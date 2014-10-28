# Docker image of Ansible with patches applied to it
# --------------------------------------------------
 
FROM            ansible/centos7-ansible:devel
MAINTAINER      Misho Krastev <misho.kr@gmail.com>

# Git configuration
RUN git config --global user.email "you@example.com" && \
    git config --global user.name  "Your Name"

# Ansible installation folder
WORKDIR /opt/ansible/ansible

# 1. Patches to apply to ansible/ansible
# https://github.com/ansible/ansible/pull/9281
RUN git remote add patch https://github.com/woltage/ansible.git && \
    git fetch -q patch                                          && \
    git rebase 3a229eb1e97b50326a41e2a603379d07dec481dc	        && \
    git rebase dec9cfbc27a0001e7db90c9d0cedf0b0629fabc9

# 2. Patches to apply to ansible/ansible-modules-core
# https://github.com/ansible/ansible-modules-core/pull/153
WORKDIR /opt/ansible/ansible/lib/ansible/modules/core
RUN git remote add patch https://github.com/woltage/ansible-modules-core.git && \
    git fetch -q patch                                                       && \
    git rebase 6375b0e976f38d41e5c81922b1d0471dad4e94f5

# 2B. Patches to apply to ansible/ansible-modules-core (v2)
# https://github.com/ansible/ansible-modules-core/pull/153
WORKDIR /opt/ansible/ansible/v2/ansible/modules/core
RUN git remote add patch https://github.com/woltage/ansible-modules-core.git && \
    git fetch -q patch                                                       && \
    git rebase 6375b0e976f38d41e5c81922b1d0471dad4e94f5

# default location for playbook
RUN mkdir /playbook
WORKDIR /playbook
