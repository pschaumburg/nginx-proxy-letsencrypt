# !/usr/bin/env bash
# Author: Patrick Schaumburg <info@p-schaumburg.de>
# Script name: entrypoint.sh

# Check requirements
if [ "$LETSENCRYPT_EMAIL" == "none" ]; then echo "Please enter environment variable LETSENCRYPT_EMAIL"; exit; fi

# run
nginx
bash /nginx_sites.sh
bash /site_certs.sh

# logs
tail -f /var/log/nginx/error.log /var/log/cron.log /var/log/letsencrypt/letsencrypt.log
