#!/bin/sh
# hapus folder .git
rm -rf .git

#
git init
git add .
echo '_______________________'
echo masukan pesan/commit:
read input
git commit -m "$input $(date '+%n |%d/%m/%Y %H:%M %Z|')"
git branch -M main
git remote add origin https://agp-id@github.com/agp-id/dots.git
git push -f origin main
