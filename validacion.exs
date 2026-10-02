defmodule Validacion do
  @moduledoc """

  """

  def validacion_lote(confeccionistas, lineas, lote) do

    with %{} <- Map.get(confeccionistas, lote.confeccionista, :confeccionista_no_existe),
        %{} <- Map.get(lineas, lote.linea, :linea_no_existe),
        :ok <- validar_dia(lote.dia),
        :ok <- validar_prenda(lote.prendas),
        :ok <- validar_defectos(lote.defectos) do

          {:ok, lote}

    else
      :confeccionista_no_existe -> {:error, :confeccionista_desconocido}
      :linea_no_existe -> {:error, :linea_desconocida}
      :error_dia -> {:error, :dia_invalido}
      :error_prenda -> {:error, :prendas_fuera_de_rango}
      :error_defectos -> {:error, :porcentaje_invalido}
    end
  end

  defp validar_dia(dia) when is_integer(dia) and dia >= 1 and dia <= 6 do
    :ok
  end
  defp validar_dia(_) do
    :error_dia
  end

  defp validar_prenda(prenda) when is_integer(prenda) and prenda >= 1 and prenda <= 180 do
    :ok
  end
  defp validar_prenda(_) do
    :error_prenda
  end

  defp validar_defectos(defectos) when is_number(defectos) and defectos >= 0 and defectos <= 100 do
    :ok
  end

  defp validar_defectos(_) do
    :error_defectos
  end

end
