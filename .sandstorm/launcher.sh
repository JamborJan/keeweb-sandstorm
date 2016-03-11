#!/bin/bash
set -euo pipefail
# This script is run every time an instance of our app - aka grain - starts up.
# This is the entry point for your application both when a grain is first launched
# and when a grain resumes after being previously shut down.
#
# This script is responsible for launching everything your app needs to run.  The
# thing it should do *last* is:
#
#   * Start a process in the foreground listening on port 8000 for HTTP requests.
#
# This is how you indicate to the platform that your application is up and
# ready to receive requests.  Often, this will be something like nginx serving
# static files and reverse proxying for some other dynamic backend service.
#
# Other things you probably want to do in this script include:
#
#   * Building folder structures in /var.  /var is the only non-tmpfs folder
#     mounted read-write in the sandbox, and when a grain is first launched, it
#     will start out empty.  It will persist between runs of the same grain, but
#     be unique per app instance.  That is, two instances of the same app have
#     separate instances of /var.
#   * Preparing a database and running migrations.  As your package changes
#     over time and you release updates, you will need to deal with migrating
#     data from previous schema versions to new ones, since users should not have
#     to think about such things.
#   * Launching other daemons your app needs (e.g. mysqld, redis-server, etc.)

# Create a bunch of folders under the clean /var that nginx expects to exist
mkdir -p /var/lib/nginx
mkdir -p /var/log
mkdir -p /var/log/nginx

# Wipe /var/run, since pidfiles and socket files from previous launches should go away
# TODO someday: I'd prefer a tmpfs for these.
rm -rf /var/run
mkdir -p /var/run

# create resources folder to writable /var/folder
mkdir -p /var/resources
# Copy demo data
cp /opt/app/.sandstorm/Demo.kdbx /var/resources

# Cleanup log files
FILES="$(find /var/log -name '*.log')"
for f in $FILES
do
  tail $f | tee $f
done

# Start nginx.
/usr/sbin/nginx -g "daemon off;"

# By default, this script does nothing.  You'll have to modify it as
# appropriate for your application.
exit 0
