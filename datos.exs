defmodule Datos do
  @moduledoc """

  """
  def confeccionistas do
    %{

      "C01" => %{nombre: "Maria Elena Rios", alquiler: true},
      "C02" => %{nombre: "Andres Salazar", alquiler: false}

    }
  end
  def lineas do
    %{

      "L1" => %{nombre: "Linea Norte", puestos: 6},
      "L2" => %{nombre: "Línea Central", puestos: 4}

    }
  end
  def lotes do
    [
      %{confeccionista: "C01", linea: "L1", dia: 1,
        prendas: 70, defectos: 1.5},
      %{confeccionista: "C01", linea: "L2", dia: 1,
        prendas: 55, defectos: 7}
      # ...
    ]
  end

end
