defmodule Util do
  @moduledoc """

  """

  def formatter(valor) do
    :erlang.float_to_binary(valor / 1, decimals: 2)
  end

end
