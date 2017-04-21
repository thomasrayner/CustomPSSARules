function Test-VariableAssignment {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.Language.ScriptBlockAst]$ScriptBlockAst
    )

    process {
        $automaticVariables = @('$','?','^','_','ARGS','CONSOLEFILENAME','ERROR','EVENT','EVENTARGS','EVENTSUBSCRIBER','EXECUTIONCONTEXT','FALSE','FOREACH','HOME','HOST','INPUT','LASTEXITCODE','MATCHES','MYINVOCATION','NESTEDPROMPTLEVEL','NULL','OFS','PID','PROFILE','PSBOUNDPARAMETERS','PSCMDLET','PSCOMMANDPATH','PSCULTURE','PSDEBUGCONTEXT','PSHOME','PSITEM','PSSCRIPTROOT','PSSENDERINFO','PSUICULTURE','PSVERSIONTABLE','PWD','REPORTERRORSHOWEXCEPTIONCLASS','REPORTERRORSHOWINNEREXCEPTION','REPORTERRORSHOWSOURCE','REPORTERRORSHOWSTACKTRACE','SENDER','SHELLID','STACKTRACE','THIS','TRUE')
        try {
			$parametersAst = $ScriptBlockAst.FindAll( { $args[0] -is [System.Management.Automation.Language.ParamBlockAst] }, $true )
            $variablesAst = $ScriptBlockAst.FindAll( { $args[0] -is [System.Management.Automation.Language.AssignmentStatementAst] }, $true )

            $parameters = $parametersAST.Parameters | Select-Object @{l='Name';e={$_.Name.VariablePath.UserPath}}, @{l='Line';e={$_.Extent.StartLineNumber}}
            $variables = $variablesAst | Select-Object @{l='Name';e={$_.Left.ToString().TrimStart('$')}}, @{l='Line';e={$_.Extent.StartLineNumber}}


            $assigned = New-Object System.Collections.ArrayList
            foreach ( $par in $parameters ) {
                $add = @{
                    'Name' = $par.Name.ToString()
                    'Line' = [int]$par.Line.ToString()
                }
                $null = $assigned.Add( ( New-Object PSObject -Property $add ) )
            }
            foreach ( $var in $variables ) {
                $add = @{
                    'Name' = $var.Name.ToString()
                    'Line' = [int]$var.Line.ToString()
                }
                $null = $assigned.Add( ( New-Object PSObject -Property $add ) )
            }
            $assigned = $assigned | Sort-Object -Property Line


            $expressionsAst = $ScriptBlockAst.FindAll( { $args[0] -is [System.Management.Automation.Language.VariableExpressionAst] }, $true )
            $expressions = $expressionsAst | Select-Object @{l='Name';e={$_.VariablePath.Userpath}}, @{l='Line';e={$_.Extent.StartLineNumber}}, Extent


            foreach ( $exp in $expressions ) {
                if ( ( $exp.Name.ToString() -notin $assigned.Name ) -and ( $exp.Name.ToString() -notin $automaticVariables ) ) {
                    [PSCustomObject]@{
					    Message  = "$($exp.Name) is used before it is assigned a value"
					    Extent   = $exp.Extent
					    RuleName = 'PSDoNotUseUnassignedVariables'
					    Severity = 'Warning'
				    }
                }
                else {
                    $line = [int]$exp.Line.ToString()
                    $assignsAfter = @($assigned | Where-Object { ( $_.Name -eq $exp.Name.ToString() ) -and ( $_.Line -gt $line ) })
                    $assignsBefore = @($assigned | Where-Object { ( $_.Name -eq $exp.Name.ToString() ) -and ( $_.Line -lt $line ) })

                    if ( ( -not $assignsBefore ) -and ( $assignsAfter ) ) {
                        [PSCustomObject]@{
					        Message  = "$($exp.Name) is used before it is assigned a value"
					        Extent   = $exp.Extent
					        RuleName = 'PSDoNotUseUnassignedVariables'
					        Severity = 'Warning'
				        }
                    } 
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError( $_ )
        }
    }
}
