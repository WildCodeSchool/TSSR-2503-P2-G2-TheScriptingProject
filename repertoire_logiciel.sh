#!/bin/bash



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
	#Création du dossier
	1) echo ""
	read -p "Quel nom voulez-vous donner au répertoire (écrire le path absolu) " repertoire
	mkdir repertoire 
	#Verification dossier créée
	if [ -d dossier ]
		then echo "Répertoire $repertoire bien créée"
		else echo "Erreur, répertoire $repertoire non créée"
	fi
	;;
	
	#Suppression dossier
	2) echo ""
	read -p "Quel répertoire voulez-vous supprimer ? " repertoire	
	rm -r $repertoire 
	#Vérification suppression dossier
		if [ -d dossier ]
		then echo "Erreur, répertoire $repertoire non supprimé"
		else echo "Répertoire $repertoire bien supprimé"
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
	
	5) echo ""
	apt list --installed | awk -F "/" '{print $1}' ;;
	
	6)
	;;
	
	#retour au menu précédent
	r) start ;;
	
	x) echo "Sortie du menu"
	 exit 0 ;;
	
	*) echo "Réponse mal comprise, réessayez en tapant le chiffre correspondant" ;;
esac
done

}
repertoire_logiciel
exit 0
