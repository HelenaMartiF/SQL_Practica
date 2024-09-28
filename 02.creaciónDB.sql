DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS bootcamp;
DROP TABLE IF EXISTS module;
DROP TABLE IF EXISTS teacher;
DROP TABLE IF EXISTS class;
DROP TABLE IF EXISTS bootcamp_module;
DROP TABLE IF EXISTS enrollment;


--- Creamos tabla Student
CREATE TABLE student(
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    surname VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone INT NOT NULL,
    address VARCHAR(50) NOT NULL,
    date_birth DATE NOT NULL,
    school_enrollment_date DATE NOT NULL
);

--- Creamos tabla Bootcamp
CREATE TABLE bootcamp(
    bootcamp_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(200) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    duration INT NOT NULL
);

--- Creamos la tabla Módulo
CREATE TABLE module(
    module_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(200) NOT NULL,
    duration INT NOT NULL
);

--- Creamos la tabla Profesor
CREATE TABLE teacher(
    teacher_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    surname VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone INT NOT NULL,
    address VARCHAR(50) NOT NULL,
    date_birth DATE NOT NULL,
    subject VARCHAR(100) NOT NULL
);

--- Creamos la tabla Clase
CREATE TABLE class(
    class_id SERIAL PRIMARY KEY,
    teacher_id INT,
    module_id INT,
    class_date DATE NOT NULL,
    class_duration INT NOT NULL,
    FOREIGN KEY (teacher_id) REFERENCES teacher (teacher_id),
    FOREIGN KEY (module_id) REFERENCES module(module_id),
    UNIQUE (teacher_id, module_id)
);

--- Creamos la tabla bootcamp-module
CREATE TABLE bootcamp_module(
    bootcamp_module SERIAL PRIMARY KEY,
    bootcamp_id INT NOT NULL,
    module_id INT NOT NULL,
    FOREIGN KEY (bootcamp_id) REFERENCES bootcamp(bootcamp_id),
    FOREIGN KEY (module_id) REFERENCES module (module_id),
    UNIQUE (bootcamp_id, module_id)
);

--- Creamos la tabla matriculación
CREATE TABLE enrollment(
    enrollment_id SERIAL PRIMARY KEY,
    student_id INT NOT NULL,
    bootcamp_id INT NOT NULL,
    bootcamp_enrollment_date DATE NOT NULL,
    FOREIGN KEY (student_id) REFERENCES student (student_id),
    FOREIGN KEY (bootcamp_id) REFERENCES bootcamp(bootcamp_id)
    UNIQUE(student_id, bootcamp_id)
);





------------------------------ TESTING ---------------------------------------------

INSERT INTO student (name, surname, email, phone, address, date_birth, school_enrollment_date) VALUES
('Helena', 'Marti', 'helenamarti@google.com', '123456789', 'Major 53, 19875 Girona', '1995-07-07', '2022-08-08'),
('Carlos', 'López', 'carloslopez@google.com', '987654321', 'Calle del Sol 12, 08001 Barcelona', '1998-05-15', '2022-08-08'),
('Marta', 'García', 'martagarcia@google.com', '456789123', 'Avenida de la Paz 45, 28001 Madrid', '1997-03-22', '2022-08-08'),
('Luis', 'Fernández', 'luisfernandez@google.com', '321654987', 'Plaza Mayor 7, 50001 Zaragoza', '1996-11-30', '2022-08-08'),
('Ana', 'Pérez', 'anaperez@google.com', '654321789', 'Calle de la Luna 21, 41001 Sevilla', '1999-02-10', '2022-08-08'),
('José', 'Sánchez', 'josesanchez@google.com', '789123456', 'Calle del Río 34, 03001 Alicante', '1995-12-05', '2022-08-08'),
('Lucía', 'Torres', 'luciatorres@google.com', '147258369', 'Calle de la Libertad 18, 15001 A Coruña', '2000-04-20', '2022-08-08'),
('Sofía', 'Hernández', 'sofiahernandez@google.com', '963852741', 'Calle del Mar 10, 46001 Valencia', '1998-09-13', '2022-08-08'),
('David', 'Jiménez', 'davidjimenez@google.com', '852147963', 'Calle del Bosque 88, 28002 Madrid', '1997-06-25', '2022-08-08');


INSERT INTO bootcamp (name, description, start_date, end_date, duration) VALUES
('IA', 'Hola mundo', '2023-08-08', '2024-08-08', 80),
('Desarrollo Web', 'Aprende a crear páginas web', '2023-09-01', '2024-09-01', 100),
('Data Science', 'Análisis de datos y aprendizaje automático', '2023-10-01', '2024-10-01', 120),
('Ciberseguridad', 'Protege tus sistemas y datos', '2023-11-01', '2024-11-01', 90),
('Marketing Digital', 'Estrategias para el mundo digital', '2023-12-01', '2024-12-01', 75),
('Desarrollo Móvil', 'Crea aplicaciones para móviles', '2024-01-01', '2024-07-01', 85),
('UX/UI Design', 'Diseño de experiencia y interfaz de usuario', '2024-02-01', '2024-08-01', 70),
('Blockchain', 'Tecnología de cadena de bloques', '2024-03-01', '2024-09-01', 95),
('Cloud Computing', 'Servicios en la nube y su gestión', '2024-04-01', '2024-10-01', 110);


INSERT INTO module (name, description, duration) VALUES
('la calle', 'hola mundo que tal buenos días todo estupendo', 80),
('Introducción a IA', 'Conceptos básicos de inteligencia artificial', 60),
('HTML y CSS', 'Fundamentos de diseño web con HTML y CSS', 40),
('JavaScript para principiantes', 'Aprende JavaScript desde cero', 70),
('Análisis de datos con Python', 'Herramientas y técnicas para analizar datos', 90),
('Fundamentos de Ciberseguridad', 'Principios básicos de la seguridad informática', 75),
('Desarrollo de aplicaciones móviles', 'Crea aplicaciones para iOS y Android', 85),
('Diseño UX/UI', 'Principios de diseño de experiencia y usuario', 65),
('Introducción a Blockchain', 'Conceptos básicos de la tecnología blockchain', 50);


INSERT INTO teacher (name, surname, email, phone, address, date_birth, subject) VALUES
('Armando', 'el inmortal', 'holaarmando@google.com', '987654321', 'Inframundo 666, 9999 China', '2000-01-01', 'Crisis existenciales'),
('María', 'Luz', 'marialuz@google.com', '123456789', 'Calle del Sol 45, 08001 Barcelona', '1985-03-15', 'Literatura contemporánea'),
('Pedro', 'Pérez', 'pedroperez@google.com', '234567890', 'Avenida de la Paz 21, 28001 Madrid', '1990-07-22', 'Matemáticas avanzadas'),
('Lucía', 'Fernández', 'luciaf@google.com', '345678901', 'Plaza Mayor 7, 50001 Zaragoza', '1992-05-30', 'Ciencias de la computación'),
('Javier', 'García', 'javiergarcia@google.com', '456789012', 'Calle de la Luna 12, 41001 Sevilla', '1988-11-11', 'Historia del arte'),
('Sofía', 'Torres', 'sofiatorres@google.com', '567890123', 'Calle del Río 34, 03001 Alicante', '1995-09-09', 'Biología'),
('Daniel', 'Sánchez', 'danielsanchez@google.com', '678901234', 'Calle de la Libertad 18, 15001 A Coruña', '1993-04-04', 'Física'),
('Elena', 'Jiménez', 'elenajimenez@google.com', '789012345', 'Calle del Mar 10, 46001 Valencia', '1991-06-21', 'Química'),
('Felipe', 'Castro', 'felipecastro@google.com', '890123456', 'Calle del Bosque 88, 28002 Madrid', '1989-02-18', 'Economía');


INSERT INTO class (teacher_id, module_id, class_date, class_duration) VALUES
(1, 9, '2020-08-08', 90),
(2, 1, '2020-08-09', 60),
(3, 5, '2020-08-10', 75),
(4, 2, '2020-08-11', 80),
(5, 6, '2020-08-12', 70),
(6, 3, '2020-08-13', 85),
(7, 4, '2020-08-14', 95),
(8, 7, '2020-08-15', 60),
(9, 8, '2020-08-16', 100);


INSERT INTO bootcamp_module (bootcamp_id, module_id) VALUES
(1, 9),
(2, 1),
(3, 5),
(4, 2),
(5, 6),
(6, 3),
(7, 4),
(8, 7),
(9, 8);


INSERT INTO enrollment (student_id, bootcamp_id, bootcamp_enrollment_date) VALUES
(1, 9, '2023-09-30'),
(2, 1, '2023-09-29'),
(3, 2, '2023-09-28'),
(4, 3, '2023-09-27'),
(5, 4, '2023-09-26'),
(6, 5, '2023-09-25'),
(7, 6, '2023-09-24'),
(8, 7, '2023-09-23'),
(9, 8, '2023-09-22');


