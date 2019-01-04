#!/bin/sh
###########################################
# Exclus certains sites du fichier adblock custom de dnsmasq
###########################################
# auteur 		: Mr Xhark (blogmotion.fr)
# licence type	: Creative Commons Attribution-NoDerivatives 4.0 (International)
# licence info	: http://creativecommons.org/licenses/by-nd/4.0/
VERSION="2018.11.20"
###########################################

### VARIABLES ###
ADFILE="/tmp/etc/dnsmasq/hosts/adblock_hosts_xhark"
WHITELIST="site.a.exclure.tld
analytics.google.com
unautresite.com
www.googleadservices.com
twittercounter.com
po.st
adf.ly
linkbucks.com
analytics.twitter.com
graph.accountkit.com
"
### FUNCTIONS ###
AddDomain() {
	site="$1"
	site0="0.0.0.0 $1"
	siteComm="#0.0.0.0 $1"
	list="$2"
	
	verbose=true
	bool=true
	alrComm=true

		# version plus simple pour le grep:
		#if grep -q -F 'max_usb_current=1' /boot/config.txt; then
		#	 echo "deja present"
		#else
		#	echo "pas encore present"
		#fi
	
	grep -q "$site0" ${list} > /dev/null 2>&1 || bool=false
	
	# Is the site present in the dnsmasq adblock list?
	if [[ "${bool}" == true ]]; then
		echo -ne "\n\t *** '${site}' detected"
		grep -q "^${siteComm}" ${list} > /dev/null 2>&1 || alrComm=false
		
		if [[ "${alrComm}" == false ]]; then
		# website already whitelisted ? if no comment, adding "#" to whitelist
			echo -ne ", adding : "
			sed -i "s/^${site0}/${siteComm}/" ${list} && echo -n "OK!" || echo -n " !!! ERREUR !!!"
			reload=true
		else
			echo -e ", but already whitelisted\n"
		fi
		
	fi
}

### SCRIPT ###
[[ 1 ]] 2>/dev/null && echo || (echo "This script is not compatible with dash, please run: dkpg-reconfigure dash" && exit 1)

echo -e "\n\t === Whitelist looping in ${ADFILE}..."

for URL in $WHITELIST
do
	#echo -e " valeur: $URL"
	AddDomain "${URL}" "${ADFILE}"
done

if [[ "$reload" == true ]]; then
	echo -e "\n\n\t > Whitelist modified, restarting dnsmasq" && service dnsmasq restart && exit 0
	echo -e "!!! ERROR : dnsmasq restart failed !!!"; exit 1
else
	echo -e "\n\n\t No change in whitelist, script exiting :)"
	echo
fi
