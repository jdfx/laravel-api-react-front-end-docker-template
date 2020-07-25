# laravel-api-react-front-end-docker-template

This is a starter development template for a Laravel back-end API and a react front-end SPA.

## Server

The server setup is a modified version of: https://hub.docker.com/r/shincoder/homestead

### Setting up your server

#### If you are starting from scratch and want fresh laravel
- edit /server/.env with your app name and instance ID and ports (instance ID is used so we can run many versions of this app concurrently if we want).
- run ./first.sh
- link ./code directory to your .git repo, not laravel's (via git remote add origin ...)
- add windows hosts file entry for your_server_name.local 127.0.0.1 (or just go to localhost and the right port)

#### If you are using this docker setup for an existing server repo
- edit /server/.env with your app name and instance ID and ports (instance ID is used so we can run many versions of this app concurrently if we want).
- mkdir /server/code and clone your code into it (you can also use https://github.com/jdfx/laravel-passport-o-auth.git which is a ready to go oAuth API with login/register etc.. designed to be used with https://github.com/jdfx/react-app-auth.git)
- run ./up.sh -composer -env
- add windows hosts file entry for your_server_name.local 127.0.0.1 (or just go to localhost and the right port)

### That's it
Our web container starts nginx, php-fpm, redis, beanstalk, npm etc.. 
The database is created on the mysql container and privileges set for root user with no password - it's exposed on localhost:3306 for mysqlworkbench etc..
There are some useful commands in ./exec.sh - you will need to remove the winpty if you're not on windows/gitbash etc
If you change any of the provision files, just docker-compose build *service name* (i.e. web)

### Production
run ./build.production.sh @todo #need to finish production build scripts

## Client

Built with create react app

### Setting up your client

### If you want a fresh copy of create-react-app (TS version)
- edit /client/.env and set your ports etc
- cd /client and run ./first.sh

### If you already have a react repo you want to use
- edit /client/.env and set your ports etc
- mkdir /client/code and clone your code into it (you can also pinch https://github.com/jdfx/react-app-auth.git which is a bare-bones react app with register and login etc, designed to be used with https://github.com/jdfx/laravel-passport-o-auth.git)
- run ./up.sh -node_modules -up

The node_modules are built on their own alpine container and linked via external volume to the main app. Feel free to npm install things locally on windows for ease, just re-run ./up.sh -nm or ./up.sh -node_modules and it'll copy your local package.json and run it on the linux container. It's important the modules are built on linux not just linked via volume to your windows version.

### That's it
- your client is running on localhost on the port you specified.

# TODO
- Production build scripts
- CD/CI for pushing to production
- Kibana
- create seperate front end and back-end networks (external networks, link them via compose).
