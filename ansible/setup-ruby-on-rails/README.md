Ruby on Rails setup
===================

Ansible playbook to set up Ruby on Rails development environment,

### Usage

* Update inventory file to set the targetr hostname
* Execute the main Ansible script

```bash
$ ansible-playbook -i hosts setup.yml
```

Note that the Ruby build step may take quite a while -- up to 30 minutes, so be patient.

### TODO

* Add step to provision EC2 instance on which to set up the environment

