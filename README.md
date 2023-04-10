# Lucifer
Lucifer (the light-bringer) is an application hosting platform. Containerized
applications sit behind Traefik as a load balancer/router and applications are
orchestrated by Docker Compose.

![x](https://upload.wikimedia.org/wikipedia/commons/thumb/f/fb/Lucifer_from_Petrus_de_Plasiis_Divine_Comedy_1491.png/1082px-Lucifer_from_Petrus_de_Plasiis_Divine_Comedy_1491.png)

## ⚡ Bring the Light ⚡
1. Ensure that the docker daemon is running. `docker ps` should return a list
  of running containers.
2. Bring up the infrastructure by running `./infra-up.sh`.
3. Bring down the infrastructure by running `./infra-down.sh`. This is remove
  all containers and networks, but retain data volumes.

## Running a Certificate Authority
* [Set up a CA on macOS](traefik/certs/README.md)
* But, it's much easier to [use mkcert](traefik/certs/README-mkcert.md) for development

## Traefik
To make basic authentication credentials for access to the dashboard,
* Run `htpasswd -nb user password`
* Add to `/traefik/dynamic.yml`
  ```yaml
  users:
    - "admin:$apr1$rUVOS6P4$RCVSuqu7wgyBVoQuAtBNc."
  ```

## Update Hosts File
Update local hosts file (e.g. /etc/hosts on macOS). At the moment, these hosts
are hardcoded.

```bash
127.0.0.1	portainer.derekzoladz.com
127.0.0.1	traefik.derekzoladz.com
```