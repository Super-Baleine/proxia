#!/bin/bash
read -p "Entrer le nom d'utilisateur que vous voulez créer : " $user;
htpasswd -B /etc/squid/db.users $user;