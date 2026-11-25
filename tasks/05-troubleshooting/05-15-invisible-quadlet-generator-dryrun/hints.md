## Level 1 — Nudge
1) Quadlets do NOT belong in `~/.config/systemd/user/` — they belong in `~/.config/containers/systemd/`!
2) Once moved, run `/usr/lib/systemd/system-generators/podman-system-generator --user --dryrun` and read every warning line!

## Level 2 — Approach
Move `broken-quad.container` into `~/.config/containers/systemd/`, run the generator `--dryrun` (which flags `[Containers]` and `Ports=`), change them to `[Container]` and `PublishPort=8515:8080`, then `daemon-reload` and `start broken-quad.service`.

## Level 3 — Key Commands
```bash
mkdir -p ~/.config/containers/systemd
mv ~/.config/systemd/user/broken-quad.container ~/.config/containers/systemd/broken-quad.container
/usr/lib/systemd/system-generators/podman-system-generator --user --dryrun
sed -i -e 's/^\[Containers\]/[Container]/' -e 's/^Ports=/PublishPort=/' \
  ~/.config/containers/systemd/broken-quad.container
/usr/lib/systemd/system-generators/podman-system-generator --user --dryrun
systemctl --user daemon-reload
systemctl --user start broken-quad.service
```
