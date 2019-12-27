pageextension 50100 OpportunityExt extends "Opportunity Card"
{
    layout
    {
        // Add changes to page layout here
        addfirst(factboxes)
        {
            part("Attachments"; "Attachments")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
            }
        }
    }


}