-- Ejercicio 1

--  Modelar la atencion en un banco por medio de un unico empleado.
-- Los clientes llegan y son atendidos por el de acuerdo al orden de llegada


Procedure Banco1 is
    Task Empleado is
        ENTRY Atencion(datos in:Text, res out:Resultado)
    end;

    Task type Cliente;

    Task body Empleado is
         loop 
            accept Atencion(datos in:Text, res out:Resultado) do
            --Resolver
            res = idCli*10
            end Atencion
         end loop;
    end Empleado;


   Task body Cliente is
      res : Texto
   begin
        entry Empleado.Atencion("Datos",res)
    end;



arrCli: array(1..N) of Cliente;
Begin

End Banco 1;

--Modelar atencion en Banco de un unico empleado
-- Clientes llegan, esperan a lo sumo 10 min ser atendidos, por orden de llegada.  Pasado ese tiempo se retiran.



Procedure Banco1 is
    Task Empleado is
        ENTRY Atencion(datos in:Text, res out:texto)
    end;

    Task type Cliente;

    Task body Empleado is
         loop 
            accept Atencion(datos in:Text, res out:texto) do
            --Resolver
            res = idCli*10
            end Atencion
         end loop;
    end Empleado;


   Task body Cliente is
      resultado : Texto
   begin
      SELECT
         entry Empleado.Atencion("Datos",resultado)
      OR delay 600seg
         null
      END SELECT;
    end Cliente;

arrCli: array(1..N) of Cliente;
Begin

End Banco 1;


-- Modelar atencion en banco. Unico emplaedo
-- Clientes llegan y esperan ser atendidos por orden de llegada. 
-- Hay clientes tipo prioritario primero.



Procedure Banco1 is
    Task Empleado is
        ENTRY Atencion(datos in:Text, res out:texto)
        ENTRY AtencionPrioritaria(datos in:Text, res out:texto)
    end;

    Task type Cliente;

   arrCli: array(1..N) of Cliente;
   


    Task body Empleado is
         loop 
            Select 
               accept AtencionPrioritaria(datos in:Text, res out:texto)
               res = idCli*10
               end Atencion
            OR When (AtencionPrioritaria'Count = 0) accept Atencion(datos in:Text, res out:texto) do 
               res = idCli*10
               end Atencion
            END SELECT;
         end loop;
    end Empleado;


   Task body Cliente is
      resultado : Texto
   begin
      if ("cliente es prioritario"):
         entry Empleado.Atencion("Datos",resultado)
      else
         entry Empleado.AtencionPrioritaria("Datos",resultado)
      END if;
   end Cliente;

Begin
   null
End Banco 1;



-- Modelar el ejercicio uno. Pero ahora hay 2 empleados. 




Process Banco4

Task Type Empleado is 
end;

empleadoA, empleadoB : Empleado


Task Organizador is:
   Entry Siguiente(idCli out:Integer, datos out:Text)
   Entry Llegada(idCliente in:Integer, datosCliente in:Text)

Task Type Cliente is:
   ENTRY Atencion(resultado in:Text)
   ENTRY Identificar(MiId in:Integer)
end;

arrCli: array(1..N) of Cliente;



Task Body Empleado is
begin
   loop
      Organizador.siguiente(idCli, datos)
      respuesta = generarREspuesta(datos)
      arrCli[idCli].atencion(respuesta)
      
   end loop;
end Empleado;

Task Body Organizador is
begin
   loop
      accept Siguiente(idCli out:Integer, datos out:Text) do
         accept Llegada(idCliente in:integer, datosCliente in:text) do
            idCli=idCLiente;
            datos=datosCliente;
         end Llegada;
      end Siguiente;
end loop;
end Organizador;

Task Body Cliente is
   resultado: Text;
   idCli:Integer;
begin
   Accept Identificar(MiId in:Integer) do  
      idCli = MiId;
   end Identificar;
   Administrador.llegada(idCli,"datos")
   Accept Atencion(res in:Texto) do
      resultado = res;
   end Atencion;
end Cliente;


Begin
   FOR i in N loop
      arrCli[i].Identificar(i)
   end loop
end Banco4;



-- Se debe modelar la cantidad de veces que aparece un numero dentro de un vector distribuido de N tareas contador.
-- Ademas existe un administrador que decide el numero que se desea buscar y se lo envia a los N contadores para que lo busquen en la parte del vector que poseen, y calcula la cantidad total


Task Administrador is:
   ENTRY suma(cant in:Integer)
end; 

Task Type Contador is:
   ENTRY comenzar(numBuscado in:Integer)
end;

Task body Contador is:
   miCant :integer;
   numBuscado :integer;
   vector(1..V): array of Integer
begin
   miCant=0;
   ACCEPT Comenzar(numBuscado in:Integer); do
      numBuscado = bus;
   end Comenzar;
   for i in N loop
      if vector[i] = numBuscado: then
         miCant++;
      end if; 
   end loop
   Administrador.suma(miCant);
end Contador;

arrContadores(1..N): array of Contador.

Task Body Administrador is
   numBuscado :Integer
   total :Integer
begin
   total =  0
   for i in N loop
      arrContadores.comenzar(numBuscado)
   end loop
   for i in N loop
      ACCEPT suma(cant in:Integer) do
         total = cant;  
      end Suma;
   end loop
end Administrador;


begin
   null
end ejemplo5;


--MEJORADO aunque el anterior ya está bien:




Task Administrador is:
   ENTRY suma(cant in:Integer)
   ENTRY comenzar(bus out:Integer)
end; 

Task Type Contador is:
   miCant :integer;
   numBuscado :integer;
   vector(1..V): array of Integer.
begin
   miCant=0;
   Administrador.Comenzar(numBuscado); do
      numBuscado = bus;
   end Comenzar;
   for i in N loop
      if vector[i] = numBuscado: then
         miCant++;
      end if; 
   end loop
   Administrador.suma(miCant);
end Contador;

arrContadores(1..N): array of Contador.

Task Body Administrador is
   numBuscado :Integer
   total :Integer
begin
   total =  0
   numBuscado = random();
   for i in N*2 loop
      SELECT
         ACCEPT comenzar(bus) do
            bus = numBuscado;
         end Comenzar;
         or  ACCEPT suma(cant in:Integer) do
            total = cant;  
         end Suma;      
      end select;
   end loop
end Administrador;

begin
   null
end ejemplo5;