#!/bin/bash
cd <path>
git pull

cd configurator-ui
pub get
pub build
docker stop pcbuilder-frontend
docker rm pcbuilder-frontend
docker build -t pcbuilder/frontend .
docker run --name "pcbuilder-frontend" -d -e "BACKEND_ADDRESS=<>" -p 80:80 -t pcbuilder/frontend
