# DOCKER
docker for nagios deployment

# USAGE

docker build -t (IMAGE Nname:Target) .

docker run -itd -p 3000:80 -P 3001:22 --name=(CONTAINER NAME) -v localfolderPath:containerPath imageName

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
