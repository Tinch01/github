link con otras respuestas, de otra persona, para revisar
https://www.notion.so/mbvstuff/Pr-ctica-de-Repaso-MD-2a3423c1987a80f880b5f826b643b803

link de guaymas:
https://github.com/MatiasGuaymas/PC/blob/main/Resoluciones/Practica-Repaso-MD.md

# Pasaje de mensajes
## Ejercicio 1
En una oficina existen 100 empleados que envían documentos para imprimir en 5 impresoras
compartidas. Los pedidos de impresión son procesados por orden de llegada y se asignan a la primera
impresora que se encuentre libre:
### a) Implemente un programa que permita resolver el problema anterior usando PMA.

chan imprimir(documento, idE)
chan[100] impresiones(impresion)

process empleado(idE=1..100){
    while(true)
        documento = generarDocumento()
        send imprimir(documento, idE)
        recibir impresiones[idE](impresion)
}   

process Impresora(idImp=1..5){
    while(true)
        recieve imprimir(documento,idE)
        impresion = imprimir(documento)
        send impresiones[idE](impresion)
}




### ) Resuelva el mismo problema anterior pero ahora usando PMS



process empleado(idE=1..100){
    while(true)
        documento = generarDocumento()
        COORDINADOR!imprimir(documento, idE)
        IMPRESORA[*]?impresion(impresion)
}   
process coordinador{
    colaPedidos = new Cola()
    while(true){
        if (not colaPedidos.vacia()); IMPRESORA[*]?pedidoSiguiente(idImp) ->
            IMPRESORA[idImp]!siguiente(cola.pop())
        []  EMPLEADO[*]?imprimir(documento, idE) -> 
            colaPedidos.push((documento, idE))
        
    }
}

process Impresora(idImp=1..5){
    while(true)
        COORDINADOR!pedidoSiguiente(idImp)
        COORDINADOR?siguiente(documento,idE)
        impresion = imprimir(documento)
        EMPLEADO[idE]!impresion(impresion)
}






## Ejercicio 2

Resolver el siguiente problema con PMS.
En la estación de trenes hay una terminal de SUBE que debe ser usada por P personas de acuerdo con el orden de llegada.
Cuando la persona accede a la terminal, la usa y luego se retira para dejar al siguiente. Nota: cada Persona usa sólo una vez la terminal

process persona(idP=1...P){
    TERMINAL!usar(idP)
    TERMINAL?turno()
    //usarla
    TERMINAL!finUso()
}

process TERMINAL {
    colaEspera = new Cola
    boolean libre= true
    for i = 1..P {
        if PERSONA[*]?usar(idP) ->
            if (libre){
                libre=false
                PERSONA[idP]!turno()
            }else{
                colaEspera.push(idP)
            }
        [] PERSONA[*]?finUso(){
            if (colaEspera.vacia()){
                libre=true
            }else{
                PERSONA[colaEspera.pop()]!turno()
            }
        }
    }
}
 o si no asi:
 
process TERMINAL {
    colaEspera = new Cola
    boolean libre= true
    for i = 1..P {
        if (libre); PERSONA[*]?usar(idP) ->
                libre=false
                PERSONA[idP]!turno()
        []  (not libre); PERSONA[*]?usar(idP) ->
                colaEspera.push(idP)
        [] (colaEspera.vacia())PERSONA[*]?finUso()
                libre=true
        [] (not colaEspera.vacia())PERSONA[*]?finUso()
                PERSONA[colaEspera.pop()]!turno()
        }
    }

Segun el chat ambas son equivalentes, la diferencia es solamente la expresividad de cada condicion puntual para cada mensaje que pueda recibirse, marcandose ahi la diferencia de que parece mas explicito, y el otro parece mas imperativo, nada mas.


Resolver el siguiente problema con PMS.
En la estación de trenes hay una terminal de SUBE que debe ser usada por P personas de acuerdo con el orden de llegada.
Cuando la persona accede a la terminal, la usa y luego se retira para dejar al siguiente. Nota: cada Persona usa sólo una vez la terminal

process persona(idP=1...P){
    TERMINAL!usar(idP)
    TERMINAL?turno()
    //usarla
    TERMINAL!finUso()
}

process TERMINAL {
    colaEspera = new Cola
    boolean libre= true
    for i = 1..P {
        if PERSONA[*]?usar(idP) ->
            if (libre){
                libre=false
                PERSONA[idP]!turno()
            }else{
                colaEspera.push(idP)
            }
        [] PERSONA[*]?finUso(){
            if (colaEspera.vacia()){
                libre=true
            }else{
                PERSONA[colaEspera.pop()]!turno()
            }
        }
    }
}
 o si no asi:
 
process TERMINAL {
    colaEspera = new Cola
    boolean libre= true
    for i = 1..P {
        if (libre); PERSONA[*]?usar(idP) ->
                libre=false
                PERSONA[idP]!turno()
        []  (not libre); PERSONA[*]?usar(idP) ->
                colaEspera.push(idP)
        [] (colaEspera.vacia())PERSONA[*]?finUso()
                libre=true
        [] (not colaEspera.vacia())PERSONA[*]?finUso()
                PERSONA[colaEspera.pop()]!turno()
        }
    }

Segun el chat ambas son equivalentes, la diferencia es solamente la expresividad de cada condicion puntual para cada mensaje que pueda recibirse, marcandose ahi la diferencia de que parece mas explicito, y el otro parece mas imperativo, nada mas.

## Ejercicio 3

Resolver el siguiente problema con PMA. En un negocio de cobros digitales hay P personas que deben pasar por la única caja de cobros para realizar el pago de sus boletas.
Las personas son atendidas de acuerdo con el orden de llegada, teniendo prioridad aquellos que deben pagar menos de 5 boletas de los que pagan más.
Adicionalmente, las personas embarazadas tienen prioridad sobre los dos casos anteriores. 
Las personas entregan sus boletas al cajero y el dinero de pago; el cajero les devuelve el vuelto y los recibos de pago.


process Persona(idP=1..P){
    List<Boleta> boletas = //tiene sus boletas
    boolean isEmbarazada = //si lo está o no
    if (isEmbarazada){
        send colaEmbarazada(idP)
    }else if (boletas.cant<5){
        send colaRapida(idP)
    }else{ send colaNormal(idP)}
    send llegada()
    recieve turno[idP]()
    send pagar(boletas,dinero)
    recieve vuelto[idP](cambio)
}


process Caja{
    while true(){
        receive llegada()
        if (not empty(colaEmbarazada)) ->
            recieve colaEmbarazada(idP)
        [] (empty(colaEmbarazada) && (not empty(colaRapida))) ->
            recieve colaRapida(idP)
        [] (empty(colaEmbarazada) && (empty(colaRapida) ) && (not empty(colaNormal))) ->
            recieve colaNormal(idP)
        send turno[idP]()
        recieve pagar(boletas, dinero)
        vuelto = cobrarBoletas(boletas, dinero)
        send  vueltp[idP](vuelto)
    }

}
Resolver el siguiente problema con PMA. En un negocio de cobros digitales hay P personas que deben pasar por la única caja de cobros para realizar el pago de sus boletas.
Las personas son atendidas de acuerdo con el orden de llegada, teniendo prioridad aquellos que deben pagar menos de 5 boletas de los que pagan más.
Adicionalmente, las personas embarazadas tienen prioridad sobre los dos casos anteriores. 
Las personas entregan sus boletas al cajero y el dinero de pago; el cajero les devuelve el vuelto y los recibos de pago.


process Persona(idP=1..P){
    List<Boleta> boletas = //tiene sus boletas
    boolean isEmbarazada = //si lo está o no
    if (isEmbarazada){
        send colaEmbarazada(idP)
    }else if (boletas.cant<5){
        send colaRapida(idP)
    }else{ send colaNormal(idP)}
    send llegada()
    recieve turno[idP]()
    send pagar(boletas,dinero)
    recieve vuelto[idP](cambio)
}


process Caja{
    while true(){
        receive llegada()
        if (not empty(colaEmbarazada)) ->
            recieve colaEmbarazada(idP)
        [] (empty(colaEmbarazada) && (not empty(colaRapida))) ->
            recieve colaRapida(idP)
        [] (empty(colaEmbarazada) && (empty(colaRapida) ) && (not empty(colaNormal))) ->
            recieve colaNormal(idP)
        send turno[idP]()
        recieve pagar(boletas, dinero)
        vuelto = cobrarBoletas(boletas, dinero)
        send  vueltp[idP](vuelto)
    }

}

# Ada
## Ejercicio 1
Resolver el siguiente problema. La página web del Banco Central exhibe las diferentes cotizaciones 
del dólar oficial de 20 bancos del país, tanto para la compra como para la venta. 
Existe una tarea programada que se ocupa de actualizar la página en forma periódica y para ello consulta la cotización de cada uno de los 20 bancos.
Cada banco dispone de una API, cuya única función es procesar las solicitudes de aplicaciones externas.
La tarea programada consulta de a una API por vez, esperando a lo sumo 5 segundos por su respuesta.
Si pasado ese tiempo no respondió, entonces se mostrará vacía la información de ese banco.



process BancoCentral is:

TASK Consultar;

TASK type ApiBanco is
    ENTRY cotizacionDiaria(dolarCompra out:real,dolarVenta out:real)
end;

arrApiBanco[20]: array of ApiBanco

TASK BODY Consultar is:
    arrCotizacionesCompra[20]:array of real;
    arrCotizacionesVenta[20]: array of real;
begin
    for (i=1..20) loop
        SELECT
            arrApiBanco[i].cotizacionDiaria(dolarCompra, dolarVenta);
                arrCotizacionesCompra[i]=dolarCompra
                arrCotizacionesVenta [i]=dolarVenta

            OR DELAY (5min)
                arrCotizacionesCompra[i]=   -1
                arrCotizacionesVenta [i]=   -1
        END SELECT
    end loop
    //actualiza la pagina con los valores obtenidos
end ApiBanco


TASK BODY ApiBanco is:
    valorCompra : real
    valorVenta : real
begin
    valorCompra = cargarValorCompra()
    valorVenta = cargarValorVenta()
    while(true) {
        ACCEPT cotizacionDiaria(dolarCompra out:real, dolarVenta out:real) do
            dolarCompra = valorCompra
            dolarVenta = valorVenta
        end cotizacionDiaria;
    }
end apiBanco

begin 
    null
end BancoCentral;



## Ejercicio 2

Resolver el siguiente problema. En un negocio de cobros digitales hay P personas que deben pasar por la única caja de cobros para realizar el pago de sus boletas.
Las personas son atendidas de acuerdo con el orden de llegada, teniendo prioridad aquellos que deben pagar menos de 5 boletas de los que pagan más.
Adicionalmente, las personas ancianas tienen prioridad sobre los dos casos anteriores.
Las personas entregan sus boletas al cajero y el dinero de pago; el cajero les devuelve el vuelto y los recibos de pago.

TASK Cajero is 
    ENTRY atencionAnciano(boletas in:List<Boleta>, dinero in:real, vuelto out:real, recibo out:Recibo);
    ENTRY atencionRapida(boletas in:List<Boleta>, dinero in:real, vuelto out:real, recibo out:Recibo);
    ENTRY atencionNormal(boletas in:List<Boleta>, dinero in:real, vuelto out:real, recibo out:Recibo);
end;

TASK TYPE Persona;

TASK BODY Cajero is:
Begin
    for (i =1..P) loop
    SELECT
        ACCEPT atencionAnciano(boletas in:List<Boleta>, dinero in:real, vuelto out:real, recibo out:Recibo) do
            //cobrarle las boletas
            vuelto = cobrar(boletas, dinero)
            recibo = emitirRecibo(boletas, dinero, vuelto)
        end atencionAnciano;            

        WHEN (atencionAnciano'count =0); ACCEPT atencionRapida(boletas in:List<Boleta>, dinero in:real, vuelto out:real, recibo out:Recibo) do
            //cobrarle las boletas
            vuelto = cobrar(boletas, dinero)
            recibo = emitirRecibo(boletas, dinero, vuelto)
        end atencionRapida;            

        WHEN (atencionAnciano'count =0 && atencionRapida'count =0);  ACCEPT atencionNormal(boletas in:List<Boleta>, dinero in:real, vuelto out:real, recibo out:Recibo) do 
            //cobrarle las boletas
            vuelto = cobrar(boletas, dinero)
            recibo = emitirRecibo(boletas, dinero, vuelto)
        end atencionNormal;            
    END SELECT
    end loop
end Cajero;






TASK BODY Persona is:
    List<Boleta> boletas = prepararBoletas()
    real dinero = prepararDinero()
    boolean isAnciano = //lo sabe
begin
    if (isAnciano)
        Cajero.atencionAnciano(boletas, dinero, vuelto, recibo);
    else (if (boletas.count()<5))
        Cajero.atencionAnciano(boletas, dinero, vuelto, recibo);
    else 
        Cajero.atencionNormal(boletas, dinero, vuelto, recibo);
    end if;
end Persona;






## Ejercicio 3

Resolver el siguiente problema.
La oficina central de una empresa de venta de indumentaria debe calcular cuántas veces fue vendido cada uno de los artículos de su catálogo. 
La empresa se compone de 100 sucursales y cada una de ellas maneja su propia base de datos de ventas.
La oficina central cuenta con una herramienta que funciona de la siguiente manera: ante la consulta realizada para un artículo determinado, la herramienta envía el identificador del artículo a las sucursales, para que cada una calcule cuántas veces fue vendido en ella. Al final del procesamiento, la herramienta debe conocer cuántas veces fue vendido en total, considerando todas las sucursales. Cuando ha terminado de procesar un artículo comienza con el siguiente (suponga que la herramienta tiene una función generarArtículo() que retorna el siguiente ID a consultar).

 Nota: maximizar la concurrencia. Existe una función ObtenerVentas(ID) que retorna la cantidad de veces que fue vendido el artículo con identificador ID en la base de la sucursal que la llama.

TASK OficinaCentral is
    ENTRY informarCantVentas(cant in:integer)
end;

TASK TYPE Sucursal is
    ENTRY pedirCantVentas(idArticulo in:integer)
end;

arrSucursales[1..100]:array of Sucursal;

TASK BODY OficinaCentral is:
    idActual :integer
begin
    idActual = generarArticulo()
    while (idActual<>-1) loop;
        for (i=1..100) loop
            arrSucursales[i].pedirCantVentas(idActual);
        end loop;
        for (i=1..100) loop
            ACCEPT informarCantVentas(cant in:integer) do
                total=total+cant
            end informarCantVentas;
        end loop;
        //informa en pantalla con print() la cantidad del articulo actual

        //pasa al siguiente articulo.
        idActual = generarArticulo()
    end loop
end;

TASK BODY Sucursal is
    cant: integer;
    idAct:integer
begin
    while (true) loop
        ACCEPT pedirCantVentas(idArticulo in:integer) do
            idAct= idArticulo;
        end pedirCantVentas;

        //se dispone de la funcion:
        cant = obtenerVentas(idArticulo) //demoraria el tiempo que tarda en contar en su bd.
        OficinaCentral.informarCantVentas(cant)
    end loop;
end Sucursal



## o la supuesta mejor version, pero tienen que estar las sucursales siempre pidiendo un ID.




TASK OficinaCentral is
    ENTRY pedirID(idArticulo out:integer)
    ENTRY informarCantVentas(cant in:integer)
end;

TASK TYPE Sucursal is
end;

arrSucursales[1..100]:array of Sucursal;

TASK BODY OficinaCentral is:
    idActual :integer
begin
    idActual = generarArticulo()
    while (idActual<>-1) loop;
        total=0
        for (i=1..200) loop
        SELECT 
            ACCEPT pedirId(idArticulo out:integer) do
                idArticulo = idActual;
                end pedirId;
            OR ACCEPT informarCantVentas(cant in:integer) do
                total=total+cant;
                end informarCantVentas;
        END SELECT
        end loop;
        //informa en pantalla con print() la cantidad del articulo actual
        idActual = generarArticulo()       //pasa al siguiente articulo.
     end loop
end;

TASK BODY Sucursal is
    cant: integer;
    idAct:integer
begin
    while (true) loop
        OficinaCentral.PedirID(idAct);
        //se dispone de la funcion:
        cant = obtenerVentas(idArticulo) //demoraria el tiempo que tarda en contar en su bd.
        OficinaCentral.informarCantVentas(cant)
    end loop;
end Sucursal

