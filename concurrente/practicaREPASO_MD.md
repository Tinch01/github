link con otras respuestas, de otra persona, para revisar
https://www.notion.so/mbvstuff/Pr-ctica-de-Repaso-MD-2a3423c1987a80f880b5f826b643b803

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

TASK BODY Consultar is:
    arrApiBanco[20]: array of ApiBanco
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
## Ejercicio 2
## Ejercicio 3