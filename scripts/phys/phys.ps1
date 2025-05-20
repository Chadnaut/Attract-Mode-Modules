$version = "pHYs Metadata Utility v1.0.0 - Chadnaut 2025"

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
     - Generating Mame's listxml takes about 2 minutes (resulting in a 265MB file)
     - Generating the phys.txt list takes about 20 seconds
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
        - Usually you'll want to run options 1, 2, 3
        - TIP: Press "Tab" to complete paths, ie: "phys" + TAB
        - TIP: Press "Up" to enter the previous command

----------------------------------------------------------------------------------------
#>

# Call this script with arguments to override these default paths
$list_path = If ($args[0]) { $args[0] } else { "phys.txt" }
$xml_path = IF ($args[1]) { $args[1] } else { "C:\mame\mame.xml" }
$mame_path = (Split-Path -parent $xml_path) + "\mame.exe"

$ext = "png"
# $ext = "jpg"
$px_arg = ($ext -match "jpe?g") ? "XResolution" : "PixelsPerUnitX"
$py_arg = ($ext -match "jpe?g") ? "YResolution" : "PixelsPerUnitY"
$pu_arg = ($ext -match "jpe?g") ? "ResolutionUnit" : "PixelUnits"
$pu_val = ($ext -match "jpe?g") ? "None" : "meters"

# Display available options
Write-Host $version
Write-Host "Usage: .\phys.ps1 <list_path> <xml_path>"
Write-Host "- 1: Generate ""$xml_path"" from ""$mame_path"""
Write-Host "- 2: Generate ""$list_path"" from ""$xml_path"""
Write-Host "- 3: Add ""$list_path"" metadata to $($ext.ToUpper())s in current dir"
Write-Host "- 4: Add ""4:3 phys"" metadata to all $($ext.ToUpper())s in current dir"
Write-Host "- 5: Add ""3:4 phys"" metadata to all $($ext.ToUpper())s in current dir"
Write-Host "- 6: Remove phys metadata from all $($ext.ToUpper())s in current dir"
Write-Host "- 7: Display phys metadata from all $($ext.ToUpper())s in current dir"
$opt = Read-Host "Select an option [1-7]"

$start = Get-Date
$ppm = 2834 # 72 pixels/in ~ 1 pixels/pt ~ 2834 pixels/m, default found on many snaps

if ($opt -eq '1') {
    if (Test-Path $xml_path) {
        Write-Host """$xml_path"" already exists."
        exit
    }
    Write-Host "Generating ""$xml_path"", please wait..."
    Invoke-Expression "$mame_path -listxml > $xml_path"
}

if ($opt -eq '2') {
    # Confirm output overwrite
    if (Test-Path $list_path) {
        $confirm = Read-Host "Overwrite ""$($list_path)"" [y/n]"
        if ($confirm -ne 'y') { exit }
        Clear-Content -Path $list_path
    } else {
        New-Item $list_path -type file | Out-Null
    }
    $start = Get-Date
    
    # Write a section to the output file
    function Add-Machines {
        Param ( $section, $items )
        $names = New-Object -TypeName System.Text.StringBuilder
        foreach ($machine in $items) { $names.Append("$($machine.name)`n") | Out-Null }
        Add-Content -Path $list_path -Value "[$section]`n$($names.ToString())"
    }
    
    # Load the XML and find machines with raster screens
    Write-Host "Generating ""$list_path"", please wait..."
    $doc = [xml]''
    $doc.Load(( $xml_path | Resolve-Path ))
    $raster = $doc.mame.machine | Where-Object { $_.display.type -eq 'raster' }
    $machines = $raster | Where-Object { $_.display.tag -match '^((main|slave)pcb:)?[lmr]?screen\d?$' }
    
    # Add sections for each screen / multi-screen ratio
    Add-Machines "4:3" ($machines | Where-Object { $_.SelectNodes("./display").count -eq 1 -and ($_.display.rotate -eq 0 -or $_.display.rotate -eq 180) })
    Add-Machines "8:3" ($machines | Where-Object { $_.SelectNodes("./display").count -eq 2 })
    Add-Machines "12:3" ($machines | Where-Object { $_.SelectNodes("./display").count -eq 3 })
    Add-Machines "3:4" ($machines | Where-Object { $_.SelectNodes("./display").count -eq 1 -and ($_.display.rotate -eq 90 -or $_.display.rotate -eq 270) })
    Add-Machines "4:6" ($raster | Where-Object { $_.SelectNodes("./display").count -eq 2 -and ($_.display.tag -match '^(top|bottom)$' -or $_.name -match '^(hangpltu?|kbh|kbm(2nd|3rd)?)$') })
}

if ($opt -eq '3') {
    Write-Host "Adding ""$list_path"" metadata, please wait..."
    $batch = New-Object -TypeName System.Text.StringBuilder
    $command = ""
    $ratio = 0
    $section = $false
    
    # Get PNG listing to check each file exists
    $images = Get-ChildItem -Name -Filter "*.$ext"
    
    # Process the previously created listing
    Get-Content $list_path | ForEach-Object {
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
            $ppu = $($_ -replace "[\[\]]", "").Split(":")
            $ratio = $ppm * $ppu[0] / $ppu[1]
            $calc = "```${ImageHeight;```$_=```$_ / ```$self->GetValue('ImageWidth') * $ratio}"
            $command = "exiftool -ignoreMinorErrors -overwrite_original -preserve -$pu_arg=$pu_val -$px_arg=$ppm -$py_arg<""$calc"""
        } elseif ($ratio) {
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
}

if ($opt -eq '4') {
    Write-Host "Adding 4:3 phys metadata, please wait..."
    $ratio = $ppm * 4 / 3
    $calc = "`${ImageHeight;`$_=`$_ / `$self->GetValue('ImageWidth') * $ratio}"
    exiftool -ignoreMinorErrors -overwrite_original -preserve -$pu_arg=$pu_val -$px_arg=$ppm -$py_arg<"$calc" -ext $ext .
}

if ($opt -eq '5') {
    Write-Host "Adding 3:4 phys metadata, please wait..."
    $ratio = $ppm * 3 / 4
    $calc = "`${ImageHeight;`$_=`$_ / `$self->GetValue('ImageWidth') * $ratio}"
    exiftool -ignoreMinorErrors -overwrite_original -preserve -$pu_arg=$pu_val -$px_arg=$ppm -$py_arg<"$calc" -ext $ext .
}

if ($opt -eq '6') {
    Write-Host "Removing phys metadata, please wait..."
    exiftool -ignoreMinorErrors -overwrite_original -PNG-pHYs:*= -XResolution= -YResolution= -ext $ext .
}

if ($opt -eq '7') {
    Write-Host "Displaying phys metadata"
    exiftool -ignoreMinorErrors -$px_arg -$py_arg -ext $ext .
}

Write-Host "Completed in $((Get-Date) - $start)"
