#!/usr/bin/env bash

chmod 400 tictactoe-ubuntu-keypair.pem
ssh -i tictactoe-ubuntu-keypair.pem ubuntu@18.222.151.48 "
  cd emmanuel_tictactoe_webAPI
  git pull origin
  sudo docker-compose down
  sudo docker-compose build
  sudo docker-compose up"
