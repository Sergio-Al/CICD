FROM tomcat:8.5-jre8

# Limpiar webapps por defecto (opcional)
RUN rm -rf /usr/local/tomcat/webapps/*

# Crear archivo de usuarios con roles necesarios
RUN echo '<?xml version="1.0" encoding="UTF-8"?>' > /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '<tomcat-users xmlns="http://tomcat.apache.org/xml"' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '              version="1.0">' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '  <role rolename="manager-gui"/>' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '  <role rolename="manager-script"/>' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '  <role rolename="admin-gui"/>' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '  <user username="admin" password="admin123" roles="manager-gui,manager-script,admin-gui"/>' >> /usr/local/tomcat/conf/tomcat-users.xml && \
    echo '</tomcat-users>' >> /usr/local/tomcat/conf/tomcat-users.xml

# Verificar que el archivo WAR existe antes de copiarlo
COPY target/JsfDemoApp-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/

# También crear una aplicación ROOT para evitar 404 en la raíz
COPY target/JsfDemoApp-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
