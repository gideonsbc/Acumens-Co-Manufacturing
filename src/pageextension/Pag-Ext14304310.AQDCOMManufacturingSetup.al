pageextension 14304310 "AQD COMManufacturingSetup" extends "Manufacturing Setup"
{
    layout
    {
        addafter(General)
        {
            group("AQD Acumens Co-Manufacturing")
            {
                Caption = 'Acumens Co-Manufacturing';
                field("AQD Co-Man No. Series"; Rec."AQD Co-Man No. Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Co-Man No. Series field.';
                    Caption = 'Co-Man No. Series';
                }
                field("AQD Subcon Template Name"; Rec."AQD Subcon Template Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Worksheet Template Name field.';
                    Caption = 'Worksheet Template Name';
                }
                field("AQD Subc. Batch Name"; Rec."AQD Subc. Batch Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Journal Batch Name field.';
                    Caption = 'Journal Batch Name';
                }
            }
        }
    }
}
