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

    Liquidacion.bonificacion_por_productividad([
      %{confeccionista: "C01", linea: "L1", dia: 1,
        prendas: 70, defectos: 1.5},
      %{confeccionista: "C01", linea: "L2", dia: 1,
        prendas: 55, defectos: 7},
      %{confeccionista: "C01", linea: "L2", dia: 1,
        prendas: 55, defectos: 7},
      %{confeccionista: "C02", linea: "L2", dia: 1,
        prendas: 55, defectos: 7}
      # ...
    ])

    Liquidacion.alquiler_maquinas([
      %{codigo: "C01", nombre: "María Elena Ríos", alquiler: true},
      %{codigo: "C02", nombre: "Andrés Salazar", alquiler: false}
      # ...
    ], [
      %{confeccionista: "C01", linea: "L1", dia: 1,
        prendas: 70, defectos: 1.5},
      %{confeccionista: "C01", linea: "L2", dia: 1,
        prendas: 55, defectos: 7},
      %{confeccionista: "C01", linea: "L2", dia: 1,
        prendas: 55, defectos: 7},
      %{confeccionista: "C02", linea: "L2", dia: 1,
        prendas: 55, defectos: 7}
      # ...
    ])
  end


end
Programa.main()
