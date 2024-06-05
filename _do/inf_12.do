********************************************************************************

* ORGANIZACIÓN:		Fundación ARU
* TITULO:			Automatizacion de Base de datos IPC 
* FECHA:			Mayo, 2024
* BASE DE DATOS:	IPC
* Elaborado por :	Diego Peñaranda y Carlos Pantoja
* Out			: 	Inflacion a 12 meses por producto

********************************************************************************
* Importación Base de Datos
* Importación Base de Datos
clear all
set more off

* Importar datos y eliminar la variable 'cod'
use "_in/ipc_abril24.dta", clear
drop cod  // Eliminar la variable 'cod'

* Crear un loop para generar variables para todos los meses desde "ene22" hasta "abr24"
foreach var of varlist ene22-abr24 {
    local month_num = real(substr("`var'", 4, .))
    local prev_month = substr("`var'", 1, 3) + string(`month_num' - 1)
    generate `var'_12meses = (`var' / `prev_month') - 1
}
 drop ene18-abr24

sort ene22_12meses
