# Write-TinyProgressBar

PowerShell function to write a small inline progress bar. Inspired by https://github.com/gravejester/psInlineProgress

## Output

![Write-TinyProgressBar](https://user-images.githubusercontent.com/22983731/73659892-5b3ad180-4654-11ea-8910-11df77644b8f.gif)

## Example 1:

```PowerShell
Write-TinyProgressBar -Task "Sorting" -Percent 50
```

## Example 2: Wait for Job to Finish

Using Positional Parameters

```PowerShell
$Job = start-job  -Name "Doing Stuff" -ScriptBlock { start-sleep -Seconds 30 }
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
```
