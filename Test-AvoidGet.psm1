function Deny-GetFunction {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst]$ScriptBlockAst
    )

    process {
        try {
			$variables = $ScriptBlockAst.FindAll( { $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $args[0].Name -match '^Get-' }, $true )
            foreach ( $variable in $variables )
            {
                [PSCustomObject]@{
					Message  = 'Avoid using the "Get" verb'
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