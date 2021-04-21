#!/bin/sh
dart pub get
dart run build_runner build
dart test --reporter expanded
