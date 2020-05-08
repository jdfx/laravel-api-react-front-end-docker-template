export $(egrep -v '^#' .env | xargs) # Export the vars in .env into your shell

for arg in "$@"
do
    case $arg in
        -web)
        winpty docker container exec -it ${app_name}_${instance_id}_web bash
        ;;
        -db|-database)
        winpty docker container exec -it ${app_name}_${instance_id}_database bash
        ;;
        -migrate)
        winpty docker container exec -it ${app_name}_${instance_id}_web bash -c "php artisan migrate"
        ;;
        -clear)
        winpty docker container exec -it ${app_name}_${instance_id}_web bash -c "php artisan cache:clear"
        ;;
    esac
done