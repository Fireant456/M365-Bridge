param([string]$FilePath)

Clear-Host
Write-Host "====================================================" -ForegroundColor Cyan
Write-Host "         M365 BRIDGE APP CORE LOGIC DEBUGGER         " -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan

# 1. INITIAL PASS-THROUGH VALIDATION
if (-not $FilePath) {
    Write-Host "[FATAL] Script fired with a blank file path argument." -ForegroundColor Red
    Write-Host "Usage: .\OpenOnline.ps1 <PathToLocalOfficeFile>" -ForegroundColor Gray
    exit
}

Write-Host "[DEBUG] Argument received raw: $FilePath" -ForegroundColor Yellow

if (-not (Test-Path $FilePath)) {
    Write-Host "[FATAL] Path string targets an item that doesn't exist on disk." -ForegroundColor Red
    exit
}

# Resolve canonical paths
$AbsoluteFile = (Get-Item $FilePath).FullName
$Folder = Split-Path $AbsoluteFile -Parent
$FileName = Split-Path $AbsoluteFile -Leaf

Write-Host "[DEBUG] Absolute File Resolved : $AbsoluteFile" -ForegroundColor DarkGray
Write-Host "[DEBUG] Parent Target Folder   : $Folder" -ForegroundColor DarkGray
Write-Host "[DEBUG] File Name Component    : $FileName" -ForegroundColor DarkGray
Write-Host "----------------------------------------------------"

# =====================================================================
# STEP 1: NATIVE SHELL VERB INTEGRATION
# =====================================================================
Write-Host "Inspecting Windows File Explorer Shell Verbs..." -ForegroundColor Cyan
try {
    $Shell = New-Object -ComObject Shell.Application
    $ShellFolder = $Shell.NameSpace($Folder)
    $ShellFile = $ShellFolder.ParseName($FileName)

    if (-not $ShellFile) {
        Write-Host "  [WARN] Shell framework initialized but couldn't isolate file attributes." -ForegroundColor DarkYellow
    } else {
        $AllVerbs = $ShellFile.Verbs()
        Write-Host "  [INFO] Found ($($AllVerbs.Count)) actions bound to this file's context shell menu." -ForegroundColor Gray
        
        $NativeViewOnline = $AllVerbs | Where-Object { 
            $CleanedName = $_.Name -replace '&', ''
            $CleanedName -eq "View online" -or $CleanedName -eq "View Online"
        }

        if ($NativeViewOnline) {
            Write-Host "  [MATCH] Found native OneDrive context verb: '$($NativeViewOnline.Name)'" -ForegroundColor Green
            Write-Host "  [ACTION] Invoking .DoIt() native system callback loop..." -ForegroundColor Green
            
            $NativeViewOnline.DoIt()
            Write-Host "[SUCCESS] Shell execution handed off to Windows. Exiting." -ForegroundColor Green
            exit
        } else {
            Write-Host "  [INFO] 'View Online' action missing from context menu attributes." -ForegroundColor Gray
            Write-Host "  Listing all discovered file context verbs for reference:" -ForegroundColor DarkGray
            foreach ($v in $AllVerbs) { if ($v.Name) { Write-Host "    -> $($v.Name)" -ForegroundColor DarkGray } }
        }
    }
} catch {
    Write-Host "  [CRITICAL] Shell COM engine initialization encountered a wall: $_" -ForegroundColor Red
}

Write-Host "----------------------------------------------------"

# =====================================================================
# STEP 2: GENERALIZED SYSTEM WORKSPACE WARNING PROMPT
# =====================================================================
# If execution drops down to this block, the file is confirmed to be not synced.
Add-Type -AssemblyName System.Windows.Forms
$AlertMessage = "This file ($FileName) is not residing inside an active OneDrive or SharePoint synced folder.`n`n" +
                "To open this document in M365 Web, please move or copy it into your Personal or Company OneDrive folder " +
                "and wait for it to sync with the green check mark icon.`n`n" +
                "Alternatively, right-click the file, click 'Open with', and choose a desktop program to open it."

[System.Windows.Forms.MessageBox]::Show($AlertMessage, "File Sync Error - M365 Bridge", 0, 48)

Write-Host "Diagnostic trace finished."
