# file: creating new projects draft.md

## 

## template project LICENSE

mkdir templates
touch templates/license.j2
nano templates/license.j2

## Template .gitignore

touch templates/gitignore.j2
nano templates/gitignore.j2

### .gitignore content example

```
```

### Content Example

The MIT License (MIT)

Copyright (c)  {{ create_project_licence_year }} {{ create_project_author }}

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## Create development inventory

```shell

mkdir -p playbooks/inventory
touch playbooks/inventory/dev.yml
nano playbooks/inventory/dev.yml

```

### content example

```yaml

[create_project]
localhost

```

## Create directory structure

```shell

mkdir -p playbooks/create_project.yml
nano playbooks/create_project.yml

```

### content example

```yaml

# file playbooks/create_project.yml
- hosts: create_project.yml
  become: false

# Ensure for remote directories on our target host(s)

```yaml

---
# file: group_vars/create_project/create_project.yml

- name: ensure for remote directories
  file:
    state   : '{{ item.value.state   | default("directory") }}'
    path    : '{{ item.value.path    | default(mandatory) }}'
    owner   : '{{ item.value.owner   | default(omit) }}'
    group   : '{{ item.value.group   | default(omit) }}'
    mode    : '{{ item.value.mode    | default(omit) }}'
    recurse : '{{ item.value.recurse | default(omit) }}'
  with_dict: ensure_dirs_on_remote

# Ensure for local directories on our local system

- name: ensure for local directories
  delegate_to: 127.0.0.1
  file:
    state   : '{{ item.value.state   | default("directory") }}'
    path    : '{{ item.value.path    | default(mandatory) }}'
    owner   : '{{ item.value.owner   | default(omit) }}'
    group   : '{{ item.value.group   | default(omit) }}'
    mode    : '{{ item.value.mode    | default(omit) }}'
    recurse : '{{ item.value.recurse | default(omit) }}'
  with_dict: ensure_dirs_on_local

```
## 
