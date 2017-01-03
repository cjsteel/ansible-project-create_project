# README.md

## Requirements

### Write access to target repository.

The means you need to have a passphrase protected SSH key pair on the local system with the ssh key loaded in memory. You will want to do, or have done something like the following:

#### Setup SSH Keys

If you do not have a passphrase keypair generate one as follows:

```shell

ssh-keygen

```

Place a copy of your public key on the target git server

### ssh agent

Load you passphrase into memory:

```shell

exec /usr/bin/ssh-agent $SHELL
ssh-add -t 3H

```

### setup your host file

```shell

mkdir inventory
touch inventory/dev
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

### project/group_vars

#### create project/group_vars

Next create and generate contents of create_project/group_vars

```shell

mkdir -p group_vars/all
echo "---"                                                  > group_vars/all/create_project.yml
echo "# group_vars/all/create_project.yml"                  >> group_vars/all/create_project.yml
echo "#"                                                    >> group_vars/all/create_project.yml
echo "#"                                                    >> group_vars/all/create_project.yml
echo ""                                                     >> group_vars/all/create_project.yml
echo "create_project_license_year    : '2016'"              >> group_vars/all/create_project.yml
echo "create_project_author          : 'Christopher Steel'" >> group_vars/all/create_project.yml
echo "create_project_license         : 'mit'"               >> group_vars/all/create_project.yml
echo "create_project_user            : 'cjs'"               >> group_vars/all/create_project.yml
echo "create_project_accept_hostkey  : True"                >> group_vars/all/create_project.yml
echo "create_project_project_name    : 'acemenu'"           >> group_vars/all/create_project.yml
echo "create_project_shared_repo_url : 'git@github.com:cjsteel/ansible-role-acemenu.git'" \
        >> group_vars/all/create_project.yml
#echo "create_project_shared_repo_url : git@github.com:cjsteel/ansible-project-create_project.git'" \
#        >> group_vars/all/create_project.yml
echo "create_project_testing         : False"            >> group_vars/all/create_project.yml

echo ""                                                    >> group_vars/all/create_project.yml
cat roles/production/defaults/main.yml  | grep -v \\---    >> group_vars/all/create_project.yml
cat roles/staging/defaults/main.yml     | grep -v \\---    >> group_vars/all/create_project.yml
cat roles/development/defaults/main.yml | grep -v \\---    >> group_vars/all/create_project.yml
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
___

