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

# patch keeweb conf
# sed doesnt do the job properly here yet
sed --in-place='' \
        --expression 's/^<meta name="kw-config" content="(no-config)">/<meta name="kw-config" content="config.json">/g' \
        /opt/app/keeweb/index.html

# Write Sandstorm specific config file
cat > /opt/app/keeweb/config.json <<EOF
{
    "skipHttpsWarning": true,
    "canOpen": false,
    "canOpenDemo": false,
    "canOpenSettings": false,
    "canCreate": false,
    "canImportXml": false,
    "dropbox": false,
    "webdav": false,
    "gdrive": false,
    "onedrive": false,
    "files": [{
        "storage": "webdav",
        "name": "My file",
        "path": "webdav-url",
        "options": { "user": "", "password": "" }
    }]
}
EOF

# By default, this script does nothing.  You'll have to modify it as
# appropriate for your application.
exit 0
