Keep feature branch up to date:

git checkout develop
git pull
git checkout feature/foo 
git merge develop 
git push



Undo last merge 
 git revert -m 1 <merge-commit-hash>


Merge release to master 
git pull
git checkout master
git merge <releaseBranch-tag>


Pull latest changes from development to my feature local branch

git checkout development
git pull
git checkout feature/mybranch
git merge development


Create IdentityServer4 certificate in Atribo core 
  1.  openssl genrsa -out privatekey.key 4096 -sha256
  2.  openssl req -sha256 -new -key privatekey.key -out certrequest.csr
  3.  openssl x509 -req -sha256 -days 2555 -in certrequest.csr -signkey privatekey.key -out certrequest.crt
  4.  openssl pkcs12 -export -out certificate.pfx -inkey privatekey.key -in certrequest.crt
