Start up EC2 instances
======================

[Ansible playbook](https://docs.ansible.com/playbooks.html) to automate the creation of virtual machines on AWS.

This is a scripted solution to quickly spin up virtual machines without having to go through vendor-specific user interfaces or multiple command-line tools.

I am sure there are other solutions for that, like Teraform. This one is implemented with [Ansible cloud modules](http://docs.ansible.com/ansible/list_of_cloud_modules.html).

### Actions

The playbook executes the following steps:

* Queries the selected cloud provider to get current list of VMs
* Creates VMs as necessary and adds them to the inventory under the __cloud__ group
* Checks connectivity to each VM

### Usage

```bash
$ ansible-playbook site.yml

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

### Restriction

You can not create VMs on multiple could providers in the same playbook execution.

### ToDo

* Expland the playbook to support VM provisioning on other clouds
* Add check for python2 on the provisioned VMs -- required for executing Ansible playbook on them
* Extend the playbook to delete VMs if the number of discovered resources is greater than what is desired
* Generate inventory file from template