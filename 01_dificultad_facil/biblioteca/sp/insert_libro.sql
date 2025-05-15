if object_id('insert_libros') is not null
    drop procedure insert_libros
go

create procedure insert_libros
    @titulo varchar(100),
    @autor varchar(100),
    @año int,
    @genero varchar(50),
    @cantidad_disponible int,
    @cantidad_total int
as
begin
    
    declare @mensajeError varchar(100)

    
    begin try
		begin transaction
        -- Verificar los datos ingresados no esten vacíos
        
        if @titulo IS NULL OR @titulo = '' OR @autor IS NULL OR @autor = '' OR @genero IS NULL OR @genero = ''
        begin
            SET @mensajeError = 'Ninguna de las variables puede estar vacía o nula';
            THROW 50000, @mensajeError, 1;
        end

        -- Verificar si el libro ya existe
        if exists (select 1 from libros where titulo = @titulo and autor = @autor)
        begin
            set @mensajeError = 'El libro ya existe en la base de datos';
            throw 50000, @mensajeError, 1;
        end

        -- Verificar que el cantidad_disponibole y cantidad_total sean válidos y misma cantidad
        if not (@cantidad_disponible = @cantidad_total AND @cantidad_disponible > 0)
        begin
            set @mensajeError = 'La cantidad disponible y total deben ser iguales y mayores a 0';
            throw 50000, @mensajeError, 1;
        end

        insert into libros (titulo, autor, año, genero, cantidad_disponible, cantidad_total)
        values (@titulo, @autor, @año, @genero, @cantidad_disponible, @cantidad_total);

        print 'Libro insertado correctamente';
        commit transaction
    end try
    begin catch

        print 'Error: ' + error_message()
        print 'Error ocurre en la línea: ' + cast(error_line() as varchar(10))
        rollback transaction
        print 'Transacción revertida'
    end catch

end


-- ============================================
-- ====== Estructura para insertar datos ======
-- ============================================

-- Ejemplo de uso
DECLARE @titulo varchar(100) = 'El otoño del patriarca';
DECLARE @autor varchar(100) = 'Gabriel García Márquez';
DECLARE @año int = 1975;
DECLARE @genero varchar(50) = 'Novela política / Realismo mágico';
DECLARE @cantidad_disponible int = 10;
DECLARE @cantidad_total int = 10;

EXEC insert_libros @titulo,@autor,@año,@genero,@cantidad_disponible,@cantidad_total