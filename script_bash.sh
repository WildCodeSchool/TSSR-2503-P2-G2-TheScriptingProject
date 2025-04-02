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
echo "R) Retour au menu précédent"
echo "x) Quitter"
read -p "Votre réponse : " cible
case $cible in 
	1) action_serveur ;;
	2) action_client ;;
	R) start ;;
	x) exit 0
esac
return 0
}

################################################


#Choix 2 = SERVEUR
# texte informatif disant qu'on entre dans le menu actions
function action_serveur()
{
echo ""
echo "Vous avez choisi pour cible le serveur"
echo ""
echo "Que voulez-vous faire ? "
echo "1) Gestion d'utilisateur"
echo "2) Gestion de groupe"
echo "R) Retour au menu précédent"
echo "x) Quitter"
read -p "Votre réponse : " choix
case $choix in 
	1) gestion_user ;;
	2) gestion_groupe ;;
	R) action ;;
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
	then echo "Erreur"
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

#Lancement du 1er menu : start
start


#case 1) sudo adduser <$> nom_groupe


#Choix = Demande d'information
exit 0
