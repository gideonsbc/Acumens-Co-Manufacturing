page 14304320 "AQD Acumens Co-Manufact. Setup"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    PageType = Card;
    SourceTable = "AQD Acumens Co-Manufact Setup";
    Caption = 'Acumens Co-Manufacturing Setup';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field(Enabled; Rec."AQD Enabled")
                {
                    ApplicationArea = All;
                    Caption = 'Enabled App';
                    ToolTip = 'Specifies the value of the Enabled field.';
                }
            }
            group("Co-Manufacturing Setup")
            {
                Caption = 'Co-Manufacturing Setups';
                field("AQD Co-Man No. Series"; Rec."AQD Co-Man No. Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Co-Man No. Series field.';
                    Caption = 'Co-Man No. Series';
                }
                field("AQD Subcon Template Name"; Rec."AQD Subcon Template Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Worksheet Template Name field.';
                    Caption = 'Worksheet Template Name';
                }
                field("AQD Subc. Batch Name"; Rec."AQD Subc. Batch Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Journal Batch Name field.';
                    Caption = 'Journal Batch Name';
                }
            }
            group("AQD DocXtender Setup")
            {
                Caption = 'DocXtender Setups';
                field("File Storage Behavior"; Rec."AQD File Storage Behavior")
                {
                    ApplicationArea = All;
                    Caption = 'File Storage Behavior';
                    ToolTip = 'Specifies the value of the File Storage Behavior field.';
                }
                field("Drop Behavior"; Rec."AQD Drop Behavior")
                {
                    ApplicationArea = All;
                    Caption = 'Drop Behavior';
                    ToolTip = 'Specifies the value of the Drop Behavior field.';
                }
                field("Duplicate Behavior"; Rec."AQD Duplicate Behavior")
                {
                    ApplicationArea = All;
                    Caption = 'Duplicate Behavior';
                    ToolTip = 'Specifies the value of the Duplicate Behavior field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Delete Acumens Co-Manufacturing Setups")
            {
                Image = CancelAllLines;
                ApplicationArea = All;
                ToolTip = 'Executes the Delete Acumens Co-Manufacturing Setup Default Setups action.';
                Caption = 'Delete Acumens Co-Manufacturing Setups';
                trigger OnAction();
                begin
                    DeleteAllSetups();
                end;
            }
        }
        area(Creation)
        {
            action("AQD Manufacturing Setup")
            {
                Image = MachineCenter;
                RunObject = page "Manufacturing Setup";
                ApplicationArea = All;
                ToolTip = 'Executes the Manufacturing Setup action.';
                Caption = 'Manufacturing Setup';
            }
            action("AQD Req. Worksheet Templates")
            {
                Image = Template;
                RunObject = page "Req. Worksheet Templates";
                ApplicationArea = All;
                ToolTip = 'Executes the Requisition Worksheet Templates action.';
                Caption = 'Requisition Worksheet Templates';
            }
            action("AQD COIWX DocXtender Setup")
            {
                Image = Template;
                RunObject = page "IWX DocXtender Setup";
                ApplicationArea = All;
                ToolTip = 'Executes the DocXtender Setup for drag and drop attachments action.';
                Caption = 'DocXtender Setup';
            }
            action("AQD COM ResetNoSeriesAction")
            {
                Caption = 'Reset Number Series';
                Image = ResetStatus;
                ToolTip = 'Resets All Acumens Co-Manufacturing Number series on the Setup';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ResetNoSeries();
                end;
            }
        }
        area(Navigation)
        {
            action("AQD About the C0-Manufacturing App")
            {
                Image = AboutNav;
                RunObject = page "AQD AboutAcumensCoManufactu";
                ApplicationArea = All;
                ToolTip = 'Executes the About Acumens Co-Manufacturing page.';
                Caption = 'About the App';
            }
        }
        area(Promoted)
        {
            group(Category_Category20)
            {
                Caption = 'Home', Comment = 'Generated from the PromotedActionCategories property index 1.';
                actionref("Delete Acumens Co-Manufacturing Setups_Promoted"; "Delete Acumens Co-Manufacturing Setups") { }
                actionref("AQD Manufacturing Setup_Promoted"; "AQD Manufacturing Setup") { }
                actionref("AQD Req. Worksheet Templates_Promoted"; "AQD Req. Worksheet Templates") { }
                actionref("AQD COIWX DocXtender Setup_Promoted"; "AQD COIWX DocXtender Setup") { }
                actionref("ResetNoSeriesAction_Promoted"; "AQD COM ResetNoSeriesAction") { }
            }
            group(Category_New)
            {
                Caption = 'About', Comment = 'Generated from the PromotedActionCategories property index 2.';
                actionref(AbouttheApp; "AQD About the C0-Manufacturing App") { }
            }
        }
    }

    trigger OnOpenPage();
    begin
        AERAccessMgt.AccessManager('ACO-M01', true, false);
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert(true);

            InitDefaultSetup();
        end;
    end;

    var
        Text001: Label 'Do you want to automatically Initialize default Acumens Co-Manufacturing Setups?';
        Text002: Label 'Default Setups Initialized Successfully!';
        Text003: Label 'Deleting Setup Card will delete all Acumens Co-Manufacturing specific Setups. Proceed?';
        AERAccessMgt: Codeunit "AQD Inventory QC Access Mgt.";

    local procedure InitDefaultSetup();
    begin
        if Confirm(Text001) then begin
            //CreateManufacturingJournalSetup();
            GenerateNoSeries();
            AssignManufacturingSetup();
            InitializeDocXtenderSetup();

            Rec."AQD Enabled" := true;
            Rec."AQD Log To History" := true;
            Rec."AQD Setup Initialized By" := UserId;
            Rec."AQD Co-Man No. Series" := 'COM';
            Rec."AQD Subcon Template Name" := 'REQ';
            Rec."AQD Subc. Batch Name" := 'DEFAULT';
            Rec."AQD File Storage Behavior" := Rec."AQD File Storage Behavior"::"Document Attachments";
            Rec."AQD Drop Behavior" := Rec."AQD Drop Behavior"::Silent;
            Rec."AQD Duplicate Behavior" := Rec."AQD Duplicate Behavior"::"Rename Automatically";
            Rec.Modify();
        end;
        Message(Text002);
    end;

    local procedure CreateManufacturingJournalSetup()
    var
        ReqWkshJnlTemplate: Record "Req. Wksh. Template";
        RequisitionWkshJnlBatch: Record "Requisition Wksh. Name";
    begin
        if not ReqWkshJnlTemplate.Get('SUBCONTEM') then begin
            ReqWkshJnlTemplate.Init();
            ReqWkshJnlTemplate.Name := 'SUBCONTEM';
            ReqWkshJnlTemplate.Description := 'Subcon Template Journal';
            ReqWkshJnlTemplate."Page ID" := 291;
            ReqWkshJnlTemplate.Insert();
        end;
        if not RequisitionWkshJnlBatch.Get('SUBCONTEM', 'SUBCOBATCH') then begin
            RequisitionWkshJnlBatch.Init();
            RequisitionWkshJnlBatch."Worksheet Template Name" := 'SUBCONTEM';
            RequisitionWkshJnlBatch.Name := 'SUBCOBATCH';
            RequisitionWkshJnlBatch."Template Type" := RequisitionWkshJnlBatch."Template Type"::"Req.";
            RequisitionWkshJnlBatch.Description := 'Subcon Template Batch';
            RequisitionWkshJnlBatch.Insert();
        end;
    end;

    local procedure GenerateNoSeries()
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        NoSeries.Reset();
        if not NoSeries.Get('COM') then begin
            NoSeries.Init();
            NoSeries.Code := 'COM';
            NoSeries.Description := 'Co-Manufacturing Nos';
            NoSeries."Default Nos." := true;
            NoSeries."Manual Nos." := true;
            NoSeries.Insert();

            NoSeriesLine.Reset();
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'COM';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'COM00001';
            if NoSeriesLine.Insert() then;
        end;
    end;

    local procedure AssignManufacturingSetup()
    var
        ManufacturingSetup: Record "Manufacturing Setup";
    begin
        if not ManufacturingSetup.Get() then
            exit;
        if ManufacturingSetup."AQD Co-Man No. Series" = '' then
            ManufacturingSetup."AQD Co-Man No. Series" := 'COM';
        if ManufacturingSetup."AQD Subcon Template Name" = '' then
            ManufacturingSetup."AQD Subcon Template Name" := 'REQ';
        if ManufacturingSetup."AQD Subc. Batch Name" = '' then
            ManufacturingSetup."AQD Subc. Batch Name" := 'DEFAULT';
        ManufacturingSetup.Modify(true);
    end;

    local procedure InitializeDocXtenderSetup()
    var
        IWXDocXtenderSetup: Record "IWX DocXtender Setup";
    begin
        if not IWXDocXtenderSetup.Get() then
            exit;
        IWXDocXtenderSetup."File Storage Behavior" := IWXDocXtenderSetup."File Storage Behavior"::"Document Attachments";
        IWXDocXtenderSetup."Drop Behavior" := IWXDocXtenderSetup."Drop Behavior"::Silent;
        IWXDocXtenderSetup."Duplicate Behavior" := IWXDocXtenderSetup."Duplicate Behavior"::"Rename Automatically";
        IWXDocXtenderSetup.Modify(true);
    end;

    local procedure DeleteAllSetups();
    begin
        if not Confirm(Text003, false) then
            exit;

        //Delete Manufacturing Setup generated data
        ClearManufacturingSetup();

        Rec.DeleteAll();
        CurrPage.Close();
    end;

    procedure ClearManufacturingSetup()
    var
        ManufacturingSetup: Record "Manufacturing Setup";
    begin
        if not ManufacturingSetup.Get() then
            exit;
        // Clear Manufacturing Setup
        Clear(ManufacturingSetup."AQD Co-Man No. Series");
        Clear(ManufacturingSetup."AQD Subcon Template Name");
        Clear(ManufacturingSetup."AQD Subc. Batch Name");
        ManufacturingSetup.Modify(true);
    end;

    local procedure ResetNoSeries()
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
        ManufacturingSetup: Record "Manufacturing Setup";
    begin
        if not Confirm('This will reset all Acumens Co-Manufacturing number series setups. Are you sure you want to Proceed?', false) then
            exit;

        if not ManufacturingSetup.Get() then
            exit;

        NoSeries.Reset();
        if not NoSeries.Get('COM+') then begin
            NoSeries.Init();
            NoSeries.Code := 'COM+';
            NoSeries.Description := 'Co-Manufacturing Header Nos.';
            NoSeries."Default Nos." := true;
            NoSeries."Manual Nos." := true;
            NoSeries.Insert();

            NoSeriesLine.Reset();
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := 'COM+';
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := 'CO-M00001';
            if NoSeriesLine.Insert() then;
        end;

        ManufacturingSetup."AQD Co-Man No. Series" := 'COM+';
        ManufacturingSetup.Modify(true);

        Rec."AQD Co-Man No. Series" := 'COM+';
        if Rec.Modify(true) then
            CurrPage.Update();

        Message('Number series setups have been reset.')
    end;
}

