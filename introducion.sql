-- Base de datos

/* Obtener el primer nombre del empleado 200 y almacenarlo en la variable v_fname (bloque PL/SQL) */
DECLARE
    V_FNAME VARCHAR2(25);
BEGIN
    SELECT
        FIRST_NAME INTO V_FNAME
    FROM
        EMPLOYEES
    WHERE
        EMPLOYEE_ID = 200;
    DBMS_OUTPUT.PUT_LINE('El primer nombre del empleado 200 es: '
        || V_FNAME);
END;
 /* Obtener la suma total de todos los emplados que trabajan en el departamento 60 (bloque PL/SQL) */
DECLARE
    V_SUM_SAL NUMBER(10, 2);
    V_DEPTNO  NUMBER NOT NULL := 60;
BEGIN
    SELECT
        SUM(SALARY) INTO V_SUM_SAL
    FROM
        EMPLOYEES
    WHERE
        DEPARTMENT_ID = V_DEPTNO;
    DBMS_OUTPUT.PUT_LINE('La suma de los salarios es:'
        || TO_CHAR(V_SUM_SAL, '$999,999'));
END;
 /* Sentencia if simple (bloque PL/SQL) */
DECLARE
    V_MI_EDAD   NUMBER(2) := 10;
    V_MI_NOMBRE VARCHAR2(25) := 'Bryan';
BEGIN
    IF V_MI_EDAD < 11 AND V_MI_NOMBRE = 'Bryan' THEN
        DBMS_OUTPUT.PUT_LINE('Me llamo Bryan');
    END IF;
END;
 /* Sentencia if then else (bloque PL/SQL) */
DECLARE
    V_SALARIO_MIN NUMBER(4);
BEGIN
    SELECT
        MIN(SALARY) INTO V_SALARIO_MIN
    FROM
        EMPLOYEES;
    DBMS_OUTPUT.PUT_LINE('El salario minimo es de: '
        || TRIM(TO_CHAR(V_SALARIO_MIN, '$999,999')));
    IF V_SALARIO_MIN > 3000 THEN
        DBMS_OUTPUT.PUT_LINE('Por lo tanto esta dentro del rango normal');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Por lo tanto debe ser aumentado');
    END IF;
END;
 /* Sentencia if then elsif else (bloque PL/SQL) 
valida el salario maximo obtenido desde tabla employees.
*/
DECLARE
    V_SAL_MAX NUMBER(5);
BEGIN
    SELECT
        MAX(SALARY) INTO V_SAL_MAX
    FROM
        EMPLOYEES;
    IF V_SAL_MAX < 5000 THEN
        DBMS_OUTPUT.PUT_LINE('Salario maximo menor a 5000');
    ELSIF V_SAL_MAX < 10000 THEN
        DBMS_OUTPUT.PUT_LINE('Salario maximo menor a 10000 y mayor a 5000');
    ELSIF V_SAL_MAX < 15000 THEN
        DBMS_OUTPUT.PUT_LINE('Salario maximo menor a 15000 y mayor a 10000');
    ELSIF V_SAL_MAX < 20000 THEN
        DBMS_OUTPUT.PUT_LINE('Salario maximo menor a 20000 y mayor a 15000');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Salario maximo es mayor a 20000');
    END IF;
END;
 /* expresion case (bloque PL/SQL) */
DECLARE
    V_CALIDAD    VARCHAR2(1) := 'A';
    V_VALORACION VARCHAR2(20);
BEGIN
    V_VALORACION := CASE V_CALIDAD WHEN 'A' THEN 'Excelente' WHEN 'B' THEN 'Muy bueno' WHEN 'C' THEN 'Bueno' ELSE 'No existe calidad' END;
    DBMS_OUTPUT.PUT_LINE('Calidad: '
        || V_CALIDAD
        || ' Valoracion: '
        || V_VALORACION);
END;
 /* Sentencia case (bloque PL/SQL) 
- ROUND: redondea el valor a un numero especifico de decimales.
- AVG: devuelve el promedio de los valores de una expresion.
*/
DECLARE
    V_SAL_PROM NUMBER(5);
BEGIN
    SELECT
        ROUND(AVG(SALARY)) INTO V_SAL_PROM
    FROM
        EMPLOYEES;
    CASE
        WHEN V_SAL_PROM < 5000 THEN
            UPDATE EMPLOYEES
            SET
                SALARY = SALARY * 1.25
            WHERE
                SALARY < V_SAL_PROM;
        WHEN V_SAL_PROM < 7000 THEN
            UPDATE EMPLOYEES
            SET
                SALARY = SALARY * 1.10
            WHERE
                SALARY < V_SAL_PROM;
        ELSE
            DBMS_OUTPUT.PUT_LINE('No corresponde aumento de salario');
    END CASE;
END;
 /* Diferencia entre sentencia case y expresion case
== Expresiones case ==
- Evalua la condicion y retorna un valor.
- Termina con la palabra end.

== Sentencia case ==
- Evalua la condicion y realiza una accion
- La sentencia puede ser un bloque completo PL/SQL.
- Termina con la palabra end case.
*/
 /* Controles de iteracion (Bucles) */
 /* Bucle loop (bloque PL/SQL) */
 /* Inserta 3 registros en la tabla locations con el pais 'CA' y la ciudad 'Montreal' */
DECLARE
    V_COUNTRYID LOCATIONS.COUNTRY_ID%TYPE := 'CA';
    V_LOC_ID    LOCATIONS.LOCATION_ID%TYPE;
    V_CONTRADOR NUMBER(2) := 1;
    V_NEW_CITY  LOCATIONS.CITY%TYPE := 'Montreal';
BEGIN
    SELECT
        MAX(LOCATION_ID) INTO V_LOC_ID
    FROM
        LOCATIONS
    WHERE
        COUNTRY_ID = V_COUNTRYID;
    LOOP
        INSERT INTO LOCATIONS(
            LOCATION_ID,
            CITY,
            COUNTRY_ID
        ) VALUES (
            (V_LOC_ID + V_CONTRADOR),
            V_NEW_CITY,
            V_COUNTRYID
        );
        V_CONTRADOR := V_CONTRADOR + 1;
        EXIT WHEN V_CONTRADOR > 3;
    END LOOP;
END;
SELECT
    *
FROM
    LOCATIONS
WHERE
    COUNTRY_ID = 'CA';
 /* WHILE LOOP (bloque PL/SQL) */
DECLARE
    V_COUNTRYID LOCATIONS.COUNTRY_ID%TYPE := 'CA';
    V_LOC_ID    LOCATIONS.LOCATION_ID%TYPE;
    V_NEW_CITY  LOCATIONS.CITY%TYPE := 'Montreal';
    V_CONTRADOR NUMBER := 1;
BEGIN
    SELECT
        MAX(LOCATION_ID) INTO V_LOC_ID
    FROM
        LOCATIONS
    WHERE
        COUNTRY_ID = V_COUNTRYID;
    WHILE V_CONTRADOR <= 3 LOOP
        INSERT INTO LOCATIONS(
            LOCATION_ID,
            CITY,
            COUNTRY_ID
        ) VALUES (
            (V_LOC_ID + V_CONTRADOR),
            V_NEW_CITY,
            V_COUNTRYID
        );
        V_CONTRADOR := V_CONTRADOR + 1;
    END LOOP;
END;
 /* FOR LOOP (bloque PL/SQL) */
DECLARE
    V_COUNTRYID LOCATIONS.COUNTRY_ID%TYPE := 'CA';
    V_LOC_ID    LOCATIONS.LOCATION_ID%TYPE;
    V_NEW_CITY  LOCATIONS.CITY%TYPE := 'Montreal';
BEGIN
    SELECT
        MAX(LOCATION_ID) INTO V_LOC_ID
    FROM
        LOCATIONS
    WHERE
        COUNTRY_ID = V_COUNTRYID;
    FOR I IN 1..3 LOOP
        INSERT INTO LOCATIONS(
            LOCATION_ID,
            CITY,
            COUNTRY_ID
        ) VALUES (
            (V_LOC_ID + I),
            V_NEW_CITY,
            V_COUNTRYID
        );
    END LOOP;
END;
 /*
el bucle LOOP es un bucle infinito controlado manualmente, el bucle WHILE LOOP se repite mientras una condición sea verdadera y el bucle FOR LOOP itera sobre una secuencia de valores conocida. La elección del bucle a utilizar depende de la lógica y las necesidades específicas del programa.
*/
