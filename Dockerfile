#This dockerfile uses the ubuntu image
#Author: docker_user
#Nagios core with centos

#Base image
FROM centos:6.8 

#Maintainer information
MAINTAINER SamsonMei (mygithublab@126.com)

#Install Prerequisites Software
RUN yum install -y \
#Prerequisties for nagios core
 gcc \
 glibc \
 php-cli \
 glibc-common \
 wget \
 unzip \
 httpd \
 php \
 gd \
 gd-devel \
 perl \
#Prerequisties for nagios-plugin 
 make \
 gettext \
 automake \
 autoconf \
 openssl-devel \
 net-snmp \
 net-snmp-utils \
 epel-release \
 perl-Net-SNMP \
#Install SSH 
 openssh-server 

#Download and Install Nagios Core 4.3.4
#Create User And Group
RUN useradd nagios && usermod -a -G nagios apache && cd /tmp && \ 
#Downloading the Source of nagios core
 wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.3.4.tar.gz && \
#Downloading the Source of nagios-plugin
 wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz && \
 tar xzvf nagioscore.tar.gz && cd /tmp/nagioscore-nagios-4.3.4/ && \
#Compile
 ./configure && make all && \
#Install Binaries
 make install && \
#Install Service / Daemon
 make install-init && chkconfig --add nagios && chkconfig --level 2345 httpd on && \
#Install Command Mode
 make install-commandmode && \
#Install Configuration Files
 make install-config && \
#Install Apache Config Files
 make install-webconf && \
#Configure Firewall
#&& iptables -I INPUT -p tcp --destination-port 80 -j ACCEPT && service iptables save \
#&& ip6tables -I INPUT -p tcp --destination-port 80 -j ACCEPT && service ip6tables save \
#Create nagiosadmin User Account
 htpasswd -bc /usr/local/nagios/etc/htpasswd.users nagiosadmin nagios && \
#Navigate to tmp folder and extract nagios-plugin
 cd /tmp && tar zxvf nagios-plugins.tar.gz && cd /tmp/nagios-plugins-release-2.2.1/ && \
#Compile + Install
 ./tools/setup && ./configure && make && make install && \
#Check and test nagios configure file
 /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg && \
#Create index.html file and setup Shanghai timezone
 touch /var/www/html/index.html && rm -rf /tmp/* && cat /usr/share/zoneinfo/Asia/Shanghai > /etc/localtime

#Add startup service script
ADD run.sh /run.sh
RUN chmod 755 /run.sh && mkdir -p /root/.ssh
COPY authorized_keys /root/.ssh
RUN chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys

#Export service ports
EXPOSE 80 22  

#Export container folder
VOLUME "/mnt"

#ENTRYPOINT ["executable","/run.sh"]
CMD ["/run.sh"]
