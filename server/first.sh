#!/usr/bin/env bash
./up.sh -clone -composer -env -key #first launch...
./exec.sh -clear
./exec.sh -db_refresh