#!/bin/sh
docker run -d -e "BACKEND_ADDRESS=<address-of-backend>" -p 8080:80 -t pcbuilder/dashboard
