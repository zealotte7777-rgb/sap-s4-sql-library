SELECT 
    b.VBELN AS SalesOrder,
    b.ERDAT AS CreationDate,
    b.KUNNR AS SoldToCustomer,
    sold_to.NAME_ORG1 AS SoldToName,
    ship_pa.KUNNR AS ShipToCustomer,
    ship_to.NAME_ORG1 AS ShipToName,
    a.POSNR AS Item,
    a.MATNR AS Material,
    m.MAKTX AS MaterialDescription,
    vep.TDDAT AS PlannedDeliveryDate,
    a.KWMENG AS OrderQuantity,
    a.VRKME AS SalesUnit,
    a.LFSTA AS DeliveryStatus
FROM VBAK AS b
INNER JOIN VBAP AS a 
    ON b.MANDT = a.MANDT 
   AND b.VBELN = a.VBELN
LEFT JOIN BUT000 AS sold_to 
    ON b.MANDT = sold_to.CLIENT 
   AND b.KUNNR = sold_to.PARTNER
INNER JOIN VBPA AS ship_pa 
    ON b.MANDT = ship_pa.MANDT 
   AND b.VBELN = ship_pa.VBELN 
   AND ship_pa.POSNR = '000000'
   AND ship_pa.PARVW = 'WE'
LEFT JOIN BUT000 AS ship_to 
    ON ship_pa.MANDT = ship_to.CLIENT 
   AND ship_pa.KUNNR = ship_to.PARTNER
LEFT JOIN VBEP AS vep 
    ON a.MANDT = vep.MANDT 
   AND a.VBELN = vep.VBELN 
   AND a.POSNR = vep.POSNR 
   AND vep.ETENR = '0001'
LEFT JOIN MAKT AS m 
    ON m.MANDT = a.MANDT 
   AND m.MATNR = a.MATNR 
   AND m.SPRAS = '1'
WHERE b.MANDT = '100'
  AND b.KUNNR IN (
    SELECT PARTNER
    FROM BUT000
    WHERE CLIENT = '100'
      AND NAME_ORG1 LIKE 'KUBOTA ENGINE%SHANGHAI%'
  )
  AND a.PSTYV = 'Z101'
  AND a.LFSTA IN ('A', 'B')
  AND COALESCE(a.ABGRU, '') = ''
ORDER BY b.VBELN, a.POSNR;
