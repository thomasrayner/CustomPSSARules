function Test-VariableCasing {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst]$ScriptBlockAst
    )
    
	process {
		try {
            $variables = $ScriptBlockAst.FindAll( { $args[0] -is [System.Management.Automation.Language.VariableExpressionAst] -and  
                $args[0].VariablePath.UserPath -cmatch '[A-Z]{3,}' }, $true )
            foreach ( $variable in $variables ) {
                [PSCustomObject]@{
					Message  = 'Avoid variables with more than 3 capital letters in a row in their name'
					Extent   = $variable.Extent
					RuleName = $PSCmdlet.MyInvocation.InvocationName
					Severity = 'Warning'
				}
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError( $_ )
        }
    }
}


 function Test-FunctionCasing {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst]$ScriptBlockAst
    )

    process {
        try {
			$variables = $ScriptBlockAst.FindAll( { $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] -and  
                $args[0].Name -cmatch '[A-Z]{3,}' }, $true )
            foreach ( $variable in $variables ) {
                [PSCustomObject]@{
					Message  = 'Avoid function names with more than 3 capital letters in a row in their name'
					Extent   = $variable.Extent
					RuleName = $PSCmdlet.MyInvocation.InvocationName
					Severity = 'Warning'
				}
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError( $_ )
        }
    }
}