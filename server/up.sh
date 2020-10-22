#!/usr/bin/env bash
printf "${GREEN}Exporting /server/.env to shell${NC}\n"
export $(egrep -v '^#' .env | xargs) # Export the vars in .env into your shell

#update nginx.conf with app name
printf "${GREEN}Updating nginx.conf with env vars${NC}\n"
sed -i "s/docker_project_name/${app_name}/g" ./provision/nginx/sites-enabled/app.conf

#printf "${GREEN}Creating shared volume${NC}\n" && docker volume create "${app_name}_laravel_logs_${instance_id}" # Create an external volume for storing shared logs
#printf "${GREEN}Creating shared volume${NC}\n" && docker volume create "${app_name}_sys_logs_${instance_id}" # Create an external volume for storing shared logs

printf "${GREEN}Running docker compose up...${NC}\n" && docker-compose up -d

for arg in "$@"; do
    case $arg in
    -cl | -clone)
        printf "${GREEN}Cloning Laravel..${NC}\n" && git clone https://github.com/laravel/laravel.git ./code
        ;;
    -ci | -composer)
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            printf "${GREEN}Running composer install..${NC}\n" && docker-compose exec web composer install
        else
            printf "${GREEN}Running composer install..${NC}\n" && winpty docker-compose exec web composer install
        fi
        ;;
    -env)
        printf "${GREEN}Renaming env.example and setting db/app names..${NC}\n" && cp ./code/.env.example ./code/.env &&
            sed -i "s/localhost/${app_name}.local/g" ./code/.env && sed -i "s/docker_project_name/${app_name}/g" ./code/.env
        ;;
    -key)
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            printf "${GREEN}Generating app key..${NC}\n" && docker-compose exec web php artisan key:generate
        else
            printf "${GREEN}Generating app key..${NC}\n" && winpty docker-compose exec web php artisan key:generate
        fi
        ;;
    -passport)
        ./exec.sh -migrate
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            docker container exec -it ${app_name}_${instance_id}_web bash -c "php artisan passport:install"
        else
            winpty docker container exec -it ${app_name}_${instance_id}_web bash -c "php artisan passport:install"
        fi
        ;;
    esac
done
