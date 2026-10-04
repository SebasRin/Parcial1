defmodule Reportes do
  @moduledoc """

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

  def reporte_r3(lotes) do
    IO.puts("=======================================================")
    IO.puts("Reporte 3")
    rango_dias = 1..6

    suma_prendas =
    Enum.reduce(lotes, %{}, fn lote, acc ->
      Map.update(acc, lote.dia, lote.prendas, &(&1 + lote.prendas))
    end)

    mapa =
    Enum.map(rango_dias, fn dia ->
      prendas = Map.get(suma_prendas, dia, 0)
      %{dia: dia, prendas: prendas, alcanzo_meta: prendas >= 600}
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


  def reporte_r5(lotes) do
    rango_dias = 1..6
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



end
