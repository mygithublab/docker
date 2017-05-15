FROM hsly903/test:v6.9

MAINTAINER samson from dockerhub.com(mygithublab@126.com)

RUN yum install -y httpd php php-cli gcc glibc glibc-common gd gd-devel net-snmp openssl-devel wget unzip openssh-server

COPY nagios-4.1.1/ /tmp/nagios-4.1.1
COPY nagios-plugins-2.1.1/ /tmp/nagios-plugins-2.1.1

RUN useradd -mp nagios nagios && groupadd nagcmd && usermod -a -G nagcmd nagios && usermod -a -G nagcmd apache
RUN cd /tmp/nagios-4.1.1 && ./configure --with-command-group=nagcmd && make all && make install && make install-init && make install-config && make install-commandmode && make install-webconf

RUN cd /tmp/nagios-plugins-2.1.1 && ./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl && make all && make install

RUN chkconfig --add nagios && chkconfig nagios on && chkconfig httpd on
RUN /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
RUN service httpd start && service nagios start  && service sshd start

RUN htpasswd -bc /usr/local/nagios/etc/htpasswd.users nagiosadmin nagios
RUN touch /var/www/html/index.html

CMD ["/bin/bash"]

