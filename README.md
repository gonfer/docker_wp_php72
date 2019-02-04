# Introduction #

This repository aims to serve as the basis for the development of a Wordpress project. I try to generate a standardized method for:

+ Develop locally.
+ Commit and upload changes.
+ Deploy to superior environments (Stage and Production) in a simple way.

## Wordpress Docker Container ##
To deploy the Docker environment for the Apache Server, PHP and Xdebug to develop locally:
    $ docker-compose up -d --build

# Important #
* Will map the content inside www to /var/www/html/ If the folder www doesn't exists will create a new worpdress.
* Remove the variable COMPOSE_CONVERT_WINDOWS_PATHS if you are going to use linux