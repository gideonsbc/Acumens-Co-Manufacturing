codeunit 14304312 "COM Single Instance"
{
    SingleInstance = true;

    procedure UnBlockLot(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[50])
    var
        LotInfo: Record "Lot No. Information";
    begin
        if LotInfo.Get(ItemNo, VariantCode, LotNo)then begin
            if not TempLotInfo.Get(ItemNo, VariantCode, LotNo)then begin
                TempLotInfo.Init();
                TempLotInfo."Item No.":=ItemNo;
                TempLotInfo."Variant Code":=VariantCode;
                TempLotInfo."Lot No.":=LotNo;
                TempLotInfo.Insert();
            end;
            LotInfo.Blocked:=false;
            LotInfo.Modify();
        end;
    end;
    procedure ResetLotInfo()
    var
        LotInfo: Record "Lot No. Information";
    begin
        if TempLotInfo.FindSet()then repeat if LotInfo.Get(TempLotInfo."Item No.", TempLotInfo."Variant Code", TempLotInfo."Lot No.")then begin
                    LotInfo.Blocked:=true;
                    LotInfo.Modify();
                end;
            until TempLotInfo.Next() = 0;
        TempLotInfo.DeleteAll();
    end;
    var TempLotInfo: Record "Lot No. Information" temporary;
}
