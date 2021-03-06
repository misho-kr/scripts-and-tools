Make Virtual Machines in the cloud
==================================

## Tombstone

This playbook was moved into dedicated repository -- [Ansible Cloud Playbooks](https://github.com/misho-kr/ansible-cloud-playbooks). All future work will continue there.

This folder will bve removed on ar after: 2018/1/1

[Ansible playbook](https://docs.ansible.com/playbooks.html) to automate the creation of virtual machines on public clouds. No need for vendor-specific user interfaces or multiple command-line tools.

I am sure there are other solutions for that, like [Teraform](https://www.terraform.io). This one is implemented with [Ansible cloud modules](http://docs.ansible.com/ansible/list_of_cloud_modules.html).

### Purpose

There are multiple Ansible playbooks in this repository. The first one is [cloud.yml](cloud.yml) which is a showcase of how to create one or more virtual machines in the cloud. Then there are more playbooks that are based on the first one that add roles and tasks to provision specific software packages and services on the VMs.

* [Dev Machine](dev-machine.yml] -- virtual machine for software developmnt (c++, ruby, etc)
* [Serf](serf.yml] -- cluster of [serf agents](https://www.serf.io/docs/index.html)

### Supported cloud providers

* Amazon Web Services
* Google Cloud Engine (work in progress)

### Actions

The playbook executes the following steps:

* Queries the selected cloud provider to get current list of VMs
* Creates VMs as necessary (or destroys) and adds them to the inventory under the __cloud__ group
* Checks connectivity to each VM

### Usage

```bash
$ ansible-playbook cloud.yml

PLAY [localhost] ***************************************************************

TASK [provision-cloud : include_vars] ******************************************
ok: [localhost] => {"ansible_facts": {"aws_access_key": null,
...

PLAY RECAP *********************************************************************
localhost                  : ok=10   changed=1    unreachable=0    failed=0

```

Optional arguments (may be passed to the playbook on the command line):

* __cloud__ -- cloud provider to use, initially only _aws_ is supported
* __vm_count__ -- number of VMs to create

Optional arguments for AWS-provioned resources:

* __ec2_instance_name_attr__ and __ec2_new_instance_name_attr__ -- attributes in the EC2 instance description that will be added as hostnames to the playbook inventory

### Prepation for execution

1. Inventory -- there is no inventory file!
1. Specify the cloud provider and desired number of VMs in the __vars__ section of the playbook
1. Optionally, expand the playbook with your provisioning and configuration steps by adding tasks and roles to the playbook

Provisioning cloud infrastructure requires credentials to be passed to the playbook. Here is how to do that:

* For working with AWS, set these environment variables
 * AWS_ACCESS_KEY_ID
 * AWS_SECRET_ACCESS_KEY
 * AWS_SECURITY_TOKEN (only if required for the account to which the above pair of keys belongs)

### Restriction

You can not create VMs on multiple could providers in the same playbook execution.

### ToDo

* Expland the playbook to support VM provisioning on other clouds
* ~~Add check for python2 on the provisioned VMs -- required for executing Ansible playbooks~~
* ~~Extend the playbook to delete VMs if the number of discovered resources is greater than what is desired~~
* ~~Generate inventory file from template with all provisioned VMs~~
