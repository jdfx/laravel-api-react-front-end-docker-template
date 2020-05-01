FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

# Install packages
ADD provision.sh /provision.sh

ADD supervisor.conf /etc/supervisor/conf.d/supervisor.conf

RUN chmod +x /*.sh

RUN ./provision.sh

WORKDIR /var/www/app

EXPOSE 80 22 35729 9876
CMD ["/usr/bin/supervisord"]
