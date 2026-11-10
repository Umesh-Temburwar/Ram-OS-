' ============================================
'  RAM OS - open like an app (Desktop and Start menu shortcut target)
' ============================================
Option Explicit
Dim fso, sh, root, port, url
Set fso = CreateObject("Scripting.FileSystemObject")
Set sh = CreateObject("WScript.Shell")
root = fso.GetParentFolderName(WScript.ScriptFullName)

port = sh.ExpandEnvironmentStrings("%JAVIS_PORT%")
If port = "%JAVIS_PORT%" Or port = "" Then port = "7777"
url = "http://127.0.0.1:" & port

If ServerUp() Then
  OpenWindow
Else
  sh.Run "wscript.exe //nologo """ & root & "\start-ram.vbs"" /open", 0, False
End If

Function ServerUp()
  Dim http
  ServerUp = False
  On Error Resume Next
  Set http = CreateObject("MSXML2.ServerXMLHTTP.6.0")
  http.setTimeouts 2000, 2000, 2000, 2000
  http.Open "GET", url & "/health", False
  http.Send
  If Err.Number = 0 Then
    If http.Status = 200 Then ServerUp = True
  End If
  Err.Clear
  On Error GoTo 0
End Function

Sub OpenWindow()
  Dim cands, c
  cands = Array(sh.ExpandEnvironmentStrings("%ProgramFiles(x86)%") & "\Microsoft\Edge\Application\msedge.exe", _
                sh.ExpandEnvironmentStrings("%ProgramFiles%") & "\Microsoft\Edge\Application\msedge.exe", _
                sh.ExpandEnvironmentStrings("%ProgramFiles%") & "\Google\Chrome\Application\chrome.exe", _
                sh.ExpandEnvironmentStrings("%LocalAppData%") & "\Google\Chrome\Application\chrome.exe")
  For Each c In cands
    If fso.FileExists(c) Then
      sh.Run """" & c & """ --app=" & url, 1, False
      Exit Sub
    End If
  Next
  sh.Run url, 1, False
End Sub

