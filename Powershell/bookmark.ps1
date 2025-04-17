param (
    [string]$Action = "list",
    [string]$Name,
    [string]$Link
)

$BookmarkFile = "$HOME\.bookmarks.txt"

# Ensure file exists
if (-not (Test-Path $BookmarkFile)) {
    New-Item -ItemType File -Path $BookmarkFile -Force | Out-Null
}

switch ($Action.ToLower()) {
    "add" {
        if (-not $Name -or -not $Link) {
            Write-Host "Usage: .\bookmark.ps1 add <Name> <Link>" -ForegroundColor Red
            break
        }
        "$Name - $Link" | Out-File -FilePath $BookmarkFile -Append
        Write-Host "Bookmark added: $Name -> $Link"
    }

    "list" {
        Get-Content $BookmarkFile
    }

    "open" {
        $selection = Get-Content $BookmarkFile | fzf
        if ($selection) {
            $parts = $selection -split '\s*-\s*', 2
            $link = $parts[1]

            if ($link -match '^https?://') {
                Start-Process $link  # open in default browser
            } elseif (Test-Path $link) {
                Start-Process $link  # open file/folder
            } else {
                Write-Host "Invalid path or URL: $link" -ForegroundColor Red
            }
        }
    }
	"edit" {
    	Start-Process nvim $BookmarkFile
	}

    default {
        Write-Host "Unknown action: $Action"
        Write-Host "Usage:"
        Write-Host "  .\bookmark.ps1 add <Name> <Link>"
        Write-Host "  .\bookmark.ps1 list"
        Write-Host "  .\bookmark.ps1 open"
        Write-Host "  .\bookmark.ps1 edit"
    }
}

# note in the $profile add teh following line
# function bm {
#    & "C:\Users\bhavesh.verma\bookmark.ps1" @args
# }
