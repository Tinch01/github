8: Una fábrica de piezas metálicas debe producir T piezas por día. Para eso, cuenta con E empleados que se ocupan de producir las piezas de a una por vez. La fábrica empieza a producir una vez que todos los empleados llegaron. Mientras haya piezas por fabricar, los empleados tomarán una y la realizarán. Cada empleado puede tardar distinto tiempo en fabricar una pieza. Al finalizar el día, se debe conocer cual es el empleado que más piezas fabricó.
a) Implemente una solución asumiendo que T > E.
b) Implemente una solución que contemple cualquier valor de T y E

int T piezasXdia
int P piezasHechas=0
sem mutexCantEmpt = 1
sem mutexPiezas = 1
sem mutexMax = 1
max= -1
idMax =-1
process Empleado (id: 0..E-1)
    int misPiezas = 0
    P(mutexCantEmpt)
    cantEmp++
    if (cantEmp = E)
        for (1= 1..E) do:
            V(barrera)
    V (mutexCantEmpt)
    P (barrera)

    P(mutexPiezas)
    while (piezasHechas < T) do{
        piezasHechas++ //toma la pieza
        V(mutexPiezas)
        delay(random)  //realiza pieza
        misPiezas++
        P(mutexPiezas)
    }
    V(mutexPiezas)
    
    P(mutexMax)
    if (misPiezas > max)
        idMax = id
        max = miesPiezas
    V(mutexMax)





9: 

sem capacidadMarcos = 30
sem disponibilidadMarcos = 0

sem capacidadVidrios = 50
sem disponibilidadVidrios = 0


sem mutexMarco, mutexVidrio, mutexVentana = 1
Cola colaVentana, colaVidrio, colaVentana

process carpintero(id = 0..3){
    while true:
        P(capacidadMarcos)
        Marco = new Marco()
        P(mutexMarco)
        colaMarcos.push(marco)
        V(mutexMarco)
        V(disponibilidadMarcos)
    
}
process vidriero(){
    while true:
        P(capacidadVidrios)
        Vidrio vidrio = new Vidrio()
        P(mutexVidrio)
        colaVidrios.push(vidrio)
        V(mutexVidrio)
        V(disponibilidadVidrios)
    
}
process armador(id = 0..1){
    while true:
        P(disponibilidadMarcos)
        P(mutexMarco)
        marco = ColaMarco.pop()
        V(mutexMarco)
        V(capacidadMarcos)

        P(disponibilidadVidrios)
        P(mutexVidrio)
        vidrio = colaVidrios.pop()
        V(mutexVidrio)
        V(capacidadVidrios)

        ventana = new Ventana(marco, vidrio)
        P(mutexVentana)
        colaVentana.push(ventana)
        V(mutexVentana)
}



10) A una cerealera van T camiones a descargarse trigo y M camiones a descargar maíz. Sólo hay lugar para que 7 camiones a la vez descarguen, pero no pueden ser más de 5 del mismo tipo de cereal.
a) Implemente una solución que use un proceso extra que actúe como coordinador entre los camiones. El coordinador debe atender a los camiones según el orden de llegada. Además, debe retirarse cuando todos los camiones han descargado.
>>> Dice NO HACER.
Pero bueno lo hice como pude

T cam trigo
M cam maiz

sem llegada = 0
sem lugarLibre=7
sem lugarTrigo=5
sem lugarMaiz=5
Cola<Camion> colaCamion;


Coordinador {
    while(true)
        P (llegada)
        P(mutexCola)
        camion = cola.pop()
        V(mutexCola)
        if (camion.tipo = "Maiz")
            P(lugarMaiz)
        elif (camion.tipo = "Trigo")
            P(lugarTrigo)
        P(lugarLibre)
        V(descargar)
       
        
}

Camion (id=0..T-1){
    tipo = //maiz / trigo
    P(mutexCola)
    cola.push(id, tipo)
    V(mutexCola)
    V(llegada)
    P(descargar)
    //hace la descarga
    //se va
    if (tipo = "Maiz")
        V(lugarMaiz)
    elif (tipo = "Trigo")
        V(lugarTrigo)
    V (lugarMaiz)
    V(lugarLibre)

}







b) Implemente una solución que no use procesos adicionales (sólo camiones).
 No importa el orden de llegada para descargar. Nota: maximice la concurrencia.


T cam trigo
M cam maiz

sem llegada = 0
sem lugarLibre=7
sem lugarTrigo=5
sem lugarMaiz=5



process CamionMAIZ {
    P(lugarMAIZ)
    P(lugarLibre)
    //hace descarga
    V(lugarLibre)
    V(lugarMAIZ)
}

process CamionTRIGO {
    P(lugarTRIGO)
    P(lugarLibre)
    //hace descarga
    V(lugarLibre)
    V(lugarTRIGO)


}