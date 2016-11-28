Role Name
=========

A brief description of the role goes here.

Requirements
------------

Any pre-requisites that may not be covered by Ansible itself or the role should be mentioned here. For instance, if the role uses the EC2 module, it may be a good idea to mention in this section that the boto package is required.

Role Variables
--------------

### project/group_vars/all/ansible-project-creation.yml

This comes from the staging role and should be copied to `/group_vars/all/ansible-project-creation.yml`

```yaml

staging_server_dir : '{{ staging_project_root_path}}/stage-srv'

```

### roles/development/defaults/main.yml

```yaml
---
# defaults file for roles/development/defaults/main.yml

development_origin_master_repository: 'git@github.com:cjsteel/ansible-project-dev_ws.git'

development_user  : 'csteel'
development_group : '{{ development_user }}'
development_host  : 'localhost'
development_mode  : '0775'

projects_root_path           : '/home/{{ development_user }}/projects'
project_type                 : 'ansible' #'ansible' 					# ansible, nagios_plugins, website,...
project_group                : 'ace' 
project_name                 : 'dev_ws'
project_root_path           : '{{ projects_root_path }}/{{ project_type }}/{{ project_group }}/{{ project_name }}'

development_repository : '{{ project_root_path}}/dev-repo'

ensure_dir_on_hosts:

  dev_ws_development_host_dir:

    state       : "dir"
    user        : "{{ development_user }}"
    system      : "{{ development_host }}"
    path        : "{{ development_root_path }}"
    owner       : "{{ development_user }}"
    group       : "{{ development_user }}"
    mode        : "0644"
    recursive   : True
```

Dependencies
------------

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
