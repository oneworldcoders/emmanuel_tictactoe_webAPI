#!/usr/bin/env bash

ssh-keyscan -H 18.222.151.48 >> ~/.ssh/known_hosts

printenv PRIVATE_KEY >> /tmp/keypair.pem
chmod 600 /tmp/keypair.pem
ssh -i /tmp/keypair.pem ubuntu@18.222.151.48 "
  cd emmanuel_tictactoe_webAPI
  git pull origin
  sudo docker-compose down
  sudo docker-compose build
  sudo docker-compose up -d"

rm /tmp/keypair.pem
