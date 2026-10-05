defmodule Util do
  @moduledoc """
    Funciones de apoyo
  """

  @doc """
  Formate un valor monetario con dos decimales, sin notacio
  cientifica
  Acepata enteros y flotantes
  """

  def formatter(valor) do
    :erlang.float_to_binary(valor / 1, decimals: 2)
  end

end
