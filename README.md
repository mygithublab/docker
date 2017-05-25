# DOCKER
docker for nagios deployment

https://hub.docker.com/u/hsly903/

# USAGE

docker build -t nagios .

docker run -itd -P --name=nagios nagios

docker ps -a

Copy nagios_container.ppk into Putty, then set Auto-login username: root, input the map port and host IP address to login container

# NOTICE
logon account: nagiosadmin password: nagios

