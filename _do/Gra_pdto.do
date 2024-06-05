********************************************************************************

* ORGANIZACIÓN:		Fundación ARU
* TITULO:			Automatizacion de Base de datos IPC 
* FECHA:			Mayo, 2024
* BASE DE DATOS:	IPC
* Elaborado por :	Diego Peñaranda y Carlos Pantoja

********************************************************************************

* Importación Base de Datos
clear all
set more off
use _in/ipc_abril24.dta, clear
drop cod  // Eliminar la variable 'cod'

* Crear una variable de identificación única para cada observación

replace pdto = subinstr(pdto, " ", "_", .)

* Limpiar variables expuestas
ssc install sxpose, replace
sxpose, force  clear

* Obtener el nombre de las variables
ds

* Guardar el nombre de las variables en una macro
local varnames `r(varlist)'

* Contar cuántas variables hay
tokenize `varnames'
local numcols : word count `varnames'

* Extraer la primera fila de datos
preserve
keep in 1
foreach var of varlist `varnames' {
    local label_`var' = `var'[1]
}
restore

* Reetiquetar las variables con la primera fila como etiquetas
forval i = 1/`numcols' {
    local label : word `i' of `varnames'
    local new_label `label_`label''
    label variable `label' "`new_label'"
}

drop in 1

*Generemos la variable de tiempo 

generate t = tm(2018m1) + _n -1
format %tm t //damos formato de año y mes a la variable t
* Declaramos la serie de tiempo
tsset t

destring, replace

** GRAFICOS
local varname _var1
local varlabel : variable label `varname'


tsline _var3, ///
    title(`varlabel', size(large) color(blue)) ///
    subtitle("2018 Enero - 2024 Abril ", size(medium) color(navy)) ///
    xtitle("Fecha", size(medium) color(black)) ///
    ytitle(`varlabel', size(medium) color(black)) ///
    ylabel(, angle(0) labsize(small)) ///
    xlabel(, labsize(small) format(%tm)) ///
    legend(off) ///
    lwidth(medium) lcolor(red) ///
    tline(100, lpattern(dash) lcolor(gs12)) ///
    graphregion(color(white))
	

