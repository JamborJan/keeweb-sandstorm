#!/bin/bash

# When you change this file, you must take manual action. Read this doc:
# - https://docs.sandstorm.io/en/latest/vagrant-spk/customizing/#setupsh

set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y nginx git curl

# Setup nginx config
cat > /etc/nginx/sites-available/default <<EOF
server {
    listen 8000 default_server;
    listen [::]:8000 default_server ipv6only=on;
    # Allow arbitrarily large bodies - Sandstorm can handle them, and requests
    # are authenticated already, so there's no reason for apps to add additional
    # limits by default.
    client_max_body_size 0;
    # Prevent nginx from adding compression; this interacts badly with Sandstorm
    # WebSession due to https://github.com/sandstorm-io/sandstorm/issues/289
    gzip off;
    server_name localhost;
    root /opt/app/keeweb/;
    location / {
        index index.html;
        # try_files \$uri \$uri/ =404;
    }
}
EOF
service nginx stop
systemctl disable nginx

# patch nginx conf to not bother trying to setuid, since we're not root
sed --in-place='' \
        --expression 's/^user www-data/#user www-data/' \
        --expression 's#^pid /run/nginx.pid#pid /var/run/nginx.pid#' \
        --expression 's/^\s*error_log.*/error_log stderr;/' \
        --expression 's/^\s*access_log.*/access_log off;/' \
        /etc/nginx/nginx.conf


# Go to app directory
cd /opt/app/
# Purge git repository just in case it is there
rm -rf /opt/app/keeweb
# Clone git repository
git clone https://github.com/keeweb/keeweb.git
cd /opt/app/keeweb
git checkout gh-pages

# By default, this script does nothing.  You'll have to modify it as
# appropriate for your application.
exit 0
