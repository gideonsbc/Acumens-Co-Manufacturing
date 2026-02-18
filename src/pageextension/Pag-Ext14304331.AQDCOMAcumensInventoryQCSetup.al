// pageextension 14304331 "AQD COMAcumensInventoryQCSetup" extends "AQD Acumens Inventory QC Setup"
// {
//     actions
//     {
//         addafter("Location Setup")
//         {
//             action("AQD Manufacturing Setup")
//             {
//                 Image = Delivery;
//                 RunObject = page "Manufacturing Setup";
//                 ApplicationArea = All;
//                 ToolTip = 'Executes the Manufacturing Setup action.';
//                 Caption = 'Manufacturing Setup';
//             }
//             action("AQD About the C0-Manufacturing App")
//             {
//                 Image = AboutNav;
//                 RunObject = page "AQD About Acumens Co-Manufact";
//                 ApplicationArea = All;
//                 ToolTip = 'Executes the About Acumens Co-Manufacturing page.';
//                 Caption = 'About the Co-Manufacturing App';
//             }
//         }
//         addafter(Category_Process)
//         {
//             group("AQD Manufacturing")
//             {
//                 Caption = 'Co-Manufacturing', Comment = 'Generated from the PromotedActionCategories property index 1.';
//                 actionref("Manufacturing Setup_Promoted"; "AQD Manufacturing Setup") { }
//             }
//         }
//         addfirst(Category_New)
//         {
//             actionref("AQD About the C0-Manufacturing App_Promoted"; "AQD About the C0-Manufacturing App") { }
//         }
//     }
// }
