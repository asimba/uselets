var fso = new ActiveXObject("Scripting.FileSystemObject");
var docPath = WScript.Arguments(0);
docPath = fso.GetAbsolutePathName(docPath);

var pdfPath = docPath.replace(/\.docx[^.]*$/i,".pdf");
var objWord = null;

try
{
    WScript.Echo("Saving '" + docPath + "' as '" + pdfPath + "'...");

    objWord = new ActiveXObject("Word.Application");
    objWord.Visible = false;

    var objDoc = objWord.Documents.Open(docPath);

    var wdFormatPdf = 17;
    objDoc.SaveAs(pdfPath, wdFormatPdf);
    objDoc.Close();

    WScript.Echo("Done.");
}
finally
{
    if (objWord != null)
    {
        objWord.Quit();
    }
}
