#!/bin/bash
#------------- GLOBAL -----------------------#
read -p "Entrer votre port d'écoute : " port;
read -p "Message d'authentification : " welcome;
echo "Téléchargement et installation du logiciel...";sleep 3s;

#------ INSTALL ----------------------------------#
apt-get update;apt-get install squid -y;
cp /etc/squid/squid.conf /etc/squid/squid.conf.backup;

# --------------- CONFIGURATION --------------------#
echo "Configuration...";
echo visible_hostname $HOSTNAME > /etc/squid/squid.conf;
echo "cache_access_log none" >> /etc/squid/squid.conf;
echo "###ACL###" >> /etc/squid/squid.conf;
echo "acl all src sll" >> /etc/squid.conf;
echo http_port $port >> /etc/squid/squid.conf;
echo "#Programme d'authentification" >> /etc/squid/squid/conf;
echo "auth_param basic program /usr/lib/squid/ncsa_auth /etc/squid/db.users" >> /etc/squid/squid.conf;
echo "acl access_authorized proxy_auth REQUIRED" >> /etc/squid/squid.conf;
echo auth_param basic realm $welcome >> /etc/squid/squid.conf;
echo "http_access deny !access_authorized" >> /etc/squid/squid.conf;
echo "auth_param basic credentialsttl 2 hours" >> /etc/squid/squid.conf;
echo "auth_param basic children 1" >> /etc/squid/squid.conf;
echo "##END CONFIG##" >> /etc/squid/squid.conf;
echo Fin de la configuration...
echo Création du fichier des utilisateurs...
read -p "Entrer votre un nom d'utilisateur : " user;
htpasswd -c -B /etc/squid/db.users $user;
/etc/init.d/squid restart;
echo "Configuration terminé !";