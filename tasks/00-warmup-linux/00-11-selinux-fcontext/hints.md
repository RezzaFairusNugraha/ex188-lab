## Level 1 — Nudge
`chcon` only changes extended attributes on disk temporarily; `semanage fcontext -a -t ...` updates the persistent policy database, and `restorecon -Rv` applies it.

## Level 2 — Approach
1. Write `SELinux Ready` to `/srv/ex188-webroot/assets/banner.txt`.
2. Check `man semanage-fcontext` (examples at the bottom!) and add `-t container_file_t '/srv/ex188-webroot(/.*)?'`.
3. Run `restorecon -Rv /srv/ex188-webroot` and verify with `ls -laZ`.

## Level 3 — Key Commands
```bash
echo 'SELinux Ready' | sudo tee /srv/ex188-webroot/assets/banner.txt
sudo semanage fcontext -a -t container_file_t '/srv/ex188-webroot(/.*)?'
sudo restorecon -Rv /srv/ex188-webroot
ls -Zd /srv/ex188-webroot /srv/ex188-webroot/assets/banner.txt
```
