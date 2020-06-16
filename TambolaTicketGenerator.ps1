param(
$TicketstoGenerate =  10

)
 
 
 function GenerateTicket { 

    #$Seedvalue =0 
    #$Colors = "Red","Green","Gray","Cyan","Magenta","Orange","Brown","Blue"     
    #(Get-Random $Colors).tochararray() | % { $val  = [int]$_* (Get-Random (1..10))  ; $Seedvalue+=$val}
    #$ParticipantName.tochararray() | % { $val  = [int]$_ ; $Seedvalue+=$val}    
    #$Seedvalue = Get-Random
    
    $TicketpositionsSelected = @() 
    # -SetSeed $Seedvalue -count 5
    $TicketpositionsSelected += get-random -InputObject (1..9) -count 5    | sort
    $TicketpositionsSelected += get-random -InputObject (10..18) -count 5   | sort
    $TicketpositionsSelected += get-random -InputObject (19..27) -count 5  | sort 
    #$TicketpositionsSelected 
    
    $TicketpositionsinColumnsValue = @()
    $TicketNumbersArray = @()

	(1..27) | % { $TicketNumbersArray += [PSCustomObject] @{Pos=$_; Value=0} }
 	
    # $ColumnRanges = @
    (0..8) | % { 
        $Column = $_  
        $Rowvalues =@()
        $Rowvalues += $Column * 1 + 1
        $Rowvalues += $Rowvalues[0] + 9
        $Rowvalues += $Rowvalues[0] + 18
    
        $TicketpositionsinColumnsValue +=  [PSCustomObject] @{Column=$Column; Rows=$Rowvalues}
     
        $NumberRangeStart = $Column * 10   
        $NumberRangeEnd = ($Column + 1 ) * 10 - 1 
         if ($Column -eq 0) {$NumberRangeStart ++}
         if ($Column -eq 8) {$NumberRangeEnd ++} 
     
     
        $SelectedNumbers =  @() 
 
        $GetPosToSelect = @()
        $GetPosToSelect += $Rowvalues | ?{$_ -in $TicketpositionsSelected}
        #"IN Column ($Column+1) rowpositions to select"
        if ($GetPosToSelect.count -gt 0) {
	        $SelectedNumbers += get-random -InputObject ($NumberRangeStart..$NumberRangeEnd)  -count ($GetPosToSelect.count)  | sort
    
	        (0..($GetPosToSelect.count - 1))| sort |  % {  
	            $position = $_ 
	            $SetValueObject = $null
	            $SetValueObject = $TicketNumbersArray | ? {$_.Pos -eq $GetPosToSelect[$position]}
	            $SetValueObject.Value  = $SelectedNumbers[$position]  
	        }
	    }  
 
    }


    #TicketNumbersArray 
    "Ticket" 
    #$TicketNumbersArray

 $TicketNumbersArray | % {if ($_.value -eq 0 ){ $_.value =$null}}

    $Print = 1  
	(0..2) | % {
        $String = "|"
        #Write-host "|`t" -NoNewline
		(0..8)| % { 
            #"Checking at position $Print"
            $TicetVal = $TicketNumbersArray | ? {$_.Pos -eq $Print } 
			$String += "   {0,-5}   |" -f $TicetVal.value  
#{1,-30}{2,-10}{3,-10}{4,-10}{5,-10}{6,-10}" -f "Host" 
                $Print++
		} 
        (0..($String.Length -1)) | % {Write-Host "-"  -NoNewline} ; "`n"
        $String
	} 

        (0..($String.Length -1)) | % {Write-Host "-"  -NoNewline} ; "`n"
     
 }

$ParticipantsTicketsQueue = @()  

#(Get-Random $Participants) 
(1..$TicketstoGenerate) | %  {
 
    WRITE-HOST "Generating ticket "
    Sleep (get-random -InputObject (1..10)) 
    GenerateTicket     
    "... Completed ticket generation " 
}