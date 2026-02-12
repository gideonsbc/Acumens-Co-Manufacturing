tableextension 14304309 "AQD COMProductionOrder" extends "Production Order"
{
    fields
    {
        field(14304309; "AQD In-Transfer Order No."; Code[20])
        {
            TableRelation = "Transfer Header"."No.";
            DataClassification = CustomerContent;
            Caption = 'In-Transfer Order No.';
        }
        field(14304310; "AQD Co-Man No."; Code[20])
        {
            TableRelation = "AQD Co-Man Header"."No.";
            DataClassification = CustomerContent;
            Caption = 'Co-Man No.';
        }
    }
}
