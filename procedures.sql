CREATE PROCEDURE Inclui_Cliente
	@RG VARCHAR(9),
    @NOME VARCHAR(50), 
    @ENDERECO VARCHAR(50), 
    @BAIRRO VARCHAR(30), 
    @CIDADE VARCHAR(30), 
    @ESTADO CHAR(2),
    @TELEFONE VARCHAR(15),
    @EMAIL VARCHAR(30), 
    @DATANASCIMENTO DATETIME, 
    @Sexo CHAR(1)
AS
BEGIN 
    INSERT INTO CLIENTES ([RG],[NOME], [ENDERECO], [BAIRRO], [CIDADE], [ESTADO], [TELEFONE], [EMAIL], [DATANASCIMENTO], [Sexo]) 
    VALUES (@RG,@NOME, @ENDERECO, @BAIRRO, @CIDADE, @ESTADO, @TELEFONE, @EMAIL, @DATANASCIMENTO, @Sexo)
END 
EXEC Inclui_Cliente '123456789', 'João Silva', 'Rua das Flores, 123', 'Centro', 'São Paulo', 'SP', '11999999999', 'joao@email.com', '1990-01-01', 'M';

/*Feita em casa e na escola*/
/*Vai aparecer erro  no create procedure mas isso acontece pq tem mais de um create no mesmo documento
Vai rodar normal desde q vc n rode os dois ao mesmo tempo, acho*/
CREATE PROCEDURE Inclui_Categoria
	@NOME_CATEGORIA VARCHAR(20)
AS
BEGIN 
    INSERT INTO CATEGORIA([NOME_CATEGORIA]) 
    VALUES (@NOME_CATEGORIA)
END
/*criada em casa*/
EXEC Inclui_Categoria 'Sci-fi';
select * from CATEGORIA;