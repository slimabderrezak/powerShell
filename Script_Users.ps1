Import-Module ActiveDirectory

$csvPath = "C:\Scripts\users.csv"
$password = ConvertTo-SecureString "Azerty_2025!" -AsPlainText -Force

# Tous les utilisateurs dans l'OU Utilisateurs
if (-not (Get-ADOrganizationalUnit -LDAPFilter "(ou=Utilisateurs)" -ErrorAction SilentlyContinue)) {
    New-ADOrganizationalUnit -Name "Utilisateurs" -Path "DC=laplateforme,DC=io"
}

$ouPath = "OU=Utilisateurs,DC=laplateforme,DC=io"

$users = Import-Csv $csvPath

foreach ($u in $users) {

    $sam = ($u.prenom + "." + $u.nom).ToLower()

    New-ADUser `
        -Name "$($u.prenom) $($u.nom)" `
        -SamAccountName $sam `
        -UserPrincipalName "$sam@laplateforme.io" `
        -GivenName $u.prenom `
        -Surname $u.nom `
        -AccountPassword $password `
        -ChangePasswordAtLogon $true `
        -Enabled $true `
        -Path $ouPath

    # Gestion rapide des groupes
    $groupes = @($u.groupe1,$u.groupe2,$u.groupe3,$u.groupe4,$u.groupe5,$u.groupe6)

    foreach ($g in $groupes) {
        if ([string]::IsNullOrWhiteSpace($g)) { continue }

        if (-not (Get-ADGroup -Filter "Name -eq '$g'" -ErrorAction SilentlyContinue)) {
            New-ADGroup -Name $g -GroupScope Global -Path "CN=Users,DC=laplateforme,DC=io"
        }

        Add-ADGroupMember -Identity $g -Members $sam -ErrorAction SilentlyContinue
    }
}
