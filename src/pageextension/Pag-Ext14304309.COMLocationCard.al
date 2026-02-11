pageextension 14304309 COMLocationCard extends "Location Card"
{
    layout
    {
        addafter("From-Production Bin Code")
        {
            field("Co-Man Location"; Rec."Co-Man Location")
            {
                ApplicationArea = All;
            }
            field("Consume Blocked Lot"; Rec."Consume Blocked Lot")
            {
                ApplicationArea = All;
            }
            field("BOM to PO"; Rec."BOM to PO")
            {
                ApplicationArea = All;
            }
            field("Balance Charge Item"; Rec."Balance Charge Item")
            {
                ApplicationArea = All;
            }
            field("PO. to TR. Order"; Rec."PO. to TR. Order")
            {
                ApplicationArea = All;
            }
        }
    }
}
