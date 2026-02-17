/// <summary>
/// Codeunit AQDAEP Access Mgt. (ID 60527).
/// </summary>
codeunit 14304313 "AQD CoManufacturing Access Mgt"
{
    // SBCNP 2021-11-11 Authorize.Net
    //                  New Codeunit to check client is licensed or not
    // SBCNP 2022-01-08 Authorize.Net
    //                   Modified functions: AccessManager,
    //                   New function: CheckClientAllowedGranules,GetCalledFromGranule
    // SBCNP 2023-10-22 Acumens Inventory Quality Control
    //                  Rewrite codeunit using functions from Acumens Licensing and Registration App
    // SBCNP 2023-11-11 Acumens Inventory Quality Control
    //                  Updated condition to include expiration Date = ControlDate and countDown

    var
        ExpiryDateCountDownMsg: Label '%1 annual access license expires in %2 days.';
        LicenseExpiryErr: Label '%1 annual access license has expired.';
        Text001: Label 'You do not have license to access %1.';
        Text002: Label 'You do not have license to access %1: %2.';
    //AppLicDetails: Codeunit "AQDApp License Details";

    trigger OnRun()
    begin
    end;

    /* var
        Text001: Label 'You do not have license to access Acumens Inventory Quality Control.';
        Text002: Label 'You do not have license to access Acumens Inventory Quality Control: %1.'; */


    /// <summary>
    /// AccessManager.
    /// </summary>
    /// <param name="ProxyContext">Temporary Record "Acumens eReceivables Setup".</param>
    /// <param name="ShowMessage">Boolean.</param>
    /// <param name="CalledFromLogin">Boolean.</param>
    /// <returns>Return value of type Boolean.</returns>
  //  [NonDebuggable]
    procedure AccessManager(ProxyContext: Code[20]; ShowMessage: Boolean; CalledFromLogin: Boolean): Boolean

    begin
        /*if NavApp.GetCurrentModuleInfo(AppInfo) then begin
            if CheckClientAllowedGranules(AppInfo.Id, AppInfo.Name, ProxyContext, (ShowMessage and (not CalledFromLogin))) then begin
                if CheckLicenseExpiryDate(AppLicDetails.GetExpiryDate(AppInfo.Id), ShowMessage, CalledFromLogin, AppInfo.Name) then
                    exit(true);
            end;
        end;

        if ShowMessage and not CalledFromLogin then begin
            AcumensInventoryQCSetup.Get();
            AcumensInventoryQCSetup."AQD Enabled" := false;
            AcumensInventoryQCSetup.Modify();
            AcumensInventoryQCSetup.Get();
            AcumensInventoryQCSetup."AQD Enabled" := false;
            AcumensInventoryQCSetup.Modify();
            Commit();
        end;

        if ShowMessage and not CalledFromLogin then
            Error(Text001, AppInfo.Name); */
    end;

    //[NonDebuggable]
    local procedure CheckClientAllowedGranules(AppID: Guid; AppName: Text; ProxyContext: Code[20]; ShowError: Boolean): Boolean
    var
        CalledFromGranule: Code[20];
    begin
        CalledFromGranule := ProxyContext;
        //GetCalledFromGranule(ProxyContext, CalledFromGranule);
        //    if AppLicDetails.CheckAllowedModule(AppID, CalledFromGranule) then
        //      exit(true);

        if ShowError then
            Error(Text002, AppName, GetGranuleName(CalledFromGranule));
    end;

    //  [NonDebuggable]
    local procedure GetGranuleName(GranuleCode: Code[20]): Text;
    begin
        case GranuleCode of
            'ACO-M01':
                exit('Acumens Co-Manufacturing');
        // 'AEP03':
        //     exit('Batch Payment Processing');
        // 'AEP04':
        //     exit('B2B eCommerce Connector');
        // 'AEP05':
        //     exit('B2C eCommerce Connector');
        // 'AEP06':
        //     exit('3rd Party App Connector');
        end;
    end;

    // [NonDebuggable]
    local procedure GetCalledFromGranule(ProxyContext: Code[20]; var CalledFromGranule: Code[20]);
    begin
        /* if ProxyContext."Enabled" then
            CalledFromGranule := 'AER01'; */
    end;

    /// <summary>
    /// GetLicenseExpiryDate.
    /// </summary>
    /// <returns>Return value of type Date.</returns>
   // [NonDebuggable]
    procedure GetLicenseExpiryDate(): Date;
    var
        AppInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(AppInfo);
        //     exit(AppLicDetails.GetExpiryDate(AppInfo.Id));
    end;

    /// <summary>
    /// IsDemo.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    [NonDebuggable]
    procedure IsDemo(): Boolean
    var
        //  AppLicDetails: Codeunit "AQDApp License Details";
        AppInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(AppInfo);
        // exit(AppLicDetails.IsDemo(AppInfo.Id));
    end;

    //  [NonDebuggable]
    local procedure CheckLicenseExpiryDate(ExpiryDate: Date; ShowMessage: Boolean; CalledFromLogin: Boolean; AppName: Text): Boolean;
    var
        ControlDate: Date;
        CountDownDays: Integer;
    begin
        ControlDate := Today;

        //Check if Expired date
        if ((ExpiryDate <> 0D) and (ExpiryDate < ControlDate)) then begin
            case true of
                ShowMessage and (not CalledFromLogin):
                    Error(LicenseExpiryErr, AppName);
                ShowMessage and CalledFromLogin:
                    Message(LicenseExpiryErr, AppName);
            end;
            //Exit True If not Expired
            exit(false);
        end;

        //Expiry Date Count Down
        if (ExpiryDate >= ControlDate) and (ExpiryDate < ((CalcDate('<1M>', ControlDate)))) then begin
            //Get Date Count Down
            CountDownDays := ExpiryDate - ControlDate;

            if ShowMessage and CalledFromLogin then
                if GuiAllowed then begin
                    if CountDownDays >= 0 then
                        Message(ExpiryDateCountDownMsg, AppName, CountDownDays);
                end;

            //Exit True If not Expired
            exit(true);
        end;

        //Exit True If not Expired
        exit(true);
    end;

    /// <summary>
    /// CheckAllowedModule.
    /// </summary>
    /// <param name="ModuleId">code[20].</param>
    /// <returns>Return value of type Boolean.</returns>
    [NonDebuggable]
    procedure CheckAllowedModule(ModuleId: Code[20]): Boolean
    var
        AppInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(AppInfo);
        //  if AppLicDetails.CheckAllowedModule(AppInfo.Id, ModuleId) then
        //       exit(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, 150, OnAfterLogin, '', false, false)]
    local procedure CU40_LoginManagementOnAfterCompanyOpen()
    var
        ProxyContext: Code[20];
        CurrAppExecutionContext: ExecutionContext;
    begin
        ProxyContext := 'ACO-M01';
        CurrAppExecutionContext := GetCurrentModuleExecutionContext();
        if CurrAppExecutionContext = CurrAppExecutionContext::Normal then
            AccessManager(ProxyContext, true, true);
    end;
    //[NonDebuggable]
    local procedure GetCalledFromGranule(ProxyContext: Record "AQD Acumens Inventory QC Setup" temporary; VAR CalledFromGranule: Code[20]);
    begin
        if ProxyContext."AQD Enabled" then
            CalledFromGranule := 'ACO-M01';
    end;

    local procedure AccessManager(ProxyContext: Code[20]; ShowMessage: Boolean): Boolean
    var
        AEPAccessMgt: Codeunit "AQD Inventory QC Access Mgt.";
    begin
        exit(AEPAccessMgt.AccessManager(ProxyContext, ShowMessage, false));
    end;
}