/*Create*/
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
EXEC Inclui_Cliente
    @RG = '123456789',
    @NOME = 'João da Silva',
    @ENDERECO = 'Rua das Flores, 123',
    @BAIRRO = 'Centro',
    @CIDADE = 'Sorocaba',
    @ESTADO = 'SP',
    @TELEFONE = '(15)99999-9999',
    @EMAIL = 'joao.silva@email.com',
    @DATANASCIMENTO = '1990-05-15',
    @Sexo = 'M';
/*Read*/
CREATE PROCEDURE Mostra_Clientes
AS
BEGIN 
    select * from CLIENTES;
END
/*criada na escola*/


CREATE PROCEDURE Mostra_Cliente_Por_ID
	@ID numeric(18,0)
AS
BEGIN 
    select * from CLIENTES where COD_CLIENTE = @ID
END
/*Update*/
CREATE PROCEDURE Update_Dados_Cliente
	@COD_CLIENTE numeric(18,0),
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
    UPDATE CLIENTES
    SET
        RG = @RG,
        NOME = @NOME,
        ENDERECO = @ENDERECO,
        BAIRRO = @BAIRRO,
        CIDADE = @CIDADE,
        ESTADO = @ESTADO,
        TELEFONE = @TELEFONE,
        EMAIL = @EMAIL,
        DATANASCIMENTO = @DATANASCIMENTO,
        Sexo = @Sexo
    WHERE COD_CLIENTE = @COD_CLIENTE
END
/*Delete*/

CREATE PROCEDURE Deleta_cliente
	@ID numeric(18,0)
AS
BEGIN
	delete from LOCACOES  where COD_CLIENTE = @ID
    delete from CLIENTES where COD_CLIENTE = @ID

END


/*2)*/
CREATE PROCEDURE MostraClientesAniversarioPorMes
    @mes numeric(2,0)
AS
BEGIN 
    select Nome, Day(DATANASCIMENTO) as Dia from CLIENTES where Month(DATANASCIMENTO) = @mes
END
EXEC MostraClientesAniversarioPorMes 1;
/*3)*/
create procedure TodosporMes 
as
begin
select M.mes as Mês , count(c.DATANASCIMENTO) 
from (values (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12) ) as M(mes) 
left join CLIENTES as c on Month(c.DATANASCIMENTO) = M.mes group BY M.mes order by M.mes asc
select Month(DATANASCIMENTO),Count(*) from CLIENTES group by Month(DATANASCIMENTO) order by Month(DATANASCIMENTO) asc 
end
/*4)*/
create procedure SelecionarClienteCidadeIdade
 @cidade varchar(30),
 @idade  numeric(3,0)
as
begin
select c.NOME,
	   c.DATANASCIMENTO,
	   (
	   DATEDIFF(YEAR,C.DATANASCIMENTO,GETDATE()) 
	   - CASE WHEN DATEADD(YEAR,DATEDIFF(YEAR,C.DATANASCIMENTO,GETDATE()),C.DATANASCIMENTO) > GETDATE()
	   THEN 1 ELSE 0 END
	   ) AS IDADE 
	   from CLIENTES as c  
	   where C.CIDADE = @cidade 
	   and (
	   DATEDIFF(YEAR,C.DATANASCIMENTO,GETDATE()) 
	   - CASE WHEN DATEADD(YEAR,DATEDIFF(YEAR,C.DATANASCIMENTO,GETDATE()),C.DATANASCIMENTO) > GETDATE()
	   THEN 1 ELSE 0 END 
	   ) <=@idade;
end ;
exec SelecionarClienteCidadeIdade 'Sorocaba' , 50;

/*5)*/
Alter table filme
add status varchar(10) not null default 'disponível'

alter table locacoes 
add Data_Devolucao datetime null;
/*adicionei alguns insert intos de exemplo*/
select* from LOCACOES;

create procedure InserirLocacao
	@id_cliente numeric(18,0),
	@id_filme numeric(18,0)
as 