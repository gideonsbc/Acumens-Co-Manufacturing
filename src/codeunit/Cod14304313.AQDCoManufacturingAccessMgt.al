Codeunit 14304313 "AQD COManufacturing Access Mgt"
{
    var
        Text001: Label 'You do not have license to access %1.';

    [EventSubscriber(ObjectType::Codeunit, 150, OnAfterLogin, '', false, false)]
    local procedure CU150_onafterlogin()
    var
        AcumensLicensing: Codeunit "AQD Acumens Licensing mgt";
    begin
        if not AcumensLicensing.Checkifappislicensed('c25b2a4a-4ae5-4c29-800a-643cb04d9b28', 'Acumens Co-Manufacturing') then
            DisableAppAccess(true, true);
    end;

    procedure DisableAppAccess(ShowMessage: Boolean; CalledFromLogin: Boolean): Boolean
    var
        AQDAcumensCoManufacturingSetup: Record "AQD Acumens Co-Manufact Setup";
    begin
        if AQDAcumensCoManufacturingSetup.Get() and AQDAcumensCoManufacturingSetup."AQD Enabled" then begin
            AQDAcumensCoManufacturingSetup."AQD Enabled" := false;
            AQDAcumensCoManufacturingSetup.Modify();
            Commit();
        end;

        if ShowMessage and not CalledFromLogin then
            Error(Text001, 'Acumens Co-Manufacturing');
    end;

    procedure CheckAppAccess(): Boolean
    var
        AcumensLicensing: Codeunit "AQD Acumens Licensing mgt";

    begin
        if not AcumensLicensing.Checkifappislicensed('c25b2a4a-4ae5-4c29-800a-643cb04d9b28', 'Acumens Co-Manufacturing') then
            DisableAppAccess(true, false)
    end;
}
