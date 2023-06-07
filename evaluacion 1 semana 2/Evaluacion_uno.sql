
-- Requerimiento 1
DECLARE
    -- Definimos variables
    v_total_dep NUMERIC(3) := 0;
    v_dep VARCHAR2(40);
BEGIN
    -- Seleccionamos los campos correspondientes y los asignamos a las variables
    SELECT ddepartment_name, COUNT(*)
    INTO v_dep, v_total_dep
    FROM departments d 
    INNER JOIN employees e
    -- Relacionamos las tablas por el campo department_id
    ON d.department_id = e.department_id
    WHERE d.department_name = 'Finance'
    -- Agrupamos por el nombre del departamento
    GROUP BY d.department_name;
    -- Imprimimos el mensaje
    DBMS_OUTPUT.PUT_LINE('En el departamento ' || v_dep || ' trabajan ' || v_total_dep || ' empleados');
END;


-- Requerimiento 2
DECLARE
    -- Definimos las variables
    v_employee_id employees.employee_id%TYPE;
    v_salary employees.salary%TYPE;
    v_message VARCHAR2(100);
BEGIN
    -- Iteramos los registros de la consulta y que esten entre 100 y 130
    FOR i IN (
        SELECT employee_id, salary
        FROM employees
        WHERE employee_id BETWEEN 100 and 130
    )
    LOOP
        -- Asignamos los valores a las variables
        v_employee_id := i.employee_id;
        v_salary := i.salary;
        -- Evaluamos el salario y asignamos el mensaje
        IF v_salary > 10000 THEN
            v_message := 'Es un buen sueldo';
        ELSIF v_salary BETWEEN 9000 AND 10000 THEN
            v_message := 'Es un salario normal';
        ELSE
            v_message := 'Es un sueldo que se debe aumentar';
        END IF;

        -- Mostramos el mensaje
        DBMS_OUTPUT.PUT_LINE('El salario actual del empleado ' || v_employee_id || ' es de ' || v_salary || '. ' || v_message );
    END LOOP;
END;

-- Requerimiento 3
DECLARE
    v_msj VARCHAR2(10);
    v_prom NUMBER;
    -- Remplazamos el tipo de dato de v_nombre por VARCHAR2
    v_nombre VARCHAR2(20);
    v_sum NUMBER;
BEGIN
    SELECT ROUND(AVG(SALARY), 0), DEPARTMENT_NAME, SUM(SALARY)
    -- Removemos la variable v_count porq no esta definida
    INTO v_prom, v_nombre, v_sum
    FROM EMPLOYEES JOIN DEPARTMENTS 
    USING (DEPARTMENT_ID)
    GROUP BY DEPARTMENT_NAME, Department_ID
    HAVING DEPARTMENT_ID = &Ingrese_ID_Departamento;

    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Se seleccionaron: ' || SQL%ROWCOUNT || ' Filas');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No se selecciono nada');
    END IF;

    -- Remplazamos el if por un case
    v_msj := CASE WHEN v_prom < 5000 THEN 'Excelente'
                  WHEN v_prom < 3000 THEN 'Bueno'
                  WHEN v_prom < 1000 THEN 'Inaceptable'
                  ELSE '-'
            END;

    -- Al v_prom le valtaba el TO_CHAR para que se muestre el valor con formato
    DBMS_OUTPUT.PUT_LINE('Su valoracion es: ' || v_msj || ' , el valor promedio es: ' || TO_CHAR(v_prom, '$999g999') || ' y el nombre del departamento es: ' || v_nombre);
END;

-- Requerimiento 4
DECLARE 
    v_prom_com NUMBER;
    v_id_depart NUMBER;
    v_total_empl NUMBER;
    v_nombre_depart VARCHAR2(30);
    v_ubi_depart NUMBER;
    v_jefe_depart departments.manager_id%TYPE;
BEGIN
    -- Mostramos el total de emplados que trabajan en del departamento 50
    SELECT d.department_id, d.department_name, COUNT(e.employee_id)
    INTO v_id_depart, v_nombre_depart, v_total_empl
    FROM departments d JOIN employees e
    ON d.department_id = e.department_id
    WHERE d.department_id = 50
    GROUP BY d.department_id, d.department_name;
    DBMS_OUTPUT.PUT_LINE('En el departamento ' || v_nombre_depart || ' trabajan ' || v_total_empl || ' emplados.');

    -- Mostramos el emplado con el salario mas bajo
    SELECT employee_id, (first_name || ' ' || last_name) AS nombre
    INTO v_id_depart, v_nombre_depart
    FROM employees e
    WHERE salary = (
        SELECT MIN(salary)
        FROM employees
    );

    DBMS_OUTPUT.PUT_LINE(v_nombre_depart || ' es el emplado con el salario mas bajo.');

    -- Calculamos el promedio de comision y lo mostramos
    SELECT ROUND(AVG(salary * NVL(commission_pct, 0)), 0)
    INTO v_prom_com
    FROM employees;

    DBMS_OUTPUT.PUT_LINE('El promedio de las comisiones es $' || v_prom_com);

    -- Mostramos el departamento con mas empleados
    SELECT d.department_id, d.department_name, d.MANAGER_ID, d.LOCATION_ID
    INTO v_id_depart, v_nombre_depart, v_jefe_depart, v_ubi_depart
    FROM departments d JOIN employees e
    ON d.department_id = e.department_id
    GROUP BY d.department_id, d.department_name, d.MANAGER_ID, d.LOCATION_ID
    HAVING COUNT(e.employee_id) = (
        SELECT MAX(COUNT(employee_id))
        FROM employees
        GROUP BY department_id
    );

    DBMS_OUTPUT.PUT_LINE('La informacion del departamento con mayor cantidad de empleados es la siguiente:');
    DBMS_OUTPUT.PUT_LINE('Identificador: ' || v_id_depart);
    DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_nombre_depart);
    DBMS_OUTPUT.PUT_LINE('Jefe: ' || v_jefe_depart);
    DBMS_OUTPUT.PUT_LINE('Ubicacion: ' || v_ubi_depart);


END;
