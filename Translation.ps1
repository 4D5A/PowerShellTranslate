function New-TranslationTable {
    <#
        .Synopsis
            Returns a translation table
        .Description
            Returns a translation table that maps each character in the InputTable
            string into the character at the same position in the OutputTable string.
            Then this table is passed to Invoke-Translate.

        .Notes
            Both InputTable and OutputTable must have the same length.
        .Example
            $InputTable = "aeiou"
            $OutputTable = "12345"
            $TranslationTable = New-TranslationTable $InputTable $OutputTable

            $string = "this is string example....wow!!!";

            Invoke-Translate -TargetString $string -TranslationTable $TranslationTable

            th3s 3s str3ng 2x1mpl2....w4w!!!
    #>
    param(
        # This is the string having actual characters.
        [string]$InputTable,
        # This is the string having corresponding mapping character.
        [string]$OutputTable
    )

    $count = $InputTable.Length
    $h = @{}
    for($idx=0; $idx -lt $count; $idx+=1) {
        $h[$InputTable[$idx]]=$OutputTable[$idx]
    }
    return $h
}

function Invoke-Translate {
    <#
        .Synopsis
            Returns a string in which all characters have been translated using Translation Table
        .Description
            Returns a string in which all characters have been translated using Translation Table
            (constructed with the New-TranslationTable),
            optionally deleting all characters found in the string DeleteChars.
        .Example
            $InputTable = "aeiou"
            $OutputTable = "12345"
            $TranslationTable = New-TranslationTable $InputTable $OutputTable

            $string = "this is string example....wow!!!";

            Invoke-Translate -TargetString $string -TranslationTable $TranslationTable

            th3s 3s str3ng 2x1mpl2....w4w!!!
        .Example
            $InputTable = "aeiou"
            $OutputTable = "12345"
            $TranslationTable = New-TranslationTable $InputTable $OutputTable

            $string = "this is string example....wow!!!";

            Invoke-Translate -TargetString $string -TranslationTable $TranslationTable -DeleteChars 'xm'

            th3s 3s str3ng 21pl2....w4w!!!
    #>
    param(
        [string]$TargetString,
        # Use the New-TranslationTable create a translation table.
        [hashtable]$TranslationTable,
        # The list of characters to be removed from the source string.
        [string]$DeleteChars
    )

    if($DeleteChars) {
        $replace = $DeleteChars.ToCharArray() -join '|'
        $TargetString = $TargetString -replace $replace, ''
    }

    $count = $TargetString.Length
    $result = ""

    for($idx=0; $idx -lt $count; $idx+=1) {

        $char = $TargetString[$idx]
        $found = $TranslationTable[$char]

        if($found) {
            $result+=$found
        } else {
            $result+=$char
        }
    }

    $result
}

$InputTable = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
$OutputTable = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ+/"

$Direction = 0

# If you are going to encode the information using the default alphabet set $Direction to 0.
If($Direction -eq 0)
 {
$TranslationTable = New-TranslationTable $InputTable $InputTable
 }
 
# If you are going to encode the information using the custom alphabet set $Direction to 1.
If($Direction -eq 1)
 {
$TranslationTable = New-TranslationTable $InputTable $OutputTable
 }

# If you are going to decode the information using the custom alphabet set $Direction to 2.
If($Direction -eq 2)
 {
$TranslationTable = New-TranslationTable $OutputTable $InputTable
 }

$string = "this is string example....wow!!!";
$string = Invoke-Translate $string $TranslationTable
$string
