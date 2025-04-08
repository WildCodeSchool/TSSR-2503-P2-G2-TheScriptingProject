#!/bin/bash

#Fonction script à distance
execution_script()
{
# Sur quelle machine distante ?
echo ""
echo "Sur quelle machine voulez-vous exécuter un script?" 
echo "1) CLILIN01"
echo "2) CLIWIN01"
echo "3) SRVWIN01"
#Pour SRVLX01; on aura une erreur car c'est la machine actuelle
echo "4) SRVLX01"
read -p "Votre réponse : " machine
# Sur quelle machine distante ?
echo ""
echo "Sur quel utilisateur voulez-vous exécuter un script?"
read -p "Votre réponse : " user
echo ""
echo "Quel est le nom du script que vous voulez exécuter?"
read -p "Votre réponse : " script
case $machine in 
 		1) IP=$172.16.20.30
 		ssh $user@$IP $script ;;
 		
 		2) IP=$172.16.20.20
 		ssh $user@$IP $script ;;
 		
 		3) IP=$172.16.20.5
 		ssh $user@$IP $script ;;
 		
 		4) echo "Vous êtes déjà sur cette machine, voulez vous exécuter le scipt?"
 		echo "o/n"
 		read -p "Votre réponse : " reponse
 		case reponse in
 			o) ./$script ;;
 			n) echo "Retour au menu précédent"
 			repertoire_logiciel ;;
 		esac
esac

}





repertoire_logiciel()
{
while true; do
echo ""
echo "Que voulez vous faire ? "
echo "1) Créer un répertoire"
echo "2) Suppression d'un répertoire"
echo "3) Installer un logiciel"
echo "4) Désinstaller un logiciel"
echo "5) Voir la liste des applications et paquets installés"
echo "6) Executer de script sur machine distante"
echo "r) Retour"
echo "x) Quitter"
read -p "Votre réponse : " choix
case $choix in
	#Création du repertoire
	1) echo ""
	read -p "Quel nom voulez-vous donner au répertoire (écrire le path absolu) " repertoire
	#Vérification repertoire n'existe pas déjà 
	if [ -d $repertoire ]
		then echo "Répertoire $repertoire déjà existant"
		else mkdir $repertoire 
		#Verification repertoire créée
		if [ -d $repertoire ]
			then echo "Répertoire $repertoire bien créée"
			else echo "Erreur, répertoire $repertoire non créée"
		fi
	fi
	;;
	
	#Suppression dossier
	2) echo ""
	read -p "Quel répertoire voulez-vous supprimer (écrire le path absolu) ? " repertoire	
	#Vérification répertoire pas déja existant
	if [ -d $repertoire ]
		then rm -r $repertoire 
	#Vérification suppression dossier
		if [ -d $repertoire ]
			then echo "Erreur, répertoire $repertoire non supprimé"
			else echo "Répertoire $repertoire bien supprimé"
		fi
		else echo "Erreur, répertoire $repertoire non supprimé"
	
	fi
	;;
	
	#Installer un logiciel
	3) echo ""
	read -p "Quel est le logiciel que vous voulez installer? " logiciel
	echo "Mise à jour des paquets ..."
	sudo apt update
	sudo apt upgrade
	#Vérification que le paquet du logiciel existe
	if  apt show $logiciel > /dev/null
		#il existe alors on l'installe
		then sudo apt install $logiciel
		echo "$logiciel est installé"
		
		#il existe pas
		else echo "$logiciel n'est pas disponible au téléchargement"
		
		#pas de vérification qu'il a bien été installé
		$logiciel > /dev/null
		if [ $? -eq 0 ]
			then echo "Le logiciel $logiciel a bien été installé"
			else echo "Erreur, $logiciel n'a pas été installé"
		fi
	fi
	;;
	
	#Désinstaller un logiciel PROBLEME : en ecrivant le nom du logiciel a désinstaller, on le lance...
	4) echo ""
	read -p "Quel est le logiciel que vous voulez désinstaller? " logiciel
	$logiciel 2>&1 /dev/null
	if [ $? -eq 0 ]
		then sudo apt remove $logiciel
		else echo "$logiciel n'a pas été trouvé, il n'a donc pas pu être désinstallé"
	fi 
	 ;;
	
	#recherche de paquet/logiciel
	5) echo ""
	apt list --installed | awk -F "/" '{print $1}' 
	echo ""
	echo "En cherchez vous en un en particulier? "
	read -p "o/n : " recherche
	case $recherche in
		#On souhaite en chercher un en particuler
		o) echo ""
		read -p "Lequel recherchez vous? " logiciel_recherche
		#verification que le paquet est installé
		if apt list --installed | awk -F "/" '{print $1}' | grep "$logiciel_recherche"
			then apt list --installed | awk -F "/" '{print $1}' | grep "$logiciel_recherche"
			echo "$logiciel_recherche est bien présent sur cette machine"
			else echo "$logiciel_recherche n'est pas présent sur cette machine"
		fi
		;;
		n) return 0 
		echo "Retour au menu précédent" ;;
	esac
	;;
	
	6) execution_script
	;;
	
	#retour au menu précédent
	r) start ;;
	
	X|x) exit 0 ;;
	
	*) echo "Réponse mal comprise, réessayez en tapant le chiffre correspondant" ;;
esac
done

}
repertoire_logiciel
exit 0
