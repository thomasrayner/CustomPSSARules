Import-Module PSScriptAnalyzer -Force

$violationName = 'PSAvoidImproperlyCapitalizedVariableNames'
$directory = Split-Path -Parent $MyInvocation.MyCommand.Path

$violations = Invoke-ScriptAnalyzer -Path "$directory\AvoidImproperlyCapitalizedVariableNames-violations.ps1" -CustomRulePath "$directory\..\Rules\AvoidImproperlyCapitalizedVariableNames.psm1" | Where-Object {$_.RuleName -eq $violationName}
$noViolations = Invoke-ScriptAnalyzer -Path "$directory\AvoidImproperlyCapitalizedVariableNames-noviolations.ps1" -CustomRulePath "$directory\..\Rules\AvoidImproperlyCapitalizedVariableNames.psm1" | Where-Object {$_.RuleName -eq $violationName}


Describe "AvoidImproperlyCapitalizedVariableNames" {
    Context "When there are violations" {
        It "has 2 badly capitalized variable names" {
            $violations.Count | Should Be 2
        }
    }

    Context "When there are no violations" {
        It "returns no violations" {
            $noViolations.Count | Should Be 0
        }
    }
}