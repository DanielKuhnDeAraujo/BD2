/*TUDO PRONTO*/
/*Daniel Kühn de Araújo*/
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

/*Triggers venda*/

create trigger Venda on lj_venda
after insert 
as
begin
    update lj_estoque set qtd = lj_estoque.qtd - inserted.qtd from lj_estoque 
    inner join inserted on lj_estoque.id_prod = inserted.id_prod where lj_estoque.id_prod = inserted.id_prod;
end


/*delete*/

create trigger DelVenda on lj_venda
after delete 
as
begin
    update lj_estoque set qtd = lj_estoque.qtd + deleted.qtd from lj_estoque 
    inner join deleted on lj_estoque.id_prod = deleted.id_prod where lj_estoque.id_prod = deleted.id_prod;
end

/*update*/
create trigger UpVenda on lj_venda
after update 
as
begin
    update lj_estoque set qtd = lj_estoque.qtd - inserted.qtd from lj_estoque 
    inner join inserted on lj_estoque.id_prod = inserted.id_prod where lj_estoque.id_prod = inserted.id_prod;
	update lj_estoque set qtd = lj_estoque.qtd + deleted.qtd from lj_estoque 
    inner join deleted on lj_estoque.id_prod = deleted.id_prod where lj_estoque.id_prod = deleted.id_prod;
end
/* Triggers compra */

create trigger Compra on lj_compra
after insert 
as
begin
    update lj_estoque set qtd = lj_estoque.qtd + inserted.qtd from lj_estoque 
    inner join inserted on lj_estoque.id_prod = inserted.id_prod where lj_estoque.id_prod = inserted.id_prod;
end


/*delete*/
create trigger DelCompra on lj_compra
after delete 
as
begin
    update lj_estoque set qtd = lj_estoque.qtd - deleted.qtd from lj_estoque 
    inner join deleted on lj_estoque.id_prod = deleted.id_prod where lj_estoque.id_prod = deleted.id_prod;
end


/*update*/
go
create trigger UpCompra on lj_compra
after update
as
begin
    update lj_estoque set qtd = lj_estoque.qtd + inserted.qtd  from lj_estoque 
    inner join inserted on lj_estoque.id_prod = inserted.id_prod where lj_estoque.id_prod = inserted.id_prod;
	update lj_estoque set qtd = lj_estoque.qtd - deleted.qtd from lj_estoque 
    inner join deleted on lj_estoque.id_prod = deleted.id_prod where lj_estoque.id_prod = deleted.id_prod;
end



/*adicionar financeiro*/
alter table lj_venda
add qtd_parcelas int not null default 1 ;
alter table lj_venda 
add valor_total int not null default 0;

create table lj_parcelas (
	id int identity(1,1) primary key not null,
	id_venda int not null foreign key references lj_venda(id),
	vencimento datetime not null,
	pag_efetivo datetime not null,
	preco float not null
);
/*insert into lj_compra(id_prod, dia, id_fornecedor, qtd ,valor_total) values (1, getdate(),10,3,35.70);*/
insert into lj_compra(id_prod, dia, id_fornecedor, qtd ) values (1, getdate(),10,100);



GO
Create trigger DeletarParcelasVenda on lj_venda
after delete
as 
begin 
	declare @I int ;
	select @I = id from inserted
	delete from lj_parcelas where id_venda  = @I;

end

/***********************/

GO
ALTER trigger CriarParcelasVenda on lj_venda
after insert
as 
begin 
	DECLARE @I INT = 1;
	DECLARE @PARC INT ;
	SELECT  @PARC= qtd_parcelas from inserted;
	-- Loop WHILE
	insert into lj_parcelas (id_venda,vencimento,pag_efetivo,preco)
	select id,getdate(),GETDATE(),valor_total/qtd_parcelas  from inserted
	WHILE @I < @PARC
	BEGIN
		insert into lj_parcelas (id_venda,vencimento,preco)
		select id,dateadd(MONTH,@I,GETDATE()),valor_total/qtd_parcelas  from inserted
		SET @I += 1;
	END

end

create table lj_FeriadosFixos (
id int identity(1,1) primary key,
nome varchar(20) not null,
data date);

INSERT INTO lj_FeriadosFixos (nome, data)
VALUES
('Confraternização Universal', '2026-01-01'),
('Tiradentes', '2026-04-21'),
('Dia do Trabalho', '2026-05-01'),
('Independência do Brasil', '2026-09-07'),
('Nossa Senhora Aparecida', '2026-10-12'),
('Finados', '2026-11-02'),
('Proclamação da República', '2026-11-15'),
('Natal', '2026-12-25');

create table lj_FeriadosVaria (
id int identity(1,1) primary key,
nome varchar(20) not null,
data date);

INSERT INTO lj_FeriadosVaria (nome, data)
VALUES

-- Ano 2026
('Carnaval', '2026-02-17'),
('Sexta-feira Santa', '2026-04-03'),
('Páscoa', '2026-04-05'),
('Corpus Christi', '2026-06-04'),

-- Ano 2027
('Carnaval', '2027-02-09'),
('Sexta-feira Santa', '2027-03-26'),
('Páscoa', '2027-03-28'),
('Corpus Christi', '2027-05-27');

go 
create procedure DeletarVenda 
@id int
as 
begin 
 delete from lj_parcelas where id_venda = @id;
 delete from lj_venda where id = @id;
end

select * from lj_parcelas
go

/*XABLAU*/



drop trigger CorrigirData
go
CREATE TRIGGER CorrigirData ON lj_parcelas
AFTER INSERT 
AS 
BEGIN
    DECLARE @id INT;
    DECLARE @vencimento DATE;
    DECLARE @contador INT;
    DECLARE @total INT;
    
    -- Pega o total de registros inseridos
    SELECT @total = COUNT(*) FROM inserted;
    SET @contador = 1;
    
    -- Enquanto tiver registros para processar
    WHILE @contador <= @total
    BEGIN
        -- Pega o ID e a data do registro atual
        SELECT @id = id, @vencimento = CAST(vencimento AS DATE)
        FROM (
            SELECT id, vencimento, ROW_NUMBER() OVER (ORDER BY id) AS linha
            FROM inserted
        ) AS temp
        WHERE linha = @contador;
        
        -- Enquanto for sábado, domingo ou feriado, avança 1 dia
        WHILE (
            (DATEPART(weekday, @vencimento) = 1) OR  -- Domingo
            (DATEPART(weekday, @vencimento) = 7) OR  -- Sábado
            EXISTS (SELECT 1 FROM lj_FeriadosFixos WHERE MONTH(data) = MONTH(@vencimento) AND DAY(data) = DAY(@vencimento)) OR
            EXISTS (SELECT 1 FROM lj_FeriadosVaria WHERE data = @vencimento)
        )
        BEGIN
            SET @vencimento = DATEADD(day, 1, @vencimento);
        END
        
        -- Atualiza a data se mudou
        UPDATE lj_parcelas 
        SET vencimento = @vencimento 
        WHERE id = @id;
        
        SET @contador = @contador + 1;
    END
END

/*teste*/

INSERT INTO lj_parcelas (id_venda, vencimento, preco) 
VALUES (4, DATEADD(day,6,getdate()),100.00);
select * from lj_parcelas

INSERT INTO lj_parcelas (id_venda, vencimento, preco) 
VALUES (4, DATEADD(day,3,getdate()),100.00);
select * from lj_parcelas


