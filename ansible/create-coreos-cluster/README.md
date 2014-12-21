CoreOS Cluster on KVM VMs
=========================

[CoreOS](https://coreos.com) is a minimal Linux distribution designed for deployments in cloud infrastructure projects.

### Goal

This [Ansible playbook](http://docs.ansible.com/playbooks.html) creates a
cluster of KVM-based virtual machines running CoreOS. It downloads VM image
from the official site and starts the virtual machines from that image.

For convenience there are several Ansible scripts to manage the cluster after was provisioned.

Ideally a cluster can be defined in one of two possible methods:

1. By declaring the desired number of virtual machines
1. By listing the names of virtual machines to provision in the [playbook inventory file](http://docs.ansible.com/intro_inventory.html)

_Note: At this time only the first method (by vm count) is implemented._

### Cluster management

#### Create 

Follow these simple steps:

1. Download (or clone) this repo
1. Update the __vm_count__ variable in [group_vars/all.yml](group_vars/all.yml) file to define the number CoreOS servers in the cluster (or pass the variable setting to te playbook at the command line)
1. Run the [create Ansible playbook](create.yml)

```bash
$ ansible-playbook -i hosts create.yml -e "vm_count=3"
...

```

#### Start up and Shutdown 

```bash
$ ansible-playbook -i hosts admin.yml -t start -e "vm_count=3"
...

$ ansible-playbook -i hosts admin.yml -t shutdown -e "vm_count=3"
...

```

#### Destroy the cluster

```bash
$ ansible-playbook -i hosts destroy.yml -e "vm_count=3"
...

```

### Issues and workarounds

Due to my incomplete knowledge of the capabilities that [Ansible](http://docs.ansible.com/]
provides, as well as some inherent limitations of what can and can not be
coded in [Ansible playbook](http://docs.ansible.com/playbooks.html), there are
certain corner cases where the playbook may produce incorrect results or 
error out:

* Can not provision cluster of size 1, i.e. the variable __vm_count__ should be at least 2
* After a cluster is provisioned it has to be restarted manually in order for each VM to properly acquire its domain name

### TODO list

* Use [Logical Volume Manager](https://www.sourceware.org/lvm2/) to create disk partitions for the disk images of the virtual machines
* Implement method to specify the virtual machines by name in the inventory file
