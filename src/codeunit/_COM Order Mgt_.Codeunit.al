codeunit 14304310 "COM Order Mgt"
{
    procedure AssignLotNoToProdOrderLine(var ProdOrderLine: Record "Prod. Order Line"; LotNo: Code[50]): Code[50]var
        ReservationEntry: Record "Reservation Entry";
        Item: Record Item;
        NoSeriesManagement: Codeunit "No. Series";
        EntryNo: Integer;
    begin
        ReservationEntry.SetLoadFields("Entry No.");
        if ReservationEntry.FindLast()then EntryNo:=ReservationEntry."Entry No." + 1
        else
            EntryNo:=1;
        Item.Get(ProdOrderLine."Item No.");
        Item.TestField("Lot Nos.");
        ReservationEntry.Reset();
        ReservationEntry.SetLoadFields();
        ReservationEntry.Init();
        ReservationEntry.Validate("Entry No.", EntryNo);
        ReservationEntry.Validate("Item No.", ProdOrderLine."Item No.");
        ReservationEntry.Validate("Location Code", ProdOrderLine."Location Code");
        ReservationEntry.Validate("Quantity (Base)", ProdOrderLine."Quantity (Base)");
        ReservationEntry.Validate("Reservation Status", "Reservation Status"::Surplus);
        ReservationEntry.Validate("Creation Date", Today());
        ReservationEntry.Validate("Source Type", Database::"Prod. Order Line");
        ReservationEntry.Validate("Source Subtype", ProdOrderLine.Status.AsInteger());
        ReservationEntry.Validate("Source ID", ProdOrderLine."Prod. Order No.");
        ReservationEntry.Validate("Source Prod. Order Line", ProdOrderLine."Line No.");
        ReservationEntry.Validate("Created By", UserId());
        ReservationEntry.Validate("Qty. per Unit of Measure", ProdOrderLine."Qty. per Unit of Measure");
        ReservationEntry.Validate(Quantity, ProdOrderLine.Quantity);
        if Format(Item."Expiration Calculation") <> '' then ReservationEntry.Validate("Expiration Date", CalcDate(Item."Expiration Calculation", ProdOrderLine."Due Date"));
        ReservationEntry.Validate("Qty. to Handle (Base)", ReservationEntry."Quantity (Base)");
        ReservationEntry.Validate("Qty. to Invoice (Base)", ReservationEntry."Quantity (Base)");
        ReservationEntry.Validate("Item Tracking", "Item Tracking Entry Type"::"Lot No.");
        if LotNo = '' then ReservationEntry.Validate("Lot No.", NoSeriesManagement.GetNextNo(Item."Lot Nos.", Today(), true))
        else
            ReservationEntry.Validate("Lot No.", LotNo);
        ReservationEntry.Insert(true);
        exit(ReservationEntry."Lot No.");
    end;
    local procedure CopyProdOrderComponents(var FromProdOrderLine: Record "Prod. Order Line"; var ToProdOrderLine: Record "Prod. Order Line")
    var
        FromProdOrderComponent: Record "Prod. Order Component";
        ToProdOrderComponent: Record "Prod. Order Component";
    begin
        FromProdOrderComponent.SetRange(Status, FromProdOrderLine.Status);
        FromProdOrderComponent.SetRange("Prod. Order No.", FromProdOrderLine."Prod. Order No.");
        FromProdOrderComponent.SetRange("Prod. Order Line No.", FromProdOrderLine."Line No.");
        if FromProdOrderComponent.FindSet()then repeat ToProdOrderComponent.Init();
                ToProdOrderComponent.TransferFields(FromProdOrderComponent);
                ToProdOrderComponent.Validate("Prod. Order Line No.", ToProdOrderLine."Line No.");
                ToProdOrderComponent.Insert(true);
            until FromProdOrderComponent.Next() = 0;
    end;
    local procedure CopyProdOrderRoutings(var FromProdOrderLine: Record "Prod. Order Line"; var ToProdOrderLine: Record "Prod. Order Line")
    var
        FromProdOrderRoutingLine: Record "Prod. Order Routing Line";
        ToProdOrderRoutingLine: Record "Prod. Order Routing Line";
    begin
        FromProdOrderRoutingLine.SetRange(Status, FromProdOrderLine.Status);
        FromProdOrderRoutingLine.SetRange("Prod. Order No.", FromProdOrderLine."Prod. Order No.");
        FromProdOrderRoutingLine.SetRange("Routing Reference No.", FromProdOrderLine."Line No.");
        if FromProdOrderRoutingLine.FindSet()then repeat ToProdOrderRoutingLine.Init();
                ToProdOrderRoutingLine.TransferFields(FromProdOrderRoutingLine);
                ToProdOrderRoutingLine.Validate("Routing Reference No.", ToProdOrderLine."Line No.");
                ToProdOrderRoutingLine.Insert(true);
            until FromProdOrderRoutingLine.Next() = 0;
    end;
    procedure AddNewProductionOrderLine(var ProdOrderLine: Record "Prod. Order Line"; var NextLineNo: Integer; var LotNo: Code[50])
    var
        NewProdOrderLine: Record "Prod. Order Line";
    begin
        if NextLineNo = 0 then NextLineNo:=ProdOrderLine."Line No.";
        NextLineNo+=10000;
        NewProdOrderLine.Init();
        NewProdOrderLine.TransferFields(ProdOrderLine);
        NewProdOrderLine."Line No."+=NextLineNo;
        NewProdOrderLine."Finished Quantity":=0;
        NewProdOrderLine."Finished Qty. (Base)":=0;
        NewProdOrderLine."Remaining Quantity":=NewProdOrderLine.Quantity;
        NewProdOrderLine."Remaining Qty. (Base)":=NewProdOrderLine."Quantity (Base)";
        NewProdOrderLine.Insert(true);
        LotNo:=AssignLotNoToProdOrderLine(NewProdOrderLine, LotNo);
        CopyProdOrderComponents(ProdOrderLine, NewProdOrderLine);
        CopyProdOrderRoutings(ProdOrderLine, NewProdOrderLine);
    end;
    procedure ProdOrderTransfer(ProdOrderNo: Text)
    var
        LotRestriction: Record "Co-Man Lot Restriction";
        ConItemLedgerEntry: Record "Item Ledger Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        CoManHeader: Record "Co-Man Header";
        ProdOrder: Record "Production Order";
        ProdOrderLine: Record "Prod. Order Line";
        Location: Record Location;
        TranHeader: Record "Transfer Header";
        TranLine: Record "Transfer Line";
        ResEntry: Record "Reservation Entry";
        Item: Record Item;
        ItemTrackingUpdate: Codeunit ItemTrackingManagement;
        HeaderOK: Boolean;
        TransfLnl: Label 'Transfer Order No. %1 have been created.';
    begin
        ItemLedgerEntry.SetRange("Order Type", ItemLedgerEntry."Order Type"::Production);
        ItemLedgerEntry.SetFilter("Order No.", ProdOrderNo);
        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Output);
        ItemLedgerEntry.SetFilter("Remaining Quantity", '<>0');
        if ItemLedgerEntry.FindFirst()then begin
            Location.Get(ItemLedgerEntry."Location Code");
            if not ProdOrder.Get(ProdOrder.Status::Released, ItemLedgerEntry."Order No.")then if ProdOrder.Get(ProdOrder.Status::Finished, ItemLedgerEntry."Order No.")then;
            if Location."Co-Man Location" then begin
                if CoManHeader.Get(ProdOrder."Co-Man No.")then begin
                    InsertTransHeader(TranHeader, ItemLedgerEntry."Location Code", CoManHeader."From/To Location Code", Today);
                    repeat Clear(ItemTrackingUpdate);
                        Item.Get(ItemLedgerEntry."Item No.");
                        if not ProdOrder.Get(ProdOrder.Status::Released, ItemLedgerEntry."Order No.")then if ProdOrder.Get(ProdOrder.Status::Finished, ItemLedgerEntry."Order No.")then;
                        ProdOrderLine.Get(ProdOrder.Status, ProdOrder."No.", ItemLedgerEntry."Order Line No.");
                        InsertTransLine(TranHeader, TranLine, ItemLedgerEntry."Item No.", '', ItemLedgerEntry."Remaining Quantity" / ProdOrderLine."Qty. per Unit of Measure", ProdOrderLine."Unit of Measure Code", Today);
                        ItemTrackingUpdate.UpdateItemTracking(TranLine, TranLine."Quantity (Base)", TranLine."Quantity (Base)", ItemLedgerEntry."Lot No.", TranLine."Shipment Date");
                        ConItemLedgerEntry.SetRange("Order Type", ConItemLedgerEntry."Order Type"::Production);
                        ConItemLedgerEntry.SetRange("Order No.", ItemLedgerEntry."Order No.");
                        ConItemLedgerEntry.SetRange("Order Line No.", ItemLedgerEntry."Order Line No.");
                        ConItemLedgerEntry.SetRange("Entry Type", ConItemLedgerEntry."Entry Type"::Consumption);
                        if ConItemLedgerEntry.FindSet()then repeat if LotRestriction.Get(ProdOrder."Co-Man No.", ConItemLedgerEntry."Item No.", ConItemLedgerEntry."Variant Code", ConItemLedgerEntry."Lot No.")then begin
                                    TranLine."Restriction Code":=LotRestriction."Restriction Code";
                                    TranLine."Restriction Status":=LotRestriction."Restriction Status";
                                    TranLine.Modify();
                                end;
                            until ConItemLedgerEntry.Next() = 0;
                    until ItemLedgerEntry.Next() = 0;
                    CODEUNIT.Run(CODEUNIT::"Release Transfer Document", TranHeader);
                    ResEntry.SetRange("Source Type", Database::"Transfer Line");
                    ResEntry.SetRange("Source ID", TranHeader."No.");
                    ResEntry.SetRange("Reservation Status", ResEntry."Reservation Status"::Surplus);
                    ResEntry.SetRange("Location Code", TranHeader."Transfer-to Code");
                    if ResEntry.FindSet()then repeat ResEntry."Qty. to Handle (Base)":=ResEntry."Quantity (Base)";
                            ResEntry.Modify();
                        until ResEntry.Next() = 0;
                    TranHeader."Co-Man No.":=CoManHeader."No.";
                    TranHeader.Modify();
                    Message(TransfLnl, TranHeader."No.");
                end;
            end;
        end;
    end;
    procedure InsertTransHeader(var TransferHeader: Record "Transfer Header"; TranfromCode: Code[10]; ToLocationCode: Code[10]; DDate: Date)
    var
        InventorySetup: Record "Inventory Setup";
        Location: Record Location;
        TLocation: Record Location;
    begin
        InventorySetup.Get();
        InventorySetup.TestField("Transfer Order Nos.");
        TransferHeader.Init();
        TransferHeader."No.":='';
        TransferHeader."Posting Date":=WorkDate();
        TransferHeader.Insert(true);
        TransferHeader.Validate("Transfer-from Code", TranfromCode);
        TransferHeader.Validate("Transfer-to Code", ToLocationCode);
        Location.Get(TranfromCode);
        TLocation.Get(ToLocationCode);
        if not(Location."Require Shipment" or TLocation."Require Shipment")then TransferHeader."Direct Transfer":=true
        else if TransferHeader."In-Transit Code" = '' then begin
                Location.SetRange("Use As In-Transit", true);
                if Location.FindFirst()then TransferHeader."In-Transit Code":=Location.Code;
            end;
        TransferHeader."Receipt Date":=DDate;
        TransferHeader."Shipment Date":=DDate;
        TransferHeader.Modify();
    end;
    procedure PerformManualRelease(var TranHeader: Record "Transfer Header")
    begin
        if TranHeader.Status <> TranHeader.Status::Released then begin
            CODEUNIT.Run(CODEUNIT::"Release Transfer Document", TranHeader);
            Commit();
        end;
    end;
    procedure InsertTransLine(var TransferHeader: Record "Transfer Header"; var TransferLine: Record "Transfer Line"; ItemNo: code[20]; VariantCode: Code[10]; Qty: Decimal; UOM: Code[10]; DDate: Date)
    var
        Item: Record Item;
        NextLineNo: Integer;
    begin
        TransferLine.SetRange("Document No.", TransferHeader."No.");
        if TransferLine.FindLast()then NextLineNo:=TransferLine."Line No." + 10000
        else
            NextLineNo:=10000;
        Item.Get(ItemNo);
        TransferLine.Init();
        TransferLine.BlockDynamicTracking(true);
        TransferLine."Document No.":=TransferHeader."No.";
        TransferLine."Line No.":=NextLineNo;
        TransferLine.Validate("Item No.", ItemNo);
        TransferLine.Description:=Item.Description;
        TransferLine."Description 2":=Item."Description 2";
        TransferLine.Validate("Variant Code", VariantCode);
        TransferLine.Validate("Transfer-from Code", TransferHeader."Transfer-from Code");
        TransferLine.Validate("Transfer-to Code", TransferHeader."Transfer-to Code");
        TransferLine.Validate(Quantity, Qty);
        TransferLine.Validate("Unit of Measure Code", UOM);
        TransferLine."Receipt Date":=DDate;
        TransferLine."Shipment Date":=DDate;
        TransferLine."WHI Transfer Origin":=TransferLine."WHI Transfer Origin"::" ";
        TransferLine.Insert();
    end;
    procedure CreateProductionOrder(CoManNo: Code[20]; ItemNo: code[20]; VariantCode: Code[10]; LocationCode: Code[10]; Qty: Decimal; ItemProductioUOM: Code[20]; DDate: Date; NumberOfBatches: Integer; SameLotNo: Boolean; var ProdOrder: Record "Production Order")
    var
        Item: Record Item;
        ProdOrderLine: Record "Prod. Order Line";
        FamilyLine: Record "Family Line";
        PurchLine: Record "Purchase Line";
        NewPurchLine: Record "Purchase Line";
        ProdOrderComponent: Record "Prod. Order Component";
        SKU: Record "Stockkeeping Unit";
        CalculateProdOrder: Codeunit "Calculate Prod. Order";
        SalesLineReserve: Codeunit "Sales Line-Reserve";
        CreateProdOrderLines: Codeunit "Create Prod. Order Lines";
        ProdOrderStatusMgt: Codeunit "Prod. Order Status Management";
        LeadTimeMgt: Codeunit "Lead-Time Management";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        UOMMgt: Codeunit "Unit of Measure Management";
        BatchProdOrderMgt: Codeunit "COM Order Mgt";
        CalcSubcontracts: Codeunit "COM Calc-Subcontracts";
        Direction: Option Forward, Backward;
        ProdOrderStatus: Enum "Production Order Status";
        ReservQty: Decimal;
        ReservQtyBase: Decimal;
        ProdOrderRowID: Text[250];
        ErrorOccured: Boolean;
        OrderCnt: Integer;
        NextLineNo: Integer;
        Text000: Label '%1 Prod. Order %2 has been created.';
    begin
        Item.Get(ItemNo);
        if NumberOfBatches = 0 then NumberOfBatches:=1;
        OrderCnt:=NumberOfBatches;
        ProdOrder.Init();
        ProdOrder.Status:=ProdOrderStatus::Released;
        ProdOrder."No.":='';
        ProdOrder.Insert(true);
        ProdOrder."Co-Man No.":=CoManNo;
        ProdOrder."Starting Date":=WorkDate();
        ProdOrder."Creation Date":=WorkDate();
        ProdOrder."Low-Level Code":=0;
        ProdOrder."Due Date":=DDate;
        ProdOrder."Source Type":=ProdOrder."Source Type"::Item;
        ProdOrder."Location Code":=LocationCode;
        ProdOrder."Bin Code":='';
        ProdOrder.Validate("Source No.", ItemNo);
        ProdOrder.Validate(Description, Item.Description);
        ProdOrder."Prod. Unit Of Measure":=ItemProductioUOM;
        if Item."Description 2" <> '' then ProdOrder.Validate("Description 2", Item."Description 2");
        ProdOrder.Quantity:=Round(Qty / NumberOfBatches, 0.01, '=');
        ProdOrder.Modify();
        ProdOrder.SetRange("No.", ProdOrder."No.");
        CreateProdOrderLine(ProdOrder, VariantCode, ErrorOccured);
        OrderCnt-=1;
        ProdOrderLine.SetRange(Status, ProdOrder.Status);
        ProdOrderLine.SetRange("Prod. Order No.", ProdOrder."No.");
        if ProdOrderLine.Find('-')then begin
            CheckProductionBOMStatus(ProdOrderLine."Production BOM No.", ProdOrderLine."Production BOM Version Code");
            CheckRoutingStatus(ProdOrderLine."Routing No.", ProdOrderLine."Routing Version Code");
            ProdOrderLine."Due Date":=DDate;
            if not CalculateProdOrder.Calculate(ProdOrderLine, Direction::Backward, true, true, false, false)then ErrorOccured:=true;
            LotNo:=BatchProdOrderMgt.AssignLotNoToProdOrderLine(ProdOrderLine, LotNo);
        end;
        if ProdOrder.Status = ProdOrder.Status::Released then ProdOrderStatusMgt.FlushProdOrder(ProdOrder, ProdOrder.Status, WorkDate());
        if ProdOrderLine.FindSet()then repeat ProdOrder.Get(ProdOrderLine.Status, ProdOrderLine."Prod. Order No.");
                ProdOrderLine."Location Code":=ProdOrder."Location Code";
                ProdOrderLine.Modify();
            until ProdOrderLine.Next() = 0;
        while((OrderCnt <= NumberOfBatches) and (OrderCnt <> 0))do begin
            if SameLotNo then begin
                BatchProdOrderMgt.AddNewProductionOrderLine(ProdOrderLine, NextLineNo, LotNo);
            end
            else
            begin
                LotNo:='';
                BatchProdOrderMgt.AddNewProductionOrderLine(ProdOrderLine, NextLineNo, LotNo);
            end;
            OrderCnt-=1;
        end;
        ProdOrder.Quantity:=Round(Qty, 0.01, '=');
        ProdOrder.Modify();
        CalcSubcontracts.Run();
        PurchLine.SetRange("Prod. Order No.", ProdOrder."No.");
        PurchLine.SetRange(Type, PurchLine.Type::Item);
        if PurchLine.FindSet()then repeat Clear(SKU);
                if SKU.Get(ProdOrder."Location Code", PurchLine."No.", '')then if SKU."WIP Item" <> '' then begin
                        NewPurchLine.SetRange("Document Type", PurchLine."Document Type");
                        NewPurchLine.SetRange("Document No.", PurchLine."Document No.");
                        NewPurchLine.SetRange(Type, PurchLine.Type::Item);
                        NewPurchLine.SetRange("No.", SKU."WIP Item");
                        if NewPurchLine.IsEmpty then begin
                            NewPurchLine.Init();
                            NewPurchLine."Document Type":=PurchLine."Document Type";
                            NewPurchLine."Document No.":=PurchLine."Document No.";
                            NewPurchLine."Line No.":=PurchLine."Line No." + 100;
                            NewPurchLine."Buy-from Vendor No.":=PurchLine."Buy-from Vendor No.";
                            NewPurchLine.Insert();
                            NewPurchLine.Type:=PurchLine.Type::Item;
                            NewPurchLine.Validate("No.", SKU."WIP Item");
                            ProdOrderComponent.SetRange("Prod. Order No.", ProdOrder."No.");
                            ProdOrderComponent.SetRange("Item No.", SKU."WIP Item");
                            if ProdOrderComponent.FindFirst()then begin
                                ProdOrderComponent.CalcSums("Remaining Quantity");
                                if ProdOrderComponent.Quantity > 0 then begin
                                    NewPurchLine.Validate("Location Code", ProdOrderComponent."Location Code");
                                    NewPurchLine.Validate("Unit of Measure Code", ProdOrderComponent."Unit of Measure Code");
                                    NewPurchLine.Validate(Quantity, ProdOrderComponent."Remaining Quantity");
                                end;
                            end;
                            NewPurchLine.Modify();
                        end;
                    end;
            until PurchLine.Next() = 0;
        Message(Text000, ProdOrder.Status, ProdOrder."No.");
    end;
    local procedure CheckProductionBOMStatus(ProductionBOMNo: Code[20]; ProductionBOMVersionNo: Code[20])
    var
        ProductionBOMHeader: Record "Production BOM Header";
        ProductionBOMVersion: Record "Production BOM Version";
    begin
        if ProductionBOMNo = '' then exit;
        if ProductionBOMVersionNo = '' then begin
            ProductionBOMHeader.SetLoadFields(Status);
            ProductionBOMHeader.Get(ProductionBOMNo);
            ProductionBOMHeader.TestField(Status, ProductionBOMHeader.Status::Certified);
        end
        else
        begin
            ProductionBOMVersion.SetLoadFields(Status);
            ProductionBOMVersion.Get(ProductionBOMNo, ProductionBOMVersionNo);
            ProductionBOMVersion.TestField(Status, ProductionBOMVersion.Status::Certified);
        end;
    end;
    local procedure CheckRoutingStatus(RoutingNo: Code[20]; RoutingVersionNo: Code[20])
    var
        RoutingHeader: Record "Routing Header";
        RoutingVersion: Record "Routing Version";
    begin
        if RoutingNo = '' then exit;
        if RoutingVersionNo = '' then begin
            RoutingHeader.SetLoadFields(Status);
            RoutingHeader.Get(RoutingNo);
            RoutingHeader.TestField(Status, RoutingHeader.Status::Certified);
        end
        else
        begin
            RoutingVersion.SetLoadFields(Status);
            RoutingVersion.Get(RoutingNo, RoutingVersionNo);
            RoutingVersion.TestField(Status, RoutingVersion.Status::Certified);
        end;
    end;
    local procedure CreateProdOrderLine(ProdOrder: Record "Production Order"; VariantCode: Code[10]; var ErrorOccured: Boolean)
    var
        SalesHeader: Record "Sales Header";
    begin
        DeleteLinesForProductionOrder(ProdOrder);
        NextProdOrderLineNo:=10000;
        InsertNew:=false;
        case ProdOrder."Source Type" of ProdOrder."Source Type"::Item: begin
            InitProdOrderLine(ProdOrder, ProdOrder."Source No.", VariantCode, ProdOrder."Location Code");
            ProdOrderLine.Description:=ProdOrder.Description;
            ProdOrderLine."Description 2":=ProdOrder."Description 2";
            ProdOrderLine.Validate(Quantity, ProdOrder.Quantity);
            ProdOrderLine.Validate("Unit of Measure Code", ProdOrder."Prod. Unit Of Measure");
            ProdOrderLine.UpdateDatetime();
            ProdOrderLine.Insert();
            if ProdOrderLine.HasErrorOccured()then ErrorOccured:=true;
        end;
        end;
    end;
    local procedure DeleteLinesForProductionOrder(ProductionOrder: Record "Production Order")
    begin
        ProdOrderLine.LockTable();
        ProdOrderLine.SetRange(Status, ProductionOrder.Status);
        ProdOrderLine.SetRange("Prod. Order No.", ProductionOrder."No.");
        ProdOrderLine.DeleteAll(true);
    end;
    local procedure InitProdOrderLine(ProdOrder: Record "Production Order"; ItemNo: Code[20]; VariantCode: Code[10]; LocationCode: Code[10])
    var
        Item: Record Item;
    begin
        ProdOrderLine.Init();
        ProdOrderLine.SetIgnoreErrors();
        ProdOrderLine.Status:=ProdOrder.Status;
        ProdOrderLine."Prod. Order No.":=ProdOrder."No.";
        ProdOrderLine."Line No.":=NextProdOrderLineNo;
        ProdOrderLine."Routing Reference No.":=ProdOrderLine."Line No.";
        ProdOrderLine.Validate("Item No.", ItemNo);
        ProdOrderLine."Location Code":=LocationCode;
        ProdOrderLine.Validate("Variant Code", VariantCode);
        if(LocationCode = ProdOrder."Location Code") and (ProdOrder."Bin Code" <> '')then ProdOrderLine.Validate("Bin Code", ProdOrder."Bin Code")
        else
            CalcProdOrder.SetProdOrderLineBinCodeFromRoute(ProdOrderLine, ProdOrderLine."Location Code", ProdOrderLine."Routing No.");
        Item.Get(ItemNo);
        ProdOrderLine."Scrap %":=Item."Scrap %";
        ProdOrderLine."Due Date":=ProdOrder."Due Date";
        ProdOrderLine."Starting Date":=ProdOrder."Starting Date";
        ProdOrderLine."Starting Time":=ProdOrder."Starting Time";
        ProdOrderLine."Ending Date":=ProdOrder."Ending Date";
        ProdOrderLine."Ending Time":=ProdOrder."Ending Time";
        ProdOrderLine."Planning Level Code":=0;
        ProdOrderLine."Inventory Posting Group":=Item."Inventory Posting Group";
        ProdOrderLine.UpdateDatetime();
        ProdOrderLine.Validate("Unit Cost");
        NextProdOrderLineNo:=NextProdOrderLineNo + 10000;
    end;
    var ProdOrderLine: Record "Prod. Order Line";
    CalcProdOrder: Codeunit "Calculate Prod. Order";
    NextProdOrderLineNo: Integer;
    InsertNew: Boolean;
    LotNo: Code[50];
}
