# Unifi-Video

[![Docker Build Status](https://img.shields.io/docker/build/exsilium/unifi-video.svg)](https://hub.docker.com/r/exsilium/unifi-video/)
[![Docker Automated build](https://img.shields.io/docker/automated/exsilium/unifi-video.svg)](https://hub.docker.com/r/exsilium/unifi-video/)
[![Docker Pulls](https://img.shields.io/docker/pulls/exsilium/unifi-video.svg)](https://hub.docker.com/r/exsilium/unifi-video/)
[![Docker Stars](https://img.shields.io/docker/stars/exsilium/unifi-video.svg)](https://hub.docker.com/r/exsilium/unifi-video/)

## Instructions for use

### Getting docker

- Download Docker from [here](https://www.docker.com/products/docker#/mac); Install by dragging app to /Applications
- (Optional) Right click on the whale in the top menu bar and select “**Open Kitematic**”, follow the download link and install the app to /Applications

### Unifi-Video installation

Because /usr/local is reserved for Docker, the example demonstrates installation of Unifi Video in a manner where the Host Data Volume directories are located in `~/Applications/unifi-video`. You can change this to your liking.

**NB!** If you receive permission errors when executing commands, precede them with `sudo`

- Create the `~/Applications/unifi-video` directory
- Run in Terminal: `docker pull exsilium/unifi-video:v3.10.2`

```
`$ docker images
REPOSITORY             TAG                 IMAGE ID            CREATED             SIZE
exsilium/unifi-video   v3.10.2            1cbeb1e369da        44 minutes ago      869.9 MB
```

- (Optional) Download\Save `run.sh` from [here](https://raw.githubusercontent.com/exsilium/docker-unifi-video/v3.10.2/run.sh)
- Create the following host data directories under `~/Applications/unifi-video`
    - `mkdir mongodb`
    - `mkdir unifi-video`
    - `mkdir log`
- Review and edit `run.sh` to make sure the BASEDIR and IP are reflecting your setup. The default 0.0.0.0 binds the ports to all interfaces.
- Execute `./run.sh` to run the container or execute `docker run` with the appropriate parameters.

```
`Checking for Host data volumes: MongoDB-OK | Unifi-Video-OK | Log-OK
16eeb080627ac648804fd0f9e64dd4569680137989d46c388ea74afb59480440
```

- You should be able to open the Unifi Video setup wizard using Chrome on `https://<yourIP>:7443`

### Camera provisioning

By default, Docker provides network isolation and due to that the automatic discovery will not work. Directly access your camera IP and enter the host IP of your server where the unifi-video docker image is running.

## Upgrade from 3.9.12 to 3.10.2

With the 3.10.x images, there has been some significant changes to underlying OS version and the bundled MongoDB version - this makes in place upgrade more challenging.

**NB!** Really, make a backup!
**NB!** MongoDB will be upgraded from 2.6 to 3.6
**NB!** Make sure you are on v3.9.12

- Use the Unifi-Video web interface to launch an upgrade, this upgrade will not finish successfully, but will upgrade the database collections to the new `v3.10.2` format
- Login to the docker container and make a `mongodump` of the `av` database. E.g: `mongodump --port 7441 -d av -o /var/lib/unifi-video/db.backup`
- Shutdown the Docker container
- Delete the requivalent of `/var/lib/unifi-video/db/*` from the Host volume
- Start the version v3.10.2 container
- Upon start a new set of collections will be populated (similar to a new installation). Relogin to the container to import the previously created dump: `mongorestore --drop --port 7441 -d av /var/lib/unifi-video/db.backup/av`
- Restart the container.

## Upgrade from 3.x.x to 3.9.12

**NB!** Always create a backup before trying to upgrade!
**NB!** Upgrade scenarios over multiple versions have not been tested!
**NB!** Make sure to read release notes prior to upgrade!
**NB!** Note that, when upgrading to v3.10.2 from previous minor version, you first need to upgrade to v3.9.12.

- Stop the running container
- Backup your Host Data Volumes (`~/Applications/unifi-video`)
- Pull the latest image `docker pull exsilium/unifi-video:v3.9.12`
- Rename the old container to something else than `unifi-video`. Refer to [docker rename](https://docs.docker.com/engine/reference/commandline/rename/) command
- Update the `run.sh` to reflect the new version (v3.9.12)
- Start the new image against the same Host Data Volumes by using `run.sh` or manually calling `docker run` with appropriate arguments.

## Need help?

If you have questions, comments, concerns. Did you find something not working or if you just need help, please [file a Github Issue](https://github.com/exsilium/docker-unifi-video/issues) and I'll do my best to help you.

Please don't use Docker Hub comments section for reaching out!
