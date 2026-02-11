tableextension 14304316 CMStockkeepingUnit extends "Stockkeeping Unit"
{
    fields
    {
        field(64000; "WIP Item"; Code[20])
        {
            TableRelation = Item."No.";
        }
    }
}
