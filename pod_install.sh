#!/bin/bash
rm -rf build
rm -rf ios/Pods
rm ios/Runner/GeneratedPluginRegistrant.h
rm ios/Runner/GeneratedPluginRegistrant.m
cd ios
pod install
cd ..
flutter pub get