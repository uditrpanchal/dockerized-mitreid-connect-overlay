
FROM ubuntu:16.04
LABEL maintainer "<Udit Panchal udit.panchal@gmail.com>"

RUN mkdir /usr/local/java && \
    apt-get update && \
    apt-get install -y curl wget && \
    apt-get install -y vim

COPY jdk-8u181-linux-x64.tar.gz /usr/local/java
RUN cd /usr/local/java && tar -xzf jdk-8u181-linux-x64.tar.gz && rm jdk-8u181-linux-x64.tar.gz
ENV JAVA_HOME /usr/local/java/jdk1.8.0_181 
ENV PATH ${JAVA_HOME}/bin:${PATH}

RUN mkdir /usr/local/maven && \
    cd /usr/local/maven && \	
    wget http://apache.forsale.plus/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz && \
    tar -xzf apache-maven-3.5.4-bin.tar.gz && \
    mv apache-maven-3.5.4 apache-maven && \
    rm apache-maven-3.5.4-bin.tar.gz

ENV M2_HOME /usr/local/maven/apache-maven 
ENV PATH ${M2_HOME}/bin:${PATH}

RUN cd /usr/local/ && \
    wget http://mirror.its.dal.ca/apache/tomcat/tomcat-9/v9.0.10/bin/apache-tomcat-9.0.10.tar.gz && \
    tar -zxf apache-tomcat-9.0.10.tar.gz && \
    mv apache-tomcat-9.0.10 tomcat && \
    rm apache-tomcat-9.0.10.tar.gz

ENV CATALINA_HOME /usr/local/tomcat 
ENV CATALINA_BASE /usr/local/tomcat 
ENV CATALINA_TMPDIR /usr/local/tomcat/temp 
ENV JRE_HOME /usr/local/java/jdk1.8.0_181 
ENV CLASSPATH /usr/local/tomcat/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar

COPY docker-openid-connect-overlay /usr/local/docker-openid-connect-overlay
RUN cd /usr/local/docker-openid-connect-overlay && \
    mvn package

EXPOSE 8005
EXPOSE 8080


CMD ["/bin/bash","-c","/usr/local/tomcat/bin/version.sh"]
