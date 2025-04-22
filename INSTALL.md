## Sommaire

### 1. [Prérequis technique](#prerequis-technique)  
   1.1 [Update et upgrade](#Update-et-upgrade)  
   1.2 [Paramétrage des IP](#Paramétrage-des-IP)  
         1.2.a [CLILIN01](#ubuntu)  
         1.2.b [CLIWIN01](#Client-Windows)  
         1.2.c [SRVWIN01](#Windows-Serveur-2022)  
         1.2.d [SRVLX01](#Serveur-Debian)  
         

   1.3 [Paramétrage du réseau](#Paramétrage-du-réseau)  
         1.3.a [CLILIN01](#ubuntu_reseau)  
         1.3.b [CLIWIN01](#Client-Windows_reseau)  
         1.3.c [SRVWIN01](#Windows-Serveur-2022_reseau)  
         1.3.d [SRVLX01](#Serveur-Debian_reseau)  
         

 


### 1. Prérequis techniques
<span id="prerequis-technique"></span>
  #### 1.1 Update et upgrade  
  <span id="Update-et-upgrade"></span>

Avant toute chose, pour les machines sous distribution GNU/Linux, vérifiez que vous avez la dernière version de paquets disponibles. Pour cela, rien de plus simple, il suffit d'entrer ces deux commandes :
``` sudo apt update ```
``` sudo apt upgrade ```

Vous êtes désormais à jour. 

  
  #### 1.2 Paramétrage des IP  
  <span id="Paramétrage-des-IP"></span>
Nous allons configurer les machines pour atteindre cette configuration finale : 

| Nom   | OS       | IP | DNS |
| :-: | :-: | :-: | :-: |
| CLILIN01 | Ubuntu 24.04 LTS | 172.16.20.30/24| 8.8.8.8 |
| CLIWIN01 | Windows 10 | 172.16.20.20/24| 8.8.8.8 |
| SRVWIN01 | Windows Server 2022 | 172.16.20.5/24| 8.8.8.8 |
| SRVLX01 | Debian 12.10 | 172.16.20.10/24| 8.8.8.8 |
  
   ##### 1.2.a CLILIN01  
   <span id="ubuntu"></span>

D'abord, paramétrons le client. Ici, nous utilisons la version Ubuntu 24.04.2 LTS. Vous pouvez le vérifier avec la commande
``` lsb_release -a ```

Nous allons dans les Paramètres; dans la rubrique Réseau; puis dans les options du réseau qui nous intéresse : Ethernet enp0s8. Il est possible d'y voir vos cartes réseau avec la commande 
``` ip -a ```

Dans la rubrique IPv4, nous allons insérer une adresse IP et un masque. Dans notre cas, nous choisirons 172.16.20.30 et 255.255.255.0.  
Ajoutons ensuite la passerelle 172.16.20.254 et le DNS en 8.8.8.8.  
Ce qui devrait donner ceci :  
![IP_CLILIN01](Ressources/configuration_CLILIN01.png)  
 

   ##### 1.2.c SRVWIN01  
<span id="Windows-Serveur-2022"></span>

Enchaînons avec le Windows serveur. Dans Server Manager, allons dans la rubrique Local Server, puis cliquons sur l'extralien de Ethernet 2. Allons dans les propriétés d'Ethernet (click droit, Properties). Puis dans Internet Protocol Version 4 (TCP/IPv4). C'est ici que nous insérons l'addresse IP, le masque, la passerelle et le DNS. Le résultat suivant est ainsi obtenu :

![IP_windows](Ressources/screen_IP_SRVWIN01.png)  

   ##### 1.2.d SRVLX01  
   <span id="Serveur-Debian"></span>
         
Ici, nous utilisons la version Debian 12.10. Vous pouvez le vérifier avec la commande
``` cat /etc/debian_version ```
Le plus simple est de se connecter directement avec le compte root.  
Ensuite, modifions le fichier /etc/network/interfaces avec la commande ```nano /etc/network/interfaces```  
Configurez votre seconde carte réseau, en insérant l'adresse IP, le masque et la passerelle de la façon suivante :

![IP_debian](Ressources/screen_network_interfaces_SRVLX01.png) 

Nous avons changé le "allow hotplug" en "auto" par mesure de précaution. Cela signalera d'activer la carte au branchement de celle-ci. ens18 étant le nom de la carte réseau, et également "dhcp" en "static" pour signaler une configuration manuelle. Une fois fait, vous pouvez enregistrer et quitter le fichier.

  #### 1.3 Paramétrage du réseau  
<span id="Paramétrage-du-réseau"></span>
   ##### 1.3.a CLILIN01  
<span id="ubuntu_reseau"></span>

Maintenant, établissons la connexion entre les machines. Pour cela, nous allons modifier le fichier /etc/hosts et y ajouter les adresses IP et les noms de machines correspondant. Pour cela, tapez la commande ```sudo nano /etc/hosts```. Dans notre cas, voici le résultat :

![reseau_CLILIN01](Ressources/screen_reseau_CLILIN01.png) 

   ##### 1.3.b Serveur Debian  
<span id="Serveur-Debian_reseau"></span>
Nous allons procéder à la même chose sur le serveur Debian. Pour cela, même commande (le sudo n'est pas nécessaire si vous êtes sur le compte root) ```nano /etc/hosts```  
Vous pouvez maintenant ajouter les adresses IP des machines de votre futur réseau. 

![reseau_debian](Ressources/screen_reseau_SRVLX01.png)  
   ##### 1.3.c Windows Serveur 2022  
<span id="Windows-Serveur-2022_reseau"></span>
Nous allons maintenant le faire sur le serveur Windows. Dans l'explorateur de fichiers, nous allons suivre le chemin suivant : C:\Windows\System32\drivers\etc pour ouvrir le fichier hosts. Ajoutons-y les adresses IP des autres machines :

![reseau_windows](Ressources/screen_reseau_SRVWIN01.png) 


