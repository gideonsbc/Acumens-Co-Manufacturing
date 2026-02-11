tableextension 14304314 TransferReceiptHeader extends "Transfer Receipt Header"
{
    fields
    {
        field(64000; "Co-Man No."; Code[20])
        {
            TableRelation = "Co-Man Header"."No.";
        }
    }
}
