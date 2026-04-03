Codeunit 14304313 "AQD COManufacturing Access Mgt"
{
    var
        Text001: Label 'You do not have license to access %1.';

    [EventSubscriber(ObjectType::Codeunit, 150, OnAfterLogin, '', false, false)]
    local procedure CU150_onafterlogin()
    var
    begin
        if not AcumensLicensing.Checkifappislicensed(appid, appname) then
            DisableAppAccess(true, true);
    end;
    procedure DisableAppAccess(ShowMessage: Boolean; CalledFromLogin: Boolean): Boolean
    var
        AQAcumensCoManufactSetup: Record "AQD Acumens Co-Manufact Setup";
        UnlicensedAppusers: Record "AQD Unlicensed App Users";
    begin
        if AQAcumensCoManufactSetup.Get() and AQAcumensCoManufactSetup."AQD Enabled" then begin
            UnlicensedAppusers.reset();
            UnlicensedAppusers.SetRange("User ID", UserId);
            if not UnlicensedAppusers.FindFirst() then begin
                UnlicensedAppusers.Init();
                UnlicensedAppusers."User ID" := UserId;
                UnlicensedAppusers."App ID" := appid;
                UnlicensedAppusers."App Name" := appname;
                UnlicensedAppusers.Insert();
                Commit();
            end;

        end;
        if ShowMessage and not CalledFromLogin then
            Error(Text001, 'Acumens Co-Manufacturing');
    end;
    procedure enableAppAccess(ShowMessage: Boolean; CalledFromLogin: Boolean): Boolean
    var
        AQAcumensCoManufactSetup: Record "AQD Acumens Co-Manufact Setup";
        UnlicensedAppusers: Record "AQD Unlicensed App Users";
    begin

        if AQAcumensCoManufactSetup.Get() and (AQAcumensCoManufactSetup."AQD enabled") then begin
            UnlicensedAppusers.reset();
            UnlicensedAppusers.SetRange("User ID", UserId);
            UnlicensedAppusers.DeleteAll();
        end;

        //if ShowMessage and not CalledFromLogin then
        /// Error(Text002, 'Acumens e-Mailing');
    end;
    procedure CheckAppAccess(): Boolean
    var
    begin
        if not AcumensLicensing.Checkifappislicensed(appid, appname) then
            DisableAppAccess(true, false)
    end;

    var
        appid: Label 'c25b2a4a-4ae5-4c29-800a-643cb04d9b28';
        appname: Label 'Acumens Co-Manufacturing';
        AcumensLicensing: Codeunit "AQD L Acumens Licensing Mgt";

}
