tableextension 14304309 COMProductionOrder extends "Production Order"
{
    fields
    {
        field(54000; "In-Transfer Order No."; Code[20])
        {
            TableRelation = "Transfer Header"."No.";
        }
        field(50004; "Co-Man No."; Code[20])
        {
            TableRelation = "Co-Man Header"."No.";
        }
    }
}
