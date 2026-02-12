tableextension 14304316 "AQD CMStockkeepingUnit" extends "Stockkeeping Unit"
{
    fields
    {
        field(14304309; "AQD WIP Item"; Code[20])
        {
            TableRelation = Item."No.";
            DataClassification = CustomerContent;
            Caption = 'WIP Item';
        }
    }
}
