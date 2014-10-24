# Docker image of Ansible with patches applied to it
# --------------------------------------------------
 
FROM            ansible/centos7-ansible:devel
MAINTAINER      Misho Krastev <misho.kr@gmail.com>

# Git configuration
RUN git config --global user.email "you@example.com"    && \
    git config --global user.name "Your Name"

# Ansible installation folder
WORKDIR /opt/ansible/ansible

# Patches to be applied
RUN git remote add patch https://github.com/woltage/ansible.git && \
    git fetch -q patch                                          && \
    git rebase 3a229eb1e97b50326a41e2a603379d07dec481dc && \
    git rebase 3a229eb1e97b50326a41e2a603379d07dec481dc
