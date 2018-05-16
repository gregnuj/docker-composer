FROM composer:latest

LABEL MAINTAINER="Greg Junge <gregnuj@gmail.com>"

## Copy entrypoint script(s)
COPY *.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/*.sh

EXPOSE 80
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/local/bin/composer-install.sh"]
