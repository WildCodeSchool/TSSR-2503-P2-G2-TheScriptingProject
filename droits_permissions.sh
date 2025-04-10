#!/bin/bash



Gestion_Droits() 
{
while true ;
do
    echo -e "\n\t MENU GESTION DES DROITS"
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
			read -p "Nom du dossier : " dossier
			# Vérification si le dossier existe
                if [ -d "$dossier" ];
                    then
                    echo -e "\n1) Donner les droits de lecture à l'utilisateur"
                    echo "2) Donner les droits d'écriture à l'utilisateur"
                    echo "3) Donner les droits d'exécution à l'utilisateur"
                    echo -e "\nPlusieurs choix possibles, comme 123"
                    read -p "Votre réponse : " droits
                    case $droits in 
                        *1*) sudo chmod u+r $dossier ;;
                        *2*) sudo chmod u+w $dossier ;;
                        *3*) sudo chmod u+x $dossier ;;
                        *) echo "Choix invalide, réessayez"
                        return 1 ;;
                    esac		 	   
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
			read -p "Nom du dossier : " dossier
			# Vérification si le dossier existe
                if [ -d "$dossier" ];
                    then
                    echo -e "\n1) Enlever les droits de lecture à l'utilisateur"
                    echo "2) Enlever les droits d'écriture à l'utilisateur"
                    echo "3) Enlever les droits d'exécution à l'utilisateur"
                    echo -e "\nPlusieurs choix possibles, comme 123"
                    read -p "Votre réponse : " droits
                    case $droits in 
                        *1*) sudo chmod u-r $dossier ;;
                        *2*) sudo chmod u-w $dossier ;;
                        *3*) sudo chmod u-x $dossier ;;
                        *) echo "Choix invalide, réessayez"
                        return 1 ;;
                    esac		 	   
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
			read -p "Nom du fichier : " fichier
			# Vérification si le fichier existe
                if [ -d "$fichier" ];
                    then
                    echo -e "\n1) Donner les droits de lecture à l'utilisateur"
                    echo "2) Donner les droits d'écriture à l'utilisateur"
                    echo "3) Donner les droits d'exécution à l'utilisateur"
                    echo -e "\nPlusieurs choix possibles, comme 123"
                    read -p "Votre réponse : " droits
                    case $droits in 
                        *1*) sudo chmod u+r $fichier ;;
                        *2*) sudo chmod u+w $fichier ;;
                        *3*) sudo chmod u+x $fichier ;;
                        *) echo "Choix invalide, réessayez"
                        return 1 ;;
                    esac		 	   
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
			read -p "Nom du fichier : " fichier
			# Vérification si le fichier existe
                if [ -d "$fichier" ];
                    then
                    echo -e "\n1) Enlever les droits de lecture à l'utilisateur"
                    echo "2) Enlever les droits d'écriture à l'utilisateur"
                    echo "3) Enlever les droits d'exécution à l'utilisateur"
                    echo -e "\nPlusieurs choix possibles, comme 123"
                    read -p "Votre réponse : " droits
                    case $droits in 
                        *1*) sudo chmod u-r $fichier ;;
                        *2*) sudo chmod u-w $fichier ;;
                        *3*) sudo chmod u-x $fichier ;;
                        *) echo "Choix invalide, réessayez"
                        return 1 ;;
                    esac		 	   
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
        R|r)
            security
            ;;
        X|x) echo -e "\n\tAu revoir !"
        exit 0 ;;
        *)
            echo "Choix invalide, veuillez réessayer"
            Gestion_Droits
            ;;
        *) echo "Choix invalide, réessayez"
        return 1 ;;
    esac
done
}

Gestion_Droits
