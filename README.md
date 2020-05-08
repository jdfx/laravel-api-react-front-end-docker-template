# laravel-api-react-front-end-docker-template

This is a starter development template for a Laravel back-end API and a react front-end SPA.

## Server

The server setup is a modified version of: https://hub.docker.com/r/shincoder/homestead

### Setting up your server
- edit /server/.env with your app name and instance ID and ports (instance ID is used so we can run many versions of this app concurrently if we want).
- run ./first.sh
- link ./code directory to your .git remote for your codebase
- add windows hosts file entry for your_server_name.local 127.0.0.1

### That's it
Our web container starts nginx, php-fpm, redis, beanstalk, npm etc.. 
The database is created on the mysql container and privileges set for root user with no password - it's exposed on localhost:3306 for mysqlworkbench etc..

### Production
run ./build.production.sh @todo

## Client

This uses create-react-app: https://github.com/facebook/create-react-app

### Setting up your client
- set your ports etc in /client/.env
- cd /client and run *./up.sh -create -node_modules -up*

### That's it
- your client is running

# TODO
- automate mysql user setup and passwords etc... (blank for dev)
- Production build scripts
- CD/CI for pushing to production
- Kibana
- create seperate front end and back-end networks (external networks, link them via compose).
