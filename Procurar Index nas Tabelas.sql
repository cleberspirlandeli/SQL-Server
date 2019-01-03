

-- PROCURAR id E parent_obj
select * from sysobjects where name like '%RAE15900%'


-- PROCURAR POR parent_obj = numero parent_obj
-- Todos objetos relacionados a tabela 
select * from sysobjects where parent_obj = 97550135


-- PROCURAR POR id = numero parent_obj
-- seleciona o index
select * from sysobjects where id = 97550135
