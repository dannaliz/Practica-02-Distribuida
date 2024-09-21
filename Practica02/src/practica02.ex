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

p1 = spawn(Grafica, :inicia, [])
p2 = spawn(Grafica, :inicia, [])
p3 = spawn(Grafica, :inicia, [])
p4 = spawn(Grafica, :inicia, [])
p5 = spawn(Grafica, :inicia, [])
p6 = spawn(Grafica, :inicia, [])

# Asignar IDs a los procesos
send(p1, {:id, 1})
send(p2, {:id, 2})
send(p3, {:id, 3})
send(p4, {:id, 4})
send(p5, {:id, 5})
send(p6, {:id, 6})

send(p1, {:vecinos, [p2, p3, p6]})
send(p2, {:vecinos, [p1, p3, p5]})
send(p3, {:vecinos, [p1, p2, p4]})
send(p4, {:vecinos, [p3, p5, p6]})
send(p5, {:vecinos, [p2, p4, p6]})
send(p6, {:vecinos, [p1, p4, p5]})

# Iniciar la propagación desde el proceso raíz
send(p1, {:inicia})

# Pausa para permitir que los mensajes se propaguen
:timer.sleep(1000)

IO.puts("----------------------------------------------")
IO.puts("Verificando conexidad de la grafica")
IO.puts("----------------------------------------------")
:timer.sleep(1000)
send(p1, {:ya})
:timer.sleep(1000)
send(p2, {:ya})
:timer.sleep(1000)
send(p3, {:ya})
:timer.sleep(1000)
send(p4, {:ya})
:timer.sleep(1000)
send(p5, {:ya})
:timer.sleep(1000)
send(p6, {:ya})
