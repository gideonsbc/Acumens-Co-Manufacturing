pageextension 14304311 COMReleasedProductionOrder extends "Released Production Order"
{
    layout
    {
        addafter("Location Code")
        {
            field("In-Transfer Order No."; Rec."In-Transfer Order No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
