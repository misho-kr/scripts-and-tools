Minimal VM Initial Setup
========================

Set of Ansible playbooks to do initial software package installation and configuration on newly created VMs.

## Purpose

When new VM is created some work needs to be done to make it convenient to use and feel familiar. This work consists of installing frequently used software packages, upload ssh keys, add vars and aliases to the shell environment.

Bare-bone VM created from scratch that provides only base operating system
and software packages. Its primary, if not the only, purpose is to be cloned
and then extended by installing additional software packages as needed for
the particular project the VM is being used.
Bare-bone VM that provides only base operating system and minimal set of software packages. It can be used for quick experiments, or be cloned and then extended by installing additional software packages as needed.
These small playbooks take care of this work.

## Ansible playbooks

There are separate Ansible playbooks -- to create remote user account, to grant sudo privileges and to customize the VM.

#### Make User

It creates regular (non-root) user account and will grant "sudo" privileges. Requires ssh login as _root_. By default the username on the local host is used to create the remote account.

```bash
$ ansible-playbook make_user.yml -i hosts -k
$ ansible-playbook make_user.yml -i hosts -e nonroot_user=userA -k
```

#### Grant User

The remote account that was created (or already existed) will get "sudo" privileges.

```bash
$ ansible-playbook grant_user.yml -i hosts -k --ask-su-pass
$ ansible-playbook grant_user.yml -i hosts -e nonroot_user=userA -k --ask-su-pass
```

#### Main

This playbook is executed when the remote account with sudo privileges exists. The action list includes the following items:

* Enables password-less login and removes the password for the non-root account
* Disables all forms of authentications with the ssh server, and leaves only public key authentication
* Configures [password-less sudo authentication](http://pamsshagentauth.sourceforge.net), when the user has logged in with ssh and autheticated with public key
* Installs small set of software packages

```bash
$ ansible-playbook site.yml -i hosts
```

#### Playbook Inventory List

Before the playbooks are run the target hosts must be defined in the [Inventory](http://docs.ansible.com/intro_inventory.html). The [Inventory](hosts) file defines 3 groups of hosts for each playbook and use case:

* Account does not exist, direct ssh login as _root_ is possible
* Account exists but does not have "sudo" privileges
* Account exists with "sudo" privileges

For example if only the main playbook will be executed then the hostname(s) should be added to the _setup-only_ group.

## Additional notes

#### Minimal VM

Bare-bone VM that provides only base operating system and minimal set of software packages. It can be used for quick experiments, or be cloned and then extended by installing additional software packages as needed.

The disk space of a minimal VM is "minimal" -- swap space (if there is any) up to twice the amount of RAM allocated to the VM, main disk partition that is just enough for the OS and essential software packages, plus some modest space for installing more sowftare.

#### Requirements


* Only base software packages are installed
* SSH server is running with only PublicKey authentication enabled to allow remote logins
* One user account is created with sudo privileges and one SSH public key configured to enable passwordless logins
* Some environment setups that are useful in everyday development and/or sysadmin work, like aliases, shell functions, etc. are preconfigured for the user account mentioned above
* The only "extra" software package may be emacs, text-only (nox) version.  This is clearly personal preference that not everyone will agree with.

## TODO

It would be nice to be able to handle the interaction with KVM with this playbook. That will replace the manual task of cloning VM or creating new VM from scratch.

Look at [Virt module](http://docs.ansible.com/virt_module.html).

