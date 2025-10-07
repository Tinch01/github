explicacion practica:
1)
Asi nomas, no necesita condiciones ni nada, puesto que solo pueden ejecutar "usarCajero()" de a uno a la vez.

Monitor cajero:{
    procedure UsarCajero():
        //usarlo
}

Process Persona(1..N){
    Cajero.usarCajero()
}

2)

Monitor cajero:{
    boolean libre=true
    Cond disponible
    cantEsperando=0  

    procedura pasar(){
        if (!libre)
            cantEsperando++
            wait(disponible)
            cantEsperando--
        else 
            libre=false
        

    procedure irse(){
        if (cantEsperando=0)
            libre=true
        else
            signal(disponible)
         
    }

    }
}

Process Persona(1..N){
    Cajero.pasar()
    UsarCajero()
    Cajero.irse()
}

3)


4)

Clientes deben ser atendidos   pro cualquier empleado, siguiendo orden llegada
Cuando empleado lo atiente... el cliente le entrega los papeles y espera resultado

E=3 Empleados
N   Clientes

procedure Empleado(id=0..E-1){
    while(true)
        Empleado[id].atenderCliente()
        //atendiendo
        Empleado[id].terminarAtencion()
}

procedure Cliente(id=0..N-1) {
    Banco.llegar(idEmp)
    Empleado[idEmp].serAtendido()
    //Siendo atendido
    Empleado[idEmp].terminarAtencion()
}

Monitor Banco{
    Cola colaEmpLibres
    Cond esperaCli
    int cantEsperando = 0
    
    Procedure llegar(idEmp int:out){
        if (cantEsperando > 0)
            cantEsperando++
            wait(esperaCli)
            cantEsperando--
        idEmp=colaEmpLibres.pop()
        
            
    }

    Procedure retirarse(idEmp int:in){
        colaEmpLibres.push(idEmp)
        if (cantEsperando>0)
            signal(esperaCli)

    }
}


Monitor Empleado(id=0..E-1){
    atenderCliente
    terminarAtencion

}




Ejercicio 5 explicaicon practica 3


Jugador 0..21 {
    Cancha.llegar()
    //jugar
    Cancha.irse()

}



Monitor cancha {
    cant=0
    cond esperando; cond Inicio
    llegar(){
        cant++
        if (cant=22)
            signal(inicio)
        wait(esperando)
    }

    cancha(irse){
        cant--
    }

    jugarPartido()
        if (cant<22)
            wait(inicio)

    terminar()
        signal_all(esperando)
}


Partido(){
    cancha.iniciar()
    delay(90 min)
    cancha.terminar()
}



Ejercicio6 expli practica 3

Mi solucion... problema: tiene que esperar a que levanten el resultado para procesar el siguiente pedido.
Es importante reconocer casos cuando no tienen que interactuar entre ellos cliente y servidor.
En estos casos nos conviene la solucion con variables privadas para guardar los resultados correspondidos a los clientes.


process Cliente(0..n-1 )
    Datos datos.
    Resultados resultados.
    AccesoServidor.accede(datos)
    AccesoServidor.recibeResultados(resultados)
    //continua.


process Servidor(){
    while (true)
        AccesoServidor.recibirDatos(datos)
        resultados = procesar(datos)
        AccesoServidor.enviarResultados(resultados)
}


Monitor accesoServidor(){
    Cond cli_espera, esperaDatos, recibido
    int cantEspera=0
    Datos datos_act
    resultados resultados_act
    Boolean true

    accede(datos:in){
        if (!libre=true)
            cantEspera++
            wait(cli_espera)
        libre = false
        datos_act = datos
        signal(esperaDatos)
    }


    recibirDatos(datos:out)
        if (libre)
            wait(esperaDatos)
        datos = datos_act

    enviaResultados(resultados: in)
        resultados_act = resultados
        procesado = true
        signal(esperaResultados)
        wait(recibido)

    recibeResultados(resultados:out)
        if (procesado=false)
            wait(esperaResultados)
        resultados = resultados_act
        cantEspera--
        if (cantEspera==0)
            libre =true
        else
            signal(cli_espera)
        signal(recibido)

        
}

Correcion con arreglo de datos:

process Cliente(0..n-1 )
    Datos datos.
    Resultados resultados.
    AccesoServidor.accede(datos, resultados)
    //continua.


process Servidor(){
    while (true)
        AccesoServidor.recibirDatos(datos)
        resultados = procesar(datos)
        AccesoServidor.enviarResultados(resultados)
}


Monitor accesoServidor(){
    Cond cli_espera, esperaDatos, recibido
    Cola C
    int cantEspera=0
    Datos datos_act
    int id_act
    Resultado[N] resultados
    Boolean true

    accede(id, datos:in, resultado:out){
        if (!libre=true)
            cantEspera++
            C.push(id,datos)
            wait(cli_espera)
        libre = false
        datos_act = datos
        id_act = id
        signal(esperaDatos)
        wait(esperaResultado)
        resultado = resultados[id]
    }


    recibirDatos(id: out, datos:out)
        if (libre)
            wait(esperaDatos)
        datos = datos_act
        id = id_act

    enviaResultados(id, resultados: in)
        resultados[id] = resultados
        signal(esperaResultado)
        
}

////COMIENZA LA PRACTICA 3



1)



4)


Process Vehiculo[id:0..N-1]{
	Puente.pasar(id,peso);
	//pasa
	Puente.termine(peso)
}

Monitor Puente {
	cond[] espera=[N];
	Cola cola[N];
	int pesoPuente=0;
	int PESOLIMITE=5000;
	
	Procedure pasar(id: in int; peso: in int){
        c.push(id, peso);
		if ((not isEmpty(C)) or (pesoPuente+peso>50000)){
			wait(espera[id]);
		}
        c.pop()
        pesoPuente+=peso;
    }

    Procedure termine(peso: in int){
        pesoPuente-=peso;
        if(not(isEmpty(C))) {
            id, peso=c.top(); mira el primero dato pero sin desencolar
            if(pesoPuente+peso <= 50000){
                signal(espera[id]);
            }
        }
    }
}


    En un corralón de materiales se deben atender a N clientes de acuerdo con el orden de llegada.
    Cuando un cliente es llamado para ser atendido, entrega una lista con los productos que
    comprará, y espera a que alguno de los empleados le entregue el comprobante de la compra
    realizada.
    a) Resuelva considerando que el corralón tiene un único empleado
    5)

    cliente (N)
        atencion.llegar(lista)
        atencion.retirarse(comprobante)

    empleado(1)
    while(true)
        atencion.tomarLista(lista)
        Comprobante comprobante = new Comprobante(lista)
        atencion.entregar(comprobante)


    Monitor atencion

    Cond disponible, atender, entrega
    Lista listaProdAct
    Comprobante compAct
    boolean libre= True
    int cant=0

    procedrue llegar(miLista:in)
        if !libre:
            cant++
            wait(disponible)
        libre=false
        singla(atender)
        listaProdAct=miLista
        wait(entrega)

    procedure retirarte (miComprobante:out)
        miComprobante = compAct
        cant--
        if (cant=0)
            libre=true
        else
            signal(disponible)


    procdeutr tomarLista(lista:out)
        if(libre)
            wait(atender)
        lista=listaAct

    procedure Entregar(comprobante:in)
        compACt = comprobante
        signal(entrega)



7)

Process Corredor(id= 0..C-1)
    //corre, termina carrera
    Maquina.tomarBotella()

Process Empleado:
while(true):
    Maquina.recargar()

Monitor Maquina
    int cantBotellas=0
    cond turno, esperaRecarga, atender
    int cantEspera=0
    boolean libre=true

    procedure tomarBotella(){
        if (!libre)
            cantEspera++;
            wait(turno)
            cantEspera--
        libre=false
        if(cantBotellas=0)
            signal(atender)
            wait(esperaRecarga)
        cantBotellas--
        if (cantEspera>0)
            signal(turno)
        else
            libre=true



    }

    procedure recargar(){
        if (cantBotellas>0)
            wait(atender)
        cantBotellas = 20
        signal(esperaRecarga)
    }


    8. En un entrenamiento de fútbol hay 20 jugadores que forman 4 equipos (cada jugador conoce
el equipo al cual pertenece llamando a la función DarEquipo()). Cuando un equipo está listo
(han llegado los 5 jugadores que lo componen), debe enfrentarse a otro equipo que también
esté listo (los dos primeros equipos en juntarse juegan en la cancha 1, y los otros dos equipos
juegan en la cancha 2). Una vez que el equipo conoce la cancha en la que juega, sus jugadores
se dirigen a ella. Cuando los 10 jugadores del partido llegaron a la cancha comienza el partido,
juegan durante 50 minutos, y al terminar todos los jugadores del partido se retiran (no es
necesario que se esperen para salir).




Process Jguador (0...j-1)
    organizacion.llegar(id_equipo)
    organizacion.cualCancha(id_equipo, id_cancha)
    organizacion.jugar(id_cancha)
    //jugando()
    organizacion.irse(ide_cancha)


Monitor Organizacion
int[] jugadoresEnCancha = ([CantCanchas], 0)
cond[] esperaEmpezarCancha = [CantCanchas]
cola CanchaLibre = (1, 2)

CantEquipos = 4
int [] jugadoresEquipo = ([CantEquipos], 0)
cond [] todosEquipo [CantEquipos]

int [] canchaToca = ([CantEquipos], 0)

PRocedure llegar(id_equipo:out){
    idEquipo = AsignarEquipo()
}

PRocedure cualCancha(id_equipo:in, id_cancha:out){
    jugadoresEquipo[id_equipo] ++
    if (jugadoresEquipo[id_equipo] < 5){
        wait(todosEquipo[id_equipo])
    }else{
        signal_all(todosEquipo[id_equipo])
        canchaToca[id_equipo] = canchaLibre.pop()
    }
    id_cancha = canchaToca[id_equipo]
}


procedure jugar(id_cancha:in){
    jugadoresEnCancha[id_cancha] ++
    if (jugadoresEnCancha[id_cancha] <10 ){
        wait(esperaEmpezarCancha[id_cancha])
    }
    else{
        signal_all(esperaEmpezarCancha[id_cancha])
    }

}


procedure irse(id_cancha:in, id_equipo:in){
    jugadoresEquipo[id_equipo] --
    jugadoresEnCancha[id_cancha] --
    if (jugadoresEnCancha[id_cancha] = 0 )
        canchasLibres.push(idCancha)
}




9. En un examen de la secundaria hay un preceptor y una profesora que deben tomar un examen
escrito a 45 alumnos. El preceptor se encarga de darle el enunciado del examen a los alumnos
cundo los 45 han llegado (es el mismo enunciado para todos). La profesora se encarga de ir
corrigiendo los exámenes de acuerdo con el orden en que los alumnos van entregando. Cada
alumno al llegar espera a que le den el enunciado, resuelve el examen, y al terminar lo deja
para que la profesora lo corrija y le envíe la nota.
Nota: maximizar la concurrencia; todos los
procesos deben terminar su ejecución; suponga que la profesora tiene una función
corregirExamen que recibe un examen y devuelve un entero con la nota.




Process Alumno=  (1..45){
    Examen.llegar(id, enunciado)
    resoluicion = enunciado.resolver()
    examen.terminar(id, resolucion)
}

process Preceptor(){
    examen.repartirEnunciados()
}

process Profesora(){
    examen.CorregirExamen(id, resolucion)
    nota = corregirExamen(resolucion)
    examen.enviarNota(id, nota)
}


Monitor Examen

int cantAlumnos=0
cond EstanTodos, Entrega
Cond[45] entregaEnunciado
Enunciado[45] enunciados
Cola<Entrega> entregas
int[45] notas

Procedure llegar(id:in; miEnunciado:out){
    cantAlumnos++
    if (cantAlumnos=45)
        signal(EstanTodos)
    wait(EntregaEnunciado[id])
    miEnunciado = enunciados[id]
}

procedure terminar(id:in, resolucion:in){
    entregas.push(id, resolucion) //como un mismo dato
    signal(entrega)
}

procedure repartirEnunciados(){
    if cantAlumnos <45
        wait(estanTodos)
    for i = 0..44{
        enunciado[i]= darleEnunciado() //funcion representativa
        signal(EntregaEnunciado[i])
    }
}

procedure recibir(id:out,resolucion:out){
    if (entregas.vacia())
        wait(entrega)
    resolucion, id = entregas.pop()
}

procedure enviarNota(id:in, nota:in){
    notas[id] = nota
}




10.En un parque hay un juego para ser usada por N personas de a una a la vez y de acuerdo al
orden en que llegan para solicitar su uso. Además, hay un empleado encargado de desinfectar el
juego durante 10 minutos antes de que una persona lo use. Cada persona al llegar espera hasta
que el empleado le avisa que puede usar el juego, lo usa por un tiempo y luego lo devuelve.
Nota: suponga que la persona tiene una función Usar_juego que simula el uso del juego; y el
empleado una función Desinfectar_Juego que simula su trabajo. Todos los procesos deben
terminar su ejecución


Process Persona(0..n-1)
    juego.solicitarUso(id)
    //usarJuego()
    juego.retirarse()

process Empleado{
    for i = 1 to N{
        juego.recibirGente()
        //desinfectarJuego()
        juego.abrir()
    }
}


Monitor Juego
boolean libre = true
Cola<int> colaEspera
cond[N] turno
cond Limpiar,PuedeUsar,Fin

Procedure SolicitarUso(id:in){
    if (!libre){
        colaEspera.push(id)
        wait(turno[id])
    }
    libre=False
    signal(Limpiar)
    wait(PuedeUsar)
}

Proceudre Retirarse(){
    if (colaEspera.vacia){
        libre=true;

    }
    else{
        signal(turno[colaEspera.pop()])
    }
    signal(fin)
}

procedure recibirGente()
    if(libre){
        wait(Limpiar)
    }

procedure abrir()
    signal(PuedeUsar)
    wait(Fin)