pageextension 14304309 "AQD COMLocationCard" extends "Location Card"
{
    layout
    {
        addafter(General)
        {
            group("AQD Acumens Co-Manufacturing")
            {
                Caption = 'Acumens Co-Manufacturing';
                field("AQD Co-Man Location"; Rec."AQD Co-Man Location")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Co-Man Location field.';
                    Caption = 'Co-Man Location';
                }
                field("AQD Consume Blocked Lot"; Rec."AQD Consume Blocked Lot")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Consume Blocked Lot field.';
                    Caption = 'Consume Blocked Lot';
                }
                field("AQD BOM to PO"; Rec."AQD BOM to PO")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the BOM to PO field.';
                    Caption = 'BOM to PO';
                }
                field("AQD Balance Charge Item"; Rec."AQD Balance Charge Item")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Balance Charge Item field.';
                    Caption = 'Balance Charge Item';
                }
                field("AQD PO. to TR. Order"; Rec."AQD PO. to TR. Order")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PO. to TR. Order field.';
                    Caption = 'PO. to TR. Order';
                }
            }
        }
    }
}
