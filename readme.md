to source development enviroment variables stored in config.yaml

can be `config/load_config.sh` + one of either (`test` or `dev` or `prod`)

```commandline
config/load_config.sh test
docker-compose up
```

```commandline
cd -p ~/docker
git clone https://github.com/oracle/docker-images.git
cd OracleDatabase/SingleInstance/dockerfiles/
```

then install the device specific linux zip 
[oracle/database/downloads](https://www.oracle.com/database/technologies/oracle-database-software-downloads.html#db_free) 
(aarch linux for mac M1/M2) (86x64 linux for windows)
to directory `~/docker/docker-images/OracleDatabase/SingleInstance/dockerfiles/`

# install oracle as a zip and put it in the docker
1. cd -p ~/docker
2. git clone https://github.com/oracle/docker-images.git
3. cd OracleDatabase/SingleInstance/dockerfiles/
4. Download Oracle Database 19c Enterprise Edition or Standard Edition 2 for Linux x64 from http://www.oracle.com/technetwork/database/enterprise-edition/downloads/index.html
5. you should now have
5. to directory `~/docker/docker-images/OracleDatabase/SingleInstance/dockerfiles/19.3.0/`
6. backend should work now!
