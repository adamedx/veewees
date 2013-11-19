' Taken from:
' http://msdn.microsoft.com/en-us/library/windows/desktop/aa387102(v=vs.85).aspx
'
Set updateSession = CreateObject("Microsoft.Update.Session")
updateSession.ClientApplicationID = "Opscode update installer for Windows"

Set updateSearcher = updateSession.CreateUpdateSearcher()

WScript.Echo "Searching for updates..." & vbCRLF

Set searchResult = _
updateSearcher.Search("IsInstalled=0 and Type='Software' and IsHidden=0")

WScript.Echo "List of applicable items on the machine:"

For I = 0 To searchResult.Updates.Count-1
    Set update = searchResult.Updates.Item(I)
    WScript.Echo I + 1 & "> " & update.Title
Next

If searchResult.Updates.Count = 0 Then
    WScript.Echo "There are no applicable updates."    
    WScript.Echo "Initiating sysprep and shutdown."    
    set wshshell = wscript.createobject("wscript.shell")
    wshshell.run "c:\windows\system32\sysprep\sysprep.exe /generalize /oobe /quit /unattend:a:\sysprep.xml", , true
    wshshell.run "shutdown -s -t 1", , true
    Wscript.echo "Finished installing updates."
    WScript.Quit
End If

WScript.Echo vbCRLF & "Creating collection of updates to download:"

Set updatesToDownload = CreateObject("Microsoft.Update.UpdateColl")

For I = 0 to searchResult.Updates.Count-1
    Set update = searchResult.Updates.Item(I)
    addThisUpdate = false
    If update.InstallationBehavior.CanRequestUserInput = true Then
        WScript.Echo I + 1 & "> skipping: " & update.Title & _
        " because it requires user input"
    Else
        addThisUpdate = true
        If update.EulaAccepted = false Then
            WScript.Echo I + 1 & "> note: " & update.Title & _
            " has a license agreement that must be accepted:"
            WScript.Echo update.EulaText
            WScript.Echo "Opscode Accepts this agreement."
            update.AcceptEula()
        End If
    End If
    If addThisUpdate = true Then
        WScript.Echo I + 1 & "> adding: " & update.Title 
        updatesToDownload.Add(update)
    End If
Next

If updatesToDownload.Count = 0 Then
    WScript.Echo "All applicable updates were skipped."
    WScript.Echo "Initiating sysprep and shutdown."    
    set wshshell = wscript.createobject("wscript.shell")
    wshshell.run "c:\windows\system32\sysprep\sysprep.exe /generalize /oobe /quit /unattend:a:\sysprep.xml", , true
    wshshell.run "shutdown -s -t 1", , true
    WScript.Echo "Finished installing updates."    
    WScript.Quit
End If
    
WScript.Echo vbCRLF & "Downloading updates..."

Set downloader = updateSession.CreateUpdateDownloader() 
downloader.Updates = updatesToDownload
downloader.Download()

Set updatesToInstall = CreateObject("Microsoft.Update.UpdateColl")

rebootMayBeRequired = false

WScript.Echo vbCRLF & "Successfully downloaded updates:"

For I = 0 To searchResult.Updates.Count-1
    set update = searchResult.Updates.Item(I)
    If update.IsDownloaded = true Then
        WScript.Echo I + 1 & "> " & update.Title 
        updatesToInstall.Add(update)             
        If update.InstallationBehavior.RebootBehavior > 0 Then
            rebootMayBeRequired = true
        End If
    End If
Next

If updatesToInstall.Count = 0 Then
    WScript.Echo "No updates were successfully downloaded."
    WScript.Quit
End If

If rebootMayBeRequired = true Then
    WScript.Echo vbCRLF & "These updates may require a reboot."
End If


WScript.Echo "Installing updates..."
Set installer = updateSession.CreateUpdateInstaller()
installer.Updates = updatesToInstall
Set installationResult = installer.Install()
    
'Output results of install
WScript.Echo "Installation Result: " & _
installationResult.ResultCode 
WScript.Echo "Reboot Required: " & _ 
installationResult.RebootRequired & vbCRLF 
WScript.Echo "Listing of updates installed " & _
"and individual installation results:" 
    
For I = 0 to updatesToInstall.Count - 1
WScript.Echo I + 1 & "> " & _
    updatesToInstall.Item(i).Title & _
    ": " & installationResult.GetUpdateResult(i).ResultCode                 
Next

WScript.Echo vbCRLF & "Rebooting..."
set wshshell = wscript.createobject("wscript.shell")
wshshell.run "shutdown /r /t 3"



