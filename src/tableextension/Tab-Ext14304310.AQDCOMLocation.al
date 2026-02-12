tableextension 14304310 "AQD COMLocation" extends Location
{
    fields
    {
        field(14304309; "AQD Co-Man Location"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Co-Man Location';
        }
        field(14304310; "AQD Consume Blocked Lot"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Consume Blocked Lot';
        }
        field(14304311; "AQD BOM to PO"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'BOM to PO';
        }
        field(14304312; "AQD Balance Charge Item"; Code[20])
        {
            TableRelation = "Item Charge"."No.";
            DataClassification = CustomerContent;
            Caption = 'Balance Charge Item';
        }
        field(14304313; "AQD PO. to TR. Order"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'PO. to TR. Order';
        }
    }
}
