#!/bin/sh
###########################################
# Télécharge une liste de sites à bloquer dans dnsmasq
###########################################
# auteur 		: Mr Xhark (blogmotion.fr)
# inspiré de 	: https://tuxicoman.jesuislibre.net/2016/10/bloquer-les-publicites-et-traqueurs-au-niveau-du-dns-avec-unbound.html
# licence type	: Creative Commons Attribution-NoDerivatives 4.0 (International)
# licence info	: http://creativecommons.org/licenses/by-nd/4.0/
VERSION="2018.11.20"
###########################################

# chemin stockage: /jffs/perso/adblock_whitelist.sh

# conf dnsmasq est dans:  /tmp/etc/dnsmasq.conf
# directive en question: addn-hosts=/etc/dnsmasq/hosts
# logger écrit dans: /tmp/var/log/messages
# remplacer dash par sh: dpkg-reconfigure dash
# voir le shell: echo $SHELL

### VARIABLES ###
URL="https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"	# fichier host (cf https://github.com/StevenBlack/hosts)
ADB_FILE="/tmp/mnt/CLE1GO/tmp/tmp.adblock_hosts.txt"					# host stocké sur la clé
DNSMASQ_FILE="/etc/dnsmasq/hosts/adblock_hosts_xhark"
AGENT="Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36"

### SCRIPT ###
[[ 1 ]] 2>/dev/null && echo || (echo "This script is not compatible with dash, please run: dkpg-reconfigure dash" && exit 1)

# code HTTP
CODE_HTTP=$(curl -I --insecure $URL 2>/dev/null | head -n 1 | cut -d$' ' -f2)

# Check du code HTTP retourné
if [ "$CODE_HTTP" != "200" ]; then
		echo -e "\n\t Download failed : HTTP CODE ${CODE_HTTP}"
		logger -t "xhark-ADB" "CODE HTTP INVALIDE: ${CODE_HTTP} (adblock.sh by xhark)"
		exit 0
	else
		echo -e "\n\t Download OK (${CODE_HTTP})"
fi

curl --silent --user-agent "$AGENT" --insecure -L ${URL} > ${ADB_FILE}

if [ -s ${ADB_FILE} ];then
		echo -e "\t Hosts file downloaded is valid (not empty)"
		echo -e "\t Copying file to ${DNSMASQ_FILE}"
		cp ${ADB_FILE} ${DNSMASQ_FILE}
		#service dnsmasq restart # pas de restart car le script adblock_whitelist.sh s'en charge ensuite
	else
		# fichier vide, donc on stop
		echo -e "\t ERROR: the downloaded file is empty !"
		logger -t "xhark-ADB" "ERREUR: Le fichier téléchargé est vide! (adblock.sh by xhark)"
		exit 1
	fi

echo && exit 0