#!/bin/sh
dart pub get
dart test test/* --reporter expanded --chain-stack-traces
