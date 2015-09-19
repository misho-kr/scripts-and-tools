Useful Docker Containers
========================

Dockerized servers, databases, web servers, etc.

Better to pull a Docker image and start a container, instead of installing a software package that clutters the server machine and to run it as regular (unrestricted) process.

* MongoDB
* MySQL
* Nginx
* Redis
* Tomcat
* Zabbix

### Usage

All Docker containers are started with [docker-compose](https://docs.docker.com/compose). Therefore the command to bring up the container is boringly repetitious:

```bash
$ docker-compose -f containers/mongo.yml up
Creating containers_mongo_1...
Pulling image mongo:2.6...
2.6: Pulling from library/mongo
ba249489d0b6: Pull complete
...
mongo26_1 | 2015-09-18T03:18:32.354+0000 [initandlisten] waiting for connections on port 27017
```
