param([string]$Directory = $PSScriptRoot)
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath $Directory).Path
$archiveName = 'FHCM-PCH-Review72-beta1-california.zip'
$manifest = Get-Content -LiteralPath (Join-Path $root 'FHCM-PCH-Review72-beta1-california.parts.json') -Raw | ConvertFrom-Json
if ($manifest.archive -cne $archiveName -or $manifest.sha256 -notmatch '^[0-9a-f]{64}$' -or
    $manifest.parts.Count -ne 7 -or $manifest.bytes -le 0) {
    throw 'This is not the manifest for PCH Review 72 Beta 1 California Plates.'
}
$destination = Join-Path $root $archiveName
if (Test-Path -LiteralPath $destination) {
    if ((Get-Item -LiteralPath $destination).Length -eq $manifest.bytes -and
        (Get-FileHash -LiteralPath $destination -Algorithm SHA256).Hash -eq $manifest.sha256) {
        Write-Output $destination
        return
    }
    throw 'A different ZIP already exists. Move it aside before joining these parts.'
}

$partial = Join-Path $root ($archiveName + '.' + [guid]::NewGuid().ToString('N') + '.partial')
try {
    $output = [IO.File]::Open($partial, [IO.FileMode]::CreateNew)
    try {
        for ($i = 0; $i -lt $manifest.parts.Count; $i++) {
            $part = $manifest.parts[$i]
            $expected = $archiveName + ('.{0:000}' -f ($i + 1))
            if ($part.name -cne $expected -or $part.sha256 -notmatch '^[0-9a-f]{64}$' -or $part.bytes -le 0) {
                throw ('Invalid part record for ' + $expected)
            }
            $file = Join-Path $root $expected
            $input = [IO.File]::Open($file, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::Read)
            try {
                $sha = [Security.Cryptography.SHA256]::Create()
                try { $received = [BitConverter]::ToString($sha.ComputeHash($input)).Replace('-', '') }
                finally { $sha.Dispose() }
                if ($input.Length -ne $part.bytes -or $received -ne $part.sha256) {
                    throw ('Invalid or incomplete download ' + $expected)
                }
                $input.Position = 0
                $input.CopyTo($output)
            } finally { $input.Dispose() }
        }
    } finally { $output.Dispose() }
    if ((Get-Item -LiteralPath $partial).Length -ne $manifest.bytes -or
        (Get-FileHash -LiteralPath $partial -Algorithm SHA256).Hash -ne $manifest.sha256) {
        throw 'Reassembled ZIP failed SHA-256 validation.'
    }
    [IO.File]::Move($partial, $destination)
    Write-Output $destination
} finally {
    if ([IO.File]::Exists($partial)) { [IO.File]::Delete($partial) }
}
