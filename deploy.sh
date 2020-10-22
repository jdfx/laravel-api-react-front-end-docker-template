#!/usr/bin/env bash
printf "${GREEN}DEPLOYING TEST ENVIRONMENT${NC}\n"

chmod +x ./*.sh
git submodule update --init
chmod +x ./client/*.sh
chmod +x ./server/*.sh
cd client  && ./first.sh && cd ..
cd server  && ./first.sh && cd ..