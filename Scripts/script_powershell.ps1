#Script PowerShell, (document à ouvrir dans PowerShell ISE ? pour y avoir le script)

############################
#fonction pour enregistrer dans le ficheir log_evt.log

function enregistrement_tout {
#Les evenements seront écrits en $1 (apres l'appel de fonction)
param ($Argument1)
Add-Content -Path c:\PerfLogs\log_evt.log -Value "$(Get-Date -Format "yyyyMMdd-HHmmss")-$env:USERNAME-$Argument1"
}

########################
#fonction pour enregistrer les informations dans le dossier log (dans le dossier d execution du script, donc la où on sera quand on executera le script)
function enregistrement_information {
$dossier_log = "log"

if (-not (Test-Path -Path $dossier_log -PathType Container)) {
    New-Item -Path $dossier_log -ItemType Directory
}

$date = Get-Date -Format "yyyyMMdd-HHmmss"
# On ajuste le nom du fichier pour une information ordinateur sous la forme <NomDuPC>-GEN_<Date>.txt qui sera créé dans le dossier "log"
        ordi_info_log="info_$env:COMPUTERNAME_GEN_$date.txt"
    # On ajuste le nom du fichier pour une information utilisateur sous la forme <NomDuPC>_<NomDeLUtilisateur>_<Date>.txt     
        user_info_log="info_$env:COMPUTERNAME_$env:USERNAME_$date.txt"
}

#####################################

function recherche_log {
Clear-Host
Write-Host "Quelle est votre recherche ?"
Write-Host "Vous pouvez chercher par le nom d'utilisateur,"
Write-Host "Par l'évenement (Vision de..., Déplacement menu ... Activation SSH ...)"
$recherche = Read-Host "Votre réponse "
#On intègre la commande pour faire la recherche dans une variable pour faire un if (et donc avoir le résultat s'il y en a un, ou un message d'erreur s'il n'y  a pas de correspondance avec les mot-clefs insérés)
$resultat = Get-Content -Path "C:\PerfLogs\log_evt.log" | Where-Object { $_ -like "*$recherche*" }
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
enregistrement_tout "Direction vers le menu principal"
start
}
default {
Write-Host "Choix invalide. Veuillez réessayer."
}
}
}


########################
function Gestion_Droits {
Clear-Host
while ($true) {
Write-Host ""
Write-Host "MENU GESTION DES DROITS"
Write-Host "Que voulez-vous voir ?"
Write-Host "1. Droits/Permissions de l'utilisateur sur un dossier :"
Write-Host "2. Droits/Permissions de l'utilisateur sur un fichier :"
Write-Host "R. Retour au menu précédent"
Write-Host "X. Quitter"
$choix = Read-Host "Votre réponse "

switch ($choix) {

1 { 
    $dossier = Read-Host "De quel dossier voulez-vous vérifier les droits (donnez le path absolu ? "
    if (Test-Path $dossier) {
        Get-Acl -Path $dossier
        enregistrement_tout "Vérification des droits et permissions du dossier $dossier"
    } else {
        Write-Host "Le dossier n'existe pas."
    }

}
2 {
    $fichier = Read-Host "De quel fichier voulez-vous vérifier les droits (donnez le path absolu) ? "
    if (Test-Path $fichier) {
        Get-Acl -Path $fichier
        enregistrement_tout "Vérifications des droits et permissions du fichier $fichier"
    } else {
        Write-Host "Le fichier n'existe pas."
    }
}
default {
    Write-Host "Choix invalide. Veuillez réessayer."
}
}
}
}

###################################################


function repertoire_logiciel {
Clear-Host
while ($true) {
Write-Host ""
Write-host "MENU GESTION REPERTOIRES/LOGICIELS"
Write-host "Que voulez vous faire ? "
Write-host "1) Créer un répertoire"
Write-host "2) Suppression d'un répertoire"
Write-host "3) Installer un logiciel"
Write-host "4) Désinstaller un logiciel"
Write-host "5) Voir la liste des applications et paquets installés"
Write-host "6) Executer de script sur machine distante"
Write-host "R) Menu Principal"
Write-host "X) Quitter"
$choix = Read-Host "Votre réponse "

switch ($choix) {
1 {
    $repertoire = Read-Host "Quel nom voulez-vous donner au répertoire (écrire le path absolu) "
    if (Test-Path -Path $repertoire) {
        Write-Output "Le répertoire $repertoire existe déjà"
    }
    else {
        New-Item -ItemType Directory -Path $repertoire -Force > $Null
        Write-Host "Répertoire $repertoire a bien été créée"
        enregistrement_tout "Création du répertoire $repertoire"
    }

}

2 {
    $repertoire = Read-Host "Quel répertoire voulez-vous supprimer ? (entrez le path absolu) "
    if (Test-Path -Path $repertoire) {
        Remove-Item -Path $repertoire -Recurse -Force
        Write-Output "Le répertoire $repertoire a été supprimé"
        enregistrement_tout "Suppression du répertoire $repertoire"
    }
    else {
        Write-Host "Répertoire $repertoire n'existe pas"
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
        Write-Host "Logiciel non trouvé dans la liste des paquets Winget"
    }
}
4 {
    $logiciel = Read-Host "Nom du logiciel à désinstaller "
    winget uninstall --name $logiciel
    #Pas de vérification de la désinstallation du logiciel
    enregistrement_tout "Désinstallation du logiciel $logiciel"
}
5 { Write-Host "Les applications et paquets installés sont :"
    winget list
    enregistrement_tout "Vision de tous les paquets et applications installés"
}   
6 { enregistrement_tout "Direction vers l'execution de script a distance"
    execution_script
}
r { enregistrement_tout "Direction vers le menu principal"
    start
}
x {
    Write-Host ""
    Write-Host "Au revoir !"
    enregistrement_tout "*********EndScript*********"
    exit 0
}
default {
Write-Host "Choix invalide. Veuillez réessayer."
}
}
}
}


#######################################################

function regles{
Clear-Host
while ($true) {

Write-host "Que voulez vous faire ?"
Write-host "1) Activer/désactiver les connexions avec une adresse IP spécifique"
Write-host "2) Activer/désactiver les connexions via ssh"
Write-host "R) Retour au menu précédent"
Write-host "X) Quitter"
$choix = Read-Host "Votre réponse "

switch ($choix) {
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
        Write-Host "Choix invalide. Veuillez réessayer."
        }

}
Write-Host ""
}
2 {
    $ssh_onoff = Read-Host "Voulez-vous activer (o) ou désactiver (n) les connexions SSH ? "
    $ssh_port = Read-Host "Sur quel port est le protocole SSH ? (22 par défaut)"
    $ip_specifique = Read-Host "Avec quelle adresse IP ? "

    switch ($ssh_onoff) {
    o {
        New-NetFirewallRule -DisplayName "AutoriserSSHEntrantDepuis:$ip_specifique" -Direction Inbound -Action Allow -Protocol TCP -RemotePort $ssh_port -RemoteAddress "$ip_specifique" -Enabled True > $null
        New-NetFirewallRule -DisplayName "AutoriserSSHSortantVers:$ip_specifique" -Direction Outbound -Action Allow -Protocol TCP -RemotePort $ssh_port -RemoteAddress "$ip_specifique" -Enabled True > $null
        Write-Host "Connexions SSH l'adresse IP $ip_specifique autorisées"
        enregistrement_tout "Autorisation des connexions SSH avec l'adresse IP $ip_specifique"
    }
    n {
        New-NetFirewallRule -DisplayName "BloquerSSHEntrantDepuis:$ip_specifique" -Direction Inbound -Action Block -Protocol TCP -RemotePort $ssh_port -RemoteAddress "$ip_specifique" -Enabled True > $null
        New-NetFirewallRule -DisplayName "BloquerSSHSortantVers:$ip_specifique" -Direction Outbound -Action Block -Protocol TCP -RemotePort $ssh_port -RemoteAddress "$ip_specifique" -Enabled True > $null
        Write-Host "Connexions SSH l'adresse IP $ip_specifique bloquées"
        enregistrement_tout "Blocage des connexions SSH avec l'adresse IP $ip_specifique"
        }
        default {
        Write-Host "Choix invalide. Veuillez réessayer."
        }
    }
Write-Host ""
}
default {
Write-Host "Choix invalide. Veuillez réessayer."
}
}
}
}

#############################################

function reseaux{
Clear-Host
while ($true) {

Write-host "Que voulez vous faire ?"
Write-host "1) Voir l'adresse MAC"
Write-host "2) Voir les adresses IP des interfaces"
Write-host "3) Voir le nombre d'interfaces"
Write-host "R) Retour au menu précédent"
Write-host "X) Quitter"
$choix = Read-Host "Votre réponse "

switch ($choix) {
1 {
    Write-Host ""
    Write-Host "Les adresses MAC de vos cartes réseaux sont : "
    Write-Host ""
    #Lors de la premiere itération de la boucle, le resultat de la commande ne s'affichait pas mais s'affichait bien lors de la seconde intération (et au dela) surement du a un temps de récupération de l'info, d'où l'ajout de "| Out-Host" qui permet de forcer l'affichage du résultat
    $(Get-NetAdapter | Select-Object Name, MacAddress) | Out-Host
    enregistrement_tout "Vision des adresses MAC des cartes réseaux"
}
2 {
#Quelle version d'IP 
    Write-host "Quelle version d'adresse IP voulez-vous ?"
    Write-host "1) IPv4"
    Write-host "2) IPv6"
    Write-host "3) Les deux"
    $ip = Read-Host "Votre réponse : "
    Write-host ""
    
switch ($ip) {
1 { 
    Get-NetIPConfiguration | Select-Object IPv4Address, InterfaceAlias | Out-Host
    enregistrement_tout "Vision des adresses IPv4 des interfaces"
}
2 {
    Get-NetIPConfiguration | Select-Object IPv6Address, InterfaceAlias | Out-Host
    enregistrement_tout "Vision des adresses IPv6 des interfaces"
}
3 {
    Get-NetIPConfiguration | Select-Object IPv4Address, IPv6Address, InterfaceAlias | Out-Host
    enregistrement_tout "Vision des adresses IPv4 et IPv6 des interfaces"
}
default {
Write-Host "Choix invalide. Veuillez réessayer."
}
    }
}
3 {
#Nombre d'interfaces
    Write-Host ""
    Write-Host "Il y a $((Get-NetAdapter).Count) interfaces connectées"
    Write-Host ""
    enregistrement_tout "Vision du nombre d'interfaces connectées"
}
default {
Write-Host "Choix invalide. Veuillez réessayer."
}
}
}
}


#########################################

function Security {
Clear-Host
while ($true) {
Write-host ""
Write-host "MENU GESTION DE LA SECURITE"
Write-host "Que voulez vous faire ?"
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
$choix = Read-Host "Votre réponse "

switch ($choix) {
#Activation du parefeu
1 {
    Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled True ;
    Write-Host "Pare-feu activé"
    enregistrement_tout "Activation du pare-feu"
}
#désactivation parefeu
2 {
    Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False ;
    Write-Host "Pare-feu désactivé"
    enregistrement_tout "Désactivation du pare-feu"
}
3 {
enregistrement_tout "Direction vers le menu de gestion des règles pare-feu"
#direction le menu de regles
regles
}
4 {
#état du parefeu
    Write-Host "Voici l'état du pare-feu :"
    Get-NetFirewallProfile
    enregistrement_tout "Vision de l'état du pare-feu"
}
5 {
#voir les ports ouverts (d'abord TCP puis UDP)
    Write-Host "Les ports TCP ouverts sont :"
    Get-NetTCPConnection | Format-Table -AutoSize
    Write-Host ""
    Write-Host "Les ports UDP ouverts sont :"
    Get-NetUDPEndpoint | Format-Table -AutoSize
    enregistrement_tout "Vision des ports ouverts"
}
6 {
#vers le menu de gestion de droits/permissions
enregistrement_tout "Directon vers le menu de gestion des droits et permissions"
    Gestion_Droits
}
7 {
#derniere connexion de l'user demandé
    $user = Read-Host "De quel utilisateur ? "
#le parametre [EventData[Data[@Name='TargetUserName' permet de filtrer l'élément dont le nom est 'TargetUserName' à l'interieur de EventData
#le parametre event ID 4624 dans le journal de sécurité Windows correspond à une connexion réussie
    Get-WinEvent -LogName Security -FilterXPath "*[EventData[Data[@Name='TargetUserName']='$user'] and System[EventID='4624']]" -MaxEvents 1
    enregistrement_tout "Vision de la dernière connexion de l'utilisateur $user"
}
8 {
    $user = Read-Host "De quel utilisateur ? "
    #On ne va afficher que la 9e ligne de la commande net user, qui correspond a la ligne du dernier changement de mdp (skip les 8 premieres, et puis que la premiere, donc la  9e)
    net user $user | Select-Object -Skip 8 -First 1
    enregistrement_tout "Vision de la dernière modification du mot de passe de l'utilisateur $user"
}
9 {
    Get-WmiObject -Class Win32_LogonSession | Select-Object Name, LogonId, LogonType | Out-Host
    enregistrement_tout "Vision de la liste des sessiosn ouvertes"
}
default {
Write-Host "Choix invalide. Veuillez réessayer."
}
}
}
}


################################################

#START

function start
{
Clear-Host
while ($true) {
Write-Host ""

Write-Host "BIENVENUE DANS LE MENU D'ADMINISTRATION"
Write-Host "Que voulez-vous faire ? "
Write-Host "1. Gérer les utilisateurs"
Write-Host "2. Gérer la sécurité"
Write-Host "3. Gérer le paramétrage réseaux"
Write-Host "4. Gérer les logiciels et répertoires"
Write-Host "5. Gérer le système"
Write-Host "6. Rechercher une information déjà demandée/un évenement"
Write-Host "0. Changer de cible utilisateur et machine"
Write-Host "X. Quitter"
$choix = Read-Host "Votre réponse "
switch ($choix) {
1 {
enregistrement_tout "Direction vers le menu de gestion des utilisateurs"
    Gestion_Utilisateur
}
    #direction vers security = lancement fonction security
2 {
enregistrement_tout "Direction vers le menu de gestion de la sécurité"
security
}

    #direction vers reseaux = lancement fonction reseaux
3 {
enregistrement_tout "Direction vers le menu de gestion du paramétrage réseau"
reseaux
}

    #direction vers repertoire_logiciel = lancement fonction repertoire_logiciel
4 {
enregistrement_tout "Direction vers le menu de gestion des logiciels et répertoires"
repertoire_logiciel
}

    #direction vers Gestion_Systeme = lancement fonction Gestion_Systeme
5 {
enregistrement_tout "Direction vers le menu de gestion du système"
Gestion_Systeme
}

6 {
enregistrement_tout "Direction vers la recherche dans le log"
recherche_log
}

0 {
enregistrement_tout "Changement de cible via ssh"
ssh_cible
}

x {
Write-Host "Au revoir !"
enregistrement_tout "*********EndScript*********"
exit 0
}

default {
Write-Host "Choix invalide. Veuillez réessayer."
}

}
}
}

enregistrement_tout "********StartScript********"
start
