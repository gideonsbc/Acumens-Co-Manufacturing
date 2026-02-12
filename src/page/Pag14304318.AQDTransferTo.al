page 14304318 "AQD Transfer To"
{
    Caption = 'Transfer To';
    PageType = Card;
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                Caption = 'GroupName';
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
                field("To Location Code"; ToLocationCode)
                {
                    TableRelation = Location.Code where("Use As In-Transit" = const(false));
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ToLocationCode field.';
                    Caption = 'ToLocationCode';

                    trigger OnValidate()
                    var
                        Location: Record Location;
                    begin
                        Location.Get(ToLocationCode);
                        ToLocationName := Location.Name;
                    end;
                }
                field("Location Name"; ToLocationName)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the ToLocationName field.';
                    Caption = 'ToLocationName';
                }
                field("Due Date"; DueDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DueDate field.';
                    Caption = 'DueDate';
                }
                field("Item No."; ItemNo)
                {
                    ApplicationArea = All;
                    TableRelation = Item."No.";
                    ToolTip = 'Specifies the value of the ItemNo field.';
                    Caption = 'ItemNo';
                }
                field(Quantity; Qty)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Qty field.';
                    Caption = 'Qty';
                }
                field(ItemProductioUOM; ItemUOM)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Item Unit of Measure.';
                    ToolTip = 'Specifies the value of the Item Unit of Measure. field.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemUOM: Record "Item Unit of Measure";
                        UOMMng: codeunit "Unit of Measure Management";
                    begin
                        IF ItemNo <> '' THEN BEGIN
                            ItemUOM.SetRange("Item No.", ItemNo);
                            IF PAGE.RUNMODAL(0, ItemUOM) = ACTION::LookupOK THEN BEGIN
                                Text := ItemUOM.Code;
                                QtyPerUOM := ItemUOM."Qty. per Unit of Measure";
                                Qty := Round((QtyBase / QtyPerUOM), 0.01, '=');
                                EXIT(TRUE);
                            END
                            ELSE
                                EXIT(FALSE);
                        END;
                    end;
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        Location: Record Location;
    begin
        DueDate := Today;
        if Location.Get(FLocationCode) then FLocationName := Location.Name;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        TranHeader: Record "Transfer Header";
        TranLine: Record "Transfer Line";
        ItemLedgerEntry: Record "Item Ledger Entry";
        Location: Record Location;
        "Production BOM": Page "Production BOM";
        UOMMng: codeunit "Unit of Measure Management";
        OrderMgt: Codeunit "AQD COM Order Mgt";
        ItemTrackingUpdate: Codeunit "Item Tracking Management"; //SBC ItemTrackingManagement
        ConLbl: Label 'Are you sure you want to create Transfer Order?';
        ErrorLbl: Label '%1 should not be blank.';
    begin
        if CloseAction = CloseAction::LookupOK then begin
            if Confirm(ConLbl, true) then begin
                if FLocationCode = '' then Error(ErrorLbl, 'From Location,');
                if ToLocationCode = '' then Error(ErrorLbl, 'To Location,');
                OrderMgt.InsertTransHeader(TranHeader, FLocationCode, ToLocationCode, DueDate);
                ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Purchase);
                ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Purchase Receipt");
                ItemLedgerEntry.SetRange("Document No.", PurchRcpHdrNo);
                ItemLedgerEntry.SetRange(Open, true);
                ItemLedgerEntry.SetRange(Positive, true);
                if ItemLedgerEntry.FindFirst() then begin
                    OrderMgt.InsertTransLine(TranHeader, TranLine, ItemNo, '', Qty, ItemUOM, DueDate);
                    //SBC ItemTrackingManagement
                    //ItemTrackingUpdate.UpdateItemTracking(TranLine, TranLine."Quantity (Base)", TranLine."Quantity (Base)", ItemLedgerEntry."Lot No.", TranLine."Shipment Date");
                end
            end;
            Page.Run(Page::"Transfer Order", TranHeader);
        end;
    end;

    procedure SetLData(_PurchRcpHdrNo: Code[20]; _ItemNo: Code[20]; _FLocationCode: Code[20]; _DueDate: Date; _Qty: Decimal; _ItemUOM: Code[10])
    begin
        PurchRcpHdrNo := _PurchRcpHdrNo;
        ItemNo := _ItemNo;
        FLocationCode := _FLocationCode;
        DueDate := _DueDate;
        Qty := _Qty;
        QtyBase := _Qty;
        ItemUOM := _ItemUOM;
    end;

    var
        PurchRcpHdrNo: Code[20];
        ItemNo: Code[20];
        ToLocationCode: Code[10];
        FLocationCode: Code[10];
        ToLocationName: Text;
        FLocationName: Text;
        Qty: Decimal;
        QtyBase: Decimal;
        QtyPerUOM: Decimal;
        DueDate: Date;
        ItemUOM: Code[20];
}
