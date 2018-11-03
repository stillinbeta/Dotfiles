#!/bin/bash

set -o pipefail

if [[ -z "$1" ]]; then 
	echo "please specify a branch!" >&2
	exit 1
fi

cd $HOME

KEYFILE=$HOME/.ssh/id_rsa

if [[ ! -e $KEYFILE ]]; then
    ssh-keygen -t rsa -f $KEYFILE -N '' -q || exit 1
fi
echo
cat ${KEYFILE}.pub
echo

echo "Please upload the new public key to github."
read -p "Press enter to continue" -n 1 -r

if [[ ! -d $HOME/.git ]]; then
    git clone --bare git@github.com:stillinbeta/dotfiles.git /tmp/dotfiles || exit 1
    mv /tmp/dotfiles $HOME/.git || exit 1
    git config core.bare false || exit 1
    git checkout $1 || exit 1
    git reset HEAD --hard || exit 1
fi

if [[ -d $HOME/ansible ]]; then
    echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" | sudo tee /etc/apt/sources.list.d/sources.list >/dev/null || exit 1
    sudo apt-get update || exit 1
    sudo apt-get install ansible || exit 1
    ansible-playbook ansible/playbook.yaml || exit 1
fi
	

