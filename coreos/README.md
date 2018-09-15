# CoreOS Notes

Once a droplet is created, one must ssh in the follwing way:

```bash
ssh core@<droplet_ip>
```

Source: https://www.digitalocean.com/community/questions/initial-password-for-coreos

This is the only user allowed in. Everything runs in docker containers.

scp will work

once docker image is scp'd, run saved docker image on boot??
