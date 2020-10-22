printf "${GREEN}RUNNING DOCKER ENTRYPOINT SCRIPT: provision.mysql.sh${NC}\n"

mysql -u root -p8shXa+2xW_nrdJe7_1 -e "GRANT ALL PRIVILEGES ON *.* TO root@'%' WITH GRANT OPTION;"
mysql -u root -p8shXa+2xW_nrdJe7_1 -e "CREATE DATABASE IF NOT EXISTS laravel_api;"