$Content = Get-Content -Path $PSScriptRoot\Input.txt
$LeftNumberList = @()
$RightNumberList = @()
foreach ($Line in $Content) {
    $SplitLine = $Line.Split(" ")
    $LeftNumberList += $SplitLine[0]
    $RightNumberList += $SplitLine[3]
}
function Get-DiffrenceFromInput {
    $Total = 0
    $LeftNumberList = $LeftNumberList | Sort-Object 
    $RightNumberList = $RightNumberList | Sort-Object 
    for ($i = 0; $i -lt $LeftNumberList.Count; $i++) {
        $Difference = [Math]::Abs($LeftNumberList[$i] - $RightNumberList[$i])
        $Total = $Total + $Difference
    }
    Return $Total
}
function Get-SimilarityScore {
    $SimilarityScoreTotal = 0
    for ($i = 0; $i -lt $LeftNumberList.Count; $i++) {
        $Matches = $RightNumberList -match $LeftNumberList[$i]
        $Similarity = $Matches.count * $LeftNumberList[$i]
        $SimilarityScoreTotal = $SimilarityScoreTotal + $Similarity      
    }
    Return $SimilarityScoreTotal
}
Get-DiffrenceFromInput
Get-SimilarityScore
