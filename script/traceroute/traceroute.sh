#!/bin/bash

echo > dote.dot

function Help () {
	echo "##########################"
	echo "      Option d'aide"
	echo "##########################"
	echo "Utilisation :"
	echo "  sudo ./traceroute [OPTION] ..."
	echo ""
	echo "Options :"
	echo "  -f :                  Permet de de passer un fichier en option."
	echo "  -h :                  Affiche la page d'aide."
	echo "  -u :                  Cette option permet de specifier une URL/IP."
	echo "  -a :                  Cette option permet d'utiliser la liste des URL/IP de base."
	echo ""
	echo "Exemples :"
	echo "  sudo ./traceroute -f url.ls"
	echo "  sudo ./traceroute -u www.perdue.com"
	echo ""
	echo " url.ls :"
	echo "  www.google.com"
	echo "  www.perdue.com"
	echo "  www.iutbeziers.fr"
	echo "  www.youtube.com"
	echo "##########################"
}

function Predef () {
	tab_URL=("www.umontpellier.fr" "www.iutbeziers.fr" "www.google.com" "ac-versailles.fr" "ac-montpellier.fr" "www.idf.iut.fr" "8.8.8.8" "1.1.1.1" "cisco.fr" "cisco.com" "stormshield.eu" "www.ac-paris.fr" "ac-toulouse.fr" "ac-lyon.fr" "ac-clermont.fr" "ac-bordeaux.fr")
	protocole=("-I" "-U" "-T" "-D" "-T-p80" "-T-p22" "-T-p20")
	declare -A colorURL=( ['www-umontpellier-fr']="red" ['www-iutbeziers-fr']="blue" ['www-google-com']="purple" ['ac-versailles-fr']="green" ['ac-montpellier-fr']="brown" ['www-idf-iut-fr']="coral" ['8-8-8-8']="darkorange" ['1-1-1-1']="gray" ['cisco-fr']="gold" ['cisco-com']="pink" ['stormshield-eu']="cyan" ['www-ac-paris-fr']="silver" ['ac-toulouse-fr']="tomato" ['ac-lyon-fr']="slateblue" ['ac-clermont-fr']="webmaroon" ['ac-bordeaux-fr']="skyblue")
	declare -A shapePRO=( ['-U']="normal" ['-I']="diamond" ['-T']="vee"  ['-T-p80']="tee" ['-T-p22']="box" ['-T-p20']="dot" )
	echo > dote.dot

	echo "digraph A {" >>dote.dot
	for url in ${tab_URL[@]}
	do
		wcolor=$(echo $url | sed "s/\./-/g")
		color=${colorURL[$wcolor]}
		echo "\"URL\" -> \"url = $url\"->\"$color\"[color=$color]" >> dote.dot
	done
	for pro in ${protocole[@]}
	do
		shape=${shapePRO[$pro]}
		echo "\"PROTOCOLE\"->\"prot = $pro\"->\"$shape\"[arrowhead=$shape]" >> dote.dot
	done
	for url in ${tab_URL[@]}
	do
	    echo -e "Traceroute sur \e[31m$url \e[39m..."
	    for pro in ${protocole[@]}
	    do
		echo "$pro"
		echo > $url$pro 
		prob=$(echo $pro | sed "s/\-/ \-/g") 
		traceroute -A $prob $url >> $url$pro
		sed -i '2d' $url$pro                
		cat $url$pro | grep -o -E "(\([[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}.[[:digit:]]{1,3})|(AS[[:digit:]]{1,})|(\* \* \*)" > p$url$pro 
		rm $url$pro
		element=$(cat p$url$pro |sed "s/(/ /g"|sed -r -e':a;N;$!ba;s/((\* \* \*\n))//g'| sed ':a;N;$!ba;s/\nA/ A/g' | sed ':a;N;$!ba;s/\n/\"\-\>\"/g')
		wcolor=$(echo $url | sed "s/\./-/g")
		color=${colorURL[$wcolor]}
		shape=${shapePRO[$pro]}
		bienfini=$(tail -n1 p$url$pro)
		if [ "$bienfini" = "* * *" ]
		then
			echo "\"$element\"[color=$color, arrowhead=$shape]" >> dote.dot 
		else
			echo "\"$element\"->\"$url\"[color=$color, arrowhead=$shape]" >> dote.dot
		fi
		rm p$url$pro
	    done
	done
	echo "}" >> dote.dot
	dot -Tpng dote.dot > dote.png
	exit
}

function Trsolo () {
	protocole=("-I" "-U" "-T" "-T-p80" "-T-p22" "-T-p20")
	declare -A shapePRO=( ['-U']="normal" ['-I']="diamond" ['-T']="vee" ['-D']="crow" ['-T-p80']="tee" ['-T-p22']="box" ['-T-p20']="dot" )
	color=( "red" "blue" "purple" "green" "brown" "coral" "darkorange" "gray" "gold" "pink" "cyan" "silver" "tomato" "slateblue" "webmaroon" "skyblue")
	echo > dote.dot
	urlia=$@
	echo "digraph A {" >>dote.dot
	for pro in ${protocole[@]}
	do
		shape=${shapePRO[$pro]}
		echo "\"PROTOCOLE\"->\"prot = $pro\"->\"$shape\"[arrowhead=$shape]" >> dote.dot
	done
	y=0
	for url in ${urlia[@]}
	do
		echo " \"URL\" -> \"url = $url\"->\"${color[$y]}\"[color=${color[$y]}]" >> dote.dot
		y=$y+1
	done
    	i=0
	for url in ${urlia[@]}
	do	
		echo -e "Traceroute sur \e[31m$url \e[39m..."
		for pro in ${protocole[@]}
		do
			echo "$pro"
			echo > $url$pro 
			prob=$(echo $pro | sed "s/\-/ \-/g") 
			traceroute -A $prob $url >> $url$pro
			sed -i '2d' $url$pro                
			cat $url$pro | grep -o -E "(\([[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}.[[:digit:]]{1,3})|(AS[[:digit:]]{1,})|(\* \* \*)" > p$url$pro 
			rm $url$pro
			element=$(cat p$url$pro |sed "s/(/ /g"|sed -r -e':a;N;$!ba;s/((\* \* \*\n))//g'| sed ':a;N;$!ba;s/\nA/ A/g' | sed ':a;N;$!ba;s/\n/\"\-\>\"/g')
			shape=${shapePRO[$pro]}
			bienfini=$(tail -n1 p$url$pro)
			if [ "$bienfini" = "* * *" ]
			then
				echo "\"$element\"[arrowhead=$shape, color=${color[$i]}]" >> dote.dot 
			else
				echo "\"$element\"->\"$url\"[arrowhead=$shape, color=${color[$i]}]" >> dote.dot
			fi
			rm p$url$pro
		done
		echo $i
		i=$i+1
	done
	echo "}" >> dote.dot
	mv dote.dot dote1.dot
	cat dote1.dot | sed -r "s/(\"\"\->(.){1,})//g" > dote.dot
	dot -Tpng dote.dot > dote.png
	rm dote1.dot
	exit

}


function Trfichier () {
	file=$1
	a=$(cat $file)
	urlfichier=$(echo $a)
	Trsolo $urlfichier
	exit
}

while getopts ":h:u:f:a:b:" option; do
    case $option in
        h) # Affiche l'aide.
            Help
            exit;;
	f) # Utilise un fichier pour les URL/IP.
            echo "Mode fichier." 
	    fileurl=$OPTARG
	    Trfichier $fileurl
	    exit;;
        u) # Permet de donnes une URL/IP en arguments.
            echo "Mode solo URL." 
            url=$OPTARG
            Trsolo $url
            exit;;
        a) # Utilise les URL et IP predefinie.
            Predef
	    exit;;
        *)
            Help
            echo "Erreur : Veuillez specifier une option"
            exit;;
    esac
done

