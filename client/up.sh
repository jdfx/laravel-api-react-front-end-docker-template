#!/usr/bin/env bash
printf "${GREEN}Exporting /server/.env to shell${NC}\n"
export $(egrep -v '^#' .env | xargs) # Export the vars in .env into your shell

printf "${GREEN}Creating react app in /code${NC}\n"
npx create-react-app code --template typescript

printf "${GREEN}Creating shared volume${NC}\n"
docker volume create "${app_name}_nodemodules_${instance_id}" # Create an external volume for storing shared node_modules

printf "${GREEN}Installing container node_modules to volume (via alpine container)${NC}\n"
docker-compose run node_modules_container # Fires up a node:alpine container, runs npm install (to the volume above, then exits)

printf "${GREEN}Running docker compose...${NC}\n"
docker-compose up # Fires up the rest of the containers, which can now access the above node-modules