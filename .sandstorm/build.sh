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

# Copy demo data
# Unfortunataley the upstream build scripts
# Need the demo data in this place.
# So when running build more than once
# this will crash without copying it
rm -rf /opt/app/keeweb/app/resources
mkdir /opt/app/keeweb/app/resources
cp /opt/app/.sandstorm/Demo.kdbx /opt/app/keeweb/app/resources

# Go to app directory
cd /opt/app/keeweb/

# Install npm dependencies
#npm install grunt
#npm install electron-prebuilt
npm install
npm install grunt-cli

# Add NPM binaries for user
export PATH=/opt/app/keeweb/node_modules/grunt-cli/bin:$PATH

# Build the app with grunt
grunt

# link resources folder to writable /var/folder
rm -rf /opt/app/keeweb/app/resources
rm -rf /var/resources
ln -s /var/resources /opt/app/keeweb/app

# By default, this script does nothing.  You'll have to modify it as
# appropriate for your application.
exit 0
