Setup account on newly created VM
=================================

## Purpose

After creating new VM there are a set of scripts to install and other setups
that I do in order to make the machine easy and familiar to work with. These
are steps that get executed with little variation every time.

This [Ansible playbook](http://docs.ansible.com/playbooks.html) automates the
post-installation tasks.

##
 
## TODO

It would be nice to be able to handle the interaction with KVM with this
playbook. That will replace the manual task of cloning VM or creating new VM
from scratch.

Look at [Virt module](http://docs.ansible.com/virt_module.html).
