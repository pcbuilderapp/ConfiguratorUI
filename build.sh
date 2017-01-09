#!/bin/sh
pub get
pub build
docker build -t pcbuilder/frontend .
