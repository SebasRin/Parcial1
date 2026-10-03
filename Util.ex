defmodule Util do
  @moduledoc """

  """

  def formatter(valor) do
    :erlang.float_to_binary(valor, decimals: 2)
  end

end
