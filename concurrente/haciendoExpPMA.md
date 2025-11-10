## Ejercicio 1
chan errores;
Process Persona
    while truee
        encontrar error
        send errores(error)

Process Empleado
    while (true)
        recieve errores(error)
        //..solucionar(error)

## Ejercicio 2

Process Persona(idP: 1..P)
    while(true)
        encontrar error
        send reportes(error, idP)
        receive respuestas[idP](respuesta)

Process Empleado 
    while(true)
        receive reportes(reporte, idP)
        // solucion = soluciona reporte
        send respuestas[idP](solucion)

## Ejercicio 3
Ahora son 3 los empleados que atienden reportes

Process Persona(idP: 1..P)
    while(true)
        encontrar error
        send reportes(error, idP)
        receive respuestas[idP](respuesta)

Process Empleado (idE: 1..3)
    while(true)
        receive reportes(reporte, idP)
        // solucion = soluciona reporte
        send respuestas[idP](solucion)

## Ejercicio 4
N personas prueban software, generan reportes de erorres.
Las personas no esperan ninguna respuesta
Los empleados los resuelven. No tienen que responder nada
Cuando no hay reportes para atender, el empleado se dedica a leer 10 min

Process Persona(idP: 1..P)
while TRUE:
    error = encontrarError
    send reportes(error)

Process Empleado
while TRUE
    if empty(reportes)
        //leyendo
        delay(10min)
    else
        receive reportes (error)
        //solucionar error


## Ejercicio 5
Lo mismo que el 4, pero ahora, hay 3 empleados.


Process Persona(idP: 1..P)
while TRUE:
    error = encontrarError
    send reportes(error)

Process Empleado
while TRUE
    send pedido(idE)
    recibir siguienteRes[idE](sigError)
    if sigError="LEER"
        //leyendo
        delay(10min)
    else
        //solucionar error
        solucionar (sigError)

Process Coordinador
while true
    receive pedido(idE)
    if empty(reportes)
        sigError = "LEER"
    else
        recieve reportes(error)
        sigError = error
    send siguienteRes[idE](sigError)
