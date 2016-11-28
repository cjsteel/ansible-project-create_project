git pull

cd {{ development_repository }}
echo "create_project test" >> README.md
git add README.md
git commit -m 'create_project test'

check staging 
cat {{ staging_server_dir }}/README.md | grep "create_project test"

## check production

git push production master
cat {{ production_server_dir }}/README.md | grep "create_project test"

## check origin

git push origin master

