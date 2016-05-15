#!/bin/bash

#---------- CHECK THE RELEASE ----------
if [[ ! -e /etc/debian_version ]]; then
  echo "Sorry, but actually, this script can run only on Debian 7 or 8";
  exit 0;
fi
if [[ "$EUID" -ne 0 ]]; then
  echo "Sorry, you need to be root to install GnuPG";
  exit 0;
fi
#--

#---------- GENERAL ----------
read -p "What do you want to do ?
1) Install the proxy server
2) create an user
3) delete an user or all users
4) Unistall the proxy server
5) Leave the script" choice
if [[ $choice = "5" ]]; then
  echo "
  Bye bye ! x)";exit 0;
fi

#---------- CHOICE ----------
case $choice in
  "1")
    apt-get update;apt-get install squid -y;apt-get install apache2-utils -y;
    cp /etc/squid/squid.conf /etc/squid/squid.conf.backup;
    echo " " > /etc/squid/squid.conf
    IP=$(wget -qO- ipv4.icanhazip.com)
    read -p "Enter the port : " $port
    read -p "Enter the welcome message : " $welcome
    read -p "Do you want choose your hostname ? ('y' for 'yes')" $host_name
      if [[ $host_name = "y" ]]; then
        read -p "Enter your hostname : " $host_name
      else
        $host_name=$HOSTNAME
      fi
    echo "visible_hostname $host_name" >> /etc/squid/squid.conf
    echo "http_port $IP:$port" >> /etc/squid/squid.conf
    echo "cache_dir ufs /var/spool/squid 100 16 256" >> /etc/squid/squid.conf
    echo "acl all src all" >> /etc/squid/squid.conf
    echo "http_port $port" >> /etc/squid/squid.conf
    echo "auth_param basic program /usr/lib/squid/ncsa_auth /etc/squid/passwd" >> /etc/squid/squid.conf
    echo "acl utilisateurs proxy_auth REQUIRED" >> /etc/squid/squid.conf
    echo "http_access deny !utilisateurs" >> /etc/squid/squid.conf
    ##users
    read -p "User's name : " $user
    read -p "Password : " $pass
    htpasswd -c -b /etc/squid/passwd $user $pass
    ;;
  "2")
    read -p "User's name : " $user
    read -p "Set the password : " $pass
    htpasswd -b /etc/squid/passwd $user $pass
    ;;
  "3")
    read -p "User's name : " $user
    htpasswd -D /etc/squid/passwd $user
    ;;
  "4")
    echo -n "Really ? (y|n)";read $really
    if [[ $really = "y" ]]; then
      apt-get remove squid;apt-get autoremove;apt-get purge;
    fi
    ;;
  *)
    echo "Don't know...";
    exit 0;
    ;;
esac
echo "Finished !
You can run the script again to create more user or delete some users.";
exit 0;