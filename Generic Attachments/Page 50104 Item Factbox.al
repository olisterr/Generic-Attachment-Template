page 50104 "ItemAttachments"
{
    PageType = CardPart;
    SourceTable = Item;//Change the Table Name Here----OLISTER

    layout
    {
        area(Content)
        {

            field(Attachments; Attachments)
            {
                ApplicationArea = All;
                Editable = false;
                trigger OnDrillDown()
                var
                    Recs: Record "Document Attachment";
                begin
                    Clear(Page_DcoumentAttachment);
                    Clear(Recs);
                    Recs.Reset();
                    Recs.SetRange("No.", Rec."No.");
                    IF Recs.FindFirst() then;
                    Page_DcoumentAttachment.SetRecord(Recs);
                    Page_DcoumentAttachment.SetTableView(Recs);
                    Page_DcoumentAttachment.RunModal();
                    Clear(Rec_DocumentAttachment);
                    Clear(Attachments);
                    Rec_DocumentAttachment.Reset();
                    Rec_DocumentAttachment.SetRange("No.", Rec."No.");
                    IF Rec_DocumentAttachment.FindSet() then
                        Attachments := Rec_DocumentAttachment.Count;
                end;
            }

        }
    }


    var
        Attachments: Integer;
        Rec_DocumentAttachment: Record "Document Attachment";
        Page_DcoumentAttachment: Page "Items Attachment";//Change the Page Name Here----OLISTER

    trigger OnAfterGetRecord()
    begin
        Clear(Attachments);
        Clear(Rec_DocumentAttachment);
        Rec_DocumentAttachment.Reset();
        Rec_DocumentAttachment.SetRange("No.", Rec."No.");
        IF Rec_DocumentAttachment.FindSet() then
            Attachments := Rec_DocumentAttachment.Count;
    end;
}