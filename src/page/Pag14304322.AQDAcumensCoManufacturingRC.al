page 14304322 "AQD AcumensCo-ManufacturingRC"
{
    Caption = 'Acumens Co-Manufacturing Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part(Control7; "Headline RC Whse. Worker WMS")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Headline RC Whse. Worker WMS';
            }
            part("AQD COMManafucturingActivities"; "AQD COMManafucturingActivities")
            {
                ApplicationArea = Warehouse;
                Caption = 'Acumens Co-Manufacturing Activities';
            }
            part(Control1901138408; "WMS Ship & Receive Activities")
            {
                ApplicationArea = Warehouse;
                Caption = 'Warehouse Activities';
            }
            part("User Tasks Activities"; "User Tasks Activities")
            {
                ApplicationArea = Suite;
                Caption = 'User Tasks Activities';
            }
            part("Job Queue Tasks Activities"; "Job Queue Tasks Activities")
            {
                ApplicationArea = Suite;
                Caption = 'Job Queue Tasks Activities';
            }
            part("Emails"; "Email Activities")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Email Activities';
            }
            part(ApprovalsActivities; "Approvals Activities")
            {
                ApplicationArea = Suite;
                Caption = 'Approvals Activities';
            }
            systempart(Control1901377608; MyNotes)
            {
                ApplicationArea = Warehouse;
            }
        }
    }

    actions
    {
        area(reporting)
        {
            group(Reports)
            {
                Caption = 'Reports';
                action(WhseShipmentStatus)
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Whse. Shipment Status';
                    RunObject = report "Whse. Shipment Status";
                    Image = Status;
                }
                action(CustomerList)
                {
                    ApplicationArea = Basic, Suite, Warehouse;
                    Caption = 'Customer Listing';
                    RunObject = Report "Customer Listing";
                    Image = List;
                }
                action(InventoryPickingList)
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Inventory Picking List';
                    RunObject = report "Inventory Picking List";
                    AccessByPermission = TableData "Location" = R;
                    Image = List;
                }
                action(ItemExpirationQuantity)
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Item Expiration - Quantity';
                    RunObject = report "Item Expiration - Quantity";
                    Image = Report;
                }
                action(InventoryLabels)
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Inventory Labels';
                    RunObject = Report "Inventory Labels";
                    Image = Inventory;
                }
                action("Warehouse &Bin List")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Warehouse &Bin List';
                    Image = List;
                    RunObject = Report "Warehouse Bin List";
                    ToolTip = 'Get an overview of warehouse bins, their setup, and the quantity of items within the bins.';
                }
                action("Warehouse A&djustment Bin")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Warehouse A&djustment Bin';
                    Image = "Report";
                    RunObject = Report "Whse. Adjustment Bin";
                    ToolTip = 'Get an overview of warehouse bins, their setup, and the quantity of items within the bins.';
                }
                action("Whse. P&hys. Inventory List")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Whse. P&hys. Inventory List';
                    Image = List;
                    RunObject = Report "Whse. Phys. Inventory List";
                    ToolTip = 'View or print the list of the lines that you have calculated in the Warehouse Physical Inventory Journal window. You can use this report during the physical inventory count to mark down actual quantities on hand in the warehouse and compare them to what is recorded in the program.';
                }
                action("Customer &Labels")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Customer &Labels';
                    Image = "Report";
                    RunObject = Report "Customer - Labels";
                    ToolTip = 'View, save, or print mailing labels with the customers'' names and addresses. The report can be used to send sales letters, for example.';
                }
                action("Shipping Labels")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Shipping Labels';
                    Image = "Report";
                    RunObject = Report "Shipping Labels";
                    ToolTip = 'View shipping labels for posted sales shipments. You can print labels for all or specific orders.';
                }
            }
        }
        area(embedding)
        {
            action(Items)
            {
                ApplicationArea = Warehouse;
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
                ToolTip = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.';
            }
            action(Customers)
            {
                ApplicationArea = Warehouse;
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
                ToolTip = 'View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.';
            }
            action(Vendors)
            {
                ApplicationArea = Warehouse;
                Caption = 'Vendors';
                Image = Vendor;
                RunObject = Page "Vendor List";
                ToolTip = 'View or edit detailed information for the vendors that you trade with. From each vendor card, you can open related information, such as purchase statistics and ongoing orders, and you can define special prices and line discounts that the vendor grants you if certain conditions are met.';
            }
            action("Shipping Agents")
            {
                ApplicationArea = Warehouse;
                Caption = 'Shipping Agents';
                RunObject = Page "Shipping Agents";
                ToolTip = 'View the list of shipping companies that you use to transport goods.';
            }
            action(Picks)
            {
                ApplicationArea = Warehouse;
                Caption = 'Picks';
                RunObject = Page "Warehouse Picks";
                ToolTip = 'View the list of ongoing warehouse picks. ';
            }
            action("Put-aways")
            {
                ApplicationArea = Warehouse;
                Caption = 'Put-aways';
                RunObject = Page "Warehouse Put-aways";
                ToolTip = 'View the list of ongoing put-aways.';
            }
            action(Movements)
            {
                ApplicationArea = Warehouse;
                Caption = 'Movements';
                RunObject = Page "Warehouse Movements";
                ToolTip = 'View the list of ongoing movements between bins according to an advanced warehouse configuration.';
            }
            action(WhseShpt)
            {
                ApplicationArea = Warehouse;
                Caption = 'Warehouse Shipments';
                RunObject = Page "Warehouse Shipment List";
                ToolTip = 'View the list of ongoing warehouse shipments.';
            }
            action(WhseShptReleased)
            {
                ApplicationArea = Warehouse;
                Caption = 'Released';
                RunObject = Page "Warehouse Shipment List";
                RunPageView = sorting("No.")
                              where(Status = filter(Released));
                ToolTip = 'View the list of released source documents that are ready for warehouse activities.';
            }
            action(WhseShptPartPicked)
            {
                ApplicationArea = Warehouse;
                Caption = 'Partially Picked';
                RunObject = Page "Warehouse Shipment List";
                RunPageView = where("Document Status" = filter("Partially Picked"));
                ToolTip = 'View the list of ongoing warehouse picks that are partially completed.';
            }
            action(WhseShptComplPicked)
            {
                ApplicationArea = Warehouse;
                Caption = 'Completely Picked';
                RunObject = Page "Warehouse Shipment List";
                RunPageView = where("Document Status" = filter("Completely Picked"));
                ToolTip = 'View the list of completed warehouse picks.';
            }
            action(WhseShptPartShipped)
            {
                ApplicationArea = Warehouse;
                Caption = 'Partially Shipped';
                RunObject = Page "Warehouse Shipment List";
                RunPageView = where("Document Status" = filter("Partially Shipped"));
                ToolTip = 'View the list of ongoing warehouse shipments that are partially completed.';
            }
            action(WhseReceipts)
            {
                ApplicationArea = Warehouse;
                Caption = 'Warehouse Receipts';
                RunObject = Page "Warehouse Receipts";
                ToolTip = 'View the list of ongoing warehouse receipts.';
            }
            action(WhseReceiptsPartReceived)
            {
                ApplicationArea = Warehouse;
                Caption = 'Partially Received';
                RunObject = Page "Warehouse Receipts";
                RunPageView = where("Document Status" = filter("Partially Received"));
                ToolTip = 'View the list of ongoing warehouse receipts that are partially completed.';
            }
            action("Transfer Orders")
            {
                ApplicationArea = Location;
                Caption = 'Transfer Orders';
                Image = Document;
                RunObject = Page "Transfer Orders";
                ToolTip = 'Move inventory items between company locations. With transfer orders, you ship the outbound transfer from one location and receive the inbound transfer at the other location. This allows you to manage the involved warehouse activities and provides more certainty that inventory quantities are updated correctly.';
            }
            action("Assembly Orders")
            {
                ApplicationArea = Assembly;
                Caption = 'Assembly Orders';
                RunObject = Page "Assembly Orders";
                ToolTip = 'View ongoing assembly orders.';
            }
            action("Bin Contents")
            {
                ApplicationArea = Warehouse;
                Caption = 'Bin Contents';
                Image = BinContent;
                RunObject = Page "Bin Contents List";
                ToolTip = 'View items in the bin if the selected line contains a bin code.';
            }
            action("AQD Co-Man List")
            {
                ApplicationArea = Warehouse;
                Caption = 'Co-Man List';
                Image = List;
                RunObject = Page "AQD Co-Man List";
                ToolTip = 'View the list of Co-Man List.';
            }
            action("AQD Co-Man Lot Restrictions")
            {
                ApplicationArea = Warehouse;
                Caption = 'Co-Man Lot Restrictions';
                Image = List;
                RunObject = Page "AQD Co-Man Lot Restrictions";
                ToolTip = 'View the list of Co-Man Lot Restrictions.';
            }
            action("AQD Archive Co-Man List")
            {
                ApplicationArea = Warehouse;
                Caption = 'Archive Co-Man List';
                Image = List;
                RunObject = Page "AQD Archive Co-Man List";
                ToolTip = 'View the list of Archive Co-Man List.';
            }
        }
        area(sections)
        {
            group(Group4)
            {
                Caption = 'Warehouse Documents';
                action("Transfer Orders1")
                {
                    ApplicationArea = Location;
                    Caption = 'Transfer Orders';
                    RunObject = page "Transfer Orders";
                }
                action(Receipts)
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Warehouse Receipts';
                    RunObject = page "Warehouse Receipts";
                }
                action(Shipments)
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Warehouse Shipments';
                    RunObject = page "Warehouse Shipment List";
                }
                action("Assembly Orders1")
                {
                    ApplicationArea = Assembly;
                    Caption = 'Assembly Orders';
                    RunObject = page "Assembly Orders";
                }
            }
            group(Group5)
            {
                Caption = 'Posted Documents';
                action("Posted Purchase Receipts")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Purchase Receipts';
                    RunObject = page "Posted Purchase Receipts";
                }
                action("Posted Return Shipments")
                {
                    ApplicationArea = PurchReturnOrder;
                    Caption = 'Posted Purchase Return Shipments';
                    RunObject = page "Posted Return Shipments";
                }
                action("Posted Sales Shipments")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Sales Shipments';
                    RunObject = page "Posted Sales Shipments";
                }
                action("Posted Return Receipts")
                {
                    ApplicationArea = SalesReturnOrder;
                    Caption = 'Posted Return Receipts';
                    RunObject = page "Posted Return Receipts";
                }
                action("Posted Assembly Orders")
                {
                    ApplicationArea = Assembly;
                    Caption = 'Posted Assembly Orders';
                    RunObject = page "Posted Assembly Orders";
                }
                action("Posted Transfer Receipts")
                {
                    ApplicationArea = Location;
                    Caption = 'Posted Transfer Receipts';
                    RunObject = page "Posted Transfer Receipts";
                }
                action("Posted Transfer Shipments")
                {
                    ApplicationArea = Location;
                    Caption = 'Posted Transfer Shipments';
                    RunObject = page "Posted Transfer Shipments";
                }
                action("Posted Direct Transfers")
                {
                    ApplicationArea = Location;
                    Caption = 'Posted Direct Transfers';
                    RunObject = page "Posted Direct Transfers";
                }
                action("Posted Receipts")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Posted Whse. Receipts';
                    RunObject = page "Posted Whse. Receipt List";
                }
                action("Posted Shipments")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Posted Whse. Shipments';
                    RunObject = page "Posted Whse. Shipment List";
                }
                action("Posted Invt. Put-away")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Posted Invt. Put-away';
                    RunObject = page "Posted Invt. Put-away List";
                }
                action("Posted Invt. Pick")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Posted Invt. Pick';
                    RunObject = page "Posted Invt. Pick List";
                }
                action("Posted Invt. Receipts")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Inventory Receipts';
                    RunObject = page "Posted Invt. Receipts";
                    Tooltip = 'Open the Posted Inventory Receipts page.';
                }
                action("Posted Invt. Shipments")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Inventory Shipments';
                    RunObject = page "Posted Invt. Shipments";
                    Tooltip = 'Open the Posted Inventory Shipments page.';
                }
            }
            group(Journals)
            {
                Caption = 'Journals';
                Image = Journals;
                action(WhsePhysInvtJournals)
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Warehouse Physical Inventory Journals';
                    RunObject = Page "Whse. Journal Batches List";
                    RunPageView = where("Template Type" = const("Physical Inventory"));
                    ToolTip = 'Prepare to count inventories by preparing the documents that warehouse employees use when they perform a physical inventory of selected items or of all the inventory. When the physical count has been made, you enter the number of items that are in the bins in this window, and then you register the physical inventory.';
                }
                action("WhseItem Journals")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Warehouse Item Journals';
                    RunObject = Page "Whse. Journal Batches List";
                    RunPageView = where("Template Type" = const(Item));
                    ToolTip = 'Adjust the quantity of an item in a particular bin or bins. For instance, you might find some items in a bin that are not registered in the system, or you might not be able to pick the quantity needed because there are fewer items in a bin than was calculated by the program. The bin is then updated to correspond to the actual quantity in the bin. In addition, it creates a balancing quantity in the adjustment bin, for synchronization with item ledger entries, which you can then post with an item journal.';
                }
            }
            group(Worksheet)
            {
                Caption = 'Worksheet';
                Image = Worksheets;
                action(PutawayWorksheets)
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Put-away Worksheets';
                    RunObject = Page "Worksheet Names List";
                    RunPageView = where("Template Type" = const("Put-away"));
                    ToolTip = 'Plan and initialize item put-aways.';
                }
                action(MovementWorksheets)
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Movement Worksheets';
                    RunObject = Page "Worksheet Names List";
                    RunPageView = where("Template Type" = const(Movement));
                    ToolTip = 'Plan and initiate movements of items between bins according to an advanced warehouse configuration.';
                }
                action(PickWorksheets)
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Pick Worksheets';
                    RunObject = Page "Worksheet Names List";
                    RunPageView = where("Template Type" = const(Pick));
                    ToolTip = 'Plan and initialize picks of items. ';
                }
            }
            group(Group15)
            {
                Caption = 'Setups';
                action("Inventory Setup")
                {
                    ApplicationArea = Suite;
                    Caption = 'Inventory Setup';
                    RunObject = page "Inventory Setup";
                }
                action("Assembly Setup")
                {
                    ApplicationArea = Assembly;
                    Caption = 'Assembly Setup';
                    RunObject = page "Assembly Setup";
                }
                action(Locations)
                {
                    ApplicationArea = Location;
                    Caption = 'Locations';
                    RunObject = page "Location List";
                }
                action("Item Tracking Codes")
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Item Tracking Codes';
                    RunObject = page "Item Tracking Codes";
                }
                action("Item Journal Templates")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Item Journal Templates';
                    RunObject = page "Item Journal Templates";
                }
                action("Nonstock Item Setup")
                {
                    ApplicationArea = Suite;
                    Caption = 'Nonstock Item Setup';
                    RunObject = page "Catalog Item Setup";
                }
                action("Transfer Routes")
                {
                    ApplicationArea = Location;
                    Caption = 'Transfer Routes';
                    RunObject = page "Transfer Routes";
                }
                action("Create Stockkeeping Unit")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Create Stockkeeping Unit';
                    RunObject = report "Create Stockkeeping Unit";
                }
                action("Report Selections Inventory")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Report Selections Inventory';
                    RunObject = page "Report Selection - Inventory";
                }
            }
            group("Report")
            {
                Caption = 'Reports';
                action("Whse. Shipment Status")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Whse. Shipment Status';
                    RunObject = report "Whse. Shipment Status";
                    Image = Status;
                }
                action("Customer - List")
                {
                    ApplicationArea = Basic, Suite, Warehouse;
                    Caption = 'Customer Listing';
                    RunObject = Report "Customer Listing";
                    Image = List;
                }
                action("Inventory Picking List")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Inventory Picking List';
                    RunObject = report "Inventory Picking List";
                    AccessByPermission = TableData "Location" = R;
                    Image = List;
                }
                action("Item Expiration - Quantity")
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Item Expiration - Quantity';
                    RunObject = report "Item Expiration - Quantity";
                    Image = Report;
                }
                action("Inventory Labels")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Inventory Labels';
                    RunObject = Report "Inventory Labels";
                    Image = Inventory;
                }
            }
        }
        area(creation)
        {
            action("&Item")
            {
                ApplicationArea = Manufacturing;
                Caption = '&Item';
                Image = Item;
                RunObject = Page "Item Card";
                RunPageMode = Create;
                ToolTip = 'Create a new item.';
            }
            action("Production &Order")
            {
                ApplicationArea = Manufacturing;
                Caption = 'Planned Production &Order';
                Image = "Order";
                RunObject = Page "Planned Production Order";
                RunPageMode = Create;
                ToolTip = 'Create a new planned production order to supply a produced item.';
            }
            action("Firm Planned Production Order")
            {
                ApplicationArea = Manufacturing;
                Caption = 'Firm Planned Production Order';
                RunObject = Page "Firm Planned Prod. Order";
                RunPageMode = Create;
                ToolTip = 'Create a new firm planned production order to supply a produced item.';
            }
            action("Released Production Order")
            {
                ApplicationArea = Manufacturing;
                Caption = 'Released Production Order';
                RunObject = Page "Released Production Order";
                RunPageMode = Create;
                ToolTip = 'Create a new released production order to supply a produced item.';
            }
            action("Production &BOM")
            {
                ApplicationArea = Manufacturing;
                Caption = 'Production &BOM';
                Image = BOM;
                RunObject = Page "Production BOM";
                RunPageMode = Create;
                ToolTip = 'Create a new bill of material for a produced item.';
            }
            action("&Routing")
            {
                ApplicationArea = Manufacturing;
                Caption = '&Routing';
                Image = Route;
                RunObject = Page Routing;
                RunPageMode = Create;
                ToolTip = 'Create a routing defining the operations that are required to produce an end item.';
            }
            action("&Purchase Order")
            {
                ApplicationArea = Manufacturing;
                Caption = '&Purchase Order';
                Image = Document;
                RunObject = Page "Purchase Order";
                RunPageMode = Create;
                ToolTip = 'Purchase goods or services from a vendor.';
            }
            action("Whse. &Shipment")
            {
                ApplicationArea = Warehouse;
                Caption = 'Whse. &Shipment';
                Image = Shipment;
                RunObject = Page "Warehouse Shipment";
                RunPageMode = Create;
                ToolTip = 'Create a new warehouse shipment.';
            }
            action("T&ransfer Order")
            {
                ApplicationArea = Warehouse;
                Caption = 'T&ransfer Order';
                Image = Document;
                RunObject = Page "Transfer Order";
                RunPageMode = Create;
                ToolTip = 'Move items from one warehouse location to another.';
            }
            action("&Whse. Receipt")
            {
                ApplicationArea = Warehouse;
                Caption = '&Whse. Receipt';
                Image = Receipt;
                RunObject = Page "Warehouse Receipt";
                RunPageMode = Create;
                ToolTip = 'Record the receipt of items according to an advanced warehouse configuration. ';
            }
            action("Phys. Inv. Order")
            {
                ApplicationArea = Warehouse;
                Caption = 'Phys. Inv. Order';
                RunObject = Page "Physical Inventory Order";
                ToolTip = 'Plan to count inventory by calculating existing quantities and generating the recording documents.';
            }
        }
        area(processing)
        {
            group(Administration)
            {
                Caption = 'Acumens Co-Manufacturing  Setups';
                action("AQD Acumens Inventory QC Setup")
                {
                    ApplicationArea = All;
                    Caption = 'Acumens Co-Manufacturing Setup';
                    Image = Setup;
                    RunObject = page "AQD Acumens Co-Manufact. Setup";
                }
                action("Warehouse Setup")
                {
                    Image = WarehouseSetup;
                    RunObject = page "Warehouse Setup";
                    ApplicationArea = All;
                    ToolTip = 'Executes the Warehouse Setup action.';
                    Caption = 'Warehouse Setup';
                }
                action("Location Setup")
                {
                    Image = Delivery;
                    RunObject = page "Location List";
                    ApplicationArea = All;
                    ToolTip = 'Executes the Locations action.';
                    Caption = 'Locations';
                }
                action("Whse. Journal Templates")
                {
                    Image = Template;
                    RunObject = page "Whse. Journal Templates";
                    ApplicationArea = All;
                    ToolTip = 'Executes the Whse. Journal Templates action.';
                    Caption = 'Whse. Journal Templates';
                }
                action("Item JournalTemplates")
                {
                    Image = Journals;
                    RunObject = page "Item Journal Templates";
                    ApplicationArea = All;
                    ToolTip = 'Executes the Item Journal Templates action.';
                    Caption = 'Item Journal Templates';
                }
            }
        }
    }
}

