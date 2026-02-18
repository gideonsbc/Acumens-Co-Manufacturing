table 14304311 "AQD Acumens Co-Manufact Setup"
{
    DataClassification = CustomerContent;
    Caption = 'Acumens Co-Manufacturing Setup';

    fields
    {
        field(1; "AQD Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; "AQD Enabled"; Boolean)
        {
            DataClassification = CustomerContent;
            Description = 'SBC';
            Caption = 'Enabled';
        }
        field(3; "AQD Log To History"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Log To History';
        }
        field(4; "AQD Setup Deleted By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Setup Deleted By';
        }
        field(5; "AQD Setup Initialized By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Setup Initialized By';
        }
        field(6; "AQD Test Mode"; Boolean)
        {
            Caption = 'Test Mode';
            DataClassification = CustomerContent;
        }
        field(7; "AQD Co-Man No. Series"; Code[20])
        {
            TableRelation = "No. Series".Code;
            DataClassification = CustomerContent;
            Caption = 'Co-Man No. Series';
        }
        field(8; "AQD Subcon Template Name"; Code[10])
        {
            Caption = 'Worksheet Template Name';
            TableRelation = "Req. Wksh. Template";
            DataClassification = CustomerContent;
        }
        field(9; "AQD Subc. Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Requisition Wksh. Name".Name where("Worksheet Template Name" = field("AQD Subcon Template Name"));
            DataClassification = CustomerContent;
        }
        field(10; "AQD File Storage Behavior"; Option)
        {
            Caption = 'File Storage Behavior';
            OptionMembers = "Document Attachments",SharePoint;
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if not IWXDocXtenderSetup.Get() then
                    exit;
                IWXDocXtenderSetup.Validate("File Storage Behavior", "AQD File Storage Behavior");
                IWXDocXtenderSetup.Modify();
            end;
        }
        field(11; "AQD Drop Behavior"; Option)
        {
            Caption = 'Drop Behavior';
            OptionMembers = Silent,Confirmation;
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if not IWXDocXtenderSetup.Get() then
                    exit;
                IWXDocXtenderSetup.Validate("Drop Behavior", "AQD Drop Behavior");
                IWXDocXtenderSetup.Modify();
            end;
        }
        field(12; "AQD Duplicate Behavior"; Option)
        {
            Caption = 'Duplicate Behavior';
            OptionMembers = Prevent,"Rename Automatically","Rename Prompt","Replace Automatically";
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if not IWXDocXtenderSetup.Get() then
                    exit;
                IWXDocXtenderSetup.Validate("Duplicate Behavior", "AQD Duplicate Behavior");
                IWXDocXtenderSetup.Modify();
            end;
        }
    }

    keys
    {
        key(Key1; "AQD Primary Key")
        {
        }
    }
    var
        IWXDocXtenderSetup: Record "IWX DocXtender Setup";
}

