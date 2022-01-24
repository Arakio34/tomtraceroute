---
title: Script 
author: TUELEAU Tom
---

# Utilisation du script traceroute.sh 

    ./traceroute.sh -h
    Page d'aide.
    ##########################
          Option d'aide
    ##########################
    Utilisation :
      sudo ./traceroute [OPTION] ...

    Options :
      -f :                  Permet de de passer un fichier en option.
      -h :                  Affiche la page d'aide.
      -u :                  Cette option permet de specifier une URL/IP.
      -a :                  Cette option permet d'utiliser la liste des URL/IP de base.

    Exemples :
      sudo ./traceroute -f url.ls
      sudo ./traceroute -u www.perdue.com

    url.ls :
      www.google.com
      www.perdue.com
      www.iutbeziers.fr
      www.youtube.com
    ##########################



