defmodule Util do
  @moduledoc """
    Funciones de apoyo
  """

  @doc """
  Formate un valor monetario con dos decimales, sin notacio
  cientifica
  Acepata enteros y flotantes

  IA - Bitácora #2: cómo evitar la notación científica (1.2e6)
  usando :erlang.float_to_binary/2.
  """

  def formatter(valor) do
    :erlang.float_to_binary(valor / 1, decimals: 2)
  end


end
