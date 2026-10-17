
# M365 Bridge - Native C# Wrapper Builder

$ErrorActionPreference = 'Stop'

$ProjectRoot = $PSScriptRoot
$SrcFolder = Join-Path $ProjectRoot 'src'

if (-not (Test-Path -LiteralPath $SrcFolder -PathType Container)) {
    throw "Source directory not found: $SrcFolder"
}

$CoreScript = Join-Path $SrcFolder 'OpenOnline.ps1'

if (-not (Test-Path -LiteralPath $CoreScript -PathType Leaf)) {
    throw "Core automation script not found: $CoreScript"
}

# App name -> icon filename.
$BridgeApps = [ordered]@{
    'WordWeb'       = 'word.ico'
    'ExcelWeb'      = 'excel.ico'
    'PowerPointWeb' = 'powerpoint.ico'
    'VisioWeb'      = 'visio.ico'
}

# Compile a separate Windows GUI executable for each application.
$CSharpCode = @"
using System;
using System.Diagnostics;
using System.IO;
using System.Text;
using System.Windows.Forms;

namespace M365Bridge
{
    internal static class Program
    {
        // Quote an argument according to Windows command-line rules.
        private static string QuoteArgument(string value)
        {
            if (value == null)
                value = String.Empty;

            StringBuilder result = new StringBuilder();
            result.Append('"');

            int backslashes = 0;

            foreach (char c in value)
            {
                if (c == '\\')
                {
                    backslashes++;
                }
                else if (c == '"')
                {
                    result.Append('\\', backslashes * 2 + 1);
                    result.Append('"');
                    backslashes = 0;
                }
                else
                {
                    result.Append('\\', backslashes);
                    result.Append(c);
                    backslashes = 0;
                }
            }

            // Trailing backslashes must be doubled before the closing quote.
            result.Append('\\', backslashes * 2);
            result.Append('"');

            return result.ToString();
        }

        [STAThread]
        private static void Main(string[] args)
        {
            if (args.Length == 0 || String.IsNullOrWhiteSpace(args[0]))
                return;

            string targetFile = args[0];

            string scriptPath = Path.Combine(
                AppDomain.CurrentDomain.BaseDirectory,
                "OpenOnline.ps1"
            );

            if (!File.Exists(scriptPath))
            {
                MessageBox.Show(
                    "M365 Bridge could not find OpenOnline.ps1.",
                    "M365 Bridge Error",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error
                );
                return;
            }

            try
            {
                ProcessStartInfo startInfo = new ProcessStartInfo();

                startInfo.FileName = "powershell.exe";
                startInfo.Arguments =
                    "-NoLogo -NoProfile -NonInteractive " +
                    "-ExecutionPolicy Bypass -WindowStyle Hidden " +
                    "-File " + QuoteArgument(scriptPath) + " " +
                    QuoteArgument(targetFile);

                startInfo.UseShellExecute = false;
                startInfo.CreateNoWindow = true;
                startInfo.WindowStyle = ProcessWindowStyle.Hidden;

                Process.Start(startInfo);
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    "M365 Bridge could not start PowerShell.\r\n\r\n" +
                    ex.Message,
                    "M365 Bridge Error",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Error
                );
            }
        }
    }
}
"@

# Initialize the .NET Framework CodeDom compiler provider.
$Provider = $null

try {
    Add-Type -AssemblyName System
    Add-Type -AssemblyName System.Core
    Add-Type -AssemblyName System.Drawing
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName Microsoft.CSharp

    $Provider = New-Object Microsoft.CSharp.CSharpCodeProvider

    foreach ($AppName in $BridgeApps.Keys) {
        $IconFile = $BridgeApps[$AppName]
        $IconPath = Join-Path $SrcFolder $IconFile
        $OutputExe = Join-Path $SrcFolder ($AppName + '.exe')

        Write-Host ""
        Write-Host "Building $AppName.exe..." -ForegroundColor Cyan

        $CompilerParameters = New-Object `
            System.CodeDom.Compiler.CompilerParameters

        $CompilerParameters.GenerateExecutable = $true
        $CompilerParameters.GenerateInMemory = $false
        $CompilerParameters.IncludeDebugInformation = $false
        $CompilerParameters.OutputAssembly = $OutputExe
        $CompilerParameters.CompilerOptions = '/target:winexe'

        [void]$CompilerParameters.ReferencedAssemblies.Add('System.dll')
        [void]$CompilerParameters.ReferencedAssemblies.Add(
            'System.Windows.Forms.dll'
        )
        [void]$CompilerParameters.ReferencedAssemblies.Add(
            'System.Core.dll'
        )

        # Embed the application's native icon if it exists.
        if (Test-Path -LiteralPath $IconPath -PathType Leaf) {
            $CompilerParameters.CompilerOptions +=
                ' /win32icon:"' + $IconPath + '"'

            Write-Host "  Icon: $IconFile" -ForegroundColor Gray
        }
        else {
            Write-Warning "Icon not found; using the default icon: $IconPath"
        }

        # Compile to disk using the installed CodeDom provider.
        $Results = $Provider.CompileAssemblyFromSource(
            $CompilerParameters,
            $CSharpCode
        )

        $Errors = @(
            $Results.Errors |
                Where-Object { -not $_.IsWarning }
        )

        if ($Errors.Count -gt 0) {
            Write-Host "[FAILED] $AppName.exe" -ForegroundColor Red

            foreach ($ErrorItem in $Errors) {
                Write-Host (
                    "  Line {0}, Column {1}: {2}" -f
                    $ErrorItem.Line,
                    $ErrorItem.Column,
                    $ErrorItem.ErrorText
                ) -ForegroundColor Red
            }

            throw "Compilation failed for $AppName.exe."
        }

        if (-not (Test-Path -LiteralPath $OutputExe -PathType Leaf)) {
            throw "Compiler reported no errors but output is missing: $OutputExe"
        }

        Write-Host "[SUCCESS] $OutputExe" -ForegroundColor Green
    }

    Write-Host ""
    Write-Host "All M365 Bridge wrappers compiled successfully." `
        -ForegroundColor Green
}
finally {
    if ($null -ne $Provider) {
        $Provider.Dispose()
    }
}
