## Ejercicio 1
Suponga que N clientes llegan a la cola de un banco y que serán atendidos por sus
empleados. Analice el problema y defina qué procesos, recursos y canales/comunicaciones
serán necesarios/convenientes para resolverlo. Luego, resuelva considerando las siguientes
situaciones:
a. Existe un único empleado, el cual atiende por orden de llegada.
b. Ídem a) pero considerando que hay 2 empleados para atender, ¿qué debe
modificarse en la solución anterior?
c. Ídem b) pero considerando que, si no hay clientes para atender, los empleados
realizan tareas administrativas durante 15 minutos. ¿Se puede resolver sin usar
procesos adicionales? ¿Qué consecuencias implicaría)




process Cliente(id=1..N){
    send llegada(id)
    receive atencion[id]();
}

process Empleado(){
    while true {
        recieve llegada(idCli)
        send atencion[idCli]()
        //lo atiende
    }
}


B)

process Cliente(id=1..N){
    send llegada(id)
    receive atencion[id]();
}

process Empleado(idE=1..2){
    while true {
        recieve llegada(idCli)
        send atencion[idCli]()
        //lo atiende
    }
}


C)
Si se puede realizar sin procesos adicionales, pero puede haber bloqueos invalidos o innecesarios, en los que mas de un Empleado, por preguntar si hay Clientes, a la vez reciban respuesta afirmativa, pero se queden bloqueados en el correspondiente Receive de ese cliente.
Por eso es mejor implementar un proceso que haga de intermediario para darle a los Empleados los pedidos cuando los haya.

process Cliente(id=1..N){
    send llegada(id)
    receive atencion[id]();
}

process Coordinador {
    while (true){
        receive pedido(idE)
        if empty (llegada){
            sig=-1
        } else{
            receive llegada(idC)
            sig=idC
        }
        send siguiente[idE](sig)
    }
}

process Empleado(idE=1..2){
    while true {
        send pedido(idE)
        recieve siguiente[idE](idCli)
        if (idCli=-1)
            //tareas administrativas
            delay(15min)
        else
            send atencion[idCli]()
            //lo atiende
    }
}


## Ejercicio 2

Se desea modelar el funcionamiento de un banco en el cual existen 5 cajas para realizar pagos.
Existen P clientes que desean hacer un pago. Para esto, cada una selecciona la caja donde hay menos personas esperando; una vez seleccionada, espera a ser atendido.
En cada caja, los clientes son atendidos por orden de llegada por los cajeros. 
Luego del pago, se les entrega un comprobante. Nota: maximizar la concurrencia

process Persona(idP=1..P){
    send llegada(idP)
    send despertar()
    receive cajas[idP](idCaja)
    send espera[idCaja](idP)
    receive atencion[idP]()
    send pagar[idcaja]("PAGO")
    receive comprobante[idCaja](comprobante)
    send despertar()
    //se retira.
}
process BANCO{
    filas :integer[] = (5, 0)
    while true{
        receive(despertar)
        if (not empty  (llegada)) && (empty (finAtencion)){
            receive llegada(idP)
            idmin = min(filas[])
            fila[idMin]++
            send cajas[idP](idMin)
        }
        [] (not empty (finAtencion())){
            receive finAtencion(idCaja)
            fila[idCaja]--
        }
    }        

}


process CAJA (idCaja= 1..5){
    while (true)
        receive espera[idCaja](idP)
        send atencion[idP]
        receive pago[idCaja](pago)
        comprobante = procesarPago(pago)
        send comprobante[idP](comprobante)
        send finAtencion(idCaja)
}

## Ejercicio 3

3. Se debe modelar el funcionamiento de una casa de comida rápida, en la cual trabajan 2
cocineros y 3 vendedores, y que debe atender a C clientes. El modelado debe considerar
que:
- Cada cliente realiza un pedido y luego espera a que se lo entreguen.
- Los pedidos que hacen los clientes son tomados por cualquiera de los vendedores y se
lo pasan a los cocineros para que realicen el plato. Cuando no hay pedidos para atender,
los vendedores aprovechan para reponer un pack de bebidas de la heladera (tardan entre
1 y 3 minutos para hacer esto).
- Repetidamente cada cocinero toma un pedido pendiente dejado por los vendedores, lo
cocina y se lo entrega directamente al cliente correspondiente.
Nota: maximizar la concurrencia

process Persona(idP=1..P){
    send llegada(idP)
    receive atencion[idP](idV)
    send Pedido[idV]("pedido")    
    receive entrega[idP](comida)
}


process Coordinador{
    while (true){
        recieve siguiente(idV)
        if (empty(llegada))
            sig = "REPONER"
        else{
            receive llegada(idP)
            sig = idP
        }
        send queHacer[idV](sig)
    }
}
process Vendedor(idV=1..3){
    while (true){
        send siguiente(idV)
        recieve queHacer[idV](sig)
        if (sig = "REPONER"){
            //repone bebidas
            delay(random(1,3)*60)
        } else{
            send atencion[idP](idV)
            recieve pedido[idV](pedido)
            send orden(idP,pedido)
        }
    }
}


process Cocinero(idC=1..2){
    while (true)
        recieve orden(idP,pedido)
        comida = prepararPedido(pedido)
        send entrega[idP], (comida)
}

## Ejercicio 4

Simular la atención en un locutorio con 10 cabinas telefónicas, el cual tiene un empleado
que se encarga de atender a N clientes. Al llegar, cada cliente espera hasta que el empleado
le indique a qué cabina ir, la usa y luego se dirige al empleado para pagarle. El empleado
atiende a los clientes en el orden en que hacen los pedidos. A cada cliente se le entrega un
ticket factura por la operación.
a) Implemente una solución para el problema descrito.

process Persona(idP=1..P){
    send pedirCabina(idP)
    send despertar()
    recibe indicarCabina[idP](idCabina)
    //la usa
    send finUsoCabina(idP,idCabina)
    send despertar(idP)
    recieve cobro[idP](ticket)
}

process Empleado(){
    colaCabinasLibres: Cola<Integer>
    cola = (1..10)
    while (true){
        recieve despertar()
        if not (empty (pedirCabina))
            if (cola.vacia()){
                receive finUsoCabina(idP, idCabina)
                colaCabinasLibres.push(idCabina)
                ticket = Cobrar(idCabina)
                send cobro[idP](ticket)
            }
            else{
                recieve pedirCabina(idP)
                idCabina = colaCabinasLibres.pop()
                send indicarCabina[idP](idCabina)
            }

        [] not (empty (finusoCabina)) ->
            recieve finUsoCabina(idP, idCabina)
            colaCabinasLibres.push(idCabina)
            ticket = Cobrar(idCabina)
            send cobro[idP](ticket)
    }
}




b) Modifique la solución implementada para que el empleado dé prioridad a los que
terminaron de usar la cabina sobre los que están esperando para usarla.
Nota : maximizar la concurrencia; suponga que hay una función Cobrar() llamada por el
empleado que simula que el empleado le cobra al cliente


process Persona(idP=1..P){
    send pedirCabina(idP)
    send despertar()
    recibe indicarCabina[idP](idCabina)
    //la usa
    send finUsoCabina(idP,idCabina)
    send despertar(idP)
    recieve cobro[idP](ticket)
}

process Empleado(){
    colaCabinasLibres: Cola<Integer>
    cola = (1..10)
    while (true){
        recieve despertar()
        if (not empty (pedirCabina)) && (empty(finUsoCabina)) -->
            if (cola.vacia()){
                receive finUsoCabina(idP, idCabina)
                colaCabinasLibres.push(idCabina)
                ticket = Cobrar(idCabina)
                send cobro[idP](ticket)
            }
            else{
                recieve pedirCabina(idP)
                idCabina = colaCabinasLibres.pop()
                send indicarCabina[idP](idCabina)
            }

        [] not (empty (finusoCabina)) ->
            recieve finUsoCabina(idP, idCabina)
            colaCabinasLibres.push(idCabina)
            ticket = Cobrar(idCabina)
            send cobro[idP](ticket)
    }
}



## Ejercicio 5

Resolver la administración de 3 impresoras de una oficina. Las impresoras son usadas por N  administrativos, los cuales están continuamente trabajando y cada tanto envían documentos a imprimir.
 Cada impresora, cuando está libre, toma un documento y lo imprime, de acuerdo con el orden de llegada.
a) Implemente una solución para el problema descrito.
b) Modifique la solución implementada para que considere la presencia de un director de oficina que también usa las impresoras, el cual tiene prioridad sobre los administrativos.
c) Modifique la solución (a) considerando que cada administrativo imprime 10 trabajos y que todos los procesos deben terminar su ejecución.
d) Modifique la solución (b) considerando que tanto el director como cada administrativo imprimen 10 trabajos y que todos los procesos deben terminar su ejecución.
e) Si la solución al ítem d) implica realizar Busy Waiting, modifíquela para evitarlo.
Nota: ni los administrativos ni el director deben esperar a que se imprima el documento.

### a)
Proceso administrativo(idAdm=1..N){
    while(true)
        //trabando
        delay(random)
        documento = necesitaImprimir()
        send colaImpresion(documento,idAdm)
        send hayPedido()
        recieve impresion[idAdm](impresion)
}
Process impresora(idImp=1..3){
    while(true){
        recieve colaImpresion(documento,idAdm)
        impresion = imprimir(documento)
        send impresion[idAdm](impresion)
    }
}

### b)

Proceso administrativo(idAdm=1..N){
    while(true)
        //trabando
        delay(random)
        documento = necesitaImprimir()
        send colaImpresion(documento,idAdm)
        send hayPedido()
        recieve impresion[idAdm](impresion)
}
process CoordinadorColaImpresion(){
    while(true)
        recieve pedirSiguiente(idImp)
        recieve hayPedido()
        if (not empty colaImpresionPrioritaria) -> {
            recieve colaImpresionPrioritaria(documento)
            send siguiente[idImp](documento, null,true)
        }
        []  (not empty colaImpresion) ->{
            recieve colaImpresion(documento, idAdm)
            send siguiente[idImp](documento, idAdm,false)
        }
    
}
Process impresora(idImp=1..3){
    while(true){
        send pedirSiguiente(idImp)
        recieve siguiente[idImp](documento, idAdm, esDirector)
        impresion= imprimir(documento)
        if esDirector{
            send impresionPrioritaria(impresion)
        }else{ 
            send impresion[idAdm](impresion)
        }
    }
}

Process Director{
    while(true)
        //trabajando
        documento = necesitaImprimir()
        send colaImpresionPrioritaria(documento)
        send hayPedido()
        recieve impresionPrioritaria(impresion)
}

### c) Modifique la solución (a) considerando que cada administrativo imprime 10 trabajos y que todos los procesos deben terminar su ejecución.

Proceso administrativo(idAdm=1..N){
    for i =1..10{
        //trabajando
        delay(random)
        documento = necesitaImprimir()
        send colaImpresion(documento,idAdm)
        send hayPedido()
        recieve impresion[idAdm](impresion)
}
Process impresora(idImp=1..3){
    for i =1..10*N{
        recieve colaImpresion(documento,idAdm)
        impresion = imprimir(documento)
        send impresion[idAdm](impresion)
    }
}

### d)


Proceso administrativo(idAdm=1..N){
    for i =1..10{

        //trabando
        delay(random)
        documento = necesitaImprimir()
        send colaImpresion(documento,idAdm)
        send hayPedido()
        recieve impresion[idAdm](impresion)
}
process CoordinadorColaImpresion(){
    for i= 1 .. ((N+1)*10){
        recieve pedirSiguiente(idImp)
        recieve hayPedido()
        if (not empty colaImpresionPrioritaria) -> {
            recieve colaImpresionPrioritaria(documento)
            send siguiente[idImp](documento, null,true)
        }
        []  (not empty colaImpresion) ->{
            recieve colaImpresion(documento, idAdm)
            send siguiente[idImp](documento, idAdm,false)
        }
    }
    for i=1..3{
        recieve pedirSiguiente(idImp)
        send siguiente(-1)
    }
    
}
Process impresora(idImp=1..3){
    send pedirSiguiente(idImp)
    recieve siguiente[idImp](documento, idAdm, esDirector)
    while(idAdm<>-1){
        impresion= imprimir(documento)
        if esDirector{
            send impresionPrioritaria(impresion)
        }else{ 
            send impresion[idAdm](impresion)
        }
        send pedirSiguiente(idImp)
        recieve siguiente[idImp](documento, idAdm, esDirector)
    }
        
    }
}

Process Director{
    for i =1..10{

        //trabajando
        documento = necesitaImprimir()
        send colaImpresionPrioritaria(documento)
        send hayPedido()
        recieve impresionPrioritaria(impresion)
}
 


## Ejercicio 6

Suponga que existe un antivirus distribuido que se compone de R procesos robots Examinadores y 1 proceso Analizador. Los procesos Examinadores están buscando
continuamente posibles sitios web infectados; cada vez que encuentran uno avisan la dirección y luego continúan buscando. El proceso Analizador se encarga de hacer todas las
pruebas necesarias con cada uno de los sitios encontrados por los robots para determinar si están o no infectados.
a) Analice el problema y defina qué procesos, recursos y comunicaciones serán necesarios/convenientes para resolverlo.
b) Implemente una solución con PMS sin tener en cuenta el orden de los pedidos.
c) Modifique el inciso (b) para que el Analizador resuelva los pedidos en el orden en que se hicieron



Forma en la que se bloquean esperando que el analizador les reciba el mensaje. Si queremos evitarlo, requerimos un proceso buffer...

process Examinador(idE = 1..R){
    while true
        //buscando sitios web infectados
        sitio = encontrarSitio()
        ANALIZADOR!Avisar(sitio)
}

process Analizador{
    while true 
        EXAMINADOR[*]?Avisar(sitio)
        analizar(sitio)
}

### Ahora con proceso BUFFER, necesario para que no se bloqueen los examinadores, y ademas es ya de paso para implementar que maneje el orden de llegada, puesto que para esto tambien es necesario un buffer, ya que los comodines de recepcion no garantizan un orden determinado.

process Examinador(idE = 1..R){
    while true
        //buscando sitios web infectados
        sitio = encontrarSitio()
        BUFFER!Avisar(sitio)
}

process BUFFER{
    colaSitios = new Cola()
    while (true){
        if EXAMINADOR[*]?Avisar(sitio) ->
            colaSitios.push(sitio)

        [] (not colaSitios.vacia()); ANALIZADOR?pedirSitio() ->
            ANALIZADOR!pasarSitio(colaSitios.pop())
    }
}

process Analizador{
    while true 
        BUFFER!pedirSitio()
        BUFFER?pasarSitio(sitio)
        analizar(sitio)
}


## Ejercicio 7

En un laboratorio de genética veterinaria hay 3 empleados.
El primero de ellos continuamente prepara las muestras de ADN; cada vez que termina, se la envía al segundo empleado y vuelve a su trabajo.
El segundo empleado toma cada muestra de ADN preparada, arma el set de análisis que se deben realizar con ella y espera el resultado para
archivarlo. Por último, el tercer empleado se encarga de realizar el análisis y devolverle el resultado al segundo empleado

### Sin buffers.
process PrimerEmpleado(){
    while (true)
        muestras = prepararMuestrasAdn()
        SegundoEmpleado!.pasarMuestras(muestras)
}
process SegundoEmpleado(){
    while (true)
        PrimerEmpleado?.pasarMuestras(muestras)
        setAnalisis = prepararSet(muestras)
        TercerEmpleado!pasarSet(setAnalisis)
        TercerEmpleado?pasarResultado(resultado)
        archivar(resultado)
}
process TercerEmpleado(){
    while(true)
        SegundoEmpleado?pasarSet(setAnalisis)
        resultado = analizar(setAnalisis)
        SegundoEmpleado!pasarResultado(resultado)
}

### Con buffer para que el PrimerEmpleado pueda volver a su trabajo.
process PrimerEmpleado(){
    while (true)
        muestras = prepararMuestrasAdn()
        BufferMuestras!.dejarMuestras(muestras)
}
process BufferMuestras{
    colaMuestras = New Cola()
    while(true)
        if PrimerEmpleado?.dejarMuestras(muestras) -> colaMuestras.push(muestras)
        [] (not empty(colaMuestras)); SegundoEmpleado?.pedirMuestras() -> SegundoEmpleado!.pasarMuestras(muestras)
}
process SegundoEmpleado(){
    while (true)
        BufferMuestras!pedirMuestras()
        BufferMuestras?.pasarMuestras(muestras)
        setAnalisis = prepararSet(muestras)
        TercerEmpleado!pasarSet(setAnalisis)
        TercerEmpleado?pasarResultado(resultado)
        archivar(resultado)
}
process TercerEmpleado(){
    while(true)
        SegundoEmpleado?pasarSet(setAnalisis)
        resultado = analizar(setAnalisis)
        SegundoEmpleado!pasarResultado(resultado)
}


## Ejercicio 8

En un examen final hay N alumnos y P profesores. Cada alumno resuelve su examen, lo
entrega y espera a que alguno de los profesores lo corrija y le indique la nota. Los
profesores corrigen los exámenes respetando el orden en que los alumnos van entregando.
a) Considerando que P=1.
b) Considerando que P>1.
c) Ídem b) pero considerando que los alumnos no comienzan a realizar su examen hasta que todos hayan llegado al aula.
Nota: maximizar la concurrencia; no generar demora innecesaria; todos los procesos deben
terminar su ejecución

N alumnos
P profesores

### a) Considerando que P=1.

process Profesor(){
    for i =1..N{
        Alumno[*]?pedirExamen(idA)
        Alumno[idA]!darExamen(examen)
    }
    for i = 1..N {
        Buffer!pedirSiguiente()
        Buffer?siguiente(resolucion, idA)
        nota = corregir(resolucion)
        Alumno[idA].darNota(nota)
    }
}

process Buffer(){
    colaEntregas = new Cola()
    for i = 1..N*2 {
        if Alumno[*]?entregar(resolucion,idA) ->
            colaEntregas.push( (resolucion,idA) )
        [] (not colaEntregas.vacia()); Profesor?pedirSiguiente() -> 
            profesor!siguiente(cola.pop())
    }
}

process Alumnos(idA=1..N){
    Profesor!pedirExamen(idA)
    Profesor?darExamen(examen)
    //comienza a resolver
    resolucion = resolver(examen)
    BufferEntregas!entregar(resolucion, idA)
    Profesor?darNota(nota)
}

### b) Considerando que P > 1.



process Profesor(idP=1..P){
    idA=0;
    BufferExamen!.pedirSiguiente(idP)
    BufferExamen?.siguienteAlumno(idA)
    while(idA<>"-1"){
        examen = copiaDelExamen()
        Alumno[idA]!darExamen(examen)
        BufferExamen!.pedirSiguiente(idP)
        BufferExamen?.siguienteAlumno(idA)

    }
    idA=0;
    BufferEntrega!pedirSiguienteResolucion(idP)
    BufferEntrega?siguienteResolucion(resolucion, idA)
    while(idA<>-1) {
        nota = corregir(resolucion)
        Alumno[idA].darNota(nota)
        BufferEntrega!pedirSiguienteResolucion(idP)
        BufferEntrega?siguienteResolucion(resolucion, idA)
    }
}

process BufferExamen(){
    colaAlumnos = new Cola
    for i = 1..N*2 {
        if Alumno[*]?pedirExamen(idA) -> colaAlumnos.push(idA)
        [] (not colaAlumnos.vacia()); Profesor[*]?pedirSiguiente(idP) ->
            Profesor[idP]!siguienteAlumno(colaAlumnos.pop())
    }
    for i =1..P {
        Profesor[*]?pedirSiguiente(idP) 
        Profesor[idP]!siguienteAlumno(-1)

    }
}

process BufferEntrega(){
    colaEntregas = new Cola()
    for i = 1..N*2 {
        if Alumno[*]?entregar(resolucion,idA) ->
            colaEntregas.push( (resolucion,idA) )
        [] (not colaEntregas.vacia()); Profesor[*]?pedirSiguienteResolucion(idP) -> 
            profesor[idP]!siguienteResolucion(cola.pop())
    }
    for i=1..P{
        Profesor?pedirSiguiente()
        profesor!siguiente(-1)
    }
}
    

process Alumnos(idA=1..N){
    BufferExamen!pedirExamen(idA)
    Profesor?darExamen(examen)
    //comienza a resolver
    resolucion = resolver(examen)
    BufferEntregas!entregar(resolucion, idA)
    Profesor?darNota(nota)
}



### c) igual que el B, pero considerando que los alumnos no comienzan a realizar su examen hasta que todos hayan llegado al aula.



process Profesor(idP=1..P){
    idA=0;
    BufferExamen!.pedirSiguiente(idP)
    BufferExamen?.siguienteAlumno(idA)
    while(idA<>"-1"){
        examen = copiaDelExamen()
        Alumno[idA]!darExamen(examen)
        BufferExamen!.pedirSiguiente(idP)
        BufferExamen?.siguienteAlumno(idA)

    }
    idA=0;
    BufferEntrega!pedirSiguienteResolucion(idP)
    BufferEntrega?siguienteResolucion(resolucion, idA)
    while(idA<>-1) {
        nota = corregir(resolucion)
        Alumno[idA].darNota(nota)
        BufferEntrega!pedirSiguienteResolucion(idP)
        BufferEntrega?siguienteResolucion(resolucion, idA)
    }
}

process BufferExamen(){
    colaAlumnos = new Cola
    for i = 1..N*2 {
        if Alumno[*]?pedirExamen(idA) -> colaAlumnos.push(idA)
        [] (not colaAlumnos.vacia()); Profesor[*]?pedirSiguiente(idP) ->
            Profesor[idP]!siguienteAlumno(colaAlumnos.pop())
    }
    for i =1..P {
        Profesor[*]?pedirSiguiente(idP) 
        Profesor[idP]!siguienteAlumno(-1, null)
    }
    colaListos = new Cola()
    for i =1..N {
        Alumno[*]?.listo(idA) ->  colaListos.push(idA)
    }
    for i = 1..N {
        Alumno[colaListos.pop()]!comenzar()
    }
}

process BufferEntrega(){
    colaEntregas = new Cola()
    for i = 1..N*2 {
        if Alumno[*]?entregar(resolucion,idA) ->
            colaEntregas.push( (resolucion,idA) )
        [] (not colaEntregas.vacia()); Profesor[*]?pedirSiguienteResolucion(idP) -> 
            profesor[idP]!siguienteResolucion(cola.pop())
    }
    for i=1..P{
        Profesor?pedirSiguiente()
        profesor!siguiente(-1, null)
    }
}
    

process Alumnos(idA=1..N){
    BufferExamen!pedirExamen(idA)
    Profesor?darExamen(examen)
    BufferExamen!.listo(idA)
    BufferExamen?.comenzar(idA)

    //comienza a resolver
    resolucion = resolver(examen)
    BufferEntregas!entregar(resolucion, idA)
    Profesor?darNota(nota)
}


## Ejercicio 9
En una exposición aeronáutica hay un simulador de vuelo (que debe ser usado con exclusión mutua) y un empleado encargado de administrar su uso. 
Hay P personas que esperan a que el empleado lo deje acceder al simulador, lo usa por un rato y se retira.
a) Implemente una solución donde el empleado sólo se ocupa de garantizar la exclusión mutua (sin importar el orden).
b) Modifique la solución anterior para que el empleado los deje acceder según el orden de
su identificador (hasta que la persona i no lo haya usado, la persona i+1 debe esperar).
c) Modifique la solución a) para que el empleado considere el orden de llegada para dar acceso al simulador.
Nota: cada persona usa sólo una vez el simulador.


### a) Empleado solo se ocupa de garantizar exclusion mutua, sin importar el orden

Procees Persona(idP=1..P){
    Empleado!pedirUsar(idP)
    //usarlo
    delay(random())
    Empleado!finUsoSimulador()
}

Process Empleado {
    for i = 1..P {   
        Persona[*]?pedirUsar(idP)
        //lo esta usando
        Persona[idP]?finUsoSimulador()
    }
}

### b) Modifique la solución anterior para que el empleado los deje acceder según el orden de su identificador (hasta que la persona i no lo haya usado, la persona i+1 debe esperar).

Procees Persona(idP=1..P){
    Empleado!pedirUsar()
    //usarlo
    delay(random())
    Empleado!finUsoSimulador()
}

Process Empleado {
    for i = 1..P
        Persona[i]?pedirUsar()
        //lo esta usando
        Persona[i]?finUsoSimulador()
}


c) Modifique la solución a) para que el empleado considere el orden de llegada para dar acceso al simulador.


Procees Persona(idP=1..P){
    Empleado!pedirUsar(idP)
    Empleado?turno()
    //usarlo
    delay(random())
    Empleado!finUsoSimulador()
}

Process Empleado {
    colaFila = new Cola()
    libre = true
    for i = 1..N*2 {
        if Persona[*]?pedirUsar(idP) ->
            if (libre && cola.vacia())
                Persona[idP]!turno()
                libre=false;
            else 
                colaFila.push(idP)

        [] Persona[*]?finUsoSimulador() ->
            if (cola.vacia())
                libre = true
            else
                Persona[colaFila.pop()]!turno()
    }
}




## Ejercicio 10

En un estadio de fútbol hay una máquina expendedora de gaseosas que debe ser usada por E Espectadores de acuerdo con el orden de llegada. 
Cuando el espectador accede a la máquina en su turno usa la máquina y luego se retira para dejar al siguiente.
Nota: cada Espectador una sólo una vez la máquina.


process Espectador(idE: 1..E){
    MAQUINA!.usar(idE)
    MAQUINA?.turno()
    //la usa
    MAQUINA!Liberar()
}

process Maquina{
    colaEspera = new Cola()
    boolean libre=true;
    while(true){
        if EMPLEADO[*]?Usar(idE) ->
            if (libre) {
                libre =false
                ESPECTADOR[idE]!turno()
            } else{
                colaEspera.push(idE)
            }
        [] EMPLEADO[*]?Liberar() ->
            if colaEspera.vacia(){
                libre=true
            }else{
                EMPLEADO[colaEspera.pop()]!Turno()
            }
    }

}

