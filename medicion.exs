# Mide con :timer.tc/1 (devuelve {microsegundos, resultado}):
#   1. Buscar 1.000 códigos entre 100.000 confeccionistas: lista con Enum.find/2 vs mapa.
#   2. Construir una lista de 20.000 elementos: ++ (al final) vs [elemento | lista] (al inicio).
# Cada medición se repite 3 veces.

repeticiones = 3


:rand.seed(:exsss, {1, 2, 3})


confeccionistas =
  Enum.map(1..100_000, fn i ->
    %{codigo: "C#{i}", nombre: "Confeccionista #{i}", alquiler: rem(i, 2) == 0}
  end)

indice = Map.new(confeccionistas, fn c -> {c.codigo, c} end)

codigos = Enum.map(1..1_000, fn _ -> "C#{Enum.random(1..100_000)}" end)


buscar_en_lista = fn ->
  Enum.each(codigos, fn codigo ->
    Enum.find(confeccionistas, fn c -> c.codigo == codigo end)
  end)
end

buscar_en_mapa = fn ->
  Enum.each(codigos, fn codigo -> Map.get(indice, codigo) end)
end

construir_con_concatenacion = fn ->
  Enum.reduce(1..20_000, [], fn elemento, acc -> acc ++ [elemento] end)
end

construir_al_inicio = fn ->
  Enum.reduce(1..20_000, [], fn elemento, acc -> [elemento | acc] end)
end


formato = fn numero -> :erlang.float_to_binary(numero / 1, decimals: 2) end

medir = fn nombre, funcion ->
  tiempos =
    for _ <- 1..repeticiones do
      {microsegundos, _resultado} = :timer.tc(funcion)
      microsegundos / 1000
    end

  promedio = Enum.sum(tiempos) / length(tiempos)
  detalle = Enum.map_join(tiempos, " | ", formato)

  IO.puts("#{nombre}")
  IO.puts("  corridas (ms): #{detalle}")
  IO.puts("  promedio (ms): #{formato.(promedio)}")
  IO.puts("")
  promedio
end

IO.puts("=== 1. Buscar 1.000 códigos entre 100.000 confeccionistas ===")
t_lista = medir.("Lista con Enum.find/2", buscar_en_lista)
t_mapa = medir.("Mapa indexado por código (Map.get/2)", buscar_en_mapa)

IO.puts("La lista fue #{formato.(t_lista / max(t_mapa, 0.001))} veces más lenta que el mapa.")
IO.puts("")

IO.puts("=== 2. Construir una lista de 20.000 elementos ===")
t_final = medir.("Agregando al final con ++", construir_con_concatenacion)
t_inicio = medir.("Agregando al inicio con [elemento | lista]", construir_al_inicio)

IO.puts("Agregar al final fue #{formato.(t_final / max(t_inicio, 0.001))} veces más lento que agregar al inicio.")
