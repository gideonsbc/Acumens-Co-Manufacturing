pageextension 14304315 "AQD COMPurchaseOrderExt" extends "Purchase Order"
{
    actions
    {
        addfirst("F&unctions")
        {
            group("AQD Acumens Co-Manufacturing")
            {
                Caption = 'Acumens Co-Manufacturing';
                action("AQD CO Purchase Order PRI")
                {
                    ApplicationArea = All;
                    Ellipsis = true;
                    Caption = 'CO Purchase Order PRI';
                    Image = PrintReport;
                    ToolTip = 'Executes the CO Purchase Order PRI report action.';
                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                    begin
                        PurchaseHeader.Reset();
                        PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
                        PurchaseHeader.SetRange("No.", Rec."No.");

                        Report.RunModal(Report::"AQD CO Purchase Order PRI", true, false, PurchaseHeader);
                    end;
                }
                action("AQD CO Purchase Comments")
                {
                    ApplicationArea = All;
                    Ellipsis = true;
                    RunObject = page "Purch. Comment Sheet";
                    RunPageLink = "No." = field("No."), "Document Type" = field("Document Type"), "Document Line No." = const(0);
                    Caption = 'CO Purchase Comments';
                    Image = ViewComments;
                    ToolTip = 'Executes the CO Purchase Comments action.';
                }
            }
        }
        addafter(Category_Category20)
        {
            group("AQD Acumens Co-Manufacturing Promoted")
            {
                Caption = 'Acumens Co-Manufacturing';
                actionref("AQD CO Purchase Order PRI_Promoted"; "AQD CO Purchase Order PRI")
                {
                }
                actionref("AQD CO Purchase Comments_Promoted"; "AQD CO Purchase Comments")
                {
                }
            }
        }
    }
}
