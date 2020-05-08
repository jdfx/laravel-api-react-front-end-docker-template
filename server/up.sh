#!/usr/bin/env bash
printf "${GREEN}Exporting /server/.env to shell${NC}\n"
export $(egrep -v '^#' .env | xargs) # Export the vars in .env into your shell

#update nginx.conf with app name
printf "${GREEN}Updating nginx.conf with env vars${NC}\n"
sed -i "s/docker_project_name/${app_name}/g" ./provision/nginx/sites-enabled/app.conf

printf "${GREEN}Running docker compose up...${NC}\n" && docker-compose up -d

for arg in "$@"
do
    case $arg in
        -cl|-clone)
        printf "${GREEN}Cloning Laravel..${NC}\n" && git clone https://github.com/laravel/laravel.git ./code 
        ;;
        -ci|-composer)
        printf "${GREEN}Running composer install..${NC}\n" && winpty docker-compose exec web composer install
        ;;
        -env)
        printf "${GREEN}Renaming env.example and setting db/app names..${NC}\n" && cp ./code/.env.example ./code/.env &&
        sed -i "s/localhost/${app_name}.local/g" ./code/.env && sed -i "s/docker_project_name/${app_name}/g" ./code/.env
        ;;
        -key)
        printf "${GREEN}Generating app key..${NC}\n" && winpty docker-compose exec web php artisan key:generate
        ;;
        -passport)
        ./exec.sh -migrate
        winpty docker container exec -it ${app_name}_${instance_id}_web bash -c "php artisan passport:install"
        ;;
    esac
done