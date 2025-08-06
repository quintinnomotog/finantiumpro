create table if not exists tb_tipo_pessoa (
    codigo bigserial not null,
    codigo_publico uuid not null default gen_random_uuid(),
    descricao varchar(60) not null,
    data_criacao timestamp default now(),
    data_edicao timestamp null,
    data_delecao timestamp null,
    constraint pk_tipo_pessoa primary key (codigo),
	constraint un_tipo_pessoa unique (descricao)
);

create table if not exists tb_pessoa (
    codigo bigserial not null,
    codigo_publico uuid not null default gen_random_uuid(),
    id_tipo_pessoa serial not null,
    nome varchar(100) not null,
    data_criacao timestamp default now(),
    data_edicao timestamp null,
    data_delecao timestamp null,
    constraint pk_pessoa primary key (codigo),
    constraint fk_pessoa_tipo_pessoa foreign key (id_tipo_pessoa) references tb_tipo_pessoa (codigo),
	constraint un_pessoa unique (nome)
);

create table if not exists tb_produto_servico (
    codigo bigserial not null,
    codigo_publico uuid not null default gen_random_uuid(),
    nome varchar(100) not null,
    data_criacao timestamp default now(),
    data_edicao timestamp null,
    data_delecao timestamp null,
    constraint pk_produto_servico primary key (codigo)
);

create table if not exists tb_forma_pagamento (
    codigo bigserial not null,
    codigo_publico uuid not null default gen_random_uuid(),
    descricao varchar(60) not null,
    data_criacao timestamp default now(),
    data_edicao timestamp null,
    data_delecao timestamp null,
    constraint pk_forma_pagamento primary key (codigo)
);

create table if not exists tb_meio_pagamento (
    codigo bigserial not null,
    codigo_publico uuid not null default gen_random_uuid(),
    descricao varchar(60) not null,
    data_criacao timestamp default now(),
    data_edicao timestamp null,
    data_delecao timestamp null,
    constraint pk_meio_pagamento primary key (codigo)
);

create table if not exists tb_bandeira_cartao (
    codigo bigserial not null,
    codigo_publico uuid not null default gen_random_uuid(),
    descricao varchar(50) not null,
    data_criacao timestamp default now(),
    data_edicao timestamp null,
    data_delecao timestamp null,
    constraint pk_bandeira_cartao primary key (codigo)
);

create table if not exists tb_tipo_conta_bancaria (
    codigo bigserial not null,
    codigo_publico uuid not null default gen_random_uuid(),
    descricao varchar(50) not null,
    data_criacao timestamp default now(),
    data_edicao timestamp null,
    data_delecao timestamp null,
    constraint pk_tipo_conta_bancaria primary key (codigo)
);

create table if not exists tb_conta_bancaria (
    codigo bigserial not null,
    codigo_publico uuid not null default gen_random_uuid(),
    id_tipo_conta_bancaria bigint not null,
    id_pessoa_instituicao_financeira bigint not null,
    data_abertura date null,
    saldo numeric(15,2) not null default 0,
    data_criacao timestamp default now(),
    data_edicao timestamp null,
    data_delecao timestamp null,
    constraint pk_conta_bancaria primary key (codigo),
    constraint fk_conta_tipo_conta foreign key (id_tipo_conta_bancaria) references tb_tipo_conta_bancaria (codigo),
    constraint fk_conta_pessoa_instituicao foreign key (id_pessoa_instituicao_financeira) references tb_pessoa (codigo)
);

create table if not exists tb_cartao_bancario (
    codigo bigserial not null,
    codigo_publico uuid not null default gen_random_uuid(),
    id_conta_bancaria bigint not null,
    id_bandeira_cartao bigint not null,
    numero varchar(20) not null,
    data_vencimento date not null,
    data_criacao timestamp default now(),
    data_edicao timestamp null,
    data_delecao timestamp null,
    constraint pk_cartao_bancario primary key (codigo),
    constraint fk_cartao_bancario_conta_bancaria foreign key (id_conta_bancaria) references tb_conta_bancaria (codigo),
    constraint fk_cartao_bancario_bandeira_cartao foreign key (id_bandeira_cartao) references tb_bandeira_cartao (codigo)
);

create table if not exists tb_transacao_financeira (
    codigo bigserial not null,
    codigo_publico uuid not null default gen_random_uuid(),
    id_pessoa_estabelecimento bigint not null,
    id_pessoa_comprador bigint not null,
    valor numeric(15,2) not null,
    data date not null,
    data_criacao timestamp default now(),
    data_edicao timestamp null,
    data_delecao timestamp null,
    constraint pk_transacao primary key (codigo),
    constraint fk_transacao_estabelecimento foreign key (id_pessoa_estabelecimento) references tb_pessoa (codigo),
    constraint fk_transacao_comprador foreign key (id_pessoa_comprador) references tb_pessoa (codigo)
);

create table if not exists tb_transacao_financeira_produto_servico (
    codigo bigserial not null,
    codigo_publico uuid not null default gen_random_uuid(),
    id_transacao_financeira bigint not null,
    id_produto_servico bigint not null,
    valor_unitario numeric(15,2) not null,
    quantidade int not null,
    data_criacao timestamp default now(),
    data_edicao timestamp null,
    data_delecao timestamp null,
    constraint pk_transacao_financeira_produto_servico primary key (codigo),
    constraint fk_transacao_financeira foreign key (id_transacao_financeira) references tb_transacao_financeira (codigo),
    constraint fk_produto_servico foreign key (id_produto_servico) references tb_produto_servico (codigo),
    constraint un_transacao_financeira_produto_servico unique (id_transacao_financeira, id_produto_servico, valor_unitario, data_criacao)
);

create table if not exists tb_parcelamento (
    codigo bigserial not null,
    codigo_publico uuid not null default gen_random_uuid(),
    valor numeric(15,2) not null,
    numero_parcela int not null,
    quantidade_dia_atraso int not null default 0,
    data_pagamento date not null,
    data_criacao timestamp default now(),
    data_edicao timestamp null,
    data_delecao timestamp null,
    constraint pk_parcelamento primary key (codigo)
);

create table if not exists tb_transacao_financeira_parcelamento (
    codigo bigserial not null,
    codigo_publico uuid not null default gen_random_uuid(),
    id_transacao_financeira bigint not null,
    id_parcelamento bigint not null,
    data_criacao timestamp default now(),
    data_edicao timestamp null,
    data_delecao timestamp null,
    constraint pk_transacao_financeira_parcelamento primary key (codigo),
    constraint fk_transacao_financeira foreign key (id_transacao_financeira) references tb_transacao_financeira (codigo),
    constraint fk_parcelamento foreign key (id_parcelamento) references tb_parcelamento (codigo)
);

create table if not exists tb_transacao_pagamento (
    codigo bigserial not null,
    codigo_publico uuid not null default gen_random_uuid(),
    id_transacao_financeira bigint not null,
    id_meio_pagamento bigint not null,
    id_forma_pagamento bigint not null,
    valor_pago numeric(15,2) not null,
    observacoes text null,
    data_pagamento date not null,
    data_criacao timestamp default now(),
    data_edicao timestamp null,
    data_delecao timestamp null,
    constraint pk_transacao_pagamento primary key (codigo),
    constraint fk_transacao_pagamento_transacao foreign key (id_transacao_financeira) references tb_transacao_financeira (codigo),
    constraint fk_transacao_pagamento_meio foreign key (id_meio_pagamento) references tb_meio_pagamento (codigo),
    constraint fk_transacao_pagamento_forma foreign key (id_forma_pagamento) references tb_forma_pagamento (codigo)
);

create table if not exists tb_pagamento_cartao (
    codigo bigserial not null,
    codigo_publico uuid not null default gen_random_uuid(),
    id_transacao_pagamento bigint not null,
    id_cartao_bancario bigint not null,
    constraint pk_pagamento_cartao primary key (codigo),
    constraint fk_pagamento_cartao_pagamento foreign key (id_transacao_pagamento) references tb_transacao_pagamento (codigo),
    constraint fk_pagamento_cartao_cartao foreign key (id_cartao_bancario) references tb_cartao_bancario (codigo)
);

create table if not exists tb_pagamento_conta (
    codigo bigserial not null,
    codigo_publico uuid not null default gen_random_uuid(),
    id_transacao_pagamento bigint not null,
    id_conta_bancaria bigint not null,
    constraint pk_pagamento_conta primary key (codigo),
    constraint fk_pagamento_conta_pagamento foreign key (id_transacao_pagamento) references tb_transacao_pagamento (codigo),
    constraint fk_pagamento_conta_conta foreign key (id_conta_bancaria) references tb_conta_bancaria (codigo)
);

create table if not exists tb_pagamento_parcelamento (
    codigo bigserial not null,
    codigo_publico uuid not null default gen_random_uuid(),
    id_transacao_pagamento bigint not null,
    id_parcelamento bigint not null,
    constraint pk_pagamento_parcelamento primary key (codigo),
    constraint fk_pagamento_parcelamento_pagamento foreign key (id_transacao_pagamento) references tb_transacao_pagamento (codigo),
    constraint fk_pagamento_parcelamento_parcelamento foreign key (id_parcelamento) references tb_parcelamento (codigo)
);

create table if not exists tb_anexo_transacao_financeira (
    codigo bigserial not null,
    codigo_publico uuid not null default gen_random_uuid(),
    id_transacao_financeira bigint not null,
    nome_arquivo text not null,
    caminho_arquivo text not null,
    tipo_mime varchar(100) not null,
    data_criacao timestamp default now(),
    data_delecao timestamp null,
    constraint pk_anexo primary key (codigo),
    constraint fk_anexo_transacao_financeira foreign key (id_transacao_financeira) references tb_transacao_financeira (codigo)
);

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

create table if not exists tb_contrato (
    codigo bigserial not null,
    codigo_publico uuid not null default gen_random_uuid(),
	id_categoria_contrato bigserial not null,
	id_pessoa_contratada bigserial not null,
	id_pessoa_contratante bigserial not null,
	id_vigencia_contrato bigserial not null,
	id_situacao_contrato bigserial not null,
	data_inicio date null,
	data_fim date null,
	valor_total numeric(15,2) null default 0,
	valor_total_pago numeric(15,2) not null default 0,
	dia_vencimento int not null,
	observacao varchar(255) null,
	data_criacao timestamp default current_timestamp not null,
	data_edicao timestamp default current_timestamp null,
	data_delecao timestamp null,
    constraint pk_contrato primary key (codigo),
    constraint fk_contrato_categoria_contrato foreign key (id_categoria_contrato) references tb_categoria_contrato (codigo),
	constraint fk_contrato_pessoa_contratada foreign key (id_pessoa_contratada) references tb_pessoa (codigo),
	constraint fk_contrato_pessoa_contrante foreign key (id_pessoa_contratante) references tb_pessoa (codigo),
	constraint fk_contrato_vigencia_contrato foreign key (id_vigencia_contrato) references tb_vigencia_contrato (codigo),
	constraint fk_contrato_situacao_contrato foreign key (id_situacao_contrato) references tb_situacao_contrato (codigo),
	constraint un_contrato unique (id_pessoa_contratada, id_pessoa_contratante, valor_total)
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

create table if not exists tb_fatura_contrato (
    codigo bigserial not null,
    codigo_publico uuid not null default gen_random_uuid(),
    id_contrato bigint not null,
    mes_ano date not null,
    valor numeric(15,2) not null,
    juros numeric(15,2) default 0,
    desconto numeric(15,2) default 0,
    valor_final numeric(15,2) not null,	
    descricao_situacao varchar(20) not null default 'ABERTA',
    data_criacao timestamp default now(),
    data_edicao timestamp null,
    data_delecao timestamp null,
    constraint pk_fatura_contrato primary key (codigo),
    constraint fk_fatura_contrato foreign key (id_contrato) references tb_contrato (codigo)
);

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
