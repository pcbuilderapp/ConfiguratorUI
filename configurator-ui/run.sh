#!/bin/sh
docker run -d -e "BACKEND_ADDRESS=http://pcbuilder.dreamlogics.com:8090" -p 9080:80 -t pcbuilder/frontend
