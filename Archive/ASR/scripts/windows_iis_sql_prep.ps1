param(
  [ValidateSet('WebOnly','DbOnly','All')]
  [string]$Role = 'All'
)

function Install-WebRole {
  Write-Host "Installing IIS + PHP..."
  Add-WindowsFeature Web-Server, Web-CGI, Web-Asp-Net45, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-WebSockets
  $phpUri = "https://windows.php.net/downloads/releases/php-8.2.20-nts-Win32-vs16-x64.zip"
  $phpZip = "$env:TEMP\php.zip"
  Invoke-WebRequest $phpUri -OutFile $phpZip
  Expand-Archive $phpZip -DestinationPath "C:\PHP" -Force
  & $env:windir\system32\inetsrv\appcmd.exe set config -section:system.webServer/fastCgi /+"[fullPath='C:\PHP\php-cgi.exe']" /commit:apphost
  & $env:windir\system32\inetsrv\appcmd.exe set config -section:system.webServer/handlers /+"[name='PHP_via_FastCGI',path='*.php',verb='GET,HEAD,POST',modules='FastCgiModule',scriptProcessor='C:\PHP\php-cgi.exe',resourceType='File']" /commit:apphost
  Copy-Item "C:\PHP\php.ini-production" "C:\PHP\php.ini" -Force
  (Get-Content "C:\PHP\php.ini").Replace(";extension_dir = \"ext\"", "extension_dir = \"ext\"") | Set-Content "C:\PHP\php.ini"
  Write-Host "IIS + PHP installed."
}

function Install-DbRole {
  Write-Host "Installing SQL Server Express + Tools..."
  $sqlUri = "https://go.microsoft.com/fwlink/?linkid=866658"
  $sqlExe = "$env:TEMP\sqlexpress.exe"
  Invoke-WebRequest $sqlUri -OutFile $sqlExe
  Start-Process -FilePath $sqlExe -ArgumentList "/QS /ACTION=Install /FEATURES=SQLEngine /INSTANCENAME=SQLEXPRESS /IACCEPTSQLSERVERLICENSETERMS /SECURITYMODE=SQL /SAPWD='P@ssw0rd!123' /TCPENABLED=1" -Wait

  $odbcUri = "https://go.microsoft.com/fwlink/?linkid=2246799"
  $odbcMsi = "$env:TEMP\msodbcsql.msi"
  Invoke-WebRequest $odbcUri -OutFile $odbcMsi
  Start-Process msiexec.exe -ArgumentList "/i `"$odbcMsi`" /quiet IACCEPTMSODBCSQLLICENSETERMS=YES" -Wait

  $phpdrvUri = "https://github.com/microsoft/msphpsql/releases/download/v5.12.0/Windows-8.2.zip"
  $phpdrvZip = "$env:TEMP\php_sqlsrv.zip"
  Invoke-WebRequest $phpdrvUri -OutFile $phpdrvZip
  Expand-Archive $phpdrvZip -DestinationPath "$env:TEMP\php_sqlsrv" -Force
  Copy-Item "$env:TEMP\php_sqlsrv\*nts-x64\*.dll" "C:\PHP\ext\" -Force
  (Get-Content "C:\PHP\php.ini") + @("extension=php_sqlsrv.dll","extension=php_pdo_sqlsrv.dll") | Set-Content "C:\PHP\php.ini"
  Restart-Service W3SVC
  Write-Host "SQL Server Express installed and PHP SQL drivers enabled."
}

if ($Role -eq 'WebOnly' -or $Role -eq 'All') { Install-WebRole }
if ($Role -eq 'DbOnly'  -or $Role -eq 'All') { Install-DbRole }
