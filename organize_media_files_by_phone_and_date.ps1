<#
.SYNOPSIS
  File separation of 

.DESCRIPTION
  Following script will loop through the destination directory and move each file to respective folder created with the date of the file LastWriteTime.
  Also it does a separation based on the Camera maker (phone name on which the image/video was taken)

.PARAMETER <Parameter_Name>
    <Brief description of parameter input required. Repeat this attribute if required>

.INPUTS
  D:/path/to/test-folder
                    ./IMG_20200101_1121.jpg         01-01-2021          Xiaomi
                    ./IMG_20200101_1124.jpg         01-01-2021          HUAWEI
                    ./PANO_20200102_1126.jpg        02-01-2021          Xiaomi
                    ./VID_20200102_1210.mp4         02-01-2021          HUAWEI
                    ./SVID_20200102_1200.mp4        02-01-2021          HUAWEI

.OUTPUTS
  D:/path/to/test-folder/Xiaomi/2021-01-01/
                            ./IMG_20200101_1121.jpg
  D:/path/to/test-folder/HUAWEI/2021-01-01/
                            ./IMG_20200101_1124.jpg
  D:/path/to/test-folder/HUAWEI/2021-01-02/
                            ./vid/VID_20200102_1210.mp4 
                            ./vid/SVID_20200102_1200.mp4
  D:/path/to/test-folder/Xiaomi/2021-01-02/
                            ./PANO_20200102_1126.jpg

.NOTES
  Version:        1.0
  Author:         Abid Khan
  Creation Date:  02-01-2021
  Purpose/Change: File separation datewise.
  
.EXAMPLE
  D:/path/to/script/organize_media_files_by_phone_and_date.ps1 D:/path/to/test-folder

.TODO
  Add file type(extension) based separation.
  Get-FileMetaData slows down the executions.
#>


$start_time = Get-Date -Format "dddd MM/dd/yyyy HH:mm K"

# Destination/Source folder as first argument
$dest = $args[0]
#$dateFormat = "%d-%m-%Y"
$dateFormat = "%Y-%m-%d"


function moveTo([string]$src, [string]$dest) {
    
    # echo "Source : $src"
    # echo "Destination : $dest"
    
    if (!(Test-Path -Path "$dest")){
        # Create the $date folder
        new-item -ErrorAction Ignore -type Directory -path "$dest"
    }

    try{
        # Move the file into date folder
        move-item "$src" "$dest"
    }
    catch{
        Write-Host "An error occurred:"
        Write-Host $_.ScriptStackTrace
    }
}

function moveFiles(){
    get-childitem -Path "$dest" -recurse | % {
        
        # Get file name
        $file = $_.FullName
        
        # Get last write time of the file
        # $date = Get-Date ($_.LastWriteTime) -UFormat $dateFormat
        
        # echo $_.Name
        
        if ( $_.Name -match '(?:PANO|IMG)_(\d{4})(\d{2})(\d{2})_.*.jpg' ) {
        
            $date=$matches[1] + "-" + $matches[2] + "-" + $matches[3]
            
            # Get the name of the phone from which the photo was taken
            $phone = (Get-FileMetaData -File $file)."Camera maker"
            # echo $phone

            if ($phone -eq 'Xiaomi'){
                moveTo "$file" "$dest\$phone\$date"
            }
            else{
                moveTo "$file" "$dest\$date"
            }

        }
        elseif ( $_.Name -match '.VID_(\d{4})(\d{2})(\d{2})_.*.mp4' ) {
        
            $date=$matches[1] + "-" + $matches[2] + "-" + $matches[3]
            
            moveTo "$file" "$dest\$date\vid"
        }
    }
}

# Call the method
moveFiles

$end_time = Get-Date -Format "dddd MM/dd/yyyy HH:mm K"

Write-Host Start time : $start_time
Write-Host End time : $end_time
