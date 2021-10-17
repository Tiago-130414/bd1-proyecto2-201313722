USE Proyecto2;
/*CONSULTA 1*/
/*Desplegar para cada elección el país y el partido político que obtuvo mayor
porcentaje de votos en su país. Debe desplegar el nombre de la elección, el
año de la elección, el país, el nombre del partido político y el porcentaje que
obtuvo de votos en su país.*/
SELECT SUB6.elec AS NombreEleccion, SUB7.ano as Año,SUB6.pais as Pais,SUB7.partido as Partido,round((SUB7.maximo/SUB6.TOTAL)*100,4) as Porcentaje FROM (
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
SELECT SUB3.pais,SUB3.departamento,SUB3.votosM, round((SUB3.votosM/SUB4.total) *100,4) as porcentaje FROM 
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

/*CONSULTA 3*/
/*Desplegar el nombre del país, nombre del partido político y número de
alcaldías de los partidos políticos que ganaron más alcaldías por país.*/
SELECT SUB5.Pais,SUB5.Partido,SUB5.Cantidad FROM 
(
	SELECT SUB2.Pais,SUB2.Partido,COUNT(SUB2.Partido) AS Cantidad FROM
	(
		SELECT PAIS.nombre AS Pais,DEPARTAMENTO.nombre AS Departamento,MUNICIPIO.nombre AS Municipio, FECHA_ELECCION.anoEleccion AS Fecha,
		PARTIDO.nombre AS Partido ,SUM(DETALLE_ELECCION.alfabetos + DETALLE_ELECCION.analfabetos) as Suma FROM DETALLE_ELECCION
		INNER JOIN FECHA_ELECCION ON DETALLE_ELECCION.idFechaEleccion = FECHA_ELECCION.idFechaEleccion
		INNER JOIN PARTIDO ON DETALLE_ELECCION.idPartido = PARTIDO.idPartido
		INNER JOIN MUNICIPIO ON DETALLE_ELECCION.idMunicipio = MUNICIPIO.idMunicipio
		INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
		INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
		INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
		GROUP BY Pais,Departamento,Municipio,Fecha,Partido
	)SUB2
	INNER JOIN
	(
		SELECT SUB1.Pais,SUB1.Departamento,SUB1.Municipio,MAX(SUB1.Suma) AS votos FROM 
		(
		SELECT PAIS.nombre AS Pais,DEPARTAMENTO.nombre AS Departamento,MUNICIPIO.nombre AS Municipio, FECHA_ELECCION.anoEleccion AS Fecha,
		PARTIDO.nombre AS Partido ,SUM(DETALLE_ELECCION.alfabetos + DETALLE_ELECCION.analfabetos) as Suma FROM DETALLE_ELECCION
		INNER JOIN FECHA_ELECCION ON DETALLE_ELECCION.idFechaEleccion = FECHA_ELECCION.idFechaEleccion
		INNER JOIN PARTIDO ON DETALLE_ELECCION.idPartido = PARTIDO.idPartido
		INNER JOIN MUNICIPIO ON DETALLE_ELECCION.idMunicipio = MUNICIPIO.idMunicipio
		INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
		INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
		INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
		GROUP BY Pais,Departamento,Municipio,Fecha,Partido
		)SUB1
		GROUP BY SUB1.Pais,SUB1.Departamento,SUB1.Municipio
	)SUB3 ON SUB2.Pais = SUB3.Pais AND SUB2.Departamento = SUB3.Departamento AND SUB2.Municipio = SUB3.Municipio AND SUB2.Suma = SUB3.votos 
	GROUP BY SUB2.Pais,SUB2.Partido
)SUB5
INNER JOIN
(
	SELECT SUB4.Pais,MAX(SUB4.Cantidad) AS Maximo FROM
	(
		SELECT SUB2.Pais,SUB2.Partido,COUNT(SUB2.Partido) AS Cantidad FROM
		(
			SELECT PAIS.nombre AS Pais,DEPARTAMENTO.nombre AS Departamento,MUNICIPIO.nombre AS Municipio, FECHA_ELECCION.anoEleccion AS Fecha,
			PARTIDO.nombre AS Partido ,SUM(DETALLE_ELECCION.alfabetos + DETALLE_ELECCION.analfabetos) as Suma FROM DETALLE_ELECCION
			INNER JOIN FECHA_ELECCION ON DETALLE_ELECCION.idFechaEleccion = FECHA_ELECCION.idFechaEleccion
			INNER JOIN PARTIDO ON DETALLE_ELECCION.idPartido = PARTIDO.idPartido
			INNER JOIN MUNICIPIO ON DETALLE_ELECCION.idMunicipio = MUNICIPIO.idMunicipio
			INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
			INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
			INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
			GROUP BY Pais,Departamento,Municipio,Fecha,Partido
		)SUB2
		INNER JOIN
		(
			SELECT SUB1.Pais,SUB1.Departamento,SUB1.Municipio,MAX(SUB1.Suma) AS votos FROM 
			(
			SELECT PAIS.nombre AS Pais,DEPARTAMENTO.nombre AS Departamento,MUNICIPIO.nombre AS Municipio, FECHA_ELECCION.anoEleccion AS Fecha,
			PARTIDO.nombre AS Partido ,SUM(DETALLE_ELECCION.alfabetos + DETALLE_ELECCION.analfabetos) as Suma FROM DETALLE_ELECCION
			INNER JOIN FECHA_ELECCION ON DETALLE_ELECCION.idFechaEleccion = FECHA_ELECCION.idFechaEleccion
			INNER JOIN PARTIDO ON DETALLE_ELECCION.idPartido = PARTIDO.idPartido
			INNER JOIN MUNICIPIO ON DETALLE_ELECCION.idMunicipio = MUNICIPIO.idMunicipio
			INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
			INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
			INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
			GROUP BY Pais,Departamento,Municipio,Fecha,Partido
			)SUB1
			GROUP BY SUB1.Pais,SUB1.Departamento,SUB1.Municipio
		)SUB3 ON SUB2.Pais = SUB3.Pais AND SUB2.Departamento = SUB3.Departamento AND SUB2.Municipio = SUB3.Municipio AND SUB2.Suma = SUB3.votos 
		GROUP BY SUB2.Pais,SUB2.Partido
	)SUB4
	GROUP BY SUB4.Pais
)SUB6 ON SUB5.Pais = SUB6.Pais AND SUB5.Cantidad = SUB6.Maximo
;
/*CONSULTA 4*/
/*Desplegar todas las regiones por país en las que predomina la raza indígena.
Es decir, hay más votos que las otras razas.*/
SELECT SUB4.Pais,SUB4.Region,SUB4.Total FROM 
(
	SELECT SUB3.Pais AS Pais,SUB3.Region AS Region,SUB3.Raza AS Raza,SUM(SUB3.total) AS Total FROM
	(
		SELECT PAIS.nombre AS Pais,REGION.nombre AS Region,RAZA.descripcion as Raza,(DETALLE_ELECCION.alfabetos + DETALLE_ELECCION.analfabetos) as total  FROM DETALLE_ELECCION
		INNER JOIN RAZA ON DETALLE_ELECCION.idRaza = RAZA.idRaza
		INNER JOIN MUNICIPIO ON DETALLE_ELECCION.idMunicipio = MUNICIPIO.idMunicipio
		INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
		INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
		INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
	)SUB3
	GROUP BY SUB3.Pais,SUB3.Region,SUB3.Raza
)SUB4
INNER JOIN
(
	SELECT SUB2.Pais AS Pais,SUB2.Region AS Region,MAX(SUB2.total) AS Maximo FROM
	(
		SELECT SUB1.Pais as Pais,SUB1.Region as Region,SUB1.Raza as Raza,SUM(SUB1.total) as total FROM
		(
			SELECT PAIS.nombre AS Pais,REGION.nombre AS Region,RAZA.descripcion as Raza,(DETALLE_ELECCION.alfabetos + DETALLE_ELECCION.analfabetos) as total  FROM DETALLE_ELECCION
			INNER JOIN RAZA ON DETALLE_ELECCION.idRaza = RAZA.idRaza
			INNER JOIN MUNICIPIO ON DETALLE_ELECCION.idMunicipio = MUNICIPIO.idMunicipio
			INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
			INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
			INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
		)SUB1
		GROUP BY SUB1.Pais,SUB1.Region,SUB1.Raza
	)SUB2
	GROUP BY SUB2.Pais,SUB2.Region
) SUB5 ON SUB5.Pais = SUB4.Pais AND SUB5.Maximo = SUB4.Total
WHERE SUB4.Raza LIKE 'INDIGENAS'
;

/*CONSULTA 5*/
/*Desplegar el nombre del país, el departamento, el municipio y la cantidad de
votos universitarios de todos aquellos municipios en donde la cantidad de
votos de universitarios sea mayor que el 25% de votos de primaria y menor
que el 30% de votos de nivel medio. Ordene sus resultados de mayor a
menor.*/
SELECT SUB2.Pais AS Pais,SUB2.Departamento AS Departamento,SUB2.Municipio AS Municipio,SUB2.UNIVERSIDAD FROM
(
	SELECT SUB1.Pais AS Pais,SUB1.Departamento AS Departamento,SUB1.Municipio AS Municipio,
    SUB1.UNIVERSIDAD,
    SUB1.PRIMARIA/SUB1.ALF*100 AS PP,
    SUB1.NIVEL_MEDIO/SUB1.ALF*100 AS PNM,
    SUB1.UNIVERSIDAD/SUB1.ALF*100 AS PU FROM 
	(
		SELECT PAIS.nombre AS Pais,DEPARTAMENTO.nombre AS Departamento,MUNICIPIO.nombre AS Municipio,
		SUM(DETALLE_ELECCION.alfabetos) AS ALF,
		SUM(DETALLE_ELECCION.primaria) AS PRIMARIA,
		SUM(DETALLE_ELECCION.nivel_medio) AS NIVEL_MEDIO,
		SUM(DETALLE_ELECCION.universitario) AS UNIVERSIDAD FROM DETALLE_ELECCION
		INNER JOIN MUNICIPIO ON DETALLE_ELECCION.idMunicipio = MUNICIPIO.idMunicipio
		INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
		INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
		INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
		GROUP BY Pais,Departamento,Municipio
	)SUB1
)SUB2
WHERE SUB2.PP > 25 AND SUB2.PNM < 30
;

/*CONSULTA 6*/
/*Desplegar el porcentaje de mujeres universitarias y hombres universitarios
que votaron por departamento, donde las mujeres universitarias que votaron
fueron más que los hombres universitarios que votaron.*/
SELECT SUB3.Pais,SUB3.Departamento,SUB3.Sexo,SUB3.Porcentaje,SUB4.Sexo,SUB4.Porcentaje FROM 
(
	SELECT SUB1.Pais AS Pais,SUB1.Departamento AS Departamento,SUB1.Sexo AS Sexo,(SUB1.suma/SUB2.suma)*100 AS Porcentaje FROM
	(
		SELECT PAIS.nombre AS Pais,DEPARTAMENTO.nombre AS Departamento,SEXO.descripcion AS Sexo, SUM(DETALLE_ELECCION.universitario) as suma FROM DETALLE_ELECCION
		INNER JOIN SEXO ON DETALLE_ELECCION.idSexo = SEXO.idSexo AND SEXO.descripcion = 'mujeres'
		INNER JOIN MUNICIPIO ON DETALLE_ELECCION.idMunicipio = MUNICIPIO.idMunicipio
		INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
		INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
		INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
		GROUP BY PAIS.nombre,DEPARTAMENTO.nombre,SEXO.descripcion
	)SUB1
	INNER JOIN
	(
		SELECT PAIS.nombre AS Pais,DEPARTAMENTO.nombre AS Departamento, SUM(DETALLE_ELECCION.universitario) as suma FROM DETALLE_ELECCION
		INNER JOIN MUNICIPIO ON DETALLE_ELECCION.idMunicipio = MUNICIPIO.idMunicipio
		INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
		INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
		INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
		GROUP BY PAIS.nombre,DEPARTAMENTO.nombre
	)SUB2 ON SUB2.Pais = SUB1.Pais AND SUB2.Departamento = SUB1.Departamento
)SUB3
INNER JOIN
(
	SELECT SUB1.Pais AS Pais,SUB1.Departamento AS Departamento,SUB1.Sexo AS Sexo,(SUB1.suma/SUB2.suma)*100 AS Porcentaje FROM
	(
		SELECT PAIS.nombre AS Pais,DEPARTAMENTO.nombre AS Departamento,SEXO.descripcion AS Sexo, SUM(DETALLE_ELECCION.universitario) as suma FROM DETALLE_ELECCION
		INNER JOIN SEXO ON DETALLE_ELECCION.idSexo = SEXO.idSexo AND SEXO.descripcion = 'hombres'
		INNER JOIN MUNICIPIO ON DETALLE_ELECCION.idMunicipio = MUNICIPIO.idMunicipio
		INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
		INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
		INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
		GROUP BY PAIS.nombre,DEPARTAMENTO.nombre,SEXO.descripcion
	)SUB1
	INNER JOIN
	(
		SELECT PAIS.nombre AS Pais,DEPARTAMENTO.nombre AS Departamento, SUM(DETALLE_ELECCION.universitario) as suma FROM DETALLE_ELECCION
		INNER JOIN MUNICIPIO ON DETALLE_ELECCION.idMunicipio = MUNICIPIO.idMunicipio
		INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
		INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
		INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
		GROUP BY PAIS.nombre,DEPARTAMENTO.nombre
	)SUB2 ON SUB2.Pais = SUB1.Pais AND SUB2.Departamento = SUB1.Departamento
)SUB4 ON SUB4.Pais = SUB3.Pais AND SUB4.Departamento = SUB3.Departamento
WHERE SUB3.Porcentaje > SUB4.Porcentaje
;

/*CONSULTA 7*/
/*Desplegar el nombre del pais, la region y el promedio de votos por
departamento. Por ejemplo: si la region tiene tres departamentos, se debe
sumar todos los votos de la region y dividirlo dentro de tres (nu´mero de
departamentos de la region)*/
SELECT SUB2.pais,SUB2.region, SUB2.total/SUB3.cantidad FROM 
(
	SELECT SUB1.Pais as pais,SUB1.Region as region,SUM(suma) as total FROM 
	(
		SELECT PAIS.nombre AS Pais,REGION.nombre AS Region, DEPARTAMENTO.nombre as Departamento,(DETALLE_ELECCION.alfabetos + DETALLE_ELECCION.analfabetos) as suma FROM DETALLE_ELECCION
		INNER JOIN MUNICIPIO ON DETALLE_ELECCION.idMunicipio = MUNICIPIO.idMunicipio
		INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
		INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
		INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
	)SUB1
	GROUP BY SUB1.Pais,SUB1.Region
)SUB2
INNER JOIN 
(
	SELECT PAIS.nombre as pais,REGION.nombre as region,COUNT(DEPARTAMENTO.idDepartamento) as cantidad FROM DEPARTAMENTO
	INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
	INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
	GROUP BY PAIS.nombre,REGION.nombre
)SUB3 ON SUB3.pais = SUB2.pais AND SUB3.region = SUB2.region
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
SELECT SUB3.pais,SUB3.raza,round((SUB3.total/SUB4.total)* 100,4) AS porcentaje FROM 
(
	SELECT SUM(suma) as total, SUB1.pais as pais,SUB1.descr as raza FROM
	(
		SELECT PAIS.nombre as pais,RAZA.descripcion AS descr,(DETALLE_ELECCION.alfabetos + DETALLE_ELECCION.analfabetos) as suma FROM DETALLE_ELECCION
		INNER JOIN MUNICIPIO ON DETALLE_ELECCION.idMunicipio = MUNICIPIO.idMunicipio
		INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
		INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
		INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
		INNER JOIN RAZA ON DETALLE_ELECCION.idRaza = RAZA.idRaza
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
	)SUB2
	GROUP BY SUB2.pais
)SUB4 ON SUB4.pais = SUB3.pais
;

/*CONSULTA 10*/
/*Desplegar el nombre del país en el cual las elecciones han sido más
peleadas. Para determinar esto se debe calcular la diferencia de porcentajes
de votos entre el partido que obtuvo más votos y el partido que obtuvo menos
votos.*/

SELECT SUB5.Pais AS Pais,(SUB6.Maximo - SUB7.Minimo) AS Diferencia FROM 
(
	SELECT SUB1.Pais AS Pais,SUB1.Partido AS Partido, SUM(SUB1.Total) AS Total FROM 
	(
		SELECT PAIS.nombre AS Pais,PARTIDO.nombre AS Partido,(DETALLE_ELECCION.alfabetos + DETALLE_ELECCION.analfabetos) AS Total FROM DETALLE_ELECCION
		INNER JOIN PARTIDO ON PARTIDO.idPartido = DETALLE_ELECCION.idPartido
		INNER JOIN MUNICIPIO ON  MUNICIPIO.idMunicipio = DETALLE_ELECCION.idMunicipio
		INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
		INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
		INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
	)SUB1
	GROUP BY Pais,Partido
)SUB5
INNER JOIN
(
	SELECT SUB2.Pais AS Pais,MAX(SUB2.Total) AS Maximo FROM 
	(
		SELECT SUB1.Pais AS Pais,SUB1.Partido AS Partido, SUM(SUB1.Total) AS Total FROM 
		(
			SELECT PAIS.nombre AS Pais,PARTIDO.nombre AS Partido,(DETALLE_ELECCION.alfabetos + DETALLE_ELECCION.analfabetos) AS Total FROM DETALLE_ELECCION
			INNER JOIN PARTIDO ON PARTIDO.idPartido = DETALLE_ELECCION.idPartido
			INNER JOIN MUNICIPIO ON  MUNICIPIO.idMunicipio = DETALLE_ELECCION.idMunicipio
			INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
			INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
			INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
		)SUB1
		GROUP BY Pais,Partido
	)SUB2
	GROUP BY SUB2.Pais
)SUB6 ON SUB5.Pais = SUB6.Pais
INNER JOIN
(
	SELECT SUB4.Pais AS Pais,MIN(SUB4.Total) AS Minimo FROM 
	(
		SELECT SUB3.Pais AS Pais,SUB3.Partido AS Partido, SUM(SUB3.Total) AS Total FROM 
		(
			SELECT PAIS.nombre AS Pais,PARTIDO.nombre AS Partido,(DETALLE_ELECCION.alfabetos + DETALLE_ELECCION.analfabetos) AS Total FROM DETALLE_ELECCION
			INNER JOIN PARTIDO ON PARTIDO.idPartido = DETALLE_ELECCION.idPartido
			INNER JOIN MUNICIPIO ON  MUNICIPIO.idMunicipio = DETALLE_ELECCION.idMunicipio
			INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
			INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
			INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
		)SUB3
		GROUP BY Pais,Partido
	)SUB4
	GROUP BY SUB4.Pais
)SUB7 ON SUB5.Pais = SUB7.Pais
GROUP BY SUB5.Pais,Diferencia
ORDER BY Diferencia ASC LIMIT 1
;

/*CONSULTA 11*/
/*Desplegar el total de votos y el porcentaje de votos emitidos por mujeres
indígenas alfabetas.*/
SELECT SUB1.Pais,SUB1.Votos,Round((SUB1.Votos/SUB2.Votos)*100,4) AS Porcentaje FROM 
(
	SELECT PAIS.nombre AS Pais,SUM(DETALLE_ELECCION.alfabetos) AS Votos FROM DETALLE_ELECCION
	INNER JOIN SEXO ON SEXO.idSexo = DETALLE_ELECCION.idSexo AND SEXO.descripcion LIKE 'mujeres'
	INNER JOIN RAZA ON RAZA.idRaza = DETALLE_ELECCION.idRaza AND RAZA.descripcion LIKE 'INDIGENAS'
	INNER JOIN MUNICIPIO ON  MUNICIPIO.idMunicipio = DETALLE_ELECCION.idMunicipio
	INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
	INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
	INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
	GROUP BY PAIS.nombre,SEXO.descripcion
)SUB1
INNER JOIN (
	SELECT SUB3.Pais AS Pais,SUM(SUB3.Total) AS Votos FROM
	(
		SELECT PAIS.nombre AS Pais,(DETALLE_ELECCION.alfabetos + DETALLE_ELECCION.analfabetos) AS Total FROM DETALLE_ELECCION
		INNER JOIN MUNICIPIO ON  MUNICIPIO.idMunicipio = DETALLE_ELECCION.idMunicipio
		INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
		INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
		INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
	)SUB3
	GROUP BY SUB3.Pais
)SUB2 ON SUB1.Pais = SUB2.Pais
;

/*CONSULTA 12*/
/*Desplegar el nombre del país, el porcentaje de votos de ese país en el que
han votado mayor porcentaje de analfabetas. (tip: solo desplegar un nombre
de país, el de mayor porcentaje).*/
SELECT SUB1.Pais AS Pais,Round((SUB1.Votos/SUB2.Votos)*100,4) AS Porcentaje FROM 
(
	SELECT PAIS.nombre AS Pais,SUM(DETALLE_ELECCION.analfabetos) AS Votos FROM DETALLE_ELECCION
	INNER JOIN MUNICIPIO ON  MUNICIPIO.idMunicipio = DETALLE_ELECCION.idMunicipio
	INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
	INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
	INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
	GROUP BY PAIS.nombre
)SUB1
INNER JOIN (
	SELECT SUB3.Pais AS Pais,SUM(SUB3.Total) AS Votos FROM
	(
		SELECT PAIS.nombre AS Pais,(DETALLE_ELECCION.alfabetos + DETALLE_ELECCION.analfabetos) AS Total FROM DETALLE_ELECCION
		INNER JOIN MUNICIPIO ON  MUNICIPIO.idMunicipio = DETALLE_ELECCION.idMunicipio
		INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
		INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
		INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
	)SUB3
	GROUP BY SUB3.Pais
)SUB2 ON SUB1.Pais = SUB2.Pais
ORDER BY Porcentaje DESC LIMIT 1
;

/*CONSULTA 13*/
/*Desplegar la lista de departamentos de Guatemala y número de votos
obtenidos, para los departamentos que obtuvieron más votos que el
departamento de Guatemala.*/
SELECT SUB4.Pais,SUB4.Departamento,SUB4.Total FROM
(
	SELECT SUB1.Pais AS pais,SUB1.departamento AS Departamento,SUM(SUB1.Total) as Total FROM 
	(
		SELECT PAIS.nombre AS pais,DEPARTAMENTO.nombre as departamento,(DETALLE_ELECCION.alfabetos + DETALLE_ELECCION.analfabetos) AS Total  FROM DETALLE_ELECCION
		INNER JOIN MUNICIPIO ON MUNICIPIO.idMunicipio = DETALLE_ELECCION.idMunicipio
		INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
		INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
		INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
	)SUB1
	WHERE SUB1.pais LIKE 'GUATEMALA' AND departamento LIKE 'Guatemala'
	GROUP BY SUB1.pais,SUB1.departamento
)SUB3
INNER JOIN (
	SELECT SUB2.Pais AS Pais,SUB2.departamento AS Departamento,SUM(SUB2.Total) as Total FROM 
	(
		SELECT PAIS.nombre AS pais,DEPARTAMENTO.nombre as departamento,(DETALLE_ELECCION.alfabetos + DETALLE_ELECCION.analfabetos) AS Total  FROM DETALLE_ELECCION
		INNER JOIN MUNICIPIO ON MUNICIPIO.idMunicipio = DETALLE_ELECCION.idMunicipio
		INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.idDepartamento = MUNICIPIO.idDepartamento
		INNER JOIN REGION ON REGION.idRegion = DEPARTAMENTO.idRegion
		INNER JOIN PAIS ON PAIS.idPais = REGION.idPais
	)SUB2
	WHERE SUB2.pais LIKE 'GUATEMALA'
	GROUP BY SUB2.pais,SUB2.departamento
)SUB4 ON SUB4.Pais = SUB3.Pais
WHERE SUB4.Total> SUB3.Total
;


