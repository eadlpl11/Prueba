/* 
Cecilia Janeth Dominguez Hinojos    1119150038 
Elmer Aaron De la Peña López        1119150046
Irving Iván Cano Paniagua           1119150007
Materia: Base de Datos para aplicacion 
Maestro Dynhora D, Ramirez Ochoa
UNIVERSIDAD TECNOLOGICA DE CHIHUAHUA
TECNOLOGIAS DE LA INFORMACION AREA DESARROLLO
GRUPO : TID31M

Descripicion: Este software permite encontrar un maestro o tutor para tener una consultoría,
la consultoría es por medio de una videollamada y para que el alumno encuentre al tutor adecuado
se utilizan una serie de filtros, el maestro tendrá una serie de características que según encajen
con los parámetros utilizados serán mostrados. Los parámetros tienen que ver con las habilidades o
materias que el maestro pueda impartir, que además estarán clasificadas según el nivel (básico, 
intermedio, experto).

Una vez encontrado el maestro, hay dos opciones para tener la consultoría, la primera es iniciarla
en ese momento para lo que el maestro deberá estar en linea, el alumno hará la petición, y el maestro
confirmara el inicio de la clase. La segunda opción puede darse en caso de que el maestro no este en 
linea o simplemente se desee hacer la reunión en otro momento, para lo cual se podrá agendar la cita.

Cada sesión será obligatoriamente puntuada, este puntaje servira para verificar si el maestro es 
competente o no. Una vez inscrito el maestro en la plataforma le serán asignadas 3 clases que tiene 
que brindar de manera gratiuta en las cuales tiene que obtener una puntuación mínima, si no la obtiene 
en al menos 2 clases, se le brindara una nueva oportunidad para que obtenga la puntuación mínima de 4 
estrellas, estos maestros además servirán para dar un periodo de prueba al usuario (sin costo adicional
para la plataforma).


Fecha de inicio: 28 de marzo del 2020
Fecha de la ultima modificacion: 30 de junio del 2020
Fecha final: 30 de junio del 2020


-- Es posible que un atributo de maestro actualice su su puntaje total

*/

#Creación de base de datos
create database if not exists detlos;
use detlos;

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Estructura de la base de datos

#Creación de la tabla usuario
create table if not exists usuario(
id_usuario int(5) 		auto_increment, -- pk
pass varchar(30) 		not null,
nickname varchar(30) 	not null,
primary key(id_usuario)
)
engine = InnoDB
auto_increment=1; -- Todos los ID de Usuario inician en 0 y terminan en 1000

#Creación de la tabla maestro
create table if not exists maestro(
id_maestro int(5) 			auto_increment,		-- pk
nombre_1 varchar(20) 		not null,
nombre_2 varchar(20) 		null,
apellido_1 varchar(20) 		not null,
apellido_2 varchar(20) 		null,
especialidad varchar(30) 	not null,                -- Area en la que da oportunidad
valoracion float(5,2) 		default 0 null,
num_sesiones int (5)		default 1 null,
primary key(id_maestro)
)engine = InnoDB
auto_increment=1001;
-- Todas los ID de Maestro inician en 1001 y terminan en 2000

#Creación de la tabla sesión
create table if not exists sesion(
id_sesion 	int(5) 		auto_increment,			-- pk
usuario	  	int(5) 		not null,				-- fk
maestro   	int(5) 		not null,				-- fk
fecha	  	date		null,				-- esta es la fecha y hora de inicio
puntuacion	float(5,2)		not null,
primary key(id_sesion)
)engine = InnoDB
auto_increment=2001;
-- TOdos los ID de sesionse inician en 2001


create table if not exists habilidades(	
id_habilidad int(5) 		auto_increment,		-- pk
id_maestro 	int(5) 			not null,			-- fk
habilidad 	varchar(15) 	not null,			-- ejemplo "java,excel,speech"
nivel		varchar(15)		not null,			-- describe el nivel de la habilidad, ejemplo "básico, intermedio, avanzado"
primary key(id_habilidad)					
)engine = InnoDB
auto_increment=3001;
-- Todos los ID Habilidad inician en 3001

create table if not exists pagos(
id_pago int(5) auto_increment,
id_sesion int(5) not null,
monto int (5) not null,
primary key(id_pago)
)
engine = InnoDB;

-- Crea tablas para saber quien modifico la base de datos
    create table bitacoras(
    id_bi            	int         		not null 			auto_increment,
    usuario            	varchar(40),
    tabla            	varchar(40),
    modificacion    	datetime,
    accion            	varchar(40),
    primary key(id_bi))
    engine = innodb;
    
    set SQL_SAFE_UPDATES=0;
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
															#CREACIÓN DE LLAVES FORANEAS

alter table pagos add foreign key (id_sesion)
references sesion(id_sesion);

alter table habilidades add foreign key(id_maestro)
references maestro(id_maestro);

alter table sesion add foreign key(maestro)
references maestro(id_maestro);

alter table sesion add foreign key(usuario)
references usuario(id_usuario);


#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
														#CREACION DE PROCEDIMIENTOS

#Procedimiento para ingresar datos en la tabla usuario
drop procedure if exists  insert_usuario;
delimiter $$
create procedure insert_usuario (n_pass varchar(30),n_nickname varchar(30))
begin
insert into usuario(pass,nickname)
values(n_pass,n_nickname);
end $$
delimiter ;
SELECT * FROM usuario where id_usuario = 1;


#Procedimiento para borrar un usuario especificado
drop procedure if exists  del_usuario;
delimiter $$
create procedure del_usuario (n_id int (5))
begin
delete from usuario where id_usuario = n_id;
end $$
delimiter ;



#Procedimiento para actualizar un usuario especificado
drop procedure if exists upd_usuario;
delimiter $$
create procedure upd_usuario(n_id int(5),n_pass varchar(30),n_nickname varchar (30))
begin
update usuario
set
usuario.pass = n_pass,
usuario.nickname = n_nickname
where usuario.id_usuario = n_id;
end $$
delimiter ;


#Procedimiento para ingresar datos en la tabla de sesion
drop procedure if exists  insert_sesion;
delimiter $$
create procedure insert_sesion (n_usuario int(5),n_maestro int(5),n_puntuacion float (5,2), n_fecha date)
begin
insert into sesion(usuario,maestro,puntuacion, fecha)
values(n_usuario,n_maestro,n_puntuacion,n_fecha);
end $$
delimiter ;


#Procedimiento para borrar una sesion especificada
drop procedure if exists  del_sesion;
delimiter $$
create procedure del_sesion (n_id int (5))
begin
delete from sesion where id_sesion = n_id;
end $$
delimiter ;

select * from sesion;
# Procedimiento para actualizar datos de una sesion especificada
drop procedure if exists upd_sesion;
delimiter $$
create procedure upd_sesion(n_id int(5),n_usuario int(5),n_maestro int (5),n_puntuacion float(5,2))
begin
update sesion 
set
usuario = n_usuario,
maestro = n_maestro,
puntuacion = n_puntuacion
where sesion.id_sesion = n_id; 
end $$
delimiter ;

# Permite seleccionar que valor cambiar de la tabla sesion excepto fecha
drop procedure if exists update_sesion_switch;
DELIMITER //
CREATE PROCEDURE update_sesion_switch(id int,texto varchar(15),valor int)

BEGIN
	CASE texto
		WHEN "usuario" THEN UPDATE sesion SET usuario=valor WHERE sesion.id_sesion = id;
        WHEN "maestro" THEN UPDATE sesion SET maestro=valor WHERE sesion.id_sesion = id;
        WHEN "puntuacion" THEN UPDATE sesion SET puntuacion=valor WHERE sesion.id_sesion = id;
        -- WHEN "fecha" THEN UPDATE sesion SET fecha=valor WHERE sesion.id_sesion = id;
	ELSE
		BEGIN
			SELECT "no se puede actualizar fecha por que el tipo de dato no corresponde";
        END;
	END CASE ;
END //
	
DELIMITER ;

# Procedimiento que verificara la existencia de un usario dentro de los registros.
drop procedure if exists verificar_usuario;
 delimiter $$
	create procedure verificar_usuario(id_usuario int (5))
	begin 
	if not exists (
	select usuario.id_usuario from usuario WHERE usuario.id_usuario = id_usuario) then
	select "El usario seleccionado no existe";
	else
	select 'El usario si existe';
	end if;
	end $$
 delimiter ;


# Procedimiento el cual verificara la existencia de un maestro, si el maestro no se encuentra en ningun registro se insertaran los datos

drop procedure if exists insertar_maestro;
delimiter // 
create procedure insertar_maestro(n_id_maestro int(20), nombre1_maestro varchar (20), apellido1_maestro varchar (20), 
                        nombre2_maestro varchar(20), apellido2_maestro varchar(20), especialidad_maestro varchar(20))
    comment 'Procedimiento que inserta un maestro a la base de datos'
    begin 
if not exists (
    select M.id_maestro
    from maestro as M
    WHERE M.id_maestro = n_id_maestro) 
    then
    insert into maestro(id_maestro,nombre_1, nombre_2, apellido_1, apellido_2,especialidad)
    values(n_id_maestro,nombre1_maestro , apellido1_maestro, nombre2_maestro, apellido2_maestro, especialidad_maestro);

else
    select 'Este maestro ya existe';
end if;
end //
delimiter ;

# Procedimiento para insertar un usuario con su nombre de usuario y contraseña
drop procedure if exists  insert_usuario;
delimiter $$
create procedure insert_usuario (n_pass varchar(30),n_nickname varchar(30))
begin
insert into usuario(pass,nickname)
values(n_pass,n_nickname);
end $$
delimiter ;

#Procedimiento para ingresar datos en la tabla habilidades
DROP PROCEDURE IF EXISTS insert_habilidaes;
DELIMITER //
CREATE PROCEDURE insert_habilidades (_habilidad varchar(15),_id_maestro int(5), _nivel varchar(15))
BEGIN
	insert into habilidades(habilidad,id_maestro,nivel)
	values (_habilidad,_id_maestro, _nivel);
    end //
DELIMITER ;


# Procedimiento para insertar datos en la tabla pagos, se requiere el id de la sesión el monto pagado
DROP PROCEDURE IF EXISTS insert_pagos;
DELIMITER //
CREATE PROCEDURE insert_pagos(_id_sesion int(5), _monto int(5))
BEGIN
	INSERT INTO pagos(id_sesion, monto)
    VALUES(_id_sesion, _monto);
END //
DELIMITER //


#Procedimiento el cual cambia la fecha, siempre y cuando no sea una fecha inferior a la de hoy se requiere la fecha y la sesión a modificar
drop procedure if exists cambiar_fecha;
delimiter //
create procedure cambiar_fecha(dia date, sesion_id int)
comment "Procedimiento que cambia la fecha de una sesión"
begin
DECLARE dias int;
set dias = DATEDIFF(dia,curdate());

if dias >= 0 then
update sesion
set fecha = dia
WHERE id_sesion = sesion_id;

else SELECT "Fecha incorrecta intente de nuevo";

end if;
end //
DELIMITER ;


# Actualiza el nombre de un maestro dentro de la tabla SESIÓN por medio de 2 ID
--
drop procedure if exists update_nombre_maestro;
delimiter //
create procedure update_nombre_maestro(id_cambiado int(30),id_cambiar int (30))
begin

UPDATE sesion
SET maestro = id_cambiar
WHERE maestro = (SELECT id_maestro FROM maestro
WHERE id_maestro = id_cambiado);

end //
delimiter ;









#Procedimiento para ingresar datos en la tabla usuario
drop procedure if exists  insert_maestro;
delimiter $$
create procedure insert_maestro (	_nombre_1 varchar(20), _nombre_2 varchar(20), 
									_apellido_1 varchar(20), _apellido_2 varchar(20),
                                    _especialidad varchar(20), _valoracion varchar (20))
begin
insert into maestro(nombre_1,nombre_2,apellido_1,apellido_2,especialidad,valoracion)
values(_nombre_1,_nombre_2,_apellido_1,_apellido_2,_especialidad,_valoracion);
end $$
delimiter ;








DROP PROCEDURE IF EXISTS transaction_insert_sesion;
delimiter //
create procedure transaction_insert_sesion(n_usuario int(5),n_maestro int(5),n_puntuacion float (5,2), n_fecha date,a boolean)
begin
START TRANSACTION;
insert into sesion(usuario,maestro,puntuacion, fecha)
values(n_usuario,n_maestro,n_puntuacion,n_fecha);
    SELECT * FROM sesion;
    SELECT "SI QUIERE CONFIRMAR LOS CAMBIOS INSERTE true
			SI QUIERE DESCARTAR LOS CAMBIOS INSERTE false";           
    IF a=true THEN 
		SELECT "COMMIT";
        commit;
	ELSE
        SELECT "ROLLBACK";
        rollback;
	END IF ;
	SELECT * FROM sesion;
    end //
delimiter ;

call transaction_insert_sesion(10,1002,4.0,'2020-06-28',true);




# Permite seleccionar que valor cambiar de la tabla sesion excepto fecha
drop procedure if exists transaction_update_sesion_switch;
DELIMITER //
CREATE PROCEDURE transaction_update_sesion_switch(id int,texto varchar(15),valor int, a boolean)

BEGIN
	START TRANSACTION;
	CASE texto
		WHEN "usuario" THEN UPDATE sesion SET usuario=valor WHERE sesion.id_sesion = id;
        WHEN "maestro" THEN UPDATE sesion SET maestro=valor WHERE sesion.id_sesion = id;
        WHEN "puntuacion" THEN UPDATE sesion SET puntuacion=valor WHERE sesion.id_sesion = id;
        -- WHEN "fecha" THEN UPDATE sesion SET fecha=valor WHERE sesion.id_sesion = id;
	ELSE
		BEGIN
			SELECT "no se puede actualizar fecha por que el tipo de dato no corresponde";
		END;
	END CASE;
        
	IF a=true THEN 
		SELECT "COMMIT";
        commit;
	ELSE
        SELECT "ROLLBACK";
        rollback;
	END IF ;	  
    
	SELECT * FROM sesion;
END //
DELIMITER ;

-- comprobacion
call transaction_update_sesion_switch(2001,'usuario',1,false);
SELECT * FROM sesion;


START TRANSACTION;
delete from pagos where id_sesion = 2034;
select * from pagos;
    call del_sesion(2034);
    SELECT * FROM sesion;

    select "SI QUIERE CONFIRMAR LOS CAMBIOS INSERTE true
            SI QUIERE DESCARTAR LOS CAMBIOS INSERTE false";

    SELECT * FROM sesion;
    call confirmacion(false);
    SELECT * FROM sesion;
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
														#CREACIÓN DE TRIGGERS


#Trigger el cual inserta en una tabla cuando hay una eliminacion en la tabla de usario.
delimiter //
create trigger Del_usuario
before delete on usuario
for each row
begin
insert into bitacoras(usuario,tabla,modificacion,accion)
values(user(),"Usuario",NOW(),"ELIMINAR");
END //
delimiter ;


#Trigger el cual inserta en una tabla cuando un hay un insert en la tabla de usuario.
delimiter //
create trigger Alt_usuario
before insert on usuario
for each row
begin
insert into bitacoras(usuario,tabla,modificacion,accion)
values(user(),"Usuario",NOW(),"INSERT");
END//
delimiter ;


/* CREAR UN DISPARADOR QUE REGISTRE INFORMACIÓN EN LA BITÁCORA, 
DESPUÉS DE QUE SE ACTUALICE ALGÚN REGISTRO EN LA TABLA USUARIO*/
delimiter //
create trigger usuario_update
before update on usuario
for each row
begin
insert into bitacoras(usuario,tabla,modificacion,accion)
values(user(),"Usuario",NOW(),"UPDATE");
END//
delimiter ;

/* CREAR UN DISPARADOR QUE REGISTRE INFORMACIÓN EN LA BITÁCORA, 
DESPUÉS DE QUE SE INGRESE ALGÚN REGISTRO EN LA TABLA SESION*/

delimiter //
create trigger bitacora_insert
before insert on sesion
for each row
begin
insert into bitacoras(usuario,tabla,modificacion,accion)
values(user(),"SESION",NOW(),"INSERT");
END//
delimiter ;

-- comprobación
INSERT INTO maestro (nombre_1,nombre_2,apellido_1,apellido_2,especialidad,valoracion)
values("Indalecio", "Placencia", "Cifuentes", 'Rodríguez',"Economía",4);
SELECT * FROM maestro;


/* CREAR UN DISPARADOR QUE REGISTRE INFORMACIÓN EN LA BITÁCORA, 
DESPUÉS DE QUE SE ACTUALICE ALGÚN REGISTRO EN LA TABLA SESION*/

delimiter //
create trigger bitacora_update
before update on sesion
for each row
begin
insert into bitacoras(usuario,tabla,modificacion,accion)
values(user(),"Sesion",NOW(),"UPDATE");
END//
delimiter ;



-- comprobación
UPDATE maestro set nombre_1 = "Rumia" WHERE id_maestro = 1041;
SELECT * FROM maestro;





/* CREAR UN DISPARADOR QUE REGISTRE INFORMACIÓN EN LA BITÁCORA, 
DESPUÉS DE QUE SE ELIMINA UN REGISTRO EN LA TABLA CLIENTE    */

delimiter //
create trigger bitacora_delete
before delete on sesion
for each row
begin
insert into bitacoras(usuario,tabla,modificacion,accion)
values(user(),"Sesion",NOW(),"DELETE");
END//
delimiter ;

-- comprobación
DELETE FROM maestro WHERE id_maestro = 1041;
SELECT * FROM maestro;
SELECT * FROM bitacoras;




#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

																		-- ALTA DE REGISTROS 
#INDICE
-- USUARIO
-- MAESTRO
-- SESIÓN
-- HABILIDADES


-- USUARIO      
call insert_usuario('12345','Raul Peres');
call insert_usuario('78954','Cesar Matias');
call insert_usuario('74589','Brandon Martinez');
call insert_usuario('14523','Eduardo Carrera');
call insert_usuario('1487','Cecilia Dominguez');
call insert_usuario('1235','Ana Gutierrez');
call insert_usuario('78951','Alexis Mendoza');
call insert_usuario('14892','Ever Rios');
call insert_usuario('14782','Rosa Sandoval');
call insert_usuario('14782','Fatima Tigo');
call insert_usuario('14782','Jesus Ramos');
call insert_usuario('14822','Juan Gonzalo');
call insert_usuario('47861','Victoria Rios');
call insert_usuario('14785','Fabiola Hinojos');
call insert_usuario('78954','Susana Olivas');
call insert_usuario('44788','Jazmin Garcia');
call insert_usuario('14782','Janeth Vazques');
call insert_usuario('14782','Jose De la Torre');
call insert_usuario('2478','Alan Borunda');
call insert_usuario('14455','Jair Torres');
call insert_usuario('78942','Ivan Garcia');
call insert_usuario('14574','Irving Aviles');
call insert_usuario('548423','Sofia Guerrero');
call insert_usuario('5441','Daniel Rosales');
call insert_usuario('517485','Luis Solano');
call insert_usuario('8979','Cesar Llanquin');
call insert_usuario('55452','Jesius Moran');
call insert_usuario('17892','Aaron Galvan');
call insert_usuario('1458','Armando Dominguez');
call insert_usuario('23685','Hugo Carrera');
call insert_usuario('14789','Carol Medina');
call insert_usuario('36987','Pedro Hernandez');
call insert_usuario('12348','Maria Rodriguez');
call insert_usuario('14552','Jesus Zamora');
call insert_usuario('54412','Ivette Gomez');
call insert_usuario('12255','Minerva Olivas');
call insert_usuario('74589','Ernesto Estada');
call insert_usuario('1455','Perla Guerrero');
call insert_usuario('4555','Lourdes Garcia');
call insert_usuario('7894','Claudia Hinojos');


-- MAESTRO
call insert_maestro ("JUAN", "MANUEL", "AZCONA", "SOLANO", "Programacion", 	1	);
call insert_maestro ("JOSE", "CARLOS", "REVUELTA", "CASTAÑO", "Diseño web", 	4	);
call insert_maestro ("FRANCISCO", " JAVIER", "ARRANZ", "SAAVEDRA", "Diseño web", 	5	);
call insert_maestro ("RAUL", "DOS", "SANTOS", "PRAT", "Programacion", 	2	);
call insert_maestro ("JUAN", "MANUEL", "ARRIAGA", "BORJA", "Economia", 	1	);
call insert_maestro ("MARIA", "CRISTINA", "LLORCA", "VADILLO", "Arte",	3	);
call insert_maestro ("EMILIA", "BLAZQUEZ", "SAN", "EMETERIO", "Diseño",	1	);
call insert_maestro ("Etna", "Lobato", "Corres", 'Fernández',"Inglés",	4	);
call insert_maestro ("Thelma", "Molinillo", "Lorden", 'López',"Back end", 	5);
call insert_maestro ("Dafne", "Aizpurua", "Retes", 'González',"Economía", 	4	);
call insert_maestro ("Irais", "Vicastillo", "Bazan", 'López',"Diseño", 	5	);
call insert_maestro ("Gerardo", "Rabanera", "Cerezuela", 'González',"Back end", 	2	);
call insert_maestro ("Narcelith", "Arroyuelo", "Ruano", 'López',"Back end", 	2	);
call insert_maestro ("Juan", "Lejarazu", "Baltuile", 'Martínez',"Diseño web", 	2	);
call insert_maestro ("Fabiola", "Cerezo", "Cabria", 'Gómez',"Diseño web", 	5	);
call insert_maestro ("Rebeca", "Arana", "Cayado", 'Sánchez',"portugués", 	4	);
call insert_maestro ("Sabel", "Gimenez", "Rebolledo", 'Pérez',"Programación", 	4	);
call insert_maestro ("Tiburcio", "Arando", "Anguciana", 'García',"Arte", 	4	);
call insert_maestro ("Indalecio", "Placencia", "Cifuentes", 'Rodríguez',"Economía", 	1	);
call insert_maestro ("Isael", "Bedoya", "Casal", 'Gómez',"Back end", 	4	);
call insert_maestro ("Devyaní", "Minayo", "Valladares", 'Rodríguez',"IOT", 	3	);
call insert_maestro ("Dina", "Erus", "Argandoña", 'Pérez',"Diseño web", 	3	);
call insert_maestro ("Ataulfo", "Aro", "Echeverria", 'Martín',"Economía", 	3	);
call insert_maestro ("Quino", "Pedrero", "Cirarruista", 'Ruiz',"Diseño web", 	4	);
call insert_maestro ("Paulina", "Merecilla", "Velez", 'Gómez',"Arduino", 	5	);
call insert_maestro ("Dámaso", "Gamez", "Monje", 'Pérez',"portugués", 	5	);
call insert_maestro ("Ambar", "Recio", "Enebro", 'Gómez',"Base de datos", 	3	)	;
call insert_maestro ("Ninoska", "Sagrario", "Estebanez", 'Rodríguez',"electrónica", 	5	)	;
call insert_maestro ("Deyanira", "Sobaler", "Marron", 'Ruiz',"Diseño", 	1	)	;
call insert_maestro ("Iván", "Talavera", "Oñaederra", 'Gómez',"Back end", 	2	)	;
call insert_maestro ("Vicente", "Salas", "Narria", 'Ruiz',"Programación", 	1	)	;
call insert_maestro ("Ariana", "Sudupe", "Gallardo", 'Martín',"Back end", 	5	)	;
call insert_maestro ("Kitzia", "Carro", "Vicioso", 'Gómez',"portugués", 	3	)	;
call insert_maestro ("Nemesio", "San", "Pelon", 'García',"Diseño", 	1	)	;
call insert_maestro ("Jamytzin", "Cendan", "Cisneros", 'Pérez',"Diseño web", 	5	)	;
call insert_maestro ("Quetzalcoatl", "Peroria", "Usabiaga", 'Pérez',"Arduino", 	5	)	;
call insert_maestro ("Marian", "Burdeos", "Puebla", 'Pérez',"Arduino", 	1	)	;
call insert_maestro ("Berthana", "Roberto", "Linares", 'González',"portugués", 	4	)	;
call insert_maestro ("Rodimiro", "Bugedo", "Tarano", 'González',"Programación", 	5	)	;
call insert_maestro ("Amaia", "Salterain", "Santavida", 'Martínez',"Calculo", 	1);

select * from sesion;
-- Insert sesion
call insert_sesion(1,1001,4,'2020-06-21');
call insert_sesion(2,1002,4,'2020-06-21');
call insert_sesion(3,1003,4,'2020-06-21');
call insert_sesion(4,1004,4,'2020-06-21');
call insert_sesion(5,1005,4,'2020-06-21');
call insert_sesion(6,1006,4,'2020-06-21');
call insert_sesion(7,1007,4,'2020-06-21');
call insert_sesion(8,1008,4,'2020-06-21');
call insert_sesion(9,1009,4,'2020-06-21');
call insert_sesion(10,1010,4,'2020-06-21');
call insert_sesion(11,1011,4,'2020-06-21');
call insert_sesion(12,1012,4,'2020-06-21');
call insert_sesion(13,1013,4,'2020-06-21');
call insert_sesion(14,1014,4,'2020-06-21');
call insert_sesion(15,1015,4,'2020-06-21');
call insert_sesion(16,1016,4,'2020-06-21');
call insert_sesion(17,1017,4,'2020-06-21');
call insert_sesion(18,1018,4,'2020-06-21');
call insert_sesion(19,1019,4,'2020-06-21');
call insert_sesion(20,1020,4,'2020-06-21');
call insert_sesion(21,1021,4,'2020-06-21');
call insert_sesion(22,1022,4,'2020-06-21');
call insert_sesion(23,1023,4,'2020-06-21');
call insert_sesion(24,1024,4,'2020-06-21');
call insert_sesion(25,1025,4,'2020-06-21');
call insert_sesion(26,1026,4,'2020-06-21');
call insert_sesion(27,1027,4,'2020-06-21');
call insert_sesion(28,1028,4,'2020-06-21');
call insert_sesion(29,1029,4,'2020-06-21');
call insert_sesion(30,1030,4,'2020-06-21');
call insert_sesion(31,1031,4,'2020-06-21');
call insert_sesion(32,1032,4,'2020-06-21');
call insert_sesion(33,1033,4,'2020-06-21');
call insert_sesion(34,1034,4,'2020-06-21');
call insert_sesion(35,1035,4,'2020-06-21');
call insert_sesion(36,1036,4,'2020-06-21');
call insert_sesion(37,1037,4,'2020-06-21');
call insert_sesion(38,1038,4,'2020-06-21');
call insert_sesion(39,1039,4,'2020-06-21');
call insert_sesion(40,1040,4,'2020-06-21');

-- HABILIDADES
call insert_habilidades("Java",1001,"básico");
call insert_habilidades("Java Script",1002,"intermedio");
call insert_habilidades("React",1003,"experto");
call insert_habilidades("Python",1004,"básico");
call insert_habilidades("Excel",1005,"intermedio");
call insert_habilidades("Pintura",1006,"experto");
call insert_habilidades("Photoshop",1007,"básico");
call insert_habilidades("Speech",1008,"intermedio");
call insert_habilidades("Ensamblador",1009,"experto");
call insert_habilidades("Probabilidad",1010,"básico");
call insert_habilidades("Photoshop",1011,"intermedio");
call insert_habilidades("Java",1012,"experto");
call insert_habilidades("Ensamblador",1013,"básico");
call insert_habilidades("HTML",1014,"intermedio");
call insert_habilidades("HTML",1015,"experto");
call insert_habilidades("Ortografía",1016,"básico");
call insert_habilidades("Pseudocódigo",1017,"intermedio");
call insert_habilidades("Puntullismo",1018,"experto");
call insert_habilidades("Excel",1019,"básico");
call insert_habilidades("Ensamblador",1020,"intermedio");
call insert_habilidades("Python",1021,"experto");
call insert_habilidades("Angular",1022,"básico");
call insert_habilidades("Excel",1023,"intermedio");
call insert_habilidades("Java Script",1024,"experto");
call insert_habilidades("Arduino",1025,"básico");
call insert_habilidades("Ortografía",1026,"intermedio");
call insert_habilidades("MySQL",1027,"experto");
call insert_habilidades("Arduino",1028,"básico");
call insert_habilidades("Dibujo",1029,"intermedio");
call insert_habilidades("Python",1030,"experto");
call insert_habilidades("Kotlin",1031,"básico");
call insert_habilidades("C++",1032,"intermedio");
call insert_habilidades("Ortografía",1033,"experto");
call insert_habilidades("DibujoTcnico",1034,"básico");
call insert_habilidades("React",1035,"intermedio");
call insert_habilidades("Soldadura",1036,"experto");
call insert_habilidades("IoT",1037,"básico");
call insert_habilidades("Speech",1038,"intermedio");
call insert_habilidades("C++",1039,"experto");
call insert_habilidades("Derivadas",1040,"básico");


-- INSERT pagos
call insert_pagos(2001,500);
call insert_pagos(2002,500);
call insert_pagos(2003,500);
call insert_pagos(2004,500);
call insert_pagos(2005,500);
call insert_pagos(2006,500);
call insert_pagos(2007,500);
call insert_pagos(2008,500);
call insert_pagos(2009,500);
call insert_pagos(2010,500);
call insert_pagos(2011,500);
call insert_pagos(2012,500);
call insert_pagos(2013,500);
call insert_pagos(2014,500);
call insert_pagos(2015,500);
call insert_pagos(2016,500);
call insert_pagos(2017,500);
call insert_pagos(2018,500);
call insert_pagos(2019,500);
call insert_pagos(2020,500);
call insert_pagos(2021,500);
call insert_pagos(2022,500);
call insert_pagos(2023,500);
call insert_pagos(2024,500);
call insert_pagos(2025,500);
call insert_pagos(2026,500);
call insert_pagos(2027,500);
call insert_pagos(2028,500);
call insert_pagos(2029,500);
call insert_pagos(2030,500);
call insert_pagos(2031,500);
call insert_pagos(2032,500);
call insert_pagos(2033,500);
call insert_pagos(2034,500);
call insert_pagos(2035,500);
call insert_pagos(2036,500);
call insert_pagos(2037,500);
call insert_pagos(2038,500);
call insert_pagos(2039,500);
call insert_pagos(2040,500);

	
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
																			#CREACIÓN DE CONSULTAS
                                   
-- Consultas simples        
                   
-- Muestra el "Maestro del mes" que es el maestro con valoración más alta dada por el usuario
SELECT concat(maestro.nombre_1," ",maestro.apellido_1) AS "Maestro del mes", maestro.valoracion AS Valoración
FROM maestro
ORDER BY valoracion desc
LIMIT 1;        

-- Los maestros con valoracion de 1 pasaran a tener valoracion de 3
set @V1=(select min(maestro.valoracion) from maestro);
Update maestro set valoracion = 3  where valoracion =  @V1;

-- MUESTA EL APELLIDO Y NOMBRE DEL MAESRTO, ORDENANDOLOS ALFABÉTICAMENTE, POR APELLIDO
SELECT concat(apellido_1, " ",nombre_1 )AS Maestro
FROM maestro
ORDER BY maestro.apellido_1 asc
LIMIT 5;

-- Muestra la contraseña más larga junto con el nombre de usuario
SELECT usuario.nickname AS Usuario, usuario.pass AS Contraseña
FROM usuario
ORDER BY LENGTH(usuario.pass) desc
LIMIT 3;



-- Consultas complejas

-- Mostrar la sesiones con nombre del maestro, usuario, y clase recibida de todos los alumnos que empiezan con "d"
SELECT usuario.nickname AS Usuario, concat(maestro.nombre_1," ",maestro.apellido_1) AS Maestro, habilidades.habilidad AS Clase
FROM usuario, maestro, habilidades,sesion
WHERE usuario.id_usuario = sesion.usuario 
AND sesion.maestro = maestro.id_maestro 
AND habilidades.id_maestro = maestro.id_maestro 
AND usuario.nickname LIKE "a%";

-- Mostrar los profesores con nivel basico de Java
select concat(M.nombre_1," ",M.apellido_1) AS Nombre,M.especialidad,H.nivel, H.habilidad
from maestro as M, habilidades as H
where M.especialidad = "Programación" and H.nivel="Basico" and H.habilidad = "Java";

select concat(M.nombre_1," ",M.apellido_1) AS Nombre,M.especialidad,H.nivel, H.habilidad
from maestro as M, habilidades as H
WHERE (H.habilidad = "Java"  and  H.id_maestro = M.id_maestro) or (M.especialidad = "Programacion"  and  H.id_maestro = M.id_maestro);

-- Muestra el nombre de los maestros con nivel "Experto"x
SELECT M.nombre_1, N.nivel
FROM maestro as M, habilidades as N
WHERE M.id_maestro=N.id_maestro and N.nivel="experto";

-- Selecciona el nombre del maestro, su nivel y habilidad
SELECT M.nombre_1, H.nivel, H.habilidad
FROM maestro as M, habilidades as H
WHERE M.id_maestro=H.id_maestro;



-- Subconsultas

-- Subconsulta que busca profesores expertos en programación
SELECT maestro.nombre_1
FROM maestro
WHERE id_maestro IN (
SELECT habilidades.id_maestro
FROM habilidades
WHERE habilidades.nivel LIKE "%experto%")
AND maestro.especialidad LIKE "%progra%";


-- Monstrar los maestros por encima del promedio
SELECT concat(maestro.nombre_1," ",maestro.apellido_1) AS Nombre, maestro.valoracion AS Valoración
from maestro
where maestro.valoracion > (select avg(maestro.valoracion) from maestro)
order by (valoracion) desc;

-- Mostar los alumnos que hayan puntuado con más de 3 unidades
SELECT usuario.nickname
FROM usuario
WHERE usuario.id_usuario IN(
SELECT sesion.usuario
FROM sesion
WHERE sesion.puntuacion > 3);



-- Crear vistas

-- Despliega nombre de usuario, maestro y la clase o materia impartida
CREATE VIEW vista1 as(SELECT usuario.nickname AS Usuario, concat(maestro.nombre_1," ",maestro.apellido_1) AS Maestro, habilidades.habilidad AS Clase
FROM usuario, maestro, habilidades,sesion
WHERE usuario.id_usuario = sesion.usuario 
AND sesion.maestro = maestro.id_maestro 
AND habilidades.id_maestro = maestro.id_maestro 
AND usuario.nickname LIKE "a%");


-- Mostrar los maestros de programacion con la valoracion mas baja
create view vista2 as(select concat(M.nombre_1," ",M.apellido_1) AS Nombre,M.especialidad, min(M.valoracion) as Valoracion
from maestro as M
where M.especialidad = "Programación"
order by M.nombre_1);

-- Aparece el profe que tenga un Nivel "Básico" y que habilidades tenian
CREATE VIEW vista3 as (SELECT M.nombre_1, H.nivel, H.habilidad
FROM maestro as M, habilidades as H
WHERE M.id_maestro=H.id_maestro and H.nivel= "Basico");


-- Comprobación de todos los procedimientos

# Verificacion de procedimiento
call insert_usuario('Rumia456','EADLPL11');
select * from usuario;


# Verificacion de procedimiento
call del_usuario(41);
select * from usuario;

#Verificacion del proceso
call upd_usuario(1,12345,'ivann');
select * from usuario; 

# Verificacion de procedimiento de insercion
call insert_sesion(2,1002,4,'2020-06-21');
select * from sesion;

# Verificacion de procedimiento de eliminacion de sesion
call del_sesion(2042);
select *from sesion;

# Verifiacion de procedimiento actualizacion de sesion
call upd_sesion(2001,2,1004,0.0);
select * from bitacoras;

# Verifiacion de procedimiento
call verificar_usuario(100);

# Verifiacion de procedimiento
call insertar_maestro(1202,"Alfonso","paco","Martinez","Sakura","Java");
select * from maestro;

-- Llamada a este procedimiento:
call cambiar_fecha('2020-06-20',2002);

# Verificacion del procedimiento
call update_nombre_maestro("1001","1004");
SELECT * FROM sesion;


insert into usuario(pass,nickname)
values(n_pass,n_nickname);