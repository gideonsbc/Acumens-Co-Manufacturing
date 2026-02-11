page 14304314 "New Co-Man Production Order"
{
    PageType = Card;
    SourceTable = "Co-Man Header";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Create Inbound Transfer"; InBoundTransfer)
                {
                    ApplicationArea = All;
                }
                field("Add to Transfer Order No."; TranHCode)
                {
                    ApplicationArea = All;
                    Editable = InBoundTransfer;

                    trigger OnLookup(var Text: Text): Boolean var
                        ProductionOrder: Record "Production Order";
                        TransferHeader: Record "Transfer Header";
                    begin
                        ProductionOrder.SETFILTER("Co-Man No.", Rec."No.");
                        ProductionOrder.SetFilter("In-Transfer Order No.", '<>%1', '');
                        IF PAGE.RUNMODAL(0, ProductionOrder) = ACTION::LookupOK THEN BEGIN
                            if TransferHeader.Get(ProductionOrder."In-Transfer Order No.")then begin
                                Text:=ProductionOrder."In-Transfer Order No.";
                                FLocationCode:=TransferHeader."Transfer-from Code";
                                FLocationName:=TransferHeader."Transfer-from Name";
                                CLocationCode:=TransferHeader."Transfer-to Code";
                                CLocationName:=TransferHeader."Transfer-to Name";
                            end;
                            EXIT(TRUE);
                        END
                        ELSE
                            EXIT(FALSE);
                    end;
                    trigger OnValidate()
                    var
                        TransferHeader: Record "Transfer Header";
                    begin
                        TransferHeader.Get(TranHCode);
                    end;
                }
                field("From Location Code"; FLocationCode)
                {
                    TableRelation = Location.Code where("Use As In-Transit"=const(false));
                    ApplicationArea = All;
                    Editable = not InBoundTransfer;

                    trigger OnValidate()
                    var
                        Location: Record Location;
                    begin
                        Location.Get(FLocationCode);
                        FLocationName:=Location.Name;
                    end;
                }
                field("From Location Name"; FLocationName)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Location Code"; CLocationCode)
                {
                    TableRelation = Location.Code where("Use As In-Transit"=const(false), "Co-Man Location"=const(true));
                    ApplicationArea = All;
                    Editable = not InBoundTransfer;

                    trigger OnValidate()
                    var
                        Location: Record Location;
                    begin
                        Location.Get(CLocationCode);
                        CLocationName:=Location.Name;
                    end;
                }
                field("Location Name"; CLocationName)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Due Date"; DueDate)
                {
                    ApplicationArea = All;
                }
                field("Output Item"; OutItem)
                {
                    ApplicationArea = All;
                    TableRelation = Item."No." where("Replenishment System"=const("Prod. Order"), "Production BOM No."=filter(<>''));

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
                        QtyPerBOM:=0;
                        OutQty:=0;
                        Item.Get(OutItem);
                        ItemProductioUOM:=Item."WC Production Unit of Measure";
                        ProdBOM.SetRange("Production BOM No.", Item."Production BOM No.");
                        ProdBOMHeader.Get(Item."Production BOM No.");
                        if SKU.Get(CLocationCode, OutItem, '')then if SKU."Production BOM No." <> '' then begin
                                ItemProductioUOM:=SKU."Production Unit of Measure";
                                ProdBOM.SetRange("Production BOM No.", SKU."Production BOM No.");
                                ProdBOMHeader.Get(SKU."Production BOM No.");
                            end;
                        QtyPerUOM:=1;
                        if ItemProductioUOM <> ProdBOMHeader."Unit of Measure Code" then begin
                            if ItemProductioUOM <> '' then begin
                                ProdItemUOM.Get(OutItem, ItemProductioUOM);
                                QPerX:=ProdItemUOM."Qty. per Unit of Measure";
                            end
                            else
                                QPerX:=1;
                            if ProdBOMHeader."Unit of Measure Code" <> '' then begin
                                BOMItemUOM.Get(OutItem, ProdBOMHeader."Unit of Measure Code");
                                QPerY:=BOMItemUOM."Qty. per Unit of Measure";
                            end
                            else
                                QPerY:=1;
                            QtyPerUOM:=QPerY / QPerX;
                        end;
                        if ProdBOM.FindFirst()then ActiveVersionCode:=VersionManagement.GetBOMVersion(ProdBOM."No.", WorkDate(), true);
                        ProdBOM.SetRange("Version Code", ActiveVersionCode);
                        ProdBOM.SetRange(Type, ProdBOM.Type::Item);
                        if ProdBOM.FindFirst()then begin
                            CItem:=ProdBOM."No.";
                            QtyPerBOM:=ProdBOM."Quantity per";
                        end;
                    end;
                }
                field("Consumed Item"; CItem)
                {
                    ApplicationArea = All;
                    TableRelation = Item."No.";
                    Editable = false;
                }
                field("Output Qty."; OutQty)
                {
                    ApplicationArea = All;
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

                    trigger OnLookup(var Text: Text): Boolean var
                        ItemUOM: Record "Item Unit of Measure";
                    begin
                        IF OutItem <> '' THEN BEGIN
                            ItemUOM.SetRange("Item No.", OutItem);
                            IF PAGE.RUNMODAL(0, ItemUOM) = ACTION::LookupOK THEN BEGIN
                                Text:=ItemUOM.Code;
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
        DueDate:=Today;
        NumberOfBatches:=1;
    end;
    trigger OnAfterGetRecord()
    var
        Location: Record Location;
    begin
        FLocationCode:=Rec."Co-Man Location Code";
        Location.Get(FLocationCode);
        FLocationName:=Location.Name;
    end;
    trigger OnQueryClosePage(CloseAction: Action): Boolean var
        TranHeader: Record "Transfer Header";
        TranLine: Record "Transfer Line";
        ProdOrder: Record "Production Order";
        ProdOrderComponent: Record "Prod. Order Component";
        SKU: Record "Stockkeeping Unit";
        OrderMgt: Codeunit "COM Order Mgt";
        ConLbl: Label 'Are you sure you want to create Production Order?';
        ErrorLbl: Label '%1 should not be blank.';
    begin
        if CloseAction = CloseAction::LookupOK then begin
            if Confirm(ConLbl, true)then begin
                if FLocationCode = '' then Error(ErrorLbl, 'From Location,');
                if CLocationCode = '' then Error(ErrorLbl, 'Co-Man Location,');
                if InBoundTransfer then if TranHCode = '' then OrderMgt.InsertTransHeader(TranHeader, FLocationCode, CLocationCode, DueDate)
                    else
                        TranHeader.Get(TranHCode);
                OrderMgt.CreateProductionOrder(Rec."No.", OutItem, '', CLocationCode, OutQty, ItemProductioUOM, DueDate, NumberOfBatches, SameLotNo, ProdOrder);
                if InBoundTransfer then begin
                    ProdOrderComponent.SetRange("Prod. Order No.", ProdOrder."No.");
                    if ProdOrderComponent.FindFirst()then repeat if ProdOrderComponent."Quantity per" <> 0 then begin
                                SKU.Get(CLocationCode, OutItem, '');
                                if SKU."WIP Item" <> ProdOrderComponent."Item No." then OrderMgt.InsertTransLine(TranHeader, TranLine, ProdOrderComponent."Item No.", '', ProdOrderComponent."Expected Quantity", ProdOrderComponent."Unit of Measure Code", DueDate);
                            end;
                        until ProdOrderComponent.Next() = 0;
                end;
                ProdOrder."In-Transfer Order No.":=TranHeader."No.";
                ProdOrder.Modify();
                if InBoundTransfer then begin
                    OrderMgt.PerformManualRelease(TranHeader);
                end;
            end;
        end;
    end;
    var InBoundTransfer: Boolean;
    CItem: Code[20];
    OutItem: Code[20];
    CLocationCode: Code[10];
    FLocationCode: Code[10];
    CLocationName: Text;
    FLocationName: Text;
    OutQty: Decimal;
    QtyPerBOM: Decimal;
    DueDate: Date;
    NumberOfBatches: Integer;
    ItemProductioUOM: Code[20];
    QtyPerUOM: Decimal;
    SameLotNo: Boolean;
    TranHCode: Code[20];
}
