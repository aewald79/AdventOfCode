$Content = Get-Content -Path "$PSScriptRoot\Input.txt"
[int]$Total = 0
[int]$NewTotal = 0
foreach ($Line in $Content) {
    $NumberList = Select-String 'mul\(\d+,\d+\)' -InputObject $Line -AllMatches | Foreach {$_.matches}
    $NumberList = $NumberList.Value -Replace '\)'
    $NumberList = $NumberList -Replace 'mul\('
    $NumberList = $NumberList -Replace ('\,'," ")
    foreach ($NumberPair in $NumberList){
        $SplitPair = $NumberPair.Split(" ")
        [int]$Sum = $([int]$SplitPair[0]) * $([int]$SplitPair[1])
        [int]$Total = [int]$Total + [int]$Sum
    }
}
$Content = Get-Content -Path "$PSScriptRoot\Input.txt"
$Content.count
foreach ($Line in $Content) {
    $NumberListFirst = $Line -match "mul\(\d+,\d+\).*?don't\(\)"
    $NumberListFirst = $Matches.Values | Select-String 'mul\(\d+,\d+\)' -AllMatches | Foreach {$_.matches}
    $NumberListFirst = $NumberListFirst.Value -Replace '\)'
    $NumberListFirst = $NumberListFirst -Replace 'mul\('
    $NumberListFirst = $NumberListFirst -Replace ('\,'," ")
    foreach ($NumberPair in $NumberListFirst){
        $SplitPair = $NumberPair.Split(" ")
        [int]$NewSum = $([int]$SplitPair[0]) * $([int]$SplitPair[1])
        [int]$NewTotal = [int]$NewTotal + [int]$NewSum
    }
    Write-Host "Just the start $NewTotal"
    $NumberList = Select-String "do\(\)(.*?)don't\(\)" -InputObject $Line -AllMatches | Foreach {$_.matches}
    $NumberList = Select-String 'mul\(\d+,\d+\)' -InputObject $NumberList -AllMatches | Foreach {$_.matches}
    $NumberList = $NumberList.Value -Replace '\)'
    $NumberList = $NumberList -Replace 'mul\('
    $NumberList = $NumberList -Replace ('\,'," ")
    foreach ($NumberPair in $NumberList){
        $SplitPair = $NumberPair.Split(" ")
        [int]$NewSum = $([int]$SplitPair[0]) * $([int]$SplitPair[1])
        [int]$NewTotal = [int]$NewTotal + [int]$NewSum
    }
}
Write-Host "Multiplier Total: $Total"
Write-Host "Do Instruction Set Total: $NewTotal"
