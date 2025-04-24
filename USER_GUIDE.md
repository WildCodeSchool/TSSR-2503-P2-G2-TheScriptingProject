## Sommaire

### 1. [Se déplacer dans le menu](#se-déplacer-dans-le-menu)  
### 2. [Les fonctionnalités](#les-fonctionnalités)  




### 1. Se déplacer dans le menu
<span id="se-déplacer-dans-le-menu"></span>
Pour les deux scripts, nous avons la même organisation des menus.

Le premier menu, dit d'administration, permettra de faire des choix selon le type d'action ou d'information voulue. Il propose les différents sous menus suivant :  
1 - Gérer les utilisateurs  
2 - Gérer la sécurité  
3 - Gérer le paramétrage réseaux  
4 - Gérer les logiciels et répertoires  
5 - Gérer le système  
6 - Rechercher une information déjà demandée/un évenement  
0 - Changer de cible utilisateur et machine  

Puis le script va demander de rentre un chiffre, chiffre correspondant au choix du sous menu.  
Pour aller dans le sous menu de gestion des utilisateurs, alors il suffit d'entrer ``1``

Ce qui nous emmene donc au menu suivant :  
1 - Voir la liste des utilisateurs                    
2 - Création d'un utilisateur                 
3 - Supprimer un utilisateur                 
4 - Changement de mot de passe                
5 - Désactivation de compte utilisateur  
6 - Gestion des groupes  
R - Menu précédent                
X - Quitter

Une fois de plus, le script attend un nouveau choix. Il est possible de d'entrer ``1`` pour avoir la liste des utilisateurs, ou bien d'entrer ``R`` pour
revenir au menu précédent.  
De plus, il est possible de quitter le script à tout moment en entrant ``X``.

### 2. Les fonctionnalités
<span id="les-fonctionnalités"></span>

| Nom du menu principal | Nom du sous menu | Nom | Description ou explication | Présent dans le script Bash? | Présent dans le script PowerShell? |
| :-: | :-: | :-: | :-: | :-: | :-: |
|Gestion d'utilisateur|/|Création de compte utilisateur local|Créer un nouvel utilisateur|&check;|&check;|
|Gestion d'utilisateur|/|Changement de mot de passe|Changer le mot de passer pour un utilisateur|&check;|&check;|
|Gestion d'utilisateur|/|Suppression de compte utilisateur local|Supprimer un utilisateur|&check;|&check;|
|Gestion d'utilisateur|/|Désactivation de compte utilisateur local|Désactiver un utilisateur|&check;|&check;|
|Gestion d'utilisateur|Gestion de groupe|Ajout à un groupe d'administration|Ajout d'un utilisateur dans un groupe d'administration|&check;|&check;|
|Gestion d'utilisateur|Gestion de groupe|Ajout à un groupe local|Ajout d'un utilisateur à un groupe local|&check;|&check;|
|Gestion d'utilisateur|Gestion de groupe|Sortie d’un groupe local|Suppression d'un utilisateur d'un groupe local|&check;|&check;|
|Gestion repertoire/logiciel|/|Installation de logiciel|Installation d'un logiciel depuis une base de paquets|&check;|&check;|
|Gestion repertoire/logiciel|/|Désinstallation de logiciel|Désinstallation d'un logiciel|&check;|&check;|
|Gestion repertoire/logiciel|/|Création de répertoire|Création d'un dossier (donner le path absolu)|&check;|&check;|
|Gestion repertoire/logiciel|/|Suppression de répertoire|Suppression d'un dossier|&check;|&check;|
|Gestion repertoire/logiciel|/|Liste des applications/paquets installées|Voir la liste des paquets et logiciels installés|&check;|&check;|
|Gestion repertoire/logiciel|Execution d'un script|Exécution de script sur la machine distante|Exécution d'un script sur un machine distante (ou on précise l'adresse IP ou le nom)|&check;|&cross;|
|Gestion de la sécurité|/|Execution d'un script|&check;|&cross;|
|Gestion de la sécurité|Règles de pare-feu|Définition de règles de pare-feu|Propositions d'ajout ou de suppression de règles (connexion SSH, avec une certaine adresse IP, ...)|&check;|&check;|
|Gestion de la sécurité|/|Activation du pare-feu|Activation du pare-feu|&check;|&check;|
|Gestion de la sécurité|/|Désactivation du pare-feu|Désactivation du pare-feu|&check;|&check;|
|Gestion de la sécurité|/|Liste des ports ouverts|Voir la liste des ports ouverts|&check;|&check;|
|Gestion de la sécurité|/|Statut du pare-feu|Voir le statut du pare-feu, avec la liste de sports associés, et les autorissations/blocages avec els adresses IPs etc|&check;|&check;|
|Gestion de la sécurité|/|Date de dernière connexion d’un utilisateur|Voir la ate de dernière connexion d’un utilisateur|&check;|&check;|	
|Gestion de la sécurité|/|Date de dernière modification du mot de passe|Voir la date de dernière modification du mot de passe|&check;|&check;|	
|Gestion de la sécurité|/|Liste des sessions ouvertes par l'utilisateur|Voir la liste des sessions ouvertes par l'utilisateur|&check;|&check;|
|Gestion de la sécurité|Gestion des droits d'un utilisateur sur un dossier ou fichier|Droits/permissions de l’utilisateur sur un dossier|Voir les droits et permissions d’un utilisateur sur un dossier spécifique|&check;|&check;|
|Gestion de la sécurité|Gestion des droits d'un utilisateur sur un dossier ou fichier|Droits/permissions de l’utilisateur sur un fichier|Voir les droits et permissions d’un utilisateur sur un fichier spécifique|&check;|&check;|
|Gestion du système|Information du système|Type de CPU, nombre de coeurs, etc.|Information sur le type de CPU, nombre de coeurs etc|&check;|&cross;|
|Gestion du système|Information du système|Mémoire RAM totale|Information sur la mémoire RAM totale|&check;|&cross;|
|Gestion du système|Information du système|Utilisation de la RAM|Information sur l'tilisation de la RAM actuellement|&check;|&cross;|
|Gestion du système|Information du système|Utilisation du disque|Information sur l'tilisation du disque actuellement|&check;|&cross;|
|Gestion du système|Information du système|Utilisation du processeur|Information sur l'tilisation du processeur actuellement|&check;|&cross;|
|Gestion du système|Information du système|Version de l'OS|Information sur le système d'exploitation de la machine actuelle|&check;|&cross;|
|Gestion du système|Action sur le système|Arrêt|Arrêt de la machine|&check;|&cross;|
|Gestion du système|Action sur le système|Redémarrage|Redémarrage de la machine|&check;|&cross;|
|Gestion du système|Action sur le système|Verrouillage|Verrouillage de la machine|&check;|&cross;|
|Gestion du système|Action sur le système|Mise-à-jour du système|Mise-à-jour du système|&check;|&cross;|
|Gestion du réseau|/|Adresse MAC|Information sur les adresses MACs des interfaces de la machine|&check;|&check;|
|Gestion du réseau|/|Adresse IP de chaque interface|Adresses Ip et nom des machines dans le réseau|&check;|&check;|
|Gestion du réseau|/|Nombre d'interface|Information sur le nombre d'interfaces connectes|&check;|&check;|
|Recherche d'une information déjà demandée/un évenement|/|Recherche des evenements dans le fichier log_evt.log pour un utilisateur|Recherche dans le fichier log de toutes les actions faites (déplacement dans le menu, actions faites, informations demandées, etc)|&check;|&check;|
|Recherche d'une information déjà demandée/un évenement|/|Recherche des evenements dans le fichier log_evt.log pour un ordinateur|Recherche dans le fichier log de toutes les actions faites (déplacement dans le menu, actions faites, informations demandées, etc)|&check;|&check;|
|Prise en main à distance|/|Prise de main à distance (GUI)|Faire une prise ne main à distance via un logiciel en graphique|&cross;|&cross;|
-------------------
# ❓ FAQ — 
-------------------

**Q : Comment naviguer dans les menus ?**

> Il suffit de saisir le chiffre ou la lettre correspondant au menu ou sous-menu désiré. Par exemple, tapez 1 pour accéder à la gestion des utilisateurs, puis R pour revenir au menu précédent ou X pour quitter._

**Q : Puis-je quitter le script à tout moment ?**

> Oui, entrez simplement X pour fermer le script immédiatement, peu importe le menu où vous êtes._

**Q : Que faire si je me suis trompé de menu ?**

> Entrez R pour revenir au menu précédent._

**Q : Est-ce que je peux installer et désinstaller des logiciels ?**

> Oui, dans le menu "Gestion des logiciels et répertoires", vous pouvez installer ou désinstaller des logiciels via une base de paquets._

**Q : Puis-je créer ou supprimer des répertoires ?**

> Absolument. Utilisez les options "Création de répertoire" ou "Suppression de répertoire" dans ce même menu._

**Q : Est-ce que je peux définir des règles de pare-feu avec ce script ?**

> Oui, dans le menu Sécurité, sélectionnez l’option correspondante pour gérer les règles de pare-feu (ajout, suppression, ports ouverts, etc.)._

**Q : Comment voir les connexions actives d’un utilisateur ?**

> Utilisez l’option "Liste des sessions ouvertes par l'utilisateur" dans le menu Sécurité._

**Q : Je n’ai pas les droits administrateur, puis-je tout de même suivre ce guide ?**
> _Non, pour le script Powershell, il est nécéssaire d'éxecuter le fichier avec les droits administrateur. Pour le script Bash vous devez connaitre le mot de passe d'administrateur pour que certaine options fonctionne correctement._
