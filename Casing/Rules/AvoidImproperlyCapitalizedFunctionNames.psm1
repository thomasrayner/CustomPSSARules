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
			$functions = $ScriptBlockAst.FindAll( { $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] -and  
                $args[0].Name -cmatch '[A-Z]{4,}' }, $true )
            foreach ( $function in $functions )
            {
                [PSCustomObject]@{
					Message  = 'Avoid function names with more than 3 capital letters in a row in their name'
					Extent   = $function.Extent
					RuleName = 'PSAvoidImproperlyCapitalizedFunctionNames'
					Severity = 'Warning'
				}
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError( $_ )
        }
    }
}