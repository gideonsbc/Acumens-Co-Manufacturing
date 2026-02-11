page 14304313 "Co-Man Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "Co-Man Header";
    SourceTableView = where("Archive Order"=const(false));
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field("From/To Location Code"; Rec."From/To Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Material coming from, finish good going to.';
                }
                field("Co-Man Location Code"; Rec."Co-Man Location Code")
                {
                    ApplicationArea = All;
                }
            }
            part("Released Prod. Order Subform"; "Released Prod. Order Subform")
            {
                Caption = 'Released Production Order Lines';
                ApplicationArea = All;
                SubPageLink = "Co-Man No."=FIELD("No."), Status=const(Released);
                SubPageView = SORTING("No.");
            }
            part("Finished Prod. Order Subform"; "Finished Prod. Order Subform")
            {
                Caption = 'Finished Production Order Lines';
                ApplicationArea = All;
                SubPageLink = "Co-Man No."=FIELD("No."), Status=const(Finished);
                SubPageView = SORTING("No.");
            }
        }
        area(FactBoxes)
        {
            part("IWX Attached Documents2"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID"=const(Database::"Co-Man Header"), "No."=field("No.");
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
            action("New Co-Man Production Order")
            {
                ApplicationArea = All;
                Caption = 'New Co-Man Production Order';
                Image = NewWarehouseShipment;

                trigger OnAction()
                var
                    CoManHeader: Record "Co-Man Header";
                    NewCoManPro: Page "New Co-Man Production Order";
                begin
                    CoManHeader.SetRange("No.", Rec."No.");
                    NewCoManPro.SetRecord(CoManHeader);
                    NewCoManPro.SetTableView(CoManHeader);
                    NewCoManPro.LookupMode(true);
                    NewCoManPro.RunModal();
                end;
            }
            action("Create Outbound Transfer Order")
            {
                ApplicationArea = All;
                Caption = 'Create Outbound Transfer Order';
                Image = TransferOrder;

                trigger OnAction()
                var
                    ProdOrder: Record "Production Order";
                    BatchProdOrderMgt: Codeunit "COM Order Mgt";
                    SelectionFilterManagement: Codeunit SelectionFilterManagement;
                    RecRef: RecordRef;
                begin
                    ProdOrder.SetRange("Co-Man No.", Rec."No.");
                    RecRef.GetTable(ProdOrder);
                    BatchProdOrderMgt.ProdOrderTransfer(SelectionFilterManagement.GetSelectionFilter(RecRef, ProdOrder.FieldNo("No.")));
                end;
            }
            action("Lot Restriction")
            {
                ApplicationArea = All;
                Caption = 'Lot Restriction';
                Image = Worksheet;
                RunObject = page "Co-Man Lot Restrictions";
                RunPageLink = "Co-Man No."=field("No.");
            }
            action("CloseArchive")
            {
                ApplicationArea = All;
                Caption = 'Close and Archive';
                Image = Archive;

                trigger OnAction()
                var
                    ProdOrder: Record "Production Order";
                    ConClose: Label 'Are you sure you want to close and achive the Co-Man?';
                    ArError: Label 'You cannot close and archive a Co-Man when one or more production order still released';
                begin
                    if Confirm(ConClose, false)then begin
                        ProdOrder.SetRange(Status, ProdOrder.Status::Released);
                        ProdOrder.SetRange("Co-Man No.", Rec."No.");
                        if ProdOrder.FindFirst()then Error(ArError);
                        Rec."Archive Order":=true;
                        Rec.Modify();
                    end;
                end;
            }
            action("Consumption Journal")
            {
                ApplicationArea = All;
                Caption = 'Consumption Journal';
                Image = ConsumptionJournal;
                RunObject = page "Consumption Journal";
            }
            group(Outbound)
            {
                action("OutTransfer Order")
                {
                    ApplicationArea = All;
                    Caption = 'Out-Transfer Order';
                    Image = TransferOrder;
                    RunObject = page "Transfer Orders";
                    RunPageLink = "Co-Man No."=field("No.");
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
                        TransferHeader.SetRange("Co-Man No.", Rec."No.");
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
                        TransferHeader.SetRange("Co-Man No.", Rec."No.");
                        RecRef.GetTable(TransferHeader);
                        WahseActLine.SetRange("Source Document", WahseActLine."Source Document"::"Inbound Transfer");
                        WahseActLine.SetFilter("Source No.", SelectionFilterManagement.GetSelectionFilter(RecRef, WahseActLine.FieldNo("No.")));
                        Page.Run(Page::"Warehouse Activity Lines", WahseActLine);
                    end;
                }
                group(Out_Posted)
                {
                    action("Posted Transfer Receipts")
                    {
                        ApplicationArea = Location;
                        Caption = 'Receipts';
                        Image = Shipment;
                        RunObject = Page "Posted Transfer Receipt";
                        RunPageLink = "Co-Man No."=field("No.");
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

                actionref("New Co-Man Production Order_Promoted"; "New Co-Man Production Order")
                {
                }
                actionref("CloseArchive_Promoted"; "CloseArchive")
                {
                }
                actionref("Consumption Journal_Promoted"; "Consumption Journal")
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
