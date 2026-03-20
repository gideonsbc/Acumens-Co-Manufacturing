page 14304319 "AQD AboutAcumensCoManufactu"
{
    Caption = 'About Acumens Co-Manufacturing';
    Editable = false;
    LinksAllowed = false;
    ShowFilter = false;
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            group(AppVersion)
            {
                Caption = 'App Version';
                field(BCAppversion; GetBCAppversion)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    Editable = false;
                }
            }
            group(About)
            {
                Caption = 'About the App';
                field(AboutApp; AboutAppTxt)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    MultiLine = true;
                }
            }
            group(Features)
            {
                Caption = 'Co-Manufacturing Capabilities';
                field(CoManufacturingManagementTxtVar; CoManufacturingManagementTxtVar)
                {
                    ApplicationArea = All;
                    //MultiLine = true;
                    ShowCaption = false;
                }
                field(CoManLotRestrictionsTxtVar; CoManLotRestrictionsTxtVar)
                {
                    ApplicationArea = All;
                    //MultiLine = true;
                    ShowCaption = false;
                }
                field(ProductionOrderTrackingTxtVar; ProductionOrderTrackingTxtVar)
                {
                    ApplicationArea = All;
                    //MultiLine = true;
                    ShowCaption = false;
                }
            }
            group(Copyright)
            {
                ShowCaption = false;
                field(GetCopyright; GetStartAndCurrentYear)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    Editable = false;
                }
            }
            group("Dynamics 365 Business Central")
            {
                Caption = 'Dynamics 365 Business Central / NAV';
                group(Control605000002)
                {
                    ShowCaption = false;
                    grid(A)
                    {
                        ShowCaption = false;
                        field(BCVersion; GetBCVersion)
                        {
                            Caption = 'Version';
                            ApplicationArea = All;
                            ShowCaption = true;
                            Editable = false;
                            ToolTip = 'Specifies the value of the Version field.';
                        }
                        field(Platform; GetBCPlatformBuild)
                        {
                            Caption = 'Platform';
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Specifies the value of the Platform field.';
                        }
                    }
                    grid(B)
                    {
                        ShowCaption = false;
                        field(BCAppBuild; GetBCAppBuild)
                        {
                            Caption = 'Build';
                            ShowCaption = true;
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Specifies the value of the Build field.';
                        }
                        field(Application; GetBCApplicationBuild)
                        {
                            Caption = 'Application';
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Specifies the value of the Application field.';
                        }
                    }
                }
            }
        }
    }

    var
        Appl: Codeunit "Application System Constants";
        AboutAppTxt: Text;
        CoManLotRestrictionsTxtVar: Text;
        CoManufacturingManagementTxtVar: Text;
        ProductionOrderTrackingTxtVar: Text;
        VersionTxt: Text;

    local procedure GetBCVersion(): Text
    begin
        exit(StrSubstNo(Appl.ApplicationVersion));
    end;

    local procedure GetBCAppBuild(): Text
    begin
        exit(StrSubstNo(Appl.ApplicationBuild));
    end;

    local procedure GetBCPlatformBuild(): Text
    begin
        exit(StrSubstNo(Appl.PlatformFileVersion()));
    end;

    local procedure GetBCApplicationBuild(): Text
    begin
        exit(StrSubstNo(Appl.ApplicationBuild()));
    end;

    local procedure GetStartAndCurrentYear(): Text
    var
        StartYear: Integer;
        CurrentYear: Integer;
        CopyrightTxt: Text;
    begin
        StartYear := 2019;
        CurrentYear := Date2DMY(Today, 3);

        if StartYear = CurrentYear then
            CopyrightTxt := StrSubstNo('© %1 SBC Dynamics ERP', CurrentYear)
        else
            CopyrightTxt := StrSubstNo('© %1-%2 SBC Dynamics ERP', StartYear, CurrentYear);

        exit(CopyrightTxt);
    end;

    local procedure GetBCAppversion(): Text
    var
        NavAppInstalledApp: Record "NAV App Installed App";
        Info: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(Info);

        VersionTxt :=
            Format(Info.AppVersion.Major) + '.' +
            Format(Info.AppVersion.Minor) + '.' +
            Format(Info.AppVersion.Build);

        exit(VersionTxt);
    end;

    trigger OnOpenPage()
    begin
        AboutAppTxt :=
          'Acumens Co-Manufacturing enables you to keep track of the inventory movement during a manufacturing operation within Microsoft Dynamics 365 Business Central. ' +
          'This feature is a pivotal in driving efficiency, automating tasks, and enhancing productivity.' +
          'The app helps to formalize outsourcing agreements, optimize resource utilization, and ensure accurate tracking of production orders within Microsoft Dynamics 365 Business Central.';

        CoManufacturingManagementTxtVar := 'Co-Manufacturing Management';
        CoManLotRestrictionsTxtVar := 'Co-Man Lot Restrictions';
        ProductionOrderTrackingTxtVar := 'Production Order Tracking';
    end;
}

