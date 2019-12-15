[CmdletBinding()]
param ()
try{
    . $PSScriptRoot\Get-RandomPassword.ps1
    Write-Verbose "Imported the main function Get-RandomPassword.ps1"
}
catch{
    Write-Host "An error occured importing the Get-RandomPassword file" -ForegroundColor Red -BackgroundColor Black
    Write-Host $_.Exception.Message -ForegroundColor Red -BackgroundColor Black
}