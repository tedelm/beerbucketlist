cd "C:\0_PRIVAT\bjcp\"
$bjcp = Get-Content "C:\0_PRIVAT\bjcp\2021_Guidelines_Beer_clean.txt"

$nl = [System.Environment]::NewLine
$items = ($bjcp -split "$nl$nl")

#Regex
$regex1 = [Regex]::new('^[0-9][A-Z]{1}')
$regex2 = [Regex]::new('^[0-9][0-9][A-Z]{1}')
$regex3 = [Regex]::new('^[0-9]')
$regex4 = [Regex]::new('^[A-Z]')
$regex_HeadCategory = [Regex]::new('^[0-9][ ][A-Z][a-z]')

function Clean-ArrayString {
    param (
        [String]$title,
        [String]$Overall_Impression,
        [String]$Aroma,
        [String]$Appearance,
        [String]$Flavor,
        [String]$Mouthfeel,
        [String]$Comments,
        [String]$History,
        [String]$Characteristic_Ingredients,
        [String]$Style_Comparison,
        [String]$Vital_Statistics,
        [String]$IBUs,
        [String]$SRM,
        [String]$Commercial_Examples,
        [String]$Tags,
        [Switch]$CHANGE_CATEGORY,
        [String]$CATEGORY
    )

    $CATEGORY_ = ($CATEGORY -split "\. ")[1]
    $CATEGORY_NUMBER = ($CATEGORY -split "\. ")[0]

    write-host $CATEGORY
    write-host $OLDCATEGORY
    Write-Host $CHANGE_CATEGORY

    $Vital_Statistics = ($Vital_Statistics -replace "`t","" -replace " ","")
    $OG = $($Vital_Statistics -split "OG:")[1]
    $OG_MIN = $($OG -split "-")[0]
    $OG_MAX = $($OG -split "-")[1]

    $IBUs = ($IBUs -replace "`t","" -replace " ","")
    $IBU_FG = $($IBUs -split "IBUs:")[1]
    $IBU = $($IBU_FG -split "FG:")[0]
    $IBU_MIN = $($IBU -split "-")[0]
    $IBU_MAX = $($IBU -split "-")[1]

    $FG = $($IBU_FG -split "FG:")[1]
    $FG_MIN = $($FG -split "-")[0]
    $FG_MAX = $($FG -split "-")[1]

    $SRM_ABV = ($SRM -replace "`t","" -replace " ","" -replace "%")
    $SRM = $($SRM_ABV -split "ABV:")[0]
    $SRM = $($SRM -split "SRM:")[1]
    $SRM_MIN = $($SRM -split "-")[0]
    $SRM_MAX = $($SRM -split "-")[1]

    $ABV = $($SRM_ABV -split "ABV:")[1]
    $ABV_MIN = $($ABV -split "-")[0]
    $ABV_MAX = $($ABV -split "-")[1]

    $CATEGORY_CLASS = $($title -split "\. ")[0]
    $CATEGORY_CLASS_NAME = $($title -split "\. ")[1]

    $STYLE_LETTER = ($CATEGORY_CLASS -replace '[0-9]',"") 
    #$CATEGORY_NUMBER = ($CATEGORY_CLASS -replace $regex4,"")

    if( ($Tags -like "*top-fermented*") -or ($Tags -like "*ale*") ){
        $TYPE = "Ale"
    }elseif ( ($Tags -like "*bottom-fermented*") -or ($Tags -like "*lager*")) {
        $TYPE = "Lager"
    }else {
        $TYPE = "-"
    }
    

    if($debugg){
        write-host "title..."
        write-host $title
        write-host "Overall_Impression..."
        write-host $Overall_Impression
        write-host "Aroma..."
        write-host $Aroma
        write-host "Appearance..."
        write-host $Appearance
        write-host "Flavor..."
        write-host $Flavor
        write-host "Mouthfeel..."
        write-host $Mouthfeel
        write-host "Comments..."
        write-host $Comments
        write-host "History..."
        write-host $History
        write-host "Characteristic_Ingredients..."
        write-host $Characteristic_Ingredients
        write-host "Style_Comparison..."
        write-host $Style_Comparison
        write-host "Vital_Statistics (OG)..."
        write-host "$OG ... OG_MIN: $OG_MIN OG_MAX: $OG_MAX"
        write-host "IBUs..."
        write-host "$IBU ... IBU_MIN: $IBU_MIN IBU_MAX: $IBU_MAX"
        write-host "$FG ... FG_MIN: $FG_MIN IBU_MAX: $FG_MAX"
        write-host "SRM..."
        write-host "$SRM SRM_MIN: $SRM_MIN SRM_MAX: $SRM_MAX"
        write-host "ABV..."    
        write-host "$ABV ABV_MIN: $ABV_MIN ABV_MAX: $ABV_MAX"
        write-host "Commercial_Examples..."
        write-host $Commercial_Examples
        write-host "Tags..."
        write-host $Tags    
        write-host "CATEGORY..."
        write-host $CATEGORY
    }




    $Commercial_Examples = $Commercial_Examples -replace "Commercial Examples: ","" -replace '"', "'"
    $Overall_Impression = $Overall_Impression -replace "Overall Impression: ","" -replace '"', "'"
    $Aroma = $Aroma -replace "Aroma: ","" -replace '"', "'"
    $Appearance = $Appearance -replace "Appearance: ","" -replace '"', "'"
    $Flavor = $Flavor -replace "Flavor: ","" -replace '"', "'"
    $Mouthfeel = $Mouthfeel -replace "Mouthfeel: ","" -replace '"', "'"
    $Comments = $Comments -replace "Comments: ","" -replace '"', "'"
    $History = $History -replace "History: ","" -replace '"', "'"
    $Characteristic_Ingredients = $Characteristic_Ingredients -replace "Characteristic Ingredients: ","" -replace '"', "'"
    $Style_Comparison = $Style_Comparison -replace "Style Comparison: ","" -replace '"', "'"
    $Tags = $Tags -replace "Tags: ",""

    write-host $CHANGE_CATEGORY

if($CHANGE_CATEGORY){
    write-host "Function category change"

$jbody = '
],
"'+$($CATEGORY_ -replace " ","_")+'": [
    {
    "'+$CATEGORY_CLASS+'": {
        "STYLE_GUIDE": "BJCP 2021",
        "NAME": "'+$CATEGORY_CLASS_NAME+'",
        "STYLE_LETTER": "'+$STYLE_LETTER+'",
        "CATEGORY": "'+$CATEGORY_+'",
        "CATEGORY_NUMBER": "'+$CATEGORY_NUMBER+'",
        "TYPE": "'+$TYPE+'",
        "OG_MIN": "'+$OG_MIN+'",
        "OG_MAX": "'+$OG_MAX+'",
        "FG_MIN": "'+$FG_MIN+'",
        "FG_MAX": "'+$FG_MAX+'",
        "IBU_MIN": "'+$IBU_MIN+'",
        "IBU_MAX": "'+$IBU_MAX+'",
        "COLOR_MIN": "'+$SRM_MIN+'",
        "COLOR_MAX": "'+$SRM_MAX+'",
        "ABV_MIN": "'+$ABV_MIN+'",
        "ABV_MAX": "'+$ABV_MAX+'",
        "RESIDUAL_SUGARS": "'+$RESIDUAL_SUGARS+'",
        "HOP_AROMA": "'+$HOP_AROMA+'",
        "MALT_AROMA": "'+$MALT_AROMA+'",
        "CARAMELL_AROMA": "'+$CARAMELL_AROMA+'",
        "FRUIT_ESTERS": "'+$FRUIT_ESTERS+'",
        "ALCOHOL_TASTE": "'+$ALCOHOL_TASTE+'",
        "YEAST_TYPE": "'+$YEAST_TYPE+'",
        "CO2": "'+$CO2+'",
        "CLARITY": "'+$CLARITY+'",         
        "NOTES": "'+$NOTES+'",
        "PROFILE": "'+$PROFILE_+'",
        "COMMERCIAL_EXAMPLES": "'+$Commercial_Examples+'",
        "OVERALL_IMPRESSION": "'+$Overall_Impression+'",
        "AROMA": "'+$Aroma+'",
        "APPEARANCE": "'+$Appearance+'",
        "FLAVOR": "'+$Flavor+'",
        "MOUTHFEEL": "'+$Mouthfeel+'",
        "COMMENTS": "'+$Comments+'",
        "HISTORY": "'+$History+'",
        "CHARACTERISTICS_INGREDIENTS": "'+$Characteristic_Ingredients+'",
        "STYLE_COMPARISON": "'+$Style_Comparison+'",
        "EXAMPLES": "'+$EXAMPLES+'",
        "TAGS": "'+$Tags+'"
    },
'
}else {
$jbody = '
    "'+$CATEGORY_CLASS+'": {
        "STYLE_GUIDE": "BJCP 2021",
        "NAME": "'+$CATEGORY_CLASS_NAME+'",
        "STYLE_LETTER": "'+$STYLE_LETTER+'",
        "CATEGORY": "'+$CATEGORY_+'",
        "CATEGORY_NUMBER": "'+$CATEGORY_NUMBER+'",
        "TYPE": "'+$TYPE+'",
        "OG_MIN": "'+$OG_MIN+'",
        "OG_MAX": "'+$OG_MAX+'",
        "FG_MIN": "'+$FG_MIN+'",
        "FG_MAX": "'+$FG_MAX+'",
        "IBU_MIN": "'+$IBU_MIN+'",
        "IBU_MAX": "'+$IBU_MAX+'",
        "COLOR_MIN": "'+$SRM_MIN+'",
        "COLOR_MAX": "'+$SRM_MAX+'",
        "ABV_MIN": "'+$ABV_MIN+'",
        "ABV_MAX": "'+$ABV_MAX+'",
        "RESIDUAL_SUGARS": "'+$RESIDUAL_SUGARS+'",
        "HOP_AROMA": "'+$HOP_AROMA+'",
        "MALT_AROMA": "'+$MALT_AROMA+'",
        "CARAMELL_AROMA": "'+$CARAMELL_AROMA+'",
        "FRUIT_ESTERS": "'+$FRUIT_ESTERS+'",
        "ALCOHOL_TASTE": "'+$ALCOHOL_TASTE+'",
        "YEAST_TYPE": "'+$YEAST_TYPE+'",
        "CO2": "'+$CO2+'",
        "CLARITY": "'+$CLARITY+'",         
        "NOTES": "'+$NOTES+'",
        "PROFILE": "'+$PROFILE_+'",
        "COMMERCIAL_EXAMPLES": "'+$Commercial_Examples+'",
        "OVERALL_IMPRESSION": "'+$Overall_Impression+'",
        "AROMA": "'+$Aroma+'",
        "APPEARANCE": "'+$Appearance+'",
        "FLAVOR": "'+$Flavor+'",
        "MOUTHFEEL": "'+$Mouthfeel+'",
        "COMMENTS": "'+$Comments+'",
        "HISTORY": "'+$History+'",
        "CHARACTERISTICS_INGREDIENTS": "'+$Characteristic_Ingredients+'",
        "STYLE_COMPARISON": "'+$Style_Comparison+'",
        "EXAMPLES": "'+$EXAMPLES+'",
        "TAGS": "'+$Tags+'"
    },
'    
}
    


return $jbody
    
}

$jsonArray = @()

$i = 0
foreach ($item in $items) {

    if($item -match '^\d{1,2}.\s\w{1,5}'){
        Write-host "Head Class: $item" -ForegroundColor Blue -BackgroundColor Yellow
        $CATEGORY = $item 
        $CHANGE_CATEGORY = $true
    }


    if( ($item -match $regex1) -and (($item -notlike "*Comments*") -or ($item -notlike "*Characteristic Ingredients*")) ){
        write-host "#############################################################" 

        if( $($items[$($i+10)]) -like "*Vital Statistics*"){
            $ii = $i+10
            $DataFound = $true
        }elseif( $($items[$($i+11)]) -like "*Vital Statistics*"){
            $ii = $i+11
            $DataFound = $true
        }elseif( $($items[$($i+12)]) -like "*Vital Statistics*"){
            $ii = $i+12
            $DataFound = $true
        }elseif( $($items[$($i+9)]) -like "*Vital Statistics*"){
            $ii = $i+9
            $DataFound = $true
        }elseif( $($items[$($i+8)]) -like "*Vital Statistics*"){
            $ii = $i+8
            $DataFound = $true
        }elseif( $($items[$($i+7)]) -like "*Vital Statistics*"){
            $ii = $i+7
            $DataFound = $true
        }else {
            $DataFound = $false
        }

        foreach ($line in $($items[$i..$($i+15)]) ) {
            if($line -like "*Overall Impression:*"){

                $Overall_Impression = $line
            }
            if($line -like "*Aroma:*"){

                $Aroma = $line
            }
            if($line -like "*Appearance:*"){

                $Appearance = $line
            }  
            if($line -like "*Flavor:*"){
                $Flavor = $line
            }
            if($line -like "*Mouthfeel:*"){
                $Mouthfeel = $line
            }      
            if($line -like "*Comments:*"){
                $Comments = $line
            } 
            if($line -like "*History:*"){
                $History = $line
            } 
            if($line -like "*Characteristic Ingredients:*"){
                $Characteristic_Ingredients = $line
            }    
            if($line -like "*Vital Statistics:*"){
                $Vital_Statistics = $line
            }    
            if($line -like "*Commercial Examples:*"){
                $Commercial_Examples = $line
            }
            if($line -like "*IBUs:*"){
                $IBUs = $line
            }
            if($line -like "*SRM:*"){
                $SRM = $line
            }                      
            if($line -like "*Tags:*"){
                $Tags = $line
            }
            if($line -like "*Style Comparison:*"){
                $Style_Comparison = $line
            }                                                                                     

        }

<#
        if($DataFound){
            $Vital_Statistics = $items[$($ii)] 
            $IBUs = $items[$($ii+1)]
            $SRM = $items[$($ii+2)]
            $Commercial_Examples = $items[$($ii+3)]
            $Tags = $items[$($ii+4)]
            $Overall_Impression = $items[$($i+1)]
            $Aroma = $items[$($i+2)]
            $Appearance = $items[$($i+3)]
            $Flavor = $items[$($i+4)]
            $Mouthfeel = $items[$($i+5)]
            $Comments = $items[$($i+6)]
            $History = $items[$($i+7)]
            $Characteristic_Ingredients = $items[$($i+8)]
            $Style_Comparison = $items[$($i+9)]

        }else {
            $Vital_Statistics = "" 
            $IBUs = ""
            $SRM = ""
            $Commercial_Examples = ""
            $Tags = ""    
        }

#>

        if($CHANGE_CATEGORY){
            write-host "Category change $CATEGORY"

            $jsonArray += Clean-ArrayString `
            -title $items[$i] `
            -Overall_Impression $Overall_Impression `
            -Aroma $Aroma `
            -Appearance $Appearance `
            -Flavor $Flavor `
            -Mouthfeel $Mouthfeel `
            -Comments $Comments `
            -History $History `
            -Characteristic_Ingredients $Characteristic_Ingredients `
            -Style_Comparison $Style_Comparison `
            -Vital_Statistics $Vital_Statistics `
            -IBUs $IBUs `
            -SRM $SRM `
            -Commercial_Examples $Commercial_Examples `
            -Tags $Tags `
            -CHANGE_CATEGORY `
            -CATEGORY $CATEGORY

            $CHANGE_CATEGORY = $false
        }else {
            $jsonArray += Clean-ArrayString `
            -title $items[$i] `
            -Overall_Impression $Overall_Impression `
            -Aroma $Aroma `
            -Appearance $Appearance `
            -Flavor $Flavor `
            -Mouthfeel $Mouthfeel `
            -Comments $Comments `
            -History $History `
            -Characteristic_Ingredients $Characteristic_Ingredients `
            -Style_Comparison $Style_Comparison `
            -Vital_Statistics $Vital_Statistics `
            -IBUs $IBUs `
            -SRM $SRM `
            -Commercial_Examples $Commercial_Examples `
            -Tags $Tags `
            -CATEGORY $CATEGORY            
        }



    }elseif( ($item -match $regex2) -and (($item -notlike "*Comments*") -or ($item -notlike "*Characteristic Ingredients*")) ){
        write-host "#############################################################" 

        if( $($items[$($i+10)]) -like "*Vital Statistics*"){
            $ii = $i+10
            $DataFound = $true
        }elseif( $($items[$($i+11)]) -like "*Vital Statistics*"){
            $ii = $i+11
            $DataFound = $true
        }elseif( $($items[$($i+12)]) -like "*Vital Statistics*"){
            $ii = $i+12
            $DataFound = $true
        }elseif( $($items[$($i+9)]) -like "*Vital Statistics*"){
            $ii = $i+9
            $DataFound = $true
        }elseif( $($items[$($i+8)]) -like "*Vital Statistics*"){
            $ii = $i+8
            $DataFound = $true
        }elseif( $($items[$($i+7)]) -like "*Vital Statistics*"){
            $ii = $i+7
            $DataFound = $true
        }else {
            $DataFound = $false
        }

        foreach ($line in $($items[$i..$($i+13)]) ) {
            if($line -like "*Overall Impression:*"){

                $Overall_Impression = $line
            }
            if($line -like "*Aroma:*"){

                $Aroma = $line
            }
            if($line -like "*Appearance:*"){

                $Appearance = $line
            }  
            if($line -like "*Flavor:*"){
                $Flavor = $line
            }
            if($line -like "*Mouthfeel:*"){
                $Mouthfeel = $line
            }      
            if($line -like "*Comments:*"){
                $Comments = $line
            } 
            if($line -like "*History:*"){
                $History = $line
            } 
            if($line -like "*Characteristic Ingredients:*"){
                $Characteristic_Ingredients = $line
            }    
            if($line -like "*Vital Statistics:*"){
                $Vital_Statistics = $line
            }    
            if($line -like "*Commercial Examples:*"){
                $Commercial_Examples = $line
            }
            if($line -like "*IBUs:*"){
                $IBUs = $line
            }
            if($line -like "*SRM:*"){
                $SRM = $line
            }                      
            if($line -like "*Tags:*"){
                $Tags = $line
            }
            if($line -like "*Style Comparison:*"){
                $Style_Comparison = $line
            }   

        }



        if($CHANGE_CATEGORY){
            write-host "Category change $CATEGORY"

            $jsonArray += Clean-ArrayString `
            -title $items[$i] `
            -Overall_Impression $Overall_Impression `
            -Aroma $Aroma `
            -Appearance $Appearance `
            -Flavor $Flavor `
            -Mouthfeel $Mouthfeel `
            -Comments $Comments `
            -History $History `
            -Characteristic_Ingredients $Characteristic_Ingredients `
            -Style_Comparison $Style_Comparison `
            -Vital_Statistics $Vital_Statistics `
            -IBUs $IBUs `
            -SRM $SRM `
            -Commercial_Examples $Commercial_Examples `
            -Tags $Tags `
            -CHANGE_CATEGORY `
            -CATEGORY $CATEGORY

            $CHANGE_CATEGORY = $false
        }else {
            $jsonArray += Clean-ArrayString `
            -title $items[$i] `
            -Overall_Impression $Overall_Impression `
            -Aroma $Aroma `
            -Appearance $Appearance `
            -Flavor $Flavor `
            -Mouthfeel $Mouthfeel `
            -Comments $Comments `
            -History $History `
            -Characteristic_Ingredients $Characteristic_Ingredients `
            -Style_Comparison $Style_Comparison `
            -Vital_Statistics $Vital_Statistics `
            -IBUs $IBUs `
            -SRM $SRM `
            -Commercial_Examples $Commercial_Examples `
            -Tags $Tags `
            -CATEGORY $CATEGORY            
        }


    }

    $i++

    $title = $null
    $Overall_Impression = $null
    $Aroma = $null
    $Appearance = $null
    $Flavor = $null
    $Mouthfeel = $null
    $Comments = $null
    $History = $null
    $Characteristic_Ingredients = $null
    $Style_Comparison = $null
    $Vital_Statistics = $null
    $IBUs = $null
    $SRM = $null
    $Commercial_Examples = $null
    $Tags = $null
    #$CATEGORY = $null    
    $NewCategory = "false"

}

"{" | out-file -FilePath BJCP2021.json -Encoding utf8
$jsonArray | out-file -FilePath BJCP2021.json -Encoding utf8 -Append
"}" | out-file -FilePath BJCP2021.json -Encoding utf8 -Append

