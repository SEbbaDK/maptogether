#!/bin/sh
dart pub get
dart run build_runner build
dart test test/* --reporter expanded --chain-stack-traces
