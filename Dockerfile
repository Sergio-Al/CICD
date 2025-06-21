FROM tomcat:8.5-jdk8-alpine

# Crear archivo de usuarios para el manager
RUN echo '<?xml version="1.0" encoding="UTF-8"?>' > /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '<tomcat-users xmlns="http://tomcat.apache.org/xml"' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '              version="1.0">' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '  <role rolename="manager-gui"/>' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '  <role rolename="manager-script"/>' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '  <user username="admin" password="admin123" roles="manager-gui,manager-script"/>' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '</tomcat-users>' >> /usr/local/tomcat/conf/tomcat-users.xml

# Permitir acceso remoto al manager
RUN sed -i 's/<Valve className="org.apache.catalina.valves.RemoteAddrValve"/#<Valve className="org.apache.catalina.valves.RemoteAddrValve"/g' /usr/local/tomcat/webapps/manager/META-INF/context.xml && \
    sed -i 's/allow="127\\.\d+\\.\d+\\.\d+|::1|0:0:0:0:0:0:0:1" \/>/allow="127\\.\d+\\.\d+\\.\d+|::1|0:0:0:0:0:0:0:1" \/>#/g' /usr/local/tomcat/webapps/manager/META-INF/context.xml

ADD target/JsfDemoApp-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/
EXPOSE 8080
CMD ["catalina.sh", "run"]
