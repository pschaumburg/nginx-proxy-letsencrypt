FROM debian:buster
LABEL maintainer="Patrick Schaumburg <info@p-schaumburg.de>"

# Install necessary packages (certbot, nginx, and cron)
# @TODO: Check, if cron is really needed, as it is a standard system package!!!!!
RUN apt update && apt install -y apt-utils && apt install -y nginx dnsmasq python-certbot-nginx

# Copy files
COPY content/nginx-config/ /etc/nginx/
COPY content/scripts/ /
COPY content/cron.d /etc/cron.d/

# Create dirs
RUN mkdir -p /var/www/letsencrypt
# RUN mkdir -p /etc/nginx/sites-enabled

# RUN touch /var/log/cron.log
RUN rm -rf /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default

# Volumes
VOLUME /etc/nginx/sites-available
VOLUME /etc/letsencrypt

# Environment variables
ENV LETSENCRYPT_EMAIL none
# ENV CERTBOT_CRON "0 */12 * * *"
# ENV NGINX_CRON "*/5 * * * *"

# Ports
EXPOSE 80
EXPOSE 443

# Command
CMD ["bash", "entrypoint.sh" ]
