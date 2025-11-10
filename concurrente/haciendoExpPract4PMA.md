Voy haciendo los ejercicios sobre la marcha antes de ver su resolucion en el video:

Ejercicio1:
hay N personas que prueban producto para encontrar errores, generan reportes para que el empleado corrija el error(las personas no reciben respeusta)
El empleado toma los reportes por orden de llegada, los evalua y arregla.


Persona (n){
    while(true){
        prueba app
        send reportes(error)
    }
}

Empleado(){
    while(true){
        receive reportes(error)
        //analizar error
        // resolver(error)
    }
}

Ahora con la modificacion para que las personas esperen la respuesta del empleado una vez que lo haya arreglado.



Persona (n){
    while(true){
        prueba app
        send reportes(error, id)
        receive respuesta[id](rta)
    }
}

Empleado(){
    while(true){
        receive reportes(error, idP)
        //analizar error
        // resolver(error)
        textoRespuesta = generarRespuesta()
        send respuesta[idP](textoRespuesta)

    }
}


Ahora la modificacion es que haya 3 empleados trabajando y recibiendo reportes.


Persona (id: 0..N-1){
    while(true){
        prueba app
        send reportes(error, id)
        receive respuesta[id](rta)
    }
}

Empleado(id: 0..2){
    while(true){
        receive reportes(error, idP)
        //analizar error
        // resolver(error)
        textoRespuesta = generarRespuesta()
        send respuesta[idP](textoRespuesta)

    }
}

Ejercicio 4:
hay N personas que prueban producto para encontrar errores, generan reportes para que el empleado corrija el error(las personas no reciben respeusta)
El empleado toma los reportes por orden de llegada, los evalua y arregla.
Si no hay reportes para atender... Se toma 10 minutos para leer.


Persona (id: 0..N-1){
    while(true){
        prueba app
        send reportes(error, id)
    }
}

Empleado(){
    while(true){
        if (empty(reportes))
            delay(10 min)
        else{
            receive reportes(error, idP)
            //analizar error
            // resolver(error)
        }

    }
}


Ejercicio 5: lo mismo que el 4 pero son 3 los empleados.



Persona (id: 0..N-1){
    while(true){
        prueba app
        send reportes(error, id)
    }
}

Empleado(idE: 0..2){
    while(true){
        send(pedido(idE))
        receive siguiente[idE](sig)
        if (sig = -1 )
            delay(600)
        else{
            receive reportes(error)
            //resolver (error)
        }

    }
}

Empleado coordinador(){
    
    while(true){
        receive pedido(idE)
        if (! empty reportes)
            signal siguiente[idE](1)
        else
            signal siguiente[idE](-1)
    }
}

