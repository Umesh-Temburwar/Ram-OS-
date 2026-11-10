' ============================================
'  RAM OS - Background Service Launcher (Hidden Window)
'  Double-click to start RAM OS in background.
'  Logs are written to server\ram.log. Stop via stop-ram.bat.
' ============================================
Set fso = CreateObject("Scripting.FileSystemObject")
root = fso.GetParentFolderName(WScript.ScriptFullName)
Set sh = CreateObject("WScript.Shell")

' Stop any existing instance
sh.Run "cmd /c cd /d """ & root & """ && call """ & root & "\stop-ram.bat"" > server\stop-last.log 2>&1", 0, True

' Start RAM OS server in hidden window
sh.Run "cmd /c cd /d """ & root & """ && .venv\Scripts\python.exe server\main.py > server\ram.log 2>&1", 0, False

If WScript.Arguments.Count > 0 Then
  If LCase(WScript.Arguments(0)) = "/open" Then MoDashboard
End If

Sub MoDashboard()
  Dim port, url, i, http, ok, cands, c
  port = sh.ExpandEnvironmentStrings("%JAVIS_PORT%")
  If port = "%JAVIS_PORT%" Or port = "" Then port = "7777"
  url = "http://127.0.0.1:" & port
  ok = False
  For i = 1 To 60
    WScript.Sleep 1000
    On Error Resume Next
    Set http = CreateObject("MSXML2.ServerXMLHTTP.6.0")
    http.setTimeouts 2000, 2000, 2000, 2000
    http.Open "GET", url & "/health", False
    http.Send
    If Err.Number = 0 Then
      If http.Status = 200 Then ok = True
    End If
    Err.Clear
    On Error GoTo 0
    If ok Then Exit For
  Next
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

