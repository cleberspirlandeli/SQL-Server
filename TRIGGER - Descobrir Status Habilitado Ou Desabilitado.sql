-- Quando retorna 1 está Desabilitado. Se retornar 0 está Habilitado.
Select (
         Select name 
           from sysobjects x 
          where x.id=tr.parent_obj
      ) Tabela, 
      Name as NomeTrigger, 
      ObjectProperty(Object_id(Name),'ExecIsTriggerDisabled') Habilitado,
      case when ObjectProperty(Object_id(Name),'ExecIsTriggerDisabled') = 0 then 'Habilitado' else 'Desabilitado' end as StatusTrigger
From sysobjects tr
Where xtype = 'tr' and 
      name not like 'log%' and 
      Name = 'RAG01600' -- NOME DA TRIGGER
-- Na linha acima, na parte do NAME NOT LIKE, eliminamos as triggers que são do log de auditoria. 
-- Se quiser visualizar estes também, deixe no Where apenas a parte XTYPE = 'TR'
Order by Tabela, Name