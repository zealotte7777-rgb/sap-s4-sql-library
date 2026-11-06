SELECT 
    aufk.AUFNR AS ProductionOrder,
    aufk.AUART AS OrderType,
    aufk.WERKS AS Plant,
    resb.PLNUM AS PlannedOrder,
    afko.PLNBEZ AS Material,
    prps.POSID AS WBSElement,
    prps.POST1 AS WBSText,
    afko.GSTRS AS OrderStartDate,
    afko.GLTRS AS OrderFinishDate,
    afko.GAMNG AS TotalQuantity,
    afko.GMEIN AS Unit
FROM AUFK AS aufk
INNER JOIN AFKO AS afko 
    ON aufk.MANDT = afko.MANDT 
   AND aufk.AUFNR = afko.AUFNR
INNER JOIN PRPS AS prps 
    ON aufk.MANDT = prps.MANDT 
   AND aufk.PSPEL = prps.PSPNR
LEFT JOIN RESB AS resb 
    ON afko.MANDT = resb.MANDT 
   AND afko.RSNUM = resb.RSNUM 
   AND resb.PLNUM <> ''
WHERE aufk.MANDT = '100'
  AND aufk.AUTYP = '10'                          
  AND aufk.AUART IN ('ZP01', 'ZP02', 'ZP03')  -- 限定生产订单类型
  AND COALESCE(aufk.LOEKZ, '') = ''          -- 排除已删除的订单
  -- 排除技术完工(TECO)和已关闭(CLSD)的生产订单
  AND aufk.OBJNR NOT IN (
      SELECT OBJNR 
      FROM JEST 
      WHERE MANDT = '100' 
        AND STAT IN ('I0045', 'I0046') 
        AND INACT = ''
  )
  AND aufk.PSPEL IN (
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
ORDER BY aufk.AUFNR;
