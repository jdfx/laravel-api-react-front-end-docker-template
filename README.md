# laravel-api-react-front-end-docker-template

This is a starter development template for a Laravel back-end API and a react front-end SPA.

## Server

The server setup is a modified version of: https://hub.docker.com/r/shincoder/homestead

### Setting up your server
- edit /server/.env with your app name and instance ID and ports (instance ID is used so we can run many versions of this app concurrently if we want).
- cd /server and run *./up.sh -clone -composer -env -key* - this will set nginx conf, start containers, clone latest laravel, composer install and set app key etc..
- link ./code directory to your .git remote for your codebase
- add windows hosts file entry for your_server_name.local 127.0.0.1

### That's it
Our web container starts nginx, php-fpm, redis, beanstalk, npm etc.. 

### Notes
- Since the web and database containers are linked you can use ```mysql``` as  the host in your ```.env``` file with an empty password to properly connect to your database.
```
DB_HOST=mysql
DB_PORT=3306
DB_USERNAME=root
DB_PASSWORD=
```

## Client

This uses create-react-app: https://github.com/facebook/create-react-app

### Setting up your client
- add windows hosts file entry for your_client_name.local 127.0.0.1

### That's it


# TODO
- Production build scripts
- CD/CI for pushing to production
- Kibana
