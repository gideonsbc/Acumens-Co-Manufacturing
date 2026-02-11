tableextension 14304311 COMWarehouseActivityLine extends "Warehouse Activity Line"
{
    fields
    {
        modify("Lot No.")
        {
            trigger OnBeforeValidate()
            begin
                if (("Activity Type" = "Activity Type"::Pick) or ("Activity Type" = "Activity Type"::"Invt. Pick") or ("Activity Type" = "Activity Type"::"Invt. Movement")) and ("Action Type" = "Action Type"::Take) then CheckItemTrackingInfoBlocked(Rec);
            end;
        }
    }
    local procedure CheckItemTrackingInfoBlocked(WhseActivityLine: Record "Warehouse Activity Line")
    var
        SerialNoInfo: Record "Serial No. Information";
        CoManHeader: Record "Co-Man Header";
        LotNoInfo: Record "Lot No. Information";
        ProdOrder: Record "Production Order";
        Location: Record Location;
    begin
        if not WhseActivityLine.TrackingExists() then exit;
        if WhseActivityLine."Serial No." <> '' then if SerialNoInfo.Get(WhseActivityLine."Item No.", WhseActivityLine."Variant Code", WhseActivityLine."Serial No.") then SerialNoInfo.TestField(Blocked, false);
        if WhseActivityLine."Lot No." <> '' then begin
            if "Source Document" = "Source Document"::"Outbound Transfer" then begin
                ProdOrder.SetRange("In-Transfer Order No.", "Source No.");
                if Location.Get(WhseActivityLine."Location Code") then if ProdOrder.FindFirst() then if Location.Get(ProdOrder."Location Code") then if Location."Co-Man Location" then exit;
            end;
            if LotNoInfo.Get(WhseActivityLine."Item No.", WhseActivityLine."Variant Code", WhseActivityLine."Lot No.") then LotNoInfo.TestField(Blocked, false);
        end;
    end;
}
