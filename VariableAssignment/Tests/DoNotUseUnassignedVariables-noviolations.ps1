function Invoke-Test {
    param (
        [parameter()][string]$Parameter
    )
    $two = 2
    Get-Childitem -Path $Parameter -Depth $two -Recurse
    $five = 'something'
    $five -eq $true
    if ( $true ) { Write-Output 'hi' }
}

function Invoke-OtherTest {
    1..2 | % { $_ }
    $seven = $true
    #$eight = $null
}