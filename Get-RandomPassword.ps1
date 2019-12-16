function Get-RandomPassword{
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
    .EXAMPLE
        Get-RandomPassword -Words 7 -Delimiter "%" -Count 10 -Long -NoCapitalization -DoNotCopyToClipboard -Language arabic
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
    .PARAMETER NoCapitalization
        Specifies that all words will be in lowercase
    .PARAMETER DoNotCopyToClipboard
        Will not copy a random password to your clipboard
    .PARAMETER Language
        Generates a password using the selected language (default is english)
    .PARAMETER ShowLanguages
        Displays a list of available languages
    .NOTES
        Strong, simple password generation
    .FUNCTIONALITY
        Strong, simple password generation
    #>

    [CmdletBinding(DefaultParameterSetName="medium")]
    [Alias('gr')]
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
        $DoNotCopyToClipboard,
        [Parameter()]
        [string]
        $Language = "english",
        [Parameter(ParameterSetName="ShowLanguages")]
        [switch]
        $ShowLanguages
    )

    $ErrorActionPreference = "Stop"

    Get-ChildItem -path $PSScriptRoot\functions\*.ps1 | ForEach-Object { # Import the functions in the functions folder
        Write-Verbose "Loaded function $($_.fullname)"
        . $_.FullName
    }


    $Available_languages = New-Object System.Collections.Generic.List[string]
    Get-ChildItem -Directory -Path $PSScriptRoot\ressources | ForEach-Object {
        $Available_languages.Add($_)
    }
    Write-Verbose "$($Available_languages.Count) languages found"


    if ($PSCmdlet.ParameterSetName -eq "ShowLanguages"){
        Write-Host "Available languages: " -NoNewline -ForegroundColor Green -BackgroundColor Black
        Add-Delimiter -Source $Available_languages -Delimiter ", "
        break
    }


    if ($Language -notin $Available_languages){
        Add-Delimiter -Source $Available_languages -Delimiter ", "
        throw "The selected language $Language does not exist. See the list above for a list of available languages"
    }


    Get-ChildItem -path $PSScriptRoot\functions\*.ps1 | ForEach-Object { # Import the functions in the functions folder
        Write-Verbose "Loaded function $($_.fullname)"
        . $_.FullName
    }

    try{
        Write-Verbose "Importing dictionnaries"
        switch ($PSCmdlet.ParameterSetName) {
            short {
                try{
                    Write-Verbose "$Language selected with short words. Retrieving corresponding words"
                    $dictionary = Get-Content -Path "$PSScriptRoot\ressources\$language\$language-short-words.txt" -Encoding UTF8
                }
                catch{
                    Write-ErrorMessage "An error occured getting the dictionary file for $language $($PSCmdlet.ParameterSetName)"
                    throw
                }
            }
            medium {
                try{
                    Write-Verbose "$Language selected with medium words. Retrieving corresponding words"
                    $dictionary = Get-Content -Path "$PSScriptRoot\ressources\$language\$language-medium-words.txt" -Encoding UTF8
                }
                catch{
                    Write-ErrorMessage "An error occured getting the dictionary file for $language $($PSCmdlet.ParameterSetName)"
                    throw
                }
            }
            long {
                try{
                    Write-Verbose "$Language selected with long words. Retrieving corresponding words"
                    $dictionary = Get-Content -Path "$PSScriptRoot\ressources\$language\$language-long-words.txt" -Encoding UTF8
                }
                catch{
                    Write-ErrorMessage "An error occured getting the dictionary file for $language $($PSCmdlet.ParameterSetName)"
                    throw
                }
            }
        }
    }
    catch [System.Management.Automation.ItemNotFoundException]{
        Write-RedText -message  "The language selected was not found in the ressources folder or the $($PSCmdlet.ParameterSetName) dictionary file for that specific language is missing."
        throw
    }
    catch{
        Write-ErrorMessage -Message "An error occured importing the dictionnaries! See below for more information:"
        throw
    }


    $Collection = New-Object System.Collections.Generic.List[string]

    1..$Count | ForEach-Object{
        try{
            Write-Verbose "Getting random words from the dictionary. Currently at iteration number $_"
            $random_words = (Get-Random -Count $Words -InputObject $dictionary)
        }
        catch{
            Write-ErrorMessage -Message "An error occured getting random words from the dictionary"
            throw
        }

        if ($NoCapitalization -eq $false){
            try{
                Write-Verbose "Randomly capitalizing each word. Currently at iteration number $_"
                $random_words = [string]($random_words | ForEach-Object { $Caps = Get-Random -InputObject ($true,$false); if ($Caps -eq $true) { $_.ToUpper() } else{ $_.ToLower() } }) # Randomly capitalizes a word
            }
            catch{
                Write-ErrorMessage -Message "An error occured with the random capitalization of the passwords"
            }
        }
        else{
            Write-Verbose "Capitalization has been toggled off"
            $random_words = [string]$random_words
        }

        try{
            Write-Verbose "Adding the delimiter to each word, Currently at iteration number $_"
            . Add-Delimiter -Source $random_words -DelimiterParameter $Delimiter
            $Collection.Add($sanitized)
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
}