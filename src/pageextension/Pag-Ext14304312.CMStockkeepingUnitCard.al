pageextension 14304312 CMStockkeepingUnitCard extends "Stockkeeping Unit Card"
{
    layout
    {
        addafter("Production BOM No.")
        {
            field("WIP Item"; Rec."WIP Item")
            {
                ApplicationArea = All;
            }
        }
    }
}
