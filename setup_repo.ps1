$DEFAULT_GAME_PATH = "C:\Program Files (x86)\Steam\steamapps\common\dota 2 beta"
$DEFAULT_MAP_NAME = "muken_v2"

Write-Host "Game path " -NoNewline -ForegroundColor Green
Write-Host "[" -NoNewline
Write-Host "default: " -NoNewline -ForegroundColor Red
$game_path = Read-Host "$DEFAULT_GAME_PATH]"

if ($game_path -eq "") {
    $game_path = $DEFAULT_GAME_PATH
}
Write-Host "Map name " -NoNewline -ForegroundColor Green
Write-Host "[" -NoNewline
Write-Host "default: " -NoNewline -ForegroundColor Red
$map_name = Read-Host "$DEFAULT_MAP_NAME]"
if ($map_name -eq "") {
    $map_name = $DEFAULT_MAP_NAME
}

$CONTENT_FOLDER = "$game_path\content\dota_addons\$map_name"
$GAME_FOLDER = "$game_path\game\dota_addons\$map_name"


if ((Test-Path 'content') -or (Test-Path 'game')) {
    Write-Host "===========================================================" -ForegroundColor Red
    Write-Host "ERROR: " -NoNewline -ForegroundColor Red
    Write-Host "game or content folders still exist in the repo directory."
    Write-Host "Please move them to their respective locations."
    Write-Host "Content folder: " -NoNewline -ForegroundColor Cyan
    Write-Host "$CONTENT_FOLDER"
    Write-Host "Game folder: " -NoNewline -ForegroundColor Cyan
    Write-Host "$GAME_FOLDER"
    Write-Host "===========================================================" -ForegroundColor Red
    Exit
}




if (!(Test-Path $CONTENT_FOLDER)) {
    Write-Host "Content folder: " -NoNewline -ForegroundColor Cyan
    Write-Host "$CONTENT_FOLDER"
    Write-Host "Content folder does not exist. Please move the content folder to the location specified above" -ForegroundColor Red
    Exit
}

if (!(Test-Path $GAME_FOLDER)) {
    Write-Host "Game folder: " -NoNewline -ForegroundColor Cyan
    Write-Host "$GAME_FOLDER"
    Write-Host "Game folder does not exist. Please move the game folder" -ForegroundColor Red
    Exit
}



New-Item -ItemType Junction -Path "game" -Value "$GAME_FOLDER"
if (!($?)) {
    Write-Host "Failed to create 'game' juntion link." -ForegroundColor Red
}
else {
    Write-Host "Successfully created 'game' juntion link." -ForegroundColor Green
}
New-Item -ItemType Junction -Path "content" -Value "$CONTENT_FOLDER"
if (!($?)) {
    Write-Host "Failed to create 'content' juntion link." -ForegroundColor Red
}
else {
    Write-Host "Successfully created 'content' juntion link." -ForegroundColor Green
}