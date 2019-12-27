page 50105 "Items Attachment"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Document Attachment";
    SourceTableView = order(descending);
    RefreshOnActivate = true;
    Permissions = TableData "17" = IMD, Tabledata "36" = IMD, Tabledata "37" = IMD, Tabledata "38" = IMD, Tabledata "39" = IMD, Tabledata "81" = IMD, Tabledata "21" = IMD, Tabledata "25" = IMD, Tabledata "32" = IMD, Tabledata "110" = IMD, TableData "111" = IMD, TableData "112" = IMD, TableData "113" = IMD, TableData "114" = IMD, TableData "115" = IMD, TableData "120" = IMD, Tabledata "121" = IMD, Tabledata "122" = IMD, Tabledata "123" = IMD, Tabledata "124" = IMD, Tabledata "125" = IMD, Tabledata "169" = IMD, Tabledata "379" = IMD, Tabledata "380" = IMD, Tabledata "271" = IMD, Tabledata "5802" = IMD;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("File Name"; "File Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    trigger OnDrillDown()
                    var
                        myInt: Integer;
                        FileManagement: Codeunit "File Management";
                        TempBlob: Codeunit "Temp Blob";
                        FilterTxt: Label '*.jpg;*.jpeg;*.bmp;*.png;*.gif;*.tiff;*.tif;*.pdf;*.docx;*.doc;*.xlsx;*.xls;*.pptx;*.ppt;*.msg;*.xml;*.*';
                        ImportTxt: Label 'Attach a document.';
                        FileDialogTxt: Label 'Attachments (%1)|%1';
                        FileName: Text;
                        FromRecRef: RecordRef;

                    begin
                        IF Recs.Get(Rec."No.") then;
                        FromRecRef.GetTable(Recs);
                        IF "Document Reference ID".HASVALUE THEN
                            Export2(TRUE)
                        ELSE BEGIN
                            FileName := FileManagement.BLOBImportWithFilter(TempBlob, ImportTxt, FileName, STRSUBSTNO(FileDialogTxt, FilterTxt), FilterTxt);
                            SaveAttachment2(FromRecRef, FileName, TempBlob, Recs."No.");
                            CurrPage.UPDATE(FALSE);
                        END;

                    end;
                }
                field("File Type"; "File Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("File Extension"; "File Extension")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(User; User)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Attached Date"; "Attached Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }

    }
    var
        Recs: Record Item; //Change the Table Name Here----OLISTER


    procedure Export2(ShowFileDialog: Boolean): Text
    var
        FullFileName: Text;
        DocumentStream: OutStream;
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
    begin

        IF ID = 0 THEN
            EXIT;
        // Ensure document has value in DB
        IF NOT "Document Reference ID".HASVALUE THEN
            EXIT;

        FullFileName := "File Name" + '.' + "File Extension";
        TempBlob.CREATEOUTSTREAM(DocumentStream);
        "Document Reference ID".EXPORTSTREAM(DocumentStream);
        EXIT(FileManagement.BLOBExport(TempBlob, FullFileName, ShowFileDialog));
    end;

    procedure SaveAttachment2(RecRef: RecordRef; FileName: Text; TempBlob: Codeunit "Temp Blob"; OpportunityNo: Code[30])
    var
        IncomingFileName2: Text;
        DocStream2: Instream;
        EmptyFileNameErr: Label 'No content';
        FileManagement: Codeunit "File Management";
        NoDocumentAttachedErr: Label 'No document attached';
        FieldRef: FieldRef;
        LineNo: Integer;
        Rec_Document: Record "Document Attachment";
        Rec_Attachment: Record "Document Attachment";
    begin
        IF FileName = '' THEN
            ERROR(EmptyFileNameErr);
        // Validate file/media is not empty
        IF NOT TempBlob.HASVALUE THEN
            ERROR(EmptyFileNameErr);
        IncomingFileName2 := FileName;
        Clear(Rec_Attachment);
        Rec_Attachment.Reset();
        Rec_Attachment.INIT;
        Rec_Attachment.VALIDATE("File Extension", FileManagement.GetExtension(IncomingFileName2));
        Rec_Attachment.VALIDATE("File Name", COPYSTR(FileManagement.GetFileNameWithoutExtension(IncomingFileName2), 1, MAXSTRLEN("File Name")));
        Rec_Attachment.Validate("Document Type", "Document Type"::Order);
        Rec_Attachment.VALIDATE("Table ID", RecRef.NUMBER);
        Rec_Attachment.Validate("No.", Recs."No.");
        TempBlob.CREATEINSTREAM(DocStream2);
        Rec_Attachment."Document Reference ID".IMPORTSTREAM(DocStream2, '', IncomingFileName2);
        IF NOT Rec_Attachment."Document Reference ID".HASVALUE THEN
            ERROR(NoDocumentAttachedErr);
        CASE RecRef.NUMBER OF
            DATABASE::Opportunity:
                BEGIN
                    FieldRef := RecRef.FIELD(1);
                    Clear(Rec_Document);
                    Rec_Document.SetRange("Table ID", RecRef.Number);
                    Rec_Document.SetRange("No.", Recs."No.");
                    IF Rec_Document.FindLast() then begin
                        Rec_Attachment.Validate("Line No.", Rec_Document."Line No." + 1000);
                    end
                    else begin
                        Rec_Attachment.Validate("Line No.", 1000);
                    end;

                END;
        END;
        Rec_Attachment.INSERT(TRUE);
    end;



}