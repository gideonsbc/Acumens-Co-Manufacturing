pageextension 14304311 "AQD COMReleasedProductionOrder" extends "Released Production Order"
{
    layout
    {
        addafter(Posting)
        {
            group("AQD Acumens Co-Manufacturing")
            {
                Caption = 'Acumens Co-Manufacturing';
                field("AQD In-Transfer Order No."; Rec."AQD In-Transfer Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the In-Transfer Order No. field.';
                    Caption = 'In-Transfer Order No.';
                }
            }
        }
    }
}
