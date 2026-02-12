page 14304311 "AQD Finished ProdOrder Subform"
{
    Caption = 'Finished Production Order Lines';
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Production Order";
    SourceTableView = where(Status = const(Finished));
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                ShowCaption = false;

                field("No."; Rec."No.")
                {
                    ApplicationArea = Manufacturing;
                    Lookup = false;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    Caption = 'No.';

                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"Finished Production Order", Rec);
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the description of the production order.';
                    Caption = 'Description';
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the number of the source document that the entry originates from.';
                    Caption = 'Source No.';
                }
                field("Routing No."; Rec."Routing No.")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the routing number used for this production order.';
                    Caption = 'Routing No.';
                }
                field("In-Transfer Order No."; Rec."AQD In-Transfer Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the In-Transfer Order No. field.';
                    Caption = 'In-Transfer Order No.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies how many units of the item or the family to produce (production quantity).';
                    Caption = 'Quantity';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    ToolTip = 'Specifies the location code to which you want to post the finished product from this production order.';
                    Visible = false;
                    Caption = 'Location Code';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the due date of the production order.';
                    Caption = 'Due Date';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Purchase Order")
            {
                ApplicationArea = All;
                Caption = 'Purchase Order';
                Image = PurchaseInvoice;
                RunObject = page "Purchase Lines";
                RunPageLink = "Document Type" = filter(Order), "Prod. Order No." = field("No.");
                ToolTip = 'Executes the Purchase Order action.';
            }
            action("Create Outbound Transfer Order")
            {
                ApplicationArea = All;
                Caption = 'Create Outbound Transfer Order';
                Image = TransferOrder;
                ToolTip = 'Executes the Create Outbound Transfer Order action.';

                trigger OnAction()
                var
                    ProdOrder: Record "Production Order";
                    BatchProdOrderMgt: Codeunit "AQD COM Order Mgt";
                    SelectionFilterManagement: Codeunit SelectionFilterManagement;
                    RecRef: RecordRef;
                begin
                    CurrPage.SetSelectionFilter(ProdOrder);
                    RecRef.GetTable(ProdOrder);
                    BatchProdOrderMgt.ProdOrderTransfer(SelectionFilterManagement.GetSelectionFilter(RecRef, ProdOrder.FieldNo("No.")));
                end;
            }
            action("Subcontracting Worksheet")
            {
                ApplicationArea = All;
                Caption = 'Subcontracting Worksheet';
                Image = Worksheet;
                RunObject = page "Subcontracting Worksheet";
                ToolTip = 'Executes the Subcontracting Worksheet action.';
            }
            group(Inbound)
            {
                Caption = 'Inbound';
                action("InTransfer Order")
                {
                    ApplicationArea = All;
                    Caption = 'In-Transfer Order';
                    Image = TransferOrder;
                    RunObject = page "Transfer Orders";
                    RunPageLink = "No." = field("AQD In-Transfer Order No.");
                    ToolTip = 'Executes the In-Transfer Order action.';
                }
                action("Whse. Shi&pments")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Whse. Shi&pments';
                    Image = Shipment;
                    RunObject = Page "Whse. Shipment Lines";
                    RunPageLink = "Source Type" = const(5741), "Source Subtype" = const("0"), "Source No." = field("AQD In-Transfer Order No.");
                    RunPageView = sorting("Source Type", "Source Subtype", "Source No.", "Source Line No.");
                    ToolTip = 'View outbound items that have been shipped with warehouse activities for the transfer order.';
                }
                action("Pick Lines")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Warehouse Pick Lines';
                    Image = PickLines;
                    RunObject = page "Warehouse Activity Lines";
                    RunPageLink = "Source Document" = filter("Outbound Transfer"), "Source No." = field("AQD In-Transfer Order No.");
                    RunPageView = sorting("Source Type", "Source Subtype", "Source No.");
                    ToolTip = 'View items that are outbound on warehouse pick documents for the transfer order.';
                }
                group(In_Posted)
                {
                    Caption = 'In_Posted';
                    action("Posted S&hipments")
                    {
                        ApplicationArea = Location;
                        Caption = 'S&hipments';
                        Image = Shipment;
                        RunObject = Page "Posted Transfer Shipments";
                        RunPageLink = "Transfer Order No." = field("AQD In-Transfer Order No.");
                        ToolTip = 'View related posted transfer shipments.';
                    }
                    action("Registered Registered Pick Lines")
                    {
                        ApplicationArea = Location;
                        Caption = 'Registered Registered Pick Lines';
                        Image = Shipment;
                        RunObject = Page "Registered Whse. Act.-Lines";
                        RunPageLink = "Source No." = field("AQD In-Transfer Order No.");
                        ToolTip = 'View related Registered Pick.';
                    }
                }
            }
            group(Posted)
            {
                Caption = 'Posted';
                action("Posted Purchase Invoices")
                {
                    ApplicationArea = Location;
                    Caption = 'Posted Purchase Invoices';
                    Image = Shipment;
                    RunObject = Page "Posted Purchase Invoice Lines";
                    RunPageLink = "Prod. Order No." = field("No.");
                    ToolTip = 'View related posted Purchase Invoice Lines.';
                }
            }
        }
    }
}
