function Write-BranchName () {
    try {
        $branch = git rev-parse --abbrev-ref HEAD

        if ($branch -eq "HEAD") {
            # we're probably in detached HEAD state, so print the SHA
            $branch = git rev-parse --short HEAD
            Write-Host " ($branch)" -ForegroundColor "red"
        }
        else {
            # we're on an actual branch, so print it
            Write-Host " ($branch)" -ForegroundColor "blue"
        }
    } catch {
        # we'll end up here if we're in a newly initiated git repo
        Write-Host " (no branches yet)" -ForegroundColor "yellow"
    }
}
function prompt {
    $base = "PS "
    $path = "$($executionContext.SessionState.Path.CurrentLocation)"
    $userPrompt = "$('>' * ($nestedPromptLevel + 1)) "

    Write-Host "`n$base" -NoNewline

    if (Test-Path .git) {
        Write-Host $path -NoNewline -ForegroundColor "green"
        Write-BranchName
    }
    else {
        # we're not in a repo so don't bother displaying branch name/sha
        Write-Host $path -ForegroundColor "green"
    }

    return $userPrompt
}
Set-Alias -Name vim -Value nvim
# Check if the 'sls' alias exists before trying to remove it
if (Test-Path Alias:\sls) {
    Remove-Item Alias:\sls
}

# Check if the 'rm' alias exists before trying to remove it
if (Test-Path Alias:\rm) {
    Remove-Item Alias:\rm
}
# Check if the 'find' alias exists before trying to remove it
if (Test-Path Alias:\find) {
    Remove-Item Alias:\find
}
Set-Alias lvim 'C:\Users\Bhavesh\.local\bin\lvim.ps1'
function htdocs{
	cd "C:\xampp\htdocs"
}
function hyst{
	cd "C:\xampp\htdocs\hyst-backend"
}
function hpm{
	cd "C:\xampp\htdocs\pm2-backend"
}
function cre{
	cd "F:\credentials"
}
function algo{
	cd "F:\algo"
}
function find {
    & "C:\Program Files (x86)\GnuWin32\bin\find.exe" @args
}
Invoke-Expression (& { (zoxide init powershell | Out-String) })
Import-Module 'gsudoModule'
# Bash-like completion with an interactive menu
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Import-Module posh-git

# get command line history
function hh {
    # Get the history file path
    $historyPath = (Get-PSReadLineOption).HistorySavePath

    # Read the content, sort by last access time in descending order, get unique entries, and use fzf for selection
    $sortedHistory = Get-Content -Path $historyPath | Sort-Object -Property { $_ } -Descending | Sort-Object -Unique

    # Use fzf for fuzzy finding and set the selected command to the clipboard
    $selectedCommand = $sortedHistory | fzf | Set-Clipboard

    # Add required assembly for SendKeys
    Add-Type -AssemblyName System.Windows.Forms

    # Paste the selected command
    [System.Windows.Forms.SendKeys]::SendWait("^{v}")
}

#get same directory open while typing newt
function get_current_directory_in_windows_terminal {wt -w 0 nt -d .}
if (!(Get-Alias -Name newt -ErrorAction SilentlyContinue)) {
	New-Alias newt get_current_directory_in_windows_terminal
}

function rgi {
    do {
        $searchString = Read-Host "Enter the search string"
        if (-not $searchString) {
            Write-Output "Search string cannot be empty. Please enter a valid search string."
        }
    } while (-not $searchString)

    do {
        $specifyfile = Read-Host "Specify the file pattern"
        if (-not $specifyfile) {
            Write-Output "File pattern cannot be empty. Please enter a valid file pattern."
        }
    } while (-not $specifyfile)
    
    rg -i $searchString --glob "$specifyfile*"
}

function fcd {
    # Get all directories recursively, excluding hidden ones and those starting with '.'
    $maxdepth=4
    $dirs = Get-ChildItem -Directory -Recurse -Depth $maxdepth -ErrorAction SilentlyContinue | 
            Where-Object { 
                -not ($_.Attributes -band [IO.FileAttributes]::Hidden) -and 
                -not ($_.Name.StartsWith('.')) 
            } | 
            Select-Object -ExpandProperty FullName

    # Check if any directories were found
    if ($dirs.Count -eq 0) {
        Write-Host "No directories found."
        return
    }

    # Use fzf to select a directory
    $selectedDir = $dirs | fzf --height 40% --reverse --inline-info

    if ($selectedDir) {
        Set-Location $selectedDir
    }
}
