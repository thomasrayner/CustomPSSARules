# AvoidImproperlyCapitalizedVariableNames

**Severity Level: Warning**

## Description

According to the PowerShell Practice and Style guide's section on [capitalization conventions](https://github.com/PoshCode/PowerShellPracticeAndStyle/blob/master/Style%20Guide/Code%20Layout%20and%20Formatting.md#capitalization-conventions) (community developed, but referencse Microsoft's [published document](https://msdn.microsoft.com/en-us/library/ms229043?f=255&MSPPError=-2147217396) on the same for the .NET framework), it is best practice to use camelCase for variables inside of functions, modules and scripts. This means that that one should never see adjacent capital letters in a variable name.

An exception exists for two letter acronyms only like "VM" for Virtual Machine or "PS" for PowerShell (ex: `$PSBoundParameters`). This should not extend to compound acronyms like Azure Resource manager's "RM" meets Virtual Machine "VM" in `$azureRmVM`. Accordingly, this rule warns on instances where four or more adjacent capital letters are found in a variable name.

## How

Variable names should conform to capitalization standards.

## Example

### Wrong

``` PowerShell
$myVARIABLE = 'data'
$myVMOS = Get-CimInstance @commandProps -ClassName Win32_OperatingSystem | Select-Object -ExpandProperty Caption
```

### Correct

``` PowerShell
$myVariable = 'data'
$myVmOS = Get-CimInstance @commandProps -ClassName Win32_OperatingSystem | Select-Object -ExpandProperty Caption
```