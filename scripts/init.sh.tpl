#!/bin/bash

cd /home/ubuntu/app
export DB_HOST=${db_host}
. ~/.bashrc
node seeds/seed.js
pm2 stop app.js
npm install
pm2 start app.js
