Minimal VM Initial Setup
========================

Set of Ansible playbooks to do initial software package installation and configuration on newly created VMs. The goal is to have everything set up the way I have become used to and have the tools I need ready to use.

#### Minimal VM

Bare-bone VM that provides only base operating system and minimal set of software packages. It can be used for quick experiments, or be cloned and then extended by installing additional software packages as needed.

The disk space of a minimal VM is "minimal" -- swap space (if there is any) up to twice the amount of RAM allocated to the VM, main disk partition that is just enough for the OS and essential software packages, plus some modest space for installing more sowftare.

#### Initial Setup

In order to be easy and quick to use in experiments the minimal VM will have the following configuration:

* Only base software packages are installed
* SSH server is running with only PublicKey authentication enabled to allow remote logins
* One user account is created with sudo privileges and one SSH public key configured to enable passwordless logins
* Some environment setups that are useful in everyday development and/or sysadmin work, like aliases, shell functions, etc. are preconfigured for the user account mentioned above
* The only "extra" software package may be emacs, text-only (nox) version.  This is clearly personal preference that not everyone will agree with.

The minimal VM must have the same software packages, user account and other settings, regardless of the Linux flavor -- Redhat/CentOS/Fedora, Ubuntu, Debian and so on, that is installed.

## Usefulness

The requirements for minimal VM as laid out above are not terribly demanding so they can be easily implemented by hand. It will take slightly longer to type the commands but since it does not happen often it can be tolarated.

However it takes more time to recall the particular settings that are useful and desirable, and to remember the location of profiles and other files that have to be copied onto the minimal VM.

And one last reason for writing these playbooks is to add experience and learn more about [Ansible playbook](http://docs.ansible.com/playbooks.html).  It was surprising how some seemingly trivial operations can require significant thought and techniques when they have to be executed on multiple Linux distros, possibly in different environment, and must produce the same predicable results.

## Finally, the Ansible playbooks

Yes, there are several playbooks. The initial goal was to have one (smart) playbook that can detect the platform on which it is running and adjust the deployment strategy accordingly. The end of this document expounds on the reasons that goal is not achiavable (yet).

So there are two main playbooks:

* Create, or update, a user account so that all hosts have identical login procedure and execution privileges
* Main playbook to carry out all installation and configuration steps

#### Make User

The use case for this playbook is hosts that have only root account that allows direct ssh login. It will create regular (non-root) user account and will grant "sudo" privileges.

```bash
$ ansible-playbook make_user.yml -i hosts -t create-sudo-user -k
$ ansible-playbook make_user.yml -i hosts -t create-sudo-user -e nonroot_user=userA -k
```

#### Grant User

This playbook can be run if non-root account already exists. That account
will get "sudo" privileges.

```bash
$ ansible-playbook grant_user.yml -i hosts -k --ask-su-pass
$ ansible-playbook grant_user.yml -i hosts -e nonroot_user=userA -k --ask-su-pass
```

#### Main -- site.yml

When all hosts have non-root account with sudo privileges the main playbook can be executed. The action list includes at least the following items:

* Enable password-less login and removes the password for the non-root account
* Disable all forms of authentications with the ssh server, and leave only public key authentication
* Configure [password-less sudo authentication](http://pamsshagentauth.sourceforge.net), when the user has logged in with ssh and public key authentication
* Install limited set of software packages

```bash
$ ansible-playbook site.yml -i hosts
```

#### Inventory list

* Defines all hosts that will be targets for the playbooks
* Splits the hosts into groups that have to be treated differently

The provided [hosts](hosts) file defines 3 groups of hosts depending on the presence or absence of regular (non-root) account:

* Account does not exist
* Account exists but does not have "sudo" privileges

## TODO

It would be nice to be able to handle the interaction with KVM with this playbook. That will replace the manual task of cloning VM or creating new VM from scratch.

Look at [Virt module](http://docs.ansible.com/virt_module.html).

