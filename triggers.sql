/*TUDO PRONTO*/
/* Trigger 1 */
CREATE TABLE CAIXA
(
    DATA            DATETIME,
    SALDO_INICIAL   DECIMAL(10,2),
    SALDO_FINAL     DECIMAL(10,2)
)
GO

INSERT INTO CAIXA
VALUES (CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 103)), 100, 100)
GO

CREATE TABLE VENDAS
(
    DATA    DATETIME,
    CODIGO  INT,
    VALOR   DECIMAL(10,2)
)
GO

CREATE TRIGGER TGR_VENDAS_AI
ON VENDAS
FOR INSERT
AS
BEGIN
    DECLARE
    @VALOR  DECIMAL(10,2),
    @DATA   DATETIME

    SELECT @DATA = DATA, @VALOR = VALOR FROM INSERTED

    UPDATE CAIXA SET SALDO_FINAL = SALDO_FINAL + @VALOR
    WHERE DATA = @DATA
END
GO

select * from CAIXA
select * from VENDAS

insert into VENDAS
VALUES (CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 103)), 100, 100)

/* Trigger */
CREATE TABLE tab_clientes (
    Id INT identity PRIMARY KEY,
    Nome VARCHAR(100),
    Email VARCHAR(100)
);
CREATE TABLE LogClientes (
    LogId INT IDENTITY PRIMARY KEY,
    ClienteId INT,
    NomeAntigo VARCHAR(100),
    NomeNovo VARCHAR(100),
    DataAlteracao DATETIME
);
go
CREATE TRIGGER trg_AfterUpdate_Clientes
ON tab_Clientes
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO LogClientes (ClienteId, NomeAntigo, NomeNovo, DataAlteracao)
    SELECT 
        d.Id,
        d.Nome AS NomeAntigo,
        i.Nome AS NomeNovo,
        GETDATE()
    FROM deleted as d
    INNER JOIN inserted i ON d.Id = i.Id;
END;

INSERT INTO tab_clientes ( Nome, Email)
VALUES ( 'João Selva', 'joao@email.com');

UPDATE tab_clientes
SET Nome = 'João Silva'
WHERE Id = 1;

select * from LogClientes
select * from tab_clientes

/*Triggers uteis*/
create trigger Inserir_Locacao
on LOCACOES
after insert 
as
begin
	update FILME set status  = 'alugado' where COD_FILME = (select  COD_FILME from inserted);
end 




create trigger Devolve_Filme on LOCACOES
after update 
as 
begin 
	update filme set status ='disponivel' from filme f inner join inserted i on  f.COD_FILME = i.COD_FILME
end 


/*Lojinha*/
create table lj_produto (
	id int identity(1,1) primary key not null ,
	descricao varchar(250),
	unidade varchar(10),
	preco int not null
);
alter table lj_produto
add nome varchar(50);
alter table lj_produto
alter column preco float;
create table lj_venda (
	id int identity(1,1) primary key not null,
	id_prod int FOREIGN KEY REFERENCES lj_produto(id) not null, 
	dia datetime not null, 
	id_cliente int not null, 
	qtd int not null
);
create table lj_compra (
	id int identity(1,1) primary key not null,
	id_prod int FOREIGN KEY REFERENCES lj_produto(id) not null, 
	dia datetime not null, 
	id_fornecedor int not null, 
	qtd int not null
);

create table lj_estoque (
	id int identity(1,1) primary key, 
	id_prod int FOREIGN KEY REFERENCES lj_produto(id) not null , 
	qtd int
);
drop trigger AdProdEstoque
create trigger AdProdEstoque on lj_produto
after insert 
as
begin
	insert into lj_estoque(id_prod,qtd) values ((select id from inserted),0)
end

insert into lj_produto(nome, unidade, preco, descricao) values ('Monster', 'Lata', 11.9, 'Monster original');
