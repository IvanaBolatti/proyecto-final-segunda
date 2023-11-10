CREATE SCHEMA biblioteca;
USE biblioteca;

CREATE TABLE editorial(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(45) NOT NULL,
    contacto VARCHAR(50)
);

CREATE TABLE nacionalidad(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    nombre VARCHAR(40) NOT NULL
);

CREATE TABLE serie(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(40) NOT NULL
);

CREATE TABLE tematica(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(40) NOT NULL
);

CREATE TABLE ubicacion(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(40) NOT NULL
);

CREATE TABLE autor(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL,
    apellido VARCHAR (25) NOT NULL,
    id_nacionalidad INT NOT NULL,
    FOREIGN KEY (id_nacionalidad) REFERENCES nacionalidad (id),
    fecha_nacim DATE NOT NULL
);

CREATE TABLE NEW_AUTOR(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL,
    apellido VARCHAR (24) NOT NULL,
    id_nacionalidad INT NOT NULL,
    FOREIGN KEY (id_nacionalidad) REFERENCES nacionalidad (id),
    fecha_nacim DATE NOT NULL
);

CREATE TABLE NEW_AUTOR_MAYOR(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL,
    apellido VARCHAR (25) NOT NULL,
    id_nacionalidad INT NOT NULL,
    FOREIGN KEY (id_nacionalidad) REFERENCES nacionalidad (id)
);

CREATE TABLE ilustrador(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL,
    apellido VARCHAR (25) NOT NULL,
    id_nacionalidad INT NOT NULL,
    FOREIGN KEY (id_nacionalidad) REFERENCES nacionalidad (id),
    fecha_nacim DATE NOT NULL
);

select * from ilustrador;

CREATE TABLE lector(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    nombre VARCHAR(25) NOT NULL, 
    apellido VARCHAR(25)NOT NULL,
    contacto VARCHAR(50)
);

CREATE TABLE libro(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(40) NOT NULL,
    id_autor INT NOT NULL,
    FOREIGN KEY (id_autor) REFERENCES autor (id),
    id_ilustrador INT NOT NULL,
    FOREIGN KEY (id_ilustrador) REFERENCES ilustrador (id),
    id_editorial INT NOT NULL,
    FOREIGN KEY (id_editorial) REFERENCES editorial (id),
    id_tematica INT NOT NULL,
    FOREIGN KEY (id_tematica) REFERENCES tematica (id),
    id_serie INT NOT NULL,
    FOREIGN KEY (id_serie) REFERENCES serie (id),
    detalle VARCHAR(50),
    edad INT
);

select * from libro;

CREATE TABLE ejemplar (
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
id_libro INT NOT NULL,
FOREIGN KEY (id_libro) REFERENCES libro (id),
id_ubicacion INT NOT NULL,
FOREIGN KEY (id_ubicacion) REFERENCES ubicacion (id),
estado VARCHAR(20) NOT NULL
);

CREATE TABLE prestamo (
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
id_ejemplar INT NOT NULL,
FOREIGN KEY (id_ejemplar) REFERENCES ejemplar (id),
id_lector INT NOT NULL,
FOREIGN KEY (id_lector) REFERENCES lector (id),
f_pedido DATE,
f_devolucion DATE,
detalle VARCHAR(60)
);

select * FROM ubicacion;
select * FROM ejemplar;

INSERT INTO nacionalidad VALUES 
(NULL,"argentino"),
(NULL,"brasilero"),
(NULL,"peruano"),
(NULL,"mexicano");

INSERT INTO ubicacion VALUES 
(NULL,"zona verde"),
(NULL,"zona azul"),
(NULL,"zona amarilla"),
(NULL,"zona roja");


SELECT * FROM ubicacion;

INSERT INTO autor VALUES 
(NULL,"Juan", "Carlos", 2, '1987/12/13'),
(NULL,"Pedro", "Alfonso", 1, '1978/02/17'),
(NULL,"Raúl","Perez", 2, '1987/08/06'),
(NULL,"Roberto","Segura", 4, '1984/07/30'),
(NULL,"Romina","Moyano", 1, '1967/05/13'),
(NULL,"Teresa", "Perez", 3, '971/09/14'),
(NULL,"Tamara", "Martinez", 2, '1965/12/23'),
(NULL,"Carolina", "Colorado", 1, '1970/02/21'),
(NULL,"Tania", "Cabas", 2, '1975/08/08'),
(NULL,"Maria", "Recalde", 4, '1984/07/30'),
(NULL,"Camilo", "Gomez", 1, '1967/05/13'),
(NULL,"Nicolas","Milanes", 3, '971/09/14');

select * from editorial;
select * FROM ilustrador;
select * FRom autor;

CREATE VIEW autores_argentinos AS 
(SELECT a.nombre, a.apellido FROM autor a  JOIN nacionalidad n on a.id_nacionalidad="2");

CREATE VIEW ejemplar_perdidos AS 
(SELECT * FROM  ejemplar WHERE estado LIKE "perdido");

CREATE VIEW libros_elegidos AS
(SELECT l.id, l.titulo FROM libro l JOIN prestamo p JOIN ejemplar e on e.id=p.id_ejemplar and e.id_libro=l.id);

CREATE OR REPLACE VIEW autores_nacionalidad AS
(SELECT a.nombre FROM autor a JOIN nacionalidad n on a.id_nacionalidad=n.id);

CREATE VIEW series AS 
SELECT s.id, s.nombre FROM serie s;

CREATE OR REPLACE VIEW tematicas AS 
SELECT t.nombre FROM tematica t;

select * from autor;

DELIMITER //
CREATE FUNCTION buscar_autor (clave int)
RETURNS varchar(20)
DETERMINISTIC
BEGIN
DECLARE nombre_encontrado VARCHAR (20);
SET nombre_encontrado="inexistente";
SELECT autor.nombre into nombre_encontrado FROM autor WHERE autor.id=clave;
RETURN nombre_encontrado;
END//

SELECT buscar_autor(9);

DELIMITER //
CREATE FUNCTION rango_edad (edad int)
RETURNS varchar(20)
DETERMINISTIC
BEGIN
DECLARE rango VARCHAR (20);
SET rango="";
CASE 
WHEN edad <=30 THEN RETURN "menor de 30";
WHEN edad >30 AND edad <60 THEN RETURN "entre 30 y 60";
WHEN edad >60 THEN RETURN "mayor a 60";
END CASE;
RETURN rango;
END//

DELIMITER //
CREATE FUNCTION edad (fecha DATE)
RETURNS int
DETERMINISTIC
BEGIN
DECLARE edad int;
SET edad=YEAR(NOW()) - YEAR(fecha);
RETURN edad;
END//

SELECT edad ("1980/12/12");
SELECT i.nombre, i.apellido, rango_edad(SELECT edad (i.fecha_nacim)) FROM ilustrador i;


