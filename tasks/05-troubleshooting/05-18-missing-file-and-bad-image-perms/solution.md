## Solution
```bash
rm -f /home/student/workspace/05-18/.containerignore
chmod 0644 /home/student/workspace/05-18/conf/nginx.conf
podman build -t localhost/ts-portal-0518:1.0 /home/student/workspace/05-18
podman rm -f portal-0518
podman run -d --name portal-0518 -p 8518:8080 localhost/ts-portal-0518:1.0
```

## Explanation
Hidden `.containerignore` files are invisible to plain `ls` (`ls -la` reveals them!) and are a classic cause of "I wrote `COPY public/ ...` why is `index.html` missing inside the container?!"

## Common Mistakes
- Checking only `Containerfile` without running `ls -la` to spot hidden `.containerignore`!
