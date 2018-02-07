# DOCKER
Docker for nagios deployment

Build Status: [![Build Status](https://travis-ci.org/mygithublab/docker.svg?branch=master)](https://travis-ci.org/mygithublab/docker)

Nagios Core 4.3.4 with Nagiosgraph

### USAGE

(Assume Host IP is 192.168.1.100, host sharefolder locate in /mnt)

```sh
docker build -t nagios .
```

```sh
docker run -itd -p 4000:80 -p 4001:22 --name nagiosgraph -v /mnt:/mnt nagios
```

```sh
docker ps -a
```

Copy nagios_container.ppk into Putty, then set Auto-login username: root, input the mapping port (4001) and host IP address (192.168.1.100) to login container

Logon Nagiosgraph http://192.168.1.100:4000/nagios

After you login nagios container, you may edit file test.cfg under /usr/local/nagios/etc/objects to customized following function

* NRPE

* TCP Traffice
** Prerequisties software for TCP Traffice :
*** Carp
*** English
*** File::Basename
*** Monitoring::Plugin
*** Monitoring::Plugin::Getopt
*** Monitoring::Plugin::Threshold
*** Monitoring::Plugin::Range
*** Readonly
*** version

* SNMP of Printer
** Prerequisties software for SNMP of Printer :
*** net-snmp-utils-5.5-57.el6.x86_64
*** net-snmp-5.5-57.el6.x86_64
*** net-snmp-libs-5.5-57.el6.x86_64
*** php-snmp-5.3.3-47.el6.x86_64
*** php-snmp-5.3.3-47.el6.x86_64
*** openssl-devel-1.0.1e-48.el6_8.1.x86_64

* HP ILO
** Prerequisties software for HP ilo2 health : 
*** A PERL plugin using Nagios::Plugin, IO::Socket::SSL and XML::Simple. 

### NOTICE
logon account: nagiosadmin password: nagios

### SAVE IMAGE
```sh
docker save -o image.tar image:target
```

### LOAD IMAGE
```sh
docker load --input image.tar ; or docker load < image.tar
```

### UPLOAD IMAGE
```sh
docker push NAME[:TAG]
```

### RUNNING IN SWARM
```sh
docker service create --name nagios --mount type=bind,src=/mnt,dst=/mnt -p 5000:80 -p 5001:22 -t --replicas 6 hsly903/nagios:latest
```
