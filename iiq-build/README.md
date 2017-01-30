Sailpoint Identity IQ Dockerized
================================
# Prerequisites

Please note that Identity IQ is closed source so you first need to get a license for Idenity IQ and go to https://community.sailpoint.com/ to download the software. You will put the downloaded identityiq-x.y.zip into the build/src/ directory to get started.
I provide a dummy file for demo purposes.

# Description
Debian Jessie, Oracle JDK 8 and Tomcat 8 based docker container.
Inspired by dodorka/tomcat

Container will run in background, IIQ will be run from mounted volume. 

Includes:

 - Oracle JDK 1.8.101
 - Tomcat 8.5.9
 - Git, wget, curl, build-essential
 - mariadb database
 
## Docker
Get started with docker for Windows here: https://docs.docker.com/engine/installation/windows/
## Volumes
Exports a volume on `/opt/tomcat/webapps` (if you use this, you need to expand your identityiq.war manually to that directory.
You can mount the volume on startup to a local directory containing your war file or exploded war directory.

## Ports
Two ports are exposed:

 - 8080: default Tomcat port.
 - 8009: default Tomcat debug port.

Remember to map the ports to the docker host with "docker run" or in docker-compose.yml.


# How to run the container
## Using docker compose
Build with:
```
docker-compose build
```
Please do not upload this docker container to a public docker registry: Sailpoint IIQ is closed source and not publicly available.

If you have `docker-compose` installed, you can just launch:

```
sudo docker-compose up
```

# Usage
## Login
Go to http://localhost:8080/identityiq. 
User: spadmin
Password: admin

## A warning regarding admin user for tomcat management console
Please note that the image contains a `tomcat-users.xml` file, including an `admin` user (password `admin`). For the time being, should you wish to change that, fork this repo and modify the xml file accordingly.

