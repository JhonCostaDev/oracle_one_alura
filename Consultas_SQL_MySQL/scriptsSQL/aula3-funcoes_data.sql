SELECT * FROM enderecos;

select e.cidade, count(a.avaliacao_id) total_avaliacoes, avg(a.nota) media from avaliacoes a
join hospedagens h on a.hospedagem_id = h.hospedagem_id
join enderecos e on h.endereco_id = e.endereco_id
group by e.cidade
order by media desc, total_avaliacoes desc;

-- FUNCOES DE DATA
select now() today; -- data atual

-- quantidade de dias por cliente
select c.nome, DATEDIFF(data_fim, data_inicio) quantidade_dias from reservas r
join clientes c on r.cliente_id = c.cliente_id
order by quantidade_dias desc;

-- quantidade de dias portipo de hospedagem
select h.tipo, SUM(DATEDIFF(data_fim, data_inicio)) quantidade_dias from reservas r
join hospedagens h on r.hospedagem_id = h.hospedagem_id
group by h.tipo
order by quantidade_dias desc;