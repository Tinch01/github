1. En una estación de trenes, asisten P personas que deben realizar una carga de su tarjeta SUBE
en la terminal disponible. La terminal es utilizada en forma exclusiva por cada persona de acuerdo
con el orden de llegada. Implemente una solución utilizando únicamente procesos Persona. Nota:
la función UsarTerminal() le permite cargar la SUBE en la terminal disponible.
A)


Persona (0..P-1)

P(mutexL)
if (!Libre)
    P(mutexCola)
    cola.push(id)
    v(mutexCola)
    v(mutexL)
    P(turno[id])
    P(mutexL)
libre=false
v(mutexL)
//usarTerminal()
P(mutexCola)
if (cola.vacia()){
    P(mutexL)
    libre=true
    V(mutexL)
}else{
    V(turno[cola.pop()])
}
v(mutexCola)


Resolver los problemas siguientes:
a) En una estación de trenes, asisten P personas que deben realizar una carga de su tarjeta SUBE
en la terminal disponible. La terminal es utilizada en forma exclusiva por cada persona de acuerdo
con el orden de llegada. Implemente una solución utilizando únicamente procesos Persona. Nota:
la función UsarTerminal() le permite cargar la SUBE en la terminal disponible.
b) Resuelva el mismo problema anterior pero ahora considerando que hay T terminales disponibles.
Las personas realizan una única fila y la carga la realizan en la primera terminal que se libera.
Recuerde que sólo debe emplear procesos Persona. Nota: la función UsarTerminal(t) le permite
cargar la SUBE en la terminal t.




B)

Persona (id=0..P-1){
    P(mutexDispo)
    P(mutexCola)
    if (dispo.vacia() or (!colaEspera.vacia()){
        V(mutexDispo)
        colaEspera.push(id)
        v(mutexCola)
        P(turno[id])
    }
    P(mutexDispo)
    id_terminal=disponible.pop()
    V(mutexDispo)
    //usarTerminaL(id_terminal)
    P(mutexDispo)
    disponible.push(idTerminal)
    P(mutexCola)
    if (!colaEspera.vacia())
        v(turno[colaEspera.pop()])
    V(mutexCola)
    V(mutexDispo)
}





3) Implemente una solución para el siguiente problema. Se debe simular el uso de una máquina
expendedora de gaseosas con capacidad para 100 latas por parte de U usuarios. Además, existe un
repositor encargado de reponer las latas de la máquina. Los usuarios usan la máquina según el orden
de llegada. Cuando les toca usarla, sacan una lata y luego se retiran. En el caso de que la máquina se
quede sin latas, entonces le debe avisar al repositor para que cargue nuevamente la máquina en forma
completa. Luego de la recarga, saca una botella y se retira. Nota: maximizar la concurrencia; mientras
se reponen las latas se debe permitir que otros usuarios puedan agregarse a la fila.


Process Persona(id=0..U-1){
    P(mutex)
    if (!libre){
        cantidad++
        v(mutex)
        p(espera)
    }
    P(mutex)    
    libre=false
    cant--
    V(mutex)    

    if(latas=0){
        V(reponer)
        P(repuesto)
    }
    //tomarLAta
    latas--
    P(mutex)
    if (cantidad=0){
        libre=true
    }else{
        V(espera)
    }
    V(mutex)
}

Process Reponedor{
    while(true){
        P(reponer)
        V(repuesto)
    }
}



Monitores


1)Monitores
1) Resolver el siguiente problema. En una elección estudiantil, se utiliza una máquina para voto
electrónico. Existen N Personas que votan y una Autoridad de Mesa que les da acceso a la máquina
de acuerdo con el orden de llegada, aunque ancianos y embarazadas tienen prioridad sobre el resto.
La máquina de voto sólo puede ser usada por una persona a la vez.
Nota: la función Votar() permite
usar la máquina



process persona(0..N-1){
    acceso.llegar(id, edad, embarazo)
    //votar()
    acceso.retirarse()
}


process Autoridad(){
    for i = 1 to N{
        acceso.siguiente()
    }
}

Monitor Acceso{

Cola colaEspera
Cola colaEsperaPrioritaria
cond[N] turno
cond retirado, hayAlguien
boolean fin=false

procedure llegar(int id:in, int edad:in, boolean embarazo:in)
    if (edad>70 or embarazo){
        colaEsperaPrioritaria.push(id)
    }
    else{
        colaEspera.push(id)
    }
    signal(hayAlguien)
    wait(turno[id])

}

procedure siguiente(){
    if (colaEspera.vacia() AND colaEsperaPrioritaria.vacia()){
        wait(hayAlguien)
    }
    if (!colaEsperaPrioritaria.vacia()){
        signal(turno[colaEsperaPrioritaria.pop()])
    }else{
        signal(turno[colaEspera.pop()])
    }
    wait(retirado)
}

procedure retirarse(){
    signal(retirado)
}






process jurado{
    for i=1..C{
        P(llegar)
    }
    for i=0..C-1{
        recetas[i]=AsignarReceta()
    }
    for i=1..C{
        V(EMPEZAR)
    }

    for i = 1 to C{
        P(fin)
        P(mutexCola)
        actual = cola.pop()
        V(mutexCola)
        v(exhibir[actuak])
        p(finExhibir)
        nota[actual] = PensarNota()
        v(esperarNota[actual])
    }
    
}


process concursante (0..C-1){
    V(llegue)
    P(empezar)
    cocinar(recetas[id])
    //delay(random)
    P(mutexCola)
    cola.push(id)
    V(mutexCola)
    V(fin)
    P(exhibir[id])
    //lo exhibe
    V(finExhibir)
    P(esperarNota[id])
    int miNota=notas[id]


}