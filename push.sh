#!/bin/bash  
git add .
git commit -m "$*"
git branch -M main
git push -u origin main