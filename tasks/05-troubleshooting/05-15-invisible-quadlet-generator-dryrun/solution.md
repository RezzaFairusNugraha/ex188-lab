## Solution
```bash
mkdir -p /home/student/.config/containers/systemd
mv /home/student/.config/systemd/user/broken-quad.container \
   /home/student/.config/containers/systemd/broken-quad.container

# Inspect exact generator errors:
/usr/lib/systemd/system-generators/podman-system-generator --user --dryrun || true

sed -i \
  -e 's/^\[Containers\]$/[Container]/' \
  -e 's/^Ports=/PublishPort=/' \
  /home/student/.config/containers/systemd/broken-quad.container

/usr/lib/systemd/system-generators/podman-system-generator --user --dryrun
systemctl --user daemon-reload
systemctl --user start broken-quad.service
```

## Explanation
Memorize `/usr/lib/systemd/system-generators/podman-system-generator --user --dryrun` (or `/usr/libexec/podman/quadlet -dryrun -user`)! Whenever `systemctl --user status foo.service` says `Unit foo.service could not be found`, running the generator dry-run prints the exact line/key that caused Quadlet generation to fail!

## Common Mistakes
- Putting `.container` files in `~/.config/systemd/user/` instead of `~/.config/containers/systemd/`!
