#!/bin/bash

# ====>   ScriptBash Sprint1
# Squelette global

# Faire des logs a chaques actions pour garder une trace => journalisation log_evt.log
# Pour le serveur windows, dans C:\Windows\System32\LogFiles
# Pour le serveur Linux, dans /var/log
# Sous la forme ---> <Date>-<Heure>-<Utilisateur>-<Evenement>
# Avec :
# <Date> : Date de l’evenement au format yyyy/mm/dd
# <Heure> : Heure de l'événement au format hh/mm/ss
# <Utilisateur> : Nom de l’utilisateur courant exécutant le script
# <Evenement> : Action effectuée (à définir )

# Deux Type de choix globaux ===> Action ou Information

#Fonction : ========> "Fait ou non fait"

# - Création compte utilisateur local 
# - Changement de mot de passe 
# - Suppression compte utilisateur local
# - Désactivation compte utilisateur local 

#Fonction : ========> "Fait ou non fait"

# - Ajout à un groupe local 
# - Sortie d'un groupe local 

#Fonction : ========> "Fait ou non fait"

# - Arret 
# - Redémarrage 
# - Vérouillage 

#Fonction : ========> "Fait ou non fait"

# - Mise-à-jour du système 

#Fonction : ========> "Fait ou non fait"

# - Création de répertoire 
# - Modification de repertoire 
# - -Suppression de répertoire 

#Fonction : ========> "Fait ou non fait"

# - Prise en main a distance (CLI)

# Fonction : ========> "Fait ou non fait"

# - Définition de règle de pare-feu 
# - Activation du pare-feu
# - Désactivation du pare feu 

#Fonction : ========> "Fait ou non fait"

# - Type de CPU, nombre de coeurs, etc.
# - Mémoire RAM totale
# - Utilisation de la RAM
# - Utilisation du disque
# - Utilisation du processeur

#Fonction : ========> "Fait ou non fait"

# - Date de dernière connexion d’un utilisateur
# - Date de dernière modification du mot de passe
# - Liste des sessions ouvertes par l'utilisateur

#Fonction : ========> "Fait ou non fait"

# - Groupe d’appartenance d’un utilisateur
# - Historique des commandes exécutées par l'utilisateur

#Fonction : ========> "Fait ou non fait"

# - Droits/permissions de l’utilisateur sur un dossier
# - Droits/permissions de l’utilisateur sur un fichier

#Fonction : ========> "Fait ou non fait"

# - Version de l'OS

#Fonction : ========> "Fait ou non fait"

# - Nombre de disque
# - Partition (nombre, nom, FS, taille) par disque

#Fonction : ========> "Fait ou non fait"

# - Liste des applications/paquets installées
# - Liste des services en cours d'execution
# - Liste des utilisateurs locaux



#Fonction : 

# - Recherche des evenements dans le fichier log_evt.log pour un utilisateur
# - Recherche des evenements dans le fichier log_evt.log pour un ordinateur

#Fonction : 

# - Mise-à-jour du système 

#Fonction 

# - Installation de logiciel
# - Désinstallation de logiciel 
# - Execution de script sur la machine distante 


###################################################

#####################################

regles()
{
echo ""
echo "Que voulez vous faire :"
echo "1) Activer/désactiver les connexions avec une adresse IP spécifique"
echo "2) Activer/désactiver les connexions via ssh"
echo "a) Annuler et réinitialiser par défaut"
echo "R) Menu Précédent"
echo "X) Quitter"
read -p "Votre réponse : " choix
case $choix in
	#Activation/désactivation des connexions IP avec une adresse donnée
	1) read -p 'Souhaitez vous activer (o) ou désactiver (n) les connexions avec une adresse IP spécifique ? ' ip_onoff
	#On demande l'adresse
	read -p "Avec quelle adresse IP ? " ip_specifique
	case $ip_onoff in
		o) sudo ufw allow from $ip_specifique
		echo "Traffic entrant depuis l'adresse IP $ip_specifique autorisé"   
		echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Activation traffic de $ip_specifique vers $IP" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
	
		#Les "vérifications" se font automatiquement : il y a en sortie normale si la regle a été ajoutée ou non
		n) sudo ufw deny out to $ip_specifique
		echo "Traffic sortant vers l'adresse IP $ip_specifique bloqué"  
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
	
	R|r) security  
	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Retour vers le menu Security" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
	
	X|x) exit 0  
	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Sortie du script" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
	
	*) echo "Réponse mal comprise, réessayez en tapant le chiffre correspondant" ;;	
esac
}



security()
{
while true; do
echo ""
echo "Que voulez vous faire ? "
echo "1) Activer un pare-feu"
echo "2) Désactiver un pare-feu"
echo "3) Définir des règles de pare-feu"
echo "4) Voir l'état du pare-feu"
echo "5) Voir les ports ouverts"
echo "6) Voir la dernière connexion d'un utilisateur"
echo "7) Voir la date de dernier changement de mot de passe"
echo "8) Voir le nombre d'interfaces"
echo "r) Retour"
echo "x) Quitter"
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
	3) regles  
	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Direction vers le menu Regles" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
	
	#voir l'état pare-feu
	4) echo ""
	sudo ufw status
	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Voir état du pare-feu" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
	
	#Voir les ports ouverts
	5) echo ""
	sudo netstat -tlnpu
	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Infos ports ouverts" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
	
	#Dernière connexion utilisateur
	6) echo ""
	read -p "Pour quel utilisateur ? " user
	#Avoir que la premiere ligne
	last -F $user | head -n 1 
	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Infos dernière connexion utilisateur" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
	
	#Deriere modif  mdp
	7) echo ""
	read -p "Pour quel utilisateur ? " user
	#Avoir que la premiere ligne
	sudo chage -l $user | head -n 1
	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Infos dernier changement mot de passe" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
	
	#Liste sessions ouverte
	8) echo ""
	read -p "Pour quel utilisateur ? " user
	w $user
	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Infos liste des sessions ouvertes pour $user" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
	
	r) start  
	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Retour vers le menu Start" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
	
	x) exit 0  
	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Sortie du script" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
	
	*) echo "Réponse mal comprise, réessayez en tapant le chiffre correspondant" ;;
esac
done
}

#######################################




# RESEAUX
reseaux()
{
while true; do
echo ""
echo "Que voulez vous faire ? "
echo "1) Voir l'adresse MAC"
echo "2) Voir les adresses IP des interfaces"
echo "3) Voir le nombre d'interfaces"
echo "R) Menu Principal"
echo "X) Quitter"
read -p "Votre réponse : " choix
case $choix in
	#Voir l'adresse MAC IL MANQUE SSH
	1) echo ""
	ip a | grep "link/ether*" | awk -F " " '{print $2}'  
  	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Infos adresse mac de $HOSTNAME" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
	
	#Voir adresse IP des interfaces (pas besoin de SSH)
	2) echo ""
	cat /etc/hosts | grep "127*"  
  	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Infos adresses IP des interfaces connectées avec $HOSTNAME" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
	
	#Voir le nombre d'interfaces (donc le nombre de lignes)
	3) echo ""
	cat /etc/hosts | grep "127*" | wc -l 
  	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Infos nombre d'interfaces connectées à $HOSTNAME" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
	
	#retour au menu précédent
	R|r) start
 	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Retour au premier menu" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
	
	X|x)
	   exit 0  
	   echo "A bientôt !"
  	   echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Sortie du menu reseaux" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
	
	*) echo "Réponse mal comprise, réessayez en tapant le chiffre correspondant" ;;
esac
done

}


#####################################

Gestion_Droits() {
while true ;
do
    echo "Bienvenu dans la gestion des droits, choisissez une option :"
    echo "1. Droits/Permissions de l'utilisateur sur un dossier :"
    echo "2. Droits/Permissions de l'utilisateur sur un fichier :"
    echo "X. Revenir au menu précédent"
    read -p "Votre choix : " choix
    case $choix in
        1)
            read -p "Nom d'utilisateur : " user
            # Vérification si l'utilisateur existe
            if id "$user" &>/dev/null; then
                continue
            else
                echo "L'utilisateur $user n'existe pas. Veuillez le créer d'abord."
                Gestion_Droits
                continue
            fi
            read -p "Nom du dossier : " dossier
            # Vérification si le dossier existe
            if [ -d "$dossier" ]; then
                continue
            else
                echo "Le dossier $dossier n'existe pas. Veuillez le créer d'abord."
                Gestion_Droits
                continue
            fi
            sudo chown $user:$user $dossier
            echo "Droits de l'utilisateur $user sur le dossier $dossier modifiés."
            ;;
        2)
            read -p "Nom d'utilisateur : " user
            # Vérification si l'utilisateur existe
            if id "$user" &>/dev/null; then
                continue
            else
                echo "L'utilisateur $user n'existe pas. Veuillez le créer d'abord."
                Gestion_Droits
                continue
            fi
            read -p "Nom du fichier : " fichier
            # Vérification si le fichier existe
            if [ -f "$fichier" ]; then
                continue
            else
                echo "Le fichier $fichier n'existe pas. Veuillez le créer d'abord."
                Gestion_Droits
                continue
            fi
            sudo chown $user:$user $fichier
            echo "Droits de l'utilisateur $user sur le fichier $fichier modifiés."
            ;;
        R|r)
            security
            ;;
        X|x) exit 0
            echo " A bientôt"
        *)
            echo "Choix invalide, veuillez réessayer."
            Gestion_Droits
            ;;
    esac
done
}

##########################################

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
	echo "R) Menu précédent"
	echo "X) Quitter"
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
 		R|r) repertoire_logiciel;;
 		X|x) exit 0
 		echo " A bientôt !"
 		;;
 		
esac

}





repertoire_logiciel()
{
while true; do
echo ""
echo -e "\t Bienvenu dans le menu Répertoire/logiciel "
echo "Que voulez vous faire ? "
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
	R|r) start 
		echo "Retour dans le menu principal" ;;
	
	X|x) exit 0 
	echo " A bientôt ! ";;
	
	*) echo "Réponse mal comprise, réessayez en tapant le chiffre correspondant" ;;
esac
done

}

###################################################

########################## Fonction PRINCIPALE Gestion Utilisateur  ##############################

Gestion_Utilisateur() {
while true ;
do
    echo -e "\t Bienvenu dans le menu de gestion d'utilisateurs !"
    echo "Choississez une option :"
    echo "1. liste des utilisateurs"                    
    echo "2. Création d'un utilisateur"                 
    echo "3. Supprimer un utilisateur"                  
    echo "4. Changement de mot de passe"                
    echo "5. Désactivation de compte utilisateur"       
    echo "6. Gestion des groupes"   
    echo "R. Menu Principale"                    
    echo "X. Quitter"
    read -p "Votre choix : " choix
    case $choix in
        1)
            echo "Liste des utilisateurs :" 
            # Enregistrement des utilisateurs dans le fichier "info_<Utilisateur>-GEN_<Date>.txt"
            cut -d: -f1 /etc/passwd | tee -a $dossier_log/$fichier_log
            echo "Les utilisateurs ont été enregistrés dans le fichier $dossier_log/$fichier_log"
            ;;
        2)
            read -p "Nom d'utilisateur à créer : " user
            sudo useradd $user
            echo "Utilisateur $user créé."
            ;;
        3)
            read -p "Nom d'utilisateur à supprimer : " user
            sudo userdel $user
            echo "Utilisateur $user supprimé."
            ;;
        4)
            read -p "Nom d'utilisateur pour changer le mot de passe : " user
            sudo passwd $user
            echo "Mot de passe changé pour l'utilisateur $user."
            ;;
        5)
            read -p "Nom d'utilisateur à désactiver : " user
            sudo usermod -L $user
            echo "Compte utilisateur $user désactivé."
            ;;
        6)
            Gestion_Groupe
            ;;
        R|r)
        	# Appel du squelette principale
            start
            echo "Retour au menu Principale"
            ;;
        X|x)
            exit 0
            echo "A Bientôt"
        *)
            echo "Choix invalide, veuillez réessayer."
            Gestion_Utilisateur
            ;;
    esac
done
}

######################## FONCTION SECONDAIRE -- GESTION_UTILISATEUR ######################################

Gestion_Groupe() {
while true ;
do
    echo "Bienvenu dans la gestion des groupes, choisissez une option :"
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
            else
                echo "L'utilisateur $user n'existe pas. Veuillez le créer d'abord."
                Gestion_Utilisateur
                continue
            fi
            sudo usermod -aG sudo $user
            echo "Utilisateur $user ajouté au groupe d'administration."
            ;;
        2)
            read -p "Nom d'utilisateur à ajouter à un groupe : " user
            # Vérification si l'utilisateur existe
            if id "$user" &>/dev/null; then
                continue
            else
                echo "L'utilisateur $user n'existe pas. Veuillez le créer d'abord."
                Gestion_Utilisateur
                continue
            fi
            
            read -p "Nom du groupe : " group
            # Vérification si le groupe existe
            if getent group $group &>/dev/null; then
                continue
            else
                echo "Le groupe $group n'existe pas. Veuillez le créer d'abord."
                Gestion_Utilisateur
                continue
            fi
            sudo usermod -aG $group $user
            echo "Utilisateur $user ajouté au groupe $group."
            ;;
        3)
            read -p "Nom d'utilisateur à sortir du groupe : " user
            read -p "Nom du groupe : " group
            sudo gpasswd -d $user $group
            echo "Utilisateur $user sorti du groupe $group."
            ;;
        R|r) 
            Gestion_Utilisateur
            
            ;;
            
        X|x)
            exit 0
            echo "A Bientôt !"
            ;;
        *)
            echo "Choix invalide, veuillez réessayer."
            ;;
    esac
done
}

####################### FONCTION PRINCIPALE -- GESTION_SYSTEME ##############################

Gestion_Systeme() {
# Boucle pour relancer la fonction
while true ;
do
    echo "Bienvenue dans la gestion du système !"
    echo "Que voulez-vous faire ? :"
    echo "1. Obtenir une information"
    echo "2. Effectuer une action"
    echo "X. Retour"
    read -p "Votre choix : " choix
    case $choix in
        1)
            information_systeme
            ;;
        2)
            action_systeme
            ;;
        X|x)
            echo "Retour à l'accueil"
            # Appel du squelette principale
            start
            ;;
        *)
            echo "Choix invalide. Veuillez réessayer."
            return 1
            ;;
    esac
done
}

####################### FONCTION SECONDAIRE -- GESTION_SYSTEME ##############################
information_systeme() {
    echo " Vous êtes à l'intérieur du système !"
    echo " Que voulez-vous savoir ?"
    echo "1. Type de CPU, nombre de coeurs, etc."
    echo "2. Memoire RAM total"
    echo "3. Utilisation de la mémoire RAM"
    echo "4. Utilisation du disque"
    echo "5; Utilisation du processeur"
    echo "6. Version du système d'exploitation"
    echo "X. Revenir au menu principal"
    read -p "Votre choix : " choix
# Initialisation des variables pour les logs
fichier_log="info_$(hostname)_$(date +%Y-%m-%d).txt"
dossier_log="log"
    case $choix in
            1)
                echo  "Type de CPU, nombre de coeurs, etc. :"
                # Enregistrement des informations dans le fichier "info_<ordinateur>-GEN_<Date>.txt"
                lscpu | tee -a $dossier_log/$fichier_log
                echo "Les informations sur le CPU ont été enregistrées dans le fichier $dossier_log/$fichier_log"
                ;;
            2)
                echo "Mémoire RAM totale :"
                # Enregistrement des informations dans le fichier "info_<ordinateur>-GEN_<Date>.txt"
                free -h | grep "Mem" | awk '{print $2}' | tee -a $dossier_log/$fichier_log
                echo "Les informations sur la mémoire RAM totale ont été enregistrées dans le fichier $dossier_log/$fichier_log"
                ;;
            3)
                echo "Utilisation de la mémoire RAM :"
                # Enregistrement des informations dans le fichier "info_<ordinateur>-GEN_<Date>.txt"
                free -h | grep "Mem" | awk '{print $3}' | tee -a $dossier_log/$fichier_log
                echo "Les informations sur l'utilisation de la mémoire RAM ont été enregistrées dans le fichier $dossier_log/$fichier_log"
                ;;
            4)
                echo "Utilisation du disque :"
                # Enregistrement des informations dans le fichier "info_<ordinateur>-GEN_<Date>.txt"
                df -h | tee -a $dossier_log/$fichier_log
                echo "Les informations sur l'utilisation du disque ont été enregistrées dans le fichier $dossier_log/$fichier_log"
                ;;
            5)
                echo "Utilisation du processeur :"
                # Enregistrement des informations dans le fichier info_<ordinateur>-GEN_<Date>.txt"
                top -b -n 1 | grep "Cpu(s)" | tee -a $dossier_log/$fichier_log
                echo "Les informations sur l'utilisation du processeur ont été enregistrées dans le fichier $dossier_log/$fichier_log"
                ;;
            6)
                echo "Version du système d'exploitation :"
                # Enregistrement des informations dans le fichier "info_<ordinateur>_<Date>.txt"
                cat /etc/os-release | tee -a $dossier_log/$fichier_log
                echo "Les informations sur la version du système d'exploitation ont été enregistrées dans le fichier $dossier_log/$fichier_log"
                ;;
            X|x)
                echo "Vous êtes de retour dans le menu principal."
                ;;
            *)
                echo "Choix invalide. Veuillez réessayer."
                # Appel pour redémarrer la fonction
                information_systeme
                ;;
    esac
}
####################### FONCTION SECONDAIRE -- GESTION_SYSTEME ##############################
action_systeme() {
    echo " Que souhaitez-vous effectuer ?"
    echo "1. Arrêter le système"
    echo "2. Redémarrer le système"
    echo "3. Vérouiller le système (GNOME-ONLY)"
    echo "4. Mettre à jour le système"
    echo "X. Revenir au menu principal"
    read -p "Votre choix : " choix
    case $choix in
            1)
                echo "Arrêt du système en cours ..."
                # Arrêt du système
                sudo shutdown -h now
                ;;
            2)
                echo "Redémarrage du système en cours ..."
                # Redémarrage du système
                sudo shutdown -r now
                ;;
            3)
                echo "Vérouillage du système en cours ..."
                # Vérouillage du système
                gnome-screensaver-command -l
                ;;
            4)
                echo "Mise à jour du système en cours ..."
                # Mise à jour du système
                sudo apt update && sudo apt upgrade -y
                ;;
            X|x)
                echo "Vous êtes de retour dans le menu principal."
                ;;
            *)
                echo "Choix invalide. Veuillez réessayer."
                # Appel pour redémarrer la fonction
                action_systeme
                ;;
    esac
    echo "Action effectuée avec succès !"
}








#################### LANCEMENT DU SQUELETTE ##########################

start()
{
while true ;
do
echo ""
echo -e "\t Bienvenue dans le menu d'adminitration "
echo -e "\n Que voulez-vous faire ? "
echo -e "\n1) Gérer les utilisateurs"
echo "2) Gérer la sécurité"
echo "3) Gérer le paramétrage réseaux"
echo "4) Gérer les logiciels et répertoires"
echo "5) Gérer le système"
echo "x) Quitter"
read -p "Votre réponse : " choix
case $choix in
    #direction vers gestion utilisateur = lancement fonction Gestion_Utilisateur
    1) Gestion_Utilisateur ;;

    #direction vers security = lancement fonction security
    2) security ;;

    #direction vers reseaux = lancement fonction reseaux
    3) reseaux ;;

    #direction vers repertoire_logiciel = lancement fonction repertoire_logiciel
    4) repertoire_logiciel ;;

    #direction vers Gestion_Systeme = lancement fonction Gestion_Systeme
    5) Gestion_Systeme ;;

    X|x) 
    echo -e "\n\tAu revoir !"
    exit 0
    ;;

    *) echo "Choix invalide. Veuillez réessayer." ;;
esac
done
}
start