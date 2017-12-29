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
##perl-Net-SNMP \
#Install SSH git
    openssh-server \ 
    git \
#Prerequisties for nagiosgraph
    perl-rrdtool \
    perl-GD \
    perl-CPAN \
    perl-CGI \
    perl-Time-HiRes \
#Prerequisties for SNMP Printer checking
    php-snmp \
    bc \
#Prerequisties for HP ilo2 health
    perl-XML-Simple \
    perl-IO-Socket-SSL \
##perl-Nagios-Plugin 
 && yum install -y \
    perl-Net-SNMP \
    perl-Nagios-Plugin \
 && yum clean all 
 
#Download and Install Nagios Core 4.3.4
#Install and setup Nagios::Config perl module 
RUN wget http://xrl.us/cpanm -O /usr/bin/cpanm && chmod +x /usr/bin/cpanm && cpanm Nagios::Config \
#Create User And Group
 && useradd nagios && usermod -a -G nagios apache && cd /tmp \ 
#Downloading the Source of nagios core
 && wget --no-check-certificate -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.3.4.tar.gz \
#Downloading the Source of nagiosgraph
 && wget --no-check-certificate -O nagiosgraph.tar.gz https://nchc.dl.sourceforge.net/project/nagiosgraph/nagiosgraph/1.5.2/nagiosgraph-1.5.2.tar.gz \
#Downloading the Source of nagios-plugin
 && wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz \
 && tar xzvf nagioscore.tar.gz && cd /tmp/nagioscore-nagios-4.3.4/ \
#Compile
 && ./configure && make all \
#Install Binaries
 && make install \
#Install Service / Daemon
 && make install-init && chkconfig --add nagios && chkconfig --level 2345 httpd on \
#Install Command Mode
 && make install-commandmode \
#Install Configuration Files
 && make install-config \
#Install Apache Config Files
 && make install-webconf \
#Configure Firewall
#&& iptables -I INPUT -p tcp --destination-port 80 -j ACCEPT && service iptables save \
#&& ip6tables -I INPUT -p tcp --destination-port 80 -j ACCEPT && service ip6tables save \
#Create nagiosadmin User Account
 && htpasswd -bc /usr/local/nagios/etc/htpasswd.users nagiosadmin nagios \
#Navigate to tmp folder and extract nagios-plugin
 && cd /tmp && tar zxvf nagios-plugins.tar.gz && cd /tmp/nagios-plugins-release-2.2.1/ \
#Compile + Install
 && ./tools/setup && ./configure && make && make install \
#Check and test nagios configure file
 && /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg \
#Install the Source of nagiosgraph
 && cd /tmp && tar zxvf nagiosgraph.tar.gz && cd /tmp/nagiosgraph-1.5.2 \
 && ./install.pl --install                                              \
         --prefix                   /usr/local/nagiosgraph              \
         --etc-dir                  /usr/local/nagiosgraph/etc          \
         --var-dir                  /usr/local/nagiosgraph/var          \
         --log-dir                  /usr/local/nagiosgraph/var/log      \
         --doc-dir                  /usr/local/nagiosgraph/doc          \
         --nagios-cgi-url           /nagiosgraph/cgi-bin                \
         --nagios-perfdata-file     /tmp/perfdata.log                   \
         --nagios-user              nagios                              \ 
         --www-user                 apache                              \
#        --prefix /opt/nagiosgraph                               \
#        --nagios-user nagios                                    \
#        --www-user apache                                       \
#        --nagios-perfdata-file /tmp/perfdata.log                \
#        --nagios-cgi-url /nagiosgraph/cgi-bin                && \
 && cp share/nagiosgraph.ssi /usr/local/nagios/share/ssi/common-header.ssi \
#Create index.html file and setup Shanghai timezone
 && touch /var/www/html/index.html && cat /usr/share/zoneinfo/Asia/Shanghai > /etc/localtime && rm -rf /tmp/*

#Add startup service script
ADD run.sh /run.sh
RUN chmod 755 /run.sh && mkdir -p /root/.ssh
COPY authorized_keys /root/.ssh
RUN chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys

#Add configure file to nagios server
ADD cfg/httpd/httpd.conf /etc/httpd/conf/httpd.conf
ADD cfg/nagiosgraph/etc/nagiosgraph-apache.conf /usr/local/nagiosgraph/etc/nagiosgraph-apache.conf
ADD cfg/nagios/etc/cgi.cfg /usr/local/nagios/etc/cgi.cfg
ADD cfg/nagios/etc/nagios.cfg /usr/local/nagios/etc/nagios.cfg
ADD cfg/nagios/objects/commands.cfg /usr/local/nagios/etc/objects/commands.cfg
ADD cfg/nagios/objects/templates.cfg /usr/local/nagios/etc/objects/templates.cfg
ADD cfg/nagios/objects/test.cfg /usr/local/nagios/etc/objects/test.cfg

#Add plugin to nagios server
ADD plugins/check_ilo2_health.pl /usr/local/nagios/libexec/check_ilo2_health.pl
ADD plugins/check_snmp_printer /usr/local/nagios/libexec/check_snmp_printer

#Change above file permission

RUN chmod 755 /usr/local/nagios/libexec/check_ilo2_health.pl \
 && chmod 755 /usr/local/nagios/libexec/check_snmp_printer   \
 && chown nagios.nagios /usr/local/nagios/etc/cgi.cfg        \
    /usr/local/nagios/etc/nagios.cfg                         \
    /usr/local/nagios/etc/objects/commands.cfg               \
    /usr/local/nagios/etc/objects/templates.cfg              \ 
 && chmod 664 /usr/local/nagios/etc/cgi.cfg                  \
    /usr/local/nagios/etc/nagios.cfg                         \
    /usr/local/nagios/etc/objects/commands.cfg               \
    /usr/local/nagios/etc/objects/templates.cfg              \
    /usr/local/nagios/etc/objects/test.cfg

#Export service ports
EXPOSE 80 22  

#Export container folder
VOLUME "/mnt"

#ENTRYPOINT ["executable","/run.sh"]
CMD ["/run.sh"]
