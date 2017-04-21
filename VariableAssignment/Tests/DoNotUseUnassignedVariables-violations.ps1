function Invoke-Test {
    param (
        [parameter()][string]$Parameter
    )
    Get-Childitem -Path $Parameter -Depth $two -Recurse
    $two = 2
    Get-ChildItem -Path $three
    Get-Childitem -Path $Parameter -Depth $two -Recurse
    $five = 'something'
    $five -eq $true
    Get-ChildItem $seven
}

function Invoke-OtherTest {
    Get-ChildItem $four
    Get-ChildItem $two
    1..2 | % { $_ }
    Get-ChildItem $five
    $seven = $true
    #$eight = $null
}

#should violate on lines 5, 7, 11, 15, 16, 18