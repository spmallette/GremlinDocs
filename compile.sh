#!/bin/bash

curl -v -X POST -d name=GremlinDocs -d repo=spmallette%2FGremlinDocs -d travis=false -d issues=false -d google_analytics=UA-34936244-1 -d twitter=spmallette --data-urlencode content@README.md http://documentup.com/compiled > index.html && open index.html

mv index.html /tmp
git checkout gh-pages
git fetch origin
git merge origin/gh-pages
mv /tmp/index.html ./

git commit -a -m 'regenerate'
git push origin gh-pages
git checkout master

