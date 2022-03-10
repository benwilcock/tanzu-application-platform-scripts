################################################################
# Test the Developer workload on TAP                           #
# Requires `minikube tunnel` AND Edits to your `hosts` file.   #
# See 'stage-01.ps1' for details.                              #
################################################################

# Test the application is responding (may take a few seconds at first)
curl.exe http://tanzu-java-web-app.default.apps.made-up-name.net 

# Final confirmation
Write-Host "`n^^ Here you should see the words `"Greetings from Spring Boot + Tanzu!`" if the workload is responding." -ForegroundColor Blue -BackgroundColor Black