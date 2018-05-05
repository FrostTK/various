#!/bin/sh

RED='\033[0;31m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
WHITE='\033[0m'

if [ $(id -u) != 0 ]; then
    echo "${BLUE}Ce script doit être lancé en tant que root !${WHITE}"
    exit
fi

ip=$(LANG=c ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}' | tee /dev/tty)

if [ -z $ip ]; then
    ip=$(LANG=c ifconfig venet0:0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}' | tee /dev/tty)
fi

clear
echo "${BLUE}------------------------${WHITE}"
echo "${WHITE}Installation de divers serveurs (au choix)"
echo "${WHITE}Par Guillaume =)"
echo "${BLUE}------------------------${WHITE}"

sleep 3
 
echo "${BLUE}Mise à jour des packets${WHITE}"
apt-get update
apt-get upgrade

clear

echo "${BLUE}Que souhaitez-vous installer :${WHITE}"
echo "${WHITE}1 - Serveur TeamSpeak 3"
echo "${WHITE}2 - Serveur Minecraft"
echo "${WHITE}3 - Serveur Web"
echo "${WHITE}4 - Rien (quitter)"
read repC

if [ $repC = "4" ]; then
    echo "${RED}Ok ! A la prochaine !${WHITE}"
    sleep 2
    exit
fi

if [ $repC = "1" ]; then
    echo "${RED}Lancement de l'installation du serveur TeamSpeak 3.${WHITE}"
    sleep 2
    echo "${BLUE}Téléchargement et décompression de l'archive du serveur TeamSpeak.${WHITE}"
    sleep 2
    cd /home
    wget http://dl.4players.de/ts/releases/3.0.10.3/teamspeak3-server_linux-amd64-3.0.10.3.tar.gz
    tar -xvzf teamspeak3-server_linux-amd64-3.0.10.3.tar.gz
    rm teamspeak3-server_linux-amd64-3.0.10.3.tar.gz
    mv teamspeak3-server_linux-amd64 teamspeak3-server
    sleep 1
    echo "${WHITE}Redirection vers le dossier créé."
    cd teamspeak3-server/
    echo "${RED}Démarrage du serveur, copiez bien ce qui va vous être affiché !${WHITE}"
    echo "${RED}Ca ne sera affiché qu'une seule fois !${WHITE}"
    sleep 5
    chmod +x ts3server_startscript.sh
    ./ts3server_startscript.sh start
fi

if [ $repC = "3" ]; then
    echo "${BLUE}Installation de apache2...${WHITE}"
    sleep 3
    apt-get install apache2
    sleep 5
    echo "${RED}Installation terminée, installation de MySQL & PhpMyAdmin...${WHITE}"
    sleep 3
    apt-get install mysql-server
    echo "${RED}Installation de MySQL terminée, installation de PhpMyAdmin${WHITE}"
    sleep 3
    apt-get install phpmyadmin
    ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
    apt-get install php5-mysql
    service apache2 restart
    echo "${WHITE}Site web disponible à : ${BLUE}http://$ip/${WHITE}"
    echo "${WHITE}PhpMyAdmin disponible à : ${BLUE}http://$ip/phpmyadmin${WHITE}"
fi


if [ $repC = "2" ]; then
    echo "${RED}Installation de Java...${WHITE}"
    apt-get install default-jre
    sleep 2
    echo "${BLUE}Installation du serveur Minecraft...${WHITE}"
    sleep 5
    cd /home
    mkdir minecraft-server
    cd minecraft-server
    echo "${RED}Lien vers le spigot.jar pour votre serveur Minecraft...${WHITE}"
    echo "${RED}Le .jar doit obligatoirement être nommé spigot.jar !${WHITE}"
    read repMC
    wget $repMC
    touch eula.txt
    echo "eula=true" >> eula.txt
    touch start.sh
    echo "java -Xms512M -jar spigot.jar" >> start.sh
    chmod +x start.sh
    echo "${GREEN}Démarrage du serveur Minecraft...${WHITE}"
    sleep 2
    ./start.sh
fi
