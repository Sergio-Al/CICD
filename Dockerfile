FROM tomcat:8.5-jre8

# Crear estructura básica del manager
RUN mkdir -p /usr/local/tomcat/webapps/manager/META-INF && \
    mkdir -p /usr/local/tomcat/webapps/manager/WEB-INF

# Crear context.xml simplificado
RUN echo '<?xml version="1.0" encoding="UTF-8"?>' > /usr/local/tomcat/webapps/manager/META-INF/context.xml && \
    echo '<Context antiResourceLocking="false" privileged="true">' >> /usr/local/tomcat/webapps/manager/META-INF/context.xml && \
    echo '  <Valve className="org.apache.catalina.valves.RemoteAddrValve" allow=".*" />' >> /usr/local/tomcat/webapps/manager/META-INF/context.xml && \
    echo '</Context>' >> /usr/local/tomcat/webapps/manager/META-INF/context.xml

# Crear archivo de usuarios
RUN echo '<?xml version="1.0" encoding="UTF-8"?>' > /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '<tomcat-users xmlns="http://tomcat.apache.org/xml"' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '              version="1.0">' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '  <role rolename="manager-gui"/>' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '  <role rolename="manager-script"/>' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '  <user username="admin" password="admin123" roles="manager-gui,manager-script"/>' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '</tomcat-users>' >> /usr/local/tomcat/conf/tomcat-users.xml

# Agregar tu aplicación WAR
ADD target/JsfDemoApp-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/

EXPOSE 8080
CMD ["catalina.sh", "run"]
