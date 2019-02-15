$webclient=New-Object System.Net.WebClient

Write-Host "Downloading Erlang..."
if (-Not (Test-Path "$env:erlang_exe_path")) { 
    $webclient.DownloadFile("$env:erlang_download_url", "$env:erlang_exe_path")
} else {
    Write-Host "Found" $env:erlang_exe_path "in cache."
}

Write-Host "Installing Erlang to" $env:erlang_home_dir "..."
mkdir $env:erlang_home_dir
cd $env:erlang_home_dir
& $env:erlang_exe_path "/S"

Write-Host "Downloading RabbitMQ..."
if (-Not (Test-Path "$env:rabbitmq_installer_path")) {
    $webclient.DownloadFile("$env:rabbitmq_installer_download_url", "$env:rabbitmq_installer_path")
} else {
    Write-Host "Found" $env:rabbitmq_installer_path "in cache."
}

Write-Host "Creating directory" $env:AppData "\RabbitMQ..."
New-Item -ItemType Directory -ErrorAction Continue -Path "$env:AppData/RabbitMQ"

Write-Host "Creating Erlang cookie files..."
[System.IO.File]::WriteAllText("C:\Users\appveyor\.erlang.cookie", "PYAMQP", [System.Text.Encoding]::ASCII)
[System.IO.File]::WriteAllText("C:\Windows\System32\config\systemprofile\.erlang.cookie", "PYAMQP", [System.Text.Encoding]::ASCII)

Write-Host "Installing and starting RabbitMQ with default config..."
& $env:rabbitmq_installer_path '/S' | Out-Null
(Get-Service -Name RabbitMQ).Status

# wait 60 seconds to start RabbitMQ
Start-Sleep -Seconds 60

Write-Host "Getting RabbitMQ status..."
cmd /c "C:\Program Files\RabbitMQ Server\rabbitmq_server-$env:rabbitmq_version\sbin\rabbitmqctl.bat" status
