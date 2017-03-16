# file: projects/ansible-create-project/README.md

# ansible-project-create_project

## Status

* under development still needs:

    * built in testing
    * var cleanup
    * field usage
    * Documentation

## Description

Sets up repositories for **development**, **staging** and **production** environments. This includes cloning the target (and existing repository) from Github under your user name.

## Requirements

### a Github repository

* a github account
* a repository you have wrtie acess to.
* a copy of your public key loaded added to the project.

### SSH Keys

You will want to have a good understanding of ssh keys and key pairs.

Using this role can required access to up to four system using ssh keypairs.

- your github repository
- your development system
- your staging system
- your production system
- and perhaps your Ansible controller if you access it remotely.

If you do not have a passphrase protected keypair you can generate one as follows:

```shell
ssh-keygen
```

### ssh agent and ssh-add

You will need to use ssh-agent and ssh-add in order to load your key identitie(s) to the authentication agent. This way you can connect to your target system(s) without needing to enter your passphrase each time.

```shell
eval `/usr/bin/ssh-agent`
/usr/bin/ssh-add -t 3H
```

### Inventory

Configure your inventory

```shell
nano inventory/dev
```

#### content example

Example for developing and testing locally.

```ini
[development]
localhost ansible_connection=local

[staging]
localhost ansible_connection=local

[production]
localhost ansible_connection=local
```

### project/group_vars/all

```shell
mkdir -p group_vars/all
cp templates/group_vars/all/create_project.yml group_vars/all/.
cat group_vars/all/create_project.yml
```

#### Customize global variables

If running everything locally you should at least change the following four variables in `group_vars/all/create_project.yml`:

```yaml
create_project_license_year: '2016'
create_project_author      : 'Christopher Steel'
create_project_license     : 'mit'
create_project_user        : 'cjs'
```

If you want to run against multiple hosts (dev, staging, production) you may want to make changes to  other variables and may need to make other adjustments to the scripts.

## Run your playbook

```shell
ansible-playbook systems.yml --ask-become-pass
```

## Testing results

Running the projects main playbook will run some tests as well. Testing results will be below this line:
Getting Started
===============


Ansible Controllers and Targets
-------------------------------

### user accounts

Ansible commands are executed on the Ansible Controller from an **unprivileged account** ``alice``. This user has an SSH key pair stored in ``~/.ssh/id_rsa`` or has its SSH key available in the SSH Agent. An **administrator account** with the same name will be created on the remote host during the bootstrap process.

### The Ansible Controller

An Ansible controller is a physical or virtual system (running Ansible) that is used to automate and/or orchestrate the configuration of one or more targeted hosts via host inventories. 

Ansible has a rapidly growing collection of included and community contributed modules and roles that allow users to target a wide array of systems running various flavours of Linux, OS X, UNIX as well as those running Windows. This includes the more traditional platforms such as PC's, Servers and virtual machines in addition to switches, firewalls and other hardware running embedded operating systems.

Most Ansible modules use idempotent commands which ensure that the host is left in a particular state.

Unlike the majority of configuration automation and orchestration systems Ansible Controllers tend  to push out configurations rather than having hosts pull configuraton from controllers although using Ansilbe to pull configuration information is quite easy to do as well.

Ansible only requires that targeted hosts run an SSH server and a version of Python 2.x


Debian parcs and DebOps
-----------------------

If your parc is limited to Debian based hosts I would highly recommend investigating the exstensive and excellent collection of Ansible scripts started by Maciej Delmanowski of the Medical University of Gdańsk.


Host Names
----------

Our script collection is used to target new workstations as well to maintain existing ones. As we currently do not have control of all of the DNS servers that we make use of we tend to avoid using fqdn to refer to them.

So rather than referring to a host as ``worstation-01.example.com`` we refer to it as ``worstation-01``.


Root or Sudo User
-----------------

Our bootstrap script requires that targeted systems have a root or sudo user with a password as well as an ssh server. For Debian based hosts you want setup the ssh server as follows:

   admin@ws-01:~$ sudo apt-get update
   admin@ws-01:~$ sudo apt-get install openssh-server

The ``admin`` account requires a password as SSH keys are not installed yet.


Requirements
------------


Create an Unprivledged user
---------------------------

On the Ansible controller we will create a regular user without sudo.

### Ubuntu

```shell
sudo adduser aadams
```


Install Requirements
--------------------

### miniconda

```shell
mkdir -p ~/sys/sw/linux/miniconda/64/
cd ~/sys/sw/linux/miniconda/64/
wget https://repo.continuum.io/miniconda/Miniconda2-4.2.12-Linux-x86_64.sh
# wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh
```

### Checksums

#### Get checksum of downloaded file

```shell
md5sum Miniconda2-4.2.12-Linux-x86_64.sh > md5sum-Miniconda2-4.2.12-Linux-x86_64.txt
cat md5sum-Miniconda2-4.2.12-Linux-x86_64.txt
```

#### Download checksums

```shell
curl -sL https://repo.continuum.io/miniccurl -L https://repo.continuum.io/miniconda/ | html2text -width 300  > md5sums.txt
```

#### Compare checksums

```shell
cat md5sums.txt | grep Miniconda2-4.2.12-Linux-x86_64.sh
cat md5sum-Miniconda2-4.2.12-Linux-x86_64.txt
```

### Install

bash Miniconda2-latest-Linux-x86_64.sh -b

### add to bashrc

```shell
# added by Miniconda2 4.2.12 installer
export PATH="/home/aadams/miniconda2/bin:$PATH"
```

### Test

Restart your terminal session then:

```shell
miniconda2/bin/conda list
```

## Create Ansible environment

This may take some time and requires an internet connection

```shell
ANSIBLE_VERSION=1.9.0.1
conda create -n ansible-$ANSIBLE_VERSION -c csteel ansible=$ANSIBLE_VERSION
```

### to activate

```shell
source activate ansible-1.9.0.1
```
### To deactivate

```shell
source deactivate

### Testing

​```shell

ansible --version
ansible 1.9.0.1
  configured module search path = None
```

### To list ansible versions available

```shell
anaconda search -t conda ansible
```

#### Output example

```shell
(ansible) cjs@automa:~/projects/ace$ anaconda search -t conda ansible
Using Anaconda Cloud api site https://api.anaconda.org
Run 'anaconda show <USER/PACKAGE>' to get more details:
Packages:
     Name                      |  Version | Package Types   | Platforms      
     ------------------------- |   ------ | --------------- | ---------------
     ActivisionGameScience/ansible |    1.7.2 | conda           | linux-64       
                                          : Radically simple IT automation
     AnneTheAgile/ansible      |    1.6.2 | conda           | osx-64         
                                          : Radically simple IT automation
     barnybug/ansible          |    1.7.1 | conda           | linux-64, osx-64
     bioconda/ansible          |    1.9.4 | conda           | linux-64, osx-64
                                          : Radically simple IT automation
     cgsanchez/ansible         |  2.0.0.2 | conda           | osx-64         
                                          : Radically simple IT automation
     cshowers/ansible          |  2.2.0.0 | conda           | linux-64       
     csteel/ansible            |  2.1.1.0 | conda           | linux-64, win-32, win-64, linux-32, osx-64
     equipoise/ansible         |    1.9.2 | conda           | osx-64         
                                          : Radically simple IT automation
     gonzo/ansible             |    1.9.2 | conda           | linux-64       
                                          : Radically simple IT automation
     hargup/ansible            |          | conda           | linux-64, noarch
                                          : Radically simple IT automation
     ijstokes/ansible          |  2.0.0.2 | conda           | osx-64         
                                          : Radically simple IT automation
     kalefranz/ansible         |    1.9.3 | conda           | linux-64       
     kbroughton/ansible        |  2.0.0.2 | conda           | linux-64, osx-64
                                          : Radically simple IT automation
     mck/ansible               |    1.7.2 | conda           | linux-64, osx-64
                                          : Radically simple IT automation
     miklophone/ansible        |    1.7.2 | conda           | osx-64         
                                          : Radically simple IT automation
     travis/ansible-shell      |    0.0.2 | conda           | linux-64       
                                          : https://github.com/dominis/ansible-shell
     wpb/ansible               |  2.1.1.0 | conda           | osx-64         
                                          : Radically simple IT automation
```

### Install a different version

```shell
 conda install -c csteel ansible=2.1.1.0
```

### Create an alias

```shell
touch  ~/.bash_aliases
nano  ~/.bash_aliases
```

#### add your alias

```shell
alias ansel1.9='source activate ansible-1.9.0.1'
alias stopansel1.9='source deactivate ansible-1.9.0.1'
```

#### source ~/.bash_aliases

```shell
. ~/.bash_aliases

# or

source ~/.bash_aliases
```


Creating an Ansible project
---------------------------

Begin by creating a project directory that will contains all of the data related to a given environment. This will include your Ansible inventory, Ansible password vault(s), custom playbooks and roles.

```shell

mkdir ~/projects/ace_testing
cd ~/projects/ace_testing

```

Install blank project

```shell

git clone https://github.com/csteel/project-ansible-ace.git

```

