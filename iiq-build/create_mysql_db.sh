#!/bin/bash
# create database schema
mysql -uroot -p$(MYSQL_ROOT_PASSWORD) < /opt/tomcat/webapps/identityiq/WEB-INF/database/create_identityiq_tables-7.0.mysql
echo "=> Done creating database!"
# set database host in properties
sed -ri -e "s/mysql:\/\/localhost/mysql:\/\/db/" /opt/tomcat/webapps/identityiq/WEB-INF/classes/iiq.properties
sed -ri -e "s/dataSource.username\=.*/dataSource.username=$(MYSQL_USER)/" /opt/tomcat/webapps/identityiq/WEB-INF/classes/iiq.properties
sed -ri -e "s/dataSource.password\=.*/dataSource.password=$(MYSQL_PASSWORD)/" /opt/tomcat/webapps/identityiq/WEB-INF/classes/iiq.properties

echo "=> Done configuring iiq.properties!"

