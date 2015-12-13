Ruby on Rails setup
===================

Ansible playbook to set up Ruby on Rails development environment.

### Usage

* Update inventory file to set the targetr hostname
* Execute the main Ansible script

```bash
$ ansible-playbook -i hosts setup.yml
```

Note that the Ruby build step may take quite a while -- up to 30 minutes, so be patient. In practice it is usually less than 5 minutes.

### Credits

This playbook is based on [shell script created by Kalman Hazins](https://github.com/jhu-ep-coursera/fullstack-course1-module1/blob/master/Lecture01-Installation/Linux-Installs/fedora-devenv/sw-install-rbenv-fedora.sh) for the Coursera online course [Introduction to Ruby on Rails](https://www.coursera.org/learn/ruby-on-rails-intro).

### TODO

* Add step to provision EC2 instance on which to set up the environment

