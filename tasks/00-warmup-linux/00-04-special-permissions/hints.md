## Level 1 — Nudge
Octal prefix `2` sets the `setgid` bit on a directory (group inheritance), while octal prefix `1` sets the sticky bit (restricted deletion).

## Level 2 — Approach
Create both directories under `/srv/ex188-00-04`, set `chown root:devshare` BEFORE `chmod 2775` on `collab` (since `chown` can clear special bits on some filesystems), set `chmod 1777` on `dropoff`, and create `ready.txt`.

## Level 3 — Key Commands
```bash
sudo mkdir -p /srv/ex188-00-04/collab /srv/ex188-00-04/dropoff
sudo chown root:devshare /srv/ex188-00-04/collab
sudo chmod 2775 /srv/ex188-00-04/collab
sudo chown root:root /srv/ex188-00-04/dropoff
sudo chmod 1777 /srv/ex188-00-04/dropoff
sudo touch /srv/ex188-00-04/collab/ready.txt
```
