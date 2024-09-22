# install oracle as a zip and put it in the docker

1. cd -p ~/docker
2. git clone https://github.com/oracle/docker-images.git
3. cd OracleDatabase/SingleInstance/dockerfiles/
4. Download Oracle Database 19c Enterprise Edition or Standard Edition 2 for Linux x64 from http://www.oracle.com/technetwork/database/enterprise-edition/downloads/index.html
5. you should now have a file either `LINUX.ARM64_1919000_db_home.zip` or similar.
5. move file to directory `~/docker/docker-images/OracleDatabase/SingleInstance/dockerfiles/19.3.0/`
6. backend should work now!
