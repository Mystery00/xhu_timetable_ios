#!/bin/bash
gitVersionCode=$(git rev-list --count HEAD)
let gitVersionCode=gitVersionCode+1
c="sed -E '4s/^version: ([0-9]+)\.([0-9]+)\.([0-9]+)\+[0-9]+/version: \1.\2.\3+$gitVersionCode/' pubspec.yaml pubspec.yaml > temp.yaml"
echo "$c"
eval $c
rm -f pubspec.yaml
mv temp.yaml pubspec.yaml
git add pubspec.yaml