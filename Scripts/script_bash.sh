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

function recherche_tout()
{
echo -e "\n Quel type d'information recherchez-vous ?"
echo "1. Une information déjà demandée qui a été stockée"
echo "2. Une information sur un évenement, une action, un déplacement"
echo "R. Retour au menu principal"
echo "X. Quitter"
read -p "Votre réponse : " choix
case $choix in
    #on va a la fonction recherche_information pour rechercher le log info
    1) enregistrement_tout "Direction vers la recherche d'information déjà demandée"
    recherche_information
    ;;
    2) enregistrement_tout "Direction vers la recherche sur un évenement, une action, un déplacement"
    recherche_log
    ;;
    r) enregistrement_tout "Retour vers le menu Start"
	start ;;
	
	x) echo -e "\n\tAu revoir !" 
	enregistrement_tout "*********EndScript*********"
    exit 0 ;;
	
	*) echo "Choix invalide, veuillez réessayer" ;;
esac

}



############################

recherche_log()
{
echo ""
echo "Quelle est votre recherche ?"
echo "Vous pouvez rechercher par le nom d'utilisateur"
echo "Par la date YYYY/MM/DD"
echo "Par l'évenement (Vision de..., Déplacement menu ..., Activation SSH ...) "
read -p "Votre réponse : " recherche
cat /var/log/log_evt.log | grep "$recherche"
if ! [ $? -eq 0 ]
then
	echo "Aucune donnée de cette recherche n'a été trouvée, essayez une autre recherche"
fi
#proposition d'autre recherche
read -p "Voulez-vous faire une autre recherche? (o/n) " encore
case $encore in
    o) enregistrement_tout "Nouvelle recherche sur un évenement, une action, un déplacement"
    recherche_log ;;
#pas d'autre recherche, retour au menu principal
    n) enregistrement_tout "Direction vers le menu principal"
	start ;;
    *) echo "Choix invalide, veuillez réessayer" ;;
esac

}



######################

recherche_information()
{
echo ""
read -p "Quelle est votre recherche ? " recherche
#On va faire une recherche des fichiers dans le log pour voir si un ou plusieurs fichiers contiennent $recherche
#Si c'ets le cas, alors il y aura un message disant qu'une information à ce sujet se trouve dans le fichier <nom du fichier> avec l'information correspondante
#est ce que la cible est paramétrée (donc dans /etc/hosts) pour une machine ou dans /etc/passwd pour un user
#on met un $ a la fin de la recherche dans /etc/hosts car il y a d'abord l'IP puis le nom (que l'on veut ici) et que' l'on veut que ca se finisse par ce que l'on a écrit dans la variable (ex : pour wilder10 et wilder100 ; ecrire "wilder10" donnera "wilder10" ET wilder"100" donc même si wilder10 n'existe pas, si wilder100 existe alors le résultat sera 0 (reussite). Or, ce n'est pas ce qui est voulu.
#Même raisonnement avec ^ pour que ce soit en début de chaine, comme dans /etc/passwd c'est écrit sous format user:...:...
for fichier in $dossier_log/*
do
	if cat "$fichier" | grep "$recherche" > /dev/null
	extrait=$(cat "$fichier" | grep "$recherche")
	then
		echo -e "\nIl y a une information à ce sujet dans le fichier $fichier"
		echo "Voici un extrait : $extrait"
	fi

done
if ! [ $? -eq 0 ]
then
	echo "Aucun fichier ne contient votre recherche, essayez une autre recherche"
fi
#proposition d'autre recherche
read -p "Voulez-vous faire une autre recherche? (o/n) " encore
case $encore in
    o) enregistrement_tout "Nouvelle sur un évenement, une action, un déplacement"
    recherche_information ;;
#pas d'autre recherche, retour au menu principal
    n) enregistrement_tout "Direction vers le menu principal"
	start ;;
    *) echo "Choix invalide, veuillez réessayer" ;;
esac
}


#####################################


enregistrement_tout()
{
    #mettre l'evenement en argument 1
evenement=$1
#on utilise la commande tee -a pour ajouter au fichier log_evt/log car ce fichier se trouvant dans /var/log, et n'ayant pas l'autorisation de modifier et sauvegarder (écrire) dans ce dossier, on ne peut pas utiliser la redirection via ">>". On utilise donc une commande, avec laquelle on peut faire un sudo et permettre de modifier ce fichier.
    echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-$evenement" | sudo tee -a /var/log/log_evt.log > /dev/null

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
		o) ssh "sudo ufw allow from $ip_specifique"
		echo "Traffic entrant depuis l'adresse IP $ip_specifique autorisé" 
		echo "Il est possible de voir toutes les règles en place dans 'Voir l'état du pare-feu'"
		enregistrement_tout "Activation_traffic_de_$ip_specifique vers $IP";;
		
		#inversement, on bloque les connexions avec l'adresse ip renseignée : ip_onoff
		#Les "vérifications" se font automatiquement : il y a en sortie normale si la regle a été ajoutée ou non
		n) ssh "sudo ufw deny out to $ip_specifique"
		echo "Traffic sortant vers l'adresse IP $ip_specifique bloqué" 
		echo "Il est possible de voir toutes les règles en place dans 'Voir l'état du pare-feu'"
		enregistrement_tout "Désactivation traffic de $IP vers $ip_specifique"
		;;
	esac ;;
	
	#Activation/désactivation de ssh	
	2) read -p "Souhaitez vous activer (o) ou désactiver (n) les connexions via ssh ?" ssh_onoff
	case $ssh_onoff in
		o) ssh "sudo ufw allow in ssh"
		echo "Connexion via autorisée" 
		enregistrement_tout "Activation connexion SSH"
		;;
		n) ssh "sudo ufw deny in ssh"
		echo "Connexion via bloquée"  
		enregistrement_tout "Désactivation connexion SSH"
		;;
	esac ;;
	
	#Réinitialisation par défaut, attention le pare-feu est donc désactivé après ça
	A|a) ssh "sudo ufw reset "
	enregistrement_tout "Réinitialisation des règles de pare-feu par défaut" ;;
	
	R|r) enregistrement_tout "Retour vers le menu Security"
	security ;;
	
	X|x) echo -e "\n\tAu revoir !" 
	enregistrement_tout "*********EndScript*********"
  	exit 0 ;;
	
	*) echo "Choix invalide, veuillez réessayer" ;;	
esac
}

#####################################

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
	ssh "sudo ufw enable"
	enregistrement_tout "Activation pare-feu"
	;;
	
	#désactivation parefeu
	2) echo ""
	ssh "sudo ufw disable "
	enregistrement_tout "Désactivation pare-feu"
	;;
	
	#definir les règles de pare-feu -> fonction regles
	3) enregistrement_tout "Direction vers le menu Regles"
	regles ;;
	
	#voir l'état pare-feu
	4) echo ""
	ssh "sudo ufw status" | tee -a $dossier_log/$ordi_info_log
	enregistrement_tout "Voir état du pare-feu" ;;
	
	#Voir les ports ouverts
	5) echo ""
	ssh "netstat -tlnpu" | tee -a $dossier_log/$ordi_info_log
	enregistrement_tout "Infos ports ouverts" ;;
	
	6) enregistrement_tout "Direction menu gestion des droits d'un utilisateur sur un dossier ou fichier"
    Gestion_Droits ;;
	
	#Dernière connexion utilisateur
	7) echo ""
	read -p "Pour quel utilisateur ? " user
	#Avoir que la premiere ligne
	ssh "last -F $user | head -n 1" | tee -a $dossier_log/$user_info_log
	enregistrement_tout "Infos dernière connexion utilisateur pour $user" ;;
	
	#Derniere modif  mdp
	8) echo ""
	read -p "Pour quel utilisateur ? " user
	#Avoir que la premiere ligne
	ssh "sudo chage -l $user | head -n 1" | tee -a $dossier_log/$user_info_log
	enregistrement_tout "Infos dernier changement mot de passe pour $user" ;;
	
	#Liste sessions ouverte
	9) echo ""
	read -p "Pour quel utilisateur ? " user
	ssh "w $user" | tee -a $dossier_log/$user_info_log
	enregistrement_tout "Infos liste des sessions ouvertes pour $user" ;;
	
	r) enregistrement_tout "Retour vers le menu Start"
	start ;;
	
	x) echo -e "\n\tAu revoir !" 
	enregistrement_tout "*********EndScript*********"
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
	ssh "ip a | grep "link/ether*" | awk -F " " '{print $2}'" | tee -a $dossier_log/$ordi_info_log  
	enregistrement_tout "Infos adresse mac de $HOSTNAME" ;;
	
	#Voir adresse IP des interfaces
	2) echo ""
	ssh "cat /etc/hosts | grep "127*"" | tee -a $dossier_log/$ordi_info_log  
	enregistrement_tout "Infos adresses IP des interfaces connectées avec $HOSTNAME" ;;
	
	#Voir le nombre d'interfaces (donc le nombre de lignes)
	3) echo ""
	ssh "cat /etc/hosts | grep "127*" | wc -l" | tee -a $dossier_log/$ordi_info_log
	enregistrement_tout "Infos nombre d'interfaces connectées à $HOSTNAME" ;;
	
	#retour au menu précédent
	R|r) enregistrement_tout "Retour au menu principal"
	start ;;
	
	X|x) echo -e "\n\tAu revoir !"
  	enregistrement_tout "*********EndScript*********"
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
    echo -e "\n Que voulez-vous faire ?"
    echo "1. Modifier les droits/permissions de l'utilisateur sur un dossier"
    echo "2. Modifier les droits/permissions de l'utilisateur sur un fichier"
    echo "3. Voir les droits/permissions sur un dossier"
    echo "4. Voir les droits/permissions sur un fichier"
    echo "R. Retour au menu précédent"
    echo "X. Quitter"
    read -p "Votre choix : " choix
    case $choix in
    #Choix de donner plus ou moins de droits (pour limiter le choix plus tard)
        1) read -p "Voulez-vous donner plus de droits (+) ou enlever des droits (-) ? " signe
        case $signe in
       		+) read -p "Nom d'utilisateur : " user
		    # Vérification si l'utilisateur existe
	    	if ssh "id "$user"" &>/dev/null; then
			read -p "Nom du dossier (entrez le path absolu) : " dossier
			# Vérification si le dossier existe
                if ssh "[ -d "$dossier" ]";
                    then
                    echo -e "\n1) Donner les droits de lecture à l'utilisateur"
                    echo "2) Donner les droits d'écriture à l'utilisateur"
                    echo "3) Donner les droits d'exécution à l'utilisateur"
                    echo -e "\nPlusieurs choix possibles, comme 123"
                    read -p "Votre réponse : " droits
                    # Pour chaque réponse donnée, on va faire l'application, permet de faire une reponse 123 pour tout faire d'un coup
                    for droit in $(echo "$droits" | grep -o "[1-3]" ); do
		            case "$droit" in
		            	1) ssh "sudo chmod u+r "$dossier""
		            	echo "Droits de lecture ajoutés" 
	                    enregistrement_tout "Ajout droits de lecture de $user sur $dossier" ;;
		            	2) ssh "sudo chmod u+w "$dossier""
	                    enregistrement_tout "Ajout droits d'écriture de $user sur $dossier"
		             	echo "Droits d'écriture ajoutés" ;;
		            	3) ssh "sudo chmod u+x "$dossier""
	                    enregistrement_tout "Ajout droits d'execution de $user sur $dossier"
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
	    	if ssh "id "$user"" &>/dev/null; then
			read -p "Nom du dossier (entrez le path absolu) : " dossier
			# Vérification si le dossier existe
                if ssh "[ -d "$dossier" ]";
                    then
                    echo -e "\n1) Enlever les droits de lecture à l'utilisateur"
                    echo "2) Enlever les droits d'écriture à l'utilisateur"
                    echo "3) Enlever les droits d'exécution à l'utilisateur"
                    echo -e "\nPlusieurs choix possibles, comme 123"
                    read -p "Votre réponse : " droits
                    # Pour chaque réponse donnée, on va faire l'application, permet de faire une reponse 123 pour tout faire d'un coup
                    for droit in $(echo "$droits" | grep -o "[1-3]"); do
		            case "$droit" in
		            	1) ssh "sudo chmod u-r "$dossier""
		            	echo "Droits de lecture enlevés" 
	                    enregistrement_tout "Suppression droits de lecture de $user sur $dossier" ;;
		            	2) ssh "sudo chmod u-w "$dossier" "
		             	echo "Droits d'écriture enlevés" 
	                    enregistrement_tout "Suppression droits d'écriture de $user sur $dossier" ;;
		             	3) ssh "sudo chmod u-x "$dossier""
		            	echo "Droits d'exécution enlevés" 
	                    enregistrement_tout "Suppression droits d'execution de $user sur $dossier" ;;
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
	    	if ssh "id "$user"" &>/dev/null; then
			read -p "Nom du fichier (entrez le path absolu) : " fichier
			# Vérification si le fichier existe
                if ssh "[ -f "$fichier" ]";
                    then
                    echo -e "\n1) Donner les droits de lecture à l'utilisateur"
                    echo "2) Donner les droits d'écriture à l'utilisateur"
                    echo "3) Donner les droits d'exécution à l'utilisateur"
                    echo -e "\nPlusieurs choix possibles, comme 123"
                    read -p "Votre réponse : " droits
                    # Pour chaque réponse donnée, on va faire l'application, permet de faire une reponse 123 pour tout faire d'un coup
                    for droit in $(echo "$droits" | grep -o "[1-3]"); do
		            case "$droit" in
		            	1) ssh "sudo chmod u+r "$fichier""
		            	echo "Droits de lecture ajoutés"
	                    enregistrement_tout "Ajout droits de lecture de $user sur $fichier" ;;
		            	2) ssh "sudo chmod u+w "$fichier""
		              	echo "Droits d'écriture ajoutés" 
                        enregistrement_tout "Ajout droits d'écriture de $user sur $fichier" ;;
		              	3) ssh "sudo chmod u+x "$fichier""
		            	echo "Droits d'exécution ajoutés" 
                        enregistrement_tout "Ajout droits d'execution de $user sur $fichier" ;;
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
	    	if ssh " id "$user"" &>/dev/null; then
			read -p "Nom du fichier (entrez le path absolu) : " fichier
			# Vérification si le fichier existe
                if ssh "[ -f "$fichier" ]";
                    then
                    echo -e "\n1) Enlever les droits de lecture à l'utilisateur"
                    echo "2) Enlever les droits d'écriture à l'utilisateur"
                    echo "3) Enlever les droits d'exécution à l'utilisateur"
                    echo -e "\nPlusieurs choix possibles, comme 123"
                    read -p "Votre réponse : " droits
                    # Pour chaque réponse donnée, on va faire l'application, permet de faire une reponse 123 pour tout faire d'un coup grace a la boucle for
                    for droit in $(echo "$droits" | grep -o "[1-3]"); do
		            case "$droit" in
		            	1) ssh "sudo chmod u-r "$fichier""
		            	echo "Droits de lecture enlevés" 
                        enregistrement_tout "Suppression droits de lecture de $user sur $fichier"  ;;
		            	2) ssh "sudo chmod u-w "$fichier""
		            	echo "Droits d'écriture enlevés" 
                        enregistrement_tout "Suppression droits d'écriture de $user sur $fichier" ;;
		            	3) ssh "sudo chmod u-x "$fichier""
		            	echo "Droits d'exécution enlevés" 
                        enregistrement_tout "Suppression droits d'execution de $user sur $fichier" ;;
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

        3) read -p "Nom du dossier (entrez le path absolu) : " dossier
        ll $dossier | head -n 2 | tail -n 1 
        enregistrement_tout "Vision des droits sur le dossier $dossier" ;;

        4) read -p "Nom du fichier (entrez le path absolu) : " fichier
        ll $fichier | head -n 2 | tail -n 1
        enregistrement_tout "Vision des droits sur le fichier $fichier" ;;


        R|r) enregistrement_tout "Retour vers le menu gestion de la sécurité"
            security
            ;;
        X|x) echo -e "\n\tAu revoir !"
        enregistrement_tout "*********EndScript*********"
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
# Execution du script avec ssh et les données qui ont été renseignées
 	1) ip="172.16.20.30"
    # On donne les droits d'execution a l'utilisateur sur lequel on est, au cas ou c'est pas deja le cas
        ssh ssh -t $user@$ip "chmod u+x $script"
 		ssh -t $user@$ip "$script "
        enregistrement_tout "Execution du script $script sur la machine $ip par l'user $user" ;;
 		
 	2) ip="172.16.20.20"
    # On donne les droits d'execution a l'utilisateur sur lequel on est, au cas ou c'est pas deja le cas
        ssh ssh -t $user@$ip "chmod u+x $script"
 		ssh -t $user@$ip "$script "
        enregistrement_tout "Execution du script $script sur la machine $ip par l'user $user" ;;
 		
 	3) ip="172.16.20.5"
    # On donne les droits d'execution a l'utilisateur sur lequel on est, au cas ou c'est pas deja le cas
        ssh ssh -t $user@$ip "chmod u+x $script"
 		ssh -t $user@$ip "$script" 
        enregistrement_tout "Execution du script $script sur la machine $ip par l'user $user" ;;

 # on peut aussi exécuter le script sur la machine actuelle, sans ssh du coup
 	4) echo "Vous êtes déjà sur cette machine, voulez vous exécuter le script? "
 	    echo "o/n"
 		read -p "Votre réponse : " reponse
 		case reponse in
 			o) chmod u+x $script
            # On a donné les droits d'execution a l'utilisateur sur lequel on est, au cas ou c'est pas deja le cas
            ./$script 
 			enregistrement_tout "Execution du script $script sur la machine $ip par l'user $user" ;;
 			n) echo "Retour au menu précédent"
 			enregistrement_tout "Retour au menu repertoire/logiciel"
 			repertoire_logiciel ;;
 		esac ;;
 		R|r) evenement="Retour au menu repertoire/logiciel"
 		enregistrement_tout $evenement
		repertoire_logiciel ;;

 	X|x) echo -e "\n\tAu revoir !"
 	enregistrement_tout "*********EndScript*********"
    exit 0
 		;;

        *) echo "Choix invalide, veuillez réessayer"
 		
esac

}


#####################################


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
	if ssh "[ -d $repertoire ]"
		then echo "Répertoire $repertoire déjà existant"
		else ssh "mkdir $repertoire "
		#Verification repertoire créée
		if ssh "[ -d $repertoire ]"
			then echo "Répertoire $repertoire bien créée"
			enregistrement_tout "Création du répertoire $repertoire"
			
			else echo "Erreur, répertoire $repertoire non créée"
		fi
	fi
	;;
	
	#Suppression dossier
	2) echo ""
	read -p "Quel répertoire voulez-vous supprimer (écrire le path absolu) ? " repertoire	
	#Vérification répertoire pas déja existant
	if ssh "[ -d $repertoire ]"
		then ssh "rm -r $repertoire" 
	#Vérification suppression dossier
		if ssh "[ -d $repertoire ]"
			then echo "Erreur, répertoire $repertoire non supprimé"
			else echo "Répertoire $repertoire bien supprimé"
			enregistrement_tout "Suppression du répertoire $repertoire"
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
	if ssh " apt show $logiciel" > /dev/null
		#il existe alors on l'installe
		then ssh "sudo apt install $logiciel"
		echo "$logiciel est installé" 
		
		#il existe pas
		else echo "$logiciel n'est pas disponible au téléchargement"
		enregistrement_tout "Installation du logiciel $logiciel impossible car absent de la liste des paquets"
		
		#pas de vérification qu'il a bien été installé
		$logiciel > /dev/null
		if ssh "[ $? -eq 0 ]"
			then echo "Le logiciel $logiciel a bien été installé"
			enregistrement_tout "Installation du logiciel $logiciel"
			else echo "Erreur, $logiciel n'a pas été installé"
		fi
	fi
	;;
	
	#Désinstaller un logiciel PROBLEME : en ecrivant le nom du logiciel a désinstaller, on le lance...
	4) echo ""
	read -p "Quel est le logiciel que vous voulez désinstaller? " logiciel
	ssh "$logiciel" 2>&1 /dev/null
	if ssh "[ $? -eq 0 ]"
		then ssh "sudo apt remove $logiciel"
		enregistrement_tout "Désinstallation du logiciel $logiciel"
		else echo "$logiciel n'a pas été trouvé, il n'a donc pas pu être désinstallé"
	fi 
	 ;;
	
	#recherche de paquet/logiciel
	5) echo ""
	ssh "apt list --installed | awk -F "/" '{print $1}'" | tee -a $dossier_log/$ordi_info_log 
	echo ""
	echo "En cherchez vous en un en particulier? "
	read -p "o/n : " recherche
	case $recherche in
		#On souhaite en chercher un en particuler
		o) echo ""
		read -p "Lequel recherchez vous? " logiciel_recherche
		#verification que le paquet est installé
		if ssh "apt list --installed | awk -F "/" '{print $1}' | grep "$logiciel_recherche""
			then ssh "apt list --installed | awk -F "/" '{print $1}' | grep "$logiciel_recherche""
			echo "$logiciel_recherche est bien présent sur cette machine"
			enregistrement_tout "Logiciel $logiciel_recherche est bien présent sur la machine"
			else echo "$logiciel_recherche n'est pas présent sur cette machine"
			enregistrement_tout "Logiciel $logiciel_recherche non présent sur la machine"
		fi
		;;
		n) echo "Retour au menu précédent" 
		return 0  ;;
	esac
	;;
	
	6) enregistrement_tout "Direction exécution d'un script"
	execution_script
	;;
	
	#retour au menu précédent
	R|r) enregistrement_tout "Retour vers le menu principal"
	start ;;
	
	X|x) echo -e "\n\tAu revoir !"
        enregistrement_tout "*********EndScript*********"
    	exit 0 ;;
	
	*) echo "Choix invalide, veuillez réessayer" ;;
esac
done

}


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
            ssh "cut -d: -f1 /etc/passwd" | tee -a $dossier_log/$ordi_info_log
            echo "Les utilisateurs ont été enregistrés dans le fichier $dossier_log/$ordi_info_log"
            enregistrement_tout "Vision de la liste des users"
            ;;
        2)
            read -p "Nom d'utilisateur à créer : " user
            ssh "sudo useradd $user"
            echo "Utilisateur $user créé."
            enregistrement_tout "Création de l'utilisateur $user"
            ;;
        3)
            read -p "Nom d'utilisateur à supprimer : " user
            ssh "sudo userdel $user"
            echo "Utilisateur $user supprimé."
            enregistrement_tout "Suppression de l'utilisateur $user"
            ;;
        4)
            read -p "Nom d'utilisateur pour changer le mot de passe : " user
            ssh "sudo passwd $user"
            echo "Mot de passe changé pour l'utilisateur $user."
            enregistrement_tout "Modification du mot de passe de $user"
            ;;
        5)
            read -p "Nom d'utilisateur à désactiver : " user
            ssh "sudo usermod -L $user"
            echo "Compte utilisateur $user désactivé."
            enregistrement_tout "Désactivation de l'utilisateur $user"
            ;;
        6) enregistrement_tout "Direction menu de gestion des groupes"
           Gestion_Groupe
            ;;
        R|r)
        	# Appel du menu principal
            enregistrement_tout "Retour vers le menu principal"
            start
            ;;
        X|x) echo -e "\n\tAu revoir !"
        enregistrement_tout "*********EndScript*********"
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
            if ssh "id "$user"" &>/dev/null; then
                ssh "sudo usermod -aG sudo $user"
                echo "Utilisateur $user ajouté au groupe d'administration."
                enregistrement_tout "Ajout de l'utilisateur $user au groupe d'administration"
            else
                echo "L'utilisateur $user n'existe pas. Veuillez le créer d'abord."
                enregistrement_tout "Retour vers le menu gestion d'utilisateur"
                Gestion_Utilisateur
                continue
            fi
            ;;
        2)
            read -p "Nom d'utilisateur à ajouter à un groupe : " user
            # Vérification si l'utilisateur existe
            if ssh " id "$user"" &>/dev/null; then
                continue
            else
                echo "L'utilisateur $user n'existe pas. Veuillez le créer d'abord."
                enregistrement_tout "Retour vers le menu gestion d'utilisateur"
                Gestion_Utilisateur
                continue
            fi
            
            ssh "read -p "Nom du groupe : " group"
            # Vérification si le groupe existe
            if ssh " getent group $group" &>/dev/null; then
            	ssh "sudo usermod -aG $group $user"
           	echo "Utilisateur $user ajouté au groupe $group."
           	enregistrement_tout "Ajout de l'utilisateur $user au groupe $group"
                continue
            else
                echo "Le groupe $group n'existe pas. Veuillez le créer d'abord."
                continue
            fi  
            ;;
        3)
            read -p "Nom d'utilisateur à sortir du groupe : " user
            read -p "Nom du groupe : " group
            ssh "sudo gpasswd -d $user $group"
            enregistrement_tout "Suppression de l'utilisateur $user du groupe $group"
            echo "Utilisateur $user sorti du groupe $group."
            ;;
        R|r) enregistrement_tout "Retour vers le menu gestion d'utilisateur"
		Gestion_Utilisateur
            ;;
            
        X|x) echo -e "\n\tAu revoir !" 
        enregistrement_tout "*********EndScript*********"
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
        1) enregistrement_tout "Direction vers le menu d'information du système"
		information_systeme ;;
        2) enregistrement_tout "Direction vers le menu d'action du système"
		action_systeme  ;;
        R|r) enregistrement_tout "Direction vers le menu principal"
		start ;;
        X|x) echo -e "\n\tAu revoir !"
        enregistrement_tout ="*********EndScript*********"
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
                ssh "lscpu" | tee -a $dossier_log/$ordi_info_log
                # On vérifie si le fichier à été crée
                if ssh "[ -f $dossier_log/$ordi_info_log ]"; then
                    echo "Les informations sur le CPU ont été enregistrées dans le fichier $dossier_log/$ordi_info_log"
                    enregistrement_tout "Vision du type de CPU, nombre de coeurs"
                else
                    echo "Erreur lors de la création du fichier $dossier_log/$ordi_info_log."
                fi                
                ;;
            2)
                echo "Mémoire RAM totale :"
                # Enregistrement des informations dans le fichier "info_<ordinateur>-GEN_<Date>.txt"
                ssh "free -h | grep "Mem" | awk '{print $2}'" | tee -a $dossier_log/$ordi_info_log
                # On vérifie si le fichier à été crée
                if ssh "[ -f $dossier_log/$ordi_info_log ]"; then
                    echo "Les informations sur la mémoire RAM totale ont été enregistrées dans le fichier $dossier_log/$ordi_info_log"
                    enregistrement_tout "Vision de la RAM totale"
                else
                    echo "Erreur lors de la création du fichier $dossier_log/$ordi_info_log."
                fi
                ;;
            3)
                echo "Utilisation de la mémoire RAM :"
                # Enregistrement des informations dans le fichier "info_<ordinateur>-GEN_<Date>.txt"
                free -h | grep "Mem" | awk '{print $3}' | tee -a $dossier_log/$ordi_info_log
                # On vérifie si le fichier à été crée
                if ssh "[ -f $dossier_log/$ordi_info_log ]"; then
                    echo "Les informations sur l'utilisation de la mémoire RAM ont été enregistrées dans le fichier $dossier_log/$ordi_info_log"
                    enregistrement_tout "Vision de l'utilisation de la RAM"
                else
                    echo "Erreur lors de la création du fichier $dossier_log/$ordi_info_log."
                fi
                ;;
            4)
                echo "Utilisation du disque :"
                # Enregistrement des informations dans le fichier "info_<ordinateur>-GEN_<Date>.txt"
                ssh "df -h" | tee -a $dossier_log/$ordi_info_log
                # On vérifie si le fichier à été crée
                if ssh " [ -f $dossier_log/$ordi_info_log ]"; then
                    echo "Les informations sur l'utilisation du disque ont été enregistrées dans le fichier $dossier_log/$ordi_info_log"
                    enregistrement_tout "Vision de l'utilisation du disque"
                else
                    echo "Erreur lors de la création du fichier $dossier_log/$ordi_info_log."
                fi
                ;;
            5)
                echo "Utilisation du processeur :"
                # Enregistrement des informations dans le fichier info_<ordinateur>-GEN_<Date>.txt"
                ssh "top -b -n 1 | grep "Cpu"" | tee -a $dossier_log/$ordi_info_log
                # On vérifie si le fichier à été crée
                echo "Les informations sur l'utilisation du processeur ont été enregistrées dans le fichier $dossier_log/$ordi_info_log"
                enregistrement_tout "Vision de l'utilisation du processeur"
                ;;
            6)
                echo "Version du système d'exploitation :"
                # Enregistrement des informations dans le fichier "info_<ordinateur>_<Date>.txt"
                ssh "cat /etc/os-release" | tee -a $dossier_log/$ordi_info_log
                # On vérifie si le fichier à été crée
                if ssh "[ -f $dossier_log/$ordi_info_log ]"; then
                    echo "Les informations sur la version du système d'exploitation ont été enregistrées dans le fichier $dossier_log/$ordi_info_log"
                    enregistrement_tout "Vision du système d'exploitation"
                else
                    echo "Erreur lors de la création du fichier $dossier_log/$ordi_info_log."
                fi
                ;;
            R|r) enregistrement_tout "Direction vers le menu de gestion du systeme"
	   		Gestion_Systeme ;;

            X|x) echo -e "\n\tAu revoir !"
            enregistrement_tout "*********EndScript*********"
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
                enregistrement_tout "Arrêt du système"
                ssh "sudo shutdown -h now"
                ;;
            2)
                echo "Redémarrage du système en cours ..."
                # Redémarrage du système
                enregistrement_tout "Redémarrage du système"
                ssh "sudo shutdown -r now"
                ;;
            3)
                echo "Vérouillage du système en cours ..."
                # Vérouillage du système
                enregistrement_tout "Verrouillage du système"
                ssh "gnome-screensaver-command -l"
                ;;
            4)
                echo "Mise à jour du système en cours ..."
                # Mise à jour du système
                ssh "sudo apt update && sudo apt upgrade -y"
                enregistrement_tout "Mise à jour du systeme"
                ;;
            R|r) enregistrement_tout "Direction vers le menu de gestion du système"
	        Gestion_Systeme ;;
            X|x) enregistrement_tout "*********EndScript*********"
            echo -e "\n\tAu revoir !"
			exit 0 ;;
            *) echo "Choix invalide. Veuillez réessayer." ;;
    esac
    echo "Action effectuée avec succès !"
}


#####################################################################


#fonction pour la connexion ssh
# A noter qu'on la fait avant le menu principal, donc pour changer de cible, il faudra quitter le script puis le relancer ou bien via la fonction pour appeler ce changement de cible depuis le menu principal
ssh_cible()
{
echo -e "\n Sur quelle machine et utilisateur voulez-vous vous connecter ?"
read -p "Entrez l'adresse IP ou le nom de la machine distante : " ip_remote
read -p "Entrez le nom d'utilisateur auquel vous voulez vous connecter sur cette la machine distante : " user_remote

#on va donc ensuite au menu principal
start
}



#petite fonction pour les commandes en ssh
ssh()
{
ssh -t $user_remote@$ip_remote
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
echo "6. Rechercher une information déjà demandée/un évenement"
echo "0. Changer de cible utilisateur et machine"
echo "X. Quitter"
read -p "Votre réponse : " choix
case $choix in
    #direction vers gestion utilisateur = lancement fonction Gestion_Utilisateur
    1) enregistrement_tout "Direction vers le menu de gestion des utilisateurs"
    Gestion_Utilisateur ;;

    #direction vers security = lancement fonction security
    2) enregistrement_tout "Direction vers le menu de gestion de la sécurité"
    security ;;

    #direction vers reseaux = lancement fonction reseaux
    3) enregistrement_tout "Direction vers le menu de gestion du paramétrage réseau"
    reseaux ;;

    #direction vers repertoire_logiciel = lancement fonction repertoire_logiciel
    4) enregistrement_tout "Direction vers le menu de gestion des logiciels et répertoires"
    repertoire_logiciel ;;

    #direction vers Gestion_Systeme = lancement fonction Gestion_Systeme
    5) enregistrement_tout "Direction vers le menu de gestion du système"
    Gestion_Systeme ;;

    6) enregistrement_tout "Direction vers la recherche d'information déjà demandée / recherche dans le log"
    recherche_tout
    ;;

    0) enregistrement_tout "Changement de cible via ssh"
    ssh_cible ;;

    X|x) echo -e "\n\tAu revoir !"
    enregistrement_tout "*********EndScript*********"
    exit 0
    ;;

    *) echo "Choix invalide. Veuillez réessayer." ;;
esac
done
}
###################### APPEL DU MENU PRINCIPAL #######################
enregistrement_tout "********StartScript********"
enregistrement_information
ssh_cible
