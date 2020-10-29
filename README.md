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

Prerequisties software for TCP Traffice :

(1)Carp

(2)English

(3)File::Basename

(4)Monitoring::Plugin

(5)Monitoring::Plugin::Getopt

(6)Monitoring::Plugin::Threshold

(7)Monitoring::Plugin::Range

(8)Readonly

(9)version

* SNMP of Printer

Prerequisties software for SNMP of Printer :

(1)net-snmp-utils-5.5-57.el6.x86_64

(2)net-snmp-5.5-57.el6.x86_64

(3)net-snmp-libs-5.5-57.el6.x86_64

(4)php-snmp-5.3.3-47.el6.x86_64

(5)openssl-devel-1.0.1e-48.el6_8.1.x86_64

* HP ILO (less than G8) or iLO Agentless Management (G8,G9) (HPE ProLiant Server)

Prerequisties software for HP ilo2 health : 

(1)A PERL plugin using Nagios::Plugin, IO::Socket::SSL and XML::Simple. 

Prerequisties software for iLO Agentless Management (HPE ProLiant Server) :

(1)nmap

(2)procmail

(3)curl

(4)libtdb

(5)nagios-plugins-hpeilo-1.5.1-156.9.rhel6.x86_64.rpm

(6)Login container to setup and add instance 

https://exchange.nagios.org/directory/Plugins/Network-and-Systems-Management/Others/A-Nagios-Plug-2Din-for-iLO-Agentless-Management-%28HPE-ProLiant-Server%29/details

USAGE

```sh
/usr/local/nagios/libexec/hpeilo_nagios_config
```

* Dell EMC OpenManage Plug-in for Nagios Core

Prerequisties software for Dell EMC OpenManage Plug-in

(1)perl-Socket6

(2)libwsman1

(3)openwsman-perl

(4)net-snmp-perl

(5)snmptt

(6)Perl Net-IP Module

(7)Dell RACADM

(8)java-1.8.0-openjdk

(9)java-1.8.0-openjdk-devel

USAGE

```sh
/usr/local/nagios/dell/scripts/dell_device_discovery.pl -h
```

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

Update later...
