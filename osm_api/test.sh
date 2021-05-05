#!/bin/sh
dart pub get
./build.sh
dart test test/* --reporter expanded
