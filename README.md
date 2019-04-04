This project is dormant ([reasons](https://gist.github.com/JamborJan/8e42eff813b6fb0b6fe987afb9241c5e)). 

Issues have been closed as there will be no further progress on them. Feel free to fork the repo and take over maintenance.

Keeweb App for Sandstorm
========================
This is the [Sandstorm](https://sandstorm.io) package of the [KeePass web app (unofficial)](https://keeweb.info) which has been build by [antelle](https://github.com/antelle).

The package is done with [vagrant-spk](https://github.com/sandstorm-io/vagrant-spk), a tool designed to help app developers package apps for [Sandstorm](https://sandstorm.io).

You can follow the following steps to make your own package or to contribute.

## Prerequisites

You will need to install:
- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- Git

## Step by Step

    git clone https://github.com/sandstorm-io/vagrant-spk
    git clone https://github.com/JamborJan/keeweb-sandstorm
    export PATH=$(pwd)/vagrant-spk:$PATH
    cd keeweb-sandstorm
    vagrant-spk vm up
    vagrant-spk dev

Visit [http://local.sandstorm.io:6080/](http://local.sandstorm.io:6080/) in a browser.

Note: when you want to fork this repo and create actual app packages for the app store you would need either the original app key from me or create a new one and make your own app.
