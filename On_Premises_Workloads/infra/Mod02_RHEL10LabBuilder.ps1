#requires -Modules Hyper-V
<#
.SYNOPSIS
    Creates six Hyper-V VMs (Gen 2) for a Linux lab using specified ISOs, connects them to a switch, and auto-starts each VM.

.DESCRIPTION
    - Creates six Generation 2 VMs with 2 vCPU, 2GB RAM, and a thin-provisioned 60GB OS disk.
    - Attaches the appropriate ISO as a DVD and sets it as the first boot device.
    - Connects all VMs to the existing Hyper-V switch 'AzureS2S'.
    - Auto-starts each VM after creation.
    - Logs each VM creation/start and a final success message to C:\LinuxLab\Logs\...log.
    - Run PowerShell as Administrator.
#>

# ---------------------------
# User-configurable variables
# ---------------------------
$RhelIsoPath   = 'C:\LinuxLab\RHEL10.iso'
$CentOsIsoPath = 'C:\LinuxLab\CentOS-Stream-10.iso'
$VmRoot        = 'C:\LinuxLab\VMFiles'
$SwitchName    = 'AzureS2S'

# VM specs: name + ISO path
$VmSpecs = @(
    @{ Name = 'RHEL10-Apache';       Iso = $RhelIsoPath },
    @{ Name = 'RHEL10-SQL';          Iso = $RhelIsoPath },
    @{ Name = 'RHEL10-FileServer';   Iso = $RhelIsoPath },
    @{ Name = 'RHEL10-AI-Model';     Iso = $RhelIsoPath },
    @{ Name = 'RHEL10-PostGreSQL';   Iso = $RhelIsoPath },
    @{ Name = 'CentOSStream-VyOS';   Iso = $CentOsIsoPath }
)

$DiskSizeBytes = 60GB   # thin-provisioned VHDX
$MemoryBytes   = 2GB
$VcpuCount     = 2

# --------------
# Logging helper
# --------------
function Write-Log {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$EventTimeStamp,  # destination log *file path*
        [Parameter(Mandatory=$true)]
        [string]$Comment
    )
    try {
        $ts = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
        $line = "{0}`t{1}" -f $ts, $Comment
        Add-Content -Path $EventTimeStamp -Value $line -Encoding UTF8
    } catch {
        Write-Warning "Failed to write to log '$EventTimeStamp': $($_.Exception.Message)"
    }
}

# --------------------------
# Environment / pre-checks
# --------------------------
try {
    Import-Module Hyper-V -ErrorAction Stop
} catch {
    Write-Error "Hyper-V PowerShell module not available. Enable Hyper-V and run as Administrator. Error: $($_.Exception.Message)"
    exit 1
}

# Verify ISOs used by this run exist
$isosInUse = $VmSpecs.Iso | Select-Object -Unique
foreach ($iso in $isosInUse) {
    if (-not (Test-Path -LiteralPath $iso)) {
        Write-Error "ISO not found: '$iso'. Ensure the file exists and try again."
        exit 1
    }
}

# Verify target switch exists
$hvSwitch = Get-VMSwitch -Name $SwitchName -ErrorAction SilentlyContinue
if (-not $hvSwitch) {
    Write-Error "Hyper-V switch '$SwitchName' was not found. Create it or update `$SwitchName."
    exit 1
}

# Ensure folders exist
$null = New-Item -ItemType Directory -Path $VmRoot -Force -ErrorAction SilentlyContinue
$LogDir = 'C:\LinuxLab\Logs'
$null = New-Item -ItemType Directory -Path $LogDir -Force -ErrorAction SilentlyContinue

# Log file
$logFilePath = Join-Path $LogDir ("HyperV-Create-RHEL-Based-VMs_{0}.log" -f (Get-Date -Format 'yyyyMMdd_HHmmss'))
"Timestamp`tEvent" | Out-File -FilePath $logFilePath -Encoding UTF8

# --------------------------
# VM creation loop
# --------------------------
foreach ($spec in $VmSpecs) {
    $name = $spec.Name
    $iso  = $spec.Iso

    try {
        # Paths
        $vmPath  = Join-Path $VmRoot $name
        $vhdPath = Join-Path $vmPath "$name-OS.vhdx"

        # Guard: existing VM
        if (Get-VM -Name $name -ErrorAction SilentlyContinue) {
            throw "A VM named '$name' already exists."
        }

        # Create VM folder and VHDX (dynamic = thin provisioned)
        $null = New-Item -ItemType Directory -Path $vmPath -Force -ErrorAction SilentlyContinue
        New-VHD -Path $vhdPath -SizeBytes $DiskSizeBytes -Dynamic | Out-Null

        # Create VM (Gen 2), attach NIC to the specified switch, set RAM/CPU
        New-VM -Name $name -Generation 2 -MemoryStartupBytes $MemoryBytes -VHDPath $vhdPath -Path $vmPath -SwitchName $SwitchName | Out-Null
        Set-VMProcessor -VMName $name -Count $VcpuCount

        # Attach ISO and set DVD as first boot device; enable Secure Boot (Linux template)
        if (Get-VMDvdDrive -VMName $name -ErrorAction SilentlyContinue) {
            Set-VMDvdDrive -VMName $name -Path $iso | Out-Null
        } else {
            Add-VMDvdDrive -VMName $name -Path $iso | Out-Null
        }
        $dvd = Get-VMDvdDrive -VMName $name
        Set-VMFirmware -VMName $name -EnableSecureBoot On -SecureBootTemplate 'MicrosoftUEFICertificateAuthority' -FirstBootDevice $dvd

        # Per-VM create log
        $perVmMsg = "VM '$name' created successfully (ISO: $([System.IO.Path]::GetFileName($iso)), Switch: $SwitchName)."
        Write-Output $perVmMsg
        $Comment = $perVmMsg
        Write-Log -EventTimeStamp $logFilePath -Comment $Comment

        # Start the VM and log
        try {
            Start-VM -Name $name -ErrorAction Stop | Out-Null
            $startMsg = "VM '$name' started successfully."
            Write-Output $startMsg
            $Comment = $startMsg
            Write-Log -EventTimeStamp $logFilePath -Comment $Comment
        } catch {
            $startErr = "Failed to start VM '$name': $($_.Exception.Message)"
            Write-Error $startErr
            Write-Log -EventTimeStamp $logFilePath -Comment $startErr
        }
    }
    catch {
        $err = "Failed to create VM '$name': $($_.Exception.Message)"
        Write-Error $err
        Write-Log -EventTimeStamp $logFilePath -Comment $err
    }
}

# Final overall message using the exact provided text
Write-Output "All VMs have been created successfully."
$Comment = "All VMs have been created successfully."
Write-Log -EventTimeStamp $logFilePath -Comment $Comment

Write-Host "Log written to: $logFilePath"