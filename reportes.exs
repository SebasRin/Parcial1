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
end
