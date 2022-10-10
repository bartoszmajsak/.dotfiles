#!/bin/bash

if ! command -v asdf &> /dev/null
then
    echo "asdf not found - installing"
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.2
fi

. $HOME/.asdf/asdf.sh


if ! command -v gvm &> /dev/null
then
    echo "gvm not found - installing"
    bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
fi


if ! command -v docker &> /dev/null
then
    echo "docker not found - installing"
    sudo dnf -y install dnf-plugins-core
    sudo dnf config-manager \
        --add-repo \
        https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install docker-ce docker-ce-cli containerd.io docker-compose-plugin
fi


if ! command -v rvm &> /dev/null
then
    echo "rvm not found - installing"
    curl -sSL https://get.rvm.io | bash -s stable
fi


if ! command -v nvm &> /dev/null
then
    echo "nvm not found - installing"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
fi
