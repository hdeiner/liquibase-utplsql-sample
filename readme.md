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
