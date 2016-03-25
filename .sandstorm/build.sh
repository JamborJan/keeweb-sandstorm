#!/bin/bash
set -euo pipefail
# This script is run in the VM each time you run `vagrant-spk dev`.  This is
# the ideal place to invoke anything which is normally part of your app's build
# process - transforming the code in your repository into the collection of files
# which can actually run the service in production
#
# Some examples:
#
#   * For a C/C++ application, calling
#       ./configure && make && make install
#   * For a Python application, creating a virtualenv and installing
#     app-specific package dependencies:
#       virtualenv /opt/app/env
#       /opt/app/env/bin/pip install -r /opt/app/requirements.txt
#   * Building static assets from .less or .sass, or bundle and minify JS
#   * Collecting various build artifacts or assets into a deployment-ready
#     directory structure

# We do some Sandstorm related changes
# 1st: as we are connecting inside the grain via 127.0.0.1 we cannot https
# 2nd: dropbox is by default not shown as we want to push privacy aware options
# 3rd: we don't want to have the demo always shown
sed --in-place='' \
        --expression='s/^        skipHttpsWarning: false,/        skipHttpsWarning: true,/' \
        --expression='s/^        dropbox: true,/        dropbox: false,/' \
        --expression='s/^        demoOpened: false/        demoOpened: true/' \
        /opt/app/keeweb/app/scripts/models/app-settings-model.js

# Go to app directory
cd /opt/app/keeweb/

# Install npm dependencies
# npm install grunt
npm install electron-prebuilt
npm install grunt-cli
npm install

# Add NPM binaries for user
export PATH=/opt/app/keeweb/node_modules/grunt-cli/bin:$PATH

# Build the app with grunt
grunt

# link folders and files which need to be writable
#rm -rf /opt/app/keeweb/app/resources
#rm -rf /var/resources
#ln -s /var/storage /opt/app/keeweb/app

# By default, this script does nothing.  You'll have to modify it as
# appropriate for your application.
exit 0
