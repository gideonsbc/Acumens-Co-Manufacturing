pageextension 14304313 "AQD COPurchaseOrderSubform" extends "Purchase Order Subform"
{
    layout
    {
        modify(Quantity)
        {
            trigger OnAfterValidate()
            var
                Location: Record Location;
                NewPurchLine: Record "Purchase Line";
                NewCIPurchLine: Record "Purchase Line";
                ItemChargeAssPurch: Record "Item Charge Assignment (Purch)";
                Item: Record Item;
                ProdBOMHeader: Record "Production BOM Header";
                ProdBOMLine: Record "Production BOM Line";
                LineNo: Integer;
            begin
                if Rec.IsTemporary then exit;
                if Rec.Type = Rec.Type::Item then
                    if Location.Get(Rec."Location Code") then
                        if Location."AQD BOM to PO" then
                            if Item.Get(Rec."No.") then
                                if Item."Production BOM No." <> '' then begin
                                    NewPurchLine.SetRange("Document Type", Rec."Document Type");
                                    NewPurchLine.SetRange("Document No.", Rec."Document No.");
                                    NewPurchLine.SetRange("Line No.", Rec."Line No." + 50, Rec."Line No." + 3000);
                                    NewPurchLine.SetRange("AQD PO BOM", true);
                                    NewPurchLine.DeleteAll();
                                    ProdBOMHeader.Get(Item."Production BOM No.");
                                    ProdBOMLine.SetRange("Production BOM No.", Item."Production BOM No.");
                                    if ProdBOMHeader."Version Nos." <> '' then ProdBOMLine.SetRange("Version Code", ProdBOMHeader."Version Nos.");
                                    ProdBOMLine.SetRange(Type, ProdBOMLine.Type::Item);
                                    LineNo := Rec."Line No.";
                                    if ProdBOMLine.FindSet() then
                                        repeat
                                            LineNo += 100;
                                            NewPurchLine.Init();
                                            NewPurchLine."Document Type" := Rec."Document Type";
                                            NewPurchLine."Document No." := Rec."Document No.";
                                            NewPurchLine."Line No." := LineNo;
                                            NewPurchLine."Buy-from Vendor No." := Rec."Buy-from Vendor No.";
                                            NewPurchLine.Insert();
                                            NewPurchLine.Type := Rec.Type::Item;
                                            NewPurchLine.Validate("No.", ProdBOMLine."No.");
                                            NewPurchLine.Validate("Location Code", Rec."Location Code");
                                            NewPurchLine.Validate("Unit of Measure Code", ProdBOMLine."Unit of Measure Code");
                                            NewPurchLine.Validate(Quantity, -ProdBOMLine."Quantity per" * Rec."Quantity (Base)");
                                            NewPurchLine."AQD PO BOM" := true;
                                            NewPurchLine.Modify();
                                            if Location."AQD Balance Charge Item" <> '' then begin
                                                LineNo += 100;
                                                NewCIPurchLine.Init();
                                                NewCIPurchLine."Document Type" := Rec."Document Type";
                                                NewCIPurchLine."Document No." := Rec."Document No.";
                                                NewCIPurchLine."Line No." := LineNo;
                                                NewCIPurchLine."Buy-from Vendor No." := Rec."Buy-from Vendor No.";
                                                NewCIPurchLine.Insert();
                                                NewCIPurchLine.Type := Rec.Type::"Charge (Item)";
                                                NewCIPurchLine.Validate("No.", Location."AQD Balance Charge Item");
                                                NewCIPurchLine.Validate("Location Code", Rec."Location Code");
                                                NewCIPurchLine.Validate(Quantity, -NewPurchLine.Quantity);
                                                NewCIPurchLine.Validate("Direct Unit Cost", NewPurchLine."Direct Unit Cost");
                                                NewCIPurchLine."AQD PO BOM" := true;
                                                NewCIPurchLine.Modify();
                                                AQDCreateItemChageAssign(NewCIPurchLine);
                                                ItemChargeAssPurch.SetRange("Document Type", Rec."Document Type");
                                                ItemChargeAssPurch.SetRange("Document No.", Rec."Document No.");
                                                ItemChargeAssPurch.SetRange("Document Line No.", NewCIPurchLine."Line No.");
                                                ItemChargeAssPurch.SetRange("Applies-to Doc. Type", Rec."Document Type");
                                                ItemChargeAssPurch.SetRange("Applies-to Doc. No.", Rec."Document No.");
                                                ItemChargeAssPurch.SetRange("Applies-to Doc. Line No.", Rec."Line No.");
                                                if ItemChargeAssPurch.FindFirst() then begin
                                                    ItemChargeAssPurch.Validate("Qty. to Assign", NewCIPurchLine.Quantity);
                                                    ItemChargeAssPurch.Modify();
                                                end;
                                            end;
                                        until ProdBOMLine.Next() = 0;
                                end;
                CurrPage.Update(false);
            end;
        }
    }
    procedure AQDCreateItemChageAssign(PurchLine: Record "Purchase Line")
    var
        PurchHeader: Record "Purchase Header";
        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
        AssignItemChargePurch: Codeunit "Item Charge Assgnt. (Purch.)";
        ItemChargeAssgntLineAmt: Decimal;
        NonDeductibleVAT: Codeunit "Non-Deductible VAT";
    begin
        PurchHeader.Get(PurchLine."Document Type", PurchLine."Document No.");
        if PurchHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision()
        else
            Currency.Get(PurchHeader."Currency Code");
        if (PurchLine."Inv. Discount Amount" = 0) and (PurchLine."Line Discount Amount" = 0) and (not PurchHeader."Prices Including VAT") then
            ItemChargeAssgntLineAmt := PurchLine."Line Amount" + NonDeductibleVAT.GetNonDeductibleVATAmountForItemCost(Rec)
        else if PurchHeader."Prices Including VAT" then
            ItemChargeAssgntLineAmt := Round(PurchLine.CalcLineAmount() / (1 + PurchLine."VAT %" / 100), Currency."Amount Rounding Precision") + NonDeductibleVAT.GetNonDeductibleVATAmountForItemCost(Rec)
        else
            ItemChargeAssgntLineAmt := PurchLine.CalcLineAmount();
        ItemChargeAssgntPurch.Reset();
        ItemChargeAssgntPurch.SetRange("Document Type", PurchLine."Document Type");
        ItemChargeAssgntPurch.SetRange("Document No.", PurchLine."Document No.");
        ItemChargeAssgntPurch.SetRange("Document Line No.", PurchLine."Line No.");
        ItemChargeAssgntPurch.SetRange("Item Charge No.", PurchLine."No.");
        if not ItemChargeAssgntPurch.FindLast() then begin
            ItemChargeAssgntPurch."Document Type" := PurchLine."Document Type";
            ItemChargeAssgntPurch."Document No." := PurchLine."Document No.";
            ItemChargeAssgntPurch."Document Line No." := PurchLine."Line No.";
            ItemChargeAssgntPurch."Item Charge No." := PurchLine."No.";
            ItemChargeAssgntPurch."Unit Cost" := Round(ItemChargeAssgntLineAmt / PurchLine.Quantity, Currency."Unit-Amount Rounding Precision");
        end;
        ItemChargeAssgntLineAmt := Round(ItemChargeAssgntLineAmt * (PurchLine."Qty. to Invoice" / PurchLine.Quantity), Currency."Amount Rounding Precision");
        AssignItemChargePurch.CreateDocChargeAssgnt(ItemChargeAssgntPurch, PurchLine."Receipt No.");
    end;
}
