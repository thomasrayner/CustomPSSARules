Import-Module PSScriptAnalyzer -Force

$violationName = 'PSAvoidImproperlyCapitalizedFunctionNames'
$directory = Split-Path -Parent $MyInvocation.MyCommand.Path

$violations = Invoke-ScriptAnalyzer -Path "$directory\AvoidImproperlyCapitalizedFunctionNames-violations.ps1" -CustomRulePath "$directory\..\Rules\AvoidImproperlyCapitalizedFunctionNames.psm1" | Where-Object {$_.RuleName -eq $violationName}
$noViolations = Invoke-ScriptAnalyzer -Path "$directory\AvoidImproperlyCapitalizedFunctionNames-noviolations.ps1" -CustomRulePath "$directory\..\Rules\AvoidImproperlyCapitalizedFunctionNames.psm1" | Where-Object {$_.RuleName -eq $violationName}


Describe "AvoidImproperlyCapitalizedFunctionNames" {
    Context "When there are violations" {
        It "has 2 badly capitalized function names" {
            $violations.Count | Should Be 2
        }
    }

    Context "When there are no violations" {
        It "returns no violations" {
            $noViolations.Count | Should Be 0
        }
    }
}