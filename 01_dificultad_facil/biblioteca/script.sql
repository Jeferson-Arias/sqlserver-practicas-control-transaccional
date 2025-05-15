use master
go

drop database if exists biblioteca;
go

create database biblioteca;
go

use biblioteca;
go

create table libros (
    id int identity(1,1) primary key,
    titulo rvachar(100) not null,
    autor varchar(100) not null,
    año int not null,
    genero varchar(50) not null,
    cantidad_disponible int not null,
    cantidad_total int not null
);

create table usuarios (
    id int identity(1,1) primary key,
    nombre varchar(100) not null,
    email varchar(100) not null
);

create table prestamos (
    id int identity(1,1) primary key,
    libro_id int not null,
    usuario_id int not null,
    fecha_prestamo date not null,
    fecha_devolucion date,
    estado int not null,-- 1= prestado, 2 = devuelto, 3 = perdido
    constraint chk_estado_prestamos check (estado in (1, 2, 3)),
    constraint fk_prestamos_libro foreign key (libro_id) references libros(id),
    constraint fk_prestamos_usuarios foreign key (usuario_id) references usuarios(id)
);

create table reservas (
    id int identity(1,1) primary key,
    libro_id int not null,
    usuario_id int not null,
    fecha_reserva date not null,
    fecha_expiracion date,
    estado int not null,-- 1= pendiente, 2 = completada, 3 = cancelada, 4 = expirado
    constraint chk_estado_reservas check (estado in (1, 2, 3, 4)),
    constraint fk_reservas_libro foreign key (libro_id) references libros(id),
    constraint fk_reservas_usuarios foreign key (usuario_id) references usuarios(id)
);
go

insert into libros (titulo, autor, año, genero, cantidad_disponible, cantidad_total) values
('El Quijote', 'Miguel de Cervantes', 1605, 'Novela', 5, 10),
('Cien años de soledad', 'Gabriel García Márquez', 1967, 'Novela', 3, 5),
('1984', 'George Orwell', 1949, 'Ciencia ficción', 2, 4),
('El Principito', 'Antoine de Saint-Exupéry', 1943, 'Fábula', 4, 6),
('Crónica de una muerte anunciada', 'Gabriel García Márquez', 1981, 'Novela', 1, 2),
('El amor en los tiempos del cólera', 'Gabriel García Márquez', 1985, 'Novela', 0, 3),
('Rayuela', 'Julio Cortázar', 1963, 'Novela', 2, 4),
('La casa de los espíritus', 'Isabel Allende', 1982, 'Novela', 3, 5),
('Ficciones', 'Jorge Luis Borges', 1944, 'Cuentos', 1, 2),
('El Aleph', 'Jorge Luis Borges', 1949, 'Cuentos', 0, 1),
('La tregua', 'Mario Benedetti', 1960, 'Novela', 2, 3),
('Los ojos de perro sordo', 'Mario Benedetti', 1990, 'Cuentos', 1, 2),
('El túnel', 'Ernesto Sabato', 1948, 'Novela', 3, 4),
('Sobre héroes y tumbas', 'Ernesto Sabato', 1961, 'Novela', 2, 3),
('Rayuela', 'Julio Cortázar', 1963, 'Novela', 1, 2);

insert into usuarios (nombre, email) values
('Juan Pérez', 'juanPerez@prueba.com'),
('María López', 'MariaLopez@prueba.com'),
('Carlos García', 'CarlosGarcia@prueba.com'),
('Ana Fernández', 'AnaGarcia@prueba.com'),
('Luis Martínez', 'LuisMartinez@prueba.com'),
('Laura Sánchez', 'LauraSanchez@prueba.com'),
('Pedro Gómez', 'PedroGomez@prueba.com'),
('Sofía Torres', 'SofiaTorres@prueba.com'),
('Javier Ramírez', 'JavierRamirez@prueba.com'),
('Lucía Díaz', 'LuciaDiaz@prueba.com');

-- Insertando datos de prueba en la tabla prestamos
-- Considerando las restricciones de cantidad_disponible vs cantidad_total

-- Declaración de variables para el rango de fechas (3 meses)
DECLARE @FechaInicio DATE = DATEADD(MONTH, -3, GETDATE());
DECLARE @FechaActual DATE = GETDATE();

-- Insertar préstamos para el libro 'El Quijote' (ID 1)
-- Tiene 5 disponibles de 10 totales, por lo que hay 5 prestados o no disponibles
INSERT INTO prestamos (libro_id, usuario_id, fecha_prestamo, fecha_devolucion, estado)
VALUES 
(1, 1, DATEADD(DAY, -80, @FechaActual), DATEADD(DAY, -65, @FechaActual), 2), -- Devuelto
(1, 3, DATEADD(DAY, -70, @FechaActual), DATEADD(DAY, -55, @FechaActual), 2), -- Devuelto
(1, 5, DATEADD(DAY, -60, @FechaActual), NULL, 1), -- Prestado actualmente
(1, 7, DATEADD(DAY, -50, @FechaActual), NULL, 1), -- Prestado actualmente
(1, 9, DATEADD(DAY, -40, @FechaActual), NULL, 1); -- Prestado actualmente

-- Insertar préstamos para 'Cien años de soledad' (ID 2)
-- Tiene 3 disponibles de 5 totales, por lo que hay 2 prestados o no disponibles
INSERT INTO prestamos (libro_id, usuario_id, fecha_prestamo, fecha_devolucion, estado)
VALUES 
(2, 2, DATEADD(DAY, -75, @FechaActual), NULL, 1), -- Prestado actualmente
(2, 4, DATEADD(DAY, -65, @FechaActual), NULL, 1); -- Prestado actualmente

-- Insertar préstamos para '1984' (ID 3)
-- Tiene 2 disponibles de 4 totales, por lo que hay 2 prestados o no disponibles
INSERT INTO prestamos (libro_id, usuario_id, fecha_prestamo, fecha_devolucion, estado)
VALUES 
(3, 6, DATEADD(DAY, -70, @FechaActual), DATEADD(DAY, -55, @FechaActual), 2), -- Devuelto
(3, 8, DATEADD(DAY, -50, @FechaActual), NULL, 1), -- Prestado actualmente
(3, 10, DATEADD(DAY, -45, @FechaActual), NULL, 1); -- Prestado actualmente

-- Insertar préstamos para 'El Principito' (ID 4)
-- Tiene 4 disponibles de 6 totales, por lo que hay 2 prestados o no disponibles
INSERT INTO prestamos (libro_id, usuario_id, fecha_prestamo, fecha_devolucion, estado)
VALUES 
(4, 1, DATEADD(DAY, -65, @FechaActual), DATEADD(DAY, -50, @FechaActual), 2), -- Devuelto
(4, 3, DATEADD(DAY, -55, @FechaActual), NULL, 1), -- Prestado actualmente
(4, 5, DATEADD(DAY, -45, @FechaActual), NULL, 1); -- Prestado actualmente

-- Insertar préstamos para 'Crónica de una muerte anunciada' (ID 5)
-- Tiene 1 disponible de 2 totales, por lo que hay 1 prestado o no disponible
INSERT INTO prestamos (libro_id, usuario_id, fecha_prestamo, fecha_devolucion, estado)
VALUES 
(5, 7, DATEADD(DAY, -60, @FechaActual), NULL, 1); -- Prestado actualmente

-- Insertar préstamos para 'El amor en los tiempos del cólera' (ID 6)
-- Tiene 0 disponibles de 3 totales, por lo que los 3 están prestados o no disponibles
INSERT INTO prestamos (libro_id, usuario_id, fecha_prestamo, fecha_devolucion, estado)
VALUES 
(6, 2, DATEADD(DAY, -70, @FechaActual), NULL, 1), -- Prestado actualmente
(6, 4, DATEADD(DAY, -65, @FechaActual), NULL, 1), -- Prestado actualmente
(6, 9, DATEADD(DAY, -50, @FechaActual), NULL, 3); -- Perdido

-- Insertar préstamos para 'Rayuela' (ID 7)
-- Tiene 2 disponibles de 4 totales, por lo que hay 2 prestados o no disponibles
INSERT INTO prestamos (libro_id, usuario_id, fecha_prestamo, fecha_devolucion, estado)
VALUES 
(7, 1, DATEADD(DAY, -80, @FechaActual), DATEADD(DAY, -65, @FechaActual), 2), -- Devuelto
(7, 6, DATEADD(DAY, -55, @FechaActual), NULL, 1), -- Prestado actualmente
(7, 10, DATEADD(DAY, -40, @FechaActual), NULL, 1); -- Prestado actualmente

-- Insertar préstamos para 'La casa de los espíritus' (ID 8)
-- Tiene 3 disponibles de 5 totales, por lo que hay 2 prestados o no disponibles
INSERT INTO prestamos (libro_id, usuario_id, fecha_prestamo, fecha_devolucion, estado)
VALUES 
(8, 3, DATEADD(DAY, -75, @FechaActual), DATEADD(DAY, -60, @FechaActual), 2), -- Devuelto
(8, 5, DATEADD(DAY, -50, @FechaActual), NULL, 1), -- Prestado actualmente
(8, 8, DATEADD(DAY, -45, @FechaActual), NULL, 1); -- Prestado actualmente

-- Insertar préstamos para 'Ficciones' (ID 9)
-- Tiene 1 disponible de 2 totales, por lo que hay 1 prestado o no disponible
INSERT INTO prestamos (libro_id, usuario_id, fecha_prestamo, fecha_devolucion, estado)
VALUES 
(9, 9, DATEADD(DAY, -60, @FechaActual), NULL, 1); -- Prestado actualmente

-- Insertar préstamos para 'El Aleph' (ID 10)
-- Tiene 0 disponible de 1 total, por lo que el único ejemplar está prestado o no disponible
INSERT INTO prestamos (libro_id, usuario_id, fecha_prestamo, fecha_devolucion, estado)
VALUES 
(10, 2, DATEADD(DAY, -40, @FechaActual), NULL, 1); -- Prestado actualmente

-- Insertar préstamos para 'La tregua' (ID 11)
-- Tiene 2 disponibles de 3 totales, por lo que hay 1 prestado o no disponible
INSERT INTO prestamos (libro_id, usuario_id, fecha_prestamo, fecha_devolucion, estado)
VALUES 
(11, 4, DATEADD(DAY, -65, @FechaActual), NULL, 1); -- Prestado actualmente

-- Insertar préstamos para 'Los ojos de perro siberiano' (ID 12)
-- Tiene 1 disponible de 2 totales, por lo que hay 1 prestado o no disponible
INSERT INTO prestamos (libro_id, usuario_id, fecha_prestamo, fecha_devolucion, estado)
VALUES 
(12, 6, DATEADD(DAY, -55, @FechaActual), NULL, 1); -- Prestado actualmente

-- Insertar préstamos para 'El túnel' (ID 13)
-- Tiene 3 disponibles de 4 totales, por lo que hay 1 prestado o no disponible
INSERT INTO prestamos (libro_id, usuario_id, fecha_prestamo, fecha_devolucion, estado)
VALUES 
(13, 8, DATEADD(DAY, -70, @FechaActual), NULL, 1); -- Prestado actualmente

-- Insertar préstamos para 'Sobre héroes y tumbas' (ID 14)
-- Tiene 2 disponibles de 3 totales, por lo que hay 1 prestado o no disponible
INSERT INTO prestamos (libro_id, usuario_id, fecha_prestamo, fecha_devolucion, estado)
VALUES 
(14, 10, DATEADD(DAY, -60, @FechaActual), NULL, 1); -- Prestado actualmente

-- Insertar préstamos para 'Rayuela' (ID 15, duplicado en la tabla original)
-- Tiene 1 disponible de 2 totales, por lo que hay 1 prestado o no disponible
INSERT INTO prestamos (libro_id, usuario_id, fecha_prestamo, fecha_devolucion, estado)
VALUES 
(15, 1, DATEADD(DAY, -50, @FechaActual), NULL, 1); -- Prestado actualmente

-- Insertar algunos préstamos históricos adicionales (todos devueltos)
INSERT INTO prestamos (libro_id, usuario_id, fecha_prestamo, fecha_devolucion, estado)
VALUES
(1, 2, DATEADD(DAY, -90, @FechaActual), DATEADD(DAY, -75, @FechaActual), 2),
(2, 3, DATEADD(DAY, -85, @FechaActual), DATEADD(DAY, -70, @FechaActual), 2),
(3, 4, DATEADD(DAY, -80, @FechaActual), DATEADD(DAY, -65, @FechaActual), 2),
(4, 5, DATEADD(DAY, -75, @FechaActual), DATEADD(DAY, -60, @FechaActual), 2),
(5, 6, DATEADD(DAY, -70, @FechaActual), DATEADD(DAY, -55, @FechaActual), 2),
(6, 7, DATEADD(DAY, -90, @FechaActual), DATEADD(DAY, -75, @FechaActual), 2),
(7, 8, DATEADD(DAY, -85, @FechaActual), DATEADD(DAY, -70, @FechaActual), 2),
(8, 9, DATEADD(DAY, -80, @FechaActual), DATEADD(DAY, -65, @FechaActual), 2),
(9, 10, DATEADD(DAY, -75, @FechaActual), DATEADD(DAY, -60, @FechaActual), 2);

-- Insertar datos para la tabla de reservas
INSERT INTO reservas (libro_id, usuario_id, fecha_reserva, fecha_expiracion, estado)
VALUES
-- Reservas pendientes
(6, 1, DATEADD(DAY, -10, @FechaActual), DATEADD(DAY, 5, @FechaActual), 1), -- Pendiente para un libro sin disponibilidad
(10, 3, DATEADD(DAY, -8, @FechaActual), DATEADD(DAY, 7, @FechaActual), 1), -- Pendiente para un libro sin disponibilidad
(5, 2, DATEADD(DAY, -5, @FechaActual), DATEADD(DAY, 10, @FechaActual), 1), -- Pendiente para un libro con poca disponibilidad

-- Reservas completadas
(2, 8, DATEADD(DAY, -30, @FechaActual), DATEADD(DAY, -15, @FechaActual), 2), -- Completada
(3, 5, DATEADD(DAY, -40, @FechaActual), DATEADD(DAY, -25, @FechaActual), 2), -- Completada
(4, 7, DATEADD(DAY, -35, @FechaActual), DATEADD(DAY, -20, @FechaActual), 2), -- Completada

-- Reservas canceladas
(1, 6, DATEADD(DAY, -20, @FechaActual), DATEADD(DAY, -5, @FechaActual), 3), -- Cancelada
(8, 4, DATEADD(DAY, -15, @FechaActual), DATEADD(DAY, 0, @FechaActual), 3), -- Cancelada

-- Reservas expiradas
(9, 9, DATEADD(DAY, -30, @FechaActual), DATEADD(DAY, -15, @FechaActual), 4), -- Expirada
(7, 10, DATEADD(DAY, -25, @FechaActual), DATEADD(DAY, -10, @FechaActual), 4); -- Expirada
GO