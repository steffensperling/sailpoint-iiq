#!/bin/bash
#check environment variables and set some defaults
if [ -z "${MYSQL_HOST}" ]
then
	export MYSQL_HOST=db
fi
if [ -z "${MYSQL_USER}" ]
then
	export MYSQL_USER=root
fi
if [ -z "${MYSQL_PASSWORD}" ]
then
	export MYSQL_PASSWORD=secr3tPa55word
fi
#wait for database to start
echo "waiting for database on ${MYSQL_HOST} to come up"
while ! mysqladmin ping -h"${MYSQL_HOST}" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" --silent ; do
	echo -ne "."
	sleep 1
done
#check if database schema is already there
export DB_SCHEMA_VERSION=$(mysql -s -N -hdb -uroot -p${MYSQL_ROOT_PASSWORD} -e "select schema_version from identityiq.spt_database_version;")
if [ -z "$DB_SCHEMA_VERSION" ]
then
	echo "No schema present, creating IIQ schema in DB" 
	# create database schema
	mysql -uroot -p${MYSQL_ROOT_PASSWORD} -hdb < /opt/tomcat/webapps/identityiq/WEB-INF/database/create_identityiq_tables-${IIQ_VERSION}.mysql
	echo "=> Done creating database!"
else
	echo "=> Database already set up, version "$DB_SCHEMA_VERSION" found, starting IIQ directly";
fi
# set database host in properties
sed -ri -e "s/mysql:\/\/localhost/mysql:\/\/${MYSQL_HOST}/" /opt/tomcat/webapps/identityiq/WEB-INF/classes/iiq.properties
sed -ri -e "s/dataSource.username\=.*/dataSource.username=${MYSQL_USER}/" /opt/tomcat/webapps/identityiq/WEB-INF/classes/iiq.properties
sed -ri -e "s/dataSource.password\=.*/dataSource.password=${MYSQL_PASSWORD}/" /opt/tomcat/webapps/identityiq/WEB-INF/classes/iiq.properties
echo "=> Done configuring iiq.properties!"

export DB_SPADMIN_PRESENT=$(mysql -s -N -hdb -uroot -p${MYSQL_ROOT_PASSWORD} -e "select name from identityiq.spt_identity where name='spadmin';")
if [ -z $DB_SPADMIN_PRESENT ]
then
	echo "No spadmin user in database, setting up database connection in iiq.properties and importing init.xml and init-lcm.xml"
	echo "import init.xml" | /opt/tomcat/webapps/identityiq/WEB-INF/bin/iiq console
	echo "import init-lcm.xml" | /opt/tomcat/webapps/identityiq/WEB-INF/bin/iiq console
	echo "=> Done loading init.xml via iiq console!"
fi
/opt/tomcat/bin/catalina.sh run

