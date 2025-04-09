#!/bin/bash



########################## Fonction PRINCIPALE Gestion Utilisateur  ##############################

Gestion_Utilisateur() {
while true ;
do
    echo "Choississez une option :"
    echo "1. liste des utilisateurs"                    #INFO
    echo "2. Création d'un utilisateur"                 #ACTION
    echo "3. Supprimer un utilisateur"                  #ACTION
    echo "4. Changement de mot de passe"                #ACTION
    echo "5. Désactivation de compte utilisateur"       #ACTION
    echo "6. Gestion des groupes"                       #ACTION
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
        X|x)
            echo "Voulez-vous sortir ou revenir au menu précédent ? (O/N)"
            read -p "Votre choix : " choix
            if [[ $choix = "O" || $choix = "o" ]]; then
                exit 0
            else
                Gestion_Utilisateur
            fi
            ;;
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
    echo "X. Revenir au menu précédent"
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
        X|x)
            Gestion_Utilisateur
            echo "Vous êtes de retour dans le menu principal."
            ;;
        *)
            echo "Choix invalide, veuillez réessayer."
            ;;
    esac
done
}

####################### FONCTION PRINCIPALE -- GESTION_AVANCEE ##############################

Gestion_Avancer() {
# Boucle pour relancer la fonction
while true ;
do
    echo "Bienvenue dans la gestion avancée du système !"
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
            Gestion_Systeme
            ;;
        *)
            echo "Choix invalide. Veuillez réessayer."
            return 1
            ;;
    esac
done
}

####################### FONCTION SECONDAIRE -- GESTION_AVANCEE ##############################
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
                echo "Type de CPU, nombre de coeurs, etc. :"
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
####################### FONCTION SECONDAIRE -- GESTION_AVANCEE ##############################
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
echo "Tu te trouve dans la gestion des utilisateurs !"
read -p "Voulez-vous gérer les utilisateurs ? (O/N) " choix
if [[ $choix = "O" || $choix = "o" ]]; then
    Gestion_Utilisateur
else
    echo "Au revoir !"
    exit 0
fi
















