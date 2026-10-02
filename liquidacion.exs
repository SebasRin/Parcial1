defmodule Liquidacion do
  @moduledoc """

  """

  def valor_lote(lote) do
    valor_base = lote.prendas * 3200

    cond do
      lote.defectos <= 2 -> valor_base + (valor_base * 0.7)
      lote.defectos > 2 and lote.defectos <= 5 -> valor_base
      lote.defectos > 5 and lote.defectos <= 10 -> valor_base - (valor_base * 0.12)
      true -> valor_base - (valor_base * 0.25)

    end


  end

end
