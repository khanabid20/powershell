<#
Author     : Abid Khan
Date       : 02-01-2021
Desciption : To move files to their date folder.
             The date folder will be created based on the file LastWriteTime and 
             it will be created inside the destination directory itself.

//TODO  Add file type(extension) based separation.
#>

# Destination/Source folder as first argument
$dest = $args[0]

function moveFiles(){
    get-childitem -Path "$dest" -recurse | % {
        
        # Get file name
        $file = $_.FullName
        
        # Get last write time of the file
        $date = Get-Date ($_.LastWriteTime) -UFormat "%d-%m-%Y"
        
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
