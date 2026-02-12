permissionset 14304309 AQDCoManPermission
{
    Assignable = true;
    Permissions = tabledata "AQD Co-Man Header"=RIMD,
        tabledata "AQD Co-Man Lot Restriction"=RIMD,
        table "AQD Co-Man Header"=X,
        table "AQD Co-Man Lot Restriction"=X,
        report "AQD CO Purchase Order PRI"=X,
        codeunit "AQD COM Calc-Subcontracts"=X,
        codeunit "AQD COM Event Subscriber"=X,
        codeunit "AQD COM Order Mgt"=X,
        codeunit "AQD COM Single Instance"=X,
        page "AQD Archive Co-Man Card"=X,
        page "AQD Archive Co-Man List"=X,
        page "AQD Co-Man Card"=X,
        page "AQD Co-Man List"=X,
        page "AQD Co-Man Lot Restrictions"=X,
        page "AQD Finished ProdOrder Subform"=X,
        page "AQD New Co-Man"=X,
        page "AQD New Co-Man Prod. Order"=X,
        page "AQD Released ProdOrder Subform"=X,
        page "AQD Transfer To"=X;
}