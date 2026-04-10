USE [MisaRP]
GO

/****** Object:  View [dbo].[vw_MasterData]    Script Date: 10/04/2026 4:14:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO













CREATE VIEW [dbo].[vw_MasterData]
AS
WITH CTE01 AS (SELECT        A.RefID, A.RefType, A.RefNoFinance, A.RefNoManagement, A.CABARefNoFinance, A.CABARefNoManagement, A.RefDate, A.PostedDate, A.CurrencyID, A.InvNo, A.InvDate, A.DebitAccount, A.CreditAccount, 
                                                              A.InventoryItemID, A.UnitID, A.InStockID, A.OutStockID, A.Quantity, A.UnitPriceFinance, A.UnitPriceManagement, A.AmountOCFinance, A.AmountOCManagement, A.AmountFinance, A.AmountManagement, 
                                                              A.DiscountRate, A.DiscountAmountOC, A.DiscountAmount, A.TotalAmountOCFinance, A.TotalAmountOCManagement, A.TotalAmountFinance, A.TotalAmountManagement, A.FixedAssetID, A.SupplyID, 
                                                              A.MasterAccountObjectID, A.DebitAccountObjectID, A.CreditAccountObjectID, A.OrganizationUnitID, A.EmployeeID, A.ExpenseItemID, A.BudgetItemID, A.ProjectWorkID, A.JobID, A.OrderID, A.PUOrderRefID, 
                                                              A.ContractID, A.PUContractID, A.BankAccountID, A.ListItemID, A.PurchasePurposeID, A.InvestmentProjectID, A.Description, A.DetailDescription, A.DetailInventoryItemID, A.DetailUnitID, A.DetailJobID, 
                                                              A.DetailContractID, A.DetailExpenseItemID, A.DetailOrganizationUnitID, A.IsPostedFinance, A.IsPostedManagement, A.DisplayOnBook, A.BranchID, A.RefDetailID, A.CreatedDate, A.CreatedBy, A.ModifiedDate, 
                                                              A.ModifiedBy, A.LOANAgreementID, A.SortOrder, 
															  B.AccountObjectID, B.AccountObjectCode, B.AccountObjectName, B.Address, B.CompanyTaxCode, B.Tel, B.Mobile, 
															  C.InventoryItemCode, C.InventoryItemName, 
                                                              D.UnitName, 
															  E.FixedAssetCode, E.FixedAssetName, 
															  F.SupplyCode, F.SupplyName, 
															  G.AccountObjectCode AS DebitAccountObject, 
															  H.AccountObjectCode AS CreditAccountObject, 
															  I.CHINHANH, I.VANPHONG, I.PHONGBAN, I.NHOM, 
															  K.ExpenseItemCode, K.ExpenseItemName, 
															  L.ProjectWorkCode, L.ProjectWorkName, L.ProjectWorkCategoryID,
															  M.BankAccountNumber, M.BankName, 
															  N.PurchasePurposeCode, N.PurchasePurposeName, 
                                                              O.RefTypeName, O.RefTypeCategory, 
															  P.AccountObjectCode AS DebitAccountObjectCode, 
															  Q.AccountObjectCode AS CreditAccountObjectCode, 
															  R.StockCode AS WarehouseCodeIN, 
                                                              S.StockCode AS WarehouseCodeOUT,
															  T.ProjectWorkCategoryCode,
															  U. AccountName AS DebitAccountName,
															  V. AccountName AS CreditAccountName
															  
                                     FROM            GNL_2024.dbo.View_Search_Voucher AS A LEFT OUTER JOIN
                                                              GNL_2024.dbo.AccountObject AS B ON A.MasterAccountObjectID = B.AccountObjectID LEFT OUTER JOIN
                                                              GNL_2024.dbo.InventoryItem AS C ON A.InventoryItemID = C.InventoryItemID LEFT OUTER JOIN
                                                              GNL_2024.dbo.Unit AS D ON A.UnitID = D.UnitID LEFT OUTER JOIN
                                                              GNL_2024.dbo.FixedAsset AS E ON A.FixedAssetID = E.FixedAssetID LEFT OUTER JOIN
                                                              GNL_2024.dbo.View_Supply AS F ON A.SupplyID = F.SupplyID LEFT OUTER JOIN
                                                              GNL_2024.dbo.AccountObject AS G ON A.DebitAccountObjectID = G.AccountObjectID LEFT OUTER JOIN
                                                              GNL_2024.dbo.AccountObject AS H ON A.CreditAccountObjectID = H.AccountObjectID LEFT OUTER JOIN
                                                              dbo.View_SplitOrganizationGNL AS I ON A.OrganizationUnitID = I.OrganizationUnitID LEFT OUTER JOIN
                                                              GNL_2024.dbo.ExpenseItem AS K ON A.ExpenseItemID = K.ExpenseItemID LEFT OUTER JOIN
                                                              GNL_2024.dbo.ProjectWork AS L ON A.ProjectWorkID = L.ProjectWorkID LEFT OUTER JOIN
                                                              GNL_2024.dbo.BankAccount AS M ON A.BankAccountID = M.BankAccountID LEFT OUTER JOIN
                                                              GNL_2024.dbo.PurchasePurpose AS N ON A.PurchasePurposeID = N.PurchasePurposeID LEFT OUTER JOIN
                                                              GNL_2024.dbo.SYSRefType AS O ON A.RefType = O.RefType LEFT OUTER JOIN
                                                              GNL_2024.dbo.AccountObject AS P ON A.DebitAccountObjectID = P.AccountObjectID LEFT OUTER JOIN
                                                              GNL_2024.dbo.AccountObject AS Q ON A.CreditAccountObjectID = Q.AccountObjectID LEFT OUTER JOIN
                                                              GNL_2024.dbo.Stock AS R ON A.InStockID = R.StockID LEFT OUTER JOIN
                                                              GNL_2024.dbo.Stock AS S ON A.OutStockID = S.StockID LEFT OUTER JOIN
															  GNL_2024.dbo.ProjectWorkCategory AS T ON L.ProjectWorkCategoryID = T.ProjectWorkCategoryID LEFT OUTER JOIN
															  GNL_2024.dbo.Account AS U ON A.DebitAccount = U.AccountNumber LEFT OUTER JOIN
															  GNL_2024.dbo.Account AS V ON A.CreditAccount = V.AccountNumber)
    SELECT        RefDetailID AS RowidRAW,
								CASE
								WHEN LEFT(LTRIM(RTRIM(ISNULL(DebitAccount, ''))), 4) IN ('3331', '1331')
           OR LEFT(LTRIM(RTRIM(ISNULL(CreditAccount, ''))), 4) IN ('3331', '1331')
        THEN CONCAT(CAST(RefDetailID AS NVARCHAR(36)), 'VAT')
        ELSE CAST(RefDetailID AS NVARCHAR(36))
								END AS Rowid,
                              CASE 
								WHEN	RefTypeCategory = '201' THEN 'NM' 
								WHEN	RefTypeCategory = '203' THEN 'PN' 
								WHEN	RefTypeCategory = '202' THEN 'PX' 
								WHEN	RefTypeCategory = '305' THEN 'PK' 
								WHEN	RefTypeCategory = '201' THEN 'NM' 
								WHEN	RefType LIKE '%353%' OR
									RefType LIKE '%356%' THEN 'HD' 
								WHEN RefTypeCategory = '102' THEN 'PC' 
								WHEN RefTypeCategory = '101' THEN 'PT' 
								WHEN RefTypeCategory = '150' THEN 'BC' 
								WHEN RefTypeCategory = '151' THEN 'BN' 
								WHEN RefTypeCategory = '401' THEN 'PK' 
								WHEN RefTypeCategory = '254' THEN 'TD' 
								ELSE NULL 
								END AS DocCode,
								RefDate AS DocDate, 
								RefNoFinance AS DocNo, 
								AccountObjectCode AS CustomerCode0, 
								AccountObjectName AS Person, 
								DetailDescription AS Description,
								Description AS BSDescription, 
								ExpenseItemCode AS ExpenseCatgCode, 
								ExpenseItemName, 
								VANPHONG AS DeptCode, 
								PHONGBAN AS DeptCode1, 
								NHOM AS ProductCode, 
								ProjectWorkCode AS Congtrinh,
								ProjectWorkCategoryCode AS Nhomcongtrinh,
								CASE
								WHEN (LEFT(DebitAccount,2) IN ('62','635','64','81') OR LEFT(CreditAccount,2) IN ('62','635','64','81'))
								THEN CASE
										WHEN (CreditAccountName LIKE '%lan%' OR DebitAccountName LIKE '%lan%') THEN 'YES'
										ELSE 'NO'
										END
								END AS CPSALAN,
								DebitAccount, 
								CreditAccount,
								DebitAccountName,
								CreditAccountName,
								AmountFinance AS Amount, 
								DebitAccountObjectCode AS DoituongNo, 
								CreditAccountObjectCode AS DoituongCo, 
								InvNo, 
								InvDate, 
								FORMAT(Quantity, 'N0') AS Quantity,
								UnitName AS Unit, 
								FORMAT(UnitPriceFinance, 'N0') AS UnitCost, 
								InventoryItemCode AS ItemCode, 
								InventoryItemName AS ItemName, 
								WarehouseCodeIN, 
								WarehouseCodeOUT
     FROM            CTE01 AS CTE01_1
     WHERE        (RefType NOT IN (615, 611))
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[28] 4[3] 2[41] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "CTE01_1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 285
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 10
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_MasterData'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_MasterData'
GO

