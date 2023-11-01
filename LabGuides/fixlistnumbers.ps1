[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateScript({
            if (-Not ($_ | Test-Path) ) {
                throw "File or folder does not exist"
            }
            if (-Not ($_ | Test-Path -PathType Leaf) ) {
                throw "The Path argument must be a file. Folder paths are not allowed."
            }
            if ($_ -notmatch "\.md$") {
                throw "The file specified in the path argument must be of type md"
            }
            return $true 
        })]
    [System.IO.FileInfo]    
    $MarkdownFile,
    [Parameter(Mandatory = $false)]
    [switch]
    $Overwrite
)

$ErrorActionPreference = 'Stop'

$lastNumber = 0

$markdown = Get-Content $MarkdownFile -Encoding utf8 | ForEach-Object {
    if ($_ -match '^\d+\.') {
        $lastNumber++
        $_ -replace '^\d+', $lastNumber
    }
    elseif ($_ -match '^#') {
        $lastNumber = 0
        $_
    }
    else {
        $_
    }
}

if ($Overwrite) {
    $MarkdownOutput = $MarkdownFile.FullName
}
else {
    $MarkdownOutput = $MarkdownFile.DirectoryName + '\' + $MarkdownFile.BaseName + '_fixed.md'
}

$markdown | Out-File -FilePath $MarkdownOutput -Encoding utf8
