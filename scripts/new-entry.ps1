# Creates a new blog post or poem with the front matter filled in, then opens it.
param(
	[Parameter(Mandatory)] [ValidateSet('blog', 'poetry')] [string]$Type,
	[string]$Title,
	[switch]$NoOpen
)

$ErrorActionPreference = 'Stop'
$repo = Split-Path $PSScriptRoot -Parent
$kind = if ($Type -eq 'poetry') { 'poem' } else { 'blog post' }

if (-not $Title) { $Title = Read-Host "Title of your new $kind" }
if (-not $Title.Trim()) { Write-Host 'No title given - nothing created.'; exit 1 }

$slug = ($Title.ToLower() -replace "['$([char]0x2019)]", '' -replace '[^a-z0-9]+', '-').Trim('-')
if (-not $slug) { $slug = 'untitled' }
$path = Join-Path $repo "src\content\$Type\$slug.md"
if (Test-Path $path) { Write-Host "A file called $slug.md already exists - opening it instead." }
else {
	$date = Get-Date -Format 'yyyy-MM-dd'
	$safeTitle = $Title.Replace('"', '\"')
	$text = "---`ntitle: `"$safeTitle`"`ndate: $date`ndraft: false`n---`n`n"
	[IO.File]::WriteAllText($path, $text, (New-Object Text.UTF8Encoding $false))
	Write-Host "Created $path"
}

if (-not $NoOpen) {
	try { Invoke-Item $path } catch { Start-Process notepad.exe $path }
}
