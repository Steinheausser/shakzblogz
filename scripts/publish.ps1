# One-step publish: tidy new files, check the site builds, then commit and push to GitHub.
param(
	[string]$Message,
	[switch]$NoPause
)

$repo = Split-Path $PSScriptRoot -Parent
Set-Location $repo

function Finish($code) {
	if (-not $NoPause) { Write-Host ''; Read-Host 'Press Enter to close' | Out-Null }
	exit $code
}

# Any .md dropped in without front matter gets a title (from the file name) and a date.
$utf8 = New-Object Text.UTF8Encoding $false
foreach ($dir in 'src\content\blog', 'src\content\poetry') {
	Get-ChildItem $dir -Filter *.md -File -ErrorAction SilentlyContinue | ForEach-Object {
		$body = [IO.File]::ReadAllText($_.FullName)
		if (-not $body.TrimStart([char]0xFEFF).StartsWith('---')) {
			$title = ($_.BaseName -replace '[-_]+', ' ').Trim().Replace('"', '\"')
			$date = $_.CreationTime.ToString('yyyy-MM-dd')
			[IO.File]::WriteAllText($_.FullName, "---`ntitle: `"$title`"`ndate: $date`n---`n`n" + $body.TrimStart([char]0xFEFF), $utf8)
			Write-Host "Added title/date to $($_.Name)"
		}
	}
}

$changes = git status --porcelain
if (-not $changes) { Write-Host 'Nothing new to publish - everything is already on GitHub.'; Finish 0 }

Write-Host 'Changes to publish:'
git status --short
Write-Host ''

if (-not $Message) { $Message = Read-Host 'Short note about this update (or just press Enter)' }
if (-not $Message.Trim()) { $Message = "Update site $(Get-Date -Format 'yyyy-MM-dd HH:mm')" }

Write-Host 'Checking the site builds...'
if (-not (Test-Path node_modules)) { npm install --silent }
npm run build --silent | Out-Null
if ($LASTEXITCODE -ne 0) {
	Write-Host ''
	Write-Host 'The site failed to build, so nothing was published. Error above.' -ForegroundColor Red
	npm run build
	Finish 1
}

git add -A
git commit -q -m $Message
git pull -q --rebase
git push -q
if ($LASTEXITCODE -ne 0) { Write-Host 'Push to GitHub failed - see the message above.' -ForegroundColor Red; Finish 1 }

Write-Host ''
Write-Host 'Published! The live site updates in about a minute:' -ForegroundColor Green
Write-Host 'https://steinheausser.github.io/shakzblogz/'
Finish 0
