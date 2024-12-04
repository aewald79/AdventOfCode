$Content = Get-Content -Path "$PSScriptRoot\Input.txt" -Raw
Class WordSearch {
    [array]$grid
    WordSearch($grid) {
        $this.grid = @()
        foreach ($line in $grid) {
            $this.grid += ,$line.ToCharArray()
        }
    }
    [array]
    hidden Find([char]$letter) {
        $coordenates = @()
        for ($y = 0; $y -lt $this.grid.Count; $y++) {
            if ($letter -in $this.grid[$y]) {
                for ($x = 0; $x -lt $this.grid[$y].Count; $x++) {
                    if ($this.grid[$y][$x] -eq $letter) {
                        $coordenates += ,[PSCustomObject]@{Y=$y;X=$x}
                    }
                }
            }
        }
        return $coordenates
    }
    [array]
    Search($word) {
        $possibilities = $output = @()
        $word = $word.ToCharArray()
        $Start = [PSCustomObject]@{Letter = $word[ 0]; Positions = $this.Find($word[ 0])}
        $End   = [PSCustomObject]@{Letter = $word[-1]; Positions = $this.Find($word[-1])}
        $count = $word.Count -1
        foreach ($Starter in $Start.Positions) {
            foreach ($Ender in $End.Positions) {
                $XAdd = $Starter.X + $count -eq $Ender.X
                $YAdd = $Starter.Y + $count -eq $Ender.Y
                $XSub = $Starter.X - $count -eq $Ender.X
                $YSub = $Starter.Y - $count -eq $Ender.Y 
                $Xeq  = $Starter.X -eq $Ender.X
                $Yeq  = $Starter.Y -eq $Ender.Y
                if (($YAdd-and$Xeq)-or($YAdd-and$XAdd)-or($Yeq-and$XAdd)-or($YSub-and$XAdd)-or($YSub-and$Xeq)-or($YSub-and$XSub)-or($Yeq-and$XSub)-or($YAdd-and$XSub)) {
                    $possibilities += [PSCustomObject]@{ Start=$Starter; End=$Ender; Valid=$true; X=$null; Y=$null }
                }
            }
        }
        foreach ($possibility in $possibilities) {
            $possibility.Y = $possibility.Start.Y..$possibility.End.Y
            $possibility.X = $possibility.Start.X..$possibility.End.X
            if ($possibility.Y.Count -eq 1) { $possibility.Y *= $word.Count }
            if ($possibility.X.Count -eq 1) { $possibility.X *= $word.Count }
            for ($i = 0; $i -lt $word.Count; $i++) {
                $possibility.Valid = $possibility.Valid -and ($this.grid[$possibility.Y[$i]][$possibility.X[$i]] -eq $word[$i])
            }
        }
        $possibilities | Where-Object {$_.Valid} | ForEach-Object {
            $output += @{Start=$_.Start.Y,$_.Start.X;End=$_.End.Y,$_.End.X}
        }
        return $output
    }
}
function Get-Intersection {
    param (
        [hashtable]$line1,
        [hashtable]$line2
    )
    Write-Host $line1.Start[0]
    $denominator = ($line1.Start[0] - $line1.Start[1]) * ($line2.End[0] - $line2.End[1]) - ($line1.End[0] - $line1.End[1]) * ($line2.Start[0] - $line2.Start[1])
    if ($denominator -eq 0) {
        return $null # Lines are parallel
    }

    $t = (($line1.Start[0] - $line2.Start[0]) * ($line2.End[0] - $line2.End[1]) - ($line1.End[0] - $line2.End[0]) * ($line2.Start[0] - $line2.Start[1])) / $denominator
    $u = -((($line1.Start[0] - $line1.Start[1]) * ($line1.End[0] - $line2.End[0]) - ($line1.End[0] - $line1.End[1]) * ($line1.Start[0] - $line2.Start[0])) / $denominator)

    if ($t -ge 0 -and $t -le 1 -and $u -ge 0 -and $u -le 1) {
        $intersectionX = $line1.Start[0] + $t * ($line1.Start[1] - $line1.Start[0])
        $intersectionY = $line1.End[0] + $t * ($line1.End[1] - $line1.End[0])
        return @{x=$intersectionX; y=$intersectionY}
    }

    return $null
}


$XMAS = $Content | Select-String 'M(?=\wM.{139}A.{139}S\wS)|M(?=\wS.{139}A.{139}M\wS)|S(?=\wS.{139}A.{139}M\wM)|S(?=\wM.{139}A.{139}S\wM)' -AllMatches | Foreach {$_.matches}
$XMAS.Count

Exit
#Gave up used Regex
$grid = @($Content)
$puzzle2 = [WordSearch]::new($grid)
$Output2 = $puzzle2.Search("MAS")
$coordinates = @()
foreach($foundword in $Output2){
    if (!(($foundword.End[0] -eq $foundword.Start[0]) -or ($foundword.End[1] -eq $foundword.Start[1]))) {$coordinates += $foundword}
}
$coordinates.count
# Find intersections
$intersections = @()
for ($i = 0; $i -lt $coordinates.Count; $i++) {
    for ($j = $i + 1; $j -lt $coordinates.Count; $j++) {
        Write-Host [$i]
        $intersection = Get-Intersection -line1 $coordinates[$i] -line2 $coordinates[$j]
        if ($intersection) {
            $intersections += $intersection
        }
    }
}

# Output intersecting coordinates
if ($intersections.Count -gt 0) {
    Write-Output "Intersecting coordinates:"
    $intersections | ForEach-Object { Write-Output "($($_.Start), $($_.End))" }
} else {
    Write-Output "No intersections found."
}