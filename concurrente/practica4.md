Suponga que N clientes llegan a la cola de un banco y que serán atendidos por sus
empleados. Analice el problema y defina qué procesos, recursos y canales/comunicaciones
serán necesarios/convenientes para resolverlo.
 Luego, resuelva considerando las siguientes situaciones:
a. Existe un único empleado, el cual atiende por orden de llegada.

b. Ídem a) pero considerando que hay 2 empleados para atender, ¿qué debe modificarse en la solución anterior?

c. Ídem b) pero considerando que, si no hay clientes para atender, los empleados realizan tareas administrativas durante 15 minutos. ¿Se puede resolver sin usar procesos adicionales? ¿Qué consecuencias implicaría?

a)

Personas (N){
    send atencion(id)
}

Empleado {
    while (true){
        receive(atencion(idCli))
        //atendiende al cliente=idCli.
    }
}

b)


Personas (N){
    send atencion(id)
}

Empleado(2) {
    while (true){
        receive(atencion(idCli))
        //atendiende al cliente=idCli.
    }
}


c)
Personas (id: 0..N-1){
    send atencion(id)
}

Empleado(id: 0..1) {
    while (true){
        send libre(id)
        recieve siguiente(sig)
        if (sig = -1)
            delay(15min)
        else
            //atenderCliente(sig)
    }
}


Coordinador {
    while (true){
        receive libre(idE)
        if (empty (atencion))
            sig = "-1"
        else
            recieve(atencion(sig))
        send siguiente[idE](sig)
    }
}

2)Se desea modelar el funcionamiento de un banco en el cual existen 5 cajas para realizar pagos.
Existen P clientes que desean hacer un pago. 
Para esto, cada una selecciona la caja donde hay menos personas esperando; una vez seleccionada, espera a ser atendido.
En cada caja, los clientes son atendidos por orden de llegada por los cajeros. 
Luego del pago, se les entrega un comprobante. Nota: maximizar la concurrencia.



Process Cliente(id: 0..N-1){
    send avisoLlegada()
    send pedirCaja(id)
    receive colaMasVacia[idC](idE)
    send espera[idE](id)
    receive atencion[idC]
    //siendo atendido
    receive comprobante[idC](comprobante)
    send cajaFinUso(idC)
}


Process Organizador(){
    int[] genteFila = [5](0)
    while (true){
        receive(avisoLlegada)
        //primero fijarse si alguien terminó, para descontar su genteFila corresp.
        if (not empty (cajaFinUso))
            receive cajaFinUso(idC)
            genteFila[idC]--
         
        [] else if (empty (cajaFinUso)  and not empty(pedirCaja))
            receive pedirCaja(idC)
            min_id = minimo_id(genteFila[])
            genteFile[min_id]++
            send colaMasVacia[idC](min_id)


        
    }
}


process Empleado(idE = 0..4 ){
    while(true){
        receive espera[idE](idC)
        send atencion[idC]()
        comprobante = generarComprobante(idC)
        send comprobante[idC](comprobante)

    }
}


3) Se debe modelar el funcionamiento de una casa de comida rápida, en la cual trabajan 2 cocineros y 3 vendedores, y que debe atender a C clientes.
El modelado debe considerar que:
- Cada cliente realiza un pedido y luego espera a que se lo entreguen.
- Los pedidos que hacen los clientes son tomados por cualquiera de los vendedores y se lo pasan a los cocineros para que realicen el plato.
-  Cuando no hay pedidos para atender, los vendedores aprovechan para reponer un pack de bebidas de la heladera, 
-  (tardan entre 1 y 3 minutos para hacer esto).
- Repetidamente cada cocinero toma un pedido pendiente dejado por los vendedores, lo cocina y se lo entrega directamente al cliente correspondiente.
Nota: maximizar la concurrencia


chan hayCliente(), pedidosACocina(Pedido, int), vendedorLibre(int)
chan[C] tomaDePedido(int), entrega(Comida)
chan[Vendedores] pedido(Pedido), siguiente(int)

process Cliente (idCli: 0..C-1){
    send hayCliente(idCli)
    recieve tomaDePedido[idC](idVen)
    text pedido = pedido;
    send pedido[idVen](pedido)
    recieve entrega[idC](comida)

}

process Cocinero(idCoc: 0..1){
    while(true){
        recieve pedidosACocina(pedido,idCli)
        //comida = preparar (pedido)
        send entrega[idCli](comida) 
    }   
}

process Vendedor(idVen: 0..2 ){
    while(true){
        send vendedorLibre(idVen)
        recieve siguiente[idVen](sig)
        if (sig=-1)
            delay (random(1min,3min)) //recargando bebidas
        else {
            idCli=sig
            send tomaDePedido[idCli](idVen)
            recieve[idVen](pedido)
            send pedidosACocina(pedido,idCli)
        }       
    }
}


process Organizador(){
    while(true){
        receive vendedorLibre(idVen)
        if (empty hayCliente())
            sig = -1
        else
            recieve hayCliente(sig)
        send siguiente[idVen](sig)
    }
}