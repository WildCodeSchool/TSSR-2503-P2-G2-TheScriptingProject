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
