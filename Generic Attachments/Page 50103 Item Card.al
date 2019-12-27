
pageextension 50103 ItemExt extends "Item Card"
{
    layout
    {
        // Add changes to page layout here
        addfirst(factboxes)
        {
            part("Attachments"; "ItemAttachments")//Change the Part Page Name Here----OLISTER 
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
            }
        }
    }


}