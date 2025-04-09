# TSSR-2503-P2-G2-TheScriptingProject

![Téléassistance](https://i.pinimg.com/736x/a3/10/ee/a310eec1336087c9735736621aba4c7d.jpg)

## Sommaire

- [TSSR-2503-P2-G2-TheScriptingProject](#tssr-2503-p2-g2-thescriptingproject)
  - [Sommaire](#sommaire)
- [🎯 Création de scripts Bash \& Powershell pour facilité l'administration de machines distantes sous différents OS](#-création-de-scripts-bash--powershell-pour-facilité-ladministration-de-machines-distantes-sous-différents-os)
    - [**Présentation**](#présentation)
    - [**Objectifs finaux**](#objectifs-finaux)
    - [📜 Introduction](#-introduction)
    - [👥 Membres du groupe par sprint](#-membres-du-groupe-par-sprint)
    - [⚙️ Choix techniques](#️-choix-techniques)
- [🧗 Difficultés rencontrées](#-difficultés-rencontrées)
- [💡 Solutions trouvées](#-solutions-trouvées)
- [🚀 Améliorations possibles](#-améliorations-possibles)
  
# 🎯 Création de scripts Bash & Powershell pour facilité l'administration de machines distantes sous différents OS

<span id="presentation-du-projet"></span>

### **Présentation**

------------------

> Le but du projet est de mettre en place une **_Télé-assistance_** entre un serveur et un client, via l'utilisation du logiciel **_UltraVNC_** et du **_Bureau à distance_** natif de Windows sur un réseau local entre les différentes machines

### **Objectifs finaux**

---------------------------

- Développer un script **Bash** qui s'exécute sur un serveur Debian permettant l'administration de machines clientes sur **Ubuntu**
- Développer un script **PowerShell** qui s'exécute sur un serveur Windows Server permettant l'administration de machines clientes sur **Windows**

### 📜 Introduction

<span id="introduction"></span>

### 👥 Membres du groupe par sprint

<span id="membres-du-groupe-par-sprint"></span>
**Sprint 1**

| Membre   | Rôle       | Missions |
| -------- | ---------- | -------- |
| Florian | PO         | -  Mise en réseau VM windows 10 et Windows Server |
| Killian | SM         | -  Mise en réseau VM serveur Debian|
| Anthounes | Technicien | - Mise en réseau VM Linux   |

**Sprint 2**

| Membre   | Rôle       | Missions |
| -------- | ---------- | -------- |
| SM | Florian | -   |
| PO | Killian | -  |

### ⚙️ Choix techniques

<span id="choix-techniques"></span>

**Matériel**
**VM Client :**

|        WINDOWS                                              |    GNU/LINUX                                               |
|:----------------------------------------------------------  |----------------------------------------------------------:|
|- Nom : **CLIWIN01**                                         |- Nom : **CLILIN01**                                        |
|- OS : **Windows 10 Pro**                                    |- OS : **Ubuntu-24.04.02-LTS**                              |
|- Compte utilisateur : **Wilder(groupe Admin local)**        |- Compte utilisateur : **wilder(Groupe Sudo)**              |
|- Mot de passe : **Azerty1\***                               |- Mot de passe : **Azerty1\***                              |
|- IP|Masque|DNS : **172.16.20.20 / 255.255.255.0 / 8.8.8.8** |- IP|Masque|DNS : **172.16.20.30 / 255.255.255.0 / 8.8.8.8**|

| Aligné à gauche  |      | Aligné à droite |
| :--------------- | -----:|
| Aligné à gauche  |   ce texte        |  Aligné à droite |
| Aligné à gauche  | Aligné à droite |
| Aligné à gauche  | centré          |    Aligné à droite |





**VM SERVEUR :**

- Nom : **SRVWIN01**
- OS : **Windows server 2022**
- Compte utilisateur :  **Administrator** / **Wilder**
- Mot de passe : **Azerty1**
- IP & Masque : **172.16.10.5 / 255.255.255.0**

**Logiciel :**

- [**UltraVNC 1.4.3.6**](https://uvnc.com/downloads/ultravnc/159-ultravnc-1-4-3-6.html)
- **Bureau à distance** Win10 Version 10.0.19041.5072
- [**Oracle VirtualBox 7.1.6**](https://www.virtualbox.org/wiki/Downloads) / [**VirtualBox Extension pack**](https://www.virtualbox.org/wiki/Downloads)

# 🧗 Difficultés rencontrées

<span id="difficultes-rencontrees"></span>

- Logiciels inconnus [**UltraVNC 1.4.3.6**](https://uvnc.com/downloads/ultravnc/159-ultravnc-1-4-3-6.html)
- Problème de transfert de dossiers avec UltraVNC  

# 💡 Solutions trouvées

<span id="solutions-trouvees"></span>

- Instruction d'installation et d'utilisation du logiciel [**UltraVNC 1.4.3.6**](https://uvnc.com/downloads/ultravnc/159-ultravnc-1-4-3-6.html) via [Youtube](https://www.youtube.com/watch?v=QO-NhJYqR8I)
- Conditions de transfert d'un dossier via UltraVNC

# 🚀 Améliorations possibles

<span id="ameliorations-possibles"></span>

- Utilisation d'autres logiciels de téléassistances possibles, [ici](https://www.appvizer.fr/services-informatiques/controle-distance) une liste d'autres logiciels utilisés (on y retrouve UltraVNC)  
- Communications possibles entre des OS différents ( Linux <--> Windows )
- Possibilité de changer le type réseau (Pont à pont ; réseau NAT...Etc)
- Mise en place d'un Active Directory
