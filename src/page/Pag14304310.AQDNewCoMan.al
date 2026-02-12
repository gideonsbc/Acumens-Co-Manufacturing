page 14304310 "AQD New Co-Man"
{
    Caption = 'New Co-Man';
    PageType = Card;
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                Caption = 'GroupName';
                field("Create Inbound Transfer"; InBoundTransfer)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the InBoundTransfer field.';
                    Caption = 'InBoundTransfer';
                }
                field("Create Inbound Transfer Shipment"; InBoundTransferShip)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the InBoundTransferShip field.';
                    Caption = 'InBoundTransferShip';
                }
                field("From Location Code"; FLocationCode)
                {
                    TableRelation = Location.Code where("Use As In-Transit" = const(false));
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the FLocationCode field.';
                    Caption = 'FLocationCode';

                    trigger OnValidate()
                    var
                        Location: Record Location;
                    begin
                        Location.Get(FLocationCode);
                        FLocationName := Location.Name;
                    end;
                }
                field("From Location Name"; FLocationName)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the FLocationName field.';
                    Caption = 'FLocationName';
                }
                field("Location Code"; CLocationCode)
                {
                    TableRelation = Location.Code where("Use As In-Transit" = const(false), "AQD Co-Man Location" = const(true));
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CLocationCode field.';
                    Caption = 'CLocationCode';

                    trigger OnValidate()
                    var
                        Location: Record Location;
                    begin
                        Location.Get(CLocationCode);
                        CLocationName := Location.Name;
                    end;
                }
                field("Location Name"; CLocationName)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the CLocationName field.';
                    Caption = 'CLocationName';
                }
                field("Due Date"; DueDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DueDate field.';
                    Caption = 'DueDate';
                }
                field("Output Item"; OutItem)
                {
                    ApplicationArea = All;
                    TableRelation = Item."No." where("Replenishment System" = const("Prod. Order"), "Production BOM No." = filter(<> ''));
                    ToolTip = 'Specifies the value of the OutItem field.';
                    Caption = 'OutItem';

                    trigger OnValidate()
                    var
                        SKU: Record "Stockkeeping Unit";
                        Item: Record Item;
                        ProdItemUOM: Record "Item Unit of Measure";
                        BOMItemUOM: Record "Item Unit of Measure";
                        ProdBOMHeader: Record "Production BOM Header";
                        ProdBOM: Record "Production BOM Line";
                        VersionManagement: Codeunit VersionManagement;
                        ActiveVersionCode: Code[20];
                        QPerX: Decimal;
                        QPerY: Decimal;
                    begin
                        QtyPerBOM := 0;
                        OutQty := 0;
                        if SKU.Get(CLocationCode, OutItem, '') then begin
                            ItemProductioUOM := SKU."Put-away Unit of Measure Code";//"Production Unit of Measure"
                            ProdBOM.SetRange("Production BOM No.", SKU."Production BOM No.");
                            ProdBOMHeader.Get(SKU."Production BOM No.");
                        end
                        else begin
                            Item.Get(OutItem);
                            ItemProductioUOM := Item."Base Unit of Measure"; //"WC Production Unit of Measure"
                            ProdBOM.SetRange("Production BOM No.", Item."Production BOM No.");
                            ProdBOMHeader.Get(Item."Production BOM No.");
                        end;
                        QtyPerUOM := 1;
                        if ItemProductioUOM <> ProdBOMHeader."Unit of Measure Code" then begin
                            if ItemProductioUOM <> '' then begin
                                ProdItemUOM.Get(OutItem, ItemProductioUOM);
                                QPerX := ProdItemUOM."Qty. per Unit of Measure";
                            end
                            else
                                QPerX := 1;
                            if ProdBOMHeader."Unit of Measure Code" <> '' then begin
                                BOMItemUOM.Get(OutItem, ProdBOMHeader."Unit of Measure Code");
                                QPerY := BOMItemUOM."Qty. per Unit of Measure";
                            end
                            else
                                QPerY := 1;
                            QtyPerUOM := QPerY / QPerX;
                        end;
                        if ProdBOM.FindFirst() then ActiveVersionCode := VersionManagement.GetBOMVersion(ProdBOM."Production BOM No.", WorkDate(), true);
                        ProdBOM.SetRange("Version Code", ActiveVersionCode);
                        ProdBOM.SetRange(Type, ProdBOM.Type::Item);
                        if ProdBOM.FindFirst() then begin
                            CItem := ProdBOM."No.";
                            QtyPerBOM := ProdBOM."Quantity per";
                        end;
                    end;
                }
                field("Consumed Item"; CItem)
                {
                    ApplicationArea = All;
                    TableRelation = Item."No.";
                    Editable = false;
                    ToolTip = 'Specifies the value of the CItem field.';
                    Caption = 'CItem';
                }
                field("Output Qty."; OutQty)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the OutQty field.';
                    Caption = 'OutQty';
                }
                field(NumberOfBatches; NumberOfBatches)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Number of Batches';
                    ToolTip = 'This field stores the number of batches to be made in this batched production order.';
                }
                field(ItemProductioUOM; ItemProductioUOM)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Item Production Unit of Measure.';
                    ToolTip = 'The item that is being built (Source No. from the Production Order Header) has a production unit of measure associated with it.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemUOM: Record "Item Unit of Measure";
                    begin
                        IF OutItem <> '' THEN BEGIN
                            ItemUOM.SetRange("Item No.", OutItem);
                            IF PAGE.RUNMODAL(0, ItemUOM) = ACTION::LookupOK THEN BEGIN
                                Text := ItemUOM.Code;
                                EXIT(TRUE);
                            END
                            ELSE
                                EXIT(FALSE);
                        END
                        ELSE
                            ERROR('Please enter an Output Item.');
                    end;
                }
                field(SameLotNo; SameLotNo)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Identical Lot No.';
                    ToolTip = 'The Lot No. for all batches are identical.';
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        DueDate := Today;
        NumberOfBatches := 1;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        CoManHeader: Record "AQD Co-Man Header";
        TranHeader: Record "Transfer Header";
        TranLine: Record "Transfer Line";
        ProdOrder: Record "Production Order";
        ProdOrderComponent: Record "Prod. Order Component";
        WhseShptLine: Record "Warehouse Shipment Line";
        WhseShptHeader: Record "Warehouse Shipment Header";
        WhseRequest: Record "Warehouse Request";
        SKU: Record "Stockkeeping Unit";
        Location: Record Location;
        "Production BOM": Page "Production BOM";
        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
        OrderMgt: Codeunit "AQD COM Order Mgt";
        BatchProdOrderMgt: Codeunit "Batch Processing Mgt.";
        WhseShipmentCreatePick: Report "Whse.-Shipment - Create Pick";
        ProdOrderStatus: Enum "Production Order Status";
        ConLbl: Label 'Are you sure you want to create Co-Man Order?';
        ErrorLbl: Label '%1 should not be blank.';
    begin
        if CloseAction = CloseAction::LookupOK then begin
            if Confirm(ConLbl, true) then begin
                if FLocationCode = '' then Error(ErrorLbl, 'From Location,');
                if CLocationCode = '' then Error(ErrorLbl, 'Co-Man Location,');
                CoManHeader.Init();
                CoManHeader.Insert(true);
                if InBoundTransfer then OrderMgt.InsertTransHeader(TranHeader, FLocationCode, CLocationCode, DueDate);
                OrderMgt.CreateProductionOrder(CoManHeader."No.", OutItem, '', CLocationCode, OutQty, ItemProductioUOM, DueDate, NumberOfBatches, SameLotNo, ProdOrder);
                if InBoundTransfer then begin
                    ProdOrderComponent.SetRange("Prod. Order No.", ProdOrder."No.");
                    if ProdOrderComponent.FindFirst() then
                        repeat
                            if ProdOrderComponent."Quantity per" <> 0 then begin
                                SKU.Get(CLocationCode, OutItem, '');
                                if SKU."AQD WIP Item" <> ProdOrderComponent."Item No." then OrderMgt.InsertTransLine(TranHeader, TranLine, ProdOrderComponent."Item No.", '', ProdOrderComponent."Expected Quantity", ProdOrderComponent."Unit of Measure Code", DueDate);
                            end;
                        until ProdOrderComponent.Next() = 0;
                end;
                ProdOrder."AQD In-Transfer Order No." := TranHeader."No.";
                ProdOrder.Modify();
                CoManHeader."From/To Location Code" := FLocationCode;
                CoManHeader."Co-Man Location Code" := CLocationCode;
                CoManHeader.Modify();
                if InBoundTransfer then begin
                    OrderMgt.PerformManualRelease(TranHeader);
                    if InBoundTransferShip then begin
                        Location.Get(FLocationCode);
                        if Location."Require Shipment" then begin
                            GetSourceDocOutbound.CreateFromOutbndTransferOrder(TranHeader);
                            Commit();
                            WhseShptLine.SetRange("Source Type", Database::"Transfer Line");
                            WhseShptLine.SetRange("Source Subtype", 0);
                            WhseShptLine.SetRange("Source No.", TranHeader."No.");
                            WhseShptLine.FindFirst();
                            WhseShptHeader.SetRange("No.", WhseShptLine."No.");
                            WhseShptHeader.FindFirst();
                            WhseShipmentCreatePick.SetWhseShipmentLine(WhseShptLine, WhseShptHeader);
                            WhseShipmentCreatePick.SetHideValidationDialog(true);
                            WhseShipmentCreatePick.UseRequestPage(true);
                            WhseShipmentCreatePick.Run();
                            WhseShipmentCreatePick.GetResultMessage();
                            Clear(WhseShipmentCreatePick);
                        end;
                    end;
                end;
            end;
        end;
    end;

    var
        InBoundTransfer: Boolean;
        InBoundTransferShip: Boolean;
        CItem: Code[20];
        OutItem: Code[20];
        CLocationCode: Code[10];
        FLocationCode: Code[10];
        CLocationName: Text;
        FLocationName: Text;
        OutQty: Decimal;
        QtyPerBOM: Decimal;
        QtyPerUOM: Decimal;
        DueDate: Date;
        NumberOfBatches: Integer;
        ItemProductioUOM: Code[20];
        SameLotNo: Boolean;
}
