codeunit 14304309 "AQD COM Event Subscriber"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Jnl.-Register Line", OnCodeOnAfterGetLastEntryNo, '', false, false)]
    local procedure OnCodeOnAfterGetLastEntryNo(var WhseJnlLine: Record "Warehouse Journal Line")
    var
        LotRestriction: Record "AQD Co-Man Lot Restriction";
        CoManHeader: Record "AQD Co-Man Header";
        ProdOrder: Record "Production Order";
        QAManagement: Codeunit "QA Management";
        Location: Record Location;
        ItemRest: Record "Item Restrictions";
        QASingleInstance: Codeunit "QA Single Instance";
    begin
        if (WhseJnlLine."Source Type" = Database::"Transfer Line") and (WhseJnlLine."Source Subtype" = 0) then begin
            ProdOrder.SetRange("AQD In-Transfer Order No.", WhseJnlLine."Source No.");
            if Location.Get(WhseJnlLine."Location Code") then
                if Location."QA. Zone" = WhseJnlLine."From Zone Code" then
                    if ProdOrder.FindFirst() then begin
                        if Location.Get(ProdOrder."Location Code") then if Location."AQD Co-Man Location" then QASingleInstance.SetQARestriction(true);
                        ItemRest.SetRange("Location Code", WhseJnlLine."Location Code");
                        ItemRest.SetRange("Item No.", WhseJnlLine."Item No.");
                        ItemRest.SetRange("Variant Code", WhseJnlLine."Variant Code");
                        ItemRest.SetRange("Lot No.", WhseJnlLine."Lot No.");
                        ItemRest.SetRange("QA. Bin Code", WhseJnlLine."From Bin Code");
                        ItemRest.SetRange(Open, true);
                        if ItemRest.FindFirst() then begin
                            if CoManHeader.Get(ProdOrder."AQD Co-Man No.") then begin
                                if not LotRestriction.Get(ProdOrder."AQD Co-Man No.", WhseJnlLine."Item No.", WhseJnlLine."Variant Code", WhseJnlLine."Lot No.") then begin
                                    LotRestriction.Init();
                                    LotRestriction."Co-Man No." := ProdOrder."AQD Co-Man No.";
                                    LotRestriction."Item No." := WhseJnlLine."Item No.";
                                    LotRestriction."Variant No." := WhseJnlLine."Variant Code";
                                    LotRestriction."Lot No." := WhseJnlLine."Lot No.";
                                    LotRestriction."Restriction Code" := ItemRest."Restriction Code";
                                    LotRestriction."Restriction Status" := ItemRest."Restriction Status";
                                    LotRestriction.Insert();
                                end;
                                ItemRest."Qty. to Handle" := WhseJnlLine.Quantity;
                                QAManagement.ReleaseRestriction(ItemRest, WhseJnlLine."Whse. Document No.", WhseJnlLine."Whse. Document Line No.");
                            end;
                        end;
                    end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Jnl.-Register Line", OnAfterCode, '', false, false)]
    local procedure OnAfterCodeWhsJnlREgLine(var WarehouseJournalLine: Record "Warehouse Journal Line")
    var
        ProdOrder: Record "Production Order";
        Location: Record Location;
        QASingleInstance: Codeunit "QA Single Instance";
    begin
        if (WarehouseJournalLine."Source Type" = Database::"Transfer Line") and (WarehouseJournalLine."Source Subtype" = 0) then begin
            ProdOrder.SetRange("AQD In-Transfer Order No.", WarehouseJournalLine."Source No.");
            if Location.Get(WarehouseJournalLine."Location Code") then if Location."QA. Zone" = WarehouseJournalLine."From Zone Code" then if ProdOrder.FindFirst() then if Location.Get(ProdOrder."Location Code") then if Location."Co-Man Location" then QASingleInstance.SetQARestriction(false);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Register", OnAfterCheckWhseActivLine, '', false, false)]
    local procedure OnAfterCheckWhseActivLine(var WarehouseActivityLine: Record "Warehouse Activity Line")
    var
        LotInfo: Record "Lot No. Information";
        ProdOrder: Record "Production Order";
        Location: Record Location;
        SingleInstance: Codeunit "AQD COM Single Instance";
    begin
        if LotInfo.Get(WarehouseActivityLine."Item No.", WarehouseActivityLine."Variant Code", WarehouseActivityLine."Lot No.") then
            if LotInfo.Blocked then
                if WarehouseActivityLine."Activity Type" = WarehouseActivityLine."Activity Type"::Pick then
                    if WarehouseActivityLine."Action Type" = WarehouseActivityLine."Action Type"::Take then
                        if (WarehouseActivityLine."Source Type" = Database::"Transfer Line") and (WarehouseActivityLine."Source Subtype" = 0) then begin
                            ProdOrder.SetRange("AQD In-Transfer Order No.", WarehouseActivityLine."Source No.");
                            if Location.Get(WarehouseActivityLine."Location Code") then
                                if ProdOrder.FindFirst() then
                                    if Location.Get(ProdOrder."Location Code") then
                                        if Location."AQD Co-Man Location" then begin
                                            SingleInstance.UnBlockLot(WarehouseActivityLine."Item No.", WarehouseActivityLine."Variant Code", WarehouseActivityLine."Lot No.");
                                        end;
                        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Activity-Register", OnCodeOnBeforeCommit, '', false, false)]
    local procedure OnCodeOnBeforeCommit()
    var
        SingleInstance: Codeunit "AQD COM Single Instance";
    begin
        SingleInstance.ResetLotInfo();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"IWX DocXtender", 'OnGetCustomRecRefFromDocAttachment', '', false, false)]
    local procedure OnGetCustomRecRefFromDocAttachmentDocXtender(precDocumentAttachment: Record "Document Attachment"; var prrRecordRef: RecordRef; var lbRecordRefHandled: Boolean);
    var
        CoManHeader: Record "AQD Co-Man Header";
    begin
        // Set the table for the custom record, when attached documents using drag-and-drop with DocXtender
        if not lbRecordRefHandled then begin
            case precDocumentAttachment."Table ID" of
                Database::"AQD Co-Man Header":
                    begin
                        prrRecordRef.Open(Database::"AQD Co-Man Header");
                        if CoManHeader.Get(precDocumentAttachment."No.") then begin
                            prrRecordRef.GetTable(CoManHeader);
                            lbRecordRefHandled := true;
                        end;
                    end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document Attachment Mgmt", 'OnAfterTableHasNumberFieldPrimaryKey', '', false, false)]
    local procedure OnAfterTableHasNumberFieldPrimaryKey(TableNo: Integer; var FieldNo: Integer; var Result: Boolean)
    begin
        case TableNo of
            Database::"AQD Co-Man Header":
                begin
                    FieldNo := 1;
                    Result := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnBeforeCheckLotNoInfoNotBlocked, '', false, false)]
    local procedure OnBeforeCheckLotNoInfoNotBlocked(var ItemJnlLine2: Record "Item Journal Line"; var IsHandled: Boolean)
    var
        Location: Record Location;
    begin
        if ItemJnlLine2."Entry Type" = ItemJnlLine2."Entry Type"::Consumption then if Location.Get(ItemJnlLine2."Location Code") then if Location."AQD Consume Blocked Lot" then IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", OnRunOnBeforeCommit, '', false, false)]
    local procedure OnRunOnBeforeCommit(var TransRcptHeader: Record "Transfer Receipt Header"; var TransHeader: Record "Transfer Header")
    begin
        TransRcptHeader."AQD Co-Man No." := TransHeader."AQD Co-Man No.";
        TransRcptHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnAfterPostPurchaseDoc, '', false, false)]
    local procedure OnAfterPostPurchaseDoc(PurchRcpHdrNo: Code[20])
    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        Location: Record Location;
        ItemLedgerEntry: Record "Item Ledger Entry";
        TransferTo: Page "AQD Transfer To";
    begin
        if PurchRcptHeader.Get(PurchRcpHdrNo) then
            if Location.Get(PurchRcptHeader."Location Code") then
                if Location."AQD PO. to TR. Order" then begin
                    ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Purchase);
                    ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Purchase Receipt");
                    ItemLedgerEntry.SetRange("Document No.", PurchRcpHdrNo);
                    ItemLedgerEntry.SetRange(Open, true);
                    ItemLedgerEntry.SetRange(Positive, true);
                    if ItemLedgerEntry.FindFirst() then begin
                        ItemLedgerEntry.CalcFields("Unit of Measure Code");
                        TransferTo.SetLData(PurchRcpHdrNo, ItemLedgerEntry."Item No.", ItemLedgerEntry."Location Code", ItemLedgerEntry."Posting Date", ItemLedgerEntry.Quantity, ItemLedgerEntry."Unit of Measure Code");
                        TransferTo.LookupMode(true);
                        TransferTo.RunModal();
                    end;
                end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', false, false)]
    local procedure OnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        CoManHeader: Record "AQD Co-Man Header";
    begin
        // Set the table for the custom record, when attaching documents manually
        case DocumentAttachment."Table ID" of
            Database::"AQD Co-Man Header":
                begin
                    RecRef.Open(Database::"AQD Co-Man Header");
                    if CoManHeader.Get(DocumentAttachment."No.") then RecRef.GetTable(CoManHeader);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDocumentAttachmentDetailsRunModal', '', false, false)]
    local procedure OnBeforeDocumentAttachmentDetailsRunModal(var DocumentAttachment: Record "Document Attachment"; var DocumentAttachmentDetails: Page "Document Attachment Details"; var RecRef: RecordRef)
    var
        CoManHeader: Record "AQD Co-Man Header";
    begin
        case DocumentAttachment."Table ID" of
            Database::"AQD Co-Man Header":
                begin
                    if CoManHeader.Get(DocumentAttachment."No.") then RecRef.GetTable(CoManHeader);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Calculate Subcontracts", OnAfterTransferProdOrderRoutingLine, '', false, false)]
    local procedure OnAfterTransferProdOrderRoutingLine(var RequisitionLine: Record "Requisition Line"; ProdOrderRoutingLine: Record "Prod. Order Routing Line")
    var
        Item: Record Item;
    begin
        if Item.Get(RequisitionLine."No.") then RequisitionLine.Description := Item.Description;
    end;
}
