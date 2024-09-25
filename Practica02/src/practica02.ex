defmodule Grafica do
  @doc """
  Inicia el proceso de la gráfica con un estado inicial por defecto que incluye si ha sido visitado, el ID del nodo, el líder y los vecinos.

  ## Parámetros
    - `estado_inicial`: El estado inicial del nodo (por defecto, no visitado, ID -1, sin líder y sin vecinos).
  """
  def inicia(estado_inicial \\ %{:visitado => false, :id => -1, :lider_id => nil, :vecinos => []}) do
    recibe_mensaje(estado_inicial)
  end

  @doc """
  Recibe un mensaje y procesa el estado del nodo según el mensaje recibido.
  
  ## Parámetros
    - `estado`: El estado actual del nodo.
  """
  def recibe_mensaje(estado) do
    receive do
      mensaje ->
        {:ok, nuevo_estado} = procesa_mensaje(mensaje, estado)
        recibe_mensaje(nuevo_estado)
    end
  end

  @doc """
  Procesa un mensaje enviado al nodo y actualiza el estado en consecuencia.
  
  ## Mensajes soportados
    - `{:id, id}`: Asigna un ID al nodo.
    - `{:vecinos, vecinos}`: Asigna los vecinos del nodo.
    - `{:inicia}`: Inicia la elección del líder desde el nodo.
    - `{:eleccion, nuevo_lider_id}`: Propaga el nuevo líder a los vecinos.
    - `{:ya}`: Verifica si el nodo ha sido visitado y reporta el estado de la elección del líder.

  ## Parámetros
    - `mensaje`: El mensaje recibido por el nodo.
    - `estado`: El estado actual del nodo.

  ## Retorno
    - `{:ok, nuevo_estado}`: El nuevo estado del nodo después de procesar el mensaje.
  """
  def procesa_mensaje({:id, id}, estado) do
    estado = Map.put(estado, :id, id)
    {:ok, estado}
  end

  @doc """
  Asigna los vecinos al nodo y actualiza su estado.
  """
  def procesa_mensaje({:vecinos, vecinos}, estado) do
    estado = Map.put(estado, :vecinos, vecinos)
    {:ok, estado}
  end

  @doc """
  Inicia el proceso de elección desde el nodo actual.
  """
  def procesa_mensaje({:inicia}, estado) do
    %{:id => id} = estado
    IO.puts("Soy el nodo #{id} y yo comienzo la elección.")
    iniciar_eleccion(id, estado)  
    {:ok, estado}
  end

  @doc """
  Procesa la elección de un nuevo líder y propaga el mensaje a los vecinos si es necesario.
  """
  def procesa_mensaje({:eleccion, nuevo_lider_id}, estado) do
    %{:id => id, :lider_id => lider_id_viejo, :vecinos => vecinos} = estado
    cond do
      lider_id_viejo == nil or nuevo_lider_id < lider_id_viejo ->
        IO.puts("Soy el nodo #{id} y acepto a #{nuevo_lider_id} como mi nuevo líder.")
        estado = Map.put(estado, :lider_id, nuevo_lider_id)
        Enum.each(vecinos, fn vecino ->
          send(vecino, {:eleccion, nuevo_lider_id})
        end)
        {:ok, estado}

      true ->
        {:ok, estado}
    end
  end

  @doc """
  Verifica si el nodo ha sido visitado y reporta el estado del proceso de elección.
  """
  def procesa_mensaje({:ya}, estado) do
    %{:id => id, :visitado => visitado, :lider_id => lider_id} = estado
    if visitado do
      IO.puts("Soy el nodo #{id} y ya me visitaron")
    else
      IO.puts("Soy el nodo #{id} y no me visitaron, la gráfica no es conexa")
    end

    if lider_id do
      IO.puts("Soy el nodo #{id} y mi líder actual es #{lider_id}.")
    else
      IO.puts("Soy el nodo #{id} y aún no se ha determinado el líder.")
    end
    {:ok, estado}
  end

  @doc """
  Inicia el proceso de elección de un líder propagando el ID del líder a todos los vecinos.
  """
  def iniciar_eleccion(lider_id, estado) do
    %{:vecinos => vecinos} = estado
    Enum.each(vecinos, fn vecino -> send(vecino, {:eleccion, lider_id}) end)
    {:ok, estado}
  end
end


q = spawn(Grafica, :inicia, [])
r = spawn(Grafica, :inicia, [])
s = spawn(Grafica, :inicia, [])
t = spawn(Grafica, :inicia, [])
u = spawn(Grafica, :inicia, [])
v = spawn(Grafica, :inicia, [])
w = spawn(Grafica, :inicia, [])
x = spawn(Grafica, :inicia, [])
y = spawn(Grafica, :inicia, [])
z = spawn(Grafica, :inicia, [])

# Asignar IDs a los procesos
send(q, {:id, 17})
send(r, {:id, 18})
send(s, {:id, 19})
send(t, {:id, 20})
send(u, {:id, 21})
send(v, {:id, 22})
send(w, {:id, 23})
send(x, {:id, 24})
send(y, {:id, 25})
send(z, {:id, 26})

send(q, {:vecinos, [s]})
send(r, {:vecinos, [s]})
send(s, {:vecinos, [q, r]})
send(t, {:vecinos, [w, x]})
send(u, {:vecinos, [y, z]})
send(v, {:vecinos, [x]})
send(w, {:vecinos, [t, x]})
send(x, {:vecinos, [t, v, w, y]})
send(y, {:vecinos, [u, x, z]})
send(z, {:vecinos, [y]})

send(r,{:inicia})


# Pausa para permitir que los mensajes se propaguen
:timer.sleep(1000)

IO.puts("----------------------------------------------")
IO.puts("Verificando conexidad de la grafica")
IO.puts("----------------------------------------------")

:timer.sleep(1000)
send(t, {:ya})
:timer.sleep(1000)
send(u, {:ya})
:timer.sleep(1000)
send(v, {:ya})
:timer.sleep(1000)
send(w, {:ya})
:timer.sleep(1000)
send(x, {:ya})
:timer.sleep(1000)
send(y, {:ya})
:timer.sleep(1000)
send(z, {:ya})
:timer.sleep(1000)
send(q, {:ya})
:timer.sleep(1000)
send(r, {:ya})
:timer.sleep(1000)
send(s, {:ya})
