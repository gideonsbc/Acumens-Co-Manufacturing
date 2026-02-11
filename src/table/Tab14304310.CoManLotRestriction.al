table 14304310 "Co-Man Lot Restriction"
{
    fields
    {
        field(1; "Co-Man No."; Code[20])
        {
            TableRelation = "Co-Man Header"."No.";
        }
        field(3; "Item No."; Code[20])
        {
            TableRelation = Item."No.";
        }
        field(4; "Variant No."; Code[10])
        {
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."));
        }
        field(5; "Lot No."; Code[50])
        {
            TableRelation = "Lot No. Information"."Lot No." where("Item No." = field("Item No."));
            ValidateTableRelation = false;
        }
        field(6; "Restriction Code"; Code[40])
        {
            TableRelation = "Warehouse Restriction"."Code" where(Status = field("Restriction Status"));
        }
        field(7; "Restriction Status"; Code[10])
        {
            TableRelation = "Warehouse Restriction Status".Code;
        }
    }
    keys
    {
        key(Key1; "Co-Man No.", "Item No.", "Variant No.", "Lot No.")
        {
            Clustered = true;
        }
    }
}
