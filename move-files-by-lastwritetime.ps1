<#
.SYNOPSIS
  File separation of 

.DESCRIPTION
  Following script will loop through the destination directory and move each file to respective folder created with the date of the file LastWriteTime.

.PARAMETER <Parameter_Name>
    <Brief description of parameter input required. Repeat this attribute if required>

.INPUTS
  D:/path/to/test-folder
                    ./file1.txt         01-01-2021
                    ./file2.txt         01-01-2021
                    ./other-file.png    02-01-2021

.OUTPUTS
  D:/path/to/test-folder/2021-01-01/
                            ./file1.txt
                            ./file2.txt
  D:/path/to/test-folder/2021-01-02/
                            ./other-file.png

.NOTES
  Version:        1.0
  Author:         Abid Khan
  Creation Date:  02-01-2021
  Purpose/Change: File separation datewise.
  
.EXAMPLE
  D:/path/to/script/move-files-by-lastwritetime.ps1 D:/path/to/test-folder

.TODO
  Add file type(extension) based separation.
#>


# Destination/Source folder as first argument
$dest = $args[0]
#$dateFormat = "%d-%m-%Y"
$dateFormat = "%Y-%m-%d"

function moveFiles(){
    get-childitem -Path "$dest" -recurse | % {
        
        # Get file name
        $file = $_.FullName
        
        # Get last write time of the file
        $date = Get-Date ($_.LastWriteTime) -UFormat $dateFormat
        
        if (!(Test-Path -Path "$dest\$date")){
            # Create the $date folder
            new-item -ErrorAction Ignore -type Directory -path "$dest\$date"
        }
        
        # Move the file into date folder
        move-item $file "$dest\$date"

    }
}

# Call the method
moveFiles
