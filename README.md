# DOCKER
docker for nagios deployment

# USAGE

docker build -t nagios_v1 .

docker run -itd -p 4000:80 -p 4001:22 --name nagiosgraph -v /mnt:/mnt nagios_v1

docker ps -a

Copy nagios_container.ppk into Putty, then set Auto-login username: root, input the mapping port and host IP address to login container

# NOTICE
logon account: nagiosadmin password: nagios

# SAVE IMAGE
docker save -o image.tar image:target

# LOAD IMAGE
docker load --input image.tar ; or docker load < image.tar

# UPLOAD IMAGE
docker push NAME[:TAG]
