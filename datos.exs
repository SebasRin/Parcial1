defmodule Datos do
  @moduledoc """
    Datos base del sistema.
    Provee las tres colecciones principales del sistema:
    confeccionistas, líneas y lotes.
  """
  def confeccionistas do
    [
    %{codigo: "C01", nombre: "Lola Pinto", alquiler: false},
    %{codigo: "C02", nombre: "Mario Gil", alquiler: true},
    %{codigo: "C03", nombre: "Nora Silva", alquiler: false}
    ]
  end

  def lineas do
    [
    %{id: "L1", nombre: "Línea Norte", puestos: 6},
    %{id: "L2", nombre: "Línea Central", puestos: 4},
    %{id: "L3", nombre: "Línea Sur", puestos: 5},
    %{id: "L4", nombre: "Línea Este", puestos: 2}
    ]
  end

  def lotes do
    [
    %{confeccionista: "C01", linea: "L1", dia: 1, prendas: 100, defectos: 1},
    %{confeccionista: "C01", linea: "L2", dia: 2, prendas: 100, defectos: 1},
    %{confeccionista: "C01", linea: "L3", dia: 3, prendas: 100, defectos: 1},
    %{confeccionista: "C01", linea: "L4", dia: 4, prendas: 100, defectos: 1},
    %{confeccionista: "C02", linea: "L1", dia: 1, prendas: 50, defectos: 9},
    %{confeccionista: "C02", linea: "L2", dia: 5, prendas: 50, defectos: 9}
    ]
  end

end
