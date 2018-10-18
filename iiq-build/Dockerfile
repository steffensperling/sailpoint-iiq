FROM debian:jessie

MAINTAINER Steffen Sperling <steffen.sperling@ventum.com>

ENV TOMCAT_VERSION 8.5.34
ENV IIQ_VERSION 7.3

# Fix sh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install dependencies
RUN apt-get update && \
apt-get install -y apt-utils wget unzip tar mysql-client

# Install JDK 8
RUN \
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list && \
echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list && \
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 && \
apt-get update && \
apt-get install -y oracle-java8-installer || true && \
sed -i 's|J_DIR=jdk1.8.0_181|J_DIR=jdk1.8.0_191|' /var/lib/dpkg/info/oracle* && \
sed -i 's|SHA256SUM_TGZ="1845567095bfbfebd42ed0d09397939796d05456290fb20a83c476ba09f991d3"|SHA256SUM_TGZ="53c29507e2405a7ffdbba627e6d64856089b094867479edc5ede4105c1da0d65"|' /var/lib/dpkg/info/oracle* && \
sed -i 's|PARTNER_URL=http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1|PARTNER_URL=http://download.oracle.com/otn-pub/java/jdk/8u191-b12/2787e4a523244c269598db4e85c51e0c|'  /var/lib/dpkg/info/oracle* && \
sed -i 's|JAVA_VERSION=8u181|JAVA_VERSION=8u191|'  /var/lib/dpkg/info/oracle* && \
apt-get install -y oracle-java8-installer && \
rm -rf /var/lib/apt/lists/* && \
rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Get Tomcat
RUN wget --quiet --no-cookies http://www-eu.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/tomcat.tgz && \
tar xzvf /tmp/tomcat.tgz -C /opt && \
mv /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat && \
rm /tmp/tomcat.tgz && \
rm -rf /opt/tomcat/webapps/examples && \
rm -rf /opt/tomcat/webapps/docs && \
rm -rf /opt/tomcat/webapps/ROOT

# Add admin/admin user
ADD tomcat-users.xml /opt/tomcat/conf/
run mkdir -p /opt/tomcat/conf/Catalina/localhost
ADD manager.xml /opt/tomcat/conf/Catalina/localhost
# add IIQ
COPY src/identityiq-${IIQ_VERSION}.zip /tmp
RUN unzip /tmp/identityiq-${IIQ_VERSION}.zip identityiq.war && \
mkdir /opt/tomcat/webapps/identityiq && \
unzip identityiq.war -d /opt/tomcat/webapps/identityiq && \
chmod +x /opt/tomcat/webapps/identityiq/WEB-INF/bin/iiq && \
rm identityiq.war

RUN mkdir /opt/tomcat/webapps/ROOT
COPY index.html /opt/tomcat/webapps/ROOT

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV CATALINA_HOME /opt/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin

EXPOSE 8080
EXPOSE 8009
VOLUME "/opt/tomcat/webapps"
WORKDIR /opt/tomcat

# Launch IIQ
CMD ["/entrypoint.sh", "run"]
#CMD ["/opt/tomcat/bin/catalina.sh", "run"]
