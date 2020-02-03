<#
   .Notes
      Inspired by https://github.com/gravejester/psInlineProgress
   .Synopsis
      PowerShell function to write a small inline progress bar.
   .Parameter Task
      Description: The name of the work being completed.
      Type: String
      Alias: t
   .Parameter Percent
      Description: The percentage complete.
      Type: Integer
      Alias: p
   .Parameter Done
      Description: A switch to tell the function to close the progress bar.
      Type: Switch
      Alias: d
   .Example
      Write-TinyProgressBar -Task "Task Name" -Percent 50
   .Example
      Write-TinyProgressBar -Task "Task Name" -Done
   .Outputs
      100% [#########################]: Loop 9543 of 9543 - Complete
#>

#region #---[ Functions ]---#

Function Write-TinyProgressBar {
   [cmdletbinding()]
   Param (
      # The name of the work being completed
      [Parameter(Mandatory = $True, Position = 0)]
      [Alias("t")]
      [string]$Task,
      # Percent Complete
      [Parameter(Mandatory = $False,Position = 1)]
      [Alias("p")]
      [int]$Percent,
      # A switch to close the progress bar
      [Parameter(Mandatory = $False)]
      [Alias("d")]
      [switch]$Done
   ) # end param

   # Set Complete Variables
   if ($Done) {
      $Percent = 100
      $Task = "$($Task) - Complete"
   } # end if
   else {
      $Task = "$($Task)..."
   } # end else

   # Shrink the bar to 25%
   [int]$Complete = [math]::Round(($Percent / 4), 0)
   [int]$InComplete = (25 - $Complete)

   # Get the cursor position
   $Cursor = $host.UI.RawUI.CursorPosition

   # Turn off the cursor
   [console]::CursorVisible = $False

   # Make a string builder object
   $String = New-Object System.Text.StringBuilder

   # Assemble sub-strings
   $Header = "$(' ' * (3 - ($Percent.ToString().Length)))$($Percent)% ["
   $Progress = ("#" * $Complete)
   $Remaining = ("-" * $InComplete)
   $Footer = "]: $($Task)"

   # Build the string
   [void]$String.Append("$($Header)$($Progress)$($Remaining)$($Footer)")

   # Write out the string
   [console]::Write(($String.ToString()))

   # Set the cursor position back to the start
   $host.UI.RawUI.CursorPosition = $Cursor

   if ($Done) {
      [console]::CursorVisible = $true
      [console]::WriteLine()
   } # end if
} # end Write-TinyProgressBar

#endregion

#region #---[ Fake Work 1: Loop over an array ]---#

# Make a fake array to work on
$Work = @(1..9543)
# Set the progress
$Progress = 1
# Set the task name
$Task = "Loop $($Progress) of $($Work.Count)"
# loop through each array item
foreach ($i in $Work) {
   # Calculate the percent complete
   [int]$Percent = [math]::Round(($Progress / $Work.Count * 100), 0)
   # Call the function
   Write-TinyProgressBar -Task "Loop $($Progress) of $($Work.Count)" -Percent $Percent
   # Do work here

   # Increment the progress counter
   $Progress++
}
# Call the function with the "Done" switch
Write-TinyProgressBar "Loop $($Work.Count) of $($Work.Count)" -Done

#endregion
#region #---[ Fake Work 2: Wait for job to finish positional params ]---#

$Job = start-job  -Name "Waiting for 10 seconds" -ScriptBlock { start-sleep -Seconds 10 }
$Progress = 1
$Task = "$($Job.Name)"
while ($Job.State -eq "Running") {
   [int]$Percent = $Progress
   Write-TinyProgressBar $Task $Percent
   start-sleep -Seconds 1
   $Progress++
}
Remove-Job -Id $Job.Id -Force
Write-TinyProgressBar $Task -Done

#endregion
