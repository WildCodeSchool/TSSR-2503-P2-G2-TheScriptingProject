########                                           ########
###                                                     ###  
###        BIENVENU DANS LE SCRIPT D'ADMINISTRATION     ###
###         LANCEMENT NECESSAIRE EN ADMINISTRATEUR      ###
########                                           ########

#initialisation de quelques variables :
$dossier_log = "c:\Projet2\log"
$date = Get-Date -Format "yyyyMMdd-HHmmss"
# On ajuste le nom du fichier pour une information ordinateur sous la forme <NomDuPC>-GEN_<Date>.txt qui sera créé dans le dossier "log"
$ordi_info_log = "info_$env:COMPUTERNAME_GEN_$date.txt"
# On ajuste le nom du fichier pour une information utilisateur sous la forme <NomDuPC>_<NomDeLUtilisateur>_<Date>.txt  
$user_info_log="info_$env:COMPUTERNAME_$env:USERNAME_$date.txt"




# ===========================================================

########                                           ########
###                                                     ###  
###             FONCTION POUR ENREGISTREMENT FICHIER    ###
###                       log_evt.log                   ###
########                                           ########
function enregistrement_tout {
    #Les evenements seront écrits en $1 (apres l'appel de fonction)
    param ($Argument1)
    Add-Content -Path C:\Windows\System32\LogFiles\log_evt.log -Value "$(Get-Date -Format "yyyyMMdd-HHmmss")-$env:USERNAME-$Argument1"
}

#=========================================================

########                                         ########
###                                                   ###  
###         FONCTION ENREGISTREMENTS INFORMATIONS     ###
###                    DOSSIER LOG                    ###
########                                         ########

#fonction pour enregistrer les informations dans le dossier log (dans le dossier d execution du script, donc la où on sera quand on executera le script)
function creation_dossier_log {
    #création du dossier contenant les logs s'il n existe pas déjà
    if (-not (Test-Path -Path $dossier_log -PathType Container)) {
        New-Item -Path $dossier_log -ItemType Directory
    }
    #Création du fichier sous bon format
 #   New-Item -Path $dossier_log\$ordi_info_log -ItemType File 
#Out-File $dossier_log\$ordi_info_log
}


#=========================================================


########                                 ########
###                                           ###  
###         GESTION UTILISATEURS              ###
###                                           ###
########                                 ########

########                                     ########
###                                               ###  
### FONCTION POUR LE MENU INTERACTIF UTILISATEUR  ###
###                                               ###
########                                     ########

function MenuUtilisateur 
{
    While ($true) 
    {
        Write-Host "====================================================" -ForegroundColor Magenta
        Write-Host "== Bienvenue dans la Gestion des utilisateurs locaux ==" -ForegroundColor Cyan
        Write-Host "1. Supprimer un utilisateur"
        write-host "2. Créer un utilisateur"
        Write-Host "3. Changer le mot de passe d'un utilisateur"
        write-host "4. Désactiver un utilisateur"
        Write-Host "5. Gestion des groupes d'utilisateurs"
        Write-Host "6. Liste des utilisateurs"
        Write-Host "R. Retour au menu principal"
        Write-Host "X. Quitter le programme"
        Write-Host "====================================================" -ForegroundColor Magenta
        $choix = Read-Host "Entrez votre choix"
        # On demande à l'administrateur de faire un choix
        # On vérifie le choix de l'administrateur et on appelle la fonction correspondante
        switch ($choix) 
        {
            "1"
            { enregistrement_tout "Direction vers le menu de suprpession d'un utilisateur"
                SupprimerUtilisateur 
            }
            "2" 
            { 
                enregistrement_tout "Direction vers le menu de création d'un utilisateur"
                AjouterUtilisateur 
            }
            "3" 
            { 
                enregistrement_tout "Direction vers le menu de changement de mot de passe d'un utilisateur"
                ChangerMdpUtilisateur 
            }
            "4" 
            { 
                enregistrement_tout "Direction vers le menu de désactivation d'un utilisateur"
                DésactiverUtilisateur 
            }
            "5" 
            { 
                enregistrement_tout "Direction vers le menu de gestion des groupes"
                GestionGroupe 
            }
            "6" 
            { 
                enregistrement_tout "Direction vers la liste des utilisateurs"
                ListerUtilisateurs enregistrement_information user_info_log
            }
            "R" 
            { 
                Write-Host "Retour au menu principal..." -ForegroundColor Green
                enregistrement_tout "Direction vers le menu principal"
                return
            }
            "X" 
            {
                Write-Host "Au revoir !" -ForegroundColor Green
                enregistrement_tout "*********EndScript*********"
                exit
            }
            default { Write-Host "Choix invalide. Veuillez réessayer." -ForegroundColor Red }
        }
    } 
} 




########                                 ########
###                                           ###  
###  FONCTION POUR SUPPRIMER UN UTILISATEUR   ###
###                                           ###
########                                 ########

function SupprimerUtilisateur {
    ## On fait une boucle pour la suppression d'utilisateur
    do {
        # On demande le nom de l'utilisateur à supprimer
        $username = Read-Host "Entrez le nom de l'utilisateur que vous voulez supprimer"
        # On vérifie si l'utilisateur existe
        if (Get-LocalUser -Name $username -ErrorAction SilentlyContinue) {
            # On supprime l'utilisateur après vérification de son existence
            Remove-LocalUser -Name $username
            # On affiche un message de confirmation de la suppression
            Write-Host "L'utilisateur $username a été supprimé avec succès." -ForegroundColor Green
            # On enregistre l'action dans le fichier log
            enregistrement_tout "Suppression de l'utilisateur $username"
            break
        } 
        else {
            # On affiche un message d'erreur si l'utilisateur n'existe pas
            Write-Host "ERREUR... L'utilisateur $username n'existe pas. Veuillez réessayer" -ForegroundColor Red
            # On enregistre l'action dans le fichier log
            enregistrement_tout "ERREUR de suppression de l'utilisateur $username"
        }
    }
    while ($true)
}

########                                 ########
###                                           ###  
###  FONCTION POUR AJOUTER UN UTILISATEUR     ###
###                                           ###
########                                 ########

function AjouterUtilisateur {
    # On fait une boucle pour la création d'utilisateur tant que l'administrateur ne veut pas quitter
    do {
        # On demande le nom de l'utilisateur à créer
        $username = Read-Host "Entrez le nom de l'utilisateur que vous voulez créer"
        # On vérifie si l'utilisateur existe déjà
        if (Get-LocalUser -Name $username -ErrorAction SilentlyContinue) {
            # On affiche un message d'erreur si l'utilisateur existe déjà
            Write-Host "Choix invalide. Veuillez réessayer" -ForegroundColor Red
            # On enregistre l'action dans le fichier log
            enregistrement_tout "ERREUR de création de l'utilisateur $username"
        } 
        else {
            # On demande le mot de passe de l'utilisateur à créer
            $password = Read-Host "Entrez le mot de passe de l'utilisateur" -AsSecureString
            # On crée l'utilisateur avec le mot de passe fourni
            New-LocalUser -Name $username -Password $password -UserMayNotChangePassword -PasswordNeverExpires -AccountNeverExpires
            # On affiche un message de confirmation de la création de l'utilisateur
            Write-host "L'utilisateur $username a été créé avec succès." -ForegroundColor Green
            # On enregistre l'action dans le fichier log
            enregistrement_tout "Création de l'utilisateur $username"
            break
        }
    } 
    while ($true)
}

########                                 ########
###                                           ###  
###  FONCTION POUR MODIFIER MDP UTILISATEUR   ###
###                                           ###
########                                 ########

function ChangerMdpUtilisateur {
    # On fait une boucle pour la modification du mot de passe d'utilisateur
    do {
        # On demande le nom de l'utilisateur dont on veut changer le mot de passe
        $username = Read-Host "Entrez le nom de l'utilisateur dont vous voulez changer le mot de passe"
        # On vérifie si l'utilisateur existe
        if (Get-LocalUser -Name $username -ErrorAction SilentlyContinue) {
            # S'il existe on demande le nouveau mot de passe de l'utilisateur
            $password = Read-Host "Entrez le nouveau mot de passe de l'utilisateur" -AsSecureString
            # On change le mot de passe de l'utilisateur avec le mot de passe fourni
            Set-LocalUser -Name $username -Password $password
            # On affiche un message de confirmation du changement de mot de passe
            Write-Host "Le mot de passe de l'utilisateur $username a été changé avec succès." -ForegroundColor Green
            # On enregistre l'action dans le fichier log
            enregistrement_tout "Changement du mot de passe de l'utilisateur $username"
            break
        } 
        else {
            # On affiche un message d'erreur si l'utilisateur n'existe pas
            Write-Host "ERREUR... L'utilisateur $username n'existe pas. Veuillez réessayer" -ForegroundColor Red
            # On enregistre l'action dans le fichier log
            enregistrement_tout "ERREUR de changement du mot de passe de l'utilisateur $username"
        }
    }
    while ($true)
}

########                                 ########
###                                           ###  
###  FONCTION POUR DESACTIVER UN UTILISATEUR  ###
###                                           ###
########                                 ########

function DésactiverUtilisateur {
    # On fait une boucle pour la désactivation d'utilisateur
    do {
        # On demande le nom de l'utilisateur à désactiver
        $username = Read-Host "Entrez le nom de l'utilisateur que vous voulez désactiver"
        # On vérifie si l'utilisateur existe
        if (Get-LocalUser -Name $username -ErrorAction SilentlyContinue) {
            # On désactive l'utilisateur avec le nom fourni
            Disable-LocalUser -Name $username
            # On affiche un message de confirmation de la désactivation de l'utilisateur
            Write-Host "L'utilisateur $username a été désactivé avec succès." -ForegroundColor Green
            # On enregistre l'action dans le fichier log
            enregistrement_tout "Désactivation de l'utilisateur $username"
            break
        } 
        else {
            # On affiche un message d'erreur si l'utilisateur n'existe pas
            Write-Host "ERREUR... L'utilisateur $username n'existe pas. Veuillez réessayer" -ForegroundColor Red
            # On enregistre l'action dans le fichier log
            enregistrement_tout "ERREUR de désactivation de l'utilisateur $username"
        }
    }
    while ($true)
}

########                                 ########
###                                           ###  
###  FONCTION POUR LISTER LES UTILISATEURS    ###
###                                           ###
########                                 ########
function ListerUtilisateurs {
    # On affiche la liste des utilisateurs locaux
    $users = Get-LocalUser
    foreach ($user in $users) {
        # On enregistre les informations de chaque utilisateur dans le dossier log user_info_log
        $users = "Nom d'utilisateur : $($user.Name)`nNom complet : $($user.FullName)`nDescription : $($user.Description)`nÉtat du compte : $($user.Enabled)"
        Write-Host "Nom d'utilisateur : $($user.Name)"
        "Nom d'utilisateur : $($user.Name)" | Out-File -FilePath "$dossier_log\$user_info_log"
        Write-Host "Nom complet : $($user.FullName)"
        "Nom complet : $($user.FullName)" | Out-File -FilePath "$dossier_log\$user_info_log"
        Write-Host "Description : $($user.Description)"
        "Description : $($user.Description)" | Out-File -FilePath "$dossier_log\$user_info_log"
        Write-Host "État du compte : $($user.Enabled)"
        "État du compte : $($user.Enabled)" | Out-File -FilePath "$dossier_log\$user_info_log"
        Write-Host "====================================================" -ForegroundColor Magenta
        
    } 
    
}

########                                 ########
###                                           ###  
###  FONCTION DU SOUS MENU GESTION GROUPE     ###
###                                           ###
########                                 ########

function MenuGroupe {
    Clear-Host
    Write-Host "====================================================" -ForegroundColor Magenta
    Write-Host "== Bienvenue dans la Gestion des groupes d'utilisateurs locaux ==" -ForegroundColor Cyan
    Write-Host "1. Ajouter à un groupe d'administration"
    Write-Host "2. Ajouter un utilisateur à un groupe local"
    write-host "3. Supprimer un utilisateur d'un groupe"
    Write-Host "R. Revenir au Menu Précédent"
    Write-Host "X. Quittez"
    Write-Host "====================================================" -ForegroundColor Magenta
}

########                                            ########
###                                                      ###  
###  FONCTION POUR AJOUTER UN UTILISATEUR --> GROUPE     ###
###                                                      ###
########                                            ########

function AjouterUtilisateurGroupe {
    # On fait une boucle pour l'ajout d'un utilisateur à un groupe
    do {
        # On demande le nom de l'utilisateur à ajouter puis le groupe
        $username = Read-Host "Entrez le nom de l'utilisateur que vous voulez ajouter au groupe"
        $groupname = Read-Host "Entrez le nom du groupe auquel vous voulez ajouter l'utilisateur"
        # On vérifie si l'utilisateur et le groupe existe
        if ((Get-LocalUser -Name $username -ErrorAction SilentlyContinue) -and (Get-LocalGroup -Name $groupname -ErrorAction SilentlyContinue)) {
            # Si les deux existes on ajoute l'utilisateur au groupe renseigné
            Add-LocalGroupMember -Group $groupname -Member $username
            # On affiche un message de confirmation de l'ajout de l'utilisateur au groupe
            Write-Host "L'utilisateur $username a été ajouté au groupe $groupname avec succès." -ForegroundColor Green
            enregistrement_tout "Ajout de l'utilisateur $user au groupe $groupname"
            break
        } 
        else {
            # On affiche un message d'erreur si l'utilisateur ou le groupe n'existe pas
            Write-Host "ERREUR... L'utilisateur $username ou le groupe $groupname n'existe pas. Veuillez réessayer" -ForegroundColor Red
            enregistrement_tout "Erreur d'ajout de l'utilisateur $username au groupe $groupname"
        }
    }
    while ($true)
}
########                                              ########
###                                                        ###  
###  FONCTION POUR AJOUTER UN UTILISATEUR --> GROUPE AD    ###
###                                                        ###
########                                              ########

function AjouterUtilisateurGroupeAD {
    # On fait une boucle pour l'ajout d'un utilisateur à un groupe AD
    do {
        # On demande le nom de l'utilisateur à ajouter puis le groupe AD
        $username = Read-Host "Entrez le nom de l'utilisateur que vous voulez ajouter au groupe AD"
        $groupname = Read-Host "Entrez le nom du groupe AD auquel vous voulez ajouter l'utilisateur"
        # On vérifie si l'utilisateur et le groupe AD existe
        if ((Get-ADUser -Identity $username -ErrorAction SilentlyContinue) -and (Get-ADGroup -Identity $groupname -ErrorAction SilentlyContinue)) {
            # Si les deux existes on ajoute l'utilisateur au groupe renseigné
            Add-ADGroupMember -Identity $groupname -Members $username
            # On affiche un message de confirmation de l'ajout de l'utilisateur au groupe AD
            Write-Host "L'utilisateur $username a été ajouté au groupe AD $groupname avec succès." -ForegroundColor Green
            enregistrement_tout "Ajout de l'utilisateur $username au groupe AD $groupname"
            break
        } 
        else {
            # On affiche un message d'erreur si l'utilisateur ou le groupe AD n'existe pas
            Write-Host "ERREUR... L'utilisateur $username ou le groupe AD $groupname n'existe pas. Veuillez réessayer" -ForegroundColor Red
            enregistrement_tout "Erreur de l'ajout de l'utilisateur $username au groupe AD $groupname"
        }
    }
    while ($true)
}

########                                              ########
###                                                        ###  
###  FONCTION POUR SUPPRIMER UN UTILISATEUR D'UN GROUPE    ###
###                                                        ###
########                                              ########

function SupprimerUtilisateurGroupe {
    # On fait une boucle pour la suppression d'un utilisateur d'un groupe
    do {
        # On demande le nom de l'utilisateur à supprimer puis le groupe
        $username = Read-Host "Entrez le nom de l'utilisateur que vous voulez supprimer du groupe"
        $groupname = Read-Host "Entrez le nom du groupe dont vous voulez supprimer l'utilisateur"
        # On vérifie si l'utilisateur et le groupe existe
        if ((Get-LocalUser -Name $username -ErrorAction SilentlyContinue) -and (Get-LocalGroup -Name $groupname -ErrorAction SilentlyContinue)) {
            # Si les deux existes on supprime l'utilisateur du groupe renseigné
            Remove-LocalGroupMember -Group $groupname -Member $username
            # On affiche un message de confirmation de la suppression de l'utilisateur du groupe
            Write-Host "L'utilisateur $username a été supprimé du groupe $groupname avec succès." -ForegroundColor Green
            enregistrement_tout "Suprpession de l'utilisateur $username du groupe $groupname"
            break
        } 
        else {
            # On affiche un message d'erreur si l'utilisateur ou le groupe n'existe pas
            Write-Host "ERREUR... L'utilisateur $username ou le groupe $groupname n'existe pas. Veuillez réessayer" -ForegroundColor Red
            enregistrement_tout "Erreur de suppression de l'utilisateur $username du groupe $groupname"
        }
    }
    while ($true)
}

########                                      ########
###                                                ###  
###  FONCTION POUR APPELER LA GESTION DES GROUPES  ###
###                                                ###
########                                      ########

function GestionGroupe {
    # On fait une boucle2 pour la gestion des groupes
        
    do {
        # On appelle la fonction MenuGroupe pour afficher le menu
        MenuGroupe
        # On demande à l'administrateur de faire un choix
        $choix = Read-Host "Veuillez choisir une option"
        # On vérifie le choix de l'administrateur et on appelle la fonction correspondante
        switch ($choix) {
            "1" { enregistrement_tout "Direction vers le menu d'ajout d'un utilisateur à un groupe"
                 AjouterUtilisateurGroupe }
            "2" { enregistrement_tout "Direction vers le menu d'ajout d'un utilisateur à un groupe AD"
                 AjouterUtilisateurGroupeAD }
            "3" { enregistrement_tout "Direction vers le menu de suppression d'un utilisateur d'un groupe"
                 SupprimerUtilisateurGroupe }
            "R" { 
                Write-Host "Retour au menu principal..." -ForegroundColor Green
                enregistrement_tout "Direction vers le menu principal"
                return
            }
            default { Write-Host "Choix invalide. Veuillez réessayer." -ForegroundColor Red }
        }
    }
    while ($true)
}

#=========================================================

########                                                ########
###                                                          ###  
###  FONCTION POUR RECHERCHER UN EVENEMENT DANS LES LOGS     ###
###                                                          ###
########                                                ########


function recherche_log {
    write-host "====================================================" -ForegroundColor Magenta
    write-host "== Bienvenue dans la recherche d'événements ==" -ForegroundColor Cyan
    Write-Host "Quelle est votre recherche ?"
    Write-Host "Vous pouvez chercher par le nom d'utilisateur,"
    Write-Host "Par l'évenement (Vision de..., Déplacement menu ... Activation SSH ...)"
    $recherche = Read-Host "Votre réponse "
    #On intègre la commande pour faire la recherche dans une variable pour faire un if (et donc avoir le résultat s'il y en a un, ou un message d'erreur s'il n'y  a pas de correspondance avec les mot-clefs insérés)
    $resultat = Get-Content -Path "C:\Windows\System32\LogFiles\log_evt.log" | Where-Object { $_ -like "*$recherche*" }
    if ($resultat) {
        Write-Host ""
        Write-Host "Résultat de la recherche :"
        #Affichage du/des résultats
        $resultat | Out-Host
        enregistrement_tout "Recherche avec les mots clefs $recherche"
    }
    else {
        Write-Host "Aucune donnée de cette recherche n'a été trouvée, essayez une autre recherche"
    }
    #On demande si on veut faire une autre recherche
    $encore = Read-Host "Voulez-vous faire une autre recherche (o/n) ?"
    switch ($encore) {
        #autre recherche => on relance la fonction
        o {
            enregistrement_tout "Nouvelle recherche sur un évenement, une action, un déplacement"
            recherche_log
        }
        #Pas d'autre recherche => retour au menu principal
        n {
            enregistrement_tout "Direction vers le menu principal" -ForegroundColor Green
            MenuAdministration
        }
        default {
            Write-Host "Choix invalide. Veuillez réessayer." -ForegroundColor Red
        }
    }
}

# ==========================================================

########                                 ########
###                                           ###  
###  FONCTION POUR LES DROITS UTILISATEURS    ###
###                                           ###
########                                 ########
function Gestion_Droits {
    while ($true) {
        Write-Host "====================================================" -ForegroundColor Magenta
        Write-Host "== Bienvenue dans la gestion des doits et permissions ==" -ForegroundColor Cyan
        Write-Host "`n Que voulez-vous voir ?"
        Write-Host "1. Droits/Permissions de l'utilisateur sur un dossier :"
        Write-Host "2. Droits/Permissions de l'utilisateur sur un fichier :"
        Write-Host "R. Retour au menu précédent"
        Write-Host "X. Quitter"
        Write-Host "====================================================" -ForegroundColor Magenta
        $choix = Read-Host "Votre réponse "

        switch ($choix) {
            1 { 
                $dossier = Read-Host "De quel dossier voulez-vous vérifier les droits (donnez le path absolu ? "
                if (Test-Path $dossier) {
                    Get-Acl -Path $dossier 
                    Get-Acl -Path $dossier | Out-File -FilePath "$dossier_log\$user_info_log"
                    enregistrement_tout "Vérification des droits et permissions du dossier $dossier"
                } 
                else {
                    Write-Host "Le dossier n'existe pas." -ForegroundColor Red
                    enregistrement_tout "Erreur lors de la vérification des droits et permission du dossier $dossier"
                }
            }
            2 {
                $fichier = Read-Host "De quel fichier voulez-vous vérifier les droits (donnez le path absolu) ? "
                if (Test-Path $fichier) {
                    Get-Acl -Path $fichier
                    Get-Acl -Path $fichier | Out-File -FilePath "$dossier_log\$user_info_log"
                    enregistrement_tout "Vérifications des droits et permissions du fichier $fichier"
                }
                else {
                    Write-Host "Le fichier n'existe pas." -ForegroundColor Red
                    enregistrement_tout "Erreur lors de la vérifications des droits et permissions du fichier $fichier"
                }
            }
            R {
                enregistrement_tout "Direction vers le menu de gestion de la sécurité"
                Security
            }
            X {
                Write-Host "Au revoir !" -ForegroundColor Green
                enregistrement_tout "*********EndScript*********"
                exit 0
            }
            default {
                Write-Host "Choix invalide. Veuillez réessayer." -ForegroundColor Red
            }
        }   
    }
}

#==========================================================

########                                 ########
###                                           ###  
###  FONCTION POUR LA GESTION DE REPERTOIRES  ###
###               ET LOGICIELS                ###
########                                 ########
function repertoire_logiciel {

    while ($true) {
        Write-Host "====================================================" -ForegroundColor Magenta
        Write-Host "== Bienvenue dans la gestion des répertoires et logiciels ==" -ForegroundColor Cyan
        Write-host "`n Que voulez vous faire ? "
        Write-host "1) Créer un répertoire"
        Write-host "2) Suppression d'un répertoire"
        Write-host "3) Installer un logiciel"
        Write-host "4) Désinstaller un logiciel"
        Write-host "5) Voir la liste des applications et paquets installés"
        Write-host "6) Executer de script sur machine distante"
        Write-host "R) Menu Principal"
        Write-host "X) Quitter"
        Write-Host "====================================================" -ForegroundColor Magenta
        $choix = Read-Host "Votre réponse "

        #On Appelle la fonction correspondante au choix de l'administrateur
        switch ($choix) {
            1 {
                $repertoire = Read-Host "Quel nom voulez-vous donner au répertoire (écrire le path absolu) "
                if (Test-Path -Path $repertoire) {
                    Write-Output "Le répertoire $repertoire existe déjà" -ForegroundColor Red
                    enregistrement_tout "Erreur lors de la création du répertoire $repertoire, le répertoire existe déjà"
                }
                else {
                    New-Item -ItemType Directory -Path $repertoire -Force > $Null
                    Write-Host "Répertoire $repertoire a bien été créée" -ForegroundColor Green
                    enregistrement_tout "Création du répertoire $repertoire"
                }
            }
            2 {
                $repertoire = Read-Host "Quel répertoire voulez-vous supprimer ? (entrez le path absolu) "
                if (Test-Path -Path $repertoire) {
                    Remove-Item -Path $repertoire -Recurse -Force
                    Write-Output "Le répertoire $repertoire a été supprimé" -ForegroundColor Green
                    enregistrement_tout "Suppression du répertoire $repertoire"
                }
                else {
                    Write-Host "Répertoire $repertoire n'existe pas" -ForegroundColor Red
                    enregistrement_tout "Erreur lors de la suppression du répertoire $repertoire, le répertoire n'existe pas"
                }
            }
            3 {
                $logiciel = Read-Host "Nom du logiciel à installer "
                winget update -y > $Null
                winget upgrade -y > $Null
                if (winget search --name $logiciel) {
                    winget install $logiciel
                    enregistrement_tout "Le logiciel $logiciel a été installé"
                }
                else {
                    Write-Host "Logiciel non trouvé dans la liste des paquets Winget" -ForegroundColor Red
                    enregistrement_tout "Erreur, logiciel $logiciel non trouvé dans la liste des paquets Winget"
                }
            }
            4 {
                $logiciel = Read-Host "Nom du logiciel à désinstaller "
                winget uninstall --name $logiciel
                #Pas de vérification de la désinstallation du logiciel
                enregistrement_tout "Désinstallation du logiciel $logiciel"
            }
            5 {
                Write-Host "Les applications et paquets installés sont :"
                winget list
                winget list | Out-File -FilePath "$dossier_log\$user_info_log"
                enregistrement_tout "Vision de tous les paquets et applications installés"
            }   
            6 { 
                enregistrement_tout "Direction vers l'execution de script a distance"
                execution_script
            }
            r { 
                enregistrement_tout "Direction vers le menu principal"
                MenuAdministration
            }
            x {
                Write-Host ""
                Write-Host "Au revoir !" -ForegroundColor Green
                enregistrement_tout "*********EndScript*********"
                exit 0
            }
            default {
                Write-Host "Choix invalide. Veuillez réessayer." -ForegroundColor Red
            }
        }
    }
}


#============================================


########                                 ########
###                                           ###  
###      FONCTION LES REGLES FIREWALL         ###
###                                           ###
########                                 ########
function regles {
    #  --Boucle pour le menu de gestion des règles pare-feu-- 
    while ($true) {
        ###     Menu de gestion des règles pare-feu     ###
        Write-Host "====================================================" -ForegroundColor Magenta
        Write-Host "== Bienvenue dans la gestion des règles pare-feu ==" -ForegroundColor Cyan
        Write-host "`n Que voulez vous faire ?"
        Write-host "1) Activer/désactiver les connexions avec une adresse IP spécifique"
        Write-host "2) Activer/désactiver les connexions via ssh"
        Write-host "R) Retour au menu précédent"
        Write-host "X) Quitter"
        Write-Host "====================================================" -ForegroundColor Magenta
        $choix = Read-Host "Votre réponse "
        # -- On appelle la fonction correspondante au choix de l'administrateur --
        switch ($choix) 
        {
            1 {
                #Activation/désactivation des connexions IP avec une adresse donnée
                Write-Host ""
                $ip_onoff = Read-Host "Voulez-vous activer (o) ou désactiver (n) les connexions avec une adresse IP spécifique ? "
                #On demande l'adresse
                $ip_specifique = Read-Host "Avec quelle adresse IP ? "
                switch ($ip_onoff) {
                    o {
                        #Autorisation d'entrée
                        New-NetFirewallRule -DisplayName "AutoriserEntreeDepuis:$ip_specifique" -Direction Inbound -Action Allow -RemoteAddress "$ip_specifique" -Enabled True > $null
                        #Autorisation de sortie
                        New-NetFirewallRule -DisplayName "AutoriserSortieVers:$ip_specifique" -Direction Outbound -Action Allow -RemoteAddress "$ip_specifique" -Enabled True > $null
                        Write-Host "Connexions avec l'adresse ip $ip_specifique autorisées"
                        enregistrement_tout "Autorisation des connexions avec l'adresse IP $ip_specifique"
                    }
                    n {
                        #Bloquer entrée
                        New-NetFirewallRule -DisplayName "BloquerEntreeDepuis:$ip_specifique" -Direction Inbound -Action Block -RemoteAddress "$ip_specifique" -Enabled True > $null
                        #Bloquer sortie
                        New-NetFirewallRule -DisplayName "BloquerSortieVers:$ip_specifique" -Direction Outbound -Action Block -RemoteAddress "$ip_specifique" -Enabled True > $null
                        Write-Host "Connexions avec l'adresse IP $ip_specifique bloquées"
                        enregistrement_tout "Blocage des connexions avec l'adresse IP $ip_specifique"
                    }  
                    default {
                        Write-Host "Choix invalide. Veuillez réessayer." -ForegroundColor Red
                    }
                }
            }
            2 {
                $ssh_onoff = Read-Host "Voulez-vous activer (o) ou désactiver (n) les connexions SSH ? "
                $ssh_port = Read-Host "Sur quel port est le protocole SSH ? (22 par défaut)"
                $ip_specifique = Read-Host "Avec quelle adresse IP ? "
                switch ($ssh_onoff) 
                {
                    o {
                        New-NetFirewallRule -DisplayName "AutoriserSSHEntrantDepuis:$ip_specifique" -Direction Inbound -Action Allow -Protocol TCP -RemotePort $ssh_port -RemoteAddress "$ip_specifique" -Enabled True > $null
                        New-NetFirewallRule -DisplayName "AutoriserSSHSortantVers:$ip_specifique" -Direction Outbound -Action Allow -Protocol TCP -RemotePort $ssh_port -RemoteAddress "$ip_specifique" -Enabled True > $null
                        Write-Host "Connexions SSH l'adresse IP $ip_specifique autorisées" -ForegroundColor Green
                        #On enregistre l'action dans le fichier log
                        enregistrement_tout "Autorisation des connexions SSH avec l'adresse IP $ip_specifique"
                    }
                    n {
                        New-NetFirewallRule -DisplayName "BloquerSSHEntrantDepuis:$ip_specifique" -Direction Inbound -Action Block -Protocol TCP -RemotePort $ssh_port -RemoteAddress "$ip_specifique" -Enabled True > $null
                        New-NetFirewallRule -DisplayName "BloquerSSHSortantVers:$ip_specifique" -Direction Outbound -Action Block -Protocol TCP -RemotePort $ssh_port -RemoteAddress "$ip_specifique" -Enabled True > $null
                        Write-Host "Connexions SSH l'adresse IP $ip_specifique bloquées" -ForegroundColor Green
                        #On enregistre l'action dans le fichier log
                        enregistrement_tout "Blocage des connexions SSH avec l'adresse IP $ip_specifique"
                    }
                    default {
                        Write-Host "Choix invalide. Veuillez réessayer." -ForegroundColor Red
                    }
                }
                Write-Host ""
            }
            r { 
                # Enregistrement de l'action dans le fichier log
                enregistrement_tout "Direction vers le menu de gestion de la sécurité"
                # Retour au menu de gestion de la sécurité
                Security
            }
            x {
                # On Quitte le programme et on enregistre l'action dans le fichier log
                Write-Host ""
                Write-Host "Au revoir !" -ForegroundColor Green
                enregistrement_tout "*********EndScript*********"
                exit 0
            }
            default {
                Write-Host "Choix invalide. Veuillez réessayer." -ForegroundColor Red
            }
        }
    }
}

#==========================================================

########                                 ########
###                                           ###  
###  FONCTION POUR GERER LE RESEAU DU SYSTEME ###
###                                           ###
########                                 ########
function reseaux {
    #On fait une boucle pour le menu de gestion du réseau
    while ($true) {
        Write-Host "====================================================" -ForegroundColor Magenta
        Write-Host "== Bienvenue dans la gestion du réseau ==" -ForegroundColor Cyan
        Write-host "`n Que voulez vous faire ?"
        Write-host "1) Voir l'adresse MAC"
        Write-host "2) Voir les adresses IP des interfaces"
        Write-host "3) Voir le nombre d'interfaces"
        Write-host "R) Retour au menu précédent"
        Write-host "X) Quitter"
        Write-Host "====================================================" -ForegroundColor Magenta
        $choix = Read-Host "Votre réponse "
        # On appelle la fonction correspondante au choix de l'administrateur
        switch ($choix) {
            1 {
                Write-Host ""
                Write-Host "Les adresses MAC de vos cartes réseaux sont : " -ForegroundColor Green
                #On affiche les adresses MAC des cartes réseaux
                Write-Host ""
                #Lors de la premiere itération de la boucle, le resultat de la commande ne s'affichait pas mais s'affichait bien lors de la seconde intération (et au dela) surement du a un temps de récupération de l'info, d'où l'ajout de "| Out-Host" qui permet de forcer l'affichage du résultat
                $(Get-NetAdapter | Select-Object Name, MacAddress) | Out-Host
                $(Get-NetAdapter | Select-Object Name, MacAddress) | Out-File -FilePath "$dossier_log\$ordi_info_log"
                enregistrement_tout "Vision des adresses MAC des cartes réseaux"
            }
            2 {
                # Choix de version d'IP
                Write-Host "========================================" -ForegroundColor Magenta 
                Write-host "Quelle version d'adresse IP voulez-vous ?" -ForegroundColor Cyan
                Write-host "1) IPv4"
                Write-host "2) IPv6"
                Write-host "3) Les deux"
                $ip = Read-Host "Votre réponse : "
                Write-host "=====================================" -ForegroundColor Magenta
                    
                switch ($ip) {
                    1 { 
                        Get-NetIPConfiguration | Select-Object IPv4Address, InterfaceAlias | Out-Host
                        Get-NetIPConfiguration | Select-Object IPv4Address, InterfaceAlias | Out-File -FilePath "$dossier_log\$ordi_info_log"
                        # On enregistre l'action dans le fichier log
                        enregistrement_tout "Vision des adresses IPv4 des interfaces"
                    }
                    2 {
                        Get-NetIPConfiguration | Select-Object IPv6Address, InterfaceAlias | Out-Host
                        Get-NetIPConfiguration | Select-Object IPv6Address, InterfaceAlias | Out-File -FilePath "$dossier_log\$ordi_info_log"
                        # On enregistre l'action dans le fichier log
                        enregistrement_tout "Vision des adresses IPv6 des interfaces"
                    }
                    3 {
                        Get-NetIPConfiguration | Select-Object IPv4Address, IPv6Address, InterfaceAlias | Out-Host
                        Get-NetIPConfiguration | Select-Object IPv4Address, IPv6Address, InterfaceAlias | Out-File -FilePath "$dossier_log\$ordi_info_log"
                        # On enregistre l'action dans le fichier log
                        enregistrement_tout "Vision des adresses IPv4 et IPv6 des interfaces"
                    }
                    default {
                        Write-Host "Choix invalide. Veuillez réessayer." -ForegroundColor Red
                    }
                }
            }
            3 {
                # On affiche le Nombre d'interfaces
                Write-Host ""
                Write-Host "Il y a $((Get-NetAdapter).Count) interfaces connectées" -ForegroundColor Green
                "Il y a $((Get-NetAdapter).Count) interfaces connectées" | Out-File -FilePath "$dossier_log\$ordi_info_log"
                Write-Host ""
                #On enregistre l'action dans le fichier log
                enregistrement_tout "Vision du nombre d'interfaces connectées"
            }
            r { 
                # Enregistrement de l'action dans le fichier log
                enregistrement_tout "Direction vers le menu principal"
                # Retour au menu principal
                MenuAdministration
            }
            x {
                # On Quitte le programme et on enregistre l'action dans le fichier log
                Write-Host ""
                Write-Host "Au revoir !" -ForegroundColor Green
                    
                enregistrement_tout "*********EndScript*********"
                    
                exit 0
            }
            default {
                Write-Host "Choix invalide. Veuillez réessayer." -ForegroundColor Red
            }
        }
    }
}


#==========================================================

########                                 ########
###                                           ###  
###  FONCTION POUR GERER LA SECURITER         ###
###                                           ###
########                                 ########

function Security {
    #On fait une boucle pour le menu de gestion de la sécurité
    #On affiche le menu de gestion de la sécurité
    while ($true) {
        Write-Host "====================================================" -ForegroundColor Magenta
        Write-Host "== Bienvenue dans la gestion de la sécurité ==" -ForegroundColor Cyan
        Write-host "`n Que voulez vous faire ?"
        Write-host "1. Activer un pare-feu"
        Write-host "2. Désactiver un pare-feu"
        Write-host "3. Définir des règles de pare-feu"
        Write-host "4. Voir l'état du pare-feu"
        Write-host "5. Voir les ports ouverts"
        Write-host "6. Gérer les droits d'un utilisateur sur un dossier ou fichier"
        Write-host "7. Voir la dernière connexion d'un utilisateur"
        Write-host "8. Voir la date de dernier changement de mot de passe"
        Write-host "9. Voir la liste des sessions ouvertes"
        Write-host "R. Retour au menu précédent"
        Write-host "X. Quitter"
        Write-Host "====================================================" -ForegroundColor Magenta
        $choix = Read-Host "Votre réponse "
        #On appelle la fonction correspondante au choix de l'administrateur
        
        switch ($choix) {
            1 {
                # Activation du pare-feu
                #On active le parefeu sur les 3 profils (Domain, Public, Private)
                
                Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled True ;
                Write-Host "Pare-feu activé" -ForegroundColor Green
                # On enregistre l'action dans le fichier log
                enregistrement_tout "Activation du pare-feu"
            }
            
            2 {
                # Désactivation du pare-feu
                # On désactive le parefeu sur les 3 profils (Domain, Public, Private)
                Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False ;
                Write-Host "Pare-feu désactivé" -ForegroundColor Green
                # On enregistre l'action dans le fichier log
                enregistrement_tout "Désactivation du pare-feu"
            }
            3 {
                # On affiche le menu de gestion des règles pare-feu
                enregistrement_tout "Direction vers le menu de gestion des règles pare-feu"
                # Appel du menu des règles pare-feu
                regles
            }
            4 {
                # état du parefeu
                Write-Host "Voici l'état du pare-feu :" -ForegroundColor Green
                Get-NetFirewallProfile
                enregistrement_information_ordinateur
                Get-NetFirewallProfile | Out-File -FilePath "$dossier_log\$ordi_info_log"
                # On enregistre l'action dans le fichier log
                enregistrement_tout "Vision de l'état du pare-feu"
            }
            5 {
                # Voir les ports ouverts (d'abord TCP puis UDP) 
                Write-Host "Les ports TCP ouverts sont :" -ForegroundColor Green
                # On affiche les ports TCP ouverts
                Get-NetTCPConnection | Format-Table -AutoSize
                Write-Host ""
                Write-Host "Les ports UDP ouverts sont :" -ForegroundColor Green
                # On affiche les ports UDP ouverts
                Get-NetUDPEndpoint | Format-Table -AutoSize
                Get-NetTCPConnection | Out-File -FilePath "$dossier_log\$ordi_info_log"
                Get-NetUDPEndpoint | Out-File -FilePath "$dossier_log\$ordi_info_log"
                # On enregistre l'action dans le fichier log
                enregistrement_tout "Vision des ports ouverts"
            }
            6 {
                # On appel le menu de gestion de droits/permissions
                enregistrement_tout "Directon vers le menu de gestion des droits et permissions"
                Gestion_Droits
            }
            7 {
                # Derniere connexion de l'user demandé
                $user = Read-Host "De quel utilisateur ? "
                #le parametre [EventData[Data[@Name='TargetUserName' permet de filtrer l'élément dont le nom est 'TargetUserName' à l'interieur de EventData
                #le parametre event ID 4624 dans le journal de sécurité Windows correspond à une connexion réussie
                Get-WinEvent -LogName Security -FilterXPath "*[EventData[Data[@Name='TargetUserName']='$user'] and System[EventID='4624']]" -MaxEvents 1
                Get-WinEvent -LogName Security -FilterXPath "*[EventData[Data[@Name='TargetUserName']='$user'] and System[EventID='4624']]" -MaxEvents 1 | Out-File -FilePath "$dossier_log\$user_info_log"
                # On enregistre l'action dans le fichier log
                enregistrement_tout "Vision de la dernière connexion de l'utilisateur $user"
            }
            8 {
                $user = Read-Host "De quel utilisateur ? "
                # On ne va afficher que la 9e ligne de la commande net user, qui correspond a la ligne du dernier changement de mdp (skip les 8 premieres, et puis que la premiere, donc la  9e)
                net user $user | Select-Object -Skip 8 -First 1 -ForegroundColor Green
                net user $user | Select-Object -Skip 8 -First 1 | Out-File -FilePath "$dossier_log\$user_info_log"
                # On enregistre l'action dans le fichier log
                enregistrement_tout "Vision de la dernière modification du mot de passe de l'utilisateur $user"
            }
            9 {
                # On affiche la liste des sessions ouvertes
                Write-Host "Voici la liste des sessions ouvertes :" -ForegroundColor Green
                Get-WmiObject -Class Win32_LogonSession | Select-Object Name, LogonId, LogonType | Out-Host -ForegreoundColor Green
                Get-WmiObject -Class Win32_LogonSession | Select-Object Name, LogonId, LogonType | Out-File -FilePath "$dossier_log\$user_info_log"
                # On enregistre l'action dans le fichier log
                enregistrement_tout "Vision de la liste des sessiosn ouvertes"
            }
            r { 
                # Retour au menu principal
                Write-Host "Retour au Menu Pricipal" -ForegroundColor Green
                # Enregistrement de l'action dans le fichier log
                enregistrement_tout "Direction vers le menu principal"
                # On appelle la fonction MenuAdministration pour revenir au menu principal
                MenuAdministration
            }
            x {
                # On Quitte le programme et on enregistre l'action dans le fichier log
                Write-Host ""
                Write-Host "Au revoir !" -ForegroundColor Green
                enregistrement_tout "*********EndScript*********"
                exit 0
            }
            default {
                Write-Host "Choix invalide. Veuillez réessayer." -ForegroundColor Red
            }
        }
    }
}


#==========================================================

########                                            ########
###                                                      ###  
###  FONCTION POUR LE MENU PRINCIPAL D'ADMINISTRATION    ###
###                                                      ###
########                                            ########

function MenuAdministration {
    # On fait une boucle pour le menu principal d'administration
    # On affiche le menu principal d'administration
    while ($true) {
        Write-Host ""
        Write-Host "====================================================" -ForegroundColor Magenta
        Write-Host "== Bienvenue dans le menu d'administration ==" -ForegroundColor Cyan
        Write-Host "`n Que voulez-vous faire ? "
        Write-Host "1. Gérer les utilisateurs"
        Write-Host "2. Gérer la sécurité"
        Write-Host "3. Gérer le paramétrage réseaux"
        Write-Host "4. Gérer les logiciels et répertoires"
        Write-Host "5. Gérer le système [Non Fonctionnel] "
        Write-Host "6. Rechercher une information déjà demandée/un évenement"
        Write-Host "0. Changer de cible utilisateur et machine"
        Write-Host "X. Quitter"
        Write-Host "====================================================" -ForegroundColor Magenta
        $choix = Read-Host "Votre réponse "
        switch ($choix) {
            1 {
                # On appelle la fonction qui affiche le Menu Utilisateur et on enregistre l'action dans le fichier log
                enregistrement_tout "Direction vers le menu de gestion des utilisateurs"
                MenuUtilisateur
            }
            2 {
                # On appelle la fonction qui affiche le Menu de gestion de la sécurité et on enregistre l'action dans le fichier log
                enregistrement_tout "Direction vers le menu de gestion de la sécurité"
                security
            }
            3 {
                # On appelle la fonction qui affiche le Menu de gestion des réseaux et on enregistre l'action dans le fichier log
                enregistrement_tout "Direction vers le menu de gestion du paramétrage réseau"
                reseaux
            }
            4 {
                # On appelle la fonction qui affiche le Menu de gestion des logiciels et répertoires et on enregistre l'action dans le fichier log
                enregistrement_tout "Direction vers le menu de gestion des logiciels et répertoires"
                repertoire_logiciel
            }
            5 {
                # On appelle la fonction qui affiche le Menu de gestion du système et on enregistre l'action dans le fichier log
                enregistrement_tout "Direction vers le menu de gestion du système"
                Gestion_Systeme
            }
            6 {
                # On appelle la fonction qui affiche le Menu de recherche dans les logs et on enregistre l'action dans le fichier log
                enregistrement_tout "Direction vers la recherche dans le log"
                recherche_log
            }
            0 {
                # On appelle la fonction qui affiche le Menu de changement de cible et on enregistre l'action dans le fichier log
                enregistrement_tout "Changement de cible via ssh"
                ssh_cible
            }
            x {
                # On Quitte le programme et on enregistre l'action dans le fichier log
                Write-Host "Au revoir !" -ForegroundColor Green
                enregistrement_tout "*********EndScript*********"
                exit 0
            }
            default {
                # Si le choix n'est pas valide, on affiche un message d'erreur
                Write-Host "Choix invalide. Veuillez réessayer." -ForegroundColor Red
            }
        }
    }
}

#==========================================================

########                                            ########
###                                                      ###  
###                   LANCEMENT DU SCRIPT                ###
###                                                      ###
########                                            ########

# On vérifie si le script est exécuté avec les droits d'administrateur
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Host "Ce script doit être exécuté avec les droits d'administrateur." -ForegroundColor Red
    exit 1
}
enregistrement_tout "********StartScript********"
creation_dossier_log
Clear-Host
MenuAdministration
