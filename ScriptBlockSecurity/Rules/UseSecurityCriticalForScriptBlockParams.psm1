function Test-ScriptBlockParamSecurity {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst]$ScriptBlockAst
    )

    process {
        try {
            if ( $ScriptBlockAst.ParamBlock ) {
		    	$paramBlocks = ($ScriptBlockAst.FindAll( { $args[0] -is [System.Management.Automation.Language.ParamBlockAst] }, $true )).Parameters | Select-Object -Unique
                foreach ( $paramBlock in $paramBlocks ) {
                    if ( $paramBlock.StaticType.Name -contains 'ScriptBlock' ) {
                        $sbParams = $paramBlock | Where-Object { $_.StaticType.Name -eq 'ScriptBlock' }
                        foreach ( $sbParam in $sbParams ) {
                            if ( $sbParam.Attributes.TypeName.FullName -notcontains 'Security.SecurityCritical' ) {
                                [PSCustomObject]@{
		    			            Message  = 'Avoid using parameters that accept a scriptblock without specifying [Security.SecurityCritical()]'
		    			            Extent   = $sbParam.Extent
		    			            RuleName = 'PSUseSecurityCriticalForScriptBlockParams'
		    			            Severity = 'Warning'
		    		            } # [PSCustomObject]
                            } # if $sbParam.Attributes.TypeName.FullName -notcontains 'Security.SecurityCritical'
                        } # foreach $sbParam in $sbParams
                    } # if $paramblock.StaticType.Name -contains 'ScriptBlock'
                } # foreach $paramblock in $paramBlocks
            } # if $ScriptBlockAst.ParamBlock
        } # try
        catch {
            $PSCmdlet.ThrowTerminatingError( $_ )
        } # catch
    } # process
} # function Test-ScriptBlockParamSecurity