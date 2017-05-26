#!/bin/bash
/etc/init.d/sshd start && /etc/init.d/nagios start && /etc/init.d/httpd start && /sbin/service xinetd restart && /bin/bash

