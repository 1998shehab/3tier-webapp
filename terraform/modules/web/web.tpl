#!/bin/bash

sed -i "s/localhost/${app_dnsname}/g" /etc/httpd/conf/httpd.conf