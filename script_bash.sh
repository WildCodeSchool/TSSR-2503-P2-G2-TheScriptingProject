#!/bin/bash

####################### JOURNALISATION ##############################
# On veut obtenir les informations sur la machine et l'utilisateur actuel
# On veut enregistrer les informations dans un dossier "log"
enregistrement_information() { 
    # On crée le dossier log s'il n'existe pas déjà
     dossier_log="log"
     if [ ! -d "$dossier_log" ]; then
            mkdir $dossier_log
    fi
    # initialisation des variables
    # On veut récupérer la date 
    date=$(date +%Y:%m:%d)
    # On ajuste le nom du fichier pour une information ordinateur sous la forme <NomDuPC>-GEN_<Date>.txt qui sera créé dans le dossier "log"
        ordi_info_log="info_$(hostname)_GEN_$date.txt"
    # On ajuste le nom du fichier pour une information utilisateur sous la forme <NomDuPC>_<NomDeLUtilisateur>_<Date>.txt     
        user_info_log="info_$(hostname)_$(whoami)_$date.txt"
}











#####################################

regles()
{
echo -e "\n\t\e[31mMENU REGLES DE PARE-FEU\e[0m"
echo -e "\n Que voulez vous faire :"
echo "1) Activer/désactiver les connexions avec une adresse IP spécifique"
echo "2) Activer/désactiver les connexions via ssh"
echo "A) Annuler et réinitialiser par défaut"
echo "R) Retour au menu Précédent"
echo "X) Quitter"
read -p "Votre réponse : " choix
case $choix in
	#Activation/désactivation des connexions IP avec une adresse donnée
	1) read -p 'Souhaitez vous activer (o) ou désactiver (n) les connexions avec une adresse IP spécifique ? ' ip_onoff
	#On demande l'adresse
	read -p "Avec quelle adresse IP ? " ip_specifique
	case $ip_onoff in
		#on autorise de recevoir des connexions depuis l'adresse ip renseignée : ip_onoff
		o) sudo ufw allow from $ip_specifique
		echo "Traffic entrant depuis l'adresse IP $ip_specifique autorisé" 
		echo "Il est possible de voir toutes les règles en place dans 'Voir l'état du pare-feu'"
		echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Activation traffic de $ip_specifique vers $IP" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
		
		#inversement, on bloque les connexions avec l'adresse ip renseignée : ip_onoff
		#Les "vérifications" se font automatiquement : il y a en sortie normale si la regle a été ajoutée ou non
		n) sudo ufw deny out to $ip_specifique
		echo "Traffic sortant vers l'adresse IP $ip_specifique bloqué" 
		echo "Il est possible de voir toutes les règles en place dans 'Voir l'état du pare-feu'"
		echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Désactivation traffic de $IP vers $ip_specifique" | sudo tee -a /var/log/log_evt.log > /dev/null
		;;
	esac ;;
	
	#Activation/désactivation de ssh	
	2) read -p "Souhaitez vous activer (o) ou désactiver (n) les connexions via ssh ?" ssh_onoff
	case $ssh_onoff in
		o) sudo ufw allow in ssh
		echo "Connexion via autorisée" 
		echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Activation connexion SSH" | sudo tee -a /var/log/log_evt.log > /dev/null
		;;
		n) sudo ufw deny in ssh
		echo "Connexion via bloquée"  
		echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Désactivation connexion SSH " | sudo tee -a /var/log/log_evt.log > /dev/null
		;;
	esac ;;
	
	#Réinitialisation par défaut, attention le pare-feu est donc désactivé après ça
	A|a) sudo ufw reset 
	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Réinitialisation des règles de pare-feu par défaut" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
	
	R|r) echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Retour vers le menu Security" | sudo tee -a /var/log/log_evt.log > /dev/null 
	security ;;
	
	X|x) echo -e "\n\tAu revoir !" 
	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-*********EndScript*********" | sudo tee -a /var/log/log_evt.log > /dev/null 
  	exit 0 ;;
	
	*) echo "Choix invalide, veuillez réessayer" ;;	
esac
}



security()
{
while true; do
echo -e "\n\t\e[31mMENU GESTION DE LA SECURITE\e[0m"
echo -e "\n Que voulez vous faire ?"
echo "1. Activer un pare-feu"
echo "2. Désactiver un pare-feu"
echo "3. Définir des règles de pare-feu"
echo "4. Voir l'état du pare-feu"
echo "5. Voir les ports ouverts"
echo "6. Gérer les droits d'un utilisateur sur un dossier ou fichier"
echo "7. Voir la dernière connexion d'un utilisateur"
echo "8. Voir la date de dernier changement de mot de passe"
echo "9. Voir le nombre d'interfaces"
echo "R. Retour au menu précédent"
echo "X. Quitter"
read -p "Votre réponse : " choix
case $choix in
	#activation parefeu
	1) echo ""
	sudo ufw enable
	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Activation pare-feu" | sudo tee -a /var/log/log_evt.log > /dev/null
	;;
	
	#désactivation parefeu
	2) echo ""
	sudo ufw disable 
	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Désactivation pare-feu" | sudo tee -a /var/log/log_evt.log > /dev/null
	;;
	
	#definir les règles de pare-feu -> fonction regles
	3) echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Direction vers le menu Regles" | sudo tee -a /var/log/log_evt.log > /dev/null 
	regles ;;
	
	#voir l'état pare-feu
	4) echo ""
	sudo ufw status | tee -a $dossier_log/$ordi_info_log
	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Voir état du pare-feu" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
	
	#Voir les ports ouverts
	5) echo ""
	sudo netstat -tlnpu | tee -a $dossier_log/$ordi_info_log
	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Infos ports ouverts" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
	
	6) echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Direction menu gestion des droits d'un utilisateur sur un dossier ou fichier" | sudo tee -a /var/log/log_evt.log > /dev/null 
	Gestion_Droits ;;
	
	#Dernière connexion utilisateur
	7) echo ""
	read -p "Pour quel utilisateur ? " user
	#Avoir que la premiere ligne
	last -F $user | head -n 1 | tee -a $dossier_log/$user_info_log
	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Infos dernière connexion utilisateur" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
	
	#Derniere modif  mdp
	8) echo ""
	read -p "Pour quel utilisateur ? " user
	#Avoir que la premiere ligne
	sudo chage -l $user | head -n 1 | tee -a $dossier_log/$user_info_log
	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Infos dernier changement mot de passe" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
	
	#Liste sessions ouverte
	9) echo ""
	read -p "Pour quel utilisateur ? " user
	w $user | tee -a $dossier_log/$user_info_log
	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Infos liste des sessions ouvertes pour $user" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
	
	r) echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Retour vers le menu Start" | sudo tee -a /var/log/log_evt.log > /dev/null 
	start ;;
	
	x) echo -e "\n\tAu revoir !" 
	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-*********EndScript*********" | sudo tee -a /var/log/log_evt.log > /dev/null
    	exit 0 ;;
	
	*) echo "Choix invalide, veuillez réessayer" ;;
esac
done
}

#######################################




# RESEAUX
reseaux()
{
while true; do
echo -e "\n\t\e [31mMENU GESTION DU RESEAU\e[0m"
echo -e "\nQue voulez vous faire ? "
echo "1) Voir l'adresse MAC"
echo "2) Voir les adresses IP des interfaces"
echo "3) Voir le nombre d'interfaces"
echo "R) Retour au menu précédent"
echo "X) Quitter"
read -p "Votre réponse : " choix
case $choix in
	#Voir l'adresse MAC IL MANQUE SSH
	1) echo ""
	ip a | grep "link/ether*" | awk -F " " '{print $2}' | tee -a $dossier_log/$ordi_info_log  
  	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Infos adresse mac de $HOSTNAME" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
	
	#Voir adresse IP des interfaces (pas besoin de SSH)
	2) echo ""
	cat /etc/hosts | grep "127*" | tee -a $dossier_log/$ordi_info_log  
  	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Infos adresses IP des interfaces connectées avec $HOSTNAME" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
	
	#Voir le nombre d'interfaces (donc le nombre de lignes)
	3) echo ""
	cat /etc/hosts | grep "127*" | wc -l | tee -a $dossier_log/$ordi_info_log
  	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Infos nombre d'interfaces connectées à $HOSTNAME" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
	
	#retour au menu précédent
	R|r) echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Retour au premier menu" | sudo tee -a /var/log/log_evt.log > /dev/null 
	start ;;
	
	X|x) echo -e "\n\tAu revoir !"
  	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-*********EndScript*********" | sudo tee -a /var/log/log_evt.log > /dev/null
        exit 0 ;;
	
	*) echo "Choix invalide, veuillez réessayer" ;;
esac
done

}


#####################################

Gestion_Droits() 
{
while true ;
do
    echo -e "\n\t\e[31m MENU GESTION DES DROITS\e[0m"
    echo -e "\n Que voulez-vous modifier ?"
    echo "1. Droits/Permissions de l'utilisateur sur un dossier :"
    echo "2. Droits/Permissions de l'utilisateur sur un fichier :"
    echo "R. Retour au menu précédent"
    echo "X. Quitter"
    read -p "Votre choix : " choix
    case $choix in
    #Choix de donner plus ou moins de droits (pour limiter le choix plus tard)
        1) read -p "Voulez-vous donner plus de droits (+) ou enlever des droits (-) ? " signe
        case $signe in
       		+) read -p "Nom d'utilisateur : " user
		    # Vérification si l'utilisateur existe
	    	if id "$user" &>/dev/null; then
			read -p "Nom du dossier (entrez le path absolu) : " dossier
			# Vérification si le dossier existe
                if [ -d "$dossier" ];
                    then
                    echo -e "\n1) Donner les droits de lecture à l'utilisateur"
                    echo "2) Donner les droits d'écriture à l'utilisateur"
                    echo "3) Donner les droits d'exécution à l'utilisateur"
                    echo -e "\nPlusieurs choix possibles, comme 123"
                    read -p "Votre réponse : " droits
                    # Pour chaque réponse donnée, on va faire l'application, permet de faire une reponse 123 pour tout faire d'un coup
                    for droit in $(echo "$droits" | grep -o "[1-3]" ); do
		            case "$droit" in
		            	1) sudo chmod u+r "$dossier" 
		            	echo "Droits de lecture ajoutés" 
		            	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Ajout droits de lecture de $user sur $dossier" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
		             	2) sudo chmod u+w "$dossier" 
		             	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Ajout droits d'écriture de $user sur $dossier" | sudo tee -a /var/log/log_evt.log > /dev/null
		              	echo "Droits d'écriture ajoutés" ;;
		            	3) sudo chmod u+x "$dossier"
		            	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Ajout droits d'execution de $user sur $dossier" | sudo tee -a /var/log/log_evt.log > /dev/null
		            	echo "Droits d'exécution ajoutés" ;;
		            	*) echo "Choix invalide, veuillez réessayer" ;;
		            esac
                    done		 	   
                else
                    echo "Le dossier $dossier n'existe pas. Veuillez le créer d'abord."
                fi
            else
                echo "L'utilisateur $user n'existe pas. Veuillez le créer d'abord."
            fi
            ;;
            -) read -p "Nom d'utilisateur : " user
		    # Vérification si l'utilisateur existe
	    	if id "$user" &>/dev/null; then
			read -p "Nom du dossier (entrez le path absolu) : " dossier
			# Vérification si le dossier existe
                if [ -d "$dossier" ];
                    then
                    echo -e "\n1) Enlever les droits de lecture à l'utilisateur"
                    echo "2) Enlever les droits d'écriture à l'utilisateur"
                    echo "3) Enlever les droits d'exécution à l'utilisateur"
                    echo -e "\nPlusieurs choix possibles, comme 123"
                    read -p "Votre réponse : " droits
                    # Pour chaque réponse donnée, on va faire l'application, permet de faire une reponse 123 pour tout faire d'un coup
                    for droit in $(echo "$droits" | grep -o "[1-3]"); do
		            case "$droit" in
		            	1) sudo chmod u-r "$dossier" 
		            	echo "Droits de lecture enlevés" 
		            	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Suppression droits de lecture de $user sur $dossier" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
		            	2) sudo chmod u-w "$dossier" 
		             	echo "Droits d'écriture enlevés" 
		             	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Suppression droits d'écriture de $user sur $dossier" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
		            	3) sudo chmod u-x "$dossier"
		            	echo "Droits d'exécution enlevés" 
		            	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Suppression droits d'execution de $user sur $dossier" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
		            	*) echo "Choix invalide, veuillez réessayer" ;;
		            esac
                    done		 	   
                else
                    echo "Le dossier $dossier n'existe pas. Veuillez le créer d'abord." 
                fi
            else
                echo "L'utilisateur $user n'existe pas. Veuillez le créer d'abord." 
            fi
            ;;

            *) echo "Choix invalide, réessayez" ;;
	    esac ;;
        2)
            read -p "Voulez-vous donner plus de droits (+) ou enlever des droits (-) ? " signe
        case $signe in
       		+) read -p "Nom d'utilisateur : " user
		    # Vérification si l'utilisateur existe
	    	if id "$user" &>/dev/null; then
			read -p "Nom du fichier (entrez le path absolu) : " fichier
			# Vérification si le fichier existe
                if [ -f "$fichier" ];
                    then
                    echo -e "\n1) Donner les droits de lecture à l'utilisateur"
                    echo "2) Donner les droits d'écriture à l'utilisateur"
                    echo "3) Donner les droits d'exécution à l'utilisateur"
                    echo -e "\nPlusieurs choix possibles, comme 123"
                    read -p "Votre réponse : " droits
                    # Pour chaque réponse donnée, on va faire l'application, permet de faire une reponse 123 pour tout faire d'un coup
                    for droit in $(echo "$droits" | grep -o "[1-3]"); do
		            case "$droit" in
		            	1) sudo chmod u+r "$fichier"
		            	echo "Droits de lecture ajoutés"
		            	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Ajout droits de lecture de $user sur $fichier" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
		              	2) sudo chmod u+w "$fichier"
		              	echo "Droits d'écriture ajoutés" 
		              	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Ajout droits d'écriture de $user sur $fichier" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
		            	3) sudo chmod u+x "$fichier"
		            	echo "Droits d'exécution ajoutés" 
		            	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Ajout droits d'execution de $user sur $fichier" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
		            	*) echo "Choix invalide, veuillez réessayer" ;;
		            esac
                    done		 	   
                else
                    echo "Le fichier $fichier n'existe pas. Veuillez le créer d'abord."
                    return 1
                fi
            else
                echo "L'utilisateur $user n'existe pas. Veuillez le créer d'abord."
                return 1
            fi
            ;;
            -) read -p "Nom d'utilisateur : " user
		    # Vérification si l'utilisateur existe
	    	if id "$user" &>/dev/null; then
			read -p "Nom du fichier (entrez le path absolu) : " fichier
			# Vérification si le fichier existe
                if [ -f "$fichier" ];
                    then
                    echo -e "\n1) Enlever les droits de lecture à l'utilisateur"
                    echo "2) Enlever les droits d'écriture à l'utilisateur"
                    echo "3) Enlever les droits d'exécution à l'utilisateur"
                    echo -e "\nPlusieurs choix possibles, comme 123"
                    read -p "Votre réponse : " droits
                    # Pour chaque réponse donnée, on va faire l'application, permet de faire une reponse 123 pour tout faire d'un coup
                    for droit in $(echo "$droits" | grep -o "[1-3]"); do
		            case "$droit" in
		            	1) sudo chmod u-r "$fichier"
		            	echo "Droits de lecture enlevés" 
		            	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Suppression droits de lecture de $user sur $fichier" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
		            	2) sudo chmod u-w "$fichier"
		            	echo "Droits d'écriture enlevés" 
		            	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Suppression droits d'écriture de $user sur $fichier" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
		            	3) sudo chmod u-x "$fichier"
		            	echo "Droits d'exécution enlevés" 
		            	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Suppression droits d'execution de $user sur $fichier" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
		            	*) echo "Choix invalide, veuillez réessayer" ;;
		            esac
                    done		 	   
                else
                    echo "Le fichier $fichier n'existe pas. Veuillez le créer d'abord."
                    return 1
                fi
            else
                echo "L'utilisateur $user n'existe pas. Veuillez le créer d'abord."
                return 1
            fi
            ;;
            *) echo "Choix invalide, réessayez"
       		return 1 ;;
	    esac ;;
        R|r) echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Retour vers le menu gestion de la sécurité" | sudo tee -a /var/log/log_evt.log > /dev/null
            security
            ;;
        X|x) echo -e "\n\tAu revoir !"
		echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-*********EndScript*********" | sudo tee -a /var/log/log_evt.log > /dev/null
        exit 0 ;;
        *) echo "Choix invalide, veuillez réessayer"
        return 1 ;;
    esac
done
}


##########################################

#Fonction script à distance
execution_script()
{
	# Sur quelle machine distante ?
	echo -e "\n Sur quelle machine voulez-vous exécuter un script?" 
	echo "1) CLILIN01"
	echo "2) CLIWIN01"
	echo "3) SRVWIN01"
#Pour SRVLX01; on aura une erreur car c'est la machine actuelle
	echo "4) SRVLX01"
	echo "R) Retour au menu précédent"
	echo "X) Quitter"
	read -p "Votre réponse : " machine
# Sur quelle machine distante ?
	echo -e "\nSur quel utilisateur voulez-vous exécuter un script?"
	read -p "Votre réponse : " user
	echo -e "\nQuel est le nom du script que vous voulez exécuter?"
	read -p "Votre réponse : " script
case $machine in 
 	1) ip="172.16.20.30"
 		ssh $user@$ip $script 
 		echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Execution du script $script sur la machine $ip par l'user $user" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
 		
 	2) ip="172.16.20.20"
 		ssh $user@$ip $script 
 		echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Execution du script $script sur la machine $ip par l'user $user" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
 		
 	3) ip="172.16.20.5"
 		ssh $user@$ip $script 
 		echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Execution du script $script sur la machine $ip par l'user $user" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
 		
 	4) echo "Vous êtes déjà sur cette machine, voulez vous exécuter le scipt? "
 	    echo "o/n"
 		read -p "Votre réponse : " reponse
 		case reponse in
 			o) ./$script 
 			echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Execution du script $script sur la machine $ip par l'user $user" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
 			n) echo "Retour au menu précédent"
 			echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Retour au menu repertoire/logiciel" | sudo tee -a /var/log/log_evt.log > /dev/null 
 			repertoire_logiciel 
 		esac ;;
 		R|r) echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Retour au menu repertoire/logiciel" | sudo tee -a /var/log/log_evt.log > /dev/null 
		repertoire_logiciel ;;

 	X|x) echo -e "\n\tAu revoir !"
 		echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-*********EndScript*********" | sudo tee -a /var/log/log_evt.log > /dev/null
       	exit 0
 		;;

        *) echo "Choix invalide, veuillez réessayer"
 		
esac

}





repertoire_logiciel()
{
while true; do
echo ""
echo -e "\n\t\e[31mMENU GESTION REPERTOIRES/LOGICIELS\e[0m"
echo -e "\n Que voulez vous faire ? "
echo "1) Créer un répertoire"
echo "2) Suppression d'un répertoire"
echo "3) Installer un logiciel"
echo "4) Désinstaller un logiciel"
echo "5) Voir la liste des applications et paquets installés"
echo "6) Executer de script sur machine distante"
echo "R) Menu Principal"
echo "X) Quitter"
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
			echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Création du répertoire $repertoire" | sudo tee -a /var/log/log_evt.log > /dev/null 
			
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
			echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Suppression du répertoire $repertoire" | sudo tee -a /var/log/log_evt.log > /dev/null 
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
		echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Installation du logiciel $logiciel impossible car absent de la liste des paquets" | sudo tee -a /var/log/log_evt.log > /dev/null
		
		#pas de vérification qu'il a bien été installé
		$logiciel > /dev/null
		if [ $? -eq 0 ]
			then echo "Le logiciel $logiciel a bien été installé"
			echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Installation du logiciel $logiciel" | sudo tee -a /var/log/log_evt.log > /dev/null
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
		echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Désinstallation du logiciel $logiciel" | sudo tee -a /var/log/log_evt.log > /dev/null
		else echo "$logiciel n'a pas été trouvé, il n'a donc pas pu être désinstallé"
	fi 
	 ;;
	
	#recherche de paquet/logiciel
	5) echo ""
	apt list --installed | awk -F "/" '{print $1}' | tee -a $dossier_log/$ordi_info_log 
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
			echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Logiciel $logiciel_recherche est bien présent sur la machine" | sudo tee -a /var/log/log_evt.log > /dev/null
			else echo "$logiciel_recherche n'est pas présent sur cette machine"
			echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Logiciel $logiciel_recherche non présent sur la machine" | sudo tee -a /var/log/log_evt.log > /dev/null
		fi
		;;
		n) echo "Retour au menu précédent" 
		return 0  ;;
	esac
	;;
	
	6) echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Direction exécution d'un script" | sudo tee -a /var/log/log_evt.log > /dev/null
	execution_script
	;;
	
	#retour au menu précédent
	R|r) echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Retour vers le menu principal" | sudo tee -a /var/log/log_evt.log > /dev/null
	start ;;
	
	X|x) echo -e "\n\tAu revoir !"
    	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-*********EndScript*********" | sudo tee -a /var/log/log_evt.log > /dev/null
    	exit 0 ;;
	
	*) echo "Choix invalide, veuillez réessayer" ;;
esac
done

}

###################################################

########################## Fonction PRINCIPALE Gestion Utilisateur  ##############################

Gestion_Utilisateur() {
while true ;
do
    echo -e "\n\t\e[31mMENU GESTION DES UTILISATEURS\e[0m"
    echo -e "\n Choississez une option :"
    echo "1. Voir la liste des utilisateurs"                    
    echo "2. Création d'un utilisateur"                 
    echo "3. Supprimer un utilisateur"                  
    echo "4. Changement de mot de passe"                
    echo "5. Désactivation de compte utilisateur"       
    echo "6. Gestion des groupes"   
    echo "R. Menu précédent"                    
    echo "X. Quitter"
    read -p "Votre choix : " choix
    case $choix in
        1)
            echo "Liste des utilisateurs :" 
            # Enregistrement des utilisateurs dans le fichier "info_<Utilisateur>-_<Date>.txt"
            cut -d: -f1 /etc/passwd | tee -a $dossier_log/$ordi_info_log
            echo "Les utilisateurs ont été enregistrés dans le fichier $dossier_log/$ordi_info_log"
            ;;
        2)
            read -p "Nom d'utilisateur à créer : " user
            sudo useradd $user
            echo "Utilisateur $user créé."
            echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Création de l'utilisateur $user" | sudo tee -a /var/log/log_evt.log > /dev/null
            ;;
        3)
            read -p "Nom d'utilisateur à supprimer : " user
            sudo userdel $user
            echo "Utilisateur $user supprimé."
            echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Suppression de l'user $user" | sudo tee -a /var/log/log_evt.log > /dev/null
            ;;
        4)
            read -p "Nom d'utilisateur pour changer le mot de passe : " user
            sudo passwd $user
            echo "Mot de passe changé pour l'utilisateur $user."
            echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Modification du mot de passe de $user" | sudo tee -a /var/log/log_evt.log > /dev/null
            ;;
        5)
            read -p "Nom d'utilisateur à désactiver : " user
            sudo usermod -L $user
            echo "Compte utilisateur $user désactivé."
            echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Désactivation de l'utilisateur $user" | sudo tee -a /var/log/log_evt.log > /dev/null
            ;;
        6) echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Direction menu de gestion des groupes" | sudo tee -a /var/log/log_evt.log > /dev/null
            Gestion_Groupe
            ;;
        R|r)
        	# Appel du menu principal
            echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Retour au menu principal" | sudo tee -a /var/log/log_evt.log > /dev/null
            start
            ;;
        X|x) echo -e "\n\tAu revoir !"
        echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-*********EndScript*********" | sudo tee -a /var/log/log_evt.log > /dev/null
        exit 0 ;;

        *) echo "Choix invalide, veuillez réessayer."
            ;;
    esac
done
}

######################## FONCTION SECONDAIRE -- GESTION_UTILISATEUR ######################################

Gestion_Groupe() {
while true ;
do
    echo -e "\n\t\e[31mGESTION DES GROUPES\e[0m"
    echo -e "\n Que voulez-vous faire?"
    echo "1. Ajouter un utilisateur à un groupe d'administration"
    echo "2. Ajouter un utilisateur à un groupe"
    echo "3. Sortie d'un utilisateur d'un groupe"
    echo "R. Retour au menu précedent"
    echo "X. Quitter"
    read -p "Votre choix : " choix
    case $choix in
        1)
            read -p "Nom d'utilisateur à ajouter au groupe d'administration : " user
            # Vérification si l'utilisateur existe
            if id "$user" &>/dev/null; then
                sudo usermod -aG sudo $user
                echo "Utilisateur $user ajouté au groupe d'administration."
                echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Ajout de l'utilisateur $user au groupe d'administration" | sudo tee -a /var/log/log_evt.log > /dev/null
            else
                echo "L'utilisateur $user n'existe pas. Veuillez le créer d'abord."
                echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Retour vers le menu gestion d'utilisateur" | sudo tee -a /var/log/log_evt.log > /dev/null
                Gestion_Utilisateur
                continue
            fi
            ;;
        2)
            read -p "Nom d'utilisateur à ajouter à un groupe : " user
            # Vérification si l'utilisateur existe
            if id "$user" &>/dev/null; then
                continue
            else
                echo "L'utilisateur $user n'existe pas. Veuillez le créer d'abord."
                echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Retour vers le menu gestion d'utilisateur" | sudo tee -a /var/log/log_evt.log > /dev/null
                Gestion_Utilisateur
                continue
            fi
            
            read -p "Nom du groupe : " group
            # Vérification si le groupe existe
            if getent group $group &>/dev/null; then
            	sudo usermod -aG $group $user
           	echo "Utilisateur $user ajouté au groupe $group."
          	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Ajout de l'utilisateur $user au groupe $group" | sudo tee -a /var/log/log_evt.log > /dev/null
                continue
            else
                echo "Le groupe $group n'existe pas. Veuillez le créer d'abord."
                continue
            fi  
            ;;
        3)
            read -p "Nom d'utilisateur à sortir du groupe : " user
            read -p "Nom du groupe : " group
            sudo gpasswd -d $user $group
            echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Suppression de l'utilisateur $user du groupe $group" | sudo tee -a /var/log/log_evt.log > /dev/null
            echo "Utilisateur $user sorti du groupe $group."
            ;;
        R|r) echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Retour vers le menu gestion d'utilisateur" | sudo tee -a /var/log/log_evt.log > /dev/null
		Gestion_Utilisateur
            ;;
            
        X|x) echo -e "\n\tAu revoir !" 
            echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-*********EndScript*********" | sudo tee -a /var/log/log_evt.log > /dev/null
            exit 0
            ;;
        *) echo "Choix invalide, veuillez réessayer."
            ;;
    esac
done
}

####################### FONCTION PRINCIPALE -- GESTION_SYSTEME ##############################

Gestion_Systeme() {
# Boucle pour relancer la fonction
while true ;
do
    echo -e "\n\t\e[31mMENU GESTION DU SYSTEME\e[0m"
    echo -e "\n Que voulez-vous faire ? "
    echo "1. Obtenir une information"
    echo "2. Effectuer une action"
    echo "R. Retour au menu précédent"
    echo "X. Quitter"
    read -p "Votre choix : " choix
    case $choix in
        1) echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Direction vers le menu d'information du système" | sudo tee -a /var/log/log_evt.log > /dev/null
		information_systeme ;;
        2) echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Direction vers le menu d'action sur le système" | sudo tee -a /var/log/log_evt.log > /dev/null
		action_systeme  ;;
        R|r) echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Direction vers le menu principal" | sudo tee -a /var/log/log_evt.log > /dev/null 
		start ;;
        X|x) echo -e "\n\tAu revoir !"
        echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-*********EndScript*********" | sudo tee -a /var/log/log_evt.log > /dev/null
        exit 0 ;;
        *) echo "Choix invalide. Veuillez réessayer." ;;
    esac
done
}

####################### FONCTION SECONDAIRE -- GESTION_SYSTEME ##############################
information_systeme() {
    echo -e "\n\t\e[31mMENU D'INFORMATIONS DU SYSTEME\e[0m"
    echo -e "\n Que voulez-vous savoir ?"
    echo "1. Type de CPU, nombre de coeurs, etc."
    echo "2. Memoire RAM totale"
    echo "3. Utilisation de la mémoire RAM"
    echo "4. Utilisation du disque"
    echo "5; Utilisation du processeur"
    echo "6. Version du système d'exploitation"
    echo "R. Revenir au menu précédent"
    echo "X. Quitter"
    read -p "Votre choix : " choix
    case $choix in
            1)
                echo  "Type de CPU, nombre de coeurs, etc. :"
                # Enregistrement des informations dans le fichier "info_<ordinateur>-GEN_<Date>.txt"
                lscpu | tee -a $dossier_log/$ordi_info_log
                # On vérifie si le fichier à été crée
                if [ -f $dossier_log/$ordi_info_log ]; then
                    echo "Les informations sur le CPU ont été enregistrées dans le fichier $dossier_log/$ordi_info_log"
					echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Vision du type de CPU, nombre de coeurs" | sudo tee -a /var/log/log_evt.log > /dev/null
                else
                    echo "Erreur lors de la création du fichier $dossier_log/$ordi_info_log."
                fi                
                ;;
            2)
                echo "Mémoire RAM totale :"
                # Enregistrement des informations dans le fichier "info_<ordinateur>-GEN_<Date>.txt"
                free -h | grep "Mem" | awk '{print $2}' | tee -a $dossier_log/$ordi_info_log
                # On vérifie si le fichier à été crée
                if [ -f $dossier_log/$ordi_info_log ]; then
                    echo "Les informations sur la mémoire RAM totale ont été enregistrées dans le fichier $dossier_log/$ordi_info_log"
					echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Vision de la RAM totale" | sudo tee -a /var/log/log_evt.log > /dev/null
                else
                    echo "Erreur lors de la création du fichier $dossier_log/$ordi_info_log."
                fi
                ;;
            3)
                echo "Utilisation de la mémoire RAM :"
                # Enregistrement des informations dans le fichier "info_<ordinateur>-GEN_<Date>.txt"
                free -h | grep "Mem" | awk '{print $3}' | tee -a $dossier_log/$ordi_info_log
                # On vérifie si le fichier à été crée
                if [ -f $dossier_log/$ordi_info_log ]; then
                    echo "Les informations sur l'utilisation de la mémoire RAM ont été enregistrées dans le fichier $dossier_log/$ordi_info_log"
					echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Vision de l'utilisation de la RAM" | sudo tee -a /var/log/log_evt.log > /dev/null
                else
                    echo "Erreur lors de la création du fichier $dossier_log/$ordi_info_log."
                fi
                ;;
            4)
                echo "Utilisation du disque :"
                # Enregistrement des informations dans le fichier "info_<ordinateur>-GEN_<Date>.txt"
                df -h | tee -a $dossier_log/$ordi_info_log
                # On vérifie si le fichier à été crée
                if [ -f $dossier_log/$ordi_info_log ]; then
                    echo "Les informations sur l'utilisation du disque ont été enregistrées dans le fichier $dossier_log/$ordi_info_log"
					echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Vision de l'utilisation du disque" | sudo tee -a /var/log/log_evt.log > /dev/null
                else
                    echo "Erreur lors de la création du fichier $dossier_log/$ordi_info_log."
                fi
                ;;
            5)
                echo "Utilisation du processeur :"
                # Enregistrement des informations dans le fichier info_<ordinateur>-GEN_<Date>.txt"
                top -b -n 1 | grep "Cpu(s)" | tee -a $dossier_log/$ordi_info_log
                # On vérifie si le fichier à été crée
                echo "Les informations sur l'utilisation du processeur ont été enregistrées dans le fichier $dossier_log/$ordi_info_log"
				echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Vision de l'utilisation du processeur" | sudo tee -a /var/log/log_evt.log > /dev/null
                ;;
            6)
                echo "Version du système d'exploitation :"
                # Enregistrement des informations dans le fichier "info_<ordinateur>_<Date>.txt"
                cat /etc/os-release | tee -a $dossier_log/$ordi_info_log
                # On vérifie si le fichier à été crée
                if [ -f $dossier_log/$ordi_info_log ]; then
                    echo "Les informations sur la version du système d'exploitation ont été enregistrées dans le fichier $dossier_log/$ordi_info_log"
		    		echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Vision du système d'exploitation" | sudo tee -a /var/log/log_evt.log > /dev/null
                else
                    echo "Erreur lors de la création du fichier $dossier_log/$ordi_info_log."
                fi
                ;;
            R|r) echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Direction vers le menu de gestion du systeme" | sudo tee -a /var/log/log_evt.log > /dev/null
	   		Gestion_Systeme ;;

            X|x) echo -e "\n\tAu revoir !"
            echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-*********EndScript*********" | sudo tee -a /var/log/log_evt.log > /dev/null
            exit 0 ;;
            
            *) echo "Choix invalide. Veuillez réessayer." ;;
    esac
}
####################### FONCTION SECONDAIRE -- GESTION_SYSTEME ##############################
action_systeme() {
    echo -e "\n\t\e[31mMENU D'ACTION SUR LE SYSTEME\e[0m"
    echo -e "\n Que souhaitez-vous effectuer ?"
    echo "1. Arrêter le système"
    echo "2. Redémarrer le système"
    echo "3. Vérouiller le système (GNOME-ONLY)"
    echo "4. Mettre à jour le système"
    echo "R. Retour au menu précédent"
    echo "X. Quitter"
    read -p "Votre choix : " choix
    case $choix in
            1)
                echo "Arrêt du système en cours ..."
                # Arrêt du système
                echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Arrêt du système" | sudo tee -a /var/log/log_evt.log > /dev/null
                sudo shutdown -h now
                ;;
            2)
                echo "Redémarrage du système en cours ..."
                # Redémarrage du système
                echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Redémarrage du système" | sudo tee -a /var/log/log_evt.log > /dev/null
                sudo shutdown -r now
                ;;
            3)
                echo "Vérouillage du système en cours ..."
                # Vérouillage du système
                echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Verrouillage du système en cours" | sudo tee -a /var/log/log_evt.log > /dev/null
                gnome-screensaver-command -l
                ;;
            4)
                echo "Mise à jour du système en cours ..."
                # Mise à jour du système
                sudo apt update && sudo apt upgrade -y
                echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Mise à jour du systeme" | sudo tee -a /var/log/log_evt.log > /dev/null
                ;;
            R|r) echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Direction vers le menu de gestion du système" | sudo tee -a /var/log/log_evt.log > /dev/null 
	    Gestion_Systeme ;;
            X|x) echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-*********EndScript*********" | sudo tee -a /var/log/log_evt.log > /dev/null
            echo -e "\n\tAu revoir !"
			exit 0 ;;
            *) echo "Choix invalide. Veuillez réessayer." ;;
    esac
    echo "Action effectuée avec succès !"
}








#################### FONCTION MENU PRINCIPAL ##########################

start()
{
while true ;
do
echo ""
echo -e "\n\t\e[31mBIENVENUE DANS LE MENU D'ADMINISTRATION\e[0m"
echo -e "\n Que voulez-vous faire ? "
echo "1. Gérer les utilisateurs"
echo "2. Gérer la sécurité"
echo "3. Gérer le paramétrage réseaux"
echo "4. Gérer les logiciels et répertoires"
echo "5. Gérer le système"
echo "X. Quitter"
read -p "Votre réponse : " choix
case $choix in
    #direction vers gestion utilisateur = lancement fonction Gestion_Utilisateur
    1) echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Direction vers le menu de gestion des utilisateurs" | sudo tee -a /var/log/log_evt.log > /dev/null 
    Gestion_Utilisateur ;;

    #direction vers security = lancement fonction security
    2) echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Direction vers le menu de gestion de la sécurité" | sudo tee -a /var/log/log_evt.log > /dev/null 
    security ;;

    #direction vers reseaux = lancement fonction reseaux
    3) echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Direction vers le menu de gestion du paramétrage réseau" | sudo tee -a /var/log/log_evt.log > /dev/null 
    reseaux ;;

    #direction vers repertoire_logiciel = lancement fonction repertoire_logiciel
    4) echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Direction vers le menu de gestion des logiciels et répertoires" | sudo tee -a /var/log/log_evt.log > /dev/null 
    repertoire_logiciel ;;

    #direction vers Gestion_Systeme = lancement fonction Gestion_Systeme
    5) echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Direction vers le menu de gestion du système" | sudo tee -a /var/log/log_evt.log > /dev/null 
    Gestion_Systeme ;;

    X|x) echo -e "\n\tAu revoir !"
    echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-*********EndScript*********" | sudo tee -a /var/log/log_evt.log > /dev/null
    exit 0
    ;;

    *) echo "Choix invalide. Veuillez réessayer." ;;
esac
done
}
###################### APPEL DU MENU PRINCIPAL #######################
echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-********StartScript********" | sudo tee -a /var/log/log_evt.log > /dev/null
enregistrement_information
start
