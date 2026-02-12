page 14304312 "AQD Co-Man List"
{
    Caption = 'Co-Man List';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "AQD Co-Man Header";
    SourceTableView = where("Archive Order" = const(false));
    CardPageId = "AQD Co-Man Card";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                Caption = 'GroupName';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                    Caption = 'No.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                    Caption = 'Description';
                }
                field("From/To Location Code"; Rec."From/To Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Material coming from, finish good going to.';
                    Caption = 'From/To Location Code';
                }
                field("Co-Man Location Code"; Rec."Co-Man Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Co-Man Location Code field.';
                    Caption = 'Co-Man Location Code';
                }
            }
        }
        area(FactBoxes)
        {
            part("IWX Attached Documents2"; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = const(Database::"AQD Co-Man Header"), "No." = field("No.");
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("NewCo-Man")
            {
                ApplicationArea = All;
                Caption = 'New Co-Man';
                Image = NewWarehouseShipment;
                ToolTip = 'Executes the New Co-Man action.';

                trigger OnAction()
                var
                    NewCoMan: Page "AQD New Co-Man";
                begin
                    NewCoMan.LookupMode(true);
                    NewCoMan.RunModal();
                end;
            }
            action(CloseArchive)
            {
                ApplicationArea = All;
                Caption = 'Close and Archive';
                Image = Archive;
                ToolTip = 'Executes the Close and Archive action.';

                trigger OnAction()
                var
                    ProdOrder: Record "Production Order";
                    ConClose: Label 'Are you sure you want to close and achive the Co-Man?';
                    ArError: Label 'You cannot close and archive a Co-Man when one or more production order still released';
                begin
                    if Confirm(ConClose, false) then begin
                        ProdOrder.SetRange(Status, ProdOrder.Status::Released);
                        ProdOrder.SetRange("AQD Co-Man No.", Rec."No.");
                        if ProdOrder.FindFirst() then Error(ArError);
                        Rec."Archive Order" := true;
                        Rec.Modify();
                    end;
                end;
            }
            group(Outbound)
            {
                Caption = 'Outbound';
                action("OutTransfer Order")
                {
                    ApplicationArea = All;
                    Caption = 'Out-Transfer Order';
                    Image = TransferOrder;
                    RunObject = page "Transfer Orders";
                    RunPageLink = "AQD Co-Man No." = field("No.");
                    ToolTip = 'Executes the Out-Transfer Order action.';
                }
                action("Whse. Receipt Lines")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Whse. Receipt';
                    Image = Receipt;
                    ToolTip = 'View inbound items that have been Receipt with warehouse activities for the transfer order.';

                    trigger OnAction()
                    var
                        TransferHeader: Record "Transfer Header";
                        WahseRecLine: Record "Warehouse Receipt Line";
                        SelectionFilterManagement: Codeunit SelectionFilterManagement;
                        RecRef: RecordRef;
                    begin
                        TransferHeader.SetRange("AQD Co-Man No.", Rec."No.");
                        RecRef.GetTable(TransferHeader);
                        WahseRecLine.SetRange("Source Document", WahseRecLine."Source Document"::"Inbound Transfer");
                        WahseRecLine.SetFilter("Source No.", SelectionFilterManagement.GetSelectionFilter(RecRef, WahseRecLine.FieldNo("No.")));
                        Page.Run(Page::"Whse. Receipt Lines", WahseRecLine);
                    end;
                }
                action("Put-away")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Warehouse Put-away';
                    Image = PutawayLines;
                    ToolTip = 'View items that are inbound on warehouse put-away documents for the transfer order.';

                    trigger OnAction()
                    var
                        TransferHeader: Record "Transfer Header";
                        WahseActLine: Record "Warehouse Activity Line";
                        SelectionFilterManagement: Codeunit SelectionFilterManagement;
                        RecRef: RecordRef;
                    begin
                        TransferHeader.SetRange("AQD Co-Man No.", Rec."No.");
                        RecRef.GetTable(TransferHeader);
                        WahseActLine.SetRange("Source Document", WahseActLine."Source Document"::"Inbound Transfer");
                        WahseActLine.SetFilter("Source No.", SelectionFilterManagement.GetSelectionFilter(RecRef, WahseActLine.FieldNo("No.")));
                        Page.Run(Page::"Warehouse Activity Lines", WahseActLine);
                    end;
                }
                group(Out_Posted)
                {
                    Caption = 'Out_Posted';
                    action("Posted Transfer Receipts")
                    {
                        ApplicationArea = Location;
                        Caption = 'Receipts';
                        Image = Shipment;
                        RunObject = Page "Posted Transfer Receipt";
                        RunPageLink = "AQD Co-Man No." = field("No.");
                        ToolTip = 'View related posted transfer Receipts.';
                    }
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref("NewCo-Man_Promoted"; "NewCo-Man")
                {
                }
                actionref("CloseArchive_Promoted"; "CloseArchive")
                {
                }
                group(Category_Category4)
                {
                    Caption = 'Outbound';

                    actionref("OutTransfer Order_Promoted"; "OutTransfer Order")
                    {
                    }
                    actionref("Whse. Receipt Lines_Promoted"; "Whse. Receipt Lines")
                    {
                    }
                    actionref("Put-away_Promoted"; "Put-away")
                    {
                    }
                    group(Category_Category5)
                    {
                        Caption = 'Posted';

                        actionref("Posted Transfer Receipts_Promoted"; "Posted Transfer Receipts")
                        {
                        }
                    }
                }
            }
        }
    }
}
