-- dbcc inputbuffer (spid)

select distinct
       dbname = cast(sd.name as varchar(25)),
       hostname = cast(sp.hostname as varchar(15)),
       spid = cast(spid as smallint),
       block = sp.blocked,
       trans = sp.open_tran,
       status = cast(sp.status as varchar(10)),
       login = cast(sp.loginame as varchar(15)),
       command = sp.cmd,
       program = cast(sp.program_name as varchar(25))
  from master..sysprocesses sp
 inner join master..sysdatabases sd on sd.dbid = sp.dbid
 where isnull(sp.hostname, '') <> ''
   and isnull(sd.name, '') <> ''
 order by dbname, hostname, spid



select distinct
       dbname = cast(sd.name as varchar(25)),
       hostname = cast(sp.hostname as varchar(15)),
       spid = cast(sl.req_spid as smallint),
       objeto = cast(so.name as varchar(30)),
       tipo = case sl.rsc_type
                 when  1 then 'Resource (not used)'
                 when  2 then 'Database'
                 when  3 then 'File'
                 when  4 then 'Index'
                 when  5 then 'Table'
                 when  6 then 'Page'
                 when  7 then 'Key'
                 when  8 then 'Extent'
                 when  9 then 'RID (Row ID)'
                 when 10 then 'Application'
              end,
       tipo_lock = case sl.req_ownertype
                      when 1 then 'Transaction'
                      when 2 then 'Cursor'
                      when 3 then 'Session'
                      when 4 then 'ExSession'
                   end,
       lock_count = sl.req_refcnt,
       modo = case sl.req_mode
                 when  0 then 'Null'
                 when  1 then 'Sch-S'
                 when  2 then 'Sch-M'
                 when  3 then 'S'
                 when  4 then 'U'
                 when  5 then 'X'
                 when  6 then 'IS'
                 when  7 then 'IU'
                 when  8 then 'IX'
                 when  9 then 'SIU'
                 when 10 then 'SIX'
                 when 11 then 'UIX'
                 when 12 then 'BU'
                 when 13 then 'RangeS_S'
                 when 14 then 'RangeS_U'
                 when 15 then 'RangeI_N'
                 when 16 then 'RangeI_S'
                 when 17 then 'RangeI_U'
                 when 18 then 'RangeI_X'
                 when 19 then 'RangeX_S'
                 when 20 then 'RangeX_U'
                 when 21 then 'RangeX_X'
              end,
       status = case sl.req_status
                   when 1 then 'Granted'
                   when 2 then 'Converting'
                   when 3 then 'Waiting'
                end,
       loginame = cast(sp.loginame as varchar(15)),
       sl.rsc_objid
  from master..syslockinfo sl
 inner join master..sysdatabases sd on sd.dbid = sl.rsc_dbid
 inner join sysobjects so on so.id = sl.rsc_objid
 inner join master..sysprocesses sp on sl.req_spid = sp.spid
 where isnull(sp.hostname, '') <> ''
   and isnull(sd.name, '') <> ''
--    and isnull(sp.loginame, '') = 'smar'
 order by dbname, hostname, spid, objeto, tipo, tipo_lock