# DOCKER
docker for nagios deployment

# USAGE

docker build -t nagios_v1 .

create local folder tree as below

/nagios
├── etc
├── libexec
└── var

docker run -itd -p 3002:80 -p 3003:22 --name=nagios_centos \
    -v /nagios/etc:/usr/local/nagios/etc \
    -v /nagios/libexec:/usr/local/nagios/libexec \
    -v /nagios/var:/usr/local/nagios/var \
    nagios_v1

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
