#!/bin/bash
# set -x

IP=$1
LOC=$2 
HTBfolder="htb"

command -v nmap >/dev/null 2>&1 || { echo >&2 "This tool requiers nmap. Install and run again.  Aborting."; exit 1;}
command -v figlet >/dev/null 2>&1 ||
while true; do
    read -p "This tool requires figlet, do you wish to install this program? " yn
    case $yn in
        [Yy]* ) sudo apt install figlet  -y; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "Start creating the enviroment for"
figlet HackTheBox
figlet -c $LOC

[ -d ~/$HTBfolder ] && echo "Directory ~/$HTBfolder already exists" || mkdir ~/$HTBfolder
[ -d ~/$HTBfolder/$LOC ] && echo "Directory ~/$HTBfolder/$LOC already exists" || mkdir -p ~/$HTBfolder/$LOC/{tools,scans,logs,evidence/{credentials,data,screenshots}} && echo "Directory structure created"
# echo "Directories created"

echo "Check open ports.....just wait"
ports=$(nmap -p- --min-rate=1000 -T4 $IP | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//)
echo "Start nmap scan....just wait again"
nmap -p$ports -sC -sV $IP | tee ~/$HTBfolder/$LOC/scans/nmap.result
echo "nmap Report Complete: ~/$HTBfolder/$LOC/nmapresult"

echo "Putting rules to host file, need sudo"
sudo -- sh -c -e "echo $IP $LOC.htb www.$LOC.htb admin.$LOC.htb >> /etc/hosts"
echo "Added $LOC.htb on $IP to /etc/hosts"

echo Notes for HTB machine : $LOC > ~/$HTBfolder/$LOC/$LOC.notes
echo  >> ~/$HTBfolder/$LOC/$LOC.notes
echo "Notes file created ~/$HTBfolder/$LOC/$LOC.notes"

echo "Happy Hacking by"
figlet r03n

cd ~/$HTBfolder/$LOC
exec bash
