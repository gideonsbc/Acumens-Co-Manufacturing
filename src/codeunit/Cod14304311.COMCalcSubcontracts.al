codeunit 14304311 "COM Calc-Subcontracts"
{
    trigger OnRun()
    var
        ManSetup: Record "Manufacturing Setup";
        CalcSubContract: Report "Calculate Subcontracts";
    begin
        ManSetup.get();
        ManSetup.TestField("Subcon Template Name");
        ManSetup.TestField("Subc. Batch Name");
        ReqLine := InsertReqLine(ManSetup);
        CalcSubContract.SetWkShLine(ReqLine);
        CalcSubContract.UseRequestPage(false);
        CalcSubContract.Run();
        CarryOutActionMsg();
    end;

    local procedure InsertReqLine(ManSetup: Record "Manufacturing Setup"): Record "Requisition Line"
    var
        RequisitionLine: Record "Requisition Line";
    begin
        RequisitionLine.Init();
        RequisitionLine."Line No." := 1;
        RequisitionLine."Worksheet Template Name" := ManSetup."Subcon Template Name";
        RequisitionLine."Journal Batch Name" := ManSetup."Subc. Batch Name";
        RequisitionLine.Insert();
        exit(RequisitionLine);
    end;

    local procedure CarryOutActionMsg()
    var
        ReqWkshMakeOrders: Codeunit "Req. Wksh.-Make Order";
        PurchaseHeader: Record "Purchase Header";
        EndOrderDate: date;
    begin
        PurchaseHeader."Posting Date" := WorkDate();
        PurchaseHeader."Order Date" := WorkDate();
        ReqWkshMakeOrders.Set(PurchaseHeader, EndOrderDate, false);
        ReqWkshMakeOrders.SetSuppressCommit(false);
        ReqWkshMakeOrders.CarryOutBatchAction(ReqLine);
    end;

    var
        ReqLine: Record "Requisition Line";
}
