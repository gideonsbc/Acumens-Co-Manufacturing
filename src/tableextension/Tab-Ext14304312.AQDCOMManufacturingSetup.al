tableextension 14304312 "AQD COMManufacturingSetup" extends "Manufacturing Setup"
{
    fields
    {
        field(14304309; "AQD Co-Man No. Series"; Code[20])
        {
            TableRelation = "No. Series".Code;
            DataClassification = CustomerContent;
            Caption = 'Co-Man No. Series';
        }
        field(14304310; "AQD Subcon Template Name"; Code[10])
        {
            Caption = 'Worksheet Template Name';
            TableRelation = "Req. Wksh. Template";
            DataClassification = CustomerContent;
        }
        field(14304311; "AQD Subc. Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Requisition Wksh. Name".Name where("Worksheet Template Name" = field("AQD Subcon Template Name"));
            DataClassification = CustomerContent;
        }
    }
}
