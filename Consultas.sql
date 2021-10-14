USE Proyecto2;
/*CONSULTA 1*/
/*Desplegar para cada elección el país y el partido político que obtuvo mayor
porcentaje de votos en su país. Debe desplegar el nombre de la elección, el
año de la elección, el país, el nombre del partido político y el porcentaje que
obtuvo de votos en su país.*/
SELECT SUB6.elec AS NombreEleccion, SUB7.ano as Año,SUB6.pais as Pais,SUB7.partido as Partido,round((SUB7.maximo/SUB6.TOTAL)*100,2) as Porcentaje FROM (
	SELECT sum(SUB1.votos) as TOTAL,PAIS.nombre as pais,SUB1.eleccion as elec FROM PAIS
	INNER JOIN(
		SELECT (DETALLE_ELECCION.alfabetos + DETALLE_ELECCION.analfabetos) as votos,PAIS.idPais as pa, ELECCION.nombre as eleccion FROM DETALLE_ELECCION
		INNER JOIN MUNICIPIO ON DETALLE_ELECCION.idMunicipio = MUNICIPIO.idMunicipio
		INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
		INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
		INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
		INNER JOIN ELECCION ON ELECCION.idEleccion = DETALLE_ELECCION.idEleccion
	) AS SUB1
	WHERE PAIS.idPAis = SUB1.pa
	GROUP BY PAIS.nombre,SUB1.eleccion
) SUB6
INNER JOIN (
	SELECT SUB4.maximo as maximo,SUB4.pais as country,SUB5.partido as partido,SUB4.a as ano FROM (
	SELECT MAX(SUB3.TOTAL) as maximo,SUB3.pa as pais,SUB3.an as a FROM (
		SELECT SUM(SUB2.votos)as TOTAL,PAIS.nombre as pa,PARTIDO.nombre as nom,SUB2.ano as an FROM PAIS
		INNER JOIN(
			SELECT (DETALLE_ELECCION.alfabetos + DETALLE_ELECCION.analfabetos) as votos,PARTIDO.nombre as nom,PAIS.idPais as pa,FECHA_ELECCION.anoEleccion as ano FROM DETALLE_ELECCION
			INNER JOIN MUNICIPIO ON DETALLE_ELECCION.idMunicipio = MUNICIPIO.idMunicipio
			INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
			INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
			INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
			INNER JOIN PARTIDO ON PARTIDO.idPartido = DETALLE_ELECCION.idPartido
			INNER JOIN FECHA_ELECCION ON DETALLE_ELECCION.idFechaEleccion = FECHA_ELECCION.idFechaEleccion
		) AS SUB2
		INNER JOIN PARTIDO ON PARTIDO.nombre = SUB2.nom
		WHERE PAIS.idPAis = SUB2.pa
		GROUP BY PAIS.nombre,PARTIDO.nombre,SUB2.ano
	) AS SUB3
	GROUP BY SUB3.pa,SUB3.an
	)SUB4
	INNER JOIN (
	SELECT MAX(SUB3.TOTAL) as maximo,SUB3.nom as partido,SUB3.an as a FROM (
		SELECT SUM(SUB2.votos)as TOTAL,PAIS.nombre as pa,PARTIDO.nombre as nom,SUB2.ano as an FROM PAIS
		INNER JOIN(
			SELECT (DETALLE_ELECCION.alfabetos + DETALLE_ELECCION.analfabetos) as votos,PARTIDO.nombre as nom,PAIS.idPais as pa,FECHA_ELECCION.anoEleccion as ano FROM DETALLE_ELECCION
			INNER JOIN MUNICIPIO ON DETALLE_ELECCION.idMunicipio = MUNICIPIO.idMunicipio
			INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
			INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
			INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
			INNER JOIN PARTIDO ON PARTIDO.idPartido = DETALLE_ELECCION.idPartido
			INNER JOIN FECHA_ELECCION ON DETALLE_ELECCION.idFechaEleccion = FECHA_ELECCION.idFechaEleccion
		) AS SUB2
		INNER JOIN PARTIDO ON PARTIDO.nombre = SUB2.nom
		WHERE PAIS.idPAis = SUB2.pa
		GROUP BY PAIS.nombre,PARTIDO.nombre,SUB2.ano
	) AS SUB3
	GROUP BY SUB3.nom,SUB3.an
	)SUB5
	WHERE SUB4.maximo = SUB5.maximo
)SUB7 ON SUB6.pais = SUB7.country
;

/*CONSULTA 2*/
/*Desplegar total de votos y porcentaje de votos de mujeres por departamento
y país. El ciento por ciento es el total de votos de mujeres por país. (Tip:
Todos los porcentajes por departamento de un país deben sumar el 100%)*/
SELECT SUB3.pais,SUB3.departamento,SUB3.votosM, round((SUB3.votosM/SUB4.total) *100,2) as porcentaje FROM 
(
	SELECT SUB1.pais as pais, SUB1.departamento as departamento,SUM(SUB1.suma) as votosM FROM 
	(
		SELECT (DETALLE_ELECCION.alfabetos + DETALLE_ELECCION.analfabetos) as suma,DEPARTAMENTO.nombre as departamento,PAIS.nombre as pais FROM DETALLE_ELECCION
		INNER JOIN SEXO ON SEXO.idSexo = DETALLE_ELECCION.idSexo AND SEXO.descripcion LIKE 'mujeres'
		INNER JOIN MUNICIPIO ON DETALLE_ELECCION.idMunicipio = MUNICIPIO.idMunicipio
		INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
		INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
		INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
		INNER JOIN RAZA ON DETALLE_ELECCION.idRaza = RAZA.idRaza
	)SUB1
	GROUP BY SUB1.pais, SUB1.departamento
)SUB3
INNER JOIN
(
	SELECT SUB2.pais as pais,SUM(SUB2.suma) as total FROM 
	(
		SELECT (DETALLE_ELECCION.alfabetos + DETALLE_ELECCION.analfabetos) as suma,DEPARTAMENTO.nombre as departamento,PAIS.nombre as pais FROM DETALLE_ELECCION
		INNER JOIN SEXO ON SEXO.idSexo = DETALLE_ELECCION.idSexo AND SEXO.descripcion LIKE 'mujeres'
		INNER JOIN MUNICIPIO ON DETALLE_ELECCION.idMunicipio = MUNICIPIO.idMunicipio
		INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
		INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
		INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
		INNER JOIN RAZA ON DETALLE_ELECCION.idRaza = RAZA.idRaza
	)SUB2
	GROUP BY SUB2.pais
)SUB4 ON SUB3.pais = SUB4.pais
;

/*CONSULTA 4*/
/*Desplegar todas las regiones por país en las que predomina la raza indígena.
Es decir, hay más votos que las otras razas.*/

SELECT SUB4.pais,SUB3.region,SUB3.tot FROM (
	SELECT MAX(SUB1.suma) AS tot,SUB1.reg AS region,SUB1.nom AS pais FROM
	(
		SELECT PAIS.nombre as nom,REGION.nombre as reg,RAZA.descripcion AS DESCR,(DETALLE_ELECCION.alfabetos + DETALLE_ELECCION.analfabetos) as suma FROM DETALLE_ELECCION
		INNER JOIN MUNICIPIO ON DETALLE_ELECCION.idMunicipio = MUNICIPIO.idMunicipio
		INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
		INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
		INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
		INNER JOIN RAZA ON DETALLE_ELECCION.idRaza = RAZA.idRaza
		GROUP BY nom,reg,suma,RAZA.descripcion
	)AS SUB1
	GROUP BY SUB1.reg,SUB1.nom
)SUB3
INNER JOIN
(
	SELECT MAX(SUB2.suma) AS tot,SUB2.nom AS pais,SUB2.DESCR as raza FROM
	(
		SELECT PAIS.nombre as nom,REGION.nombre as reg,RAZA.descripcion AS DESCR,(DETALLE_ELECCION.alfabetos + DETALLE_ELECCION.analfabetos) as suma FROM DETALLE_ELECCION
		INNER JOIN MUNICIPIO ON DETALLE_ELECCION.idMunicipio = MUNICIPIO.idMunicipio
		INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
		INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
		INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
		INNER JOIN RAZA ON DETALLE_ELECCION.idRaza = RAZA.idRaza
		GROUP BY nom,reg,suma,RAZA.descripcion
	)AS SUB2
	GROUP BY SUB2.nom,SUB2.DESCR
)SUB4 ON SUB4.pais = SUB3.pais AND SUB4.tot = SUB3.tot AND SUB4.raza = 'INDIGENAS'
;


SELECT PAIS.nombre as nom,REGION.nombre as reg,RAZA.descripcion AS descr,(DETALLE_ELECCION.alfabetos + DETALLE_ELECCION.analfabetos) as suma FROM DETALLE_ELECCION
INNER JOIN MUNICIPIO ON DETALLE_ELECCION.idMunicipio = MUNICIPIO.idMunicipio
INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
INNER JOIN RAZA ON DETALLE_ELECCION.idRaza = RAZA.idRaza
GROUP BY nom,reg,suma,RAZA.descripcion
;

/*CONSULTA 7*/
/*Desplegar el nombre del pais, la region y el promedio de votos por
departamento. Por ejemplo: si la region tiene tres departamentos, se debe
sumar todos los votos de la region y dividirlo dentro de tres (nu´mero de
departamentos de la region)*/
SELECT SUB2.pais,SUB2.region, round((SUB2.total/SUB3.cantidad),2) AS promedio FROM
(
	SELECT SUB1.pais as pais,SUB1.region as region,SUM(SUB1.suma) as total FROM
	(
		SELECT PAIS.nombre as pais,REGION.nombre as region,(DETALLE_ELECCION.alfabetos + DETALLE_ELECCION.analfabetos) as suma FROM DETALLE_ELECCION 
		INNER JOIN MUNICIPIO ON DETALLE_ELECCION.idMunicipio = MUNICIPIO.idMunicipio
		INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
		INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
		INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
		GROUP BY REGION.nombre,PAIS.nombre,suma 
	)SUB1
	GROUP BY SUB1.pais,SUB1.region
)SUB2
INNER JOIN
(
	SELECT PAIS.nombre as pais,REGION.nombre as region,COUNT(DEPARTAMENTO.idDepartamento) AS cantidad FROM MUNICIPIO 
	INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
	INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
	INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
	GROUP BY REGION.nombre,PAIS.nombre
) SUB3 ON  SUB2.pais = SUB3.pais AND SUB2.region = SUB3.region
;

/*CONSULTA 8*/
/*Desplegar el total de votos de cada nivel de escolaridad (primario, medio,
universitario) por pai´s, sin importar raza o sexo.*/
SELECT SUM(DETALLE_ELECCION.primaria) AS PRIMARIA,SUM(DETALLE_ELECCION.nivel_medio)AS NIVEL_MEDIO,
SUM(DETALLE_ELECCION.universitario) AS UNIVERSIDAD,PAIS.nombre AS COUNTRY FROM DETALLE_ELECCION
INNER JOIN MUNICIPIO ON DETALLE_ELECCION.idMunicipio = MUNICIPIO.idMunicipio
INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
GROUP BY PAIS.nombre;

/*CONSULTA 9*/
/*Desplegar el nombre del pais y el porcentaje de votos por raza.*/
SELECT SUB3.pais,SUB3.raza,round((SUB3.total/SUB4.total)* 100,2) AS porcentaje FROM 
(
	SELECT SUM(suma) as total, SUB1.pais as pais,SUB1.descr as raza FROM
	(
		SELECT PAIS.nombre as pais,RAZA.descripcion AS descr,(DETALLE_ELECCION.alfabetos + DETALLE_ELECCION.analfabetos) as suma FROM DETALLE_ELECCION
		INNER JOIN MUNICIPIO ON DETALLE_ELECCION.idMunicipio = MUNICIPIO.idMunicipio
		INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
		INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
		INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
		INNER JOIN RAZA ON DETALLE_ELECCION.idRaza = RAZA.idRaza
		GROUP BY pais,suma,RAZA.descripcion
	)SUB1
	GROUP BY SUB1.pais,SUB1.descr
)SUB3
INNER JOIN 
(
	SELECT SUM(suma) as total, SUB2.pais as pais FROM
	(
		SELECT PAIS.nombre as pais,RAZA.descripcion AS descr,(DETALLE_ELECCION.alfabetos + DETALLE_ELECCION.analfabetos) as suma FROM DETALLE_ELECCION
		INNER JOIN MUNICIPIO ON DETALLE_ELECCION.idMunicipio = MUNICIPIO.idMunicipio
		INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
		INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
		INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
		INNER JOIN RAZA ON DETALLE_ELECCION.idRaza = RAZA.idRaza
		GROUP BY pais,suma,RAZA.descripcion
	)SUB2
	GROUP BY SUB2.pais
)SUB4 ON SUB4.pais = SUB3.pais
;

/*CONSULTA 11*/
