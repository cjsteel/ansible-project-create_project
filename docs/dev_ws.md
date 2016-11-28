# file: dev_ws.yml
#
# dev_ws playbook

## ensure for our local directoriedevelopment root directory

mkdir -p /home/<username>/projects/ansible/ace/dev_ws/dev

### Clone our central/development repository

cd /home/<username>/projects/ansible/ace/dev_ws/dev
git clone git@github.com:<username>teel/ansible-project-dev_ws.git dev-repo

### add a new file

cd /home/<username>/projects/ansible/ace/dev_ws/dev/dev-repo
echo "this project is currently being development" >> README.md
git add README.md

Do **not** commit just yet!

# Create our post-commit hook

    nano .git/hooks/post-commit

### Content example

Make sure to use absolute (full) paths in your hook file, things do not work as you might expect them to.

```yaml

#!/bin/bash
git push origin master
unset GIT_INDEX_FILE
git --work-tree=/home/<username>/projects/ansible/ace/dev_ws/stage/stage-srv --git-dir=/home/<username>/projects/ansible/ace/dev_ws/dev/dev-repo/.git checkout -f

```

### ensure hook is executable

As this is a bash script so we need to make it executable (other script types are allowed as well):

```shell

chmod +x .git/hooks/post-commit

```

### ensure for your target staging directory

```shell

mkdir -p /home/<username>/projects/ansible/ace/dev_ws/stage/stage-srv

```

#### if web server

```shell

sudo chown -R `whoami`:`id -gn` /home/<username>/projects/ansible/ace/dev_ws/stage/stage-srv

```
### commit your changes and confirm

```shell

git commit -m "automated deploy from our development repository to our stageing directory"

```

#### Confirm our central repository

```shell

curl -O https://github.com/<username>teel/ansible-project-dev_ws/blob/master/README.md /tmp/README.md
cat /tmp/README.md | grep README.md

```

### Confirm our staging (or deployment) directory

You should see the file you added to your development repository in your staging directory now...

```shell

    ls -al /home/<username>/projects/ansible/ace/dev_ws/stage/stage-srv | grep README.md

```

# Using a git hook to deploy to a remote production Server

## Requirements

### git

```shell

    ssh <production_server_username>@<production_server>
    sudo apt-get install git

```

### Other server configuration

* install and configure firewall
* install and configure server applications (apache / ansible)

## create a production repository

Note this directory should be in the remote users home directory.

```shell

ssh to server
mkdir -p /home/<username>/projects/ansible/ace/dev_ws/prod
cd /home/<username>/projects/ansible/ace/dev_ws/prod
git init --bare prod-repo

```

#### example output

    Initialized empty Git repository in `/home/<username>/projects/ansible/ace/dev_ws/prod-repo/`

#### Important note

Since this is a bare repository and therfore has no working directory, all of the files found in the .git directory in a standard repository are found in the main directory of our bare repository.

### confirm

```shell

ll prod-repo

```

## Create our post-receive hook

```shell

    nano prod-repo/hooks/post-receive

```

### Content example

```shell

#!/bin/bash
while read oldrev newrev ref
do
    if [[ $ref =~ .*/master$ ]];
    then
        echo "Master ref received.  Deploying master branch to production..."
        git --work-tree=/home/<username>/projects/ansible/ace/dev_ws/prod/prod-srv --git-dir=/home/<username>/projects/ansible/ace/dev_ws/prod/prod-repo/ checkout -f
    else
        echo "Ref $ref successfully received.  Doing nothing: only the master branch may be deployed on this server."
    fi
done

```

### make script executalbe

```shell

    chmod +x prod-repo/hooks/post-receive

```

### ensure for our production servers directory

```shell

    mkdir -p /home/<username>/projects/ansible/ace/dev_ws/prod/prod-srv

```
#### for www servers you may need to do something like this:

```shell

sudo chown -R `whoami`:`id -gn` /home/<username>/projects/ansible/ace/dev_ws/prod/prod-srv

```
# On the local workstation

```shell

    cd /home/<username>/projects/ansible/ace/dev_ws/dev/dev-repo

```

## add production remote

```shell

git remote add production <username>@localhost:/home/<username>/projects/ansible/ace/dev_ws/prod/prod-repo

```

## add ROADMAP.md and commit

```shell

echo "file: ace/dev_ws/prod/prod-repo/ROADMAP.md" > ROADMAP.md
git status
git add ROADMAP.md
git status
git commit -m 'autodeploying ROADMAP.md '
git status

```

### confirm the changes

* staging directory

```shell

ls -al /home/<username>/projects/ansible/ace/dev_ws/stage/stage-srv | grep ROADMAP.md

```

#### if web server on localhost

    http://localhost/
    
## Try to push the master repositories master branch out to our production server:

```shell

cd /home/<username>/projects/ansible/ace/dev_ws/dev/dev-repo
git push production master

```

## Confirm your push changes

Did it work?

```shell

ssh server_user@server_ip

```
### is it in the development repository?

```shell

    ls -al /home/<username>/projects/ansible/ace/dev_ws/dev/dev-repo | grep ROADMAP.md
    ls -al /home/<username>/projects/ansible/ace/dev_ws/stage/stage-srv | grep ROADMAP.md
    ls -al /home/<username>/projects/ansible/ace/dev_ws/prod/prod-srv | grep ROADMAP.md

```

## sign out of remote server

If your server is remote, sign exit now

```shell

exit

```

# Branch example

## Create a test_feature branch and add a new file

```shell

cd /home/<username>/projects/ansible/ace/dev_ws/dev/dev-repo
git checkout -b test_feature

```
### add documentation to our project

```shell

    mkdir docs
    echo "# file: ace/dev_ws/dev/dev-repo/docs/using-and-testing-git-hooks.md"> docs/using-and-testing-git-hooks.md
    git add docs/using-and-testing-git-hooks.md
    git commit -m "added doc about using and testing git hooks"

```

#### check devlopment repository and our staging directory

```shell

    ll /home/<username>/projects/ansible/ace/dev_ws/dev/dev-repo/docs | grep using-and-testing-git-hooks.md
    ll /home/<username>/projects/ansible/ace/dev_ws/stage/stage-srv/docs | grep using-and-testing-git-hooks.md

```

##  lets try to push to our production server

```shell

    git push production test_feature

```
### output example

Notice the **Doing nothing: only the master branch may be deployed on this server.**. This mean our hook is working.

here we see that our push did not result in any change to our production server, exactly what we want!

## versioning

#
# Create or calculate our version file.
#
# format: <major>.<minor>.<patch>-b<build>
#
# if VERSION does not exist then:

```shell

echo "" > VERSION
MAJOR=0
    MINOR=0
    PATCH=0

```

# if VERSION does exits

Calculate our version

# get faux build number

```shell

    BUILD=`git rev-list HEAD | wc -l`
    echo $BUILD

```

## Create our version tag.

```shell

    VERSION=v${MAJOR}.${MINOR}.${PATCH}-b${BUILD}
    echo $VERSION
    echo ${VERSION} >> VERSION
    
    git tag -a ${VERSION} -m "Creating the first official version."
    git show v0.0.0-b15
    echo ${VERSION} > VERSION

```

### ## merging

Once we have tested the changes made using the test_feature branch check out our master branch and merge in our test_feature branch:

```shell

    git checkout master
    git merge --no-ff -m "tagging ${VERSION} and deploying lastest docs versions" test_feature

```

* We use the `--no-ff` (no fast forward) in order to ensure that we keep our repositories entire history.

### push our changes

Then we push our new feature(s) the production repositories master branch:

```shell

    git push production master

```
#### Output example

Look for **Deploying master branch to production...** in yor output.

```shell

    Total 0 (delta 0), reused 0 (delta 0)
    remote: Master ref received.  Deploying master branch to production...
    To <username>@localhost:/home/<username>/projects/ace/dev_ws/prod
       bdeb65a..79fa113  master -> master

```

### confirm production server directory

If your production server is on a remote connect via ssh:

```shell

    ssh <production_server_user>@

```
 
run something like:

```shell

ll /home/<username>/ansible_srv_root/ace/dev_ws/prod

```

alternativly for web projects and websites:

```shell

    ll /var/www

```

## Workflow

Once everything is set up your workflow will go something like this. 

* Create a new feature branch if you have not already done so.

```shell

git branch -b my_new_feature

```

* Checkout your feature branch if you have not already done so.

```shell

git checkout my_new_feature

```
* code!

* commit (and automatically push to originp

This way everyone will see what it is that you are working on.

### development cycle

* pull
* make change(s)
* commit, which automatically:
    * `git push origin master`
    * deploys code to the **staging server directory**
* test staging
* repeat as required until code is ready to deploy to production.

### deploy to production

Once you have a solid new feature that is well tested and working just fine you will want to push it into production.

* tag
* add
* commit
* push to origin

    `git push origin master`

* push to production

    `git push production master`


