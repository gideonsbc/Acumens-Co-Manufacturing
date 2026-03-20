
tableextension 14304318 "AQD COMWarehouseWMSCueExt" extends "Warehouse WMS Cue"
{
    fields
    {
        field(14304309; "AQD Co-Man List"; Integer)
        {
            CalcFormula = count("AQD Co-Man Header");
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Co-Man List';
        }
        field(14304310; "AQD Co-Man Lot Restriction"; Integer)
        {
            CalcFormula = count("AQD Co-Man Lot Restriction");
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Co-Man Lot Restriction';
        }
        field(14304311; "AQD Archive Co-Man List"; Integer)
        {
            CalcFormula = count("AQD Co-Man Header" where("Archive Order" = const(true)));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Archive Co-Man List';
        }
    }
}