#!/bin/bash

echo 
git status && git add . && git commit -a -m `date +%Y%m%d%H%M%S` && git push
