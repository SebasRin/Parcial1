defmodule Reportes do
  @moduledoc """

  """



  def reporte_r1(confeccionistas, lineas, lotes_err) do


    Enum.each(lotes_err, fn lote ->
      result = Validacion.validacion_lote(confeccionistas, lineas, lote)
      motivo = elem(result, 1)

      IO.puts("#{lote}, Motivo: #{motivo}")
    end)

    conteo =
    Enum.reduce(lotes_err, %{
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

  end

  def reporte_r2()

end
