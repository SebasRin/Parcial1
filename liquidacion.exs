

defmodule Liquidacion do
  @moduledoc """

  """


  def valor_lote(lote) do
    valor_base = lote.prendas * 3200
    cond do
      lote.defectos <= 2 -> valor_base + (valor_base * 0.07)
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

      Enum.reduce(mapa, %{}, fn {{codigo, _dia}, total}, acc ->
        bonificacion =
        if total >= 120 do
            18000
        else
          0
        end
        Map.update(acc, codigo, bonificacion, &(&1 + bonificacion))

      end)
      |> IO.inspect(label: "Confeccionistas que se le aplica la bonificaion")
  end


  def alquiler_maquinas(confeccionistas, lotes)do
    Map.new(confeccionistas, fn confe ->
      if confe.alquiler == true and Enum.any?(lotes, fn lote -> lote.confeccionista == confe.codigo end) do
        {confe.codigo, 15000 * contar_dias(confe.codigo, lotes)}
      else
        {confe.codigo, 0}
      end

    end)
    |> IO.inspect(label: "Alquiler maquinas")
  end

  defp contar_dias(confeccionista, lotes) do
    lotes
    |> Enum.filter(fn lote -> lote.confeccionista == confeccionista end)
    |> Enum.map(fn lote -> lote.dia end)
    |> Enum.uniq()
    |> length()
  end

  def liquidacion(confeccionistas,_lineas, lotes) do

    bonificacion = bonificacion_por_productividad(lotes)
    alquiler = alquiler_maquinas(confeccionistas, lotes)

    Enum.reduce(lotes,%{}, fn lote, acc ->
        Map.update(acc, {lote.confeccionista}, valor_lote(lote), &(&1 + valor_lote(lote)))
    end)
    |> Enum.map(fn {{codigo}, subtotal} ->
        subtotal + Map.get(bonificacion, codigo) - Map.get(alquiler, codigo)
    end)
    |> IO.inspect(label: "Liquidacion")



  end

end
