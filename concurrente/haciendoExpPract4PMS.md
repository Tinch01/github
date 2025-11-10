## Ejercicio 1

Empresa software
empleado TESTEO que prueba un software, si encuentra errores hace reportes para que otro empleado MANTENIMIENTO lo corrija y le responda
Manteninimento toma los reportes, loes evalua corrije y repsonde a empleado TESTEO.

process TESTEO {
    while (true)
        error = probar()
        MANTEMINIMIENTO.!reportar(error)
        MANTENIMIENTO.?respuesta(respuesta)
}

process MANTENIMIENTO {
    while (true){
        TESTEO.?reportar(error)
        respuesta = evaluar(error)
        TESTEO.!respuesta(respuesta)
    }
}

## Ejercicio 2
Igual que el anterior, pero ahora TESTEO no requiere una respuesta para seguir trabajando.
No hay respuesta.

process TESTEO {
    while (true)
        error = probar()
        MANTEMINIMIENTO.!reportar(error)
}

process MANTENIMIENTO {
    while (true){
        TESTEO.?reportar(error)
         //correjir(error)
    }
}


Asi ya estaría, el tema es que los procesos deben esperar a que "llegue" su reporte para poder continuar.
Implemento solución con buffer, asi pueden enviar reportes y seguir, en algun momennto el mantenimiento lo procesará, y no hace falta esperarlo. 

process TESTEO {
    while (true)
        error = probar()
        BUFFER.!reportar(error)
}

process BUFFER{
    colaReportes;
    while(true){
        if TESTEO.?reportar(error) ->
            colaReportes.push(error)

        [] (not colaReportes.vacia()); MANTENIMIENTO.?pedirReporte() ->
            error = colaReportes.pop()
            MANTEMINIENTO.!siguienteReporte(error) 
    }
}

process MANTENIMIENTO {
    while (true){
        BUFFER.!pedirReporte()
        BUFFER.?siguienteReporte(error)
         //correjir(error)
    }
}

## Ejercicio 3

Ahora son N empleados TESTEO, 1 MANTENIMIENTO.
Los testeo reciben respuesta del mantemiento
El * (comodin) es una sintesis de una guarda sobre el vector de procesos TESTEO. Pero no sigue un orden.
Para mantener un orden debo usar un proceso intermediario


### VARIANTE que el admin solo maneja el orden(ADMIN no guarda el reporte)

process TESTEO(idT=1..N){
    while(true){
        error = probar()
        ADMIN.!encolarse(idT)
        MANTENIMIENTO.?turno()
        MANTENIMIENTO.!reporte(error)
        MANTENIMIENTO.?respuesta(respuesta)
    }
}

process ADMIN(){
    colaTesters;
    while(true)
        if TESTEO[*].?encolarse(idT) ->
            colaTesters.push(idT)
        [] (not colaTesters.vacia()); MANTENIMIENTO.?pedirSiguiente() ->
            MANTENIMIENTO.!siguiente(colaTesters.pop());
}
process MANTENIMIENTO(){
    while(true){
        ADMIN.!pedirSiguiente()
        ADMIN.?siguiente(idT)
        TESTEO[idT].!turno()
        TESTEO[idT].?reporte(error)
        respuesta = procesarError()
        TESTEO[idT].!respuesta(respuesta)

    }
}




### VARIANTE de la explicacion practica (el admin SI guarda el reporte ademas del orden)
process TESTEO(idT=1..N){
    while(true){
        error = probar()
        ADMIN.!reporte(error,idT)
        MANTENIMIENTO.?respuesta(respuesta)
    }
}

process ADMIN(){
    colaTesters;
    while(true)
        if TESTEO[*].?reporte(error, idT) ->
            colaTesters.push((error, idT))
        [] (not colaTesters.vacia()); MANTENIMIENTO.?pedirSiguiente() ->
            MANTENIMIENTO.!siguiente(colaTesters.pop());
}

process MANTENIMIENTO(){
    while(true){
        ADMIN.!pedirSiguiente()
        ADMIN.?siguiente((error,idT))
        respuesta = procesarError(error)
        TESTEO[idT].!respuesta(respuesta)
    }

}



## Ejercicio 4
N empleados TESTEO
3 empleados MANTEMIENTO
Orden llegada
Responder a quien hizo el reporte


process TESTEO(idT: 1..N){
    while(true)
        error = probar()
        ADMIN!reporte(error,idT)
        MANTENIMIENTO[*]?respuesta(respuesta)
}

process MANTENIMIENTO(idM: 1..3){
    while(true)
        ADMIN!.pedirSiguiente(idM)
        ADMIN?.siguiente((reporte,idT))
        respuesta = resolver(error)
        TESTEO[idT]!respuesta(respuesta)
}

process ADMIN{
    colaReportes;
    while(true){
        if TESTEO[*]?.reporte(error,idT)->
            colaReportes.push( (error, idT) )
        [] (not colaReportes.vacia())  MANTENIMIENTO[*]?.pedirSiguiente(idM) ->
            MANTENIMIENTO[idM]!siguiente(colaReportes.pop())
    }

}