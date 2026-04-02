Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

Install-ADDSForest `
  -DomainName "laplateforme.io" `
  -DomainNetbiosName "LAPLATEFORME" `
  -SafeModeAdministratorPassword (ConvertTo-SecureString "Azerty_2025!" -AsPlainText -Force) `
  -Force
