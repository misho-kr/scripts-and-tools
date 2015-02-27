Mesosphere on CoreOS cluster
============================

With ready-to-use Docker images of Zookeeper, Mesos master and sslave, and Marathon framework, all that is needed to bring up a Mesos cluster is a platform to run Docker containers. And that is what [CoreOS](https://coreos.com) is for.

The idea to run thse components in Docker containers and to combine them to form a Mesos cluster came from this blog -- [Mesosphere on a Single CoreOS Instance](https://mesosphere.com/docs/tutorials/mesosphere-on-a-single-coreos-instance). The [Ansible playbook](http://docs.ansible.com/playbooks.html) in this repo automates the process to provision the cluster.

### Step 1: servers

Get some number of servers ready for deployment -- easiest is to create virtual machines on your computer or from a cloud provider. 

### Step 2: source code and tools

Clone this repo to get the Ansible playbook. If you don't have the Ansible tool, look for at the [installation instructions](http://docs.ansible.com/intro_installation.html).

### Step 3: inventory

Ansible needs to know what servers will be targeted by the playbook. These are the servers provisioned at step 1. Add their hostnames to the __coreos__ section of the [inventory file](hosts).

### Step 4: playbook

Run the Ansible tool and wait until it completes.

```bash
$ ansible-playbook -i hosts site.yml
...
```

### Step 5: Mesos

The cluster is up and running. Point your browser to any of the servers that is running a Mesos master and choose port _5050_.
