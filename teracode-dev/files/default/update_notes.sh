#!/usr/bin/env bash

cd /www/notes/current; svn update
cd /www/notes/current/www/js/notes && ./js apps/notebook/compress.js
