

CREATE DATABASE LetsCar

USE LetsCar

CREATE TABLE Carro
(
	Id   		INT IDENTITY PRIMARY KEY,
	
	Nome		VARCHAR(100) NOT NULL,
	Ano		    BIGINT NOT NULL,
	Cor		    VARCHAR(50) NOT NULL,
	Valor		BIGINT NOT NULL
	
)

INSERT INTO Carro(Nome, Ano, Cor, Valor)
VALUES ('Sandero', 2015, 'Prata', 35000)

INSERT INTO Carro(Nome, Ano, Cor, Valor)
VALUES ('Ford ka', 2010, 'Vermelho', 25000)

INSERT INTO Carro(Nome, Ano, Cor, Valor)
VALUES ('Fiat Palio', 2009, 'Preto', 15000)

DROP TABLE Carro

-----------------------------------------------------MARCA -------------------------------------------------------
CREATE TABLE Marca
(
	Id		    INT IDENTITY PRIMARY KEY,
	IdCarro     INT NOT NULL, 
	Nome		VARCHAR(100) NOT NULL,
	CONSTRAINT FK_Marca_Carro 
		FOREIGN KEY (IdCarro)
		REFERENCES Carro(Id)
)

SELECT * FROM Carro
SELECT * FROM Marca

INSERT INTO Marca(Idcarro, Nome)
	VALUES (1, 'Renault')


INSERT INTO Marca(Idcarro, Nome)
	VALUES (3,'Fiat')


INSERT INTO Marca(Idcarro, Nome)
	VALUES (2, 'Ford')


-----------------------------------CATEGORIA ----------------------------------------------------------------

CREATE TABLE Categoria
(
	Id		INT IDENTITY PRIMARY KEY,
	IdCarro		INT,
	Nome		VARCHAR(100) NOT NULL,
	CONSTRAINT FK_Categoria_Carro
		FOREIGN KEY (IdCarro)
		REFERENCES Carro(Id)
)

INSERT INTO Categoria(IdCarro, Nome)
	VALUES (2,'Compacto')
SET IDENTITY_INSERT Categoria ON

INSERT INTO Categoria(IdCarro, Nome)
	VALUES (4,'Sedan')

INSERT INTO Categoria(IdCarro, Nome)
	VALUES (1,'Subcompacto')


	SELECT * FROM Categoria

	DROP TABLE Categoria

-------------------------------------------CLIENTE ----------------------------------------------------------------
	CREATE TABLE Cliente
(
	Id		         INT IDENTITY PRIMARY KEY,
	Nome		          VARCHAR(100) NOT NULL,
	DataNascimento		    DATE NOT NULL,
	Endereco		    VARCHAR(100) NOT NULL,
	Cidade         		VARCHAR(50) NOT NULL,
	Estado         		VARCHAR(50) NOT NULL,
	Cep         		VARCHAR(50) NOT NULL,
	Email         		VARCHAR(50) NOT NULL
)

INSERT INTO Cliente(Nome, DataNascimento, Endereco, Cidade, Estado, Cep, Email)
	VALUES ('Nyth','1987-09-6','Rua Maradona', 'Sao Paulo','Sao Paulo', '20304050', 'nythg@gmail.com' )

SELECT * FROM Cliente
DROP TABLE Cliente



-------------------------------------------TELEFONE ----------------------------------------------------------------
CREATE TABLE Telefone
(
	Id		        INT IDENTITY PRIMARY KEY,
	IdCliente		INT,
	Numero		     BIGINT NOT NULL,
	CONSTRAINT FK_Telefone_Cliente
		FOREIGN KEY (IdCliente)
		REFERENCES Cliente(Id)
)

-------------------------------------------EMAIL ----------------------------------------------------------------
CREATE TABLE Email
(
	Id		        INT IDENTITY PRIMARY KEY,
	IdCliente		INT,
	Email		     VARCHAR(50) NOT NULL,
	CONSTRAINT FK_Email_Cliente
		FOREIGN KEY (IdCliente)
		REFERENCES Cliente(Id)
)

-------------------------------------------PEDIDO ----------------------------------------------------------------
CREATE TABLE Pedido
(
	Id		            INT IDENTITY PRIMARY KEY,
	IdCarro              INT,
	IdCliente		      INT,
	DataPagamento		     DATE NOT NULL,
	DataPedido		     DATE NOT NULL,
	EnderecoEntrega       VARCHAR(100),
	Frete                 BIGINT,
	Valor                 BIGINT,
	IdFormaPagamento         INT,
	  CONSTRAINT FK_Pedido_Cliente
		FOREIGN KEY (IdCliente)
		REFERENCES Cliente(Id),

		CONSTRAINT FK_Pedido_Cliente_Carro
		FOREIGN KEY (IdCarro)
		REFERENCES Carro(Id)
)

--ID FORMA PAGAMENTO
--1 BOLETO
--2 CARTAO DE CREDITO
--3 TRANSFERÊNCIA


INSERT INTO Pedido(IdCarro, IdCliente,DataPagamento,DataPedido, EnderecoEntrega, Frete, Valor, IdFormaPagamento) 
Values (1, 1, '19-09-2021', '19-09-2021', 'Rua Maradona', 250,35000, 2 )

-------------------------------------------PAGAMENTO ----------------------------------------------------------------
CREATE TABLE Pagamento
(
	Id		             INT IDENTITY PRIMARY KEY,
	IdCliente             INT NOT NULL,
	IdPedido             INT NOT NULL,
	Descricao		     VARCHAR(50) NOT NULL,
	IdFormaPagamento         INT NOT NULL
)


	ALTER TABLE Pagamento ADD CONSTRAINT FK_Pagamento_Cliente
		FOREIGN KEY (IdCliente)
		REFERENCES Cliente(Id),
	ALTER TABLE Pagamento ADD	CONSTRAINT FK_Pagemnto_Pedido
		FOREIGN KEY (IdPedido)
		REFERENCES Pedido(Id)


--ID FORMA PAGAMENTO
--1 BOLETO
--2 CARTAO DE CREDITO
--3 TRANSFERÊNCIA


INSERT INTO Pagamento(IdCliente, IdPedido, Descricao, IdFormaPagamento) 
Values (1, 1,'Cartão de Credito',2 )


-------------------------------------------ITENS ----------------------------------------------------------------
CREATE TABLE Itens
(
	Id		            INT IDENTITY PRIMARY KEY,
	IdPedido              INT NOT NULL,
	IdCliente		      INT NOT NULL,
	IdCarro		      INT NOT NULL,
	Descricao           VARCHAR(100),
	Preco                BIGINT NOT NULL,
	Quantidade            INT NOT NULL
	
	  CONSTRAINT FK_Pedido_Itens
		FOREIGN KEY (IdCliente)
		REFERENCES Cliente(Id),

		CONSTRAINT FK_Pedido_Itens_Cliente
		FOREIGN KEY (Idpedido)
		REFERENCES Pedido(Id),
		CONSTRAINT FK_Pedido_Itens_Carro
		FOREIGN KEY (IdCarro)
		REFERENCES Carro(Id)
)


INSERT INTO Itens(IdPedido, IdCliente, IdCarro, Descricao, Preco, Quantidade) 
Values (1, 1, 1,'Ar condicionado',600,1 )
-------------------------------------------FAVORITAR ----------------------------------------------------------------
CREATE TABLE Favoritar
(
	Id      INT IDENTITY PRIMARY KEY,
	IdCarro     INT NOT NULL,
	IdCliente     INT NOT NULL,
	

	CONSTRAINT FK_Favoritar_Carro
		FOREIGN KEY (IdCarro)
		REFERENCES Carro(Id),
		CONSTRAINT FK_Favoritar_Carro_Cliente
		FOREIGN KEY (IdCliente)
		REFERENCES Cliente(Id)
)

INSERT INTO Favoritar(IdCarro, Idcliente)
	VALUES (1,1 )

INSERT INTO Favoritar(IdCarro, Idcliente)
VALUES (2,3 )


SELECT * FROM Cliente 
DROP TABLE Favoritar

INSERT INTO Favoritar(IdCarro, IdCliente)
	VALUES (1,2)
	SET IDENTITY_INSERT Favoritar ON
------------------------------------------	PROCEDURES -------------------------------------------------------------

-- ACHAR CARRO FAVORITADO PELO ID DO CLIENTE 

GO
CREATE PROCEDURE FavoritoCliente 
@CampoBusca VARCHAR (20) 
AS
SELECT	f.IdCliente AS NomeFavoritar,
			c.Nome AS NomeCliente,
			b.Nome AS NomeCarro
		FROM Favoritar f
			LEFT JOIN Cliente c
			ON f.IdCarro = c.Id

			LEFT JOIN Carro b
			ON f.IdCarro = b.Id
			WHERE c.Id = @CampoBusca

EXECUTE FavoritoCliente 1
GO
    


-- PROCEDURE BUSCAR CARRO E ID
GO
CREATE PROCEDURE BuscaIdCarro --- Declarando o nome da procedure
@CampoBusca VARCHAR (20) --- Declarando variável (note que utilizamos o @ antes do nome da variável)
AS
SELECT Id, Nome --- Consulta
FROM Carro
WHERE Nome = @CampoBusca --- Utilizando variável como filtro para a consulta

EXECUTE BuscaIdCarro 'Sandero'


-- PROCEDURE BUSCAR  A QUE MARCA PERTENCE O CARRO

GO
CREATE PROCEDURE BuscaMarcaCarro 
@CampoBusca VARCHAR (20) 
AS
SELECT	f.Nome AS NomeMarca,
			c.Nome AS Nomecarro
		FROM Marca f
			LEFT JOIN Carro c
			
			ON f.IdCarro = c.Id
			WHERE c.Nome = @CampoBusca

EXECUTE BuscaMarcaCarro 'Sandero'
GO


-- PROCEDURE INSERIR TABELA CARRO
GO
CREATE PROCEDURE InserirCarro 
       @nome                         VARCHAR(100)  = NULL   , 
       @ano                          BIGINT      = NULL   , 
       @cor                          VARCHAR(50)  = NULL   , 
       @valor                        BIGINT  = NULL  
AS 
BEGIN 
     SET NOCOUNT ON 

     INSERT INTO Carro
          (                    
            Nome                     ,
            Ano                      ,
            Cor                      ,
            Valor                 
          ) 
     VALUES 
          ( 
            @nome,
            @ano,
            @cor,
            @valor
          ) 

END 

GO

exec InserirCarro 
    @nome  = 'Honda City' ,
    @ano   = 2020      ,
    @cor   = 'Branco'  ,
    @valor = 65000 


-- PROCEDURE INSERIR TABELA MARCA

GO
CREATE PROCEDURE InserirMarca 
       
        @codigoCarro                          INT      = NULL, 
	    @nome                         VARCHAR(100)  = NULL    
       
AS 
BEGIN 
     SET NOCOUNT ON 

     INSERT INTO Marca
          (                    
            IdCarro                     ,
            Nome                      
                          
          ) 
     VALUES 
          ( 
            @codigoCarro,
            @nome
            
          ) 

END 

GO

exec InserirMarca 
    @codigoCarro = 4 ,
    @nome   = 'Honda'       
    

-- PROCEDURE INSERIR TABELA CATEGORIA
GO
CREATE PROCEDURE InserirCategoria 
       @codigoCarro                         INT  = NULL   , 
       @nome                         VARCHAR(100)  = NULL   
       
AS 
BEGIN 
     SET NOCOUNT ON 

     INSERT INTO Categoria
          (                    
            Idcarro                     ,
            Nome                      
                          
          ) 
     VALUES 
          ( 
            @codigoCarro,
            @nome
            
          ) 

END 


GO


 exec InserirCategoria 
   @CodigoCarro  = 3 ,
   @Nome   = 'Sedan' 

 

  -- PROCEDURE BUSCAR A QUE CATEGORIA PERTENCE O CARRO

GO
CREATE PROCEDURE BuscaCategoriaCarro 
@CampoBusca VARCHAR (20) 
AS
SELECT	f.Nome AS NomeCategoria,
			c.Nome AS Nomecarro
		FROM Categoria f
			LEFT JOIN Carro c
			
			ON f.IdCarro = c.Id
			WHERE c.Nome = @CampoBusca

EXECUTE BuscaCategoriaCarro 'Sandero'



-- PROCEDURE INSERIR TABELA CLIENTE

GO
CREATE PROCEDURE InserirCliente 
       @nome                          VARCHAR(100)  = NULL   , 
       @dataNascimento                DATE      = NULL   , 
       @endereco                      VARCHAR(100)  = NULL   , 
       @cidade                        VARCHAR(50)  = NULL, 
	   @estado                        VARCHAR(50)  = NULL,
	   @cep                           VARCHAR(50)  = NULL
	 
  
AS 
BEGIN 
     SET NOCOUNT ON 

     INSERT INTO Cliente
          (                    
            Nome                     ,
            DataNascimento                      ,
            Endereco                      ,
            Cidade                       ,
			Estado                       ,
			Cep                          
			                      
          ) 
     VALUES 
          ( 
            @nome,
            @dataNascimento,
            @endereco,
            @cidade,
			@estado,
			@cep
			
          ) 

END 

GO

exec InserirCliente 
    @nome  = 'Maria' ,
    @dataNascimento   = '1960-09-01'      ,
    @endereco   = 'Rio de Janeiro'  ,
    @cidade = 'Macae' ,
	@estado = 'Rio de Janeiro',
	@cep =   '104050479'       
	


	-- INSERIR E PROCURAR TELEFONE:

	GO
CREATE PROCEDURE InserirTelefone 
       
        @codigoCliente                          INT      = NULL, 
	    @numero                         BIGINT  = NULL    
       
AS 
BEGIN 
     SET NOCOUNT ON 

     INSERT INTO Telefone
          (                    
            IdCliente                    ,
            Numero                      
                          
          ) 
     VALUES 
          ( 
            @codigoCliente,
            @numero
            
          ) 

END 

GO

exec InserirTelefone 
    @codigoCliente = 3 ,
    @numero   = 99999999  

	SELECT *FROM Cliente

	GO
CREATE PROCEDURE BuscarTelefoneCliente 
@CampoBusca INT  
AS
SELECT	f.Numero AS NumeroTelefone,
			c.Nome AS NomeCliente
		FROM Telefone f
			LEFT JOIN Cliente c
			
			ON f.IdCliente = c.Id
			WHERE c.Id = @CampoBusca

EXECUTE BuscarTelefoneCliente 3

-- INSERIR E PROCURAR EMAIL:

	GO
CREATE PROCEDURE InserirEmail 
       
        @codigoCliente                          INT      = NULL, 
	    @email                       VARCHAR(50)  = NULL    
       
AS 
BEGIN 
     SET NOCOUNT ON 

     INSERT INTO Email
          (                    
            IdCliente                    ,
            Email                      
                          
          ) 
     VALUES 
          ( 
            @codigoCliente,
            @email
            
          ) 

END 

GO

exec InserirEmail 
    @codigoCliente = 3 ,
    @email   = 'graca@gmail.com ' 

	SELECT *FROM Cliente

	GO
CREATE PROCEDURE BuscarEmailCliente 
@CampoBusca INT  
AS
SELECT	f.Email AS NumeroEmail,
			c.Nome AS NomeCliente
		FROM Email f
			LEFT JOIN Cliente c
			
			ON f.IdCliente = c.Id
			WHERE c.Id = @CampoBusca

EXECUTE BuscarEmailCliente 3



---------------------------------------------------DELETAR UM CLIENTE/CARRO/TELEFONE/EMAIL/------------------------------------------------

GO
CREATE PROCEDURE DeletarCliente 
@CampoBusca INT  
AS
DELETE FROM
        Cliente
        WHERE
        Id = @CampoBusca

EXECUTE DeletarCliente 3

GO
CREATE PROCEDURE DeletarCarro 
@CampoBusca INT  
AS
DELETE FROM
        Carro
        WHERE
        Id = @CampoBusca


CREATE PROCEDURE DeletarTelefone 
@CampoBusca INT  
AS
DELETE FROM
        Telefone
        WHERE
        Id = @CampoBusca

CREATE PROCEDURE DeletarEmail 
@CampoBusca INT  
AS
DELETE FROM
        Email
        WHERE
        Id = @CampoBusca

