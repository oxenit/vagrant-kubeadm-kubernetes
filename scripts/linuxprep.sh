#! /bin/bash
sudo sed -i 's|http://us.|http://|g' /etc/apt/sources.list
sudo apt update -y
