## Ejercicio 1.

1. Se requiere modelar un puente de un único sentido que soporta hasta 5 unidades de peso.
El peso de los vehículos depende del tipo: cada auto pesa 1 unidad, cada camioneta pesa 2
unidades y cada camión 3 unidades. Suponga que hay una cantidad innumerable de
vehículos (A autos, B camionetas y C camiones). Analice el problema y defina qué tareas,
recursos y sincronizaciones serán necesarios/convenientes para resolverlo.
a. Realice la solución suponiendo que todos los vehículos tienen la misma prioridad.
b. Modifique la solución para que tengan mayor prioridad los camiones que el resto de los
vehículos.


Procedure CruceSinPrioridad is:
TASK Puente is 
    ENTRY cruzarAuto()
    ENTRY cruzarCamion()
    ENTRY cruzarCamioneta()


TASK BODY Puente is:
    unidadesLibres: Integer = 5
Begin
    loop: 
        SELECT
            WHEN (unidadesLIbres>=1) ENTRY CruzarAuto() do
                unidadesLibres=unidadesLibres-1
            end CruzarAuto();
            OR WHEN (unidadesLIbres>=2) ENTRY CruzarCamioneta() do
                unidadesLibres=unidadesLibres-2
            end CruzarCamioneta();
            OR WHEN (unidadesLIbres>=3) ENTRY CruzarCamion() do
                unidadesLibres=unidadesLibres-3
            end CruzarCamion();
            OR ENTRY FinCruceAuto() do
                unidadesLibres=unidadesLibres+1
            OR ENTRY FinCruceCamioneta() do
                unidadesLibres=unidadesLibres+2
            OR ENTRY FinCruceCamion() do
                unidadesLibres=unidadesLibres+3
        END SELECT
    end loop;
END


TASK TYPE Auto;

TASK BODY Auto is:
begin
    Puente.CruzarAuto()
    //Cruza
    Puente.FinCruceAuto()
end;

TASK TYPE Camion;
TASK BODY Camion is:
begin
    Puente.CruzarCamion()
    //Cruza
    Puente.FinCruceCamion()
end;

TASK TYPE Camioneta;
TASK BODY Camioneta is:
begin
    Puente.CruzarCamioneta()
    //Cruza
    Puente.FinCruceCamioneta()
end;


arrAuto(): array of Auto;
arrCamion(): array of Camion;
arrCamioneta(): array of Camioneta;




b) los camiones tienen prioridad:


Procedure CruceSinPrioridad is:
TASK Puente is 
    ENTRY cruzarAuto()
    ENTRY cruzarCamion()
    ENTRY cruzarCamioneta()


TASK BODY Puente is:
    unidadesLibres: Integer = 5
Begin
    loop: 
        SELECT
            WHEN (unidadesLIbres>=1) && (CruzarCamion.Count=0) ENTRY CruzarAuto() do
                unidadesLibres=unidadesLibres-1
            end CruzarAuto();
            OR WHEN (unidadesLIbres>=2) (CruzarCamion.Count=0) ENTRY CruzarCamioneta() do
                unidadesLibres=unidadesLibres-2
            end CruzarCamioneta();
            OR WHEN (unidadesLIbres>=3) ENTRY CruzarCamion() do
                unidadesLibres=unidadesLibres-3
            end CruzarCamion();
            OR ENTRY FinCruceAuto() do
                unidadesLibres=unidadesLibres+1
            OR ENTRY FinCruceCamioneta() do
                unidadesLibres=unidadesLibres+2
            OR ENTRY FinCruceCamion() do
                unidadesLibres=unidadesLibres+3
        END SELECT
    end loop;
END


TASK TYPE Auto;

TASK BODY Auto is:
begin
    Puente.CruzarAuto()
    //Cruza
    Puente.FinCruceAuto()
end;

TASK TYPE Camion;
TASK BODY Camion is:
begin
    Puente.CruzarCamion()
    //Cruza
    Puente.FinCruceCamion()
end;

TASK TYPE Camioneta;
TASK BODY Camioneta is:
begin
    Puente.CruzarCamioneta()
    //Cruza
    Puente.FinCruceCamioneta()
end;


arrAuto(): array of Auto;
arrCamion(): array of Camion;
arrCamioneta(): array of Camioneta;











## Ejercicio 2.
Se quiere modelar el funcionamiento de un banco, al cual llegan clientes que deben realizar
un pago y retirar un comprobante. Existe un único empleado en el banco, el cual atiende de
acuerdo con el orden de llegada.
a) Implemente una solución donde los clientes llegan y se retiran sólo después de haber sido
atendidos.
b) Implemente una solución donde los clientes se retiran si esperan más de 10 minutos para
realizar el pago.
c) Implemente una solución donde los clientes se retiran si no son atendidos
inmediatamente.
d) Implemente una solución donde los clientes esperan a lo sumo 10 minutos para ser
atendidos. Si pasado ese lapso no fueron atendidos, entonces solicitan atención una vez más
y se retiran si no son atendidos inmediatamente.


### Inciso A
Procedure BancoA is:

TASK Empleado is
    ENTRY Atencion(comp out:text);
end;


TASK TYPE Cliente is;


TASK BODY Empleado is;
begin
    loop
        ACCEPT Atencion(comp out:text) do
            //le cobra al cliente
            comp = generarComprobante()
        end Atencion;
    end loop;
end;


TASK BODY Cliente is;
    comprobante: Text;
begin
    Empleado.atencion(comp)
    comprobante = comp;
    //se va.
end Cliente;




### Inciso B
Procedure BancoB is:

TASK Empleado is
    ENTRY Atencion(comp out:text);
end;


TASK TYPE Cliente is;


TASK BODY Empleado is;
begin
    loop
        ACCEPT Atencion(comp out:text) do
            //le cobra al cliente
            comp = generarComprobante()
        end Atencion;
    end loop;
end;


TASK BODY Cliente is;
    comprobante: Text;
begin
    SELECT
        Empleado.atencion(comp) do
            comprobante = comp;
            end;
        OR DELAY 10min do
            null;
    END SELECT;
    //se va.
end Cliente;



### Inciso C
Procedure BancoC is:

TASK Empleado is
    ENTRY Atencion(comp out:text);
end;


TASK TYPE Cliente is;


TASK BODY Empleado is;
begin
    loop
        ACCEPT Atencion(comp out:text) do
            //le cobra al cliente
            comp = generarComprobante()
        end Atencion;
    end loop;
end;


TASK BODY Cliente is;
    comprobante: Text;
begin
    SELECT
        Empleado.atencion(comp) do
            comprobante = comp;
            end;
        ELSE
            null;
    END SELECT;
    //se va.
end Cliente;



### Inciso D
Procedure BancoD is:

TASK Empleado is
    ENTRY Atencion(comp out:text);
end;


TASK TYPE Cliente is;


TASK BODY Empleado is;
begin
    loop
        ACCEPT Atencion(comp out:text) do
            //le cobra al cliente
            comp = generarComprobante()
        end Atencion;
    end loop;
end;


TASK BODY Cliente is;
    comprobante: Text;
begin
    SELECT
        Empleado.atencion(comp) do
            comprobante = comp;
            end;
        OR DELAY 10min do
            SELECT 
                Empleado.atencion(comp) do
                comprobante = comp;
                end;
            ELSE
                null;
            END SELECT;
    END SELECT;
    //se va.
END CLIENTE;        
            

## Ejercicio 3.
3. Se dispone de un sistema compuesto por
1 central y
2 procesos periféricos, que se
comunican continuamente. Se requiere modelar su funcionamiento considerando las
siguientes condiciones:
- La central siempre comienza su ejecución tomando una señal del proceso 1; luego
toma aleatoriamente señales de cualquiera de los dos indefinidamente. Al recibir una
señal de proceso 2, recibe señales del mismo proceso durante 3 minutos.
- Los procesos periféricos envían señales continuamente a la central. La señal del
proceso 1 será considerada vieja (se deshecha) si en 2 minutos no fue recibida. Si la
señal del proceso 2 no puede ser recibida inmediatamente, entonces espera 1 minuto y
vuelve a mandarla (no se deshecha).


PROCEDURE ejercicio3 is:

TASK Central;
    ENTRY señal1();
    ENTRY señal2();
    ENTRY avisar();

TASK Timer;
    ENTRY Iniciar(timeSegs in:integer);

TASK Periferico1;
TASK Periferico2;

TASK BODY Timer is
begin
    loop
        ACCEPT Iniciar(timeSegs in:integer);
        delay(timeSegs)
        Central.Avisar();

    end loop;
end;

TASK BODY Periferico1 is
begin
    loop
        SELECT
            Central.Señal1();
        OR DELAY 2min
            null
        END SELECT
    end loop;
end;

TASK BODY Periferico2 is
begin
    loop
        SELECT
            Central.Señal2()
        ELSE
            delay(60)
            Central.Señal2()
    end loop;
end;

TASK BODY Central is:
    fin:boolean = false;
BEGIN
    accept señal1();
    loop
        SELECT
            accept señal1() do
            end señal1;
            accept señal2() do
                fin=false;
                Timer.Iniciar(180);
                WHILE (not fin) loop
                    SELECT
                        WHEN (Aviso.count=0) ACCEPT señal2();
                    OR ACCEPT Aviso() do;
                        fin = true;
                END loop;
            end señal2;
        END SELECT
    end loop
END;


## Ejercicio 4
En una clínica existe un médico de guardia que recibe continuamente peticiones de
atención de las E enfermeras que trabajan en su piso y de las P personas que llegan a la clínica ser atendidos.
Cuando una persona necesita que la atiendan espera a lo sumo 5 minutos a que el médico lo
haga, si pasado ese tiempo no lo hace, espera 10 minutos y vuelve a requerir la atención del
médico. Si no es atendida tres veces, se enoja y se retira de la clínica.

Cuando una enfermera requiere la atención del médico, si este no lo atiende inmediatamente
le hace una nota y se la deja en el consultorio para que esta resuelva su pedido en el
momento que pueda (el pedido puede ser que el médico le firme algún papel). Cuando la
petición ha sido recibida por el médico o la nota ha sido dejada en el escritorio, continúa
trabajando y haciendo más peticiones.

El médico atiende los pedidos dándole prioridad a los enfermos que llegan para ser atendidos.
Cuando atiende un pedido, recibe la solicitud y la procesa durante un cierto tiempo. Cuando
está libre aprovecha a procesar las notas dejadas por las enfermeras.

1 medico
1 escritorio
E enfermeras
P Pacientes

Task Medico is
    ENTRY pedidoEnfermera()
    ENTRY atencion()

Task Escritorio is
    ENTRY pedidoEnfermera()
    ENTRY obtenerLosPedidos()

Task TYPE Enfermera;
Task TYPE Paciente;


Task BODY Medico is:
begin
    loop
        SELECT
            ACCEPT atencion() do
                //atender paciente;
            end atencion;
            OR WHEN (atencion.count()=0) ACCEPT pedidoEnfermera()
                //atiende pedido
                delay(60)
            end pedidoEnfermera;
        ElSE
            SELECT Escritorio.obtenerLosPedidos(notas)
                //procesa los pedidos
                procesar(notas)
                //delay(60)
            ELSE
                null;
            END SELECT
        END SELECT;
    END loop;
end;

Task BODY Escritorio is:
    notas: lista Text
begin
    loop
        SELECT 
            ACCEPT pedidoEnfermera(nota in:text) do
                notas.add(nota)
                cant++
            end pedidoEnfermera
        OR WHEN (NOT notas.vacia()) ACCEPT obtenerLosPedidos(notasDar out:list text) do
            notasDar=notas;
            notas.vaciar()
            end obtenerLosPedidos
        END SELECT
    end loop;
end Escritorio;

Task BODY Enfermera is:
begin
    loop
        SELECT 
            MEDICO.pedidoEnfermera();
        ELSE
            ESCTRITORIO.pedidoEnfermera("NOTA")
        END SELECT
    end loop
End Enfermera;


Task BODY Paciente is:
BEGIN
    SELECT
        Medico.Atencion()
    OR DELAY 5min
        SELECT
            Medico.Atencion()    
        OR DELAY 10min
            SELECT
                Medico.Atencion()    
            ELSE
                null
                //Se retira enojado.;
            END SELECT
        END SELECT
    END SELECT
End Paciente;



## Ejercicio 5
En un sistema para acreditar carreras universitarias, hay UN Servidor que atiende pedidos de U Usuarios, de a uno a la vez y de acuerdo con el orden en que se hacen los pedidos.
Cada usuario trabaja en el documento a presentar, y luego lo envía al servidor; espera la respuesta de este que le indica si está todo bien o hay algún error. 
Mientras haya algún error, vuelve a trabajar con el documento y a enviarlo al servidor. Cuando el servidor le responde que está todo bien, el usuario se retira.
Cuando un usuario envía un pedido espera a lo sumo 2 minutos a que sea recibido por el servidor, pasado ese tiempo espera un minuto y vuelve a intentarlo (usando el mismo documento)

1 servidor
U usuarios

Procedure Acreditaciones;
TASK Servidor is
    ENTRY presentarDoc(doc in:text, estaListo out:boolean);
end;

TASK TYPE Usuario;


TASK BODY Servidor
begin
    loop
        ACCEPT presentarDoc(doc in:text, estaListo out:boolean) do
            estaListo = revisarDocumento(doc);
        end presentarDoc;

        
    end loop
end

TASK BODY Usuario
    documento :text
begin
    fin=false;
    documento // lo prepara
    while(!fin) loop 
        SELECT
            Servidor.presentarDoc(documento, fin);
            if (!fin)
                documento = arreglarDocumento(documento)

        OR DELAY 120seg
            delay 60seg

        END SELECT;
    end loop
end