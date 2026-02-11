pageextension 14304314 COPostedPurchaseReceipt extends "Posted Purchase Receipt"
{
    actions
    {
        addfirst(processing)
        {
            action("Transfer To")
            {
                ApplicationArea = All;
                Visible = true;
                Caption = 'Transfer To';
                Image = TransferOrder;

                trigger OnAction()
                var
                    PurchRcptHeader: Record "Purch. Rcpt. Header";
                    Location: Record Location;
                    ItemLedgerEntry: Record "Item Ledger Entry";
                    TransferTo: Page "Transfer To";
                begin
                    if PurchRcptHeader.Get(Rec."No.") then
                        if Location.Get(PurchRcptHeader."Location Code") then
                            if Location."PO. to TR. Order" then begin
                                ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Purchase);
                                ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Purchase Receipt");
                                ItemLedgerEntry.SetRange("Document No.", Rec."No.");
                                ItemLedgerEntry.SetRange(Open, true);
                                ItemLedgerEntry.SetRange(Positive, true);
                                if ItemLedgerEntry.FindFirst() then begin
                                    ItemLedgerEntry.CalcFields("Base Unit of Measure");
                                    TransferTo.SetLData(Rec."No.", ItemLedgerEntry."Item No.", ItemLedgerEntry."Location Code", ItemLedgerEntry."Posting Date", ItemLedgerEntry.Quantity, ItemLedgerEntry."Base Unit of Measure");
                                    TransferTo.LookupMode(true);
                                    TransferTo.RunModal();
                                end;
                            end;
                end;
            }
        }
    }
}
