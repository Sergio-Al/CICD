FROM tomcat:8.5-jdk8-alpine

# Copiar configuración personalizada
COPY tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml

# Permitir acceso remoto
RUN sed -i '/<Valve className="org.apache.catalina.valves.RemoteAddrValve"/,/<\/Valve>/d' /usr/local/tomcat/webapps/manager/META-INF/context.xml

ADD target/JsfDemoApp-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/
EXPOSE 8080
CMD ["catalina.sh", "run"]
