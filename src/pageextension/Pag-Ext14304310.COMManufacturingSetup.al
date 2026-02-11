pageextension 14304310 COMManufacturingSetup extends "Manufacturing Setup"
{
    layout
    {
        addafter("Routing Nos.")
        {
            field("Co-Man No. Series"; Rec."Co-Man No. Series")
            {
                ApplicationArea = All;
            }
            field("Subcon Template Name"; Rec."Subcon Template Name")
            {
                ApplicationArea = All;
            }
            field("Subc. Batch Name"; Rec."Subc. Batch Name")
            {
                ApplicationArea = All;
            }
        }
    }
}
