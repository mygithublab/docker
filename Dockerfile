FROM centos:6.8 

MAINTAINER mygithublab (mygithublab@126.com)

RUN yum install -y \
 httpd \
 php \
 php-cli \
 gcc \
 glibc \
 glibc-common \
 gd \
 gd-devel \
 net-snmp \
 openssl-devel \
 wget \
 unzip \
 openssh-server \
 make \
 gettext \
 automake \
 net-snmp-utils \
 epel-release \
 perl-Net-SNMP \
 perl \
 automake

RUN cd /tmp && useradd nagios && usermod -a -G nagios apache \
 && wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.3.4.tar.gz \
 && wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz \
 && tar xzvf nagioscore.tar.gz && cd /tmp/nagioscore-nagios-4.3.4/ \
 && ./configure && make all && make install && make install-init \
 && chkconfig --add nagios && chkconfig --level 2345 httpd on \
 && make install-commandmode && make install-config && make install-webconf \
 && htpasswd -bc /usr/local/nagios/etc/htpasswd.users nagiosadmin nagios \
 && cd /tmp && tar zxvf nagios-plugins.tar.gz && cd /tmp/nagios-plugins-release-2.2.1/ \
 && ./tools/setup && ./configure && make && make install \
 && /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg \
 && touch /var/www/html/index.html && rm -rf /tmp/* && cat /usr/share/zoneinfo/Asia/Shanghai > /etc/localtime

#Add startup service script
ADD run.sh /run.sh
RUN chmod 755 /run.sh && mkdir -p /root/.ssh
COPY authorized_keys /root/.ssh
RUN chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys

EXPOSE 80 22  
#ENTRYPOINT ["/bin/bash","/run.sh"]

CMD ["/run.sh"]
