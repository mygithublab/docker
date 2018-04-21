#!/bin/bash

docker build -t mygithublab . 
docker rm -f mygithublab 
docker run -itd -p 8000:80 -p 8001:22 --name mygithublab -v /mnt:/mnt --restart=always mygithublab
