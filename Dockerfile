FROM tomcat:8.5-jre8-alpine

# Instalar bash (necesario en Alpine)
RUN apk add --no-cache bash

# Copiar webapps desde webapps.dist a webapps
RUN cp -r /usr/local/tomcat/webapps.dist/* /usr/local/tomcat/webapps/

# Crear directorio META-INF para manager si no existe
RUN mkdir -p /usr/local/tomcat/webapps/manager/META-INF

# Crear context.xml con configuración adecuada para el manager
RUN echo '<?xml version="1.0" encoding="UTF-8"?>' > /usr/local/tomcat/webapps/manager/META-INF/context.xml && \
    echo '<Context antiResourceLocking="false" privileged="true">' >> /usr/local/tomcat/webapps/manager/META-INF/context.xml && \
    echo '  <CookieProcessor className="org.apache.tomcat.util.http.Rfc6265CookieProcessor" sameSiteCookies="strict" />' >> /usr/local/tomcat/webapps/manager/META-INF/context.xml && \
    echo '  <Valve className="org.apache.catalina.valves.RemoteAddrValve" allow=".*" />' >> /usr/local/tomcat/webapps/manager/META-INF/context.xml && \
    echo '  <Manager sessionAttributeValueClassNameFilter="java\.lang\.(?:Boolean|Integer|Long|Number|String)|org\.apache\.catalina\.filters\.CsrfPreventionFilter\$LruCache(?:\$1)?|java\.util\.(?:Linked)?HashMap"/>' >> /usr/local/tomcat/webapps/manager/META-INF/context.xml && \
    echo '</Context>' >> /usr/local/tomcat/webapps/manager/META-INF/context.xml

# Crear archivo de usuarios para el manager
RUN echo '<?xml version="1.0" encoding="UTF-8"?>' > /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '<tomcat-users xmlns="http://tomcat.apache.org/xml"' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '              version="1.0">' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '  <role rolename="manager-gui"/>' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '  <role rolename="manager-script"/>' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '  <role rolename="manager-jmx"/>' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '  <role rolename="manager-status"/>' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '  <role rolename="admin-gui"/>' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '  <user username="admin" password="admin123" roles="manager-gui,manager-script,manager-jmx,manager-status,admin-gui"/>' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '  <user username="jenkins" password="jenkins_deploy" roles="manager-script,manager-jmx,manager-status"/>' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '</tomcat-users>' >> /usr/local/tomcat/conf/tomcat-users.xml

# Agregar tu aplicación WAR
ADD target/JsfDemoApp-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/

EXPOSE 8080
CMD ["catalina.sh", "run"]
