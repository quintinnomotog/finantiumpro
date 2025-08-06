# 📄 Especificação de Requisitos — Módulo de Contratos

## 1. Visão Geral  
O módulo de Contratos tem como objetivo permitir o cadastro, acompanhamento, pagamento, reajuste e renovação de contratos recorrentes.  
Aplica-se aos seguintes públicos: **negócios**, **financeiro**, **gestão** e **desenvolvimento**.

## 2. Objetivos e Escopo  
- **Objetivo**: controlar contratos com valor anual parcelado, incluindo juros, inadimplência e renovações sem perda de histórico.  
- **Escopo funcional**: cadastro de contratos, geração de parcelas, registro de pagamentos, visualização de status, renovação contratual, relatório de resultados.  
- **Fora do escopo**: integração com sistemas terceiros (vendas, CRM), gestão de multas legais, suporte ao cliente.

---

## 3. Especificação Funcional 🧩  
*(O que o usuário e negócio esperam do sistema)*

### 3.1 Personas  
- **Analista de contratos**: cadastra e renova contratos.  
- **Financeiro/Administração**: acompanha pagamentos, juros e saldos.  
- **Gerente**: visualiza indicadores e relatórios gerais.

### 3.2 Casos de Uso

#### UC‑01: Cadastrar Contrato  
**Pré-Condições**: dados obrigatórios coletados.  
**Fluxo Principal**:  
1. Preencher contrato (contratante, fornecedor, valor total, vigência, dia vencimento, categoria, observações).  
2. Sistema gera automaticamente parcelas mensais iguais até completar valor total.  
3. Contrato é criado com situação `Vigente`.

#### UC‑02: Registrar Pagamento de Parcela  
**Pré-Condição**: parcela `Pendente` existe.  
**Fluxo Principal**:  
1. Seleciona parcela.  
2. Informa valor pago, data, forma e meio.  
3. Sistema calcula juros se pagamento após vencimento.  
4. Atualiza status da parcela para `Pago`.

#### UC‑03: Visualizar Contratos  
- Dashboard com lista de contratos.  
- Para cada um, exibe resumo (situação, valor total, total pago, saldo restante, indicadores de atraso e inadimplência).

#### UC‑04: Renovar Contrato  
1. Selecionar contrato vigente.  
2. Informar nova vigência, valor total (com ou sem reajuste).  
3. Sistema cria novo registro de renovação e novas parcelas associadas.

#### UC‑05: Relatórios e Indicadores  
- Valor total pago x contratado por período.  
- Percentual de inadimplência.  
- Contratos ativos vs encerrados.  
- Previsão de pagamentos futuros por mês e categoria.

---

## 4. Especificação Técnica 🛠️  
*(Como o sistema irá implementar os requisitos funcionais)*

### 4.1 Arquitetura de Dados  
**Tabelas principais**:  
- `tb_contrato`: informações básicas do contrato (valor, datas, observação).  
- `tb_parcela_contrato`: parcelas com valor base, vencimento, juros calculados, status.  
- `tb_pagamento_parcela`: registro de pagamento, valor efetivo, data, forma e meio.  
- `tb_renovacao_contrato`: histórico de ciclos do contrato (início, fim, reajuste).

Chaves e relacionamentos:  
- `parcela → contrato`,  
- `pagamento → parcela`,  
- `renovação → contrato`.

### 4.2 Regras de Negócio e Validações  
- **`CHECK` constraints**: parcelas não podem somar mais que valor total contratual.  
- **Triggers ou funções SQL** para:  
  - calcular juros ao registrar pagamento atrasado,  
  - atualizar status da parcela (`Pago`, `Aguardando`, `Pendente`),  
  - recalcular campo `valor_total_pago` no contrato.

### 4.3 Requisitos Não Funcionais (Qualidade)  
- **Segurança**: usar criptografia (como `pgcrypto`) para dados sensíveis, e UUID como identificadores públicos.  
- **Desempenho**: índices nas colunas mais consultadas (`status`, `vencimento`, `codigo_publico`).  
- **Escalabilidade**: deve suportar milhares de contratos e dezenas de parcelas por contrato.  
- **Disponibilidade**: alta disponibilidade prevista com backup e migrations via Flyway.

### 4.4 Integrações e Infraestrutura  
- Sugerimos integração futura com sistemas de pagamento automático e notificações via email/SMS.  
- Logs de auditoria para rastrear alterações (criação, edição, deleção lógica).

### 4.5 Critérios de Aceitação / Conclusão  
- Todas as funções passam em testes de caso de uso.  
- Validação automática de soma de parcelas.  
- Interface gerencial atualizada com indicadores.  
- Documentação de API ou endpoints quadrados (se houver front-end ou serviço).

---

## 5. Metodologia Recomendada  
- Levantamento de requisitos usando **workshops com stakeholders**, entrevistas e prototipagem rápida:contentReference[oaicite:5]{index=5}.  
- Especificação funcional detalhada para consenso do negócio.  
- A especificação técnica elaborada após validação funcional com a equipe dev:contentReference[oaicite:6]{index=6}.

---

## 6. Resumo Executivo  
Este documento alinha as visões funcional e técnica do Módulo de Contratos, garantindo transparência e clareza entre negócios, gestão e desenvolvimento. Ele proporciona segurança ao validar escopo, requisitos e forma de implementação antes do desenvolvimento.

