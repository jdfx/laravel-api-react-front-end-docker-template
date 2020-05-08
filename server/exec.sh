export $(egrep -v '^#' .env | xargs) # Export the vars in .env into your shell
winpty docker container exec -it ${app_name}_${instance_id}_web bash