# file: mr_register_all.sh
#
# Description:
#
#    Runs the command `mr register` in all subdirectories in order of precedence (abc123...).
#    * Only goes down one directory level.
#    * Any lower repositories ( ldap/templates ) must be manually registered.
#
# Usage
#
#     chmod +x mr_register_all.sh
#     ./mr_register_all.sh
#
# References and Alternatives:
#
# * [ run command all subdirectories ]( http://superuser.com/questions/44787/looping-through-subdirectories-and$
#
# (not sorted - not in order of ls)
#
#     find . -type d -name .git -execdir sh -c "mr register" \;
#
#
#     find . -maxdepth 1 -type d -name '*' -exec sh -c 'cd "{}" && pwd' \;
#
# ls -d */ | awk '{print $NF}' | xargs -n1 sh -c 'cd $0 && pwd && mr register'
# * [ run command all subdirectories ]( http://superuser.com/questions/44787/looping-through-subdirectories-and-running-a-command-in-each )
#
# Alternatives:
#
#     find . -maxdepth 1 -type d -name '*' -exec sh -c 'cd "{}" && pwd' \;
#     find . -type d -name .git -execdir sh -c "mr register" \;
#
# find . -maxdepth 1 -type d -name '*' -exec sh -c 'cd "{}" && pwd' \;
#
# This gives us an alphabetical listing in ~/.mrconfig
#
ls -d */ | awk '{print $NF}' | xargs -n1 sh -c 'cd $0 && pwd && mr register'

# register repository `ldap/templates` if it is installed
if [ -d ./ldap/templates ] ; then
    cd ldap/templates && pwd && mr register
fi
