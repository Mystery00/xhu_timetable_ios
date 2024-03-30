#!/bin/bash
gitVersionCode=$(git rev-list --count HEAD)
gitVersionName=$(git rev-parse --short=8 HEAD)
c="sed '4s/.*/version: 1.0.0+'$gitVersionCode'-'$gitVersionName'/' pubspec.yaml > temp.yaml"
eval $c
rm -f pubspec.yaml
mv temp.yaml pubspec.yaml
git add pubspec.yaml