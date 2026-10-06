# Liquidación de la producción de un taller de confección

**Universidad del Quindío · Ingeniería de Sistemas y Computación**
**Programación III · Parcial 1** · Docente: Robinson Arias Muñoz

**Integrantes**

- Juan Sebastián Rincon Cañon
- Marlon Adrian Ocampo

---

## Descripción

Programa en Elixir que calcula cuánto debe pagar un taller de confección a cada confeccionista independiente al finalizar la semana y genera reportes de producción

El programa:

1. Carga los datos desde el módulo `Datos` (`datos.exs`).
2. Pide un **lote adicional** por teclado.
3. Valida los lotes y separa los válidos de los rechazados.
4. Liquida a todos los confeccionistas.
5. Imprime los reportes R1 a R8 y las tres llamadas a `Reportes.ranking/2`.
6. Pide el código de un confeccionista e imprime su **comprobante individual**.


## Compilación y ejecución

Desde la carpeta del proyecto (la que contiene los archivos `.exs`):

```bash
# 1. Compilar los módulos de apoyo
elixirc Util.ex

# 2. Ejecutar el programa
elixir programa.exs
```

## Estructura del proyecto

| Archivo | Módulo | Responsabilidad |
|---|---|---|
| `datos.exs` | `Datos` | Provee `confeccionistas/0`, `lineas/0` y `lotes/0`. Es reemplazable sin modificar el resto del programa. |
| `validacion.exs` | `Validacion` | Valida cada lote en el orden exigido y separa válidos de rechazados. |
| `liquidacion.exs` | `Liquidacion` | Calcula valor de lote, bonificación diaria, alquiler y pago neto. |
| `reportes.exs` | `Reportes` | Calcula e imprime R1 a R8 y `ranking/2`. |
| `util.exs` | `Util` | Formateo de valores. |
| `programa.exs` | `Programa` | Contiene `main/0`: orquesta el flujo y la interacción con el usuario. |


## Parámetros del taller

Definidos como atributos de módulo:

| Parámetro | Valor |
|---|---|
| Tarifa base por prenda | $3.200 |
| Meta diaria del taller | 600 prendas |
| Días de producción | 6 (numerados del 1 al 6) |
| Máximo de prendas por lote | 180 |
| Prendas diarias para bonificación | 120 |
| Bonificación diaria | $18.000 |
| Alquiler de máquina | $15.000 por día trabajado |

## Reglas de negocio

### Validación de lotes

Se aplican en orden y solo se informa el primer motivo de rechazo.

| Orden | Regla | Motivo de rechazo |
|---|---|---|
| 1 | El confeccionista existe | `:confeccionista_desconocido` |
| 2 | La línea existe | `:linea_desconocida` |
| 3 | El día es un entero entre 1 y 6 | `:dia_invalido` |
| 4 | Las prendas son un entero entre 1 y 180 | `:prendas_fuera_de_rango` |
| 5 | Los defectos son un número entre 0 y 100 | `:porcentaje_invalido` |

La validación devuelve `{:ok, lote}` o `{:error, motivo}`. Los lotes rechazados se excluyen de los cálculos, pero aparecen en R1.

### Valor de un lote

`valor_base = prendas × 3200`, con ajuste según el porcentaje de defectos:

| Defectos | Ajuste |
|---|---|
| Hasta 2 % | Bonificación del 7 % |
| Más de 2 % y hasta 5 % | Sin ajuste |
| Más de 5 % y hasta 10 % | Descuento del 12 % |
| Más de 10 % | Descuento del 25 % |

### Bonificación y alquiler

- **Bonificación:** $18.000 por cada día en que el confeccionista acumula 120 prendas o más en lotes válidos (sumando todas sus líneas).
- **Alquiler:** $15.000 por cada día con al menos un lote válido, solo para quienes usan máquina del taller.

### Liquidación

```
neto = suma de valores de los lotes + bonificaciones - alquiler
```

Todos los confeccionistas aparecen en la liquidación, incluso sin lotes válidos (todos sus valores en cero).

**Comprobación:** con los lotes de María Elena del enunciado, el neto debe ser **$598.560,00**.

## Reportes

| # | Contenido |
|---|---|
| R1 | Lotes rechazados con su motivo y conteo por motivo |
| R2 | Prendas por línea y productividad (prendas/puestos), de mayor a menor |
| R3 | Producción diaria del taller y cumplimiento de la meta de 600 prendas |
| R4 | Liquidación de todos los confeccionistas, numerada y ordenada por neto |
| R5 | Confeccionista(s) con más prendas cada día y quién ganó más días |
| R6 | Mejor calidad: menor porcentaje de defectos ponderado (mínimo 3 lotes válidos) |
| R7 | Total pagado por el taller y costo promedio por prenda válida |
| R8 | Confeccionistas con al menos un lote válido en todas las líneas |

Porcentaje ponderado de R6:

```
porcentaje_ponderado = suma(defectos × prendas) / suma(prendas)
```

### `Reportes.ranking/2`

Recibe la lista de liquidaciones y una *keyword list* con opciones:

| Opción | Valores | Predeterminado |
|---|---|---|
| `campo` | `:neto`, `:prendas`, `:bruto` | `:neto` |
| `orden` | `:desc`, `:asc` | `:desc` |
| `limite` | entero positivo | todos |

## Interacción con el usuario

**1. Lote adicional** (antes de los reportes). Formato:

```
Ingrese un lote adicional (confeccionista;linea;dia;prendas;defectos)
o Enter para omitir: C03;L2;4;85;3.5
```

- Con Enter se omite.
- Si el formato es incorrecto devuelve `{:error, :formato_invalido}` y el programa continúa.
- Si el formato es correcto se aplican las cinco reglas de validación; un lote válido se incorpora a todos los reportes.

**2. Comprobante individual** (después de los reportes). Se ingresa el código de un confeccionista y se muestra su comprobante con nombre, código, detalle por día trabajado, bonificaciones, descuento por alquiler y neto. Si el código no existe, se informa sin fallar.



## Documentación adicional

El documento PDF de entrega incluye el diseño (Parte A), la explicación del promedio ponderado de R6, la investigación (Parte C),y el uso de IA (Parte D).
