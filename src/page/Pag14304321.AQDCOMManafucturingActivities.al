page 14304321 "AQD COMManafucturingActivities"
{
    Caption = 'Acumens Co-Manufacturing Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Warehouse WMS Cue";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            cuegroup("Co-Manufacturing")
            {
                Caption = 'Co-Manufacturing';
                field("AQD Co-Man List"; Rec."AQD Co-Man List")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "AQD Co-Man List";
                    Caption = ' Co-Man List';
                }
                field("AQD Co-Man Lot Restriction"; Rec."AQD Co-Man Lot Restriction")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "AQD Co-Man Lot Restrictions";
                    Caption = 'Co-Man Lot Restrictions';
                }
            }
            cuegroup("Archive Co-Man List")
            {
                Caption = 'Archive Co-Man List';
                field("AQD Archive Co-Man List"; Rec."AQD Archive Co-Man List")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "AQD Archive Co-Man List";
                    Caption = 'Archive Co-Man List';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
        // Rec.SetRange("User ID Filter", UserId());
        // LocationCode := WhseWMSCue.GetEmployeeLocation(UserId());
        // Rec.SetFilter("Location Filter", LocationCode);
    end;

    var
        WhseWMSCue: Record "Warehouse WMS Cue";
        LocationCode: Text[1024];
}

