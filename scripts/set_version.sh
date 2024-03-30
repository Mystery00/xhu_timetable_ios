#!/bin/bash
gitVersionCode=$(git rev-list --count HEAD)
c="perl -i -pe 's/^(version:\s+\d+\.\d+\.)(\d+)(\+)(\d+)$/\$1.\$2.\$3.$gitVersionCode/e' pubspec.yaml
eval $c
git add pubspec.yaml
git commit -m 'Update version code'