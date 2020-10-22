printf "${GREEN}RUNNING DOCKER ENTRYPOINT SCRIPT: provision.mysql.sh${NC}\n"

mysql -u root -pchangeme -e "GRANT ALL PRIVILEGES ON *.* TO root@'%' WITH GRANT OPTION;"
mysql -u root -pchangeme -e "CREATE DATABASE IF NOT EXISTS laravel_api;"