

defmodule Liquidacion do
  @moduledoc """

  """


  @tarifa_base_prenda 3200
  @prendas_diarias_bonificacion 120
  @bonificacion_diaria 18000
  @alquiler_maquina 15000

  def valor_lote(lote) do
    valor_base = lote.prendas * @tarifa_base_prenda
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
        if total >= @prendas_diarias_bonificacion do
            @bonificacion_diaria
        else
          0
        end
        Map.update(acc, codigo, bonificacion, &(&1 + bonificacion))

      end)
  end


  def alquiler_maquinas(confeccionistas, lotes)do
    Map.new(confeccionistas, fn confe ->
      if confe.alquiler == true and Enum.any?(lotes, fn lote -> lote.confeccionista == confe.codigo end) do
        {confe.codigo, @alquiler_maquina * contar_dias(confe.codigo, lotes)}
      else
        {confe.codigo, 0}
      end

    end)
  end

  defp contar_dias(confeccionista, lotes) do
    lotes
    |> Enum.filter(fn lote -> lote.confeccionista == confeccionista end)
    |> Enum.map(fn lote -> lote.dia end)
    |> Enum.uniq()
    |> length()
  end

  def liquidacion(confeccionistas, lotes) do

    bonificacion = bonificacion_por_productividad(lotes)
    alquiler = alquiler_maquinas(confeccionistas, lotes)

    Enum.reduce(lotes,%{}, fn lote, acc ->
        Map.update(acc, {lote.confeccionista}, valor_lote(lote), &(&1 + valor_lote(lote)))
    end)
    |> Enum.map(fn {{codigo}, subtotal} ->

        suma_prendas =
        lotes
        |> Enum.filter(&(&1.confeccionista == codigo))
        |> Enum.map(&(&1.prendas))
        |> Enum.sum()

        bonifi = Map.get(bonificacion, codigo)
        alqui = Map.get(alquiler, codigo)
        resultado = subtotal + bonifi - alqui
        %{codigo: codigo, pago_neto: resultado, bonificacion: bonifi, alquiler: alqui, valor_lote: subtotal, prendas: suma_prendas}
    end)



  end

end
