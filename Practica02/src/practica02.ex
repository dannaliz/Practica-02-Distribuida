defmodule Grafica do

  def inicia(estado_inicial \\ %{:visitado => false, :raiz => false, :id => -1}) do
    recibe_mensaje(estado_inicial)
  end

  def recibe_mensaje(estado) do
    receive do
      mensaje ->
        {:ok, nuevo_estado} = procesa_mensaje(mensaje, estado)
        recibe_mensaje(nuevo_estado)
    end
  end

  # Agrupar todas las definiciones de la función procesa_mensaje/2
  def procesa_mensaje({:id, id}, estado) do
    estado = Map.put(estado, :id, id)
    {:ok, estado}
  end

  def procesa_mensaje({:vecinos, vecinos}, estado) do
    estado = Map.put(estado, :vecinos, vecinos)
    {:ok, estado}
  end

  def procesa_mensaje({:mensaje, n_id}, estado) do
    estado = conexion(estado, n_id)
    {:ok, estado}
  end

  def procesa_mensaje({:inicia}, estado) do
    estado = Map.put(estado, :raiz, true)
    estado = conexion(estado)
    {:ok, estado}
  end

  def procesa_mensaje({:ya}, estado) do
    %{:id => id, :visitado => visitado} = estado
    if visitado do
      IO.puts("Soy el proceso #{id} y ya me visitaron")
    else
      IO.puts("Soy el proceso #{id} y no me visitaron, la gráfica no es conexa")
    end
    {:ok, estado}
  end

  # Función que hace la elección de lider, recibe un estado y ve 3 casos, uno en donde el id del nodo que tenemos es menor
  # que el id del lider, otro donde el id del lider es menor, por lo tanto el lider es el mismo que ya era, y el ultimo
  # caso donde el nodo no quiere ser lider pero da el mensaje de quien es el lider.

  def procesa_mensaje({:eleccion, lider_id}, estado) do
    %{:id => id, :lider => lider, :lider_id => lider_id_viejo, :soyLider => false} = estado
      cond do
        id < lider_id and lider ->
          IO.puts("Soy el nodo #{id} y me proclamo como lider.")
          Enum.each(Map.get(estado, :vecinos), fn vecino -> send(vecino, {:eleccion, id}) end)
          estado=Map.put(estado,:lider_id, id)
        lider_id_viejo < lider_id ->
          IO.puts("Soy nodo #{id} y acepto al nodo #{lider_id} como lider.")
          Enum.each(Map.get(estado, :vecinos), fn vecino -> send(vecino, {:eleccion, lider_id_viejo}) end)
        :soyLider == true ->
          IO.puts("Soy el nodo #{id} y no quiero ser lider, el lider es #{lider_id}.")
      end
    {:ok, estado}
  end

  def conexion(estado, n_id \\ nil) do
    %{:id => id, :vecinos => vecinos, :visitado => visitado, :raiz => raiz} = estado
    if raiz and not visitado do
      IO.puts("Soy el proceso inicial (#{id})")
      Enum.map(vecinos, fn vecino -> send(vecino, {:mensaje, id}) end)
      Map.put(estado, :visitado, true)
    else
      if n_id != nil and not visitado do
        IO.puts("Soy el proceso #{id} y mi padre es #{n_id}")
        Enum.map(vecinos, fn vecino -> send(vecino, {:mensaje, id}) end)
        Map.put(estado, :visitado, true)
      else
        estado
      end
    end
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

send(x,{:inicia})

# Iniciar la propagación desde el proceso raíz
send(s, {:inicia})


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
