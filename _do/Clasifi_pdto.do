********************************************************************************

* ORGANIZACIÓN:		Fundación ARU
* TITULO:			Automatizacion de Base de datos IPC 
* FECHA:			Mayo, 2024
* BASE DE DATOS:	IPC
* Elaborado por :	Diego Peñaranda y Carlos Pantoja
* Out:				Clasificacion por productos IPC

********************************************************************************

* BLOQUE 1: LECTURA Y DISEÑO MUESTRAL

* Importación Base de Datos
clear all
set more off
use _in/ipc_abril24.dta, clear
drop in 1
* Extraemos el codigo 
gen cod_prefix = substr(cod, 1, 4)
drop cod pdto

* Colapsar las variables por 'cod_prefix'
ds cod_prefix, not
local vars `r(varlist)'
collapse (mean) `vars', by(cod_prefix)

* Transponer

sxpose, force firstnames clear

* Damos formato de año y mes a la variable t

generate t = tm(2018m1) + _n -1
format %tm t 
* Declaramos la serie de tiempo
tsset t

destring, replace
order t
la var t "Año"

* Grafico de Variables

* Renombramos las variables en base a los códigos
label variable _var1 "Alimentos y bebidas no alcohólicas"
label variable _var2 "Bebidas alcohólicas, tabaco y estupefacientes"
label variable _var3 "Prendas de vestir y calzado"
label variable _var4 "Alojamiento, agua, electricidad, gas y otros combustibles"
label variable _var5 "Muebles, artículos para el hogar y para la conservación ordinaria del hogar"
label variable _var6 "Salud"
label variable _var7 "Transporte"
label variable _var8 "Comunicaciones"
label variable _var9 "Recreación y cultura"
label variable _var10 "Educación"
label variable _var11 "Restaurantes y hoteles"
label variable _var12 "Bienes y servicios diversos"

* Crear los gráficos individuales con etiquetas en el eje Y y fondo blanco
forvalues i = 1/12 {
    tsline _var`i', ///
        name(graph`i', replace) ///
        graphregion(color(white)) ///
        ylabel(none) /// Quitar las etiquetas del eje Y
        ytitle("") /// Quitar el título del eje Y
        xlabel(, labsize(vsmall)) /// Mantener las etiquetas del eje X pequeñas
        xtitle("") /// Quitar el título del eje X
        legend(off) /// Quitar la leyenda
        title(`"`: variable label _var`i''"', size(vsmall))
}

* Combinar los gráficos con títulos individuales
graph combine graph1 graph2 graph3 graph4 graph5 graph6 graph7 graph8 graph9 graph10 graph11 graph12, ///
    cols(3) ///
    imargin(5 5 5 5) ///
    title("IPC por Categoría", size(small) margin(medsmall)) ///
    note("Fuente: INE", size(vsmall) position(12)) ///
    graphregion(color(white))
