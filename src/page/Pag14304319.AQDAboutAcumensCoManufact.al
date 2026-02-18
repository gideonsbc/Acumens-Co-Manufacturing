page 14304319 "AQD About Acumens Co-Manufact"
{
    Caption = 'About Acumens Co-Manufacturing';
    Editable = false;
    LinksAllowed = false;
    ShowFilter = false;
    // ApplicationArea = All;
    // UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group("Acumens Co-Manufacturing")
            {
                Caption = 'Acumens Co-Manufacturing';
                group(Control605000013)
                {
                    ShowCaption = false;
                    field(ApplicationVersion; GetAEPApplicationVersion)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ShowCaption = false;
                    }
                    field(CUVersion; GetAEPCUversion)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ShowCaption = false;
                    }
                    field(AEPBuildDate; GetAEPBuildDate)
                    {
                        //CaptionClass = GetAEPBuildDate;
                        ApplicationArea = All;
                        Editable = false;
                        ShowCaption = false;
                    }
                    field(Control605000008; Text004)
                    {
                        //  CaptionClass = Text004;
                        //   MultiLine = true;
                        ShowCaption = false;
                        Style = Strong;
                        StyleExpr = true;
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field(Control605000007; Text00501)
                    {
                        CaptionClass = Text00501;
                        //MultiLine = true;
                        ShowCaption = false;
                        ApplicationArea = All;
                        Editable = false;
                    }
                    // field(Control605000006; Text00502)
                    // {
                    //     // CaptionClass = Text00502;
                    //     // MultiLine = true;
                    //     ShowCaption = false;
                    //     ApplicationArea = All;
                    //     Editable = false;
                    // }
                    /* field(Control605000005; Text00503)
                    {
                        // CaptionClass = Text00503;
                        ShowCaption = false;
                        ApplicationArea = all;
                        Editable = false;
                    }
                    field(Control605000004; Text00504)
                    {
                        // CaptionClass = Text00504;
                        ShowCaption = false;
                        ApplicationArea = all;
                        Editable = false;
                    }
                    field(Control605000016; Text00505)
                    {
                        // CaptionClass = Text00505;
                        ShowCaption = false;
                        ApplicationArea = all;
                        Editable = false;
                    }
                    field(Control605000017; Text00506)
                    {
                        // CaptionClass = Text00506;
                        ShowCaption = false;
                        ApplicationArea = all;
                        Editable = false;
                    } */
                    field(Control605000009; Text009)
                    {
                        // CaptionClass = Text009;
                        MultiLine = true;
                        ShowCaption = false;
                        Style = Strong;
                        StyleExpr = true;
                        ApplicationArea = All;
                    }
                }
            }
            group("Dynamics 365 Business Central")
            {
                Caption = 'Dynamics 365 Business Central';
                group(Control605000002)
                {
                    ShowCaption = false;
                    field(BCVersion; GetBCVersion)
                    {
                        CaptionClass = GetBCVersion;
                        ApplicationArea = All;
                        ShowCaption = false;
                        Editable = false;
                    }
                    field(BCAppBuild; GetBCAppBuild)
                    {
                        //  CaptionClass = GetBCAppBuild;
                        ShowCaption = false;
                        ApplicationArea = All;
                        Editable = false;
                    }
                }
            }
        }
    }

    actions
    {
    }

    var
        Appl: Codeunit "Application System Constants";
        AEPAppl: Codeunit "AQD Arc Appl System Constants";
        Text001: Label 'ACO-M Version: %1';
        Text002: Label 'CU Version: %1';
        Text003: Label 'ACO-M Build Date: %1';
        Text004: Label 'Acumens Co-Manufacturing includes following granules:';
        Text009: Label '© 2019-2026 SBC Dynamics ERP';
        Text010: Label 'Version: %1';
        Text011: Label 'Build: %1';
        Text00501: Label '  * Co-Manufacturing Management';

    local procedure GetAEPApplicationVersion(): Text
    begin
        exit(StrSubstNo(Text001, AEPAppl.AIQCMPApplicationVersion));
    end;

    local procedure GetAEPCUversion(): Text
    begin
        exit(StrSubstNo(Text002, AEPAppl.AIQCMPCUVersion));
    end;

    local procedure GetAEPBuildDate(): Text
    begin
        exit(StrSubstNo(Text003, AEPAppl.AIQCMPBuildDate));
    end;

    local procedure GetBCVersion(): Text
    begin
        exit(StrSubstNo(Text010, Appl.ApplicationVersion));
    end;

    local procedure GetBCAppBuild(): Text
    begin
        exit(StrSubstNo(Text011, Appl.ApplicationBuild));
    end;
}

