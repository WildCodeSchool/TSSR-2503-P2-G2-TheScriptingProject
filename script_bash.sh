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
function start()
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
function action()
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
	x) exit 0
esac
return 0
}

################################################


#Choix 2 = SERVEUR
# texte informatif disant qu'on entre dans le menu ACTION SERVEUR
function action_serveur()
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
	x) exit 0
esac
return 0
}

################################################


#Choix 2 = CLIENT
# texte informatif disant qu'on entre dans le menu ACTION CLIENT
#Pour la tâche principale, le client est UBUNTU
function action_client()
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
	x) exit 0
esac
return 0
}


################################################

#création d'un utilisateur
function creation_user()
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
function modif_mdp()
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

function suppression()
{
echo ""
echo "Vous avez choisi de faire supprimer un utilisateur"
echo ""
read -p "Quel utilisateur voulez-vous supprimer ? " utilisateur
sudo userdel $utilisateur
if cat /etc/passwd | grep "$utilisateur"
	then echo "Erreur lors de la suppression"
	else echo "Ok, utilisateur supprimé"
fi
return 0
}

###############################################

#désactivation compte user local
function verrouillage()
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

function gestion_user()
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
	 exit 0
esac
done
}

#####################################


#ajout user dans groupe local
function ajout_groupe_local()
{
echo ""
echo "Vous avez choisi d'ajouter un utilisateur à un groupe"
echo ""
read -p "Entrez le nom de l'utilisateur à ajouter à un groupe : " user
read -p "Entrez le nom du groupe auquel l'ajouter : " groupe
sudo usermod -aG $groupe $user
#vérification
if cat /etc/group | grep "$groupe.*$user" > /dev/null 
	 then
	 	echo "L'utilisateur $user a été ajouté au groupe $groupe"
	 	return 0
	 else 
  		echo "Erreur, l'utilisateur $user n'a pas été ajouté au groupe $groupe"
    		return 1
fi
return 0
}


####################################################################



#enlever user d'un groupe local
function sortie_groupe_local()
{
echo ""
echo "Vous avez choisi d'enlever un utilisateur d'un groupe"
echo ""
read -p "Entrez le nom de l'utilisateur à enlever d'un groupe : " user
read -p "Entrez le nom du groupe auquel l'enlever : " groupe
sudo deluser $user $groupe
#vérification
if cat /etc/group | grep "$groupe.*$user" > /dev/null 
	 then
	 	echo "Erreur, l'utilisateur $user n'a pas été supprimé du groupe $groupe"
    		return 1
	 	
	 else 
  		echo "L'utilisateur $user a été supprimé du groupe $groupe"
	 	return 0
fi
return 0
}



####################################################################



#ajout user dans groupe admin
function ajout_groupe_admin()
{
echo ""
echo "Vous avez choisi d'ajouter un utilisateur à un groupe admin"
echo ""
read -p "Entrez le nom de l'utilisateur à ajouter à un groupe : " user
sudo usermod -aG sudo $user
#vérification
if cat /etc/group | grep "sudo.*$user" > /dev/null 
	 then
	 	echo "L'utilisateur $user a été ajouté au groupe admin"
	 	return 0
	 else 
  		echo "Erreur, l'utilisateur $user n'a pas été ajouté au groupe admin"
    		return 1
fi
return 0
}


####################################################################


function gestion_groupe()
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
	 exit 0
esac
done
}



##################################


#Choix 1 = INFOS
# texte informatif disant qu'on entre dans le menu informations
function infos()
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
	x) exit 0
esac
return 0
}


################################################


#Choix 2 = SERVEUR
# texte informatif disant qu'on entre dans le menu INFOS SERVEUR
function infos_serveur()
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
	echo "";;
	x) echo "Sortie du menu"
	 exit 0
esac
}


#####################################




#Lancement du 1er menu : start
start


#case 1) sudo adduser <$> nom_groupe


#Choix = Demande d'information
exit 0
