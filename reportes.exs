defmodule Reportes do
  @moduledoc """
  Reportes del sistema de producción (R1 a R8).

  Los cálculos de conteo son puros, la impresión se realiza con
  IO.puts en cada función reporte.
  """

  @meta_diaria_taller 600
  @dias_produccion 6

  @doc """
  Imprime el reporte R1: lotes rechazados con su motivo y cantidad
  de rechazos por cada motivo.

  Recibe los confeccionistas, las líneas y la lista de lotes
  rechazados (sin motivo). Vuelve a validar cada lote para obtener
  el motivo.

  IA - Bitácora #6: conteo de rechazos por motivo con
  Enum.reduce y un mapa preinicializado con Map.update!/3.
  """

  def reporte_r1(confeccionistas, lineas, lotes_err) do

    rechazados =
      Enum.map(lotes_err, fn lote ->
        {:error, motivo} = Validacion.validacion_lote(confeccionistas, lineas, lote)
        {lote, motivo}
      end)

    IO.puts("==================================================================")
    IO.puts("Reporte 1")
    Enum.each(rechazados, fn {lote, motivo} ->
      IO.puts("#{inspect(lote)}, Motivo: #{motivo}")
    end)

    conteo =
    Enum.reduce(rechazados, %{
      confeccionista_desconocido: 0,
      linea_desconocida: 0,
      dia_invalido: 0,
      prendas_fuera_de_rango: 0,
      porcentaje_invalido: 0
    }, fn {_lote, motivo}, acc ->
      Map.update!(acc, motivo, &(&1 + 1))
    end)

    IO.puts("confeccionista_desconocido: #{conteo.confeccionista_desconocido}")
    IO.puts("linea_desconocida: #{conteo.linea_desconocida}")
    IO.puts("dia_invalido: #{conteo.dia_invalido}")
    IO.puts("prendas_fuera_de_rango: #{conteo.prendas_fuera_de_rango}")
    IO.puts("porcentaje_invalido: #{conteo.porcentaje_invalido}")

    IO.puts("=============================================================================")

  end

  @doc """
  Imprime el reporte R2: prendas elaboradas por línea y productividad
  semanal en prendas por puesto (prendas / puestos).

  Ordena de mayor a menor productividad. Las líneas sin lotes válidos
  aparecen con cero prendas.

  IA - Bitácora #3: ordenar por un campo descendente con
  Enum.sort_by/3.
  """

  def reporte_r2(lineas, lotes) do
    IO.puts("=======================================================")
    IO.puts("Reporte 2")
    prendas_totales=
    Enum.reduce(lotes,%{}, fn lote, acc ->
        Map.update(acc, lote.linea, lote.prendas, &(&1 + lote.prendas))
    end)
    Enum.map(lineas, fn linea ->
      prendas = Map.get(prendas_totales, linea.id, 0)
      productividad = prendas / linea.puestos

      %{id: linea.id, prendas: prendas, productividad: productividad}
    end)
    |> Enum.sort_by(&(&1.productividad), :desc)
    |> IO.inspect()

  end


  @doc """
  Imprime el reporte R3: prendas producidas por el taller en cada uno
  de los 6 días, indicando si se alcanzó la meta de 600 prendas.

  Los días sin lotes válidos aparecen con cero. Al final se indica si
  se alcanzó la meta todos los días y si se alcanzó al menos uno.
  """

  def reporte_r3(lotes) do
    IO.puts("=======================================================")
    IO.puts("Reporte 3")
    rango_dias = 1..@dias_produccion

    suma_prendas =
    Enum.reduce(lotes, %{}, fn lote, acc ->
      Map.update(acc, lote.dia, lote.prendas, &(&1 + lote.prendas))
    end)

    mapa =
    Enum.map(rango_dias, fn dia ->
      prendas = Map.get(suma_prendas, dia, 0)
      %{dia: dia, prendas: prendas, alcanzo_meta: prendas >= @meta_diaria_taller}
    end)

    Enum.each(mapa, fn dias ->
      IO.inspect(dias)
    end)

    todo_dias = Enum.all?(mapa, fn meta -> meta.alcanzo_meta end )
    algun_dia = Enum.any?(mapa, fn meta -> meta.alcanzo_meta end)
    IO.puts("Meta diaria: #{todo_dias}")
    IO.puts("Al menos un dia: #{algun_dia}")

    IO.puts("=======================================================")

  end


  @doc """
  Imprime el reporte R4: liquidación de todos los confeccionistas,
  numerada y ordenada por pago neto de mayor a menor.

  Muestra prendas, valor de lotes, bonificaciones, alquiler y pago
  neto. Los valores monetarios se imprimen con dos decimales y sin
  notación científica.

  IA - Bitácora #3 y #4: orden descendente por neto con
  Enum.sort_by/3 y numeración de filas con Enum.with_index(1).
  """

  def reporte_r4(confeccionista, lotes) do
      IO.puts("=========================================================")
      IO.puts("Reporte 4")
      lista = Liquidacion.liquidacion(confeccionista, lotes)

      Enum.sort_by(lista, &(&1.pago_neto), :desc)
      |> Enum.with_index(1)
      |> Enum.each(fn {liq, idx} ->
        IO.puts("##{idx}  #{liq.codigo}  #{liq.prendas} prendas")
        IO.puts("    Valor lote:   #{Util.formatter(liq.valor_lote)}")
        IO.puts("    Bonificación: #{Util.formatter(liq.bonificacion)}")
        IO.puts("    Alquiler:     #{Util.formatter(liq.alquiler)}")
        IO.puts("    Pago neto:    #{Util.formatter(liq.pago_neto)}")
        IO.puts("")
      end)

      IO.puts("=========================================================")
  end


  @doc """
  Imprime el reporte R5: confeccionista que produjo más prendas cada
  día (todos si hay empate) y quién ocupó el primer lugar más días al
  final.

  Los días sin lotes válidos se indican como tales. Si hay empate en
  el primer lugar, se incluyen todos los empatados.

  IA - Bitácora #5 y #7: conteo de días ganados con flat_map +
  Enum.frequencies, y lista de empatados como texto con Enum.join/2.
  """

  def reporte_r5(lotes) do
    rango_dias = 1..@dias_produccion
    mapa =
    Enum.reduce(lotes, %{}, fn lote, acc ->
      Map.update(acc, {lote.confeccionista, lote.dia}, lote.prendas, &(&1 + lote.prendas))
    end)

    mapa_ordenado = Enum.group_by(mapa, fn {{_confeccionista, dia}, _total} -> dia end)

    mapa_ganador =
    Enum.map(rango_dias, fn dia ->
      map_encontrado = Map.get(mapa_ordenado, dia, 0)
      if map_encontrado == 0 do
        %{dia: dia, ganadores: [], prendas: 0, sin_lotes: true}
      else
        max_prendas =
        Enum.map(map_encontrado, fn {{_confeccionista, _dia}, total} -> total end)
        |> Enum.max()

        ganadores =
          Enum.filter(map_encontrado, fn {{_confeccionista, _dia}, total} -> total == max_prendas end)
          |> Enum.map(fn {{confeccionista, _dia}, _total} -> confeccionista end)

        %{dia: dia, ganadores: ganadores, prendas: max_prendas, sin_lotes: false}

      end

    end)

    conteo_ganadores =
      Enum.flat_map(mapa_ganador, &(&1.ganadores))
      |> Enum.frequencies()

    max_dias =
      case Map.values(conteo_ganadores) do
        [] -> 0
        valores -> Enum.max(valores)
      end

    top =
      Enum.filter(conteo_ganadores, fn {_confeccionista, dias} -> dias == max_dias end)
      |> Enum.map(fn {confeccionistas, _dias} -> confeccionistas end)

    IO.puts("=============================================================")
    IO.puts("Reporte 5")

    Enum.each(mapa_ganador, fn g ->
      if g.sin_lotes do
        IO.puts("Dia #{g.dia}: sin lotes validos")
      else
        IO.puts("Dia #{g.dia}: #{Enum.join(g.ganadores, ", ")} con #{g.prendas} prendas")
      end
    end)

    IO.puts("Primer lugar mas dias")
    if max_dias == 0 do
      IO.puts("Nadie gano ningun dia")
    else
      IO.puts("#{Enum.join(top, ", ")} #{max_dias} dia")
    end


  end

  @doc """
  Imprime el reporte R6: Confeccionista con mejor calidad: menor porcentaje de
  defectos ponderado por prendas entre quienes tengan al menos 3 lotes válidos.
  """

  def reporte_r6(confeccionistas, lineas, lotes) do
    IO.puts("=======================================================")
    IO.puts("Reporte 6")

    lotes_validos =
      Enum.reduce(lotes, [], fn lote, acc ->
        case Validacion.validacion_lote(confeccionistas, lineas, lote) do
          {:ok, lote} ->
            [lote | acc]

          {:error, _motivo} ->
            acc
        end
      end)

    cantidad_lotes =
      Enum.reduce(lotes_validos, %{}, fn lote, acc ->
        Map.update(acc, lote.confeccionista, 1, fn cantidad ->
          cantidad + 1
        end)
      end)

    confeccionistas_validos =
      Enum.filter(cantidad_lotes, fn {_confeccionista, cantidad} ->
        cantidad >= 3
      end)

    resultados =
      Enum.map(confeccionistas_validos, fn {confeccionista, _cantidad} ->

        lotes_confeccionista =
          Enum.filter(lotes_validos, fn lote ->
            lote.confeccionista == confeccionista
          end)

        suma_ponderada =
          Enum.reduce(lotes_confeccionista, 0, fn lote, acc ->
            acc + lote.prendas * lote.defectos
          end)

        total_prendas =
          Enum.reduce(lotes_confeccionista, 0, fn lote, acc ->
            acc + lote.prendas
          end)

        porcentaje_ponderado = suma_ponderada / total_prendas

        %{
          confeccionista: confeccionista,
          lotes_validos: length(lotes_confeccionista),
          prendas: total_prendas,
          porcentaje_defectos: porcentaje_ponderado
        }
      end)

    resultados_ordenados =
      Enum.sort_by(
        resultados,
        &(&1.porcentaje_defectos),
        :asc
      )

    Enum.each(resultados_ordenados, fn resultado ->
      IO.puts(
        "Confeccionista: #{resultado.confeccionista}, " <>
        "Lotes válidos: #{resultado.lotes_validos}, " <>
        "Prendas: #{resultado.prendas}, " <>
        "Defectos ponderados: #{Float.round(resultado.porcentaje_defectos, 2)}%"
      )
    end)

    case resultados_ordenados do
      [] ->
        IO.puts("No hay confeccionistas con al menos 3 lotes válidos.")

      [primero | _] ->
        mejores =
          Enum.filter(resultados_ordenados, fn resultado ->
            resultado.porcentaje_defectos == primero.porcentaje_defectos
          end)

        IO.puts("-------------------------------------------------------")

        Enum.each(mejores, fn mejor ->
          IO.puts(
            "Mejor calidad: #{mejor.confeccionista} " <>
            "(#{Util.formatter(mejor.porcentaje_defectos)}% de defectos ponderado)")
        end)
    end
  end

  @doc """
  Imprime el Reporte R7: Total que debe pagar el taller durante la semana y
  costo promedio pagado por prenda válida (total pagado / total de prendas válidas).
  Si no hay prendas válidas, se debe indicar que el promedio no puede calcularse.
  """

  def reporte_r7(confeccionistas, lotes) do
    IO.puts("=======================================================")
    IO.puts("Reporte 7")

    liquidacion = Liquidacion.liquidacion(confeccionistas, lotes)

    total_pagado =
      liquidacion
      |> Enum.map(&(&1.pago_neto))
      |> Enum.sum()

    total_prendas_validas =
      liquidacion
      |> Enum.map(&(&1.prendas))
      |> Enum.sum()

    IO.puts("Total a pagar durante la semana: #{Util.formatter(total_pagado)}")

    if total_prendas_validas > 0 do
      promedio = total_pagado / total_prendas_validas

      IO.puts(
        "Costo promedio por prenda valida: #{Util.formatter(Float.round(promedio, 2))}"
      )
    else
      IO.puts("El promedio no puede calcularse porque no hay prendas válidas.")
    end
    end


  @doc """
  Imprime Reporte R8: Confeccionistas que elaboraron al menos un lote válido
  en todas las líneas de producción. Si no hay ninguno, debe indicarse.
  """
  def reporte_r8(confeccionistas, lineas, lotes) do
    IO.puts("=======================================================")
    IO.puts("Reporte 8")

    lotes_validos =
      Enum.filter(lotes, fn lote ->
        case Validacion.validacion_lote(confeccionistas, lineas, lote) do
          {:ok, _lote} -> true
          {:error, _motivo} -> false
        end
      end)

    lineas_produccion =
      Enum.map(lineas, &(&1.id))

    resultado =
      Enum.filter(confeccionistas, fn confeccionista ->
        lineas_del_confeccionista =
          lotes_validos
          |> Enum.filter(&(&1.confeccionista == confeccionista.codigo))
          |> Enum.map(&(&1.linea))
          |> Enum.uniq()

        Enum.all?(lineas_produccion, fn linea ->
          linea in lineas_del_confeccionista
        end)
      end)

    if resultado == [] do
      IO.puts("No hay confeccionistas que hayan elaborado")
      IO.puts("al menos un lote válido en todas las líneas de producción.")
    else
      IO.puts("Confeccionistas encontrados: ")

      Enum.each(resultado, fn confeccionista ->
        IO.puts("- #{confeccionista.codigo}")
      end)
    end
  end

    @doc """
  Imprime el comprobante individual de un confeccionista: nombre, código,
  detalle de cada día trabajado (solo días con al menos un lote válido),
  sumas, descuento por alquiler y neto. Si el código no existe, lo informa.
  """
  def comprobante(confeccionistas, codigo, lotes_ok) do
    case Enum.find(confeccionistas, nil, fn c -> c.codigo == codigo end) do
      nil ->
        IO.puts("El código #{codigo} no existe.")

      confe ->
        propios = Enum.filter(lotes_ok, fn lote -> lote.confeccionista == codigo end)
        [liq] = Liquidacion.liquidacion([confe], propios)
        por_dia = Enum.group_by(propios, fn lote -> lote.dia end)

        IO.puts("=======================================================")
        IO.puts("Comprobante: #{confe.nombre} (#{confe.codigo})")

        por_dia
        |> Map.keys()
        |> Enum.sort()
        |> Enum.each(fn dia ->
          lotes_dia = Map.fetch!(por_dia, dia)
          prendas = lotes_dia |> Enum.map(fn l -> l.prendas end) |> Enum.sum()
          valor = lotes_dia |> Enum.map(&Liquidacion.valor_lote/1) |> Enum.sum()
          bonificacion = Liquidacion.bonificacion_dia(prendas)

          IO.puts(
            "Día #{dia}: #{prendas} prendas | lotes: #{Util.formatter(valor)} | " <>
              "bonificación: #{Util.formatter(bonificacion)}"
          )
        end)

        IO.puts("Suma de lotes: #{Util.formatter(liq.valor_lote)}")
        IO.puts("Suma de bonificaciones: #{Util.formatter(liq.bonificacion)}")
        IO.puts("Descuento por alquiler: #{Util.formatter(liq.alquiler)}")
        IO.puts("Neto: #{Util.formatter(liq.pago_neto)}")
    end
  end

    @doc """
  Ordena las liquidaciones según una keyword list de opciones:
    campo:  :neto | :prendas | :bruto   (predeterminado :neto)
    orden:  :desc | :asc                (predeterminado :desc)
    limite: entero positivo             (predeterminado: todos)
  Un valor no reconocido se reemplaza por el predeterminado.
  """
  def ranking(liquidaciones, opciones) do
    campo = Keyword.get(opciones, :campo, :neto)
    orden = Keyword.get(opciones, :orden, :desc)
    limite = Keyword.get(opciones, :limite)

    clave =
      case campo do
        :prendas -> :prendas
        :bruto -> :valor_lote
        _ -> :pago_neto
      end

    sentido = if orden == :asc, do: :asc, else: :desc

    ordenadas = Enum.sort_by(liquidaciones, &Map.fetch!(&1, clave), sentido)

    if is_integer(limite) and limite > 0 do
      Enum.take(ordenadas, limite)
    else
      ordenadas
    end
  end



@doc "Imprime un ranking con su título."
def imprimir_ranking(titulo, filas) do
  IO.puts("=======================================================")
  IO.puts(titulo)

  filas
  |> Enum.with_index(1)
  |> Enum.each(fn {liq, idx} ->
    IO.puts(
      "##{idx} #{liq.codigo} | prendas: #{liq.prendas} | " <>
        "bruto: #{Util.formatter(liq.valor_lote)} | neto: #{Util.formatter(liq.pago_neto)}"
    )
  end)
end

    @doc "Producción del taller por día (1 a 6), con cero en los días sin lotes."
  def produccion_diaria(lotes) do
    acumulado =
      Enum.reduce(lotes, %{}, fn lote, acc ->
        Map.update(acc, lote.dia, lote.prendas, &(&1 + lote.prendas))
      end)

    Map.new(1..@dias_produccion, fn dia -> {dia, Map.get(acumulado, dia, 0)} end)
  end

  @doc """
  Combina la producción diaria propia con la de un taller aliado,
  sumando las prendas de los días presentes en ambos mapas.
  """
  def combinar_talleres(produccion_propia, taller_aliado) do
    Map.merge(produccion_propia, taller_aliado, fn _dia, propias, aliadas ->
      propias + aliadas
    end)
  end



end
