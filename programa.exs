Code.require_file("datos.exs")
Code.require_file("validacion.exs")
Code.require_file("liquidacion.exs")
Code.require_file("reportes.exs")

defmodule Programa do

  @moduledoc """

  """
    def main do
    confeccionistas = Datos.confeccionistas()
    lineas = Datos.lineas()
    lotes = Datos.lotes()

    lotes_ok = lotes_ok(confeccionistas, lineas, lotes)
    lotes_error = lotes_error(confeccionistas, lineas, lotes)

    Reportes.reporte_r1(confeccionistas, lineas, lotes_error)
    Reportes.reporte_r2(lineas, lotes_ok)
    Reportes.reporte_r3(lotes_ok)
    Reportes.reporte_r4(confeccionistas, lotes_ok)
    Reportes.reporte_r5(lotes)


    end


    defp lotes_ok(confeccionistas, lineas, lotes) do
      Enum.filter(lotes, fn lote ->
        match?({:ok, _},Validacion.validacion_lote(confeccionistas, lineas, lote))
      end)

    end

    defp lotes_error(confeccionistas, lineas, lotes)do
      Enum.filter(lotes, fn lote ->
        match?({:error, _},Validacion.validacion_lote(confeccionistas, lineas, lote))
      end)
    end

end
Programa.main()
