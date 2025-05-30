Attribute VB_Name = "Module1"

Sub ExportQueriesToFolderWithFileName()
    Dim qdf As QueryDef
    Dim db As DAO.Database
    Dim folderPath As String
    Dim fileName As String
    Dim exportFile As Integer
    Dim accFileName As String
    Dim fso As Object

    ' Access file name without path and extension
    accFileName = Mid(CurrentDb.Name, InStrRev(CurrentDb.Name, "\") + 1)
    accFileName = Left(accFileName, InStrRev(accFileName, ".") - 1)

    ' Desktop folder
    folderPath = Environ("USERPROFILE") & "\Desktop\AccessExport\"

    ' Create folder if it doesn't exist
    Set fso = CreateObject("Scripting.FileSystemObject")
    If Not fso.FolderExists(folderPath) Then
        fso.CreateFolder folderPath
    End If

    ' File name for queries
    fileName = folderPath & "queries_" & accFileName & ".txt"

    ' Export queries
    Set db = CurrentDb
    exportFile = FreeFile
    Open fileName For Output As #exportFile

    For Each qdf In db.QueryDefs
        If Left(qdf.Name, 1) <> "~" Then
            Print #exportFile, "-- " & qdf.Name
            Print #exportFile, qdf.SQL
            Print #exportFile, ""
        End If
    Next qdf

    Close #exportFile

    MsgBox "Queries saved as: " & fileName, vbInformation
End Sub
