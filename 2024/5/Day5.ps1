$RuleList = @()
$UpdateList = @()
$InputState = 0

Get-Content "$PSscriptroot/Input.txt" | ForEach-Object {
    $Line = $_.Trim()
    if ($Line -eq "") {
        $InputState = 1
    } elseif ($InputState -eq 0) {
        $A, $B = $Line -split "\|"
        $NewTuple = [tuple]::Create([int]$A, [int]$B)
        $RuleList += $NewTuple
    } else {
        $NewLine = $Line -split "," | ForEach-Object { [int]$_ }
        $UpdateList += ,@($NewLine)
    }
}

$Part1Answer = 0
for ($v = 0; $v -lt $UpdateList.Count; $v++) {
    $u = $UpdateList[$v]
    $Len = $u.Count
    $Allowed = $true
    foreach ($Rule in $RuleList) {
        $Front, $Back = $Rule
        if ($u -notcontains $Front -or $u -notcontains $Back) {
            continue
        }
        $FrontIndex = $u.IndexOf($Front)
        $BackIndex = $u.IndexOf($Back)
        if ($BackIndex -lt $FrontIndex) {
            $Allowed = $false
            break
        }
    }
    if ($Allowed) {
        $MiddleIndex = [math]::Floor($Len / 2)
        $Part1Answer += $u[$MiddleIndex]
        $UpdateList[$v] = "Void"
    }
}

$UpdateList = $UpdateList | Where-Object { $_ -ne "Void" }

$Part2Answer = 0
foreach ($u in $UpdateList) {
    $Dict = @{}
    foreach ($g in $u) {
        $Dict[$g] = 0
    }
    foreach ($Rule in $RuleList) {
        $Front, $Back = $Rule
        if ($u -contains $Front -and $u -contains $Back) {
            $Dict[$Front]++
        }
    }
    foreach ($g in $u) {
        if ($Dict[$g] -eq [math]::Floor($u.Count / 2)) {
            $Part2Answer += $g
            break
        }
    }
}

Write-Output "Part1Answer = $Part1Answer"
Write-Output "Part2Answer = $Part2Answer"