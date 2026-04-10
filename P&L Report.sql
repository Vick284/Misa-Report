USE [MisaRP]
GO

/****** Object:  View [dbo].[BC_KQKD]    Script Date: 10/04/2026 4:35:56 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








ALTER VIEW [dbo].[BC_KQKD] AS
WITH CTEB AS (
    SELECT
	[Rowid]
      ,[DocCode]
      ,[DocDate]
      ,[DocNo]
      ,[CustomerCode0]
      ,[Person]
      ,[Description]
	  ,[BSDescription]
      ,[ExpenseCatgCode]
      ,[ExpenseItemName]
      ,[DeptCode]
      ,[DeptCode1]
      ,[ProductCode]
      ,[DebitAccount]
      ,[CreditAccount]
      ,[Amount] AS Amount_z
      ,[DoituongNo]
      ,[DoituongCo]
      ,[InvNo]
      ,[InvDate]
	  ,[Unit]
      ,[Quantity]
      ,[UnitCost]
      ,[ItemCode]
      ,[ItemName]
      ,[WarehouseCodeIN]
      ,[WarehouseCodeOUT]
	  ,CASE 
	WHEN itemname IS NULL OR itemname = '' THEN description
    ELSE itemname
    END AS official_itemname
    FROM [MisaRP].[dbo].[BKCT]
),
CTE1 AS (
    SELECT *,
        CASE
            WHEN LEFT(CreditAccount,3) IN ('622', '642', '627', '621', '811') 
            THEN CONCAT(CreditAccount,ExpenseCatgCode)
            WHEN LEFT(DebitAccount,3) IN ('622', '642', '627', '621', '811') 
            THEN CONCAT(DebitAccount,ExpenseCatgCode)
        END AS newDBaccount,
        CASE
            WHEN LEFT(CreditAccount,3) IN ('511', '521', '711') 
            THEN CONCAT(CreditAccount,ExpenseCatgCode)
            WHEN LEFT(DebitAccount,3) IN ('511', '521', '711') 
            THEN CONCAT(DebitAccount,ExpenseCatgCode)
        END AS newCDaccount
    FROM CTEB
),
CTE2 AS (
    SELECT
        Stt AS SttKhaibao, 
        Description AS Name_DT_CP,
        ItemNo,
        CONCAT(CAST(Stt AS NVARCHAR),'.',REPLACE(Description,'-','')) AS Mix_stt_Name,
        CONCAT(CAST(Account AS NVARCHAR),ExpenseCatgCode) AS newaccount_KBCT_DT,
        CONCAT(CAST(Account AS NVARCHAR),ExpenseCatgCode) AS newaccount_KBCT_CP
    FROM [MisaRP].[dbo].[FormulaV2270524]
),
CTE3 AS (
    SELECT 
        t1.*,
        t2.SttKhaibao AS Stt_CP,
        t2.Mix_stt_Name,
        t2.ItemNo,
        t2.newaccount_KBCT_CP,
        t2.newaccount_KBCT_DT,
        CASE
            WHEN t1.newDBaccount = t2.newaccount_KBCT_CP THEN t2.Mix_stt_Name
            ELSE 'Null'
        END AS Name_CP
    FROM CTE1 t1
    LEFT JOIN CTE2 t2
    ON t1.newDBaccount = t2.newaccount_KBCT_CP
),
CTE3_1 AS (
    SELECT 
        a.*,
        b.SttKhaibao AS Stt_DT,
        CASE
            WHEN a.newCDaccount = b.newaccount_KBCT_DT THEN b.Mix_stt_Name
            ELSE 'Null'
        END AS Name_DT
    FROM CTE3 a
    LEFT JOIN CTE2 b
    ON a.newCDaccount = b.newaccount_KBCT_DT
),
CTE5 AS (
    SELECT 
        *,
        FORMAT(CONVERT(DATETIME, DocDate, 120), 'dd/MM/yyyy') AS newdate,
        CONCAT(Stt_CP,'.',Name_CP) AS ChiphiV2,
        CONCAT(Stt_DT,'.',Name_DT) AS DoanhthuV2,
        CONCAT(DebitAccount,'-',Name_CP) AS offnameCP,
        CONCAT(CreditAccount,'-',Name_DT) AS offnameDT,
        CONCAT(ExpenseCatgCode,'-',ExpenseItemName) AS offKM
    FROM CTE3_1
),
CTE6 AS(
SELECT *,
    CASE
        WHEN LEFT(CreditAccount,3) IN ('622', '642', '627', '621', '811') 
        THEN -Amount_z
        WHEN LEFT(DebitAccount,3) IN ('511', '521', '711') 
        THEN -Amount_z
        WHEN LEFT(DebitAccount,3) IN ('622', '642', '627', '621', '811')
        THEN Amount_z
        WHEN LEFT(CreditAccount,3) IN ('511', '521', '711')
        THEN Amount_z
    END AS Amount,
    CASE
        WHEN LEFT(DebitAccount,3) IN ('622', '642', '627', '621', '811') 
        OR LEFT(CreditAccount,3) IN ('622', '642', '627', '621', '811')
        THEN 'CHI PHI'
        WHEN LEFT(CreditAccount,3) IN ('511', '711')
        OR LEFT(DebitAccount,3) IN ('511', '711')
        THEN 'DOANH THU'
        WHEN LEFT(DebitAccount,3) = '521'
        THEN 'GIAM TRU DOANH THU'
    END AS PHANLOAI_DTCP
FROM CTE5
)
SELECT TOP 100 PERCENT *
FROM CTE6
WHERE DeptCode IN ('SL','SLCAM')
ORDER BY Stt_CP ASC, Stt_DT ASC, ProductCode ASC, newdate ASC
GO

