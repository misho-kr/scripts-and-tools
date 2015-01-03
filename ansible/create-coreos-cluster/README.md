KVM Cluster of CoreOS machines
==============================

This [Ansible playbook](http://docs.ansible.com/playbooks.html) creates a cluster of [CoreOS](https://coreos.com) servers running on KVM virtual machines running. [CoreOS](https://coreos.com) is a minimal Linux distribution designed for deployments in cloud infrastructure projects

### Goal

This [Ansible playbook](http://docs.ansible.com/playbooks.html) creates a cluster of KVM-based virtual machines running CoreOS. It downloads VM image from the official site and starts the virtual machines from that image.

Ideally a cluster can be defined in one of two possible methods:

1. By declaring the desired number of virtual machines
1. By listing the names of virtual machines to provision in the [playbook inventory file](http://docs.ansible.com/intro_inventory.html)

_Note: At this time only the first method (by vm count) is implemented._

### Cluster management

For convenience there are several Ansible scripts to manage the cluster after was provisioned.

#### Create 

Follow these simple steps:

1. Download (or clone) this repo
1. Update the __vm_count__ variable in [group_vars/all.yml](group_vars/all.yml) file to define the number CoreOS servers in the cluster (or pass the variable setting to te playbook at the command line as shown in the examples)
1. Run the [create Ansible playbook](create.yml)

```bash
$ ansible-playbook -i hosts create.yml -e "vm_count=5"
...

```

#### Provisioning options

These playbook variables that can be used to customize the provisioned cluster:

* __vm_count__ (default=3) -- number of virtual machines in the cluster
* __vg_name__ -- use this volume group to create logical volumes for vm images; if not defined then use plain filesystem
* __cloud_init_profile__
 * __basic__ (default) -- minimum setup, set hostname and upload ssh keys
 * __etcd_fleet__ -- _etcd_ and _fleet_ services are started on each VM
* __discovery_token__ -- pass _etcd_ discovery token for use by the _etcd_ cluster, if not provided one will be generated from https://discovery.etcd.io/new
* __use_discovery_token__ (default=yes) -- __discovery_token__ will be used to find all neighbors in the cluster
* __force_download__ -- fresh vm image will be downloaded even if one exists in the download folder

#### Start up and Shutdown 

```bash
$ ansible-playbook -i hosts admin.yml -t start -e "vm_count=5"
...

$ ansible-playbook -i hosts admin.yml -t shutdown -e "vm_count=5
...

```

#### Destroy the cluster

```bash
$ ansible-playbook -i hosts destroy.yml -e "vm_count=3"
...

```

#### Repeated execution

This option is not that useful anymore, but it is handy when troubleshooting some problem.

The playbook consists of several roles which are like seperate steps of the procedure to provision the cluster. Each role has tag which allows to skip or select for execution indivisual steps. For example to skip the creation of cloud-init file for each virtual machine, request that roles and tasks with _init_ tag be skipped:

```bash
$ ansible-playbook -i hosts create.yml -e "vm_count=5" --skip-tags=init
...

```

By default the playbook will not download vm image from the official site if one already exists in the download folder. Therefore it is not necessary to skip the tasks with tag _download_. OTOH if the vm image has to be refreshed then use the __force_download__ flag.

### Issues and workarounds

Due to my incomplete knowledge of the capabilities that [Ansible](http://docs.ansible.com/) provides, as well as some inherent limitations of what can and can not be coded in [Ansible playbook](http://docs.ansible.com/playbooks.html), there are corner cases where the playbook may produce incorrect results or error out:

* Can not provision cluster of size 1, i.e. the variable __vm_count__ should be at least 2
* After a cluster is provisioned it has to be restarted in order for each VM to properly acquire the domain name from the DHCP server (this is handled by the playbook)

### TODO list

* Implement a method to specify the virtual machines by name in the inventory file
* At the end of _create_, _start_ and _restart_ commands there are pauses of fixed number of seconds to give the VMs chance to complete the operation. Instead the playbook should query the status of the VMs and finish when _libvirt_ gives positive indicator.
* ~~Use [Logical Volume Manager](https://www.sourceware.org/lvm2/) to create disk partitions for the disk images of the virtual machines~~
* ~~When cluster is destroyed, the files or logical volumes of the virtual machines should be deleted~~
* ~~Download of CoreOS image should be done only if the image was not downloaded already, or if explicitly requested~~
* ~~_etcd_ cluster should be initialized via either [discovery token](https://coreos.com/docs/cluster-management/setup/cluster-discovery) or [explicitly setting the peer hostnames](http://www.chrislunsford.com/blog/2014/08/01/exploring-etcd)~~
* ~~Acquire new etcd discovery token automatically every time new cluster is provisioned~~
