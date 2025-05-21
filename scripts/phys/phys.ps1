<#
----------------------------------------------------------------------------------------

Powershell script to add "physical pixel" (pHYs) metadata to PNG images.
- Intended for Mame screenshots used in AttractMode Plus 3.1.1
- The hard work is performed using ExifTool by Phil Harvey

----------------------------------------------------------------------------------------

# FAQ

- Q: Why do I need this?
- A: To display PNG images at their correct aspect-ratio

- Q: What's wrong with PNG's aspect-ratio?
- A: Images displayed on CRT monitors are stretched to fill a 4:3 (or 3:4) screen
     This means their pixel-aspect-ratio (PAR) is not 1.0 like a modern LED monitor
     Since PNG's do not typically store PAR, these images are displayed squished on modern screens
     Examples:
     - http://adb.arcadeitalia.net/dettaglio_mame.php?game_name=ddp3
     - http://adb.arcadeitalia.net/dettaglio_mame.php?game_name=willow
     - http://adb.arcadeitalia.net/dettaglio_mame.php?game_name=1944

- Q: What does this script do?
- A: First it scans Mame's listxml to make a list of raster displays
     Then it uses ExifTool to add the appropriate pHYs metadata to your PNG files
     Apps that read this metadata can display the image at the correct ratio

- Q: After using this my PNG's still display squished in my image-viewer?
- A: Many viewers and editors display images at their native resolution
     You can use GIMP to view a PNG with its pHYs metadata applied:
     - View > Dot for Dot (un-tick)
     - Zoom-in to see non-square pixels!
     PNG thumbnails should also appear at the correct ratio in Windows Explorer

- Q: How can I view my PNG's current pHYs metadata?
- A: Run this script and select "Display phys metadata"
     Or open the PNG in GIMP:
     - Image > Metadata > View Metadata (see Exif: PixelsPerUnitX & PixelsPerUnitY)

- Q: Will this break my PNG's?
- A: This script only makes changes to your PNG's metadata, it will not change the file in any other way
     PNG's should not be open in apps that place a lock on them (AM+), so the metadata can be written
     I have not encountered any issues, but you should always keep a backup just in case

- Q: The script is not responding, or has frozen?
- A: Your computer is probably just "thinking"
     - Generating Mame's listxml takes about 5 seconds (resulting in a 265MB file)
     - Generating the phys.txt list takes about 15 seconds
     - Adding pHYs metadata to 17,500 raster snaps takes about 7.5 minutes

- Q: Why is it so slow?
- A: ExifTool updates a single image in about 26ms, which is pretty quick
     - 26ms * 17,500 images = 455,000ms = 7.5 minutes

- Q: Why are there only 17,500 entries in the pHYs.txt list?
- A: Not all Mame machines use CRT raster displays - some are LCD, Vector, or even SVG

- Q: Why does the number of files updated change each time?
- A: ExifTool works fastest when updating files in batches
     However a command line has a limit of 32k characters
     So the script runs a batch when the line is full

- Q: Should I trust random scripts I find on the internet?
- A: Absolutely not. Always read them first and make sure you understand what it's doing.

----------------------------------------------------------------------------------------

# Instructions

## Mame
    - Download Mame from https://www.mamedev.org/release.html
    - Extract to: C:\mame

## Snaps
    - Download Snaps from https://www.progettosnaps.net/snapshots/
    - Extract to: C:\mame\snap

## ExifTool
    - Download ExifTool from https://exiftool.org/
    - Extract to: C:\Program Files (x86)\exiftool
    - Rename: exiftool(-k).exe --> exiftool.exe
    - Start > Edit the system environment variables > Environment Variables
        - System variables > Path > Edit...
        - New > C:\Program Files (x86)\exiftool
        - Ok, Ok, Ok
        - NOTE: VSCode requires a *complete* restart to find new env vars
    - Start > Windows Powershell
        exiftool -ver
        - It will display version 13.29 or above, this means it's working

## PHYS script (this file)
    - https://stackoverflow.com/questions/64511176/security-risks-of-set-executionpolicy-executionpolicy-remotesigned
    - Copy phys.ps1 to C:\mame\snap
    - Start > Windows Powershell
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
        cd C:\mame\snap
        .\phys.ps1
    - Follow the onscreen instructions
        - Usually you'll want to follow the examples in order to generate xml, meta, then add metadata
        - TIP: Press "Tab" to complete paths, ie: "phys" + TAB
        - TIP: Press "Up" to enter the previous command
        
----------------------------------------------------------------------------------------
#>

param (
    [string]$mame = "",
    [string]$xml = "",
    [string]$meta = "",
    [string]$ext = "png",
    [string]$ratio = "",
    [switch]$add = $false,
    [switch]$remove = $false,
    [switch]$show = $false,
    [switch]$overwrite = $false
)

if (!$add -and !$remove -and !$show -and !$overwrite -and !$mame -and !$xml -and !$meta) {
    Write-Host "pHYs Metadata Utility v1.1.0 - Chadnaut 2025"
    Write-Host "Usage: .\phys.ps1 -option <value> -switch"
    Write-Host "  -mame <path>       Path to ""mame.exe"", use with -xml to generate ""list.xml"""
    Write-Host "  -xml <path>        Path to ""list.xml"", use with -meta to generate ""meta.txt"""
    Write-Host "  -meta <path>       Path to ""meta.txt"", use with -add to apply metadata"
    Write-Host "  -ext <extension>   Image extension to update, defaults to ""png"""
    Write-Host "  -ratio <x:y>       Ratio to manually apply to images"
    Write-Host "  -add               Add pHYx metadata to images, use with -meta or -ratio"
    Write-Host "  -remove            Remove pHYx metadata from all images"
    Write-Host "  -show              Show pHYx metadata from all images"
    Write-Host "  -overwrite         Overwrite generated files"
    Write-Host "Examples:"
    Write-Host "  .\phys.ps1 -mame C:\mame\mame.exe -xml C:\mame\list.xml       # Create list xml from mame"
    Write-Host "  .\phys.ps1 -xml C:\mame\list.xml -meta C:\mame\snap\meta.txt  # Create meta file from list xml"
    Write-Host "  .\phys.ps1 -add -meta C:\mame\snap\meta.txt                   # Add meta metadata to matching images"
    Write-Host "  .\phys.ps1 -add -ratio 4:3                                    # Add 4:3 ratio metadata to images"
}

# Validate input paths
if ($mame -and !(Test-Path $mame)) { Write-Host "Cannot find -mame ""$mame"""; exit }
if ($mame -and $xml -and (Test-Path $xml) -and !$overwrite) { Write-Host """$xml"" already exists, use -overwrite"; exit }
if ($xml -and !(Test-Path (Split-Path -parent $xml))) { Write-Host "Invalid -xml dir ""$xml"""; exit }
if ($xml -and $meta -and !(Test-Path $xml)) { Write-Host "Cannot find -xml ""$xml"""; exit }
if ($xml -and $meta -and (Test-Path $meta) -and !$overwrite) { Write-Host """$meta"" already exists, use -overwrite"; exit }
if ($meta -and !(Test-Path (Split-Path -parent $meta))) { Write-Host "Invalid -meta dir ""$meta"""; exit }
if ($add -and $meta -and !$ratio -and !(Test-Path $meta)) { Write-Host "Cannot find -meta ""$meta"""; exit }
if ($add -and !$meta -and !$ratio) { Write-Host "Nothing to add, use -meta or -ratio"; exit }

$is_jpg = $ext -match "^jpe?g$"
$px_arg = $is_jpg ? "XResolution" : "PixelsPerUnitX"
$py_arg = $is_jpg ? "YResolution" : "PixelsPerUnitY"
$pu_val = $is_jpg ? "ResolutionUnit=None" : "PixelUnits=meters"

function Start-Timer {
    $global:timer = Get-Date
}

function Write-Timer {
    Write-Host "Completed in $((Get-Date) - $global:timer)"
    $global:timer = Get-Date
}

function Write-Machines {
    Param ( $filename, $section, $machines )
    $names = New-Object -TypeName System.Text.StringBuilder
    foreach ($machine in $machines) { $names.Append("$($machine.name)`n") | Out-Null }
    Add-Content -Path $filename -Value "[$section]`n$($names.ToString())"
}

function Get-Ratio {
    Param ( [string]$ratio_val )
    $m = $ratio_val | Select-String -Pattern '^\[?(\d+):(\d+)\]?$' 
    if (!$m) { throw "Invalid ratio ""$ratio_val""" }
    Return New-Object PsObject -Property @{x=[int]$m.Matches.Groups[1].ToString(); y=[int]$m.Matches.Groups[2].ToString()}
}

function Get-Command {
    Param ( [string]$ratio_val )
    $r = Get-Ratio $ratio_val
    $cx = "```${ImageWidth;```$_=```$_*$($r.y)}"
    $cy = "```${ImageHeight;```$_=```$_*$($r.x)}"
    Return "exiftool -ignoreMinorErrors -overwrite_original -preserve -$pu_val -$px_arg<""$cx"" -$py_arg<""$cy"""
}

Start-Timer

if ($mame -and $xml) {
    Write-Host "Generating ""$xml"", please wait..."
    Invoke-Expression "$mame -listxml > $xml"
    Write-Timer
}

if ($xml -and $meta) {
    if ((Test-Path $meta) -and $overwrite) {
        Clear-Content -Path $meta
    } else {
        New-Item $meta -type file | Out-Null
    }
    
    # Load the XML and find machines with raster screens
    Write-Host "Generating ""$meta"", please wait..."
    $doc = [xml]''
    $doc.Load(( $xml | Resolve-Path ))
    $raster = $doc.mame.machine | Where-Object { $_.display.type -eq 'raster' }
    $machines = $raster | Where-Object { $_.display.tag -match '^((main|slave)pcb:)?[lmr]?screen\.?\d?$' }
    
    # Add sections for each screen / multi-screen ratio
    Write-Machines $meta "4:3" ($machines | Where-Object { $_.SelectNodes("./display").count -eq 1 -and ($_.display.rotate -eq 0 -or $_.display.rotate -eq 180) })
    Write-Machines $meta "8:3" ($machines | Where-Object { $_.SelectNodes("./display").count -eq 2 })
    Write-Machines $meta "12:3" ($machines | Where-Object { $_.SelectNodes("./display").count -eq 3 })
    Write-Machines $meta "3:4" ($machines | Where-Object { $_.SelectNodes("./display").count -eq 1 -and ($_.display.rotate -eq 90 -or $_.display.rotate -eq 270) })
    Write-Machines $meta "4:6" ($raster | Where-Object { $_.SelectNodes("./display").count -eq 2 -and ($_.display.tag -match '^(top|bottom)$' -or $_.name -match '^(hangpltu?|kbh|kbm(2nd|3rd)?)$') })
    Write-Timer
}

if ($remove) {
    Write-Host "Removing phys metadata from all $($ext.ToUpper())s, please wait..."
    exiftool -ignoreMinorErrors -overwrite_original -PNG-pHYs:*= -XResolution= -YResolution= -ext $ext .
    Write-Timer
}

if ($add -and $meta -and !$ratio) {
    Write-Host "Adding ""$meta"" metadata to matching $($ext.ToUpper())s, please wait..."
    $batch = New-Object -TypeName System.Text.StringBuilder
    $command = ""
    $section = $false
    
    # Get image listing for future checks
    $images = Get-ChildItem -Name -Filter "*.$ext"
    
    # Process the previously created listing
    Get-Content $meta | ForEach-Object {
        if (!($_)) { return }
        $section = $_.StartsWith("[")
        
        # Run the current batch if the limit has been reached
        if ($command -and (($section -and $batch.Length) -or $batch.Length -gt 30000)) {
            Invoke-Expression "$($command)$($batch.ToString())"
            $batch = New-Object -TypeName System.Text.StringBuilder
        }
        
        if ($section) {
            # Prepare a new command for the next batch
            Write-Host "Applying $($_) metadata..."
            $command = Get-Command $_
        } elseif ($command.Length) {
            # Add filename to the batch
            $filename = "$($_).$($ext)"
            if ($images -contains $filename) {
                $batch.Append(" ""$filename""") | Out-Null
            }
        }
    }
    
    # Run the final batch
    if ($command -and $batch.Length) { 
        Invoke-Expression "$($command)$($batch.ToString())"
    }
    Write-Timer
}

if ($add -and $ratio) {
    Write-Host "Adding ""$ratio"" phys metadata to all $($ext.ToUpper())s, please wait..."
    $command = Get-Command $ratio
    Invoke-Expression "$($command) -ext $ext ."
    Write-Timer
}

if ($show) {
    Write-Host "Showing phys metadata from $($ext.ToUpper())s"
    exiftool -ignoreMinorErrors -$px_arg -$py_arg -ext $ext .
    Write-Timer
}
