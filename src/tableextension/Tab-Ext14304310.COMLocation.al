tableextension 14304310 COMLocation extends Location
{
    fields
    {
        field(64000; "Co-Man Location"; Boolean)
        {
        }
        field(64001; "Consume Blocked Lot"; Boolean)
        {
        }
        field(64002; "BOM to PO"; Boolean)
        {
        }
        field(64003; "Balance Charge Item"; Code[20])
        {
            TableRelation = "Item Charge"."No.";
        }
        field(64004; "PO. to TR. Order"; Boolean)
        {
        }
    }
}
