tableextension 14304313 "AQD COMTransferHeader" extends "Transfer Header"
{
    fields
    {
        field(14304309; "AQD Co-Man No."; Code[20])
        {
            TableRelation = "AQD Co-Man Header"."No.";
            DataClassification = CustomerContent;
            Caption = 'Co-Man No.';
        }
    }
}
