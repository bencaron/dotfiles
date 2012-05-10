#! /bin/sh
php_packages=`dpkg -l | grep php | awk '{print $2}'`

sudo apt-get remove $php_packages

sed s/lucid/karmic/g /etc/apt/sources.list | sudo tee /etc/apt/sources.list.d/karmic.list

sudo mkdir -p /etc/apt/preferences.d/

for package in $php_packages;
do echo "Package: $package
    Pin: release a=karmic
    Pin-Priority: 991
    " | sudo tee -a /etc/apt/preferences.d/php
done

sudo apt-get update

sudo apt-get install $php_packages
