Docker Components Installation
==============================

[Ansible playbook](https://docs.ansible.com/playbooks.html) to install Docker service, Docker Compose, Swarm and Machine from the [official repo](https://docker.io)

## Purpose

Docker can be installed from Linux package repositories on most, if not all, Linux distros. This playbook can be useful thse situations:

* [https://docker.io] releases new version of Docker but the Linux distro repository has not been updated yey to provide the new version
* Docker Compose, Swarm and Machine are considered experimental so there are no ready packages

## Execution

* Make sure [Ansible](https://docs.ansible.com] is installed on the machine that will execute the playbook (your laptop or dekstop computer)
* Clone or download this GitHub repository
* Define the target hosts (where the Docker components will be installed) in the [playbook inventory file](hosts)
* Run the playbook

#### 1. Install Ansible

Ansible tool has to be installed *only* on the host (deskop or laptop) where the playbook is being executed. There is no installation on the hosts where the Docker componens will be installed, as long as Python 2.7 (anything higher than 2.4) is available.

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

#### 3. Select target hosts

After the one-time preparaion is completed, the first step is to define which hosts will be targetted by the playbook execution. The list of hosts is called [inventory](http://docs.ansible.com/intro_inventory.html) where hosts are grouped by the component that will be installed on them.

1. Look at the root folder of the git repository and you will find the [host](host) file
1. Add the hostnames of the target hosts to __docker-all__ group

```
...
[docker-all]
my-docker-host.my-domain.com
[docker-compose]
my-docker-compose.my-domain.com
```

The example above will select to install:

* All Docker components on _my-docker-host.my-domain.com_
* Only Docker Compose on _my-docker-compose.my-domain.com_

#### 4. Run the playbook

This will install all Docker components on all hosts defined in __docker-all__ group. Pay attention to these details:

* If your public SSH key is already uploaded to all target hosts, there is no need to pass the "-k" option. This is known as [passwordless login](http://linuxconfig.org/passwordless-ssh)
* Your user account on the target hosts may or may not require password to execute _sudo_, in the latter case "-K" option is not needed
* By default Ansible will run the playbook in parallel in blocks of 5 hosts each.

```bash
$ ansible-playbook -v -i hosts site.yml -k -K
SSH password:
SUDO password[defaults to SSH password]:

PLAY [docker] *****************************************************************

GATHERING FACTS ***************************************************************
ok: [my-docker-host.my-domain.com]

...

PLAY RECAP ********************************************************************
my-docker-host.my-domain.com : ok=7    changed=4    unreachable=0    failed=0
```

#### 5. Run the playbook to install only select Docker components

TBC

#### TODO

TBC
