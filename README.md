# bm-tomato-adblock
===
### Description
Bloque les publicités par DNS (dnsmasq) dans un routeur tomato.


## 🚦 Copier les fichiers dans la partition JFFS (activez-la si ce n'est pas le cas)
- [X] /jffs/perso/adblock.sh
- [X] /jffs/perso/adblock_whitelist.sh

Pensez à rendre les fichiers exécutables (chmod +x) si partition de type Linux (inutile avec une clé USB en FAT32).

## Cron
Ajouter une tache dans http://tomato/admin-sched.asp (admin > scheduler)
- Time: 0:30
- Days : Everyday
- Command :
```
# AdBlock DNS by xhark
/bin/sh /jffs/perso/adblock.sh && /bin/sh /jffs/perso/adblock_whitelist.sh
```

### 🚀 Utilisation
**adblock.sh** : récupère les listes de fichiers host et injecte le tout dans dnsmasq.
Exemple de retour si exécution manuelle :
```
# /jffs/perso/adblock.sh
Download OK (200)
         Hosts file downloaded is valid (not empty)
         Copying file to /etc/dnsmasq/hosts/adblock_hosts_xhark
```

**adblock_whitelist.sh** : ajoute des exceptions de sites avec le préfixe "#" puis injecte le tout dans dnsmasq.
Exemple de retour si exécution manuelle :
```
# /jffs/perso/adblock_whitelist.sh


         === Whitelist looping in /tmp/etc/dnsmasq/hosts/adblock_hosts_xhark...

		*** ' site.a.exclure.tld' detected, adding : OK!
		*** 'analytics.google.com' detected, adding : OK!
		*** 'unautresite.com' detected, adding : OK!
		*** 'www.googleadservices.com' detected, adding : OK!
		*** 'twittercounter.com' detected, adding : OK!
		*** 'po.st' detected, adding : OK!
		*** 'adf.ly' detected, adding : OK!
		*** 'linkbucks.com' detected, adding : OK!
		*** 'analytics.twitter.com' detected, adding : OK!
		*** graph.accountkit.com

         > Whitelist modified, restarting dnsmasq
..
Done.

```
