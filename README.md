# Get-RandomPassword
[![MIT License](https://img.shields.io/badge/license-mit-green.svg?style=flat-square)](https://opensource.org/licenses/MIT)

Generates random passwords using random common words

[Test your password here!](https://howsecureismypassword.net/)

Based on https://xkcd.com/936/ and https://xkpasswd.net/s/

English words provided by https://github.com/first20hours/google-10000-english

All the other words are provided by https://github.com/oprogramador/most-common-words-by-language (filtered by me)



## How to use it
Running `Get-Help Get-RandomPassword` will provide some details and examples, but here's a description of each parameter and what they do

Parameters | Type | Functionnality
-----------|------|---------------
Words | Integer | Number of words that the password will contain. The default is 3. Example: "car-HORSE-staple" is a 3 word password
Delimiter | Integer | Separator for the passwords. Default is a dash (-). Example: "car!HORSE!staple" the delimiter here would be the exclamation point (!)
Count | Integer | Number of passwords you want generated. Default is 3.
Short | Switch | Generates a password containing short words (1-4 characters long).
Medium | Switch | Generates a password containing medium words (5-8 characters long) (default if no length is specified)
Long | Switch | Generates a password containing long words (9+ characters long)
NoCapitalization | Switch | Specifies that all words will be in lowercase
DoNotCopyToClipboard | Switch | Will not copy a random password to your clipboard
Language | String | Generates passwords using common words of your language of choice. Please note that these words have not been filtered and may not be appropriate (the only exception to this is the english language)
ShowLanguages | Switch | Displays a list of available languages

**Please note that only one word length can be specified**

### Installation

[Now available on the PSGallery!](https://www.powershellgallery.com/packages/Get-RandomPassword/1.1.1)

```powershell
PS > Install-Module -Name Get-RandomPassword
PS > Import-Module Get-RandomPassword
```

## Examples

```powershell
# This example generates 3 passwords containing 3 words each
Get-RandomPassword
forward-genuine-extract
floral-piece-RELEASED
diseases-metadata-EBOOKS
A random password has been copied to your clipboard!
```

```powershell
# This example generates 3 passwords with 5 words per password.
# The Sun would die before a computer could crack these passwords
# It uses the default delimiter "-" (a dash) and a medium dictionnary (5-8 characters long)
Get-RandomPassword -Word 5
ROMANCE-restore-RENEWAL-payday-example
TEXAS-VISIT-speeches-POSTINGS-CHANNELS
DERIVED-invalid-korean-skype-union
A random password has been copied to your clipboard!
```

```powershell
# This example generates 5 passwords containing 4 words each with the asterisk delimiter
# The -Long switch was specified, therefore it used words that are over 9 characters long
Get-RandomPassword -Word 4 -Count 5 -Delimiter * -Long
DISTRIBUTED*LOCATIONS*PHENTERMINE*DISTINGUISHED
CONTAINERS*ECOMMERCE*selecting*bandwidth
microphone*RECEIVING*underground*bookstore
commissioner*sufficient*INDONESIA*RESPONDENTS
amendment*COMMUNITY*UNSUBSCRIBE*helicopter
A random password has been copied to your clipboard!
```

```powershell
# This example generates 4 passwords with 5 words each
# The -Short switch was specified, therefore it uses words that are in between 1 and 4 characters long
Get-RandomPassword -word 5 -count 4 -short
zinc-MAC-ho-slip-bids
DVDS-lost-AV-BUSY-nbc
aims-ugly-PDAS-AUG-BIN
LONE-F-TIL-pty-EZ
A random password has been copied to your clipboard!
```

```powershell
# This example generates 3 passwords containing 3 french words
# The -Long switch was specified, therefore it uses words that are 9 characters long or higher
# The -DoNotCopyToClipboard was specified, therefore it wasn't copied to the clipboard
# The -NoCapitalization switch was specified, therefore no capitalization was added
Get-RandomPassword.ps1 -Language French -Long -DoNotCopyToClipboard -NoCapitalization   
recommande-prochains-publicités
remplacés-d'exportation-extérieur
résolument-président-réductions
```

```powershell
# This example generates 4 passwords containing 5 long italian words (9+ characters long)
# It utilizes the alias of Get-RandomPassword, "gr"
# It also doesn't copy a random password to your clipboard
gr -Language Italian -words 5 -long -count 4 -DoNotCopyToClipboard
CURRICULUM-PSICOLOGIA-orfanotrofio-grandiosa-TERRIBILE
cioccolato-coinvolto-RIPRENDENDO-stupidaggine-abbandonati
COLONNELLO-ESECUZIONE-scommesso-mezzogiorno-meraviglia
prenderlo-indovinate-trascorso-ELICOTTERO-INCONTRATO
```
