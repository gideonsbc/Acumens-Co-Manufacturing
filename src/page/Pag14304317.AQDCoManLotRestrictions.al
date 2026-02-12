page 14304317 "AQD Co-Man Lot Restrictions"
{
    Caption = 'Co-Man Lot Restrictions';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "AQD Co-Man Lot Restriction";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                Caption = 'GroupName';
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lot No. field.';
                    Caption = 'Lot No.';
                }
                field("Restriction Status"; Rec."Restriction Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Restriction Status field.';
                    Caption = 'Restriction Status';
                }
                field("Restriction Code"; Rec."Restriction Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Restriction Code field.';
                    Caption = 'Restriction Code';
                }
            }
        }
    }
}
