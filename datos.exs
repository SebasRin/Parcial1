defmodule Datos do
  @moduledoc """

  """
  def confeccionistas do
      [
      %{codigo: "C01", nombre: "María Elena Ríos", alquiler: true},
      %{codigo: "C02", nombre: "Andrés Salazar", alquiler: false},
      %{codigo: "C03", nombre: "Luisa Fernanda Gómez", alquiler: true},
      %{codigo: "C04", nombre: "Carlos Pérez", alquiler: true}
    ]

  end
  def lineas do
    [
      %{id: "L1", nombre: "Línea Norte", puestos: 6},
      %{id: "L2", nombre: "Línea Central", puestos: 4},
      %{id: "L3", nombre: "Línea Sur", puestos: 5}
    ]
  end
  def lotes do
    [
      %{confeccionista: "C01", linea: "L1", dia: 1, prendas: 70, defectos: 1.5},
      %{confeccionista: "C01", linea: "L2", dia: 1, prendas: 55, defectos: 7},
      %{confeccionista: "C02", linea: "L1", dia: 1, prendas: 130, defectos: 3},
      %{confeccionista: "C03", linea: "L1", dia: 1, prendas: 60, defectos: 12},
      %{confeccionista: "C04", linea: "L3", dia: 1, prendas: 90, defectos: 0.5},
      %{confeccionista: "C01", linea: "L1", dia: 2, prendas: 90, defectos: 12},
      %{confeccionista: "C01", linea: "L2", dia: 2, prendas: 40, defectos: 4},
      %{confeccionista: "C02", linea: "L2", dia: 2, prendas: 100, defectos: 8},
      %{confeccionista: "C03", linea: "L2", dia: 2, prendas: 80, defectos: 2},
      %{confeccionista: "C01", linea: "L3", dia: 3, prendas: 120, defectos: 5},
      %{confeccionista: "C03", linea: "L3", dia: 3, prendas: 130, defectos: 1},
      %{confeccionista: "C04", linea: "L3", dia: 3, prendas: 50, defectos: 6},
      %{confeccionista: "C99", linea: "L1", dia: 1, prendas: 70, defectos: 1.5},
      %{confeccionista: "C88", linea: "L1", dia: 1, prendas: 70, defectos: 1.5},
      %{confeccionista: "C01", linea: "L99", dia: 1, prendas: 70, defectos: 1.5},
      %{confeccionista: "C01", linea: "L1", dia: 7, prendas: 70, defectos: 1.5},
      %{confeccionista: "C01", linea: "L1", dia: 0, prendas: 70, defectos: 1.5},
      %{confeccionista: "C01", linea: "L1", dia: "1", prendas: 70, defectos: 1.5},
      %{confeccionista: "C01", linea: "L1", dia: 1, prendas: 0, defectos: 1.5},
      %{confeccionista: "C01", linea: "L1", dia: 1, prendas: 200, defectos: 1.5},
      %{confeccionista: "C01", linea: "L1", dia: 1, prendas: 70, defectos: "5"},
      %{confeccionista: "C01", linea: "L1", dia: 1, prendas: 70, defectos: 150},
      %{confeccionista: "C01", linea: "L1", dia: 1, prendas: 70, defectos: -5},
      %{confeccionista: "C77", linea: "L1", dia: 8, prendas: 500, defectos: "abc"},
      %{confeccionista: "C01", linea: "L77", dia: 1, prendas: 500, defectos: "abc"}
    ]
  end

end
