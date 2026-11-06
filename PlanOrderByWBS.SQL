SELECT 
    plaf.PLNUM AS PlannedOrder,
    plaf.MATNR AS Material,
    prps.POSID AS WBSElement,
    prps.POST1 AS WBSText,
    plaf.PSTTR AS OrderStartDate,
    plaf.PEDTR AS OrderFinishDate,
    plaf.GSMNG AS TotalQuantity,
    plaf.MEINS AS Unit
FROM PLAF AS plaf
INNER JOIN PRPS AS prps 
    ON plaf.MANDT = prps.MANDT 
   AND plaf.PSPEL = prps.PSPNR
WHERE plaf.MANDT = '100'
  AND plaf.PSPEL IN (
    SELECT DISTINCT a.PS_PSP_PNR
    FROM VBAK AS b
    INNER JOIN VBAP AS a 
        ON b.MANDT = a.MANDT 
       AND b.VBELN = a.VBELN
    WHERE b.MANDT = '100'
      AND b.KUNNR IN (
        SELECT PARTNER
        FROM BUT000
        WHERE CLIENT = '100'
          AND NAME_ORG1 LIKE 'KUBOTA ENGINE%SHANGHAI%'
      )
      AND a.PS_PSP_PNR IS NOT NULL
      AND a.PS_PSP_PNR <> 0
  )
ORDER BY plaf.PLNUM;
