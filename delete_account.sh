#!/bin/bash
read -p "Quel utilisateur voulez-vous supprimer ? : " user;
htpasswd -D /etc/squid/db.users $user;