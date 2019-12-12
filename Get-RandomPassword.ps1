<#
.SYNOPSIS
    Generates a random password using random common words
.DESCRIPTION
    This cmdlet generates a series of random words which are easy to remember and have fairly high entropy. Based on the xkcd comic (https://xkcd.com/936/)
    Short words: 1 to 4 characters long
    Medium words: 5-8 characters long (default)
    Long words: 9+ characters long
.EXAMPLE
    Get-RandomPassword -Words 3
.EXAMPLE
    Get-RandomPassword -Words 5 -Delimiter "-"
.PARAMETER Words
    Number of words that the password will contain. The default is 3. Example: "car-HORSE-staple" is a 3 word password
.PARAMETER Delimiter
    Separator for the passwords. Default is a dash (-). Example: "car!HORSE!staple" the delimiter here would be the exclamation point (!)
.Parameter Count
    Number of passwords you want generated. Default is 3.
.PARAMETER short
    Specifies to take from the list of short words (1-4 characters long)
.PARAMETER medium
    Specifies to take from the list of medium words (5-8 characters long) (default length if no length is specified)
.PARAMETER long
    Specifies to take from the list of long words (9+ characters long)
.NOTES
    Strong, simple password generation
.FUNCTIONALITY
    Strong, simple password generation
#>

[CmdletBinding(DefaultParameterSetName="medium")]
param (
    [Parameter()] # Number of words that the password will contain. Default is 3
    [int]
    $Words = 3,
    [Parameter()] # Delimiter for the words. Default is a dash (-)
    [string]
    $Delimiter = "-",
    [Parameter()] # Number of passwords that the script will generate. Default is 3
    [int]
    $Count = 3,
    [Parameter(ParameterSetName="short")] # Selects short words (1-4 chars)
    [switch]
    $short,
    [Parameter(ParameterSetName="medium")] # Selects medium words (5-8 chars)
    [switch]
    $medium,
    [Parameter(ParameterSetName="long")] # Selects long words (9+ chars)
    [switch]
    $long,
    [Parameter()]
    [switch]
    $NoCapitalization,
    [Parameter()]
    [switch]
    $DoNotCopyToClipboard
)

$ErrorActionPreference = "Stop"


Get-ChildItem -path $PSScriptRoot\functions\*.ps1 | ForEach-Object { # Import the functions in the functions folder
    write-verbose "Loaded $($_.fullname)"
    . $_.FullName
}

try{
    Write-Verbose "Importing dictionnaries"
    switch ($PSCmdlet.ParameterSetName) {
        short { $dictionnary = Get-Content -Path "$PSScriptRoot\ressources\google-10000-english-usa-no-swears-short.txt" }
        medium { $dictionnary = Get-Content -Path "$PSScriptRoot\ressources\google-10000-english-usa-no-swears-medium.txt" }
        long { $dictionnary = Get-Content -Path "$PSScriptRoot\ressources\google-10000-english-usa-no-swears-long.txt" }
    }
}
catch [ItemNotFoundException]{
    Write-RedText -message  "The required dictionnary files are not present. Please make sure the required files are in the ressources folder."
    exit
}
catch{
    Write-ErrorMessage -Message "An error occured importing the dictionaries! See below for more information:"
    exit
}


$Collection = New-Object System.Collections.Generic.List[string]

1..$Count | ForEach-Object{
    try{
        Write-Verbose "Getting random words from the dictionnary. Currently at iteration number $_"
        $random_words = [string](Get-Random -Count $Words -InputObject $dictionnary)
    }
    catch{
        Write-ErrorMessage -Message "An error occured getting random words from the dictionnary"
        exit
    }

    if ($NoCapitalization -eq $false){
        try{
            Write-Verbose "Randomly capitalizing each word. Currently at iteration number $_"
            $random_words = $random_words | ForEach-Object { $Caps = Get-Random -InputObject ($true,$false); if ($Caps -eq $true) { $_.ToUpper() } else{ $_.ToLower() } } # Randomly capitalizes a word
        }
        catch{
            Write-ErrorMessage -Message "An error occured with the random capitalization of the passwords"
        }
    }
    else{
        Write-Verbose "Capitalization has been toggled off"
    }

    try{
        Write-Verbose "Adding the delimiter to each word, Currently at iteration number $_"
        . Add-Delimiter -Source $random_words -DelimiterParameter $Delimiter
        $Collection += $sanitized
    }
    catch{
        Write-ErrorMessage -Message "An error occured adding a delimiter to the passwords"
    }
}

if ($DoNotCopyToClipboard -eq $false){
    try{
        Write-Verbose "Getting a random passwword from the list"
        Get-Random -InputObject $Collection -Count 1 | Set-Clipboard
        Write-Host "A random password has been copied to your clipboard!" -ForegroundColor Green -BackgroundColor Black
    }
    catch{
        Write-ErrorMessage -Message "An error occured getting a random password"
    }
}