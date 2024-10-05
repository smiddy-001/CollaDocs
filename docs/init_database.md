# how to install oracle docker database

1. Download Oracle Database 19c Enterprise Edition or Standard Edition 2 for Linux x64 from http://www.oracle.com/technetwork/database/enterprise-edition/downloads/index.html
2. you should now have a file like: `LINUX.ARM64_1919000_db_home.zip` for mac, or similar for windows.
3. move file to directory `services/database/installation/oracledb/19.3.0`
6. `services/database/installation/oracledb/19.3.0/docker build --version 19.3.0 -e`
where:
    -e stands for enterprize edition which is required for 19.3.0 on mac