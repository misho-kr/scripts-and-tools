Minimal VM Initial Setup
========================

## First things first

Before describing the Ansible playbooks in this project it is best to first
introduce the components and setups that are being managed by those playbooks.

#### Minimal VM

Bare-bone VM created from scratch that provides only base operating system
and software packages. Its primary, if not the only, purpose is to be cloned
and then extended by installing additional software packages as needed for
the particular project the VM is being used.

The disk space of a minimal VM is "minimal" -- swap space up to twice the
amount of RAM allocated to the VM, main disk partition that is more than
enough for the OS and essential software packages, plus some modest space
for installing more sowftare. However for more serious work beyond quick
experiments addtional volumes should be created and attached to the VM.

Needless to say, a minimal VM has some Linux distro installed on it.

#### Initial Setup

In order to be easy and quick to use in experiments the minimal VM will
have the following configuration:

* Only the base software packages are installed
* SSH server is running with only PublicKey authentication enabled to allow
remote logins
* A user account is created with sudo privileges and one SSH public key
configured to enable passwordless logins
* Some environment setups that are useful in everyday development and/or
sysadmin work, like aliases, shell functions, etc. are preconfigured for
the user account mentioned above
* The only "extra" software package may be emacs, text-only (nox) version.
This is clearly personal preference that not everyone will agree with.

The minimal VM must have the same software packages, user account and other
settings, regardless of the Linux flavor -- Redhat/CentOS/Fedora, Ubuntu,
Debian and so on, that is installed.

## Usefulness

The requirements for minimal VM as laid out above are not terribly demanding
so they can be easily implemented by hand. It will take slightly longeg to
type the commands but since it does not happen often it can be tolarated.

However it takes more time to recall the particular settings that are useful
and desirable, and to remember the location of profiles and other files that
have to be copied onto the minimal VM.

And one last reason for writing these playbooks is to add experience and
learn more about [Ansible playbook](http://docs.ansible.com/playbooks.html).
It was surprising how some seemingly trivial operations can require
significant thought and techniques when they have to be executed on
multiple Linux distros, possibly in different environment, and must produce
the same predicable results.

## Finally, the Ansible playbooks


#### Inventory list

* Defines all hosts that will be targets for the playbooks
* Splits the hosts into groups that have to be treated differently, because
there operations can be carried out on some on some Lunux distros but not
on others, or have differences across different flavors of Linux

## TODO

It would be nice to be able to handle the interaction with KVM with this
playbook. That will replace the manual task of cloning VM or creating new VM
from scratch.

Look at [Virt module](http://docs.ansible.com/virt_module.html).
