################# Header: Define the base system you want to use ################
# Reference of the kind of base you want to use (e.g., docker, debootstrap, shub).
Bootstrap: docker
# Select the docker image you want to use (Here we choose tensorflow)
From: ubuntu:22.04

# Environment variables that should be sourced at runtime.
%environment
        # use bash as default shell
        export SHELL=/bin/bash
        export LANG=en_CA.UTF-8
        export LANGUAGE=en_CA:en
        export LC_ALL=en_CA.UTF-8
        export LANG=en_CA.UTF-8
        export LC_CTYPE=en_CA.UTF-8
        export ACLANTHOLOGY=/code/submodules/acl-anthology
        export PYTHONPATH+=:$ACLANTHOLOGY/bin

# Add files at build time
%files
        requirements.txt

################# Section: Defining the system #################################
# Commands in the %post section are executed within the container.
%post
        export DEBIAN_FRONTEND=noninteractive

        echo "Update apt packages"
        apt update -y

        echo "Setting locale"
        apt-get install -y locales tzdata git
        locale-gen en_CA.UTF-8
        dpkg-reconfigure locales
        echo "Canada/Eastern" > /etc/timezone
        dpkg-reconfigure -f noninteractive tzdata

        echo "Installing apt packages"
        apt-get update
        apt-get install -y curl \
                wget \
                unzip \
                software-properties-common \
                git \
                build-essential \
                bibtool \
                libxml-xpath-perl \
                texlive-full

        echo "Install python3.11.."
        apt install -y python3.11-dev python3.11-distutils python3.11-venv
        update-alternatives --install /usr/bin/python python /usr/bin/python3.11 1
        update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1

        echo "Create a python environment"
        python3 -m venv /opt/venv

        echo "Installing pip.."
        . /opt/venv/bin/activate && \
        curl -sS https://bootstrap.pypa.io/get-pip.py | \
        python3 && \
        update-alternatives --install /usr/local/bin/pip pip /usr/local/bin/pip3.11 1 && \
        update-alternatives --install /usr/local/bin/pip3 pip3 /usr/local/bin/pip3.11 1

        echo "Installing requirements.."
        . /opt/venv/bin/activate && \
        pip3 install --upgrade pip && \
        pip3 install -r requirements.txt

        echo "Creating mount points.."
        mkdir /dataset
        mkdir /tmp_log
        mkdir /final_log
