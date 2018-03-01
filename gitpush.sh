#!/bin/bash

echo on
git status && git commit -a -m `date +%Y%m%d%H%M%S` && git push
