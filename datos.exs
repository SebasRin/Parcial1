defmodule Datos do
  @moduledoc """
    Datos base del sistema.
    Provee las tres colecciones principales del sistema:
    confeccionistas, líneas y lotes.
  """
  def confeccionistas do
    [
    %{codigo: "C01", nombre: "Empate Uno", alquiler: false},
    %{codigo: "C02", nombre: "Empate Dos", alquiler: false},
    %{codigo: "C03", nombre: "Rechazada Cero", alquiler: false},
    %{codigo: "C04", nombre: "Peor Calidad", alquiler: false}
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
    %{confeccionista: "C01", linea: "L1", dia: 1, prendas: 100, defectos: 2},
    %{confeccionista: "C01", linea: "L1", dia: 2, prendas: 100, defectos: 4},
    %{confeccionista: "C01", linea: "L1", dia: 3, prendas: 100, defectos: 6},
    %{confeccionista: "C02", linea: "L2", dia: 1, prendas: 100, defectos: 4},
    %{confeccionista: "C02", linea: "L2", dia: 2, prendas: 100, defectos: 4},
    %{confeccionista: "C02", linea: "L2", dia: 3, prendas: 100, defectos: 4},
    %{confeccionista: "C03", linea: "L1", dia: 1, prendas: 50, defectos: 0},
    %{confeccionista: "C03", linea: "L1", dia: 2, prendas: 50, defectos: 0},
    %{confeccionista: "C03", linea: "L1", dia: 7, prendas: 50, defectos: 0},
    %{confeccionista: "C03", linea: "L1", dia: 8, prendas: 50, defectos: 0},
    %{confeccionista: "C03", linea: "L1", dia: 0, prendas: 50, defectos: 0},
    %{confeccionista: "C04", linea: "L3", dia: 1, prendas: 100, defectos: 4.5},
    %{confeccionista: "C04", linea: "L3", dia: 2, prendas: 100, defectos: 4.5},
    %{confeccionista: "C04", linea: "L3", dia: 3, prendas: 100, defectos: 4.5}
    ]
  end

end
