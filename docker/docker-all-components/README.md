Docker Components Installation
==============================

[Ansible playbook](https://docs.ansible.com/playbooks.html) to install Docker daemon/service, Docker Compose, Swarm and Machine.

## Purpose

Docker can be installed from Linux package repositories on most, if not all, Linux distros. With this playbook the installation, and update, can be executed on multiple hosts with one siblge command. It can be useful these situations:

* When (Docker) [https://docker.io] releases new versions the Linux distro repository may not be updated for some time
* Docker Compose, Swarm and Machine are considered experimental so there are no ready packages to install

## Execution

* Make sure [Ansible](https://docs.ansible.com) is installed on the machine that will execute the playbook (your laptop or dekstop computer)
* Clone or download this GitHub repository
* Define the target hosts (where the Docker components will be installed) in the [playbook inventory file](hosts)
* Run the playbook

#### 1. Install Ansible

Ansible tool has to be installed *only* on the host (deskop or laptop) where the playbook is being executed. There are no requirements for the hosts where the Docker componens will be installed, as long as Python 2.7 (anything higher than 2.4) is available.

See the [Ansible documentation](http://docs.ansible.com/intro_installation.html) for instructions to install the tool with _apt_, _yum_, _pip_, _brew_ or from source code.

#### 2. Download the playbook

Use __git-clone__ or __wget__ to bring the playbook source files to your computer. The example below uses _wget_.

```bash
$ wget https://github.com/misho-kr/scripts-and-tools/archive/master.zip
...
2015-04-26 23:43:24 (526 KB/s) - ‘master.zip’ saved [174936/174936]

$ unzip master.zip && rm master.zip
Archive:  master.zip
eeacad786c5a5e6a4249628f8cffa81ad835645b
   creating: scripts-and-tools-master/
...
$ cd scripts-and-tools-master/docker/docker-all-components
```

#### 3. Select the target hosts

The list of hosts is called [inventory](http://docs.ansible.com/intro_inventory.html) where hosts are grouped by the component that will be installed on them.

* Look in the playbook folder for the [host](host) file
* Add hosts to group(s) with names of the Docker components to be installed on them

```
...
[docker]
my-docker-host.my-domain.com

[compose]
my-docker-compose.my-domain.com
```

The example above will select to install:

* Docker on _my-docker-host.my-domain.com_
* Docker Compose on _my-docker-compose.my-domain.com_

#### 4. Run the playbook

This will install the Docker components on the hosts as defined in the inventory. Pay attention to these details:

* If your public SSH key is already uploaded to all target hosts, there is no need to pass the "-k" option. This is known as [passwordless login](http://linuxconfig.org/passwordless-ssh)
* Your user account on the target hosts may or may not require password to execute _sudo_, in the latter case "-K" option is not needed
* By default Ansible will run the playbook in parallel in blocks of 5 hosts each, this can be changed with the "-f" option

```bash
$ ansible-playbook -i hosts site.yml -k -K
SSH password:
SUDO password[defaults to SSH password]:

PLAY [docker] *****************************************************************

GATHERING FACTS ***************************************************************
ok: [my-docker-host.my-domain.com]

...

PLAY RECAP ********************************************************************
my-docker-host.my-domain.com : ok=7    changed=4    unreachable=0    failed=0
my-docker-compose.my-domain.com : ok=7    changed=5    unreachable=0    failed=0
```

#### 5. Run the playbook to install only select Docker components

The normal playbook execution will go through every groups and install the corrsponding Docker components on the hosts in that group. If instead only select Docker components should be installed, use the "-t" flag to restrict the scope of the playbook. The "-t" flag can be used multiple times on the same command line.

```bash
$ ansible-playbook -i hosts site.yml -t docker -k -K
SSH password:
SUDO password[defaults to SSH password]:

PLAY [docker] *****************************************************************

GATHERING FACTS ***************************************************************
ok: [my-docker-host.my-domain.com]

...

PLAY RECAP ********************************************************************
my-docker-host.my-domain.com : ok=7    changed=4    unreachable=0    failed=0
```

#### TODO

TBC
