tableextension 14304315 "AQD CMPurchaseLine" extends "Purchase Line"
{
    fields
    {
        modify("Line Amount")
        {
            trigger OnBeforeValidate()
            var
                Currency: Record Currency;
            begin
                if "Prod. Order No." <> '' then "Direct Unit Cost" := "Line Amount" / Quantity;
            end;
        }
        field(14304309; "AQD PO BOM"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'PO BOM';
        }
    }
}
