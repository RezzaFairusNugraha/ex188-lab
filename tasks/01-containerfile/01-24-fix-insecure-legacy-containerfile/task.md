# Task 01-24: Refactoring a Broken, Bloated, Root-Running Legacy Containerfile

## Scenario
Inspect `/home/student/workspace/01-24/Containerfile`. It suffers from six classic defects:
1. Runs as `root` (`USER` never set).
2. Uses 4 separate `RUN` layers without cleaning `dnf` metadata.
3. Hard-codes `ENV APP_SECRET=HardcodedBadSecret!` directly in the image.
4. Sets wrong `WORKDIR /tmp/wrongdir` so relative path lookups fail.
5. Leaves `/var/lib/webapp/data` owned by `root:root`, blocking non-root writes.
6. Uses shell-form `CMD python3 app.py`.

## Requirements
1. Fix `/home/student/workspace/01-24/Containerfile` so it:
   - Consolidates package installation, directory creation, ownership (`1001:0` + `g=u`), and `dnf clean all` into **a single `RUN` instruction**.
   - Removes the hard-coded `APP_SECRET` from the `Containerfile` completely.
   - Sets `WORKDIR /opt/webapp`, copies `app.py` and `requirements.txt` into `/opt/webapp/`, sets `USER 1001`, and uses exec-form `CMD ["python3", "/opt/webapp/app.py"]`.
2. Build `localhost/webapp-remediated:2.0`.
3. Create Podman secret `remediated_secret` (`printf 'SafeRuntimeSecret77' | podman secret create remediated_secret -`) and run detached container `webapp-clean` on `-p 8124:8080 -e APP_ENV=production -e REQUIRE_SECRET=1 --secret remediated_secret,target=/run/secrets/webapp_secret`.
