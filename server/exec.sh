export $(egrep -v '^#' .env | xargs) # Export the vars in .env into your shell

for arg in "$@"; do
    case $arg in
    -web)
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            docker container exec -it ${app_name}_${instance_id}_web bash
        else
            winpty docker container exec -it ${app_name}_${instance_id}_web bash
        fi
        ;;
    -db | -database)
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            docker container exec -it ${app_name}_${instance_id}_database bash
        else
            winpty docker container exec -it ${app_name}_${instance_id}_database bash
        fi
        ;;
    -filebeat)
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        docker container exec -it ${app_name}_${instance_id}_filebeat bash
    else
        winpty docker container exec -it ${app_name}_${instance_id}_filebeat bash
    fi
    ;;
    -migrate)
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            docker container exec -it ${app_name}_${instance_id}_web bash -c "php artisan optimize && php artisan migrate"
        else
            winpty docker container exec -it ${app_name}_${instance_id}_web bash -c "php artisan optimize && php artisan migrate"
        fi
        ;;
    -clear)
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            docker container exec -it ${app_name}_${instance_id}_web bash -c "php artisan optimize"
        else
            winpty docker container exec -it ${app_name}_${instance_id}_web bash -c "php artisan optimize"
        fi
        ;;
    -db_refresh)
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            docker container exec -it ${app_name}_${instance_id}_web bash -c "php artisan optimize && php artisan migrate:refresh && php artisan passport:install && php artisan db:seed"
        else
            winpty docker container exec -it ${app_name}_${instance_id}_web bash -c "php artisan optimize && php artisan migrate:refresh && php artisan passport:install && php artisan db:seed"
        fi
        ;;
    esac
done
