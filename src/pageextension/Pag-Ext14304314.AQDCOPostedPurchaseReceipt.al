pageextension 14304314 "AQD COPostedPurchaseReceipt" extends "Posted Purchase Receipt"
{
    actions
    {
        addfirst(processing)
        {
            action("AQD Transfer To")
            {
                ApplicationArea = All;
                Visible = true;
                Caption = 'Transfer To';
                Image = TransferOrder;
                ToolTip = 'Executes the Transfer To action.';

                trigger OnAction()
                var
                    PurchRcptHeader: Record "Purch. Rcpt. Header";
                    Location: Record Location;
                    ItemLedgerEntry: Record "Item Ledger Entry";
                    TransferTo: Page "AQD Transfer To";
                begin
                    if PurchRcptHeader.Get(Rec."No.") then
                        if Location.Get(PurchRcptHeader."Location Code") then
                            if Location."AQD PO. to TR. Order" then begin
                                ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Purchase);
                                ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Purchase Receipt");
                                ItemLedgerEntry.SetRange("Document No.", Rec."No.");
                                ItemLedgerEntry.SetRange(Open, true);
                                ItemLedgerEntry.SetRange(Positive, true);
                                if ItemLedgerEntry.FindFirst() then begin
                                    ItemLedgerEntry.CalcFields("Unit of Measure Code"); //"Base Unit of Measure" does not exists. replaced with "Unit of Measure Code"
                                    TransferTo.SetLData(Rec."No.", ItemLedgerEntry."Item No.", ItemLedgerEntry."Location Code", ItemLedgerEntry."Posting Date", ItemLedgerEntry.Quantity, ItemLedgerEntry."Unit of Measure Code");
                                    TransferTo.LookupMode(true);
                                    TransferTo.RunModal();
                                end;
                            end;
                end;
            }
        }
        addafter(Category_Category5)
        {
            group("AQD Acumens Co-Manufacturing Promoted")
            {
                Caption = 'Acumens Co-Manufacturing';
                actionref("AQDTransferTo_Promoted"; "AQD Transfer To")
                {
                }
            }
        }
    }
}
