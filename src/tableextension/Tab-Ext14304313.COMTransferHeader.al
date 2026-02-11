tableextension 14304313 COMTransferHeader extends "Transfer Header"
{
    fields
    {
        field(64000; "Co-Man No."; Code[20])
        {
            TableRelation = "Co-Man Header"."No.";
        }
    }
}
