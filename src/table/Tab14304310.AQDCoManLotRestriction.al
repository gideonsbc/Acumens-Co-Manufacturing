table 14304310 "AQD Co-Man Lot Restriction"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Co-Man No."; Code[20])
        {
            TableRelation = "AQD Co-Man Header"."No.";
            Caption = 'Co-Man No.';
        }
        field(3; "Item No."; Code[20])
        {
            TableRelation = Item."No.";
            Caption = 'Item No.';
        }
        field(4; "Variant No."; Code[10])
        {
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."));
            Caption = 'Variant No.';
        }
        field(5; "Lot No."; Code[50])
        {
            TableRelation = "Lot No. Information"."Lot No." where("Item No." = field("Item No."));
            ValidateTableRelation = false;
            Caption = 'Lot No.';
        }
        field(6; "Restriction Code"; Code[40])
        {
            TableRelation = "Warehouse Restriction"."Code" where(Status = field("Restriction Status"));
            Caption = 'Restriction Code';
        }
        field(7; "Restriction Status"; Code[10])
        {
            TableRelation = "Warehouse Restriction Status".Code;
            Caption = 'Restriction Status';
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
