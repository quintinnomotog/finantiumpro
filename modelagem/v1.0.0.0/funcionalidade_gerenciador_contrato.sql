-- Contrato
Código 					0001
Contradada 				Brava Internet
Contratante 			José Quintinno
Categoria 				Serviço de Internet Fixa
Inicio 					01/01/2025
Fim 					NULL
Vigência				Anual
Valor Total 			R$ 1416,00
Valor Total Pago 		R$ 1600,00 (Calculado após o fim da vigência anual)
Dia Vencimento 			10
Situação 				Vigênte|Encerrado
Observação 				Plano 1GB (sem outros benefícios)

-- Parcelamento do Contrato
Código 					0001
Contrato 				0001
Número 					1
Valor da Parcela		R$ 118,00
Valor Juros				R$ 2,88
Vencimento 				10/01/2025
Situação				Pago

Código 					0002
Contrato 				0001
Número 					2
Valor 					R$ 118,00
Valor Juros				R$ 00,00
Vencimento 				10/02/2025
Situação				Pago

Código 					0009
Contrato 				0001
Número 					9
Valor 					R$ 118,00
Vencimento 				10/09/2025
Situação				Aguardando

-- Pagamento do Contrato
Código 					0001
Parcela 				0001
Valor Pago				R$ 120,88
Data 					10/10/2025
Forma 					Recorrente
Meio 					Transferência Bancária - PIX

-- Renovação do Contrato
Código 					0001
Contrato 				0001
Situação				Renovado
Vigência				Anual
Inicio 					01/01/2026
Fim 					31/12/2026
Valor Reajuste 			R$ 00,00
Valor Total 			R$ 1416,00

---- Script

create table if not exists tb_categoria_contrato (
	codigo bigserial not null,
    codigo_publico uuid not null default gen_random_uuid(),
	descricao varchar(100) not null,
	data_criacao timestamp default now() not null,
	data_edicao timestamp default now() null,
	data_delecao timestamp default now() null,
    constraint pk_categoria_contrato primary key (codigo),
    constraint un_categoria_contrato unique (descricao)
);

create table if not exists tb_vigencia_contrato (
	codigo bigserial not null,
    codigo_publico uuid not null default gen_random_uuid(),
	descricao varchar(100) not null,
	data_criacao timestamp default current_timestamp not null,
	data_edicao timestamp default current_timestamp null,
	data_delecao timestamp null,
    constraint pk_vigencia_contrato primary key (codigo),
    constraint un_vigencia_contrato unique (descricao)
);

create table if not exists tb_situacao_contrato (
	codigo bigserial not null,
    codigo_publico uuid not null default gen_random_uuid(),
	descricao varchar(100) not null,
	data_criacao timestamp default current_timestamp not null,
	data_edicao timestamp default current_timestamp null,
	data_delecao timestamp null,
    constraint pk_situacao_contrato primary key (codigo),
    constraint un_situacao_contrato unique (descricao)
);

create table if not exists tb_contrato (
    codigo bigserial not null,
    codigo_publico uuid not null default gen_random_uuid(),
	id_categoria bigserial not null,
	id_contratada bigserial not null,
	id_contratante bigserial not null,
	id_vigencia_contrato bigserial not null,
	id_situacao_contrato bigserial not null,
	data_inicio date not null,
	data_fim date null,
	valor_total numeric(15,2) null default 0,
	valor_total_pago numeric(15,2) not null default 0,
	dia_vencimento int null,
	data_vencimento date not null,
	observacao varchar(255) null,
	data_criacao timestamp default current_timestamp not null,
	data_edicao timestamp default current_timestamp null,
	data_delecao timestamp null,
    constraint pk_contrato primary key (codigo),
    constraint fk_contrato_categoria foreign key (id_categoria) references tb_categoria_contrato (codigo),
	constraint fk_contrato_pessoa_contratada foreign key (id_contratada) references tb_pessoa (codigo),
	constraint fk_contrato_pessoa_contrante foreign key (id_contratante) references tb_pessoa (codigo),
	constraint fk_contrato_vigencia_contrato foreign key (id_vigencia_contrato) references tb_vigencia_contrato (codigo),
	constraint fk_contrato_situacao_contrato foreign key (id_situacao_contrato) references tb_situacao_contrato (codigo),
	constraint un_contrato unique (id_contratada, id_contratante, valor_total)
);

create table if not exists tb_situacao_pagamento (
	codigo bigserial not null,
    codigo_publico uuid not null default gen_random_uuid(),
	descricao varchar(100) not null,
	data_criacao timestamp default current_timestamp not null,
	data_edicao timestamp default current_timestamp null,
	data_delecao timestamp null,
    constraint pk_situacao_pagamento primary key (codigo),
    constraint un_situacao_pagamento unique (descricao)
);

create table if not exists tb_parcelamento_contrato (
    codigo bigserial not null,
    codigo_publico uuid not null default gen_random_uuid(),
	id_contrato bigserial not null,
	id_situacao_pagamento bigserial not null,
	numero_parcela int not null,
	valor_parcela numeric(10,2) not null,
	valor_juros numeric(10,2) null,
	data_vencimento date not null,
    constraint pk_parcelamento_contrato primary key (codigo),
    constraint fk_contrato foreign key (id_contrato) references tb_contrato (codigo),
	constraint fk_situacao_pagamento foreign key (id_situacao_pagamento) references tb_situacao_pagamento (codigo),
	constraint un_parcelamento_contrato unique (id_contrato, valor_parcela)
);

create table if not exists tb_parcelamento_contrato (
    codigo bigserial not null,
    codigo_publico uuid not null default gen_random_uuid(),
	id_parcela bigserial not null,
	id_forma_pagamento bigserial not null,
	id_meio_pagamento bigserial not null,
	valor_pago numeric(10,2),
	data_pagamento date not null,
    constraint pk_parcelamento_contrato primary key (codigo),
    constraint fk_parcela foreign key (id_parcela) references tb_parcela (codigo),
	constraint fk_forma_pagamento foreign key (id_forma_pagamento) references tb_forma_pagamento (codigo),
	constraint fk_meio_pagamento foreign key (id_meio_pagamento) references tb_meio_pagamento (codigo)
);

create table if not exists tb_situacao_renovacao_contrato (
	codigo bigserial not null,
    codigo_publico uuid not null default gen_random_uuid(),
	descricao varchar(100) not null,
	data_criacao timestamp default current_timestamp not null,
	data_edicao timestamp default current_timestamp null,
	data_delecao timestamp null,
    constraint pk_situacao_renovacao_contrato primary key (codigo),
    constraint un_situacao_renovacao_contrato unique (descricao)
);

create table if not exists tb_renovacao_contrato (
    codigo bigserial not null,
    codigo_publico uuid not null default gen_random_uuid(),
	id_contrato bigserial not null,
	id_situacao_renovacao_contrato bigserial not null,
	id_vigencia_contrato bigserial not null,
	data_inicio date not null,
	data_fim date not null,
	valor_total numeric(10,2) not null,
	valor_reajuste numeric(10,2) null,
    constraint pk_tb_renovacao_contrato primary key (codigo),
    constraint fk_contrato foreign key (id_contrato) references tb_contrato (codigo),
	constraint fk_situacao_renovacao_contrato foreign key (id_situacao_renovacao_contrato) references tb_situacao_renovacao_contrato (codigo),
	constraint fk_vigencia_contrato foreign key (id_vigencia_contrato) references tb_vigencia_contrato (codigo)
);

-- Outros

select
	'feature/FINANTIUM' || TO_CHAR(NOW(), 'YYYYMMDD') || TO_CHAR(NOW(), 'HH24MISS') || 'API' as feature;

drop table if exists flyway_schema_history cascade;
drop table if exists tb_tipo_pessoa cascade;
drop table if exists tb_pessoa cascade;
drop table if exists tb_produto_servico cascade;
drop table if exists tb_forma_pagamento cascade;
drop table if exists tb_meio_pagamento cascade;
drop table if exists tb_bandeira_cartao cascade;
drop table if exists tb_tipo_conta_bancaria cascade;
drop table if exists tb_conta_bancaria cascade;
drop table if exists tb_cartao_bancario cascade;
drop table if exists tb_transacao_financeira cascade;
drop table if exists tb_transacao_financeira_produto_servico cascade;
drop table if exists tb_parcelamento cascade;
drop table if exists tb_transacao_financeira_parcelamento cascade;
drop table if exists tb_transacao_pagamento cascade;
drop table if exists tb_pagamento_conta cascade;
drop table if exists tb_pagamento_parcelamento cascade;
drop table if exists tb_transacao_financeira_anexo cascade;
drop table if exists tb_contrato cascade;
drop table if exists tb_fatura_contrato cascade;
drop table if exists tb_anexo_transacao_financeira cascade;
drop table if exists tb_pagamento_cartao cascade;
drop table if exists tb_situacao_pagamento cascade;
drop table if exists tb_categoria_contrato cascade;
drop table if exists tb_parcelamento_contrato cascade;
drop table if exists tb_renovacao_contrato cascade;
drop table if exists tb_situacao_contrato cascade;
drop table if exists tb_situacao_renovacao_contrato cascade;
drop table if exists tb_vigencia_contrato cascade;

-- Pagar uma Transação Financeira

select * from tb_transacao_financeira;

select * from tb_transacao_pagamento;

select * from tb_transacao_financeira_parcelamento;

select * from tb_pagamento_conta;

-- quando a fatura virar transação:
alter table tb_transacao add column if not exists id_fatura_contrato bigint null;

alter table tb_transacao
    add constraint fk_transacao_fatura_contrato foreign key (id_fatura_contrato) references tb_fatura_contrato (codigo);

ALTER TABLE tb_fatura_contrato
    ADD COLUMN dias_atraso INT DEFAULT 0;

ALTER TABLE tb_fatura_contrato
    ALTER COLUMN status TYPE VARCHAR(20) USING status::VARCHAR;

-- Tabela de negociação de dívidas
CREATE TABLE IF NOT EXISTS tb_negociacao_divida (
    codigo BIGSERIAL NOT NULL,
    codigo_publico UUID NOT NULL DEFAULT gen_random_uuid(),
    id_fatura_contrato BIGINT NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NULL,
    valor_original NUMERIC(15,2) NOT NULL,
    valor_negociado NUMERIC(15,2) NOT NULL,
    descricao TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'Aberta', -- Aberta, Fechada, Cancelada
    data_criacao TIMESTAMP DEFAULT now(),
    data_edicao TIMESTAMP NULL,
    data_delecao TIMESTAMP NULL,
    CONSTRAINT pk_negociacao_divida PRIMARY KEY (codigo),
    CONSTRAINT fk_negociacao_fatura FOREIGN KEY (id_fatura_contrato) REFERENCES tb_fatura_contrato (codigo)
);