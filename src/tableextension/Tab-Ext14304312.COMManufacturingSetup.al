tableextension 14304312 COMManufacturingSetup extends "Manufacturing Setup"
{
    fields
    {
        field(64000; "Co-Man No. Series"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(64001; "Subcon Template Name"; Code[10])
        {
            Caption = 'Worksheet Template Name';
            TableRelation = "Req. Wksh. Template";
        }
        field(64002; "Subc. Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Requisition Wksh. Name".Name where("Worksheet Template Name" = field("Subcon Template Name"));
        }
    }
}
