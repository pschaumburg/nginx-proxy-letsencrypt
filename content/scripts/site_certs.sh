# !/usr/bin/env bash
# Author: Patrick Schaumburg <info@p-schaumburg.de>
# Script name: site_certs.sh


echo "---> Running site certificate check"

enabledconfigfiles=$(ls -d /etc/nginx/sites-enabled/*)

for enabledconfig in $enabledconfigfiles; do
  domains=$(grep -rw $enabledconfig -e "server_name" | sed 's/\<server_name\>//g' | tr -d ';' | sed -r 's/[ ]+/ -d /g' | sed ':a;N;$!ba;s/\n//g')
  echo "$domains" > /tmp/subdomains
  if [ -n "$domains" ]; then
    certbot --nginx --agree-tos --noninteractive \
      --expand --redirect --reinstall \
      --webroot-path=/var/www/letsencrypt \
      --email $LETSENCRYPT_EMAIL \
      --post-hook "service nginx reload" \
      $domains
  fi
done

echo "---> Done site certificate check"
