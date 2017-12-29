# DOCKER
docker for nagios deployment

# USAGE

(Assume Host IP is 192.168.1.100, host sharefolder locat in /mnt)

docker build -t nagios_v1 .

docker run -itd -p 4000:80 -p 4001:22 --name nagiosgraph -v /mnt:/mnt nagios_v1

docker ps -a

Copy nagios_container.ppk into Putty, then set Auto-login username: root, input the mapping port (4001) and host IP address (192.168.1.100) to login container

Logon Nagiosgraph http://192.168.1.100:4000/nagios

# NOTICE
logon account: nagiosadmin password: nagios

# SAVE IMAGE
docker save -o image.tar image:target

# LOAD IMAGE
docker load --input image.tar ; or docker load < image.tar

# UPLOAD IMAGE
docker push NAME[:TAG]
