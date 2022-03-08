<#
	.SYNOPSIS

	.DESCRIPTION

	.PARAMETER Template
	The Template String 

	.PARAMETER Csv
	Path to the CSV

	.PARAMETER Params
	CSV Headers
#>


function Publish-TemplatedTweet {
	param (
		[string] $Template,
		[string] $Csv,
		[string[]] $ParamList
	)
	
	# Import-Module BluebirdPS -Scope Local


	$list = Import-Csv -Path $Csv -Header $ParamList

	$list | ForEach-Object {
		$currentObj = $_
		$Template_Iter = $Template

		$ParamList | ForEach-Object {
			New-Variable -Name $_ -Value $currentObj.$($_)
			# Get-Variable -Name $_ -ValueOnly | Write-Host
			$SearchExp = "\`$\`{$_\`}"
			$ReplaceVal = Get-Variable -Name $_ -ValueOnly
			$Template_Iter = $Template_Iter -replace $SearchExp, $ReplaceVal 
			Remove-Variable -Name $_
		}

		#Template has been generated
		Write-Host $Template_Iter

		# # Raw Character Count, Ignoring Link count
		# Write-Host "Char Count (No URL Parsing): "$Template_Iter.Length;

		# $CharCount = $Template_Iter.Length
		# #Find links and do a proper char count
		# $URLMatch = "(http[s]?:\/\/.*)\s"
		# if ($Template_Iter -match $URLMatch) {
		# 	#If we have multiple URLs, Parse through each of them
		# 	foreach ($item in $Matches.GetEnumerator()) {
		# 		$CharCount = $CharCount - $item.Value.Length + 23

		# 	} 
		
		# }

		# Write-Host "Char Count (With URL Parsing): "$CharCount
		Publish-Tweet -TweetText $Template_Iter
		Write-Host "Tweet Sent!"
		Start-Sleep -Seconds 1
		Write-Host `n`n

	}


}

Export-ModuleMember -Function Publish-TemplatedTweet