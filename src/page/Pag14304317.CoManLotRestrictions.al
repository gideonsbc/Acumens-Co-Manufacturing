page 14304317 "Co-Man Lot Restrictions"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Co-Man Lot Restriction";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                }
                field("Restriction Status"; Rec."Restriction Status")
                {
                    ApplicationArea = All;
                }
                field("Restriction Code"; Rec."Restriction Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
