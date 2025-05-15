if object_id('insert_usuarios') is not null
    drop procedure insert_usuarios
go

create procedure insert_usuarios
    @nombre varchar(100),
    @email varchar(100)
as
begin

    declare @mensajeError varchar(100);
    begin try
        begin transaction

        -- Verificar los datos ingresados no esten vacíos
        if @nombre IS NULL OR @nombre = '' OR @email IS NULL OR @email = ''
        begin
            set @mensajeError = 'Ninguna de las variables puede estar vacía o nula';
            throw 50000, @mensajeError, 1;
        end

        -- Verificar si el usuario ya existe mediante el email
        if exists (select 1 from usuarios where email = @email)
        begin
            set @mensajeError = 'El usuario ya existe en la base de datos registrado con el mismo email';
            throw 50000, @mensajeError, 1;
        end

        insert into usuarios (nombre, email)
        values (@nombre, @email);

        print 'Usuario insertado correctamente';
        commit transaction
    end try
    begin catch
        print 'Error: ' + error_message()
        print 'Error ocurre en la línea: ' + cast(error_line() as varchar(10))
        rollback transaction
    end catch

end

-- ============================================
-- ====== Estructura para insertar datos ======
-- ============================================

--ejemplo de uso
DECLARE @nombre varchar(100) = 'Juan Pérez';
DECLARE @email varchar(100) = 'juanPerez@prueba.com';

EXEC insert_usuarios @nombre, @email