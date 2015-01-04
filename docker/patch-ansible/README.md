Patched Ansible
===============

[Docker image of Ansible](https://github.com/ansible/ansible-docker-base) with
patches applied to pick up bug fixes and improvements that have not been merged
into the main codebase.

This modified version of the Ansible Docker image was built to provide version
of Ansible with option to force [HTTP Basic Authentication](http://en.wikipedia.org/wiki/Basic_access_authentication)
 when invoking the [get_url module](http://docs.ansible.com/get_url_module.html).
At the time this new feature was needed there was already an issue and
pull-requests (PR) for two GitHub repositories:

* [ansible/ansible](https://github.com/ansible/ansible) -- [#9281](https://github.com/ansible/ansible/pull/9281)
* [ansible/ansible-modules-core](https://github.com/ansible/ansible-modules-core) -- [#153](https://github.com/ansible/ansible-modules-core/pull/153)

However the PR is not merged to master branch yet. This Docker image is one workaround.

## Usage

The same way the official [Ansible Docker image](https://github.com/ansible/ansible-docker-base)
is used:

```bash
$ docker run -it --rm misho1kr/ansible-patched ansible --version
ansible 1.8 (devel c3ef1f734c) last updated 2014/10/27 05:25:05 (GMT +100)
  lib/ansible/modules/core: (detached HEAD dea9a2181f) last updated 2014/10/27 05:41:02 (GMT +100)
  lib/ansible/modules/extras: (detached HEAD a0df36c6ab) last updated 2014/10/23 18:29:42 (GMT +100)
  v2/ansible/modules/core: (detached HEAD 6375b0e976) last updated 2014/10/27 05:41:44 (GMT +100)
  v2/ansible/modules/extras: (detached HEAD 8a4f07eecd) last updated 2014/10/23 18:29:45 (GMT +100)
  configured module search path = /opt/ansible/ansible/library
```

## Ansible Docker Base

These are base docker images that include ansible. Ansible maintains these
images so that people can easily build docker images using ansible playbooks.

The images use [centos7](https://registry.hub.docker.com/u/ansible/centos7-ansible)
or [ubuntu14.04](https://registry.hub.docker.com/u/ansible/ubuntu14.04-ansible)
as their base. 

## Bug Fixes, Improvements and New Features

It would be nice to make the generation of Dockerfile (and creation of Docker
image) generic and parameterized. That would allow to point to particular PR
(pull request) or commit id and have a custom Docker image prepared from the
base Ansible Docker image with the desired changes applied.

[Ansible playbook]() can automate this process and make it as simple as
executing one single command.
