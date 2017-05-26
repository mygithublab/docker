FROM hsly903/test:v6.9

MAINTAINER mygithublab (mygithublab@126.com)

RUN yum install -y httpd php php-cli gcc glibc glibc-common gd gd-devel net-snmp openssl-devel wget unzip openssh-server xinetd

#Add startup service script
ADD run.sh /run.sh
RUN chmod 755 /run.sh

#Add authorized_keys into .ssh folder
RUN mkdir -p /root/.ssh
COPY authorized_keys /root/.ssh
RUN chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys

#Create sharefolder in container
RUN mkdir /share

#Copy nagios installation packages into container
COPY nagios-4.1.1/ /tmp/nagios-4.1.1
COPY nagios-plugins-2.1.1/ /tmp/nagios-plugins-2.1.1

#Nagios installation
RUN useradd -mp nagios nagios && groupadd nagcmd && usermod -a -G nagcmd nagios && usermod -a -G nagcmd apache
RUN cd /tmp/nagios-4.1.1 && ./configure --with-command-group=nagcmd && make all && make install && make install-init && make install-config && make install-commandmode && make install-webconf
RUN cd /tmp/nagios-plugins-2.1.1 && ./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl && make all && make install

RUN chkconfig --add nagios && chkconfig nagios on && chkconfig httpd on && chkconfig sshd on
RUN htpasswd -bc /usr/local/nagios/etc/htpasswd.users nagiosadmin nagios
RUN /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg

RUN touch /var/www/html/index.html

#Install NRPE
COPY sharefolder/nrpe-3.1.0 /tmp/nrpe-3.1.0 

#On Monitoring Host Setup, monitor itself.
RUN cd /tmp/nrpe-3.1.0 && ./configure && make all && make install && make install-config && make check_nrpe && make install-plugin && echo "nrpe 5666/tcp #nrpe">>/etc/services && make install-inetd && chkconfig xinetd on && chkconfig nrpe on

#On Monitoring Host Setup, not monitor itself
#RUN cd /tmp/nrpe-3.1.0 && ./configure && make check_nrpe && make install-plugin


EXPOSE 80 22  
#ENTRYPOINT ["/bin/bash","/run.sh"]

CMD ["/run.sh"]
