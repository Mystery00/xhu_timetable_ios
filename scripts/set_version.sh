#!/bin/bash
gitVersionCode=$(git rev-list --count HEAD)
c="sed '4s/.*/version: 1.0.0+'$gitVersionCode'/' pubspec.yaml > temp.yaml"
eval $c
rm -f pubspec.yaml
mv temp.yaml pubspec.yaml
git add pubspec.yaml