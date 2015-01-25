CoreOS cluster on KVM
=====================

[Ansible playbook](http://docs.ansible.com/playbooks.html) to create a cluster of [CoreOS](https://coreos.com) servers running on KVM virtual machines.

* [CoreOS](https://coreos.com) is a minimal Linux distribution designed for deployments in cloud infrastructure projects
* [KVM](http://www.linux-kvm.org) is a popular hypervisor for running virtual machines

### Quick start

Creating a cluster of CoreOS machines is as easy as choosing the desired number of machines in the cluster and running one command. The playbook will download stable CoreOS image from the official site, create the KVM virtual machines and bring up the cluster. 

```bash
$ git clone https://github.com/misho-kr/scripts-and-tools
Cloning into 'scripts-and-tools'...
$ cd scripts-and-tools/ansible/create-coreos-cluster
$ ansible-playbook create.yml -i hosts -e vm_count=3
...
```

You need to have [Ansible](http://docs.ansible.com) on your machine in order to run the playbook. Follow the [instuctions in the Ansible documentation](http://docs.ansible.com/intro_installation.html) to install it from distro repositories, from source or with pip.

While the playbook does its thing you can read through this document to understand how to manage the cluster after it is created, and the available configurations options.

### Cluster management

There are several Ansible scripts to manage the cluster after it was provisioned, like _list_, _start_, _stop_, etc.

The recommanded first step is to update the virtual machine count in the configuration file so it does not have to be passed as command-line argument with every command. This can be done even before the cluster is created which will further reduce the command above to create the cluster. Open (group_vars/all.yml) for edit and set the right value to the _vm_count_ variable.

#### Start up and Shutdown 

```bash
$ ansible-playbook -i hosts admin.yml -t start -e vm_count=3
...

$ ansible-playbook -i hosts admin.yml -t shutdown -e vm_count=3
...

```

#### Destroy the cluster

```bash
$ ansible-playbook -i hosts destroy.yml -e vm_count=3
...

```

#### Create 

These playbook variables that can be used to customize the provisioned cluster:

* __vm_count__ (default=3) -- number of virtual machines in the cluster
* __vg_name__ -- use this volume group to create logical volumes for vm images; if not defined then use plain filesystem
* __cloud_init_profile__
 * __basic__ (default) -- minimum setup, set hostname and upload ssh keys
 * __etcd_fleet__ -- _etcd_ and _fleet_ services are started on each VM
* __discovery_token__ -- pass _etcd_ discovery token for use by the _etcd_ cluster, if not provided one will be generated from https://discovery.etcd.io/new
* __use_discovery_token__ (default=yes) -- __discovery_token__ will be used to find all neighbors in the cluster
* __force_download__ -- fresh vm image will be downloaded even if one exists in the download folder

#### Repeated execution

This option is not that useful anymore, but it is handy when troubleshooting some problem.

The playbook consists of several roles which are like seperate steps of the procedure to provision the cluster. Each role has a tag which allows to skip it or select it for exclusive execution. For example to skip the creation of cloud-init file for each virtual machine, request that roles and tasks with _init_ tag be skipped:

```bash
$ ansible-playbook -i hosts create.yml -e "vm_count=5" --skip-tags=init
...

```

By default the playbook will not download vm image from the official site if one already exists in the download folder. Therefore it is not necessary to skip the tasks with tag _download_. OTOH if the vm image has to be refreshed then use the __force_download__ flag.

### TODO list

* At the end of provisioning the cluster, create an inventory file with all CoreOS virtual machines listed in it
* Implement a method to specify the virtual machines by name in the inventory file
* Currently the virtual machines are given uninspiring names like _coreos-1_, _coreos-2_, etc. It would be great to allow the user to prepare an inventory file with the desired virtial machines and their names, and use that to provision the cluster
* ~~At the end of _create_, _start_ and _restart_ commands there are pauses of fixed number of seconds to give the VMs chance to complete the operation. Instead the playbook should query the status of the VMs and finish when _libvirt_ gives positive indicator.~~
* ~~Use [Logical Volume Manager](https://www.sourceware.org/lvm2/) to create disk partitions for the disk images of the virtual machines~~
* ~~When cluster is destroyed, the files or logical volumes of the virtual machines should be deleted~~
* ~~Download of CoreOS image should be done only if the image was not downloaded already, or if explicitly requested~~
* ~~_etcd_ cluster should be initialized via either [discovery token](https://coreos.com/docs/cluster-management/setup/cluster-discovery) or [explicitly setting the peer hostnames](http://www.chrislunsford.com/blog/2014/08/01/exploring-etcd)~~
* ~~Acquire new etcd discovery token automatically every time new cluster is provisioned~~

### Issues and workarounds

Due to my incomplete knowledge of the capabilities that [Ansible](http://docs.ansible.com/) provides, there are corner cases where the playbook may produce incorrect results or error out:

* Can not provision cluster of size 1, i.e. the variable __vm_count__ should be at least 2
* After a cluster is provisioned it has to be restarted in order for each VM to properly acquire the domain name from the DHCP server (this is handled by the playbook, no need for manual action)
