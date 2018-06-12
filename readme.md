Use SQL derived from http://www.oracletutorial.com/oracle-sample-database/

Getting Oracle 11g XE installed to use for testing.  Let's go with the bone-head simple solution.  Docker images.

Install Docker.<br/>
Installation from the standard Ubuntu repository.<br/>
$ sudo apt install docker.io<br/>
Start Docker and ensure that starts after the reboot:<br/>
$ sudo systemctl start docker<br/>
$ sudo systemctl enable docker<br/>
Verify that we're all done.<br/>
$ docker --version<br/>
Docker version 17.03.2-ce, build f5ec1e2<br/>
<br/>
Pull the Docker image.<br/>
sudo docker pull alexeiled/docker-oracle-xe-11gb
<br/>
Run the Docker image.<br/>
sudo docker run -d -p 49160:22 -p 49161:1521 -p 49162:8080 alexeiled/docker-oracle-xe-11g<br/>
<br/>
Stop all Docker containers<br/>
sudo docker stop $(sudo docker ps -aq)<br/>
<br/>
Install utPLSQL<br/>
cd utPLSQL/source<br/>
sqlplus sys/oracle@localhost:49161/xe as sysdba @install_headless.sql<br/>
<br/>
Install utPLSQL-cli<br/>
example invocation<br/>
utplsql run system/oracle@localhost:49161:xe<br/>
<br/>
The following is not what we want.  That user and password, installed by utPLSQL @install_headless.sql will come into play someday...<br/>
utplsql run UT3/XNtxj8eEgA6X6b6f@localhost:49161:xe<br/>
<br/>
The warning of "Warning: Could not find Oracle i18n driver in classpath. Depending on the database charset utPLSQL-cli might not run properly. It is recommended you download the i18n driver from the Oracle website and copy it to the 'lib' folder of your utPLSQL-cli installation." is not satisfied with i18n.jar.  You need to download the orai18n.jar to make this work, at least for Java 8. <br/>
<br/>
Install the PLSQL code to test<br/>
cd utPLSQL-demo-project/source<br/>
install_sh<br/>
<br/>
Install the PLSQL unit tests<br/>
cd utPLSQL-demo-project/test<br/>
install_sh<br/>
<br/>
IN THIS DEMO, EVERYTHING IS CONFIGURED TO RUN FROM MAVEN!<br/><br/>
"mvn test" will do all of the docker container management, fresh oracle database, etc, liquibase database schema and data creation, utPLSQL installation, sample plSQL and plSQL unit test code, and running everything.<br/><br/>
I probably should partition out the docker things into the "clean" phase, the liquibase stuff into the "compile" phase, installation of utPLSQL and the tests into the "test" phase, and fix the "install" phase to use liquibase and attach a completely different database instance.  Proof is left to the reader.

To run Jenkins in a Docker container on port 9090:
```bash
docker run -p 9090:8080 -p 50090:50000 --name Jenkins jenkins/jenkins:lts
```
