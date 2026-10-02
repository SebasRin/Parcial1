Code.require_file("datos.exs")
Code.require_file("validacion.exs")

defmodule Programa do

  @moduledoc """

  """



  def main do
    confeccionistas = Datos.confeccionistas()
    lineas = Datos.lineas()
    Validacion.validacion_lote(confeccionistas, lineas, %{confeccionista: "C01", linea: "L1", dia: 7, prendas: 70, defectos: "5"})
    |> IO.inspect()
  end

end
Programa.main()
