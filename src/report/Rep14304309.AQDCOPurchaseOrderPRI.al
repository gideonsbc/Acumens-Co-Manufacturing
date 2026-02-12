report 14304309 "AQD CO Purchase Order PRI"
{
    Caption = 'Purchase Order PRI';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = NewPurchaseOrder;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Buy-from Vendor No.", "Pay-to Vendor No.", "No. Printed";

            column(No_PurchaseHeader; "No.")
            {
            }
            column(ShiptoName_PurchaseHeader; "Ship-to Name")
            {
            }
            column(Status; Status)
            {
            }
            column(VendorComment; VendorComment)
            {
            }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number);

                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

                    column(CompanyInfoPicture; CompanyInformation.Picture)
                    {
                    }
                    column(CompanyAddress1; CompanyAddress[1])
                    {
                    }
                    column(CompanyAddress2; CompanyAddress[2])
                    {
                    }
                    column(CompanyAddress3; CompanyAddress[3])
                    {
                    }
                    column(CompanyAddress4; CompanyAddress[4])
                    {
                    }
                    column(CompanyAddress5; CompanyAddress[5])
                    {
                    }
                    column(CompanyAddress6; CompanyAddress[6])
                    {
                    }
                    column(BillToAddress1; BillToAddress[1])
                    {
                    }
                    column(BillToAddress2; BillToAddress[2])
                    {
                    }
                    column(BillToAddress3; BillToAddress[3])
                    {
                    }
                    column(BillToAddress4; BillToAddress[4])
                    {
                    }
                    column(BillToAddress5; BillToAddress[5])
                    {
                    }
                    column(BillToAddress6; BillToAddress[6])
                    {
                    }
                    column(BillToAddress7; BillToAddress[7])
                    {
                    }
                    column(CopyTxt; CopyTxt)
                    {
                    }
                    column(BuyFromAddress1; BuyFromAddress[1])
                    {
                    }
                    column(BuyFromAddress2; BuyFromAddress[2])
                    {
                    }
                    column(BuyFromAddress3; BuyFromAddress[3])
                    {
                    }
                    column(BuyFromAddress4; BuyFromAddress[4])
                    {
                    }
                    column(BuyFromAddress5; BuyFromAddress[5])
                    {
                    }
                    column(BuyFromAddress6; BuyFromAddress[6])
                    {
                    }
                    column(BuyFromAddress7; BuyFromAddress[7])
                    {
                    }
                    column(ExptRecptDt_PurchaseHeader; "Purchase Header"."Requested Receipt Date")
                    {
                    }
                    column(CreatedByUserID; "Purchase Header".SystemCreatedBy)
                    {
                    }
                    column(ShipToAddress1; ShipToAddress[1])
                    {
                    }
                    column(ShipToAddress2; ShipToAddress[2])
                    {
                    }
                    column(ShipToAddress3; ShipToAddress[3])
                    {
                    }
                    column(ShipToAddress4; ShipToAddress[4])
                    {
                    }
                    column(ShipToAddress5; ShipToAddress[5])
                    {
                    }
                    column(ShipToAddress6; ShipToAddress[6])
                    {
                    }
                    column(ShipToAddress7; ShipToAddress[7])
                    {
                    }
                    column(BuyfrVendNo_PurchaseHeader; "Purchase Header"."Buy-from Vendor No.")
                    {
                    }
                    column(YourRef_PurchaseHeader; "Purchase Header"."Your Reference")
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(No1_PurchaseHeader; "Purchase Header"."No.")
                    {
                    }
                    column(OrderDate_PurchaseHeader; "Purchase Header"."Order Date")
                    {
                    }
                    column(CompanyAddress7; CompanyAddress[7])
                    {
                    }
                    column(CompanyAddress8; CompanyAddress[8])
                    {
                    }
                    column(BuyFromAddress8; BuyFromAddress[8])
                    {
                    }
                    column(ShipToAddress8; ShipToAddress[8])
                    {
                    }
                    column(ShipmentMethodDescription; ShipmentMethod.Description)
                    {
                    }
                    column(PaymentTermsDescription; PaymentTerms.Description)
                    {
                    }
                    column(CompanyInformationPhoneNo; CompanyInformation."Phone No.")
                    {
                    }
                    column(CopyNo; CopyNo)
                    {
                    }
                    column(VendTaxIdentificationType; FORMAT(Vend."Tax Identification Type"))
                    {
                    }
                    column(ToCaption; ToCaptionLbl)
                    {
                    }
                    column(ReceiveByCaption; ReceiveByCaptionLbl)
                    {
                    }
                    column(VendorIDCaption; VendorIDCaptionLbl)
                    {
                    }
                    column(ConfirmToCaption; ConfirmToCaptionLbl)
                    {
                    }
                    column(BuyerCaption; BuyerCaptionLbl)
                    {
                    }
                    column(ShipCaption; ShipCaptionLbl)
                    {
                    }
                    column(ToCaption1; ToCaption1Lbl)
                    {
                    }
                    column(PurchOrderCaption; PurchOrderCaptionLbl)
                    {
                    }
                    column(PurchOrderNumCaption; PurchOrderNumCaptionLbl)
                    {
                    }
                    column(PurchOrderDateCaption; PurchOrderDateCaptionLbl)
                    {
                    }
                    column(PageCaption; PageCaptionLbl)
                    {
                    }
                    column(ShipViaCaption; ShipViaCaptionLbl)
                    {
                    }
                    column(TermsCaption; TermsCaptionLbl)
                    {
                    }
                    column(PhoneNoCaption; PhoneNoCaptionLbl)
                    {
                    }
                    column(TaxIdentTypeCaption; TaxIdentTypeCaptionLbl)
                    {
                    }
                    column(VendorOrderNo_Lbl; VendorOrderNoLbl)
                    {
                    }
                    column(VendorInvoiceNo_Lbl; VendorInvoiceNoLbl)
                    {
                    }
                    column(VendorOrderNo; "Purchase Header"."Vendor Order No.")
                    {
                    }
                    column(VendorInvoiceNo; "Purchase Header"."Vendor Invoice No.")
                    {
                    }
                    column(ShippingAgentCode; "Purchase Header"."Shipment Method Code")
                    {
                    }
                    column(CreatedByUserName; "Purchase Header".SystemCreatedBy)
                    {
                    }
                    dataitem("Purchase Line"; "Purchase Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Purchase Header";
                        DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") WHERE("Document Type" = CONST(Order), "AQD PO BOM" = const(false));

                        column(AmountExclInvDisc; AmountExclInvDisc)
                        {
                        }
                        column(ItemNumberToPrint; ItemNumberToPrint)
                        {
                        }
                        column(ItemNumberToPrint2; ItemNumberToPrint2)
                        {
                        }
                        column(UnitofMeasure_PurchaseLine; "Unit of Measure")
                        {
                        }
                        column(Quantity_PurchaseLine; Quantity)
                        {
                        }
                        column(UnitPriceToPrint; UnitPriceToPrint)
                        {
                            DecimalPlaces = 2 : 5;
                        }
                        column(Description_PurchaseLine; Description)
                        {
                        }
                        column(Outstanding_Quantity; "Outstanding Quantity")
                        {
                        }
                        column(PrintFooter; PrintFooter)
                        {
                        }
                        column(InvDiscountAmt_PurchaseLine; "Inv. Discount Amount")
                        {
                        }
                        column(TaxAmount; TaxAmount)
                        {
                        }
                        column(LineAmtTaxAmtInvDiscountAmt; "Line Amount" + TaxAmount - "Inv. Discount Amount")
                        {
                        }
                        column(TotalTaxLabel; TotalTaxLabel)
                        {
                        }
                        column(BreakdownTitle; BreakdownTitle)
                        {
                        }
                        column(BreakdownLabel1; BreakdownLabel[1])
                        {
                        }
                        column(BreakdownAmt1; BreakdownAmt[1])
                        {
                        }
                        column(BreakdownLabel2; BreakdownLabel[2])
                        {
                        }
                        column(BreakdownAmt2; BreakdownAmt[2])
                        {
                        }
                        column(BreakdownLabel3; BreakdownLabel[3])
                        {
                        }
                        column(BreakdownAmt3; BreakdownAmt[3])
                        {
                        }
                        column(BreakdownAmt4; BreakdownAmt[4])
                        {
                        }
                        column(BreakdownLabel4; BreakdownLabel[4])
                        {
                        }
                        column(DocumentNo_PurchaseLine; "Document No.")
                        {
                        }
                        column(ItemNoCaption; ItemNoCaptionLbl)
                        {
                        }
                        column(UnitCaption; UnitCaptionLbl)
                        {
                        }
                        column(DescriptionCaption; DescriptionCaptionLbl)
                        {
                        }
                        column(QuantityCaption; QuantityCaptionLbl)
                        {
                        }
                        column(UnitPriceCaption; UnitPriceCaptionLbl)
                        {
                        }
                        column(TotalPriceCaption; TotalPriceCaptionLbl)
                        {
                        }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        {
                        }
                        column(InvDiscCaption; InvDiscCaptionLbl)
                        {
                        }
                        column(TotalCaption; TotalCaptionLbl)
                        {
                        }
                        column(BaseUoM; "Purchase Line"."Unit of Measure Code")
                        {
                        }
                        trigger OnAfterGetRecord()
                        begin
                            OnLineNumber := OnLineNumber + 1;
                            IF ("Purchase Header"."Tax Area Code" <> '') AND NOT UseExternalTaxEngine THEN SalesTaxCalc.AddPurchLine("Purchase Line");
                            if PrintItemNumber then
                                ItemNumberToPrint := "No."
                            else IF "Vendor Item No." <> '' THEN
                                ItemNumberToPrint := "Vendor Item No."
                            ELSE
                                ItemNumberToPrint := "No.";
                            ItemNumberToPrint2 := "No.";
                            IF Type = "Purchase Line".type::" " THEN BEGIN
                                ItemNumberToPrint := '';
                                "Unit of Measure" := '';
                                "Line Amount" := 0;
                                "Inv. Discount Amount" := 0;
                                Quantity := 0;
                            END;
                            AmountExclInvDisc := "Line Amount";
                            IF Quantity = 0 THEN
                                UnitPriceToPrint := 0 // so it won't print
                            ELSE
                                UnitPriceToPrint := ROUND(AmountExclInvDisc / Quantity, 0.00001);
                            IF OnLineNumber = NumberOfLines THEN BEGIN
                                PrintFooter := TRUE;
                                IF "Purchase Header"."Tax Area Code" <> '' THEN BEGIN
                                    IF UseExternalTaxEngine THEN
                                        SalesTaxCalc.CallExternalTaxEngineForPurch("Purchase Header", TRUE)
                                    ELSE
                                        SalesTaxCalc.EndSalesTaxCalculation(UseDate);
                                    SalesTaxCalc.GetSummarizedSalesTaxTable(TempSalesTaxAmtLine);
                                    BrkIdx := 0;
                                    PrevPrintOrder := 0;
                                    PrevTaxPercent := 0;
                                    TaxAmount := 0;
                                    BEGIN
                                        TempSalesTaxAmtLine.RESET;
                                        TempSalesTaxAmtLine.SETCURRENTKEY(TempSalesTaxAmtLine."Print Order", TempSalesTaxAmtLine."Tax Area Code for Key", TempSalesTaxAmtLine."Tax Jurisdiction Code");
                                        IF TempSalesTaxAmtLine.FIND('-') THEN
                                            REPEAT
                                                IF (TempSalesTaxAmtLine."Print Order" = 0) OR (TempSalesTaxAmtLine."Print Order" <> PrevPrintOrder) OR (TempSalesTaxAmtLine."Tax %" <> PrevTaxPercent) THEN BEGIN
                                                    BrkIdx := BrkIdx + 1;
                                                    IF BrkIdx > 1 THEN BEGIN
                                                        IF TaxArea."Country/Region" = TaxArea."Country/Region"::CA THEN
                                                            BreakdownTitle := Text006
                                                        ELSE
                                                            BreakdownTitle := Text003;
                                                    END;
                                                    IF BrkIdx > ARRAYLEN(BreakdownAmt) THEN BEGIN
                                                        BrkIdx := BrkIdx - 1;
                                                        BreakdownLabel[BrkIdx] := Text004;
                                                    END
                                                    ELSE
                                                        BreakdownLabel[BrkIdx] := STRSUBSTNO(TempSalesTaxAmtLine."Print Description", TempSalesTaxAmtLine."Tax %");
                                                END;
                                                BreakdownAmt[BrkIdx] := BreakdownAmt[BrkIdx] + TempSalesTaxAmtLine."Tax Amount";
                                                TaxAmount := TaxAmount + TempSalesTaxAmtLine."Tax Amount";
                                            UNTIL TempSalesTaxAmtLine.NEXT = 0;
                                    END;
                                    IF BrkIdx = 1 THEN BEGIN
                                        CLEAR(BreakdownLabel);
                                        CLEAR(BreakdownAmt);
                                    END;
                                END;
                            END;
                        end;

                        trigger OnPreDataItem()
                        begin
                            //CurrReport.CREATETOTALS(AmountExclInvDisc, "Line Amount", "Inv. Discount Amount");
                            NumberOfLines := COUNT;
                            OnLineNumber := 0;
                            PrintFooter := FALSE;
                        end;
                    }
                }
                trigger OnAfterGetRecord()
                begin
                    //CurrReport.PAGENO := 1;
                    IF CopyNo = NoLoops THEN BEGIN
                        IF NOT CurrReport.PREVIEW THEN PurchasePrinted.RUN("Purchase Header");
                        CurrReport.BREAK;
                    END;
                    CopyNo := CopyNo + 1;
                    IF CopyNo = 1 THEN // Original
                        CLEAR(CopyTxt)
                    ELSE
                        CopyTxt := Text000;
                    TaxAmount := 0;
                    CLEAR(BreakdownTitle);
                    CLEAR(BreakdownLabel);
                    CLEAR(BreakdownAmt);
                    TotalTaxLabel := Text008;
                    IF "Purchase Header"."Tax Area Code" <> '' THEN BEGIN
                        TaxArea.GET("Purchase Header"."Tax Area Code");
                        CASE TaxArea."Country/Region" OF
                            TaxArea."Country/Region"::US:
                                TotalTaxLabel := Text005;
                            TaxArea."Country/Region"::CA:
                                TotalTaxLabel := Text007;
                        END;
                        UseExternalTaxEngine := TaxArea."Use External Tax Engine";
                        SalesTaxCalc.StartSalesTaxCalculation;
                    END;
                end;

                trigger OnPreDataItem()
                begin
                    NoLoops := 1 + ABS(NoCopies);
                    IF NoLoops <= 0 THEN NoLoops := 1;
                    CopyNo := 0;
                end;
            }
            trigger OnAfterGetRecord()
            var
                CommentLine: Record "Comment Line";
                PurchasesSetup: Record "Purchases & Payables Setup";
                I: Integer;
            begin
                CalcFields(SystemCreatedBy);
                Clear(CompanyAddress2);
                if PrintCompany then
                    if RespCenter.Get("Responsibility Center") then begin
                        FormatAddress.GetCompanyAddr("Responsibility Center", RespCenter, CompanyInformation, CompanyAddress);
                        CompanyInformation."Phone No." := RespCenter."Phone No.";
                        CompanyInformation."Fax No." := RespCenter."Fax No.";
                        if RespCenter.Name <> '' then begin
                            I += 1;
                            BillToAddress[I] := RespCenter.Name;
                        end;
                        if RespCenter."Remit Address" <> '' then begin
                            I += 1;
                            BillToAddress[I] := RespCenter."Remit Address";
                            if RespCenter."Remit Address 2" <> '' then begin
                                BillToAddress[I] += ', ' + RespCenter."Remit Address 2";
                            end;
                        end;
                        if RespCenter."Remit City" <> '' then begin
                            I += 1;
                            BillToAddress[I] := RespCenter."Remit City";
                            if RespCenter."Remit County" <> '' then BillToAddress[I] += ', ' + RespCenter."Remit County";
                            if RespCenter."Remit Post Code" <> '' then BillToAddress[I] += ' ' + RespCenter."Remit Post Code";
                            if RespCenter."Remit Country/Region Code" <> '' then BillToAddress[I] += ' ' + RespCenter."Remit Country/Region Code";
                        end;
                        if RespCenter."Remit Phone No." <> '' then begin
                            I += 1;
                            BillToAddress[I] := RespCenter."Remit Phone No.";
                        end;
                        if RespCenter."Remit E-Mail" <> '' then begin
                            I += 1;
                            BillToAddress[I] := RespCenter."Remit E-Mail";
                        end;
                    end;
                //CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");
                IF "Purchaser Code" = '' THEN
                    CLEAR(SalesPurchPerson)
                ELSE
                    SalesPurchPerson.GET("Purchaser Code");
                IF "Payment Terms Code" = '' THEN
                    CLEAR(PaymentTerms)
                ELSE
                    PaymentTerms.GET("Payment Terms Code");
                IF "Shipment Method Code" = '' THEN
                    CLEAR(ShipmentMethod)
                ELSE
                    ShipmentMethod.GET("Shipment Method Code");
                FormatAddress.PurchHeaderBuyFrom(BuyFromAddress, "Purchase Header");
                FormatAddress.PurchHeaderShipTo(ShipToAddress, "Purchase Header");
                IF NOT CurrReport.PREVIEW THEN BEGIN
                    // IF ArchiveDocument THEN ArchiveManagement.StorePurchDocument("Purchase Header", LogInteraction);
                    // IF LogInteraction THEN BEGIN
                    //     CALCFIELDS("No. of Archived Versions");
                    //     SegManagement.LogDocument(13, "No.", "Doc. No. Occurrence", "No. of Archived Versions", DATABASE::Vendor, "Buy-from Vendor No.", "Purchaser Code", '', "Posting Description", '');
                    // END;
                END;
                IF "Posting Date" <> 0D THEN
                    UseDate := "Posting Date"
                ELSE
                    UseDate := WORKDATE;
                PurchasesSetup.Get();
                if PurchasesSetup."Vendor Comment Code" <> '' then begin
                    CommentLine.SetRange("Table Name", CommentLine."Table Name"::Vendor);
                    CommentLine.SetRange("No.", "Buy-from Vendor No.");
                    CommentLine.SetRange(Code, PurchasesSetup."Vendor Comment Code");
                    if CommentLine.FindSet() then
                        repeat
                            if VendorComment = '' then
                                VendorComment := CommentLine.Comment
                            else
                                VendorComment += ', ' + CommentLine.Comment;
                        until CommentLine.Next() = 0;
                end;
            end;

            trigger OnPreDataItem()
            begin
                IF PrintCompany THEN begin
                    FormatAddress.Company(CompanyAddress, CompanyInformation);
                    CompanyInformation.CalcFields(Picture);
                end
                ELSE
                    CLEAR(CompanyAddress);
            end;
        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(NumberOfCopies; NoCopies)
                    {
                        ApplicationArea = All;
                        Caption = 'Number of Copies';
                        ToolTip = 'Specifies the value of the Number of Copies field.';
                    }
                    field(PrintCompanyAddress; PrintCompany)
                    {
                        Caption = 'Print Company Address';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Print Company Address field.';
                    }
                    field(PrintItemNumber; PrintItemNumber)
                    {
                        Caption = 'Print Item Number';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Print Item Number field.';
                    }
                    // field(ArchiveDocument; ArchiveDocument)
                    // {
                    //     Caption = 'Archive Document';
                    //     ApplicationArea = All;
                    //     Enabled = ArchiveDocumentEnable;
                    //     trigger OnValidate()
                    //     begin
                    //         IF NOT ArchiveDocument THEN LogInteraction := FALSE;
                    //     end;
                    // }
                    // field(LogInteraction; LogInteraction)
                    // {
                    //     Caption = 'Log Interaction';
                    //     ApplicationArea = All;
                    //     Enabled = LogInteractionEnable;
                    //     trigger OnValidate()
                    //     begin
                    //         IF LogInteraction THEN ArchiveDocument := ArchiveDocumentEnable;
                    //     end;
                    // }
                }
            }
        }
        actions
        {
        }
        // trigger OnInit()
        // begin
        //     LogInteractionEnable := TRUE;
        //     ArchiveDocumentEnable := TRUE;
        // end;
        // trigger OnOpenPage()
        // begin
        //     ArchiveDocument := ArchiveManagement.PurchaseDocArchiveGranule;
        //     LogInteraction := SegManagement.FindInteractTmplCode(13) <> '';
        //     ArchiveDocumentEnable := ArchiveDocument;
        //     LogInteractionEnable := LogInteraction;
        // end;
    }
    rendering
    {
        layout(NewPurchaseOrder)
        {
            Type = RDLC;
            LayoutFile = './src/layout/NewPurchaseOrder.rdlc';
        }
        layout(POReceiver)
        {
            Type = RDLC;
            LayoutFile = './src/layout/POReceiver.rdlc';
        }
    }
    labels
    {
    }
    trigger OnPreReport()
    begin
        CompanyInformation.GET('');
        PrintCompany := true;
    end;

    var
        UnitPriceToPrint: Decimal;
        AmountExclInvDisc: Decimal;
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInformation: Record "Company Information";
        RespCenter: Record "Responsibility Center";
        Language1: Record Language;
        TempSalesTaxAmtLine: Record "Sales Tax Amount Line" temporary;
        TaxArea: Record "Tax Area";
        Vend: Record Vendor;
        CompanyAddress: array[8] of Text[50];
        CompanyAddress2: array[8] of Text[50];
        BuyFromAddress: array[8] of Text[50];
        ShipToAddress: array[8] of Text[50];
        BillToAddress: array[8] of Text[50];
        CopyTxt: Text[10];
        ItemNumberToPrint: Text[20];
        PrintCompany: Boolean;
        PrintItemNumber: Boolean;
        PrintFooter: Boolean;
        NoCopies: Integer;
        NoLoops: Integer;
        CopyNo: Integer;
        NumberOfLines: Integer;
        OnLineNumber: Integer;
        PurchasePrinted: Codeunit "Purch.Header-Printed";
        FormatAddress: Codeunit "Format Address";
        SalesTaxCalc: Codeunit "Sales Tax Calculate";
        ArchiveManagement: Codeunit ArchiveManagement;
        // SegManagement: Codeunit SegManagement;
        // ArchiveDocument: Boolean;
        // LogInteraction: Boolean;
        ItemNumberToPrint2: Text[50];
        TaxAmount: Decimal;
        TotalTaxLabel: Text[30];
        BreakdownTitle: Text[30];
        BreakdownLabel: array[4] of Text[30];
        BreakdownAmt: array[4] of Decimal;
        BrkIdx: Integer;
        PrevPrintOrder: Integer;
        PrevTaxPercent: Decimal;
        UseDate: Date;
        VendorComment: Text;
        Text000: Label 'COPY';
        Text003: Label 'Sales Tax Breakdown:';
        Text004: Label 'Other Taxes';
        Text005: Label 'Total Sales Tax:';
        Text006: Label 'Tax Breakdown:';
        Text007: Label 'Total Tax:';
        Text008: Label 'Tax:';
        UseExternalTaxEngine: Boolean;
        // ArchiveDocumentEnable: Boolean;
        // LogInteractionEnable: Boolean;
        ToCaptionLbl: Label 'To:';
        ReceiveByCaptionLbl: Label 'Receive By';
        VendorIDCaptionLbl: Label 'Vendor ID';
        ConfirmToCaptionLbl: Label 'Confirm To';
        BuyerCaptionLbl: Label 'Buyer';
        ShipCaptionLbl: Label 'Ship';
        ToCaption1Lbl: Label 'To:';
        PurchOrderCaptionLbl: Label 'PURCHASE ORDER';
        PurchOrderNumCaptionLbl: Label 'Purchase Order Number:';
        PurchOrderDateCaptionLbl: Label 'Purchase Order Date:';
        PageCaptionLbl: Label 'Page:';
        ShipViaCaptionLbl: Label 'Ship Via';
        TermsCaptionLbl: Label 'Terms';
        PhoneNoCaptionLbl: Label 'Phone No.';
        TaxIdentTypeCaptionLbl: Label 'Tax Ident. Type';
        ItemNoCaptionLbl: Label 'Item No.';
        UnitCaptionLbl: Label 'Unit';
        DescriptionCaptionLbl: Label 'Description';
        QuantityCaptionLbl: Label 'Quantity';
        UnitPriceCaptionLbl: Label 'Unit Price';
        TotalPriceCaptionLbl: Label 'Total Price';
        SubtotalCaptionLbl: Label 'Subtotal:';
        InvDiscCaptionLbl: Label 'Invoice Discount:';
        TotalCaptionLbl: Label 'Total:';
        VendorOrderNoLbl: Label 'Vendor Order No.';
        VendorInvoiceNoLbl: Label 'Vendor Invoice No.';

    local procedure "***Beck***"()
    begin
    end;

    local procedure UserName(_userID: Text): Text
    var
        _user: Record User;
    begin
        //PRI00.44
        IF _userID = '' THEN EXIT(_userID);
        _user.SETRANGE("User Name", _userID);
        IF _user.FINDFIRST THEN EXIT(_user."Full Name");
        EXIT(_userID);
    end;
}
