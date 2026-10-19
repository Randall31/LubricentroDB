-- LUBRICAR - CARGA DE 1000 REGISTROS FICTICIOS
-- Conexion LUBRICAR_BD
-- Requiere las 12 tablas vacias; no modifica el DDL original
-- Identificaciones FIC-* son datos de prueba, NO cedulas reales, se pueden modificar si es necesario

SET SERVEROUTPUT ON;
DECLARE
  v_total NUMBER;
  v_tabla VARCHAR2(40);
  TYPE t_tablas IS TABLE OF VARCHAR2(40);
  v_tablas t_tablas := t_tablas('CLIENTE','VEHICULO','EMPLEADO','SERVICIO',
    'PROVEEDOR','REPUESTO','ORDEN_SERVICIO','DETALLE_SERVICIO',
    'DETALLE_REPUESTO','FACTURA','PAGO','MOVIMIENTO_INVENTARIO');
  v_subtotal NUMBER(12,2);
  v_descuento NUMBER(12,2);
  v_impuesto NUMBER(12,2);
BEGIN
  -- Proteccion: no duplicar cargas existentes.
  FOR j IN 1..v_tablas.COUNT LOOP
    v_tabla := v_tablas(j);
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' || v_tabla INTO v_total;
    IF v_total <> 0 THEN
      RAISE_APPLICATION_ERROR(-20001,
        'La tabla ' || v_tabla || ' ya contiene ' || v_total || ' registros. No se ejecuto la carga.');
    END IF;
  END LOOP;

  -- 1 CLIENTE (100)
  FOR i IN 1..100 LOOP
    INSERT INTO CLIENTE (ID_CLIENTE,NOMBRE,APELLIDO,CEDULA,TELEFONO,CORREO,DIRECCION,FECHA_REGISTRO)
    VALUES (i,
      CASE MOD(i,8) WHEN 0 THEN 'Andrea' WHEN 1 THEN 'Carlos' WHEN 2 THEN 'Maria' WHEN 3 THEN 'Jose' WHEN 4 THEN 'Daniela' WHEN 5 THEN 'Luis' WHEN 6 THEN 'Sofia' ELSE 'Pablo' END,
      CASE MOD(i,7) WHEN 0 THEN 'Mora' WHEN 1 THEN 'Vargas' WHEN 2 THEN 'Jimenez' WHEN 3 THEN 'Rojas' WHEN 4 THEN 'Solis' WHEN 5 THEN 'Castro' ELSE 'Ramirez' END,
      'FIC-C-' || LPAD(i,6,'0'),
      '8' || LPAD(i,7,'0'),
      'cliente' || i || '@ejemplo.test',
      'Direccion ficticia ' || i || ', Costa Rica',
      DATE '2025-01-01' + MOD(i,365));
  END LOOP;

  -- 2 EMPLEADO (50)
  FOR i IN 1..50 LOOP
    INSERT INTO EMPLEADO (ID_EMPLEADO,NOMBRE,APELLIDO,CEDULA,TELEFONO,CORREO,PUESTO,FECHA_CONTRATACION,ESTADO)
    VALUES (i,
      CASE MOD(i,6) WHEN 0 THEN 'Esteban' WHEN 1 THEN 'Valeria' WHEN 2 THEN 'Ricardo' WHEN 3 THEN 'Natalia' WHEN 4 THEN 'Marco' ELSE 'Paola' END,
      CASE MOD(i,5) WHEN 0 THEN 'Campos' WHEN 1 THEN 'Araya' WHEN 2 THEN 'Vega' WHEN 3 THEN 'Herrera' ELSE 'Alfaro' END,
      'FIC-E-' || LPAD(i,6,'0'),
      '7' || LPAD(i,7,'0'),
      'empleado' || i || '@ejemplo.test',
      CASE MOD(i,4) WHEN 0 THEN 'Mecanico' WHEN 1 THEN 'Tecnico' WHEN 2 THEN 'Asesor de servicio' ELSE 'Administrador' END,
      DATE '2022-01-01' + i*12,'Activo');
  END LOOP;

  -- 3 SERVICIO (50)
  FOR i IN 1..50 LOOP
    INSERT INTO SERVICIO (ID_SERVICIO,NOMBRE,DESCRIPCION,PRECIO_BASE,DURACION_MINUTOS,ESTADO)
    VALUES (i,
      CASE MOD(i,8) WHEN 0 THEN 'Cambio de aceite' WHEN 1 THEN 'Revision de frenos' WHEN 2 THEN 'Alineacion' WHEN 3 THEN 'Balanceo' WHEN 4 THEN 'Revision de bateria' WHEN 5 THEN 'Cambio de filtro' WHEN 6 THEN 'Diagnostico general' ELSE 'Revision de suspension' END || ' - Tipo ' || i,
      'Servicio de mantenimiento ficticio ' || i,
      7500 + MOD(i,12)*2500,30 + MOD(i,7)*15,'Activo');
  END LOOP;

  -- 4 PROVEEDOR (50)
  FOR i IN 1..50 LOOP
    INSERT INTO PROVEEDOR (ID_PROVEEDOR,NOMBRE,CEDULA_JURIDICA,TELEFONO,CORREO,DIRECCION,ESTADO)
    VALUES (i,'Proveedor Automotriz ' || LPAD(i,3,'0'),
      'FIC-P-' || LPAD(i,6,'0'),
      '2' || LPAD(i,7,'0'),
      'proveedor' || i || '@ejemplo.test',
      'Direccion comercial ficticia ' || i,'Activo');
  END LOOP;

  -- 5 VEHICULO (120)
  FOR i IN 1..120 LOOP
    INSERT INTO VEHICULO (ID_VEHICULO,ID_CLIENTE,PLACA,MARCA,MODELO,ANIO,COLOR,TIPO_VEHICULO)
    VALUES (i,MOD(i-1,100)+1,'FIC-' || LPAD(i,6,'0'),
      CASE MOD(i,6) WHEN 0 THEN 'Toyota' WHEN 1 THEN 'Hyundai' WHEN 2 THEN 'Honda' WHEN 3 THEN 'Nissan' WHEN 4 THEN 'Kia' ELSE 'Suzuki' END,
      CASE MOD(i,6) WHEN 0 THEN 'Corolla' WHEN 1 THEN 'Accent' WHEN 2 THEN 'Civic' WHEN 3 THEN 'Sentra' WHEN 4 THEN 'Rio' ELSE 'Vitara' END,
      2008+MOD(i,18),
      CASE MOD(i,5) WHEN 0 THEN 'Blanco' WHEN 1 THEN 'Negro' WHEN 2 THEN 'Gris' WHEN 3 THEN 'Azul' ELSE 'Rojo' END,
      CASE MOD(i,3) WHEN 0 THEN 'Sedan' WHEN 1 THEN 'SUV' ELSE 'Hatchback' END);
  END LOOP;

  -- 6 REPUESTO (100)
  FOR i IN 1..100 LOOP
    INSERT INTO REPUESTO (ID_REPUESTO,ID_PROVEEDOR,NOMBRE,DESCRIPCION,MARCA,PRECIO_COMPRA,PRECIO_VENTA,EXISTENCIAS,STOCK_MINIMO)
    VALUES (i,MOD(i-1,50)+1,
      CASE MOD(i,8) WHEN 0 THEN 'Filtro de aceite' WHEN 1 THEN 'Pastillas de freno' WHEN 2 THEN 'Bujias' WHEN 3 THEN 'Filtro de aire' WHEN 4 THEN 'Aceite motor' WHEN 5 THEN 'Correa' WHEN 6 THEN 'Bateria' ELSE 'Amortiguador' END || ' ' || i,
      'Repuesto ficticio para practica ' || i,
      CASE MOD(i,4) WHEN 0 THEN 'Bosch' WHEN 1 THEN 'NGK' WHEN 2 THEN 'Denso' ELSE 'Generica' END,
      2000+MOD(i,20)*900,3000+MOD(i,20)*1200,10+MOD(i,70),5);
  END LOOP;

  -- 7 ORDEN_SERVICIO (120)
  FOR i IN 1..120 LOOP
    INSERT INTO ORDEN_SERVICIO (ID_ORDEN,ID_VEHICULO,ID_EMPLEADO,FECHA_INGRESO,FECHA_FINALIZACION,KILOMETRAJE,DESCRIPCION_PROBLEMA,DIAGNOSTICO,ESTADO,OBSERVACIONES)
    VALUES (i,i,MOD(i-1,50)+1,
      DATE '2026-01-01' + MOD(i,240),
      DATE '2026-01-02' + MOD(i,240),
      10000 + i*700,
      'Mantenimiento preventivo solicitado - orden ' || i,
      'Revision general y servicio programado',
      'Finalizada','Datos de prueba academica');
  END LOOP;

  -- 8 DETALLE_SERVICIO (100)
  FOR i IN 1..100 LOOP
    INSERT INTO DETALLE_SERVICIO (ID_DETALLE_SERVICIO,ID_ORDEN,ID_SERVICIO,CANTIDAD,PRECIO_UNITARIO,DESCUENTO)
    VALUES (i,i,MOD(i-1,50)+1,1,7500+MOD(MOD(i-1,50)+1,12)*2500,0);
  END LOOP;

  -- 9 DETALLE_REPUESTO (100)
  FOR i IN 1..100 LOOP
    INSERT INTO DETALLE_REPUESTO (ID_DETALLE_REPUESTO,ID_ORDEN,ID_REPUESTO,CANTIDAD,PRECIO_UNITARIO)
    VALUES (i,i,i,1,3000+MOD(i,20)*1200);
  END LOOP;

  -- 10 FACTURA (80): importes consistentes con detalles de las primeras 80 ordenes.
  FOR i IN 1..80 LOOP
    v_subtotal := (7500+MOD(MOD(i-1,50)+1,12)*2500) + (3000+MOD(i,20)*1200);
    v_descuento := 0;
    v_impuesto := ROUND((v_subtotal-v_descuento)*0.13,2);
    INSERT INTO FACTURA (ID_FACTURA,ID_ORDEN,FECHA_EMISION,SUBTOTAL,DESCUENTO,IMPUESTO,TOTAL,ESTADO)
    VALUES (i,i,DATE '2026-01-03'+MOD(i,240),v_subtotal,v_descuento,v_impuesto,
      v_subtotal-v_descuento+v_impuesto,'Pagada');
  END LOOP;

  -- 11 PAGO (80): un pago completo por factura.
  FOR i IN 1..80 LOOP
    v_subtotal := (7500+MOD(MOD(i-1,50)+1,12)*2500) + (3000+MOD(i,20)*1200);
    v_impuesto := ROUND(v_subtotal*0.13,2);
    INSERT INTO PAGO (ID_PAGO,ID_FACTURA,FECHA_PAGO,MONTO,METODO_PAGO,REFERENCIA,ESTADO)
    VALUES (i,i,DATE '2026-01-04'+MOD(i,240),v_subtotal+v_impuesto,
      CASE MOD(i,3) WHEN 0 THEN 'Efectivo' WHEN 1 THEN 'Tarjeta' ELSE 'Transferencia' END,
      'PAGO-FIC-' || LPAD(i,6,'0'),'Registrado');
  END LOOP;

  -- 12 MOVIMIENTO_INVENTARIO (50)
  FOR i IN 1..50 LOOP
    INSERT INTO MOVIMIENTO_INVENTARIO (ID_MOVIMIENTO,ID_REPUESTO,ID_EMPLEADO,ID_ORDEN,TIPO_MOVIMIENTO,CANTIDAD,FECHA_MOVIMIENTO,OBSERVACION)
    VALUES (i,i,MOD(i-1,50)+1,i,'Salida',1,
      DATE '2026-01-02'+MOD(i,240),'Uso en orden de servicio ficticia ' || i);
  END LOOP;

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Carga completa: 1000 registros en 12 tablas.');
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error: se deshizo la carga de este bloque. ' || SQLERRM);
    RAISE;
END;
/

-- VALIDACION FINAL
SELECT 'CLIENTE' TABLA,COUNT(*) TOTAL FROM CLIENTE
UNION ALL SELECT 'VEHICULO',COUNT(*) FROM VEHICULO
UNION ALL SELECT 'EMPLEADO',COUNT(*) FROM EMPLEADO
UNION ALL SELECT 'SERVICIO',COUNT(*) FROM SERVICIO
UNION ALL SELECT 'PROVEEDOR',COUNT(*) FROM PROVEEDOR
UNION ALL SELECT 'REPUESTO',COUNT(*) FROM REPUESTO
UNION ALL SELECT 'ORDEN_SERVICIO',COUNT(*) FROM ORDEN_SERVICIO
UNION ALL SELECT 'DETALLE_SERVICIO',COUNT(*) FROM DETALLE_SERVICIO
UNION ALL SELECT 'DETALLE_REPUESTO',COUNT(*) FROM DETALLE_REPUESTO
UNION ALL SELECT 'FACTURA',COUNT(*) FROM FACTURA
UNION ALL SELECT 'PAGO',COUNT(*) FROM PAGO
UNION ALL SELECT 'MOVIMIENTO_INVENTARIO',COUNT(*) FROM MOVIMIENTO_INVENTARIO;
