# README.md

# ansible-project-create_project

## Status

* under development, works

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

## Create a github repository

### Derive your repository name

Derive your repository name based on the following scheme:

    project_type       : ansible
    project_subtype    : role
    project_short_name : rminc

These three variables give your the full name of your project, in this case:

    project_full_name  : ansible-role-rminc
you will use the projects full name as the **Repository Name** on github.

### Create your github repository

* Sign up and/or sign on to Github.

#### Create a new repository

**Note:** You only need to fill in the repository name as any other options will be overwritten.

* Enter the repositories full name in the **repository name** field.
* Select the **Create Repository** button at the bottom of the page.
* Do not clone this project, that will be done automatically for you later.

#### Setup your public ssh key

* Go to your repositories url, for example:

  ```shell
  https://github.com/cjsteel/ansible-role-rminc
  ```

* Choose **Settings** then **Deploy Keys**

* Git your deploy ke a title such as mary@marys_system

* Copy your public key `~/.ssh/id_rsa.pub`and paste it into the **Key** field.

* Check the **Allow write access** tick box

* Choose the **Add Key** button.

## ansible_project_create_project

* if you have not already done so clone **ansible_project_create_project** to your projects directory. In this example that would be `~/projects`.

## Setup and configuration

### Fork and then clone create_project

#### Fork

You probably want to fork the **create_project** repo using the github fork button. This way you can customize it to meet your particualr needs.

#### Clone

Clone your fork of create_project (using ssh and your SSH keypair) to your development system using something like this:

```shell
cd ~/projects
git clone git@github.com:cjsteel/ansible-project-create_project.git create_project
```



Now we will configure the version of **create_project** that you cloned in the above step

### Inventory

Configure your inventory

```shell
cd ~/projects/create_project
nano inventory/dev
```

#### content example

The following example is for testing so our controller, development, staging and production server are all located on localhost, the system where you are testing this project.

```ini
[controller]
localhost ansible_connection=local

[development]
localhost ansible_connection=local

[staging]
localhost ansible_connection=local

[production]
localhost ansible_connection=local
```

### project/group_vars/all

#### ensure for create_project/group_vars/all 

```shell
mkdir -p group_vars/all
```

#### ensure for `group_vars/all/create_project.yml`

```shell
cp templates/group_vars/all/create_project.yml group_vars/all/.
```

#### Customize your global variables

`group_vars/all/create_project.yml` contains variables that apply to all roles in **create_project**. Any variable values here will overide those contained elsewhere in the **create_project** project.

You will want to set the following variables in `group_vars/all/create_project.yml` to match your projects values. Here is an example:

```yaml
create_project_license_year    : '2017'
create_project_author          : 'Christopher Steel'
create_project_license         : 'MIT'

create_project_parent_dir      : 'parc'

# for project named "ansible-project-automa"

create_project_project_type    : 'ansible'
create_project_project_subtype : 'project'
create_project_project_name    : 'automa'
create_project_repo_long_name  : '{{ create_project_project_type }}-{{ create_project_project_subtype }}-{{ create_project_project_name }}'

# git

create_project_git_user        : 'cjsteel'
create_project_git_server      : 'github.com'
```

If you want to run against multiple hosts (dev, staging, production) you may want to make changes to  other variables and may need to make other adjustments to the scripts.

## Run your playbook

### activate your ansible environment

If you are running Ansible in a virtual / sandboxed Python environment activate it now

```shell
source activate ansible
```

Run your playbook

```shell
ansible-playbook systems.yml --ask-become-pass
```

## Testing results

Running the projects main playbook will run some tests as well. Testing results will be below this line:

