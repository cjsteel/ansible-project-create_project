# README.md

## Preparation

### ansible logging

```shell
mkdir ../ace_ansible_logs
touch ../ace_ansible_logs/ansible.log
```
### project/group_vars

#### edit roles defaults/main.yml files

If you want to change your orinin master's defaults edit them now.

```shell
nano roles/production/defaults/main.yml
nano roles/staging/defaults/main.yml
nano roles/development/defaults/main.yml
```

#### create project/group_vars

Next create and generate contents of create_project/group_vars

```shell
mkdir -p group_vars/all
echo "---"                                              > group_vars/all/create_project.yml
echo "# group_vars/all/create_project.yml"              >> group_vars/all/create_project.yml
echo "create_project_licence_year: '2016'"              >> group_vars/all/create_project.yml
echo "create_project_author      : 'Christopher Steel'" >> group_vars/all/create_project.yml
echo ""                                                >> group_vars/all/create_project.yml
cat roles/production/defaults/main.yml  | grep -v \\--- >> group_vars/all/create_project.yml
cat roles/staging/defaults/main.yml     | grep -v \\--- >> group_vars/all/create_project.yml
cat roles/development/defaults/main.yml | grep -v \\--- >> group_vars/all/create_project.yml
cat group_vars/all/create_project.yml
```

Remove extraneous '---' as required

```shell
nano group_vars/all/create_project.yml
```

###


