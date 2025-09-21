<#
.SYNOPSIS
    Compare two Git branches using WinMerge by creating temporary git worktrees,
    launching a folder diff, and optionally cleaning everything up automatically.

.EXAMPLE
    .\Compare-GitBranches-With-WinMerge.ps1 -RepoPath . -Left main -Right feature/api -AutoClean

.EXAMPLE
    .\Compare-GitBranches-With-WinMerge.ps1 -RepoPath C:\dev\myrepo -Left main -Right origin/feature/foo

.PARAMETER RepoPath
    Path to the Git repository (default: current directory).

.PARAMETER Left
    The left branch/revision (e.g., main, release/1.2, origin/feature/foo).

.PARAMETER Right
    The right branch/revision.

.PARAMETER AutoClean
    If set, the script will remove/prune worktrees and delete temp folders automatically after WinMerge closes.

.PARAMETER WinMergePath
    Optional full path to WinMergeU.exe if not on PATH or in the default install locations.

.PARAMETER ExtraWinMergeArgs
    Optional additional args passed to WinMerge (e.g., '/f FilterName' or '/cfg SomeKey=Value').

.NOTES
    Requires: Git 2.5+ and WinMerge (WinMergeU.exe).
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$RepoPath = ".",

    [Parameter(Mandatory = $true)]
    [string]$Left,

    [Parameter(Mandatory = $true)]
    [string]$Right,

    [switch]$AutoClean,

    [string]$WinMergePath,

    [string]$ExtraWinMergeArgs
)

$ErrorActionPreference = 'Stop'

function Assert-GitAvailable {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        throw "Git is not installed or not on PATH. Install Git and try again."
    }
}

function Assert-InRepo([string]$repo) {
    $inside = git -C "$repo" rev-parse --is-inside-work-tree 2>$null
    if ($LASTEXITCODE -ne 0 -or $inside -ne 'true') {
        throw "Path '$repo' does not appear to be inside a Git repository."
    }
}

function Resolve-Commitish([string]$repo, [string]$rev) {
    # Verify that the rev resolves to a commit (supports local or remote refs)
    git -C "$repo" rev-parse --verify --quiet "$rev^{commit}" | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "Revision/branch '$rev' not found. Make sure it exists (fetch if needed)."
    }
}

function Sanitize-Name([string]$name) {
    # Replace path-invalid characters
    return ($name -replace '[:\\/*?"<>|]', '-')
}

function Get-RepoName([string]$repo) {
    $top = (git -C "$repo" rev-parse --show-toplevel).Trim()
    Split-Path $top -Leaf
}

function New-Worktree([string]$repo, [string]$targetPath, [string]$rev) {
    Write-Host "Adding worktree: $targetPath -> $rev"
    git -C "$repo" worktree add "$targetPath" "$rev" | Out-Null
}

function Remove-Worktree([string]$repo, [string]$targetPath) {
    if (Test-Path $targetPath) {
        Write-Host "Removing worktree registration: $targetPath"
        git -C "$repo" worktree remove --force "$targetPath" | Out-Null
    }
}

function Prune-Worktrees([string]$repo) {
    Write-Host "Pruning stale worktrees..."
    git -C "$repo" worktree prune | Out-Null
}

function Delete-Folder([string]$path) {
    if (Test-Path $path) {
        Write-Host "Deleting folder: $path"
        Remove-Item -LiteralPath $path -Recurse -Force -ErrorAction SilentlyContinue
    }
}

function Find-WinMerge([string]$hint) {
    if ($hint -and (Test-Path $hint)) { return (Resolve-Path $hint).Path }

    $candidates = @(
        (Get-Command WinMergeU.exe -ErrorAction SilentlyContinue)?.Source,
        Join-Path $env:ProgramFiles 'WinMerge\WinMergeU.exe',
        Join-Path ${env:ProgramFiles(x86)} 'WinMerge\WinMergeU.exe'
    ) | Where-Object { $_ -and (Test-Path $_) } | Select-Object -Unique

    if ($candidates.Count -gt 0) { return $candidates[0] }

    throw "WinMergeU.exe not found. Install WinMerge or pass -WinMergePath 'C:\Path\To\WinMergeU.exe'."
}

# ---- Main ----
try {
    Assert-GitAvailable
    $RepoPath = (Resolve-Path $RepoPath).Path
    Assert-InRepo $RepoPath

    # Ensure both revs exist
    Resolve-Commitish $RepoPath $Left
    Resolve-Commitish $RepoPath $Right

    $repoName = Get-RepoName $RepoPath
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $root = Join-Path $env:TEMP ("git-worktree-compare\{0}\{1}" -f $repoName, $stamp)

    $leftName = Sanitize-Name $Left
    $rightName = Sanitize-Name $Right

    $leftPath = Join-Path $root ("left-{0}" -f $leftName)
    $rightPath = Join-Path $root ("right-{0}" -f $rightName)

    New-Item -ItemType Directory -Path $leftPath  -Force | Out-Null
    New-Item -ItemType Directory -Path $rightPath -Force | Out-Null

    # Create the worktrees
    New-Worktree $RepoPath $leftPath  $Left
    New-Worktree $RepoPath $rightPath $Right

    # Locate WinMerge
    $winMergeExe = Find-WinMerge $WinMergePath

    Write-Host ""
    Write-Host "Launching WinMerge folder compare..."
    Write-Host "Left  : $leftPath   ( $Left )"
    Write-Host "Right : $rightPath  ( $Right )"
    Write-Host ""

    # Default arguments:
    #  /e  : single instance
    #  /u  : don't update MRU
    #  /r  : recurse subfolders
    #  /dl : label for left
    #  /dr : label for right
    $args = @('/e', '/u', '/r', '/dl', "Left: $Left", '/dr', "Right: $Right", $leftPath, $rightPath)

    if ($ExtraWinMergeArgs) {
        # Split extra args like a typical command line (simple split by space; quote paths yourself if needed)
        $args += ($ExtraWinMergeArgs -split ' ')
    }

    $proc = Start-Process -FilePath $winMergeExe -ArgumentList $args -PassThru
    Wait-Process -Id $proc.Id

    Write-Host "`nWinMerge closed."

}
catch {
    Write-Error $_
}
finally {
    # Cleanup flow
    try {
        if ($AutoClean) {
            Write-Host "AutoClean enabled."
            Remove-Worktree $RepoPath $leftPath
            Remove-Worktree $RepoPath $rightPath
            Prune-Worktrees $RepoPath
            Delete-Folder $root
            Write-Host "Cleanup complete."
        }
        else {
            Write-Host ""
            $response = Read-Host "Clean up worktrees and delete temp folders now? (y/N)"
            if ($response -match '^(y|yes)$') {
                Remove-Worktree $RepoPath $leftPath
                Remove-Worktree $RepoPath $rightPath
                Prune-Worktrees $RepoPath
                Delete-Folder $root
                Write-Host "Cleanup complete."
            }
            else {
                Write-Host "Left on disk:"
                Write-Host "  $leftPath"
                Write-Host "  $rightPath"
                Write-Host "You can clean up later with:"
                Write-Host "  git -C `"$RepoPath`" worktree remove --force `"$leftPath`""
                Write-Host "  git -C `"$RepoPath`" worktree remove --force `"$rightPath`""
                Write-Host "  git -C `"$RepoPath`" worktree prune"
                Write-Host "  Remove-Item -Recurse -Force `"$root`""
            }
        }
    }
    catch {
        Write-Error "Cleanup encountered an issue: $_"
        Write-Host "You can manually clean:"
        Write-Host "  git -C `"$RepoPath`" worktree remove --force `"$leftPath`""
        Write-Host "  git -C `"$RepoPath`" worktree remove --force `"$rightPath`""
        Write-Host "  git -C `"$RepoPath`" worktree prune"
        Write-Host "  Remove-Item -Recurse -Force `"$root`""
    }
}
