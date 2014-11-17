CoreOS Cluster on KVM VMs
=========================

__WORK IN PROGRESS__

[CoreOS](https://coreos.com) is a minimal Linux distribution designed for
deployments in cloud infrastructure projects.

### Goal

This [Ansible playbook](http://docs.ansible.com/playbooks.html) creates a
KVM cluster of N CoreOS servers. It downloads VM image from the official
site and starts the virtual machines from that image.

For convenience there are several Ansible scripts to manage the cluster
after was provisioned.

### Provisioning

Follow these simple steps:

1. Download (or clone) this repo
2. Update [hosts](hosts) file to define the number CoreOS servers in the
cluster and to define their names
3. Run the Ansible playbook

```bash
$ ansible-playbook -i hosts site.yml
...

```

### Start up and Shutdown 

```bash
$ ansible-playbook -i hosts start.yml
...

$ ansible-playbook -i hosts stop.yml
...


```

### Destroy the cluster

```bash
$ ansible-playbook -i hosts destroy.yml
...

```
