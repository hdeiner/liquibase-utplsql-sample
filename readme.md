Use SQL derived from http://www.oracletutorial.com/oracle-sample-database/

Getting Oracle 11g XE installed to use for testing.  Let's go with the bone-head simple solution.  Docker images.

Install Docker.
Installation from the standard Ubuntu repository.
$ sudo apt install docker.io
Start Docker and ensure that starts after the reboot:
$ sudo systemctl start docker
$ sudo systemctl enable docker
Verify that we're all done.
$ docker --version
Docker version 17.03.2-ce, build f5ec1e2

Pull the Docker image.
sudo docker pull alexeiled/docker-oracle-xe-11g

Run the Docker image.
sudo docker run -d -p 49160:22 -p 49161:1521 -p 49162:8080 alexeiled/docker-oracle-xe-11g

Stop all Docker containers
sudo docker stop $(sudo docker ps -aq)

Install utPLSQL
cd utPLSQL/source
sqlplus sys/oracle@localhost:49161/xe as sysdba @install_headless.sql

Install utPLSQL-cli
example invocation
utplsql run system/oracle@localhost:49161:xe

The following is not what we want.  That user and password, installed by utPLSQL @install_headless.sql will come into play someday...
utplsql run UT3/XNtxj8eEgA6X6b6f@localhost:49161:xe

The warning of "Warning: Could not find Oracle i18n driver in classpath. Depending on the database charset utPLSQL-cli might not run properly. It is recommended you download the i18n driver from the Oracle website and copy it to the 'lib' folder of your utPLSQL-cli installation." is not satisfied with i18n.jar.  You need to download the orai18n.jar to make this work, at least for Java 8. 

Install the PLSQL code to test
cd utPLSQL-demo-project/source
install_sh

Install the PLSQL unit tests
cd utPLSQL-demo-project/test
install_sh

Run the tests
cd utPLSQL-demo-project/test
run_sh

