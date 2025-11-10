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
## Ejercicio 3


# Ada
## Ejercicio 1
## Ejercicio 2
## Ejercicio 3