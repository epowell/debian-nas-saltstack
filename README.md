# General

This is a set of [saltstack](http://saltstack.com/) recipes to set up and configure the following services on your debian insallation:

* usbautomount
* logrotate
* users
* samba shares
* transmission
* plexmediaserver

Additionally one may use [salty-vagrant](https://github.com/saltstack/salty-vagrant) to deploy and test the configuration in virtual machine.

# Requirements
* Ubuntu 14.04 Trusty Tahr
* Saltstack 2014.1.1

# Install Packages
    $sudo add-apt-repository ppa:saltstack/salt
    $sudo apt-get install salt-minion
    
# Customize Salt states
Edit pillar data to fit your needs.

# Configure Salt

- Put minion configuration under _/etc/salt/minion_
- Copy _roots/_ folder contents under _/srv/_

# Run
    salt-call --local state.highstate

# Known issues

# Links
* [Minimal Debian server by romanrm](http://romanrm.ru/en/a10/debian)
* [SaltStack standalone minion](http://salt.readthedocs.org/en/latest/topics/tutorials/standalone_minion.html)

