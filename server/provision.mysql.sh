#!/usr/bin/env bash


printf "${GREEN}Exporting /server/.env to shell${NC}\n"
export $(egrep -v '^#' .env | xargs) # Export the vars in .env into your shell

./exec -migrate #migrate database tables
./exec -passport #install passport
./exec -clear #clear laravel web cache