# **Scripting Project**
![Scripting Project](Ressources/Projet2Scripting.JPG)

## Sommaire 

- [🎯 Présentation du projet](#presentation-du-projet)
- [📜 Introduction](#introduction)
- [👥 Membres du groupe par sprint](#membres-du-groupe-par-sprint)
- [⚙️ Choix Techniques](#choix-techniques)
- [🧗 Difficultés rencontrées](#difficultes-rencontrees)
- [💡 Solutions trouvées](#solutions-trouvees)
- [🚀 Améliorations possibles](#ameliorations-possibles)

# 🎯 **Présentation du projet**
<span id="presentation-du-projet"></span>

## **Présentation**

Scripts **Bash** et **PowerShell**  
Avec chacun, plusieurs fonctionnalités, qui peuvent être des informations, ou des actions; sur différentes cibles : la machine cliente, ou la machine serveur.
Les machines sont détaillées dans la section choix techniques.

## **Objectifs finaux**

_Tâche principale :_

 - Développer un script Bash qui s'exécute sur un serveur Debian pour administrer des machines clientes Ubuntu
 - Développer un script PowerShell qui s'exécute sur un serveur Windows Server pour administrer des machines clientes Windows


_Objectif secondaire :_

 - Développer un script Bash qui s'exécute sur un serveur Debian pour administrer des machines clientes Windows.
 - Développer un script PowerShell qui s'exécute sur un serveur Windows Server pour administrer des machines clientes Ubuntu.

En raison d'un manque de temps et de volonté de priorisation; l'objectif secondaire n'aura pas été réalisé.


# 📜 **Introduction**
<span id="introduction"></span>

Les scripts permettent d'automatiser une ou plusieurs actions. Ils permettent ainsi un gain de temps conséquent. De plus, de par les nombreuses fonctionnalités incorporées dans les scripts, ces scripts offrent une multitude de possibilités et sont donc plutôt complets en terme d'administration.

Dans ce projet, nous allons proposer des fonctionnalités via les commandes associées, sur les versions Bash et PowerShell. Ces commandes seront employées à distances, via un protocole de connexion à distance : le SSH.

Vous retrouvez plus d'information les documents USER_GUIDE.md et INSTALL.md


## 👥 Membres du groupe par sprint
<span id="membres-du-groupe-par-sprint"></span>


Pour ce projet, nous avons suivi la méthode de gestion de projet Scrum.
Le projet ayant duré 4 semaines, il a été divisé en 4 sprints, représentant chacun une semaine.

Les tableaux suivants résument la répartition des rôles par sprint.

### Sprint 1



| Membre           | Rôle          | 
| ---------------- | ------------- | 
| Anthounes NEZI   | Technicien    | 
| Florian CHERON   | Product Owner | 
| Killian CASTILLO | Scrum Master  | 

### Sprint 2


| Membre           | Rôle          | 
| ---------------- | ------------- |  
| Florian CHERON   | Scrum Master | 
| Killian CASTILLO | Product Owner  | 

### Sprint 3


| Membre           | Rôle          | 
| ---------------- | ------------- |  
| Florian CHERON   | Product Owner | 
| Killian CASTILLO | Scrum Master  | 

### Sprint 4


| Membre           | Rôle          | 
| ---------------- | ------------- |  
| Florian CHERON   | Scrum Master | 
| Killian CASTILLO | Product Owner  | 


# ⚙️ **Choix techniques**
<span id="choix-techniques"></span>
Les machines ont été configurées comme suit sur Proxmox et en local pour des tests.  
Sur le noeud du [proxmox](https://node5.infra.wilders.dev:8006/#v1:0:18:4:::::::) **wcs-cyber-node05**. Nos machines sont les machines de **546** à **549** :

| Nom   | OS       | IP | DNS | ID Proxmox |
| :-: | :-: | :-: | :-: | :-: |
| CLILIN01 | Ubuntu 24.04 LTS | 172.16.20.30/24| 8.8.8.8 | 546 |
| CLIWIN01 | Windows 10 | 172.16.20.20/24| 8.8.8.8 | 547 |
| SRVWIN01 | Windows Server 2022 | 172.16.20.5/24| 8.8.8.8 | 548 |
| SRVLX01 | Debian 12.9 | 172.16.20.10/24| 8.8.8.8 | 549 |



# 🧗 **Difficultés rencontrées**
<span id="difficultes-rencontrees"></span>

- Mise en place du protocole SSH
- Connaissance des commandes et de la syntaxe de celles-ci

# 💡 **Solutions trouvées**
<span id="solutions-trouvees"></span>

- Beaucoup de temps passé sur la documentation, à faire des tests
- Documentations et recherches des commandes, tests et corrections sur les VMs locales

# 🚀 **Améliorations possibles à mettre en place**
<span id="ameliorations-possibles"></span>

- Plus de fonctionnalités mises en place dans le script PowerShell
- Clé SSH pour éviter d'insérer le mot de passe de la session à distance
- Objectif secondaire
