Code.require_file("datos.exs")
Code.require_file("validacion.exs")
Code.require_file("liquidacion.exs")
Code.require_file("reportes.exs")

defmodule Programa do

  @moduledoc """
  Punto de entrada del sistema de producción.

  Orquesta el flujo completo: lee los datos, separa los lotes en
  válidos y rechazados, y ejecuta los reportes R1 a R8. Los efectos
  secundarios (leer datos, imprimir) están concentrados aquí.
  """


  @doc """
  Ejecuta el flujo principal del sistema.

  1. Lee los datos base desde Datos.
  2. Separa los lotes en válidos y rechazados.
  3. Imprime los reportes R1 a R8.
  """

  def main do
    confeccionistas = Datos.confeccionistas()
    lineas = Datos.lineas()
    lotes = Datos.lotes()
    lotes_ok = Validacion.lotes_ok(confeccionistas, lineas, lotes)
    lotes_error = Validacion.lotes_error(confeccionistas, lineas, lotes)

    
    Reportes.reporte_r1(confeccionistas, lineas, lotes_error)
    Reportes.reporte_r2(lineas, lotes_ok)
    Reportes.reporte_r3(lotes_ok)
    Reportes.reporte_r4(confeccionistas, lotes_ok)
    Reportes.reporte_r5(lotes_ok)


    end




end
Programa.main()
