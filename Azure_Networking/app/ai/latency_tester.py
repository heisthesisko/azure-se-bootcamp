import sys, time, socket, json
def test_tcp(host, port, count=3, timeout=3.0):
    res = []
    for _ in range(count):
        s = socket.socket()
        s.settimeout(timeout)
        t0 = time.time()
        try:
            s.connect((host, port))
            s.close()
            res.append((time.time()-t0)*1000.0)
        except Exception as e:
            res.append(None)
    return res
if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python latency_tester.py <host> <port>")
        sys.exit(1)
    host, port = sys.argv[1], int(sys.argv[2])
    samples = test_tcp(host, port)
    stats = dict(
        samples=samples,
        avg_ms=sum([x for x in samples if x is not None])/max(1, len([x for x in samples if x is not None])) if any(samples) else None
    )
    print(json.dumps(stats, indent=2))
