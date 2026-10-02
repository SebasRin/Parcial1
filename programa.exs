Code.require_file("datos.exs")
Code.require_file("validacion.exs")
Code.require_file("liquidacion.exs")

defmodule Programa do

  @moduledoc """

  """



  def main do
    confeccionistas = Datos.confeccionistas()
    lineas = Datos.lineas()
    Validacion.validacion_lote(confeccionistas, lineas, %{confeccionista: "C01", linea: "L1", dia: 2, prendas: 70, defectos: 5})
    |> IO.inspect()

    Liquidacion.valor_lote(%{confeccionista: "C01", linea: "L1", dia: 2, prendas: 70, defectos: 10})
    |> IO.puts()


  end

end
Programa.main()
