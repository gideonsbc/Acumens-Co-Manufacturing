tableextension 14304315 CMPurchaseLine extends "Purchase Line"
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
        field(64000; "PO BOM"; Boolean)
        {
        }
    }
}
