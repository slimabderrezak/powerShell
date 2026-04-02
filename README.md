Processus 

(Windows Serveur 2022)

1. Création domaine avec le script.

Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

Install-ADDSForest
  
  -DomainName "laplateforme.io"
  
  -DomainNetbiosName "LAPLATEFORME"
 
  -SafeModeAdministratorPassword (ConvertTo-SecureString "Azerty_2025!" -AsPlainText -Force)
 
  -Force


 Serveur redémarre -> contrôleur de domaine prêt.

2. Import utilisateurs CSV
Script_Users.ps1 :
- Création de l'OU "Utilisateurs"
- Mot de passe commun et changement forcé : Azerty_2025! + ChangePasswordAtLogon $true
- Login : prenom.nom@laplateforme.io
- Groupes : groupe1 à groupe6 du CSV

3. Vérifications

Get-ADUser -Filter * -SearchBase "OU=Utilisateurs,DC=laplateforme,DC=io"

Get-ADGroupMember "Cadre"


 Résultat
- Les 14 utilisateurs ont bien etait créés dans l'OU "Utilisateurs"
- Les 8 groupes ont bien etait crées
- Tous les comptes activés avec mot de passe commun + changement forcé

Toute les captures d'écrans et les scripts sont disponibles en piéces jointes.
