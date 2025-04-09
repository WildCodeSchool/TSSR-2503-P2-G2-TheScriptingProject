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

#!/bin/bash





#FONCTIONS

#Le menu demande si on veut faire une action ou une demande d'information
start()
{
echo ""
echo "Voulez vous faire une action ou avoir une information ? "
echo "1) Faire une action"
echo "2) Avoir une information"
echo "x) Quitter"
read -p "Votre réponse : " choix1
case $choix1 in
	#direction vers les actions = lancement fonction ACTIONS
	1) action ;;
	
	#direction vers les renseignements = lancement fonction INFOS
	2) infos ;;
esac
return 0
}

################################################

#Choix 1 = ACTION
# texte informatif disant qu'on entre dans le menu actions
action()
{
echo ""
echo "Vous avez choisi de faire une action"
echo ""
echo "Voulez-vous cibler un serveur ou bien un client?"
echo "1) Un serveur"
echo "2) Un client"
echo "r) Retour au menu précédent"
echo "x) Quitter"
read -p "Votre réponse : " cible
case $cible in 
	1) action_serveur ;;
	2) action_client ;;
	r) start ;;
	x) echo "Sortie du menu"
 	exit 0 ;;
	
	*) echo "Réponse mal comprise, réessayez en tapant le chiffre correspondant" ;;
esac
return 0
}

################################################


#Choix 2 = SERVEUR
# texte informatif disant qu'on entre dans le menu ACTION SERVEUR
action_serveur()
{
echo ""
echo "Vous avez choisi pour cible le serveur"
echo ""
echo "Que voulez-vous faire ? "
echo "1) Gestion d'utilisateur"
echo "2) Gestion de groupe"
echo "r) Retour au menu précédent"
echo "x) Quitter"
read -p "Votre réponse : " choix
case $choix in 
	1) gestion_user ;;
	2) gestion_groupe ;;
	r) action ;;
	x) echo "Sortie du menu"
 	exit 0 ;;
	
	*) echo "Réponse mal comprise, réessayez en tapant le chiffre correspondant" ;;
esac
return 0
}

################################################


#Choix 2 = CLIENT
# texte informatif disant qu'on entre dans le menu ACTION CLIENT
#Pour la tâche principale, le client est UBUNTU
action_client()
{
echo ""
echo "Vous avez choisi pour cible le client, à savoir, CLILIN01"
echo ""
echo "Que voulez-vous faire ? "
echo "1) Arrêter/redemarrer/verrouiller"
echo "2) Gestion de répertoire"
echo "3) Gestion du parefeu"
echo "4) Gestion de logiciel"
echo "5) Prise en main à distance"
echo "6) Mettre à jour le système"
echo "r) Retour au menu précédent"
echo "x) Quitter"
read -p "Votre réponse : " choix
case $choix in 
	1) arv ;;
	2) gestion_répertoire ;;
	3) parefeu ;;
	4) logiciel ;;
	5) distance ;;
	6) maj ;;
	r) action ;;
	x) echo "Sortie du menu"
 	exit 0 ;;
	
	*) echo "Réponse mal comprise, réessayez en tapant le chiffre correspondant" ;;
esac
return 0
}


################################################

#création d'un utilisateur
creation_user()
{
echo ""
echo "Vous avez choisi de créer un utilisateur"
echo ""
read -p "Entrez le nom d'utilisateur à créer " newUser
if cat /etc/passwd | grep "$newUser" > /dev/null 
	 then
	 	echo "L'utilisateur existe déjà"
	 	return 1
	 else
	 	sudo useradd $newUser
#Vérification que le $newUser que a bien été créé
	 	if cat /etc/passwd | grep "$newUser" > /dev/null 
	 	then
	 		echo "Ok, utilisateur créée"
	 	else
	 		echo "Erreur, utilisateur non créée"
	 		return 1
	 	fi
	 fi
return 0
}

##############################################

#modification mdp
modif_mdp()
{
echo ""
echo "Vous avez choisi de modifier un mot de passe"
echo ""
read -p "De quel utilisateur voulez-vous modifier le mot de passe ? " User_mdp
#read -p "Quel mdp? " mdp
	sudo passwd $User_mdp
return 0
}

################################################


#supprimer user

suppression()
{
echo ""
echo "Vous avez choisi de faire supprimer un utilisateur"
echo ""
read -p "Quel utilisateur voulez-vous supprimer ? " utilisateur
sudo userdel $utilisateur
if cat /etc/passwd | grep "$utilisateur"
	then echo "Erreur"
	else echo "Ok, utilisateur supprimé"
fi
return 0
}

###############################################

#désactivation compte user local
verrouillage()
{
echo ""
echo "Vous avez choisi de verrouiller un utilisateur"
echo ""
read -p "Quel utilisateur voulez-vous désactiver ? " utilisateur
sudo usermod -L $utilisateur
echo "Utilisateur $utilisateur verrouillé"
return 0
}

################################################
################################################
	
#Choix = Action
#Le menu demande si on veut faire une action sur l'utilisateur (serveur) ou sur un client
#Choix Serveur=Utilisateur

gestion_user()
{
echo ""
echo "Vous avez choisi de faire une gestion d'utilisateur"
echo ""
#On rentre dans le choix de gestion de l'user, que veut on faire ?
#Boucle while true; do AVANT pour qu'on voit les messages apapraitre et redemander le choix Que voulez vous faire
while true; do

echo "Que voulez-vous faire ? "
echo "1) Création d'un nouvel utilisateur"
echo "2) Modifier le mot de passe d'un utilisateur"
echo "3) Supprimer un utilisateur"
echo "4) Désactiver un utilisateur"
echo "r) Retour au menu précédent"
echo "x) Quitter"
read -p "Votre réponse : " choix

case $choix in
	1) creation_user 
	echo ""
	echo "Retour au menu de gestion d'utilisateur :" 
	echo "";;
	2) modif_mdp 
	echo ""
	echo "Retour au menu de gestion d'utilisateur :" 
	echo "";;
	3) suppression 
	echo ""
	echo "Retour au menu de gestion d'utilisateur :" 
	echo "";;
	4) verrouillage 
	echo ""
	echo "Retour au menu de gestion d'utilisateur :" 
	echo "";;
	r) serveur_action 
	echo ""
	echo "Retour au menu d'action sur le serveur :" 
	echo "";;
	x) echo "Sortie du menu"
 	exit 0 ;;
	
	*) echo "Réponse mal comprise, réessayez en tapant le chiffre correspondant" ;;
esac
done
}

#####################################


gestion_groupe()
{
echo ""
echo "Vous avez choisi de faire une gestion de groupe"
echo ""
#On rentre dans le choix de gestion de groupe, que veut on faire ?
#Boucle while true; do AVANT pour qu'on voit les messages apapraitre et redemander le choix Que voulez vous faire
while true; do

echo "1) Ajout d'utilisateur dans un groupe local"
echo "2) Sortie d'utilisateur dans un groupe local"
echo "3) Ajout d'utilisateur dans un groupe administrateur"
echo "r) Retour au menu précédent"
echo "x) Quitter"
read -p "Que voulez-vous faire ? " choix

case $choix in
	1) ajout_groupe_local
	echo ""
	echo "Retour au menu :" 
	echo "";;
	2) sortie_groupe_local
	echo ""
	echo "Retour au menu :" 
	echo "";;
	3) ajout_groupe_admin
	echo ""
	echo "Retour au menu :" 
	echo "";;
	r) gestion_groupe
	echo ""
	echo "Retour au menu d'action sur le serveur :" 
	echo "";;
	x) echo "Sortie du menu"
 	exit 0 ;;
	
	*) echo "Réponse mal comprise, réessayez en tapant le chiffre correspondant" ;;
esac
done
}



##################################


#Choix 1 = INFOS
# texte informatif disant qu'on entre dans le menu informations
infos()
{
echo ""
echo "Vous avez choisi d'avoir une information"
echo ""
echo "Voulez-vous cibler un serveur ou bien un client?"
echo "1) Un serveur"
echo "2) Un client"
echo "r) Retour au menu précédent"
echo "x) Quitter"
read -p "Votre réponse : " cible
case $cible in 
	1) infos_serveur ;;
	2) infos_client ;;
	r) start ;;
	x) echo "Sortie du menu"
 	exit 0 ;;
	
	*) echo "Réponse mal comprise, réessayez en tapant le chiffre correspondant" ;;
esac
return 0
}


################################################


#Choix 2 = SERVEUR
# texte informatif disant qu'on entre dans le menu INFOS SERVEUR
infos_serveur()
{
echo ""
echo "Vous avez choisi pour cible le serveur"
echo ""
echo "Sur quel thème cherchez-vous une information ? "
echo "1) Droits et permissions"
echo "2) Dates de modifications"
# Soit à mettre maintenant, soit à mettre dans une catégorie, à voir
echo "3) Liste des sessions ouverte par l'utilisateur"
echo "r) Retour au menu précédent"
echo "x) Quitter"
read -p "Votre réponse : " choix
case $choix in 
	1) droits ;;
	2) dates ;;
	3) sessions ;;
	r) infos
	echo ""
	echo "Retour au menu d'action sur le serveur :" 
	echo ""  
	x) echo "Sortie du menu"
 	exit 0  
	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Sortie du script" | sudo tee -a /var/log/log_evt.log > /dev/null
	;;
	
	*) echo "Réponse mal comprise, réessayez en tapant le chiffre correspondant" ;;
esac
}


#####################################

regles()
{
echo ""
echo "Que voulez vous faire :"
echo "1) Activer/désactiver les connexions avec une adresse IP spécifique"
echo "2) Activer/désactiver les connexions via ssh"
echo "a) Annuler et réinitialiser par défaut"
echo "r) Retour"
echo "x) Quitter"
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
	
	r) security  
	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Retour vers le menu Security" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
	
	x) exit 0  
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
echo "r) Retour"
echo "x) Quitter"
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
	r) start
 	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Retour au premier menu" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
	
	x) echo "Sortie du menu"
 	exit 0 
  	echo "$(date +%Y/%m/%d-%H:%M:%S)-$USER-Sortie du menu reseaux" | sudo tee -a /var/log/log_evt.log > /dev/null ;;
	
	*) echo "Réponse mal comprise, réessayez en tapant le chiffre correspondant" ;;
esac
done

}


#####################################

Gestion_Droits() {
true ;
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
                Gestion_Utilisateur
                continue
            fi
            read -p "Nom du dossier : " dossier
            # Vérification si le dossier existe
            if [ -d "$dossier" ]; then
                continue
            else
                echo "Le dossier $dossier n'existe pas. Veuillez le créer d'abord."
                Gestion_Utilisateur
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
                Gestion_Utilisateur
                continue
            fi
            read -p "Nom du fichier : " fichier
            # Vérification si le fichier existe
            if [ -f "$fichier" ]; then
                continue
            else
                echo "Le fichier $fichier n'existe pas. Veuillez le créer d'abord."
                Gestion_Utilisateur
                continue
            fi
            sudo chown $user:$user $fichier
            echo "Droits de l'utilisateur $user sur le fichier $fichier modifiés."
        X|x)
            Gestion_Utilisateur
            echo "Vous êtes de retour dans le menu principal."
            ;;
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

###################################################



#Lancement du 1er menu : start
start


#case 1) sudo adduser <$> nom_groupe


#Choix = Demande d'information
exit 0
