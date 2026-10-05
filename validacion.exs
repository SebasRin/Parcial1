defmodule Validacion do
  @moduledoc """
    Validación de lotes.
    Cada lote se valida en el orden indicado:
    confeccionista, línea, día, prendas y defectos. Si un lote
    incumple más de una regla, se informa únicamente el primer
    motivo de rechazo.
  """

  @dias_produccion 6
  @maximo_prendas_lote 180


  @doc """
  Valida un lote de producción.

  Verifica en orden:

    1. El confeccionista existe.
    2. La línea de producción existe.
    3. El día es un entero entre 1 y 6.
    4. La cantidad de prendas es un entero entre 1 y 180.
    5. El porcentaje de defectos es un número entre 0 y 100.

  Devuelve {:ok, lote} si es válido, o {:error, motivo} con el
  primer motivo de rechazo encontrado.

  IA - Bitácora 1#: cómo encadenar validaciones en orden con with.
  """

  def validacion_lote(confeccionistas, lineas, lote) do

    with %{} <- Enum.find(confeccionistas, :confeccionista_no_existe, &(&1.codigo == lote.confeccionista)),
        %{} <- Enum.find(lineas,:linea_no_existe , &(&1.id == lote.linea)),
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


  defp validar_dia(dia) when is_integer(dia) and dia >= 1 and dia <= @dias_produccion do
    :ok

  end
  defp validar_dia(_) do
    :error_dia
  end

  defp validar_prenda(prenda) when is_integer(prenda) and prenda >= 1 and prenda <= @maximo_prendas_lote do
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

  @doc """
  Separa los lotes validos
  """

  def lotes_ok(confeccionistas, lineas, lotes) do
      Enum.filter(lotes, fn lote ->
        match?({:ok, _},Validacion.validacion_lote(confeccionistas, lineas, lote))
      end)

    end

  @doc """
  Separa los lotes invalidos
  """

  def lotes_error(confeccionistas, lineas, lotes)do
    Enum.filter(lotes, fn lote ->
      match?({:error, _},Validacion.validacion_lote(confeccionistas, lineas, lote))
    end)
  end

end
