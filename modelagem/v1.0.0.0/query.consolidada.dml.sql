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

insert into tb_tipo_pessoa (descricao) values ('Pessoa Física');
insert into tb_tipo_pessoa (descricao) values ('Pessoa Jurídica');
insert into tb_tipo_pessoa (descricao) values ('Pessoa Sistema');
insert into tb_tipo_pessoa (descricao) values ('Pessoa Instituição Financeira');

insert into tb_tipo_conta_bancaria (descricao) values ('Conta Carteira');
insert into tb_tipo_conta_bancaria (descricao) values ('Conta Corrente');
insert into tb_tipo_conta_bancaria (descricao) values ('Conta Poupança');
insert into tb_tipo_conta_bancaria (descricao) values ('Conta Investimento');

insert into tb_pessoa (id_tipo_pessoa, nome) values (
	(select codigo from tb_tipo_pessoa where descricao = 'Pessoa Instituição Financeira'),
	'Conta Carteira'
);

insert into tb_pessoa (id_tipo_pessoa, nome) values (
	(select codigo from tb_tipo_pessoa where descricao = 'Pessoa Física'),
	'Usuário do Sistema'
);

insert into tb_conta_bancaria (id_tipo_conta_bancaria, id_pessoa_instituicao_financeira, saldo) values (
	(select codigo from tb_tipo_conta_bancaria where descricao = 'Conta Carteira'),
	(select codigo from tb_pessoa where id_tipo_pessoa = 4),
	0
);

insert into tb_pessoa (id_tipo_pessoa, nome) values (
	(select codigo from tb_tipo_pessoa where descricao = 'Pessoa Física'),
	'Deinin Meys Lasarn'
);

insert into tb_pessoa (id_tipo_pessoa, nome) values (
	(select codigo from tb_tipo_pessoa where descricao = 'Pessoa Jurídica'),
	'Casa Grande Mecânica e Eletrica em Geral'
);

insert into tb_transacao_financeira (id_pessoa_estabelecimento, id_pessoa_comprador, data, valor) values (
	(select codigo from tb_pessoa where nome = 'Casa Grande Mecânica e Eletrica em Geral'),
	(select codigo from tb_pessoa where nome = 'Deinin Meys Lasarn'),
	now(),
	440
);

-- Detalhar a Transação Financeira

insert into tb_produto_servico (nome) values ('Silicone Neutro Car 80');
insert into tb_produto_servico (nome) values ('Percador de Óleo');
insert into tb_produto_servico (nome) values ('Mão de Obra Especializada');

insert into tb_transacao_financeira_produto_servico (id_produto_servico, id_transacao_financeira, valor_unitario, quantidade) values (
	(select codigo from tb_produto_servico where nome = 'Silicone Neutro Car 80'),
	(select codigo from tb_transacao_financeira where valor = 440),
	60,
	2
);

insert into tb_transacao_financeira_produto_servico (id_produto_servico, id_transacao_financeira, valor_unitario, quantidade) values (
	(select codigo from tb_produto_servico where nome = 'Percador de Óleo'),
	(select codigo from tb_transacao_financeira where valor = 440),
	120,
	1
);

insert into tb_transacao_financeira_produto_servico (id_produto_servico, id_transacao_financeira, valor_unitario, quantidade) values (
	(select codigo from tb_produto_servico where nome = 'Mão de Obra Especializada'),
	(select codigo from tb_transacao_financeira where valor = 440),
	200,
	1
);

-- Pagar a Transação Financeira

insert into tb_forma_pagamento (descricao) values ('À Vista');
insert into tb_forma_pagamento (descricao) values ('Parcelado');
insert into tb_forma_pagamento (descricao) values ('Recorrente');
insert into tb_forma_pagamento (descricao) values ('Antecipado');

insert into tb_meio_pagamento (descricao) values ('Dinheiro');
insert into tb_meio_pagamento (descricao) values ('Transferência Bancária - TED');
insert into tb_meio_pagamento (descricao) values ('Transferência Bancária - DOC');
insert into tb_meio_pagamento (descricao) values ('Transferência Bancária - PIX');
insert into tb_meio_pagamento (descricao) values ('Cartão de Débito em Conta Corrente');
insert into tb_meio_pagamento (descricao) values ('Cartão de Crédito em Conta Corrente');

insert into tb_transacao_pagamento (id_transacao_financeira, id_forma_pagamento, id_meio_pagamento, valor_pago, data_pagamento) values (
	(select codigo from tb_transacao_financeira where valor = 440),
	(select codigo from tb_forma_pagamento where descricao = 'À Vista'),
	(select codigo from tb_meio_pagamento where descricao = 'Transferência Bancária - PIX'),
	200,
	'2025-08-05'
);

insert into tb_transacao_pagamento (id_transacao_financeira, id_forma_pagamento, id_meio_pagamento, valor_pago, data_pagamento) values (
	(select codigo from tb_transacao_financeira where valor = 440),
	(select codigo from tb_forma_pagamento where descricao = 'À Vista'),
	(select codigo from tb_meio_pagamento where descricao = 'Cartão de Débito em Conta Corrente'),
	220,
	'2025-08-05'
);

/*
select *
from tb_transacao_financeira;

select * from tb_transacao_financeira_produto_servico; 

select 
    pessoa.nome,
    produto_servico.nome,
    sum(transacao_financeira_produto_servico.valor_unitario * transacao_financeira_produto_servico.quantidade) as valor_produto,
    (
        select sum(t2.valor_unitario * t2.quantidade) from tb_transacao_financeira_produto_servico t2
    ) as valor_total_geral
  from tb_transacao_financeira transacao_financeira 
  join tb_pessoa pessoa on pessoa.codigo = transacao_financeira.id_pessoa_estabelecimento
  join tb_transacao_financeira_produto_servico transacao_financeira_produto_servico on transacao_financeira_produto_servico.id_transacao_financeira = transacao_financeira.codigo
  join tb_produto_servico produto_servico on produto_servico.codigo = transacao_financeira_produto_servico.id_produto_servico
  group by pessoa.nome, transacao_financeira_produto_servico.id_produto_servico, produto_servico.nome;
*/

  -- Fuxo de Contrato
  insert into tb_pessoa (id_tipo_pessoa, nome) values (
	(select codigo from tb_tipo_pessoa where descricao = 'Pessoa Física'),
	'Brava Internet'
);
  insert into tb_categoria_contrato (descricao) values ('Serviço de Internet Fixa');
   insert into tb_vigencia_contrato (descricao) values ('Semanal');
   insert into tb_vigencia_contrato (descricao) values ('Mensal');
   insert into tb_vigencia_contrato (descricao) values ('Anual');
   insert into tb_situacao_contrato (descricao) values ('Vigênte');
   insert into tb_situacao_contrato (descricao) values ('Encerrado');

insert into tb_contrato (id_categoria_contrato, id_pessoa_contratada, id_pessoa_contratante, id_vigencia_contrato, id_situacao_contrato, data_inicio, dia_vencimento) values (
    (select codigo from tb_categoria_contrato where descricao = 'Serviço de Internet Fixa'),
    (select codigo from tb_pessoa where nome = 'Brava Internet'),
    (select codigo from tb_pessoa where nome = 'Deinin Meys Lasarn'),
    (select codigo from tb_vigencia_contrato where descricao  = 'Anual'),
    (select codigo from tb_situacao_contrato where descricao = 'Vigênte'),
    '2025-01-01', 10
);

