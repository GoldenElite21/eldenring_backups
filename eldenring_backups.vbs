Option Explicit

Dim objShell, saveDirectory, backupDirectory, folder, saveFilePath
Dim latestBackup, lastModifiedTime, currentModifiedTime, fso, folderObj, backupFilePath, timestamp, scriptPath, scriptFolder
Set objShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' Get the path of the script
scriptPath = WScript.ScriptFullName
scriptFolder = fso.GetParentFolderName(scriptPath)

' Define the paths
saveDirectory = objShell.ExpandEnvironmentStrings("%APPDATA%") & "\EldenRing"
backupDirectory = scriptFolder & "\eldenring_backups"

' Ensure the backup directory exists
If Not fso.FolderExists(backupDirectory) Then
    fso.CreateFolder(backupDirectory)
End If

' Find the Elden Ring save file
Set folder = fso.GetFolder(saveDirectory)
For Each folderObj In folder.SubFolders
    saveFilePath = folderObj.Path & "\ER0000.sl2"
    Exit For
Next

' Get the last modified time of the latest backup file
If fso.FolderExists(backupDirectory) Then
    Set folder = fso.GetFolder(backupDirectory)
    If folder.Files.Count > 0 Then
        Set latestBackup = Nothing
        For Each folderObj In folder.Files
            If latestBackup Is Nothing Then
                Set latestBackup = folderObj
            ElseIf folderObj.DateLastModified > latestBackup.DateLastModified Then
                Set latestBackup = folderObj
            End If
        Next
        lastModifiedTime = latestBackup.DateLastModified
    Else
        lastModifiedTime = "1/1/1970 12:00:00 AM"
    End If
Else
    lastModifiedTime = "1/1/1970 12:00:00 AM"
End If

' Function to create a backup
Sub BackupSaveFile()
    timestamp = Year(Now) & Right("0" & Month(Now), 2) & Right("0" & Day(Now), 2) & Right("0" & Hour(Now), 2) & Right("0" & Minute(Now), 2) & Right("0" & Second(Now), 2)
    backupFilePath = backupDirectory & "\ER0000_" & timestamp & ".sl2"
    fso.CopyFile saveFilePath, backupFilePath
End Sub

' Check if Elden Ring is running
If IsProcessRunning("eldenring.exe") Then
    currentModifiedTime = fso.GetFile(saveFilePath).DateLastModified
    If currentModifiedTime > lastModifiedTime Then
        BackupSaveFile()
    End If
End If

Function IsProcessRunning(process)
    Dim objWMIService, colProcessList, objProcess
    Set objWMIService = GetObject("winmgmts:\\.\root\CIMV2")
    Set colProcessList = objWMIService.ExecQuery("Select * from Win32_Process Where Name = '" & process & "'")
    If colProcessList.Count > 0 Then
        IsProcessRunning = True
    Else
        IsProcessRunning = False
    End If
End Function
