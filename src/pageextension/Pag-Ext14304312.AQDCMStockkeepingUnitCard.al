pageextension 14304312 "AQD CMStockkeepingUnitCard" extends "Stockkeeping Unit Card"
{
    layout
    {
        addafter(General)
        {
            group("AQD Acumens Co-Manufacturing")
            {
                Caption = 'Acumens Co-Manufacturing';
                field("AQD WIP Item"; Rec."AQD WIP Item")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the WIP Item field.';
                    Caption = 'WIP Item';
                }
            }
        }
    }
}
