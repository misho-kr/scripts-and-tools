CoreOS cluster on KVM
=====================

[Ansible playbook](http://docs.ansible.com/playbooks.html) to create a cluster of [CoreOS](https://coreos.com) servers running on KVM virtual machines.

* [CoreOS](https://coreos.com) is a minimal Linux distribution designed for deployments in cloud infrastructure projects
* [KVM](http://www.linux-kvm.org) is a popular hypervisor for running virtual machines

### Quick start

Creating a cluster of CoreOS machines is as easy as choosing the desired number of machines in the cluster and running one command. The playbook will download stable CoreOS image from the official site, create 3 (by default) KVM virtual machines and bring up the cluster. 

```bash
$ git clone https://github.com/misho-kr/scripts-and-tools
Cloning into 'scripts-and-tools'...
$ cd scripts-and-tools/ansible/create-coreos-cluster
$ ansible-playbook create.yml -i hosts
```

Obviously you need to have [Ansible](http://docs.ansible.com) on your machine in order to run the playbook. Follow the [instuctions in the Ansible documentation](http://docs.ansible.com/intro_installation.html) to install it from distro repositories, from source or with pip.

While the playbook does its thing you can read through this document to understand how to manage the cluster after it is created, and the available configurations options for the _create_ playbbok.

### Cluster management

There are several Ansible scripts to manage the cluster after it was created, like _list_, _start_, _stop_, etc.

By default the cluster is configured to have 3 virtual machines. This can be changed by passing _vm_count_ argument to the playbook, or by updating the virtual machine count in the main configuration file. This can be done even before the cluster is created. Open [group_vars/all.yml](group_vars/all.yml) for edit and set the right value to the _vm_count_ variable.

#### Start up, Shutdown, Restart 

```bash
$ ansible-playbook -i hosts admin.yml -t start
...

$ ansible-playbook -i hosts admin.yml -t shutdown
...

$ ansible-playbook -i hosts admin.yml -t restart
...

```

#### Destroy the cluster

```bash
$ ansible-playbook -i hosts destroy.yml
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

The variables can be passed to the playbook at the command line, or be set permanently in the main configuration file [group_vars/all.yml](group_vars/all.yml). For example thi command will create cluster with 9 virtual machines on LV group named "lv_coreos":

```bash
$ ansible-playbook create.yml -i hosts -e vm_count=9 -e vg_name=lv_coreos
```

#### Repeated execution

This option is not that useful anymore, but it is handy when troubleshooting some problem.

The playbook consists of several roles which are like seperate steps of the procedure to provision the cluster. Each role has a tag which allows to skip it or select it for exclusive execution. For example to skip the creation of cloud-init file for each virtual machine, request that roles and tasks with _init_ tag be skipped:

```bash
$ ansible-playbook -i hosts create.yml -e "vm_count=5" --skip-tags=init
...

```

### Features

The goal of the playbook was to automate many of the cluster provisioning tasks:

* _etcd_ cluster can be initialized via either
 * [discovery token](https://coreos.com/docs/cluster-management/setup/cluster-discovery)
 * [explicitly setting the peer hostnames](http://www.chrislunsford.com/blog/2014/08/01/exploring-etcd)
* If using etcd discovery token, new one will be acquired every time new cluster is provisioned (tokens can be reused)
* CoreOS image is downloaded only the first time the playbook runs.  The cached image will be reused until it is deleted, or if explicitly requested with the _force_download_ option.
* Virtual machines can be created on plain filesystem or on [Logical Volume Manager](https://www.sourceware.org/lvm2/) logical volume

### TODO list

* At the end of provisioning the cluster, create an inventory file with all CoreOS virtual machines listed in it
* Implement a method to specify the virtual machines by name in the inventory file
* Currently the virtual machines are given uninspiring names like _coreos-1_, _coreos-2_, etc. It would be great to allow the user to prepare an inventory file with the desired virtial machines and their names, and use that to provision the cluster

### Issues and workarounds

* Can not provision cluster of size 1, i.e. the variable __vm_count__ should be at least 2
* After a cluster is provisioned it has to be restarted in order for each VM to properly acquire the domain name from the DHCP server (this is handled by the playbook, no need for manual action)
