page 14304309 "Released Prod. Order Subform"
{
    Caption = 'Released Production Order Lines';
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Production Order";
    SourceTableView = where(Status=const(Released));
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

                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"Released Production Order", Rec);
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the description of the production order.';
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the number of the source document that the entry originates from.';
                }
                field("Routing No."; Rec."Routing No.")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the routing number used for this production order.';
                }
                field("In-Transfer Order No."; Rec."In-Transfer Order No.")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies how many units of the item or the family to produce (production quantity).';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    ToolTip = 'Specifies the location code to which you want to post the finished product from this production order.';
                    Visible = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the due date of the production order.';
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
                RunPageLink = "Document Type"=filter(Order), "Prod. Order No."=field("No.");
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
            }
            group(Inbound)
            {
                action("InTransfer Order")
                {
                    ApplicationArea = All;
                    Caption = 'In-Transfer Order';
                    Image = TransferOrder;
                    RunObject = page "Transfer Orders";
                    RunPageLink = "No."=field("In-Transfer Order No.");
                }
                action("Whse. Shi&pments")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Whse. Shi&pments';
                    Image = Shipment;
                    RunObject = Page "Whse. Shipment Lines";
                    RunPageLink = "Source Type"=const(5741), "Source Subtype"=const("0"), "Source No."=field("In-Transfer Order No.");
                    RunPageView = sorting("Source Type", "Source Subtype", "Source No.", "Source Line No.");
                    ToolTip = 'View outbound items that have been shipped with warehouse activities for the transfer order.';
                }
                action("Pick Lines")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Warehouse Pick Lines';
                    Image = PickLines;
                    RunObject = page "Warehouse Activity Lines";
                    RunPageLink = "Source Document"=filter("Outbound Transfer"), "Source No."=field("In-Transfer Order No.");
                    RunPageView = sorting("Source Type", "Source Subtype", "Source No.");
                    ToolTip = 'View items that are outbound on warehouse pick documents for the transfer order.';
                }
                group(In_Posted)
                {
                    action("Posted S&hipments")
                    {
                        ApplicationArea = Location;
                        Caption = 'S&hipments';
                        Image = Shipment;
                        RunObject = Page "Posted Transfer Shipments";
                        RunPageLink = "Transfer Order No."=field("In-Transfer Order No.");
                        ToolTip = 'View related posted transfer shipments.';
                    }
                    action("Registered Registered Pick Lines")
                    {
                        ApplicationArea = Location;
                        Caption = 'Registered Registered Pick Lines';
                        Image = Shipment;
                        RunObject = Page "Registered Whse. Act.-Lines";
                        RunPageLink = "Source No."=field("In-Transfer Order No.");
                        ToolTip = 'View related Registered Pick.';
                    }
                }
            }
            group(Posted)
            {
                action("Posted Purchase Invoices")
                {
                    ApplicationArea = Location;
                    Caption = 'Posted Purchase Invoices';
                    Image = Shipment;
                    RunObject = Page "Posted Purchase Invoice Lines";
                    RunPageLink = "Prod. Order No."=field("No.");
                    ToolTip = 'View related posted Purchase Invoice Lines.';
                }
            }
        }
    }
}
