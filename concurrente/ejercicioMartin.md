Resolver este ejercicio con ADA. 
En un banco se tiene un sistema que administra el uso de una sala de reuniones por parte de N clientes.
Los clientes se clasifican en habituales o temporales.
La sala puede ser usada por un unico cliente a la vez y cuando esta libre se debe  determinar a quien permitirle su uso siempre priorizando a los clientes habituales.
Dentro de cada clase de cliente se debe respetar el orden de llegada.
Nota: suponga que existe una funcion tipo() que le indica al cliente de que tipo esta

Task Sala is
    ENTRY UsarPrioritario
    ENTRY Usar
    ENTRY Liberar
end;

Task type cliente is
end;


Task body Cliente is
begin
    if tipo()="HABITUAL"{
        SALA.UsarPrioritario()
    }
    else if tipo()="TEMPORAL"{
        SALA.Usar()
    }
    //la usa
    delay(random)
    SALA.Liberar()
end

Task body Sala is
begin
    while (true) loop
        SELECT 
            ACCEPT UsarPrioritario();
            or WHEN (UsarPrioritario'count=0) ACCEPT Usar();
        END SELECT
        ACCEPT Liberar()
    end loop
end


arrCli(1..N): Array of Cliente