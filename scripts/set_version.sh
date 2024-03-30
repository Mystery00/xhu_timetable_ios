#!/bin/bash
gitVersionCode=$(git rev-list --count HEAD)
c="sed -E '4s/^version: ([0-9]+)\.([0-9]+)\.([0-9]+)\+[0-9]+/version: \1.\2.\3+$gitVersionCode/g' pubspec.yaml pubspec.yaml > temp.yaml"
eval $c
rm -f pubspec.yaml
mv temp.yaml pubspec.yaml
git add pubspec.yaml
git commit -m 'Update version code'