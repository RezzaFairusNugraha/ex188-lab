## Solution
```bash
chmod 0755 /home/student/workspace/05-02/start-worker.sh
podman build -t localhost/ts-worker-0502:1.0 /home/student/workspace/05-02
podman rm -f worker-0502
podman run -d --name worker-0502 localhost/ts-worker-0502:1.0
```

## Explanation
Distinguish the two classic startup exit codes immediately on the exam:
- **`127`** = file/command **not found** (bad path, missing interpreter on `#!`, or Windows `\r` CRLF on `#!/bin/sh\r`!).
- **`126`** = file exists, **cannot execute** (missing `chmod +x` or attempting to execute a directory).

## Common Mistakes
- Confusing `126` with `127` and wasting time editing `PATH`.
