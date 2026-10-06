Code.require_file("datos.exs")
Code.require_file("validacion.exs")
Code.require_file("liquidacion.exs")
Code.require_file("reportes.exs")

defmodule Programa do

  @moduledoc """
  Punto de entrada del sistema de producción.
  Orquesta el flujo completo: lee los datos, separa los lotes en
  válidos y rechazados, y ejecuta los reportes R1 a R8. Los efectos
  secundarios (leer datos, imprimir) están concentrados aquí.
  """


  @doc """
  Ejecuta el flujo principal del sistema.

  1. Lee los datos base desde Datos.
  2. Separa los lotes en válidos y rechazados.
  3. Imprime los reportes R1 a R8.
  """

  def main do
    confeccionistas = Datos.confeccionistas()
    lineas = Datos.lineas()
    lotes = Datos.lotes()
    lotes_ok = Validacion.lotes_ok(confeccionistas, lineas, lotes)
    lotes_error = Validacion.lotes_error(confeccionistas, lineas, lotes)


    Reportes.reporte_r1(confeccionistas, lineas, lotes_error)
    Reportes.reporte_r2(lineas, lotes_ok)
    Reportes.reporte_r3(lotes_ok)
    Reportes.reporte_r4(confeccionistas, lotes_ok)
    Reportes.reporte_r5(lotes_ok)
    Reportes.reporte_r6(confeccionistas, lineas, lotes)
    Reportes.reporte_r7(confeccionistas, lotes)
    Reportes.reporte_r8(confeccionistas, lineas, lotes)

    end


  def ingresar_lote_adicional(confeccionistas, lineas) do
    entrada =
      IO.gets(
        "Ingrese un lote adicional (confeccionista;linea;dia;prendas;defectos) o Enter para omitir: "
      )
      |> String.trim()

    if entrada == "" do
      IO.puts("Lote adicional omitido.")
      {:omitido, nil}
    else
      campos = String.split(entrada, ";")

      if length(campos) != 5 do
        IO.puts("Lote rechazado: formato inválido.")
        {:error, :formato_invalido}
      else
        [confeccionista, linea, dia, prendas, defectos] = campos

        with {dia, ""} <- Integer.parse(dia),
            {prendas, ""} <- Integer.parse(prendas),
            {defectos, ""} <- Float.parse(defectos) do

          lote = %{
            confeccionista: confeccionista,
            linea: linea,
            dia: dia,
            prendas: prendas,
            defectos: defectos
          }

          case Validacion.validacion_lote(
                confeccionistas,
                lineas,
                lote
              ) do

            {:ok, lote} ->
              IO.puts("Lote adicional agregado correctamente.")
              {:ok, lote}

            {:error, motivo} ->
              IO.puts("Lote rechazado: #{motivo}")
              {:error, motivo}
          end
        else
          _ ->
            IO.puts("Lote rechazado: formato inválido.")
            {:error, :formato_invalido}
        end
      end
    end
  end


  def comprobante_individual(confeccionistas, lineas, lotes) do
    codigo =
      IO.gets("Ingrese el código del confeccionista: ")
      |> String.trim()

    case Enum.find(confeccionistas, &(&1.codigo == codigo)) do
      nil ->
        IO.puts("El confeccionista #{codigo} no existe.")

      confeccionista ->
        lotes_validos =
          Validacion.lotes_ok(
            confeccionistas,
            lineas,
            lotes
          )

        lotes_confeccionista =
          Enum.filter(lotes_validos, fn lote ->
            lote.confeccionista == codigo
          end)

        mostrar_comprobante(
          confeccionista,
          confeccionistas,
          lotes_confeccionista
        )
    end
end

def mostrar_comprobante(confeccionista, confeccionistas, lotes) do
  IO.puts("")
  IO.puts("---------------------------------------------")
  IO.puts("Comprobante Individual")

  IO.puts("Nombre: #{confeccionista.nombre}")
  IO.puts("Código: #{confeccionista.codigo}")

  lotes_por_dia =
    Enum.group_by(lotes, &(&1.dia))

  Enum.each(
    Enum.sort_by(lotes_por_dia, fn {dia, _lotes} -> dia end),
    fn {dia, lotes_dia} ->

      prendas_dia =
        lotes_dia
        |> Enum.map(&(&1.prendas))
        |> Enum.sum()

      valor_dia =
        lotes_dia
        |> Enum.map(&(&1.valor_lote/1))
        |> Enum.sum()

      bonificacion_dia =
        Liquidacion.bonificacion_por_productividad(lotes_dia)
        |> Map.get(confeccionista.codigo, 0)

      IO.puts("-------------------------------------------------------")
      IO.puts("Día: #{dia}")
      IO.puts("Prendas por día: #{prendas_dia}")
      IO.puts("Valor de los lotes por día: #{valor_dia}")
      IO.puts("Bonificación diaria: #{bonificacion_dia}")
    end
  )

  suma_lotes =
    lotes
    |> Enum.map(&(&1.valor_lote/1))
    |> Enum.sum()

  suma_bonificaciones =
    Liquidacion.bonificacion_por_productividad(lotes)
    |> Map.get(confeccionista.codigo, 0)

  alquiler =
    Liquidacion.alquiler_maquinas(confeccionistas, lotes)
    |> Map.get(confeccionista.codigo, 0)

  neto =
    suma_lotes + suma_bonificaciones - alquiler

  IO.puts("-------------------------------------------------------")
  IO.puts("Suma de lotes: #{suma_lotes}")
  IO.puts("Suma de bonificaciones: #{suma_bonificaciones}")
  IO.puts("Descuento por alquiler: #{alquiler}")
  IO.puts("Neto: #{neto}")

  IO.puts("=======================================================")
end

end
Programa.main()
