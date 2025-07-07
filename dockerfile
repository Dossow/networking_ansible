FROM python:3.10-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        sshpass \
        iputils-ping \
        openssh-client \
        libffi-dev \
        libssl-dev \
        build-essential && \
    pip install --no-cache-dir \
        ansible \
        paramiko \
        ansible-pylibssh \
        netmiko && \
    ansible-galaxy collection install cisco.ios && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/ansible
COPY . /opt/ansible
