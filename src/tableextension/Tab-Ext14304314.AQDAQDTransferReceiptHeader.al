tableextension 14304314 "AQD AQDTransferReceiptHeader" extends "Transfer Receipt Header"
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
