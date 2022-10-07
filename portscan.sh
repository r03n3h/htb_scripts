#!/bin/bash
# set -x

IP=$1

echo "Check open ports.....just wait"
ports=$(nmap -p- --min-rate=1000 -T4 $IP | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//)

echo "Start nmap scan....just wait again"
nmap -p$ports -sC -sV $IP 
