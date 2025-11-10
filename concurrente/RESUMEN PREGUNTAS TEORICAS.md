
--------------------------------------------------------------------------------
Programación Concurrente 2025
Cuestionario guía - Clases Teóricas 5, 6 y 7
## 1- Defina y diferencie programa concurrente, programa distribuido y programa paralelo.
Los tres términos describen diferentes aspectos de la ejecución y el diseño de programas:
💡 Definiciones:
• Programa Concurrente: Se refiere a la ejecución de múltiples tareas o procesos de manera aparentemente simultánea, aunque no necesariamente en paralelo
. Puede llevarse a cabo en sistemas con un solo procesador (mediante la alternancia rápida de tareas, conocido como multiprogramación) o en sistemas con múltiples procesadores. Especificar la concurrencia implica definir los procesos concurrentes, su comunicación y su sincronización
.
• Programa Paralelo: Es la ejecución concurrente en múltiples procesadores con el objetivo principal de reducir el tiempo de ejecución del programa
.
• Programa Distribuido: Es fundamentalmente un programa concurrente que se comunica mediante mensajes
. Típicamente, supone la ejecución sobre una arquitectura de memoria distribuida, aunque podría ejecutarse sobre una de memoria compartida o híbrida. Los procesos en un programa distribuido SOLO comparten canales (físicos o lógicos), y nada más
--------------------------------------------------------------------------------

## 2- Marque al menos 2 similitudes y 2 diferencias entre los pasajes de mensajes sincrónicos y asincrónicos. Indicar cual es la principal ventaja de pasaje de mensajes sincrónicos respecto a pasaje de mensajes asincrónicos.
Ambos son mecanismos fundamentales para el Pasaje de Mensajes (PM) utilizados en el procesamiento distribuido
.
Similitudes (Al menos 2)
1. Mecanismos de Interacción: Ambos utilizan primitivas de envío (Send o sync_send) y recepción (Receive) para que los procesos interactúen
.
2. Canales Compartidos: En ambos modelos, los procesos solo comparten canales (físicos o lógicos) para la comunicación
.
3. Naturaleza Bloqueante del Receive: En ambos casos (PMA y PMS), la primitiva de recepción (Receive o ? en CSP) es bloqueante, demorando al receptor hasta que haya un mensaje en el canal
.
Diferencias (Al menos 2)
1. Comportamiento del Emisor (Send):
    ◦ PMA: La operación Send no bloquea al emisor, el proceso continúa inmediatamente después de enviar el mensaje
.
    ◦ PMS: La operación Send o sync_send es bloqueante; el transmisor queda esperando hasta que el mensaje sea recibido por el receptor
.
2. Uso de Memoria/Canales:
    ◦ PMA: Los canales son colas de mensajes (buffers) que se consideran ilimitadas en principio, almacenando mensajes enviados y aún no recibidos
.
    ◦ PMS: La cola de mensajes asociada a un Send sobre un canal se reduce a un mensaje, lo que requiere menos memoria
.
3. Grado de Concurrencia y Deadlock:
    ◦ PMA: Hay una mayor concurrencia porque los procesos se ejecutan a su propia velocidad gracias al buffering implícito
.
    ◦ PMS: El grado de concurrencia se reduce (los emisores se bloquean), y las posibilidades de deadlock son mayores, requiriendo que el programador asegure que todas las sentencias send y receive hagan matching
.
Ventaja Principal de PMS
La principal ventaja del Pasaje de Mensajes Sincrónicos respecto al Asincrónico es que requiere menos memoria, ya que la cola de mensajes se reduce a un solo mensaje


--------------------------------------------------------------------------------
## 3- Analice qué tipo de mecanismos de pasaje de mensajes son más adecuados para resolver problemas de tipo Cliente/Servidor, Pares que interactúan, Filtros, y Productores y Consumidores. Justifique claramente su respuesta.
🎯 Filtros y Productores y Consumidores
• Mecanismo Adecuado: Pasaje de Mensajes Asincrónicos (PMA) o Pasaje de Mensajes General
.
• Justificación: El Pasaje de Mensajes (PM) se ajusta bien a estos problemas, ya que generalmente plantean una comunicación unidireccional
. PMA es especialmente ventajoso para Productores/Consumidores porque el buffering implícito (canales como colas ilimitadas) permite a los procesos ejecutar a su propia velocidad, sin ir al ritmo del más lento, lo que aumenta la concurrencia. Los filtros (procesos que reciben de canales de entrada y envían a canales de salida) también se benefician del PMA para mantener un flujo de datos eficiente. Si se usara PMS, sería necesario programar un proceso buffer adicional para lograr el mismo efecto
.
🎯 Pares que interactúan
• Mecanismo Adecuado: Pasaje de Mensajes General (PMA o PMS)
.
• Justificación: Al igual que los filtros, los pares que interactúan (procesos idénticos que interactúan entre sí) a menudo requieren comunicación unidireccional o intercambios simples que el PM gestiona bien
. Si la interacción requiere un intercambio simétrico de valores (bidireccional), PMS con comunicación guardada puede ser utilizado para evitar deadlock, aunque puede ser más complejo de implementar que una solución PMA
.
🎯 Cliente/Servidor (C/S)
• Mecanismo Más Adecuado: RPC (Remote Procedure Call) y Rendezvous
.
• Justificación: Para resolver C/S se necesita comunicación bidireccional (solicitud y respuesta). Si se usa PM simple (PMA), esto obliga a especificar dos tipos de canales (requerimientos y respuestas), y cada cliente necesita un canal de reply distinto
. RPC y Rendezvous resuelven esta complejidad, ya que son técnicas que suponen un canal bidireccional de forma implícita y combinan una interfaz procedural (similar a monitores) con mensajes sincrónicos que demoran al llamador hasta el retorno de los resultados
.

--------------------------------------------------------------------------------
## 4- Indique por qué puede considerarse que existe una dualidad entre los mecanismos de monitores y pasaje de mensajes. Ejemplifique
Existe una dualidad entre monitores y pasaje de mensajes (PM) porque cada uno de ellos es capaz de simular al otro
. Esta correspondencia entre sus mecanismos es directa
La elección de cuál mecanismo es más eficiente depende de la arquitectura física subyacente: los monitores son adecuados para arquitecturas de Memoria Compartida (MC), mientras que PM es más eficiente para arquitecturas de Memoria Distribuida (MD)
.
Ejemplo de Simulación (Monitor Activo con PM - C/S)
Un monitor (que es un manejador de recurso con variables permanentes y procedures pasivos) puede ser simulado usando un proceso servidor activo y Pasaje de Mensajes
.
Programas con Monitores
	
Programas basados en PM (Servidor Activo)
Variables permanentes
	
Variables locales del servidor (encapsulan el estado)
.
Llamado a procedure
	
send al canal de requerimiento y luego receive del canal de respuesta propio
.
Entry del monitor
	
receive request() (el servidor espera por un pedido)
.
Retorno del procedure
	
send respuesta() (el servidor devuelve el resultado)
.
Sentencia wait
	
Se simula salvando el pedido pendiente (diferir la respuesta)
.
Sentencia signal
	
Se simula recuperando/procesando el pedido pendiente y enviando la respuesta
.
Ejemplo Concreto (Administrador de Recursos): Para simular el monitor Administrador_Recurso que maneja la adquisición y liberación de unidades (incluyendo sincronización por condición), el servidor utiliza una cola (queue pendientes) para salvar los pedidos de adquisición cuando no hay unidades disponibles (wait en monitor). Cuando se libera una unidad (signal en monitor), el servidor recupera un pedido de esa cola para atenderlo

--------------------------------------------------------------------------------
## 5- ¿En qué consiste la comunicación guardada (introducida por CSP) y cuál es su utilidad? Describa cómo es la ejecución de sentencias de alternativa e iteración que contienen comunicaciones guardadas.
¿En qué consiste y cuál es su utilidad?
La comunicación guardada (introducida por CSP, Communicating Sequential Processes) consiste en utilizar operaciones de comunicación (? para entrada o ! para salida) dentro de una guarda, permitiendo hacer un AWAIT hasta que una condición sea verdadera
.
Una guarda se compone de una condición booleana opcional (B) y una sentencia de comunicación (C), resultando en la forma B;C→S
.
Su principal utilidad es soportar la comunicación no determinística
. Esto es crucial cuando un proceso necesita comunicarse con otros (posiblemente por diferentes puertos) sin saber de antemano el orden en que los otros procesos desearán comunicarse con él
.
• Una guarda tiene éxito si B es true y ejecutar C no causa demora
.
• Una guarda falla si B es false
.
• Una guarda se bloquea si B es true pero C no puede ejecutarse inmediatamente
.
⚙️ Ejecución de Sentencias de Alternativa (if) e Iteración (do)
Las sentencias de comunicación guardadas aparecen en las estructuras if y do de CSP
.
1. Evaluación de las Guardas
• Se evalúan primero todas las guardas
• Si todas las guardas fallan, el if termina sin efecto (o el do termina)
• Si al menos una guarda tiene éxito, se elige una de ellas de forma no determinística
• Si algunas guardas se bloquean, el proceso espera hasta que alguna de ellas tenga éxito (es decir, hasta que la comunicación pueda ocurrir inmediatamente)

2. Ejecución de la Comunicación:
• Luego de elegir una guarda exitosa, se ejecuta la sentencia de comunicación de la guarda elegida

3. Ejecución de la Sentencia:
• Finalmente, se ejecuta la sentencia Si​ asociada a esa guarda
La ejecución de la sentencia de iteración (do) es similar, repitiéndose este ciclo hasta que todas las guardas fallen, momento en el cual la iteración termina
--------------------------------------------------------------------------------
## 6- Modifique la solución con mensajes sincrónicos de la Criba de Eratóstenes para encontrar los números primos detallada en teoría de modo que los procesos no terminen en deadlock.
La solución original de la Criba de Eratóstenes con Pasaje de Mensajes Sincrónicos (PMS) establece un pipeline de procesos filtro
. La fuente indica que, excepto el primer proceso, los demás terminan bloqueados esperando un mensaje de su predecesor cuando se acaba la entrada, lo que es una forma de no-terminación controlada (deadlock potencial si no se maneja)
.
Para evitar que los procesos terminen en deadlock y garantizar una terminación limpia, se debe introducir un centinela (sentinel) que marque el fin del flujo de datos
. Asumiremos que N es el límite superior y 0 es el centinela, ya que los primos son positivos.
📝 Solución Original (Base para la modificación)
:

Process Criba[1]  {    int p = 2;
    for [i = 3 to n by 2]  Criba[2] ! (i); 
}
Process Criba[i = 2 to L]  {    int p, proximo;
    Criba[i-1] ? (p); 
    do Criba[i-1] ? (proximo) →
        if ((proximo MOD p) <> 0 ) and (i < L) → Criba[i+1] ! (proximo); 
    od
}

✅ Solución Modificada (Usando Centinela):
1. Proceso Criba
 (Productor): Debe enviar el centinela (0) al terminar el stream.

Process Criba[1]  {    int p = 2;
    for [i = 3 to n by 2]  Criba[2] ! (i); 
    Criba[2] ! (0); // Envía el centinela para señalar el fin
}

2. Proceso Criba[i] (Filtro, i ≥ 2): Debe recibir mensajes y, si detecta el centinela, propagarlo a su sucesor y terminar su propio loop, evitando quedar bloqueado esperando una entrada inexistente.

Process Criba[i = 2 to L]  {    int p, proximo;
    Criba[i-1] ? (p); 
    // p es el primo detectado por este filtro
    
    do Criba[i-1] ? (proximo) →
        if (proximo == 0) and (i < L) → 
            Criba[i+1] ! (0); // Propaga el centinela si no es el último filtro
            break; // Termina el loop para que el proceso Criba[i] finalice
        fi
        
        if ((proximo MOD p) <> 0 ) and (i < L) → 
            Criba[i+1] ! (proximo); // Envía números no múltiplos
        // El último proceso (i=L) no intenta enviar nada
    od
}

Al incluir el centinela y manejar su propagación, se asegura que la cadena de procesos termine ordenadamente en lugar de bloquearse indefinidamente esperando datos.

--------------------------------------------------------------------------------
## 7- Suponga que N procesos poseen inicialmente cada uno un valor. Se debe calcular la suma de todos los valores y al finalizar la computación todos deben conocer dicha suma.
a) Análisis (desde el punto de vista del número de mensajes y la performance global)
Este análisis se basa en la información proporcionada en las fuentes para el problema de encontrar el mínimo y el máximo valor, el cual sigue un patrón de intercambio de valores similar al de la suma
.
Arquitectura
	
Número de Mensajes
	
Performance Global y Justificación
Estrella (Centralizada)
	
2(N−1) mensajes
.
	
Eficaz para la toma de decisiones centralizadas
. La performance puede verse afectada ya que los N−1 mensajes llegan al coordinador casi simultáneamente. El coordinador es un punto único de fallo. La latencia puede ser alta, aunque el número de mensajes es lineal
.
Anillo Circular
	
(2N)−1 mensajes
.
	
El número de mensajes es lineal (similar a la centralizada)
. Sin embargo, el esquema de comunicación es inherentemente lineal y lento para este tipo de problema. La solución requiere que los mensajes circulen dos veces completas por el anillo, lo que lleva a tiempos muy diferentes que la centralizada, ya que cada proceso espera secuencialmente
.
Totalmente Conectada (Simétrica)
	
N(N−1) mensajes
.
	
Utiliza el mayor número de mensajes si no se dispone de broadcast
. Todos los procesos ejecutan el mismo algoritmo, y todos tienen acceso a todos los datos. Si la red soporta transmisiones concurrentes, puede ser muy rápida (shortest), pero el overhead de comunicación limita el speedup. Si se dispone de primitiva broadcast, el número de mensajes se reduce a N
.
Árbol y Grilla Bidimensional
	
(No detallado en las fuentes).
	
Las fuentes mencionan árboles y grafos para estructuras dinámicas y búsquedas
, y el paradigma pipeline y heartbeat se usan para cálculos en cuadrículas
. Sin embargo, las fuentes no proporcionan un análisis explícito del número de mensajes o la performance global para el problema de la suma en arquitecturas de Árbol o Grilla Bidimensional.
b) Escriba las soluciones para las arquitecturas mencionadas.
Adaptaremos los ejemplos de intercambio de valores de las fuentes (basados en PMA) para el cálculo de la suma.
1. Arquitectura en Estrella (Centralizada)
Un proceso central (P) recopila todos los valores, calcula la suma y la reenvía.

chan valores(int), resultados[n-1] (int sumaTotal);

Process P { 
    int v; // Valor inicial de P
    int nuevo;
    int suma = v;
    
    for [i=1 to n-1] { 
        receive valores (nuevo); 
        suma = suma + nuevo; 
    } 
    
    // El procesador central propaga la suma total
    for [i=1 to n-1] 
        send resultados [i-1] (suma);
}

Process P[i=1 to n-1] { 
    int v; // Valor inicial de P[i]
    int sumaTotal;
    
    send valores (v); // Envía valor al central
    receive resultados[i-1](sumaTotal); // Recibe la suma total
}

2. Arquitectura Totalmente Conectada (Simétrica)
Cada proceso envía su valor local a todos los demás y recibe N−1 valores, calculando la suma total de forma paralela
.

chan valores[n] (int);

Process P[i=0 to n-1]  { 
    int v=...; // Valor inicial de P[i]
    int nuevo;
    int suma = v;
    
    // Enviar valor local a todos los demás
    for [k=0 to n-1 st k <> i ] 
        send valores[k] (v);
    
    // Recibir valores de todos los demás
    for [k=0 to n-1 st k <> i ] { 
        receive valores[i] (nuevo); 
        suma = suma + nuevo; // Acumular la suma
    } 
    // Al finalizar, 'suma' contiene la suma total en P[i].
}

3. Arquitectura en Anillo Circular
Se utiliza un esquema de dos etapas: una pasada para acumular la suma y una segunda pasada para propagar la suma total
.

chan valor_suma[n] (int);

Process P  { 
    int v=...; // Valor inicial de P
    int suma_recibida;
    
    // Etapa 1: P arranca la acumulación (send valor inicial)
    send valor_suma[1] (v);
    receive valor_suma (suma_recibida); // P recibe la suma total
    
    // Etapa 2: Propagar la suma total
    send valor_suma[1] (suma_recibida);
    // P tiene la suma en 'suma_recibida'.
}

Process P[i=1 to n-1]  { 
    int v=...; // Valor inicial de P[i]
    int suma_recibida;
    
    // Etapa 1: Acumular
    receive valor_suma[i] (suma_recibida);
    suma_recibida = suma_recibida + v;
    send valor_suma[(i+1) mod n] (suma_recibida);
    
    // Etapa 2: Recibir y Propagar la suma final
    receive valor_suma[i] (suma_recibida);
    if (i < n-1) 
        send valor_suma[i+1] (suma_recibida);
    // P[i] tiene la suma en 'suma_recibida'.
};

Nota sobre Árbol y Grilla Bidimensional: Las soluciones específicas para calcular la suma total en arquitecturas de Árbol y Grilla Bidimensional no están disponibles en las fuentes proporcionadas.

--------------------------------------------------------------------------------
## 8- Marque similitudes y diferencias entre los mecanismos RPC y Rendezvous. Ejemplifique para la resolución de un problema a su elección.
RPC (Remote Procedure Call) y Rendezvous son mecanismos de comunicación y sincronización diseñados principalmente para el patrón Cliente/Servidor
.
Similitudes
1. Patrón C/S: Ambos son ideales para programar aplicaciones Cliente/Servidor
.
2. Interfaz Procedural: Ambos combinan una interfaz "tipo monitor" (llamadas externas CALL)
.
3. Sincronía Implícita: Ambos utilizan mensajes sincrónicos de manera implícita, demorando al llamador (cliente) hasta que la operación remota termine de ejecutarse y se devuelvan los resultados
.
4. Canal Bidireccional: Ambos suponen un canal bidireccional para manejar la solicitud y la respuesta
.
Diferencias (Difieren en cómo se sirve la invocación)
Característica
	
RPC (Remote Procedure Call)
	
Rendezvous
Servicio de Invocación
	
Crea un nuevo proceso (servidor) para manejar conceptualmente cada llamado
.
	
Hace rendezvous con un proceso existente (el proceso servidor único)
.
Sincronización Interna
	
Solo provee comunicación intermódulo. La Exclusión Mutua y Sincronización por Condición deben programarse aparte dentro del módulo
.
	
Combina comunicación y sincronización
. Las operaciones se atienden típicamente una por vez (secuencialmente)
.
Mecanismo de Servicio
	
El servidor implementa procedures (proc opname) llamados remotamente
.
	
El servidor utiliza una sentencia de Entrada (in o accept) para esperar, procesar la invocación y devolver los resultados
.
Vista del Cliente
	
El cliente siente que tiene el proceso remoto en su sitio
.
	
El cliente invoca un call a un proceso activo existente
.
Ejemplo: Buffer Limitado con Rendezvous
El problema del Buffer Limitado ilustra claramente cómo Rendezvous combina comunicación y sincronización usando un único proceso servidor y comunicación guardada, algo que RPC no logra por sí mismo
.
En este ejemplo, el proceso Buffer (servidor) solo atiende depositar si la capacidad es menor a N, y solo atiende retirar si la capacidad es mayor a 0, garantizando la sincronización y exclusión mutua implícitamente
.

module BufferLimitado
op depositar (typeT), retirar (OUT typeT);
body .
process Buffer
{ queue buf;
int cantidad = 0;
while (true)
{  
    in depositar (item) and cantidad < n →   // Guarda: solo acepta si hay espacio
        push (buf, item);
        cantidad = cantidad + 1;
     retirar (OUT item) and cantidad > 0 →   // Guarda: solo acepta si hay elementos
        pop (buf, item);
        cantidad = cantidad - 1;
    ni
}
}
end BufferLimitado

• Cliente (Llamador): Un proceso cliente simplemente haría call BufferLimitado.depositar(dato)
.
• Servidor (Buffer): El proceso Buffer espera en la sentencia in. Si ambas guardas son exitosas, elige no determinísticamente cuál atender
. Una vez que se elige la entrada (ej: depositar), se ejecuta el código asociado, y solo entonces el cliente llamador puede continuar.

## 9- Describa sintéticamente las características de sincronización y comunicación de ADA. Indicar que diferencia hay entre la comunicación guardada de Rendezvous (general) con la provista por ADA.
🎯 Características de Sincronización y Comunicación en ADA
ADA, desarrollado por el Departamento de Defensa de USA, utiliza el modelo de tareas para la concurrencia
. Sus principales características son:
1. Tasks (Tareas): El programa se organiza en tareas que pueden ejecutarse independientemente y contienen primitivas de sincronización
.
1. Rendezvous: Es el mecanismo principal de sincronización y comunicación
. Es un mecanismo sincrónico
.
1. Entrys: Son los puntos de invocación de una tarea, especificados en la parte visible (header) de la misma
.
1. Entry Call: Los procesos cliente invocan una operación usando un entry call (Tarea.entry (parámetros)), el cual es bloqueante y demora al llamador hasta que la operación termine
.
1. Accept: La tarea servidora utiliza la primitiva accept para servir los llamados a un entry específico
. La tarea se demora hasta que haya una invocación pendiente para ese entry
.
1. Sentencia Wait Selectiva: Soporta la comunicación guardada mediante la estructura select
.
🔄 Diferencia entre Comunicación Guardada de Rendezvous (General) y ADA
El Rendezvous general, como se describe en las fuentes (por ejemplo, en el contexto de módulos con la sintaxis in...ni), y la implementación en ADA cumplen la misma función: permitir la espera selectiva no determinística sobre múltiples invocaciones de operaciones, posiblemente condicionadas
.
La diferencia clave radica en la sintaxis y las capacidades de control directo sobre la selección:
Característica
	
Rendezvous General (Sintaxis in...ni)
	
Rendezvous en ADA (Sintaxis select...accept)
Estructura
	
Utiliza in opname (formales) and B by e → S; ni
.
	
Utiliza select when B => accept E; sentencias; or... end select;
.
Expresión de Sincronización (Guarda)
	
Se define como Bi​ (opcional) dentro de la alternativa
.
	
Se define con la cláusula WHEN (opcional) antes del ACCEPT
.
Expresión de Scheduling
	
Puede incluir una expresión de scheduling opcional (ei​) para influir en la elección del llamador
.
	
Utiliza atributos del entry como count para la gestión
, pero el mecanismo by e no está directamente detallado en la sintaxis provista para select/accept.
En resumen, ADA implementa la comunicación guardada mediante su sentencia select junto con la primitiva accept y la cláusula when para las condiciones
, mientras que la descripción general del Rendezvous usa la estructura in...ni con la posibilidad explícita de expresiones de sincronización (Bi​) y scheduling (ei​)
.

--------------------------------------------------------------------------------

## 10- Considere el problema de lectores/escritores. Desarrolle un proceso servidor para implementar el acceso a la base de datos, y muestre las interfaces de los lectores y escritores con el servidor. Los procesos deben interactuar: a) con mensajes asincrónicos; b) con mensajes sincrónicos; c) con RPC; d) con Rendezvous.
El problema de Lectores/Escritores requiere un proceso Servidor (o Scheduler) que controle el acceso a una base de datos (BD). Los lectores pueden acceder concurrentemente, pero los escritores deben tener acceso exclusivo
.
El servidor debe exponer las siguientes cuatro operaciones, independientemente del mecanismo:
1. InicioLeer: Petición de un lector.
2. FinLeer: Notificación de que un lector ha terminado.
3. InicioEscribir: Petición de un escritor.
4. FinEscribir: Notificación de que un escritor ha terminado.
El estado interno del servidor necesita una variable para contar los lectores activos (numLect)
.
a) Solución con Mensajes Asincrónicos (PMA)
Para implementar el patrón Cliente/Servidor con PMA, necesitamos un canal de requerimientos general y canales de respuesta privados para cada cliente
. La implementación simula un monitor activo
.
Definiciones de Canales: Necesitamos identificar al cliente y el tipo de operación
.

type clase_op = enum(InicioLeer, FinLeer, InicioEscribir, FinEscribir);
// Respuesta simple (ACK) o tipo de dato de la BD si la BD fuera accesible
chan request (int idCliente, clase_op oper); 
chan respuesta[n] (); // Array de canales de respuesta, uno por cliente

Interfaz del Cliente (Lector/Escritor):

Process Lector [i = 1 to n] {
    // 1. Pide empezar a leer
    send request(i, InicioLeer);
    receive respuesta[i](); 
    // ... Usa la BD ...
    // 2. Notifica el fin de la lectura
    send request(i, FinLeer); 
    receive respuesta[i](); 
}

Process Escritor [i = 1 to n] {
    // 1. Pide empezar a escribir
    send request(i, InicioEscribir);
    receive respuesta[i]();
    // ... Usa la BD (exclusivamente) ...
    // 2. Notifica el fin de la escritura
    send request(i, FinEscribir);
    receive respuesta[i]();
}

Proceso Servidor (Scheduler) (Simplificado, adaptando la lógica de
 para salvar pedidos):
El servidor debe usar un mecanismo para salvar pedidos pendientes (wait) si no se puede acceder inmediatamente, y luego recuperar/procesar el pedido (signal) cuando se libere el recurso
. Necesitaría colas internas para lectores y escritores pendientes.

Process Sched {
    int numLect = 0;
    queue pendientesEscritores, pendientesLectores;
    
    while (true) {
        // Recibe cualquier tipo de requerimiento
        receive request (IdCliente, oper); 
        
        if (oper == InicioLeer) {
            // Lógica para InicioLeer: solo si no hay escritores esperando
            // ... (Se debe implementar lógica de prioridad) ... 
            // Si el acceso es posible: 
            numLect = numLect + 1;
            send respuesta[IdCliente](); // Permite la lectura

            // Si el acceso NO es posible, guardar IdCliente en pendientesLectores
            // (Esta lógica de guardado es compleja y requiere definir el criterio de espera) [17, 18].

        } elsif (oper == InicioEscribir) {
            if (numLect == 0) {
                numLect = -1; // Marcador para exclusividad de escritor
                send respuesta[IdCliente]();
            } else {
                push (pendientesEscritores, IdCliente); // Salvar pedido pendiente [15]
            }
        } elsif (oper == FinLeer) {
            numLect = numLect - 1;
            send respuesta[IdCliente]();
            // Lógica para despertar escritores pendientes si numLect llega a 0 [18].
        } elsif (oper == FinEscribir) {
            // Lógica para despertar lectores/escritores pendientes [18].
            numLect = 0; // Liberar recurso
            send respuesta[IdCliente]();
        }
    }
}

b) Solución con Mensajes Sincrónicos (PMS)
Utilizar PMS directamente es más complejo para C/S
, especialmente cuando se requiere demorar el servicio (como en InicioEscribir si hay lectores), ya que las primitivas son bloqueantes y el Send del cliente se detiene hasta que el servidor recibe el mensaje
.
La principal desventaja es que, si un lector (L) envía FinLeer (liberando el recurso), L se detiene hasta que el servidor recibe el mensaje, aunque no haya razón para la demora
. Para una solución pura en PMS que maneje la sincronización de manera eficiente, se requeriría un proceso buffer adicional para desacoplar el emisor del receptor
.
c) Solución con RPC (Remote Procedure Call)
RPC es ideal para C/S porque combina la interfaz procedural (como un monitor) con mensajes sincrónicos bidireccionales implícitos
. El servidor se implementa como un Módulo que exporta procedimientos
.
Módulo Servidor (Scheduler):
El módulo exporta los cuatro procedimientos. Asumiendo que los procesos dentro del módulo ejecutan concurrentemente, se necesitaría sincronización interna (monitores o semáforos) para proteger la variable numLect
.

module Scheduler
op InicioLeer (INT idCliente);
op FinLeer (INT idCliente);
op InicioEscribir (INT idCliente);
op FinEscribir (INT idCliente);

body
INT numLect = 0;
SEM mutex = 1; // Para EM sobre numLect
SEM espera_escritor = 0; // Para sincronización
...
proc InicioLeer (idCliente) {
    P(mutex);
    // Lógica de espera si hay escritores
    V(mutex);
}
... // Definiciones similares para FinLeer, InicioEscribir, FinEscribir
end Scheduler;

Interfaz del Cliente (Lector/Escritor):
El cliente llama al procedimiento remoto como si fuera un procedimiento local
.

Process Lector [i = 1 to n] {
    // 1. Pide empezar a leer
    call Scheduler.InicioLeer(i);
    // ... Usa la BD ...
    // 2. Notifica el fin de la lectura
    call Scheduler.FinLeer(i); 
}

Process Escritor [i = 1 to n] {
    // 1. Pide empezar a escribir
    call Scheduler.InicioEscribir(i);
    // ... Usa la BD ...
    // 2. Notifica el fin de la escritura
    call Scheduler.FinEscribir(i);
}

d) Solución con Rendezvous
Rendezvous combina comunicación y sincronización, y el servicio lo brinda un proceso existente activo
. Utiliza comunicación guardada (in/ni o select/accept) para manejar la selección no determinística y las condiciones de acceso
.
El esquema de Rendezvous para Lectores/Escritores es proporcionado en las fuentes, utilizando la sintaxis de ADA
:
Estructura del Servidor (Task Sched):
El servidor utiliza la variable numLect para controlar el acceso y las guardas when para condicionar los accept
. El InicioEscribir solo se acepta si numLect es cero, o si no hay peticiones pendientes de otros escritores (InicioEscribir'Count = 0).

Task body Sched is
    numLect: integer := 0; // Contador de lectores
Begin
    Loop
        Select
            // Condición para Lectores: Si NO hay escritores esperando (count=0)
            When InicioEscribir'Count = 0 => 
                accept InicioLeer; // Permite la lectura
                numLect := numLect+1;
            or accept FinLeer; 
                numLect := numLect-1;
            // Condición para Escritores: Si NO hay lectores activos (numLect=0)
            or When numLect = 0 => 
                accept InicioEscribir; // Bloquea y espera al escritor
                accept FinEscribir; // Espera a que el escritor termine
                
                // Lógica para despertar lectores encolados después de la escritura
                For i in 1..InicioLeer‘count loop 
                    accept InicioLeer;
                    numLect:= numLect +1;
                End loop;
        End select;
    End loop;
End Sched;

Interfaz del Cliente (Lector/Escritor):
Los clientes realizan un entry call
.

// Lector
Loop
    Sched.InicioLeer; // Llama al entry (se bloquea hasta que Sched lo acepta)
    // ... Usa la BD ...
    Sched.FinLeer; // Notifica el fin
End loop;

// Escritor
Loop
    Sched.InicioEscribir; // Se bloquea hasta que Sched lo acepta (numLect=0)
    // ... Usa la BD ...
    Sched.FinEscribir; // Notifica el fin
End loop;
