table 14304309 "Co-Man Header"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            var
                MfgSetup: Record "Manufacturing Setup";
                NoSeries: Codeunit "No. Series";
            begin
                if "No." <> xRec."No." then begin
                    MfgSetup.Get();
                    MfgSetup.TestField("Co-Man No. Series");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(3; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(8; "From/To Location Code"; Code[10])
        {
            TableRelation = Location.Code;
        }
        field(10; "Co-Man Location Code"; Code[10])
        {
            TableRelation = Location.Code;
        }
        field(11; "Archive Order"; Boolean)
        {
        }
        field(12; Description; Text[2000])
        {
        }
    }
    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        InvtAdjmtEntryOrder: Record "Inventory Adjmt. Entry (Order)";
        MfgSetup: Record "Manufacturing Setup";
        NoSeries: Codeunit "No. Series";
        DefaultNoSeriesCode: Code[20];
    begin
        MfgSetup.Get();
        if "No." = '' then begin
            MfgSetup.TestField("Co-Man No. Series");
            if NoSeries.AreRelated(MfgSetup."Co-Man No. Series", xRec."No. Series") then
                "No. Series" := xRec."No. Series"
            else
                "No. Series" := MfgSetup."Co-Man No. Series";
            "No." := NoSeries.GetNextNo("No. Series", "Due Date");
        end;
        if "Due Date" = 0D then Validate("Due Date", WorkDate());
    end;
}
