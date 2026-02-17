tableextension 14304317 "AQD CMPurchases&PayablesSetup" extends "Purchases & Payables Setup"
{
    fields
    {
        field(14304309; "AQD Vendor Comment Code"; Code[20])
        {
            TableRelation = "Comment Line".Code;
            DataClassification = CustomerContent;
            Caption = 'Vendor Comment Code';
        }
    }
}
