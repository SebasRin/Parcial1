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

  def bonificacion_por_productividad(lotes) do
      mapa =
      Enum.reduce(lotes, %{}, fn lote, acc ->
        Map.update(acc, {lote.confeccionista, lote.dia}, lote.prendas, &(&1 + lote.prendas))
      end)

      Map.new(mapa, fn {{confeccionista, dia}, total} ->
        {{confeccionista, dia}, %{total_prendas: total, bonificacion: total >= 120}}

      end)
      |> IO.inspect(label: "Confeccionistas que se le aplica la bonificaion")
  end


  def alquiler_maquinas(confeccionistas, lotes)do
    Map.new(confeccionistas, fn confe ->
      valor = confe.alquiler == true and Enum.any?(lotes, fn lote -> lote.confeccionista == confe.codigo end)
      {confe.codigo, valor}
    end)
    |> IO.inspect(label: "Alquiler maquinas")
  end

end
