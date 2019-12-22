# !/usr/bin/env bash
# Author: Patrick Schaumburg <info@p-schaumburg.de>
# Script name: check_nginx_sites.sh

echo "---> Running nginx site check"

# 1. Check, if enabled sites is still available, else remove from sites-enabled
echo "-----> Check for removed sites and remove them from sites-enabled"

for enabledconfig in /etc/nginx/sites-enabled/*; do
  filecheck="/etc/nginx/sites-available/$(basename $enabledconfig)"
  if [ ! -e $filecheck ]; then
    echo "$(basename $enabledconfig) not found anymore in sites-available, so removing it from sites-enabled."
    rm $enabledconfig
  fi
done

echo "-----> Check for removed sites done"

# 2. Enable sites, which are not enabled right now
echo "-----> Check for new sites and add them to sites-enabled"

for availableconfig in /etc/nginx/sites-available/*; do
    filecheck="/etc/nginx/sites-enabled/$(basename $availableconfig)"
    if [ ! -f $filecheck ]; then
        echo "Found $availableconfig so adding it to sites-enabled"
        ln -s $availableconfig $filecheck
        echo "Linked $availableconfig to $filecheck"
    fi
done

echo "-----> Check for new sites done"

# this has to be done, as there is no implementation right now for disabling creation of * as sites-enabled conf
rm -rf /etc/nginx/sites-enabled/\*

echo "---> DONE nginx site check"