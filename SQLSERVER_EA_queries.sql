
SELECT * FROM [dbo].[t_package] where name = 'RAM';

SELECT * FROM [dbo].[t_package] where name = 'ACCPAC';
SELECT * FROM [dbo].[t_package] WHERE PARENT_ID = 27
SELECT * FROM [dbo].[t_package] WHERE PARENT_ID = 7380;
SELECT * FROM [dbo].[t_package] WHERE PARENT_ID = 27; -- parent Volet Information
select * from [dbo].[t_package]  where package_id = 7385 -- 7567;
select * from[dbo].[t_attribute] ;
select * from [dbo].[t_object];

select * from [dbo].[t_object] WHERE PACKAGE_ID = 7380;
select * from [dbo].[t_object] WHERE OBJECT_ID = 46763; --PKG ID = 7380
select * from [dbo].[t_object] WHERE PACKAGE_ID =  7380;
SELECT * FROM T_PACKAGE WHERE Parent_ID =  7380;
SELECT * FROM T_PACKAGE WHERE Parent_ID =  7385;
select name from [dbo].[t_object] WHERE PACKAGE_ID =  7385 AND substring(name,4,1)  not LIKE '%[0-9]%' AND LEN(Alias) =2 ORDER BY NAME ;


SELECT name  FROM  [dbo].[t_package] where PARENT_ID =  4870 and substring(name,1,1)  not LIKE '%[0-9]%'  

order by name ; --Volet Systemes 

SELECT * FROM t_stereotypes;
SELECT * FROM [SPARXSYSTEM].[dbo].t_stereotypes;


select * from t_object as o join t_package as p on o.ea_guid = p.ea_guid where o.Name = 'Volet Information' ; --7567

select * from[dbo].[t_object] as o join t_package as p on o.ea_guid = p.ea_guid where o.Package_ID = 7567;

select * from t_object where Package_ID = 4295 and Object_Type in ('Class', 'Interface', 'Enumeration');

select * from  t_attribute where Object_ID = 48996 order by Pos;
--Find Classes or Interfaces by name:

----Aoociations et connectors--------------

select distinct object_type  from t_object o;
select * from t_object o where o.object_type = 'Association';

select 
c.Name, c.Direction, c.Connector_Type, c.SourceCard, c.DestCard, c.Start_Object_ID, c.End_Object_ID, c.Top_Mid_Label, 
(select o.name from t_object o where  o.object_id = c.Start_Object_ID) AS source_object,
(select o.name from t_object o where  o.object_id = c.End_Object_ID) AS Target_object
from t_connector c 
where c.connector_type = 'Association' 
and
(
c.Start_Object_ID = (select object_id from t_object where name = '06.02.03 Élément Assujetti')
or
c.End_Object_ID = (select object_id from t_object where name = '06.02.03 Élément Assujetti')
)
--and 
--(c.Start_Object_ID = 47491 or c.end_object_id = 47491)
--and direction = 'Source -> Destination'
and c.Connector_ID in (select connectorid from t_diagramlinks where diagramid = 12045)
order by c.Direction
;




select * from t_diagram where name = '06.02 Élément Assujetti'; --12045
select * from t_diagramobjects where diagram_id = 12045;
select * from  t_object o where o.name = '06.02.03 Élément Assujetti' ;

select * from t_diagramlinks where diagramid = 12045;
select * from t_object where name like '%Application - Objets information%';


select * from t_object o
where name like '%06.02.03 Élément Assujetti%';

------------------------------------------------------------------
------------------------Objet d'information
select --o.ea_guid as CLASSGUID, 
--o.Object_Type as CLASSTYPE, o.Stereotype,
o.name as Name --, o.modifieddate 
--,package.name as 'Package Name' ,package_p1.name as 'Package level -1',package_p2.name as 'Package level -2',package_p3.name as 'Package level -3'
from (((( t_object o
inner join t_package package on o.package_id = package.package_id)
left join t_package package_p1 on package_p1.package_id = package.parent_id)
left join t_package package_p2 on package_p2.package_id = package_p1.parent_id)
left join t_package package_p3 on package_p3.package_id = package_p2.parent_id)
where
o.Object_Type in ('Class','Interface')
and 
package.name = 'Volet Information'
and o.Stereotype != 'Entité données'
and o.Stereotype like '%information%'
--and o.Name like '06.%'
--and o.Name like '%assujet%'
--and o.Name like '03.02.01%'
--AND upper(o.Name) like  '[0-9][0-9][.][0-9][0-9][.][A-Z][A-Z]%' 
--AND o.Name like  '[0-9][0-9][.][0-9][0-9][.][0-9][0-9]%' 
--AND o.Name like  '[0-9][0-9][.][0-9][0-9]%' 
--and substring(o.Name, 7,2) not like '[0-9]%'
AND upper(o.Name) like  '[0-9][0-9]%'
and upper(o.Name) not like  '%XX%'
order by o.name 
;

select * from t_object;
------------------------------------Fonctions d'affaire

select --o.ea_guid as CLASSGUID, 
o.Object_Type as CLASSTYPE, o.Stereotype,
o.name as Name
,package.name as 'Package Name' ,package_p1.name as 'Package level -1',package_p2.name as 'Package level -2',package_p3.name as 'Package level -3'
from (((( t_object o
inner join t_package package on o.package_id = package.package_id)
left join t_package package_p1 on package_p1.package_id = package.parent_id)
left join t_package package_p2 on package_p2.package_id = package_p1.parent_id)
left join t_package package_p3 on package_p3.package_id = package_p2.parent_id)
where
o.Object_Type in ('Class','Interface')
and package.name = 'Volet Affaires'
--and o.Stereotype != 'Entité données'
--and o.Name like '03.02.01%'
--and o.Name like '01.04.01%'
order by o.name
;




--Find Elements by stereotype:

SELECT * FROM t_object WHERE ea_guid = '{30D3E963-3712-4605-AB66-1FD26DDFD297}';

select DISTINCT -- package.package_id,o.ea_guid as CLASSGUID, o.Object_Type as CLASSTYPE, 
package.name as 'Package Name' , o.name as Name
from ((t_object o
left join t_xref stereo on stereo.Client = o.ea_guid)
inner join t_package package on o.package_id = package.package_id)
where package.name = 'Volet Information'
--AND o.name LIKE '01%'
AND  package.package_id = 7385
and substring(o.name,1,2)  LIKE '%[0-9]%'   
ORDER BY O.NAME;

select DISTINCT -- package.package_id,o.ea_guid as CLASSGUID, o.Object_Type as CLASSTYPE, 
package.name as 'Package Name' , o.name as Name
from ((t_object o
left join t_xref stereo on stereo.Client = o.ea_guid)
inner join t_package package on o.package_id = package.package_id)
where package.name = 'Tests'

select * from t_package p where p.Name ='FAOUZI';
select * from t_object where name  ='FAOUZI';


select o.ea_guid as CLASSGUID, o.Object_Type as CLASSTYPE, o.name as Name
,package.name as 'Package Name' ,package_p1.name as 'Package level -1',package_p2.name as 'Package level -2',package_p3.name as 'Package level -3'
from (((( t_object o
inner join t_package package on o.package_id = package.package_id)
left join t_package package_p1 on package_p1.package_id = package.parent_id)
left join t_package package_p2 on package_p2.package_id = package_p1.parent_id)
left join t_package package_p3 on package_p3.package_id = package_p2.parent_id)
where package_p1.name = 'FAOUZI';

select o.ea_guid as CLASSGUID, o.Object_Type as CLASSTYPE, o.name as Name
,package.name as 'Package Name' ,package_p1.name as 'Package level -1',package_p2.name as 'Package level -2',package_p3.name as 'Package level -3'
from (((( t_object o
inner join t_package package on o.package_id = package.package_id)
left join t_package package_p1 on package_p1.package_id = package.parent_id)
left join t_package package_p2 on package_p2.package_id = package_p1.parent_id)
left join t_package package_p3 on package_p3.package_id = package_p2.parent_id)
where package_p1.name = 'Client';


select * from t_attribute where name = 'ID CLIENT';--Name = ID CLIENT
select * from t_object where object_id = 49214;--Name = Client
select * from t_package where package_id =7627; --NAME = Informations
select * from t_package where package_id =7631;  --Name = FAOUZI
select * from t_package where package_id =142;  -- NAME = Tests
select * from t_package where package_id =141;  -- NAME = Tests
--------------------------------------------------------------
select * from t_package where name = 'Volet Information'; --7567
select * from t_package where package_id in (7380,7555,7567)
select * from t_package where name = 'AEM';

select * from t_object where package_id = 7567;
select * from t_object where name = '06.01.01 Client'; -- Object_id = 47600
select * from t_attribute where object_id = 47600



select DISTINCT -- package.package_id,o.ea_guid as CLASSGUID, o.Object_Type as CLASSTYPE, 
--package.name as 'Package Name' , 
o.name as Name, 
CASE WHEN substring(o.name,1,2) LIKE '%[0-9]%'   AND substring(o.name,4,2) not LIKE '%[0-9]%' then o.name end as Domaine_Info,
CASE WHEN substring(o.name,4,2) LIKE '%[0-9]%'   AND substring(o.name,6,2) not LIKE '%[0-9]%' then o.name end as Objet_Majeure_Info,
CASE WHEN substring(o.name,1,2) LIKE '%[0-9]%'  AND substring(o.name,6,2)  LIKE '%[0-9]%' then o.name end as Objet_Info
--CASE WHEN  TRY_CONVERT(FLOAT,substring(o.name,1,6)) IS NOT NULL THEN o.name END  TEST1,
--CASE WHEN  TRY_CONVERT(FLOAT,substring(o.name,1,2)) IS NOT NULL THEN o.name END  TEST2
from ((t_object o
left join t_xref stereo on stereo.Client = o.ea_guid)
inner join t_package package on o.package_id = package.package_id)
where package.name = 'Volet Information'
--AND o.name LIKE '01%'
AND  package.package_id = 7385
and substring(o.name,1,2)  LIKE '%[0-9]%'   
and upper(o.name)  like '%ASSUJET%'
ORDER BY O.NAME;

SELECT
    CASE WHEN TRY_CONVERT(FLOAT, 'test') IS NULL
    THEN 'Cast failed'
    ELSE 'Cast succeeded'
END AS Result;

select * from t_package where name = 'Dictionnaire de donnees'; --package_id = 7829;

select o.ea_guid as CLASSGUID, o.Object_Type as CLASSTYPE, o.name as Name
,package.name as 'Package Name' ,package_p1.name as 'Package level -1',package_p2.name as 'Package level -2',package_p3.name as 'Package level -3'
from (((( t_object o
inner join t_package package on o.package_id = package.package_id)
left join t_package package_p1 on package_p1.package_id = package.parent_id)
left join t_package package_p2 on package_p2.package_id = package_p1.parent_id)
left join t_package package_p3 on package_p3.package_id = package_p2.parent_id)
where package_p1.name = 'Dictionnaire de donnees';



select 
package_p1.name as 'Parent Folder' , 
package.name as 'Data Source' ,
class.name as 'Table Name',
 a.name as 'Column Name',
--a.Stereotype,
 a.notes,
 a.Type as 'Type',
 a.length,
 a.Precision, 
 a.Scale, 
 a.Derived,
 a.[Default] as 'Default_Value',
 a.AllowDuplicates
--a.ea_guid as CLASSGUID,
--'Attribute' as CLASSTYPE,
--a.name as Name
--,package_p2.name as 'Package level -2',package_p3.name as 'Package level -3'
from (((((t_attribute  a
inner join t_object class on a.object_id = class.object_id)
inner join t_package package on class.package_id = package.package_id)
left join t_package package_p1 on package_p1.package_id = package.parent_id)
left join t_package package_p2 on package_p2.package_id = package_p1.parent_id)
left join t_package package_p3 on package_p3.package_id = package_p2.parent_id)
where package_p1.name = 'Dictionnaire de donnees'
AND class.name  = 'DH_DONNEE_RECUEILLIE_7JRS'
order by package.name,
class.name ,
 a.name  
 ;
 
 
 select DISTINCT -- package.package_id,o.ea_guid as CLASSGUID, o.Object_Type as CLASSTYPE, 
--package.name as 'Package Name' -- , 
o.name as Name
from ((t_object o
left join t_xref stereo on stereo.Client = o.ea_guid)
inner join t_package package on o.package_id = package.package_id)
where package.name = 'Volet Information'
--AND o.name LIKE '01%'
AND  package.package_id = 7385
and substring(o.name,1,2)  LIKE '%[0-9]%'   
--and substring(o.name,1,5)  ='07.02'

ORDER BY O.NAME;


select DISTINCT -- package.package_id,o.ea_guid as CLASSGUID, o.Object_Type as CLASSTYPE, 
--package.name as 'Package Name' , 
--o.name as Name, 
CASE WHEN substring(o.name,1,2) LIKE '%[0-9]%'   AND substring(o.name,4,2) not LIKE '%[0-9]%' then o.name end as test1,
CASE WHEN substring(o.name,4,2) LIKE '%[0-9]%'   AND substring(o.name,6,2) not LIKE '%[0-9]%' then o.name end as test2--,
--CASE WHEN substring(o.name,1,2) LIKE '%[0-9]%'  AND substring(o.name,6,2)  LIKE '%[0-9]%' then o.name end as test3
--CASE WHEN  TRY_CONVERT(FLOAT,substring(o.name,1,6)) IS NOT NULL THEN o.name END  TEST1,
--CASE WHEN  TRY_CONVERT(FLOAT,substring(o.name,1,2)) IS NOT NULL THEN o.name END  TEST2
from ((t_object o
left join t_xref stereo on stereo.Client = o.ea_guid)
inner join t_package package on o.package_id = package.package_id)
where package.name = 'Volet Information'
--AND o.name LIKE '01%'
AND  package.package_id = 7385
and substring(o.name,1,2)  LIKE '%[0-9]%'   
--ORDER BY O.NAME
;


select DISTINCT -- package.package_id,o.ea_guid as CLASSGUID, o.Object_Type as CLASSTYPE, 
--package.name as 'Package Name' , 
o.name as Name
from ((t_object o
left join t_xref stereo on stereo.Client = o.ea_guid)
inner join t_package package on o.package_id = package.package_id)
where package.name = 'Volet Information'
--AND o.name LIKE '01%'
AND  package.package_id = 7385
and substring(o.name,1,2)  LIKE '%[0-9]%'   
and  substring(o.name,7,2)  not LIKE '%[0-9]%'   
ORDER BY O.NAME;



select 
package_p1.name as 'Parent Folder' , 
package_p2.name as 'Parent Folder1',
package_p3.name as 'Parent Folder2',
package.name as 'Data Source' ,
class.name as 'Table Name',
 a.name as 'Column Name',
--a.Stereotype,
 a.notes,
 a.Type as 'Type',
 a.length,
 a.Precision, 
 a.Scale, 
 a.Derived,
 a.[Default] as 'Default_Value',
 a.AllowDuplicates
--a.ea_guid as CLASSGUID,
--'Attribute' as CLASSTYPE,
--a.name as Name
--,package_p2.name as 'Package level -2',package_p3.name as 'Package level -3'
from (((((t_attribute  a
inner join t_object class on a.object_id = class.object_id)
inner join t_package package on class.package_id = package.package_id)
left join t_package package_p1 on package_p1.package_id = package.parent_id)
left join t_package package_p2 on package_p2.package_id = package_p1.parent_id)
left join t_package package_p3 on package_p3.package_id = package_p2.parent_id)
where package.name = 'Volet Information'
--AND class.name  = 'DH_DONNEE_RECUEILLIE_7JRS'
and substring(class.name,1,2) NOT  LIKE '%[0-9]%'   
order by package.name,
class.name ,
 a.name  
 ;
 -------------------------------------
 SELECT * FROM [dbo].[t_package] where name = 'Tables' and Parent_ID = 8072; --package_id = 8140

 select DISTINCT -- package.package_id,o.ea_guid as CLASSGUID, o.Object_Type as CLASSTYPE, 
--package.name as 'Package Name' , 
o.name as Name
from ((t_object o
left join t_xref stereo on stereo.Client = o.ea_guid)
inner join t_package package on o.package_id = package.package_id)
where --package.name = 'Volet Information'
--AND o.name LIKE '01%'
--AND  
package.package_id = 8140
--and substring(o.name,1,2)  LIKE '%[0-9]%'   
--and  substring(o.name,7,2)  not LIKE '%[0-9]%'   
ORDER BY O.NAME;


select 
package_p1.name as 'Parent Folder' , 
package_p2.name as 'Parent Folder1',
package_p3.name as 'Parent Folder2',
package.name as 'Data Source' ,
class.name as 'Table Name',
a.*,
 a.name as 'Column Name',
--a.Stereotype,
 a.notes,
 a.Type as 'Type',
 a.length,
 a.Precision, 
 a.Scale, 
 a.Derived,
 a.[Default] as 'Default_Value',
 a.AllowDuplicates
--a.ea_guid as CLASSGUID,
--'Attribute' as CLASSTYPE,
--a.name as Name
--,package_p2.name as 'Package level -2',package_p3.name as 'Package level -3'
from (((((t_attribute  a
inner join t_object class on a.object_id = class.object_id)
inner join t_package package on class.package_id = package.package_id)
left join t_package package_p1 on package_p1.package_id = package.parent_id)
left join t_package package_p2 on package_p2.package_id = package_p1.parent_id)
left join t_package package_p3 on package_p3.package_id = package_p2.parent_id)
where package_p3.name = 'Tests'
and package_p1.name ='Faouzi'-- 'STH_Physique'
--and class.name ='TH_TRANC_FINNC'
--AND class.name  = 'DH_DONNEE_RECUEILLIE_7JRS'
 
order by package.name,
class.name ,
 a.name  
 ;

select 
--package_p1.name as 'Parent Folder' , 
--package_p2.name as 'Parent Folder1',
--package_p3.name as 'Parent Folder2',
--package.name as 'Data Source' ,
UPPER(class.name) as 'Table Name',
--a.*,
 UPPER(a.name) as 'Column Name'--,
--a.Stereotype,
 --a.notes,
-- a.Type as 'Type',
-- a.length,
-- a.Precision, 
-- a.Scale, 
-- a.Derived,
 --a.[Default] as 'Default_Value',
-- a.AllowDuplicates
--a.ea_guid as CLASSGUID,
--'Attribute' as CLASSTYPE,
--a.name as Name
--,package_p2.name as 'Package level -2',package_p3.name as 'Package level -3'
from (((((t_attribute  a
inner join t_object class on a.object_id = class.object_id)
inner join t_package package on class.package_id = package.package_id)
left join t_package package_p1 on package_p1.package_id = package.parent_id)
left join t_package package_p2 on package_p2.package_id = package_p1.parent_id)
left join t_package package_p3 on package_p3.package_id = package_p2.parent_id)
where package_p3.name = 'STH'
and package_p1.name ='Logical Data Model'-- 'STH_Physique'
and class.name ='TH_TRANC_FINNC'
--AND class.name  = 'DH_DONNEE_RECUEILLIE_7JRS'
 EXCEPT
  select 
--package_p1.name as 'Parent Folder' , 
--package_p2.name as 'Parent Folder1',
--package_p3.name as 'Parent Folder2',
--package.name as 'Data Source' ,
UPPER(class.name) as 'Table Name',
--a.*,
 UPPER(a.name) as 'Column Name'--,
--a.Stereotype,
 --a.notes,
 --a.Type as 'Type',
 --a.length,
-- a.Precision, 
 --a.Scale, 
 --a.Derived,
 --a.[Default] as 'Default_Value',
 --a.AllowDuplicates
--a.ea_guid as CLASSGUID,
--'Attribute' as CLASSTYPE,
--a.name as Name
--,package_p2.name as 'Package level -2',package_p3.name as 'Package level -3'
from (((((t_attribute  a
inner join t_object class on a.object_id = class.object_id)
inner join t_package package on class.package_id = package.package_id)
left join t_package package_p1 on package_p1.package_id = package.parent_id)
left join t_package package_p2 on package_p2.package_id = package_p1.parent_id)
left join t_package package_p3 on package_p3.package_id = package_p2.parent_id)
where package_p3.name = 'STH'
and package_p1.name = 'STH_Physique'
and class.name ='TH_TRANC_FINNC'
--AND class.name  = 'DH_DONNEE_RECUEILLIE_7JRS'
  ;

 ;

 SELECT * FROM T_ATTRIBUTE WHERE NAME = 'PK_TH_TRANC_FINNC';
select * from t_object where Object_ID in
(53117,53129,53136,53170,53190);
select * from t_objectproperties where object_id =53190;

SELECT t_connector.Connector_ID, t_connector.SourceRole, t_connector.DestRole, t_connector.StyleEx 
FROM t_connector, t_operation WHERE t_connector.Start_Object_ID = t_operation.Object_ID 
AND t_operation.Stereotype = 'FK' 

select * from t_connector;
select * from t_operation where Stereotype ='PK' AND NAME = 'PK_TH_TRANC_FINNC' AND OBJECT_ID =53190 ;
select * from t_operation where Stereotype ='FK' 
AND NAME LIKE 'FK_TH_TRANC%' AND ReturnArray IS NOT null and object_id = 53190;

select 
--package_p1.name as 'Parent Folder' , 
--package_p2.name as 'Parent Folder1',
--package_p3.name as 'Parent Folder2',
--package.name as 'Data Source' ,
UPPER(class.name) as 'Table Name',
--a.*,
 UPPER(a.name) as 'Column Name'--,
--a.Stereotype,
 --a.notes,
-- a.Type as 'Type',
-- a.length,
-- a.Precision, 
-- a.Scale, 
-- a.Derived,
 --a.[Default] as 'Default_Value',
-- a.AllowDuplicates
--a.ea_guid as CLASSGUID,
--'Attribute' as CLASSTYPE,
--a.name as Name
--,package_p2.name as 'Package level -2',package_p3.name as 'Package level -3'
from (((((t_attribute  a
inner join t_object class on a.object_id = class.object_id)
inner join t_package package on class.package_id = package.package_id)
left join t_package package_p1 on package_p1.package_id = package.parent_id)
left join t_package package_p2 on package_p2.package_id = package_p1.parent_id)
left join t_package package_p3 on package_p3.package_id = package_p2.parent_id)
where package_p3.name = 'STH'
and package_p1.name =--'Logical Data Model'
 'STH_Physique'
--and class.name ='TH_DROIT'
--AND class.name  = 'DH_DONNEE_RECUEILLIE_7JRS'
Order by class.name , a.name;


select * from t_package where upper(name) = 'IMPORT_MCD_STH_V2'; -- ID = 12512



select * from t_package where name =  'Modèle conceptuel Gestion des barrages publics GB';

SELECT NAME FROM t_object WHERE Package_ID= 14168 ORDER BY NAME;

SELECT name, Stereotype
FROM t_object WHERE Package_ID= 12512 -- and  object_id = 75169 
ORDER BY NAME ;

select * from t_objectproperties where object_id = 75169;

SELECT obj.NAME , objprop.value
FROM t_object obj, t_objectproperties objprop 
WHERE 
obj.Object_ID = objprop.Object_ID
and obj.Package_ID= 14167 
and  objprop.property = 'Code'
ORDER BY value;


--select * from t_stereotypes where ea_guid = '{00382EFB-1E49-b21e-A11C-1FDF37B7FCBF}';
--select * from t_xref where XrefID = '{00382EFB-1E49-b21e-A11C-1FDF37B7FCBF}';

select t_object.ea_guid AS CLASSGUID, t_object.Object_Type AS CLASSTYPE, t_object.Name, t_object.Object_Type as BaseType, t_object.Stereotype, t_xref.Description
from t_object, t_xref
where t_object.ea_guid = t_xref.Client and t_xref.Name='Stereotypes'
-------

select *   from t_package where name = 'Barrages';

select package_id  from t_package where parent_id =14230 and  name in ( 'Acteurs','Actif Immobilier Barrage','Associations','Domaines de valeurs','Gestion des barrages','Sécurité Barrage');

SELECT NAME FROM t_object WHERE Package_ID= 14230 ORDER BY NAME;

SELECT name, Stereotype
FROM t_object WHERE Package_ID= 12512 -- and  object_id = 75169 
ORDER BY NAME ;

select * from t_objectproperties where object_id = 75169;

SELECT obj.NAME , objprop.value
FROM t_object obj, t_objectproperties objprop 
WHERE 
obj.Object_ID = objprop.Object_ID
and obj.Package_ID in (select package_id  from t_package where parent_id =14230 and  name in ( 'Acteurs','Actif Immobilier Barrage','Associations','Domaines de valeurs','Gestion des barrages','Sécurité Barrage')
)
and  objprop.property = 'Code'
ORDER BY value;


SELECT v.name ,obj.NAME , objprop.value, obj.note
FROM t_object obj, t_objectproperties objprop ,
(select package_id , name  from t_package where parent_id =14230 )   v where 
obj.Object_ID = objprop.Object_ID
and v.name in ( 'Acteurs','Actif Immobilier Barrage','Associations','Domaines de valeurs','Gestion des barrages','Sécurité Barrage')
and obj.package_id = v.package_id 
and  objprop.property = 'Code'
--and obj.note like  '%Commentaire a verifier%'
--and obj.note like  '%QUESTION%'

ORDER BY value;
--------

------------------------domaine d'information--------
select 
o.name as Name 
from (((( t_object o
inner join t_package package on o.package_id = package.package_id)
left join t_package package_p1 on package_p1.package_id = package.parent_id)
left join t_package package_p2 on package_p2.package_id = package_p1.parent_id)
left join t_package package_p3 on package_p3.package_id = package_p2.parent_id)
where
o.Object_Type in ('Class','Interface')
and 
package.name = 'Volet Information'
and o.Stereotype != 'Entité données'
and upper(o.Name) not like  '%XX%'
and o.Stereotype = 'Domaine information'
order by o.name 
;

------------------------Domaine  d'information Majeure--------

select 
o.name as Name 
,package.name as 'Package Name',o.Stereotype 
from (((( t_object o
inner join t_package package on o.package_id = package.package_id)
left join t_package package_p1 on package_p1.package_id = package.parent_id)
left join t_package package_p2 on package_p2.package_id = package_p1.parent_id)
left join t_package package_p3 on package_p3.package_id = package_p2.parent_id)
where
o.Object_Type in ('Class','Interface')
and 
package.name = 'Volet Information'
and o.Stereotype != 'Entité données'
and o.Stereotype like '%information%'
AND upper(o.Name) like  '[0-9][0-9]%'
and upper(o.Name) not like  '%XX%'
--and o.Stereotype = 'Objet information majeur'
order by o.name 
;

------------------------Objet d'information--------
select 
o.name as Name 
,package.name as 'Package Name' 
from (((( t_object o
inner join t_package package on o.package_id = package.package_id)
left join t_package package_p1 on package_p1.package_id = package.parent_id)
left join t_package package_p2 on package_p2.package_id = package_p1.parent_id)
left join t_package package_p3 on package_p3.package_id = package_p2.parent_id)
where
o.Object_Type in ('Class','Interface')
and 
package.name = 'Volet Information'
and o.Stereotype != 'Entité données'
and o.Stereotype like '%information%'
AND upper(o.Name) like  '[0-9][0-9]%'
and upper(o.Name) not like  '%XX%'
--and o.Stereotype = 'Objet information'
order by o.name 
;

select DISTINCT -- package.package_id,o.ea_guid as CLASSGUID, o.Object_Type as CLASSTYPE, 
--package.name as 'Package Name' , 
o.name as Name, 
CASE WHEN substring(o.name,1,2) LIKE '%[0-9]%'   AND substring(o.name,4,2) not LIKE '%[0-9]%' then o.name end as test1,
CASE WHEN substring(o.name,4,2) LIKE '%[0-9]%'   AND substring(o.name,6,2) not LIKE '%[0-9]%' then o.name end as test2,
CASE WHEN substring(o.name,1,2) LIKE '%[0-9]%'  AND substring(o.name,6,2)  LIKE '%[0-9]%' then o.name end as test3
--CASE WHEN  TRY_CONVERT(FLOAT,substring(o.name,1,6)) IS NOT NULL THEN o.name END  TEST1,
--CASE WHEN  TRY_CONVERT(FLOAT,substring(o.name,1,2)) IS NOT NULL THEN o.name END  TEST2
from ((t_object o
left join t_xref stereo on stereo.Client = o.ea_guid)
inner join t_package package on o.package_id = package.package_id)
where package.name = 'Volet Information'
--AND o.name LIKE '01%'
AND  package.package_id = 7385
and substring(o.name,1,2)  LIKE '%[0-9]%'  
and o.Stereotype in( 'Domaine information','Objet information majeur','Objet information')
ORDER BY O.NAME;

select * from t_diagram where name = 'Barrages'; --diagram id = 17287
select * from t_diagramobjects where diagram_id = 17287;
select * from  t_object o where o.name = '06.02.03 Élément Assujetti' ;

select * from t_diagramlinks where diagramid = 17287;
select * from t_object where name like '%Application - Objets information%';


select * from t_connector where Connector_ID = 62379;

select * from t_object o
where name like '%06.02.03 Élément Assujetti%';


select * from t_package where name = 'Actif Immobilier Barrage'; -- package_id = 14230
select * from t_object where name = 'Reservoir' and package_id = 14231; --object_id 86607
select * from t_diagram where name = 'Gestion des Barrages_MCD_cible'; -- diagram_id = 17287
select * from t_diagramobjects where diagram_id = 17287 and object_id =86607;
select * from t_diagramlinks where diagramid = 17287;

select * from t_connector where start_object_id = 86607;
select * from t_connector where end_object_id = 86607;

select connector_id , name , direction, notes, connector_type, start_object_id , end_object_id , stereotype, diagramId, ea_guid from t_connector where start_object_id = 86607 --and  diagramid = 17287
;

select * from t_objectproperties where object_id = 75169;

SELECT obj.NAME , objprop.value
FROM t_object obj, t_objectproperties objprop 
WHERE 
obj.Object_ID = objprop.Object_ID
and obj.Package_ID in (select package_id  from t_package where parent_id =14230 and 
name in ( 'Acteurs','Actif Immobilier Barrage','Associations','Domaines de valeurs','Gestion des barrages','Sécurité Barrage','Organique')
)
and  objprop.property = 'Code'
ORDER BY value;

select o.name, o.Object_ID , op.value from t_diagramobjects d  , t_object o, t_objectproperties op
where d.diagram_id = 17287 and o.object_id = d.Object_ID and op.Object_ID=o.Object_ID and op.property= 'Code'
order by op.value;


select * from t_diagram where name = 'Barrages_MCD_Cible';


SELECT  objprop.value
FROM t_object obj, t_objectproperties objprop 
WHERE 
obj.Object_ID = objprop.Object_ID
and obj.Package_ID in (select package_id  from t_package where parent_id =14230 and 
name in ( 'Acteurs','Actif Immobilier Barrage','Associations','Domaines de valeurs','Gestion des barrages','Sécurité Barrage','Organique')
)
and  objprop.property = 'Code'

---------------------------------
select  op.value from t_diagramobjects d  , t_object o, t_objectproperties op
where d.diagram_id = 17561 and o.object_id = d.Object_ID and op.Object_ID=o.Object_ID and op.property= 'Code'
and not exists 
(SELECT  objprop.value
FROM t_object obj, t_objectproperties objprop 
WHERE 
obj.Object_ID = objprop.Object_ID
and obj.Package_ID in (select package_id  from t_package where parent_id =14230 and 
name in ( 'Acteurs','Actif Immobilier Barrage','Associations','Domaines de valeurs','Gestion des barrages','Sécurité Barrage','Organique')
)
and  objprop.property = 'Code'
and op.value = objprop.value );
------------------------
SELECT  objprop.value
FROM t_object obj, t_objectproperties objprop 
WHERE 
obj.Object_ID = objprop.Object_ID
and obj.Package_ID in (select package_id  from t_package where parent_id =14230 and 
name in ( 'Acteurs','Actif Immobilier Barrage','Associations','Domaines de valeurs','Gestion des barrages','Sécurité Barrage','Organique')
)
and  objprop.property = 'Code'
and not exists (select  op.value from t_diagramobjects d  , t_object o, t_objectproperties op
where d.diagram_id = 17561 and o.object_id = d.Object_ID and op.Object_ID=o.Object_ID and op.property= 'Code' and  op.value = objprop.value );


select * from t_package where name = 'GBPP Modèle conceptuel de données REP_BP et SE'; --14169

SELECT  name , objprop1.value
FROM t_object obj, t_objectproperties objprop1
WHERE 
obj.Object_ID = objprop1.Object_ID
and obj.Package_ID = 14169 
and  objprop1.property = 'Code'
and exists 
(
SELECT  objprop.value
FROM t_object obj, t_objectproperties objprop 
WHERE 
obj.Object_ID = objprop.Object_ID
and obj.Package_ID in (select package_id  from t_package where parent_id =14230 and 
name in ( 'Acteurs','Actif Immobilier Barrage','Associations','Domaines de valeurs','Gestion des barrages','Sécurité Barrage','Organique')
and  objprop.property = 'Code'  and objprop1.value = objprop.value ))


SELECT  OBJ.*, objprop.value
FROM t_object obj, t_objectproperties objprop 
WHERE 
obj.Object_ID = objprop.Object_ID
and obj.Package_ID in (select package_id  from t_package where parent_id =14230 and 
name in ( 'Acteurs','Actif Immobilier Barrage','Associations','Domaines de valeurs','Gestion des barrages','Sécurité Barrage','Organique'))
ORDER BY CreatedDate DESC
;


select * from t_package where name = 'tmp_BP_SE'; --14262
 
SELECT  obj.name , objprop.value
FROM t_object obj, t_objectproperties objprop 
WHERE 
obj.Object_ID = objprop.Object_ID
and obj.Package_ID in (select package_id  from t_package where parent_id =14230 and 
name in ( 'Acteurs','Actif Immobilier Barrage','Associations','Domaines de valeurs','Gestion des barrages','Sécurité Barrage','Organique')
and  objprop.property = 'Code'  ) 
and exists 
(
SELECT  objprop1.value
FROM t_object obj, t_objectproperties objprop1
WHERE 
obj.Object_ID = objprop1.Object_ID
and obj.Package_ID = 14262 
and  objprop1.property = 'Code'
and objprop1.value = objprop.value
);


SELECT  obj.name , objprop.value, obj.Package_ID
FROM t_object obj, t_objectproperties objprop 
WHERE 
obj.Object_ID = objprop.Object_ID
and obj.Package_ID in (select package_id  from t_package where parent_id =14230 and 
name in ( 'Acteurs','Actif Immobilier Barrage','Associations','Domaines de valeurs','Gestion des barrages','Sécurité Barrage','Organique')
and  objprop.property = 'Code'  ) 
order by value --by obj.name
;

select * from t_package where Package_ID = 14253;

SELECT  obj.name,  objprop1.value
FROM t_object obj, t_objectproperties objprop1
WHERE 
obj.Object_ID = objprop1.Object_ID
and obj.Package_ID = 14262 
and  objprop1.property = 'Code'
--and value = 'BP_CONSTITUANT_MATERIAU'
and value like 'BP_%'
ORDER BY VALUE
;

select * from t_object where Stereotype = 'Entité données' and name ='Adresse' ; 

select *  from t_attribute where Stereotype like  '%Attribut%' and  object_id = 75171;

select *  from t_attribute where Stereotype =  'Attribut' and name = 'noSeqAdresse'; --75171


select * from t_package where name = 'Import_MCD_STH_v2'; --12512

SELECT  obj.name,  objprop1.value
FROM t_object obj, t_objectproperties objprop1
WHERE 
obj.Object_ID = objprop1.Object_ID
and obj.object_id =75171
ORDER BY VALUE
;

select * from t_package where name = 'Gestion des barrages'; --14239

select * from t_object where package_id = 14239 and name = 'DebitEntrant';

select * from t_attribute where object_id = 86559
;
select * from t_attributetag where elementid = 41366;


select Object_ID, name , Stereotype, id  from t_attribute where Stereotype =  'Attribut' and name = 'adresse'; --86971 ---ID = 42879
select * from t_attributetag where elementid in
(select id  from t_attribute where Stereotype =  'Attribut' and name = 'adresse');

select * from t_package where name = 'GBPP Modèle conceptuel de données REP_BP et SE'; --14169;

SELECT  OBJ.NAME , objprop1.value , obj.Stereotype, obj.note
FROM t_object obj, t_objectproperties objprop1
WHERE 
obj.Object_ID = objprop1.Object_ID
and obj.Package_ID = 14169 
and  objprop1.property = 'Code'
AND VALUE LIKE 'SE_%'
ORDER BY NAME 
;
-------------------


SELECT  OBJ.NAME , objprop1.value , obj.Stereotype, obj.note
FROM t_object obj, t_objectproperties objprop1
WHERE 
obj.Object_ID = objprop1.Object_ID
and obj.Package_ID IN (
select DISTINCT Package_ID from t_package where name 
IN('Acteurs','Actif Immobilier Barrage','Associations','Domaines de valeurs','Gestion des barrages','Sécurité Barrage','Organique')
AND PARENT_ID = (select DISTINCT Package_ID from t_package where name  IN('09 Barrages')
)
)
and  objprop1.property = 'Code'
--AND VALUE LIKE 'SE_%'
ORDER BY NAME 
;

SELECT  OBJ.NAME , objprop1.value --, obj.Stereotype, obj.note
FROM t_object obj, t_objectproperties objprop1
WHERE 
obj.Object_ID = objprop1.Object_ID
and obj.Package_ID IN (
select DISTINCT Package_ID from t_package where name 
IN('Acteurs','Actif Immobilier Barrage','Associations','Domaines de valeurs','Gestion des barrages','Sécurité Barrage','Organique')
AND PARENT_ID = (select DISTINCT Package_ID from t_package where name  IN('09 Barrages')
)
)
and  objprop1.property = 'Code'
--AND VALUE LIKE 'SE_%'
ORDER BY NAME 
;

--List of object in a package 
SELECT  OBJ.NAME , objprop1.value --, obj.Stereotype, obj.note
FROM t_object obj, t_objectproperties objprop1
WHERE 
obj.Object_ID = objprop1.Object_ID
and obj.Package_ID IN (
select DISTINCT Package_ID from t_package where name IN(
'Acteurs',
'Actif Immobilier Barrage',
'Associations',
'Domaines de valeurs',
'Gestion des barrages',
'Sécurité Barrage',
'Organique')
AND PARENT_ID = (select DISTINCT Package_ID from t_package where name  IN('09 Barrages')
)
)
and  objprop1.property = 'Code'
AND VALUE LIKE 'GB_%'
ORDER BY NAME ;

SELECT DATABASEPROPERTYEX('SPARXSYSTEM', 'Collation');



--List of objects in a diagram 
SELECT o.name, 
op.value,-- o.note,
replace(replace(replace(replace(replace(o.note, '&#233;', 'é'),'&#224;','a') ,'&#226','a'),'&#232;','e'),'&#234','e') note
--o.note  Latin1_General_100_BIN2, 
--cast(cast(o.note AS varchar(1000)) AS varchar(1000) ) Latin1_General_100_CI_AS
from t_diagramobjects DO,  t_diagram D, t_object o, t_objectproperties op
WHERE DO.diagram_id = D.diagram_id
and do.object_id = o.object_id 
and o.Object_ID = op.Object_ID
and d.name = 'Gestion des Barrages_MCD_cible'
and op.Property = 'Code'
--and op.value LIKE 'GB_%'
ORDER BY o.name, op.value
;

SELECT 'résumé' COLLATE Latin1_General_CI_AS , 'resume' COLLATE Latin1_General_CI_AS; -- Returns 0 (False)
SELECT 'résumé' COLLATE Latin1_General_CI_AI , 'resume' COLLATE Latin1_General_CI_AI; -- Returns 1 (True)


--List of links in a diagram

select * from t_diagram where name = 'Gestion des Barrages_MCD_cible'; -- diagram_id = 17287
select * from t_diagramobjects where diagram_id = 17561 and object_id =86607;
select * from t_diagramlinks where diagramid = 17287;

select * from t_connector where start_object_id = 86607;
select * from t_connector where end_object_id = 86607;
select distinct connector_type from t_connector order by connector_type;
--select distinct object_type  from t_object order by object_type;

select * from t_connector ;

select c.name, c.Stereotype, c.Notes from t_diagramlinks dl, t_connector c   
where dl.diagramid = 17287 and dl.ConnectorID = c.Connector_ID  and c.name = 'gerePar' order by name;

 -- Start or end objects of a link
select connector_id , name , direction, notes, connector_type, start_object_id , end_object_id , stereotype, diagramId, ea_guid 
from t_connector where start_object_id = 86607 --and  diagramid = 17287
;

--List of object in a package and not in a diagram

SELECT  OBJ.NAME , objprop1.value , p.name--, obj.Stereotype, obj.note
FROM t_object obj, t_objectproperties objprop1, t_package p
WHERE 
obj.Object_ID = objprop1.Object_ID
and obj.Package_ID = p.Package_ID
and obj.Package_ID IN (
select DISTINCT Package_ID from t_package where name 
IN(
'Acteurs',
'Actif Immobilier Barrage',
'Associations',
'Domaines de valeurs',
'Gestion des barrages',
--'Sécurité Barrage',
'Organique')
AND PARENT_ID = (select DISTINCT Package_ID from t_package where name  IN('09 Barrages')
)
)
and  objprop1.property = 'Code'
AND VALUE LIKE 'GB_%'
and not exists 
(
SELECT o.name, op.value from t_diagramobjects DO,  t_diagram D, t_object o, t_objectproperties op
WHERE DO.diagram_id = D.diagram_id
and do.object_id = o.object_id 
and o.Object_ID = op.Object_ID
and d.name = 'Gestion des Barrages_MCD_cible'
and op.Property = 'Code'
and op.value LIKE 'GB_%'
and o.object_id = obj.object_id
)
;

--Liste des entites REP-SE
SELECT  OBJ.NAME , objprop1.value , p.name--, obj.Stereotype, obj.note
FROM t_object obj, t_objectproperties objprop1, t_package p
WHERE 
obj.Object_ID = objprop1.Object_ID
and obj.Package_ID = p.Package_ID
and obj.Package_ID IN (
select DISTINCT Package_ID from t_package where name 
IN(
'Acteurs',
'Actif Immobilier Barrage',
'Associations',
'Domaines de valeurs',
--'Gestion des barrages',
'Sécurité Barrage',
'Organique')
AND PARENT_ID = (select DISTINCT Package_ID from t_package where name  IN('09 Barrages')
)
)
and  objprop1.property = 'Code'
AND VALUE LIKE 'BP_%'
order by p.name,obj.name
;


--List of object in a package and not in a diagram BP

SELECT  OBJ.NAME , objprop1.value , p.name--, obj.Stereotype, obj.note
FROM t_object obj, t_objectproperties objprop1, t_package p
WHERE 
obj.Object_ID = objprop1.Object_ID
and obj.Package_ID = p.Package_ID
and obj.Package_ID IN (
select DISTINCT Package_ID from t_package where name 
IN(
'Acteurs',
'Actif Immobilier Barrage',
'Associations',
'Domaines de valeurs',
'Gestion des barrages',
'Sécurité Barrage',
'Organique')
AND PARENT_ID = (select DISTINCT Package_ID from t_package where name  IN('09 Barrages')
)
)
and  objprop1.property = 'Code'
AND VALUE LIKE 'BP_%'
and not exists 
(
SELECT o.name, op.value from t_diagramobjects DO,  t_diagram D, t_object o, t_objectproperties op
WHERE DO.diagram_id = D.diagram_id
and do.object_id = o.object_id 
and o.Object_ID = op.Object_ID
and d.name = 'REP MCD_Cible'
and op.Property = 'Code'
and op.value LIKE 'BP_%'
and o.object_id = obj.object_id
)
;

--Liste des entites REP-SE
SELECT  OBJ.NAME ,
objprop1.value , p.name--, obj.Stereotype, obj.note
FROM t_object obj, t_objectproperties objprop1, t_package p
WHERE 
obj.Object_ID = objprop1.Object_ID
and obj.Package_ID = p.Package_ID
and obj.Package_ID IN (
select DISTINCT Package_ID from t_package where name 
IN(
'Acteurs',
'Actif Immobilier Barrage',
'Associations',
'Domaines de valeurs',
'Gestion des barrages',
'Sécurité Barrage',
'Organique')
AND PARENT_ID = (select DISTINCT Package_ID from t_package where name  IN('09 Barrages')
)
)
and  objprop1.property = 'Code'
AND VALUE LIKE 'BP_%'
order by objprop1.value,p.name,obj.name
;

--Lit of object in a diagram
SELECT o.name, op.value from t_diagramobjects DO,  t_diagram D, t_object o, t_objectproperties op
WHERE DO.diagram_id = D.diagram_id
and do.object_id = o.object_id 
and o.Object_ID = op.Object_ID
and d.name = 'REP MCD_Cible'
and op.Property = 'Code'
--and op.value LIKE 'BP_%'
order by o.name
;
--------

select * from t_connector where start_object_id = 86607;
select * from t_connector where end_object_id = 86607;
select distinct connector_type from t_connector order by connector_type;
--select distinct object_type  from t_object order by object_type;

select * from t_connector ;

select c.name, c.Stereotype, c.Notes from t_diagramlinks dl, t_connector c   
where dl.diagramid = 17287 and dl.ConnectorID = c.Connector_ID  and c.name = 'gerePar' order by name;

 -- Start or end objects of a link
select connector_id , name , direction, notes, connector_type, start_object_id , end_object_id , stereotype, diagramId, ea_guid 
from t_connector where start_object_id = 86607 --and  diagramid = 17287
;

select * from t_package where name = 'Actif Immobilier Barrage'; --14231

SELECT * FROM t_object where name = 'Barrage' and package_id = 14231; --86545


select * from t_diagram where name = 'REP MCD_Cible'; --18982
select * from t_connector where   diagramid = 18982; --??????



select c.name, c.Stereotype, c.Notes from t_diagramlinks dl, t_connector c, t_diagram d   
where dl.diagramid = d.diagram_id  and dl.ConnectorID = c.Connector_ID  and d.name = 'REP MCD_Cible' order by name;




--List of object in a diagram linked to other objects ex barrage start and end objects
select o.name,  op.value, o.Stereotype,
--c.connector_id , 
c.name , 
--c.direction, 
c.notes, 
c.connector_type, 
--c.start_object_id , c.end_object_id , 
c.stereotype, --c.diagramId, c.ea_guid 
c.SubType, c.SourceCard, c.DestCard
from t_connector c  , t_object o, t_diagramlinks dl,t_diagram d,t_objectproperties op
where (
(c.end_object_id = o.object_id and c.start_object_id = 86545 ) 
or
( c.start_object_id = o.object_id and c.end_object_id = 86545)
)
-- Barrage
and dl.diagramid = d.diagram_id  and dl.ConnectorID = c.Connector_ID  and d.name = 'REP-Repertoire des barrages MCD_Cible'
and o.Object_ID = op.Object_ID
and op.Property = 'Code'
order by op.value
;

--Association Class ?
select * from t_connector c where c.connector_type = 'Association' and c.SubType = 'Class' and name is not null;



SELECT o.name, op.value from t_diagramobjects DO,  t_diagram D, t_object o, t_objectproperties op
WHERE DO.diagram_id = D.diagram_id
and do.object_id = o.object_id 
and o.Object_ID = op.Object_ID
and d.name = 'REP MCD_Cible'
and op.Property = 'Code'
--and op.value LIKE 'BP_%'
order by o.name;


SELECT  OBJ.NAME , objprop1.value , p.name As Package_Name--, obj.Stereotype, obj.note
FROM t_object obj, t_objectproperties objprop1, t_package p
WHERE 
obj.Object_ID = objprop1.Object_ID
and obj.Package_ID = p.Package_ID
and obj.Package_ID IN (
select DISTINCT Package_ID from t_package where name 
IN(
'Acteurs',
'Actif Immobilier Barrage',
'Associations',
'Domaines de valeurs',
'Gestion des barrages',
'Sécurité Barrage',
'Organique')
AND PARENT_ID = (select DISTINCT Package_ID from t_package where name  IN('09 Barrages')))
and objprop1.value like 'SE_%'
ORDER BY objprop1.value
;


select * from t_diagram where name = 'SEBP MCD_cible';

select c.name, c.Stereotype, c.Notes from t_diagramlinks dl, t_connector c   
where dl.diagramid = 18983 and dl.ConnectorID = c.Connector_ID  and upper(c.notes) like '%SE_ETAT_COMPOSANTE%'
order by name;



SELECT  OBJ.NAME , objprop1.value , p.name As Package_Name--, obj.Stereotype, obj.note
FROM t_object obj, t_objectproperties objprop1, t_package p
WHERE 
obj.Object_ID = objprop1.Object_ID
and obj.Package_ID = p.Package_ID
and obj.Package_ID IN (
select DISTINCT Package_ID from t_package where name 
IN(
'Acteurs',
'Actif Immobilier Barrage',
'Associations',
'Domaines de valeurs',
'Gestion des barrages',
'Sécurité Barrage',
'Organique')
AND PARENT_ID = (select DISTINCT Package_ID from t_package where name  IN('09 Barrages')))
and objprop1.value like 'SE_%'
ORDER BY objprop1.value
;

SELECT * FROM T_PACKAGE WHERE NAME = 'Catalogue des entités de données';

--NIV 3
select Package_id , name , parent_id 
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données'));

--NIV 2
select Package_id , name , parent_id 
from t_package 
where parent_id in 
(SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données');

--Niv 1
SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données';

--OBJECT NIV2	

SELECT NIV2.NAME,OBJ.NAME , OBJ.NOTE, OBJ.Stereotype  FROM T_OBJECT OBJ ,
(select Package_id , name , parent_id 
from t_package 
where parent_id in 
(SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données')) NIV2
WHERE NIV2.PACKAGE_ID = OBJ.PACKAGE_ID;


--Liste des objets cible par systeme et package
SELECT 
NIV3.NAME Package_Name,OBJ.NAME Object_Name , 
--OBJ.NOTE, 
replace(replace(replace(replace(replace(OBJ.note, '&#233;', 'é'),'&#224;','a') ,'&#226','a'),'&#232;','e'),'&#234','e') note ,
objprop1.value  Table_Name--,
--OBJ.Stereotype  
FROM T_OBJECT OBJ , t_objectproperties objprop1 ,
(
select Package_id , name , parent_id 
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données'))
)NIV3
 WHERE NIV3.PACKAGE_ID = OBJ.PACKAGE_ID
AND obj.Object_ID = objprop1.Object_ID
AND NIV3.NAME NOT IN ('tmp_BP_SE','tmp_GBP','tmp_BC' ,'Associations')
--and value like 'GB_%'
AND objprop1.value  LIKE '%TRAIT%'
order by NIV3.NAME, objprop1.value
;

SELECT 
NIV3.NAME Package_Name,OBJ.NAME Object_Name , 
--OBJ.NOTE, 
replace(replace(replace(replace(replace(OBJ.note, '&#233;', 'é'),'&#224;','a') ,'&#226','a'),'&#232;','e'),'&#234','e') note ,
objprop1.value  Table_Name--
--OBJ.Stereotype  
FROM T_OBJECT OBJ , t_objectproperties objprop1 ,
(
select Package_id , name , parent_id 
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données'))
)NIV3
 WHERE NIV3.PACKAGE_ID = OBJ.PACKAGE_ID
AND obj.Object_ID = objprop1.Object_ID
AND NIV3.NAME NOT IN ('tmp_BP_SE','tmp_GBP','tmp_BC' )
--and value like 'GB_%'
AND  EXISTS(
SELECT 
1
FROM T_OBJECT OBJ2 , t_objectproperties objprop2 ,
(
select Package_id , name , parent_id 
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données'))
)NIV3
 WHERE NIV3.PACKAGE_ID = OBJ2.PACKAGE_ID
AND obj2.Object_ID = objprop2.Object_ID
AND NIV3.NAME  IN ('tmp_BC' )
and objprop1.value = objprop2.value
) ;


SELECT 
NIV3.NAME Package_Name,OBJ.NAME Object_Name , 
--OBJ.NOTE, 
replace(replace(replace(replace(replace(OBJ.note, '&#233;', 'é'),'&#224;','a') ,'&#226;','a'),'&#232;','e'),'&#234','e') note ,
objprop1.value  Table_Name--
--OBJ.Stereotype  
FROM T_OBJECT OBJ , t_objectproperties objprop1 ,
(
select Package_id , name , parent_id 
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données'))
)NIV3
 WHERE NIV3.PACKAGE_ID = OBJ.PACKAGE_ID
AND obj.Object_ID = objprop1.Object_ID
AND NIV3.NAME not like 'tmp_%'-- ('tmp_BC' )
ORDER BY objprop1.value
;

SELECT 
NIV3.NAME Package_Name,OBJ.NAME Object_Name , 
--OBJ.NOTE, 
replace(replace(replace(replace(replace(OBJ.note, '&#233;', 'é'),'&#224;','a') ,'&#226','a'),'&#232;','e'),'&#234','e') note ,
objprop1.value  Table_Name--
--OBJ.Stereotype  
FROM T_OBJECT OBJ , t_objectproperties objprop1 ,
(
select Package_id , name , parent_id 
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données'))
)NIV3
 WHERE NIV3.PACKAGE_ID = OBJ.PACKAGE_ID
AND obj.Object_ID = objprop1.Object_ID
AND NIV3.NAME NOT IN ('tmp_BP_SE','tmp_GBP','tmp_BC' )
--and value like 'GB_%'
order by OBJ.NAME;

SELECT 
NIV3.NAME Package_Name,OBJ.NAME Object_Name , 
--OBJ.NOTE, 
replace(replace(replace(replace(replace(OBJ.note, '&#233;', 'é'),'&#224;','a') ,'&#226','a'),'&#232;','e'),'&#234','e') note ,
objprop1.value  Table_Name--
--OBJ.Stereotype  
FROM T_OBJECT OBJ , t_objectproperties objprop1 ,
(
select Package_id , name , parent_id 
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données'))
)NIV3
 WHERE NIV3.PACKAGE_ID = OBJ.PACKAGE_ID
AND obj.Object_ID = objprop1.Object_ID
AND NIV3.NAME  IN ('Commun' )
--and value like 'GB_%'
order by OBJ.NAME ;

select * from t_package where name = 'Commun';

select * from t_package where package_id in (14258,14233);
-------

--Liste des entites BC Source

SELECT  OBJ.NAME ,
objprop1.value , p.name--, obj.Stereotype, obj.note
FROM t_object obj, t_objectproperties objprop1, t_package p
WHERE 
obj.Object_ID = objprop1.Object_ID
and obj.Package_ID = p.Package_ID
and obj.Package_ID IN (
select DISTINCT Package_ID from t_package where name 
IN(
'tmp_BC')
AND PARENT_ID = (select DISTINCT Package_ID from t_package where name  IN('09 Barrages')
)
)
and  objprop1.property = 'Code'
AND VALUE LIKE 'BC_%'
order by objprop1.value,p.name,obj.name;


---List of object to be validated by client and Information Object
SELECT 
NIV3.NAME Package_Name,OBJ.NAME Entity_Name , objprop1.value  Table_Name,
--OBJ.NOTE, 
replace(replace(replace(replace(replace(replace(OBJ.note, '&#233;', 'é'),'&#224;','a') ,'&#226;','a'),'&#232;','e'),'&#234;','e'), '&#201;','e') Note 
--
--OBJ.Stereotype  
FROM T_OBJECT OBJ , t_objectproperties objprop1 ,
(
select Package_id , name , parent_id 
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données'))
)NIV3
 WHERE NIV3.PACKAGE_ID = OBJ.PACKAGE_ID
AND obj.Object_ID = objprop1.Object_ID
AND NIV3.NAME NOT IN ('tmp_BP_SE','tmp_GBP','tmp_BC','Associations' )
--and value like 'BC_%'
order by NIV3.NAME, OBJ.NAME;

select * from t_object;

SELECT obj.object_id, obj.name, (select name from  t_package pkg where pkg.Package_ID = obj.Package_ID  and pkg.name = 'Actif Immobilier Barrage' )
FROM T_OBJECT obj WHERE NAME = 'Barrage';

SELECT obj.object_id 
FROM T_OBJECT obj WHERE obj.NAME = 'Barrage'
and  obj.package_id = (select  pkg.Package_ID pkg from t_package pkg where pkg.Package_ID = obj.Package_ID  and pkg.name = 'Actif Immobilier Barrage' );


--List of object in a diagram linked to other objects ex barrage start and end objects
select o.name,  op.value, o.Stereotype,
--c.connector_id , 
c.name , 
--c.direction, 
c.notes, 
c.connector_type, 
--c.start_object_id , c.end_object_id , 
c.stereotype, --c.diagramId, c.ea_guid 
c.SubType, c.SourceCard, c.DestCard, d.diagram_id
from t_connector c  , t_object o, t_diagramlinks dl,t_diagram d,t_objectproperties op
where (
(c.end_object_id = o.object_id and c.start_object_id = (SELECT obj.object_id 
FROM T_OBJECT obj WHERE obj.NAME = 'Barrage'
and  obj.package_id = (select  pkg.Package_ID pkg from t_package pkg where pkg.Package_ID = obj.Package_ID  and pkg.name = 'Actif Immobilier Barrage' )) ) 
or
( c.start_object_id = o.object_id and c.end_object_id =(SELECT obj.object_id 
FROM T_OBJECT obj WHERE obj.NAME = 'Barrage'
and  obj.package_id = (select  pkg.Package_ID pkg from t_package pkg where pkg.Package_ID = obj.Package_ID  and pkg.name = 'Actif Immobilier Barrage' )))
)
-- Barrage
and dl.diagramid = d.diagram_id  and dl.ConnectorID = c.Connector_ID  and d.name = 'REP-Repertoire des barrages MCD_Cible'
and o.Object_ID = op.Object_ID
and op.Property = 'Code'
order by op.value
;

select * from t_diagram where diagram_id =18982;

--List of object in a diagram linked to other objects ex barrage start and end objects
select 'Starting' as START_STOP , o.name,  op.value, o.Stereotype,
--c.connector_id , 
c.name , 
--c.direction, 
c.notes, 
c.connector_type, 
--c.start_object_id , c.end_object_id , 
c.stereotype, --c.diagramId, c.ea_guid 
c.SubType, c.SourceCard, c.DestCard
from t_connector c  , t_object o, t_diagramlinks dl,t_diagram d,t_objectproperties op
where (
(c.end_object_id = o.object_id and c.start_object_id = (SELECT obj.object_id 
FROM T_OBJECT obj WHERE obj.NAME = 'Barrage'
and  obj.package_id = (select  pkg.Package_ID pkg from t_package pkg where pkg.Package_ID = obj.Package_ID  and pkg.name = 'Actif Immobilier Barrage' )) ) 
)
-- Barrage
and dl.diagramid = d.diagram_id  and dl.ConnectorID = c.Connector_ID  and d.name IN( 'REP-Repertoire des barrages MCD_Cible', 'BC-Station Poste et instrument_MCD_Cible','GBP-Gestion des Barrages_MCD_cible','SEBP- Securite et entretien des barrages_MCD_cible')
and o.Object_ID = op.Object_ID
and op.Property = 'Code'
--order by op.value
union all
--List of object in a diagram linked to other objects ex barrage start and end objects
select  'Ending' as START_STOP, o.name,  op.value, o.Stereotype,
--c.connector_id , 
c.name , 
--c.direction, 
c.notes, 
c.connector_type, 
--c.start_object_id , c.end_object_id , 
c.stereotype, --c.diagramId, c.ea_guid 
c.SubType, c.SourceCard, c.DestCard
from t_connector c  , t_object o, t_diagramlinks dl,t_diagram d,t_objectproperties op
where (
( c.start_object_id = o.object_id and c.end_object_id =(SELECT obj.object_id 
FROM T_OBJECT obj WHERE obj.NAME = 'Barrage'
and  obj.package_id = (select  pkg.Package_ID pkg from t_package pkg where pkg.Package_ID = obj.Package_ID  and pkg.name = 'Actif Immobilier Barrage' )))
)
-- Barrage
and dl.diagramid = d.diagram_id  and dl.ConnectorID = c.Connector_ID  and d.name IN( 'REP-Repertoire des barrages MCD_Cible', 'BC-Station Poste et instrument_MCD_Cible','GBP-Gestion des Barrages_MCD_cible','SEBP- Securite et entretien des barrages_MCD_cible')
and o.Object_ID = op.Object_ID
and op.Property = 'Code'
;
;

select  op.value,
O.name
from t_connector c  , t_object o, t_diagramlinks dl,t_diagram d,t_objectproperties op
where (
(c.end_object_id = o.object_id and c.start_object_id = (
SELECT obj.object_id 
FROM T_OBJECT obj WHERE obj.NAME = 'Barrage'
and  obj.package_id IN  (select Package_id
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données')) AND  NAME NOT IN ('tmp_BP_SE','tmp_GBP','tmp_BC') )
)
) 
)
-- Barrage
and dl.diagramid = d.diagram_id  
and dl.ConnectorID = c.Connector_ID 
and d.name IN( 'REP-Repertoire des barrages MCD_Cible', 'BC-Station Poste et instrument_MCD_Cible','GBP-Gestion des Barrages_MCD_cible','SEBP- Securite et entretien des barrages_MCD_cible')
and o.Object_ID = op.Object_ID
and op.Property = 'Code'
order by op.value;



select  op.value,
O.name
from t_connector c  , t_object o, t_diagramlinks dl,t_diagram d,t_objectproperties op
where (
(c.start_object_id = o.object_id and c.end_object_id = (
SELECT obj.object_id 
FROM T_OBJECT obj WHERE obj.NAME = 'Barrage'
and  obj.package_id IN  (select Package_id
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données')) AND  NAME NOT IN ('tmp_BP_SE','tmp_GBP','tmp_BC') )
)
) 
)
-- Barrage
and dl.diagramid = d.diagram_id  
and dl.ConnectorID = c.Connector_ID 
and d.name IN( 'REP-Repertoire des barrages MCD_Cible', 'BC-Station Poste et instrument_MCD_Cible','GBP-Gestion des Barrages_MCD_cible','SEBP- Securite et entretien des barrages_MCD_cible')
and o.Object_ID = op.Object_ID
and op.Property = 'Code'
order by op.value;




select Package_id , name , parent_id 
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données'))
AND  NAME NOT IN ('tmp_BP_SE','tmp_GBP','tmp_BC' );
-------------------

select 'Starting' as Dir_Type,  op.value,
O.name
from t_connector c  , t_object o, t_diagramlinks dl,t_diagram d,t_objectproperties op
where (
(c.start_object_id = o.object_id and c.end_object_id = (
SELECT obj.object_id 
FROM T_OBJECT obj WHERE obj.NAME = 'SectionSebp'
and  obj.package_id IN  (select Package_id
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données')) AND  NAME NOT IN ('tmp_BP_SE','tmp_GBP','tmp_BC') )
)
) 
)
-- Barrage
and dl.diagramid = d.diagram_id  
and dl.ConnectorID = c.Connector_ID 
and d.name IN( 'REP-Repertoire des barrages MCD_Cible', 'BC-Station Poste et instrument_MCD_Cible','GBP-Gestion des Barrages_MCD_cible','SEBP- Securite et entretien des barrages_MCD_cible')
and o.Object_ID = op.Object_ID
and op.Property = 'Code'
--order by op.value
UNION ALL
select  'Ending' as Dir_Type,   op.value,
O.name
from t_connector c  , t_object o, t_diagramlinks dl,t_diagram d,t_objectproperties op
where (
(c.start_object_id = o.object_id and c.end_object_id = (
SELECT obj.object_id 
FROM T_OBJECT obj WHERE obj.NAME = 'SectionSebp'
and  obj.package_id IN  (select Package_id
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données')) AND  NAME NOT IN ('tmp_BP_SE','tmp_GBP','tmp_BC') )
)
) 
)
-- Barrage
and dl.diagramid = d.diagram_id  
and dl.ConnectorID = c.Connector_ID 
and d.name IN( 'REP-Repertoire des barrages MCD_Cible', 'BC-Station Poste et instrument_MCD_Cible','GBP-Gestion des Barrages_MCD_cible','SEBP- Securite et entretien des barrages_MCD_cible')
and o.Object_ID = op.Object_ID
and op.Property = 'Code'
--order by op.value
;


--List of object in a package and not in a diagram BP

SELECT  OBJ.NAME , objprop1.value , p.name--, obj.Stereotype, obj.note
FROM t_object obj, t_objectproperties objprop1, t_package p
WHERE 
obj.Object_ID = objprop1.Object_ID
and obj.Package_ID = p.Package_ID
and obj.Package_ID IN (
select DISTINCT Package_ID from t_package where name 
IN(
'Acteurs',
'Actif Immobilier Barrage',
'Associations',
'Domaines de valeurs',
'Gestion des barrages',
'Sécurité Barrage',
'Organique')
AND PARENT_ID = (select DISTINCT Package_ID from t_package where name  IN('09 Barrages')
)
)
and  objprop1.property = 'Code'
AND VALUE LIKE 'GB_%'
and not exists 
(
SELECT o.name, op.value from t_diagramobjects DO,  t_diagram D, t_object o, t_objectproperties op
WHERE DO.diagram_id = D.diagram_id
and do.object_id = o.object_id 
and o.Object_ID = op.Object_ID
and d.name = 'GBP-Gestion des Barrages_MCD_cible'
and op.Property = 'Code'
and op.value LIKE 'GB_%'
and o.object_id = obj.object_id
)
;

---------------------------
select  distinct dir_type , value , name  from 
(
select 'Starting' as Dir_Type,  op.value,
O.name
from t_connector c  , t_object o, t_diagramlinks dl,t_diagram d,t_objectproperties op
where (
(c.start_object_id = o.object_id and c.end_object_id in (
SELECT obj.object_id 
FROM T_OBJECT obj WHERE 
--obj.NAME = 'SectionSebp'
--and  
obj.package_id IN  (select Package_id
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données')) AND  NAME NOT IN ('tmp_BP_SE','tmp_GBP','tmp_BC') )
)
) 
)
-- Barrage
and dl.diagramid = d.diagram_id  
and dl.ConnectorID = c.Connector_ID 
and d.name IN( 
--'REP-Repertoire des barrages MCD_Cible', 
--'BC-Station Poste et instrument_MCD_Cible',
'GBP-Gestion des Barrages_MCD_cible'--,
--'SEBP- Securite et entretien des barrages_MCD_cible'
)
and o.Object_ID = op.Object_ID
and op.Property = 'Code'
--order by op.value
UNION ALL
select  'Ending' as Dir_Type,   op.value,
O.name
from t_connector c  , t_object o, t_diagramlinks dl,t_diagram d,t_objectproperties op
where (
(c.start_object_id = o.object_id and c.end_object_id in (
SELECT obj.object_id 
FROM T_OBJECT obj WHERE 
--obj.NAME = 'SectionSebp'
--and  
obj.package_id IN  (select Package_id
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données')) AND  NAME NOT IN ('tmp_BP_SE','tmp_GBP','tmp_BC') )
)
) 
)
-- Barrage
and dl.diagramid = d.diagram_id  
and dl.ConnectorID = c.Connector_ID 
and d.name IN( 
--'REP-Repertoire des barrages MCD_Cible', 
--'BC-Station Poste et instrument_MCD_Cible',
'GBP-Gestion des Barrages_MCD_cible'--,
--'SEBP- Securite et entretien des barrages_MCD_cible'
)
and o.Object_ID = op.Object_ID
and op.Property = 'Code'
--order by op.value
) V
where V.value like 'GB_%'
;----------------------------

select 'Starting' as Dir_Type,  op.value,
O.name
from t_connector c  , t_object o, t_diagramlinks dl,t_diagram d,t_objectproperties op
where (
(c.start_object_id = o.object_id and c.end_object_id = (
SELECT obj.object_id 
FROM T_OBJECT obj WHERE obj.NAME = 'SectionSebp'
and  obj.package_id IN  (select Package_id
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données')) AND  NAME NOT IN ('tmp_BP_SE','tmp_GBP','tmp_BC') )
)
) 
)
-- Barrage
and dl.diagramid = d.diagram_id  
and dl.ConnectorID = c.Connector_ID 
and d.name IN( 'REP-Repertoire des barrages MCD_Cible', 'BC-Station Poste et instrument_MCD_Cible','GBP-Gestion des Barrages_MCD_cible','SEBP- Securite et entretien des barrages_MCD_cible')
and o.Object_ID = op.Object_ID
and op.Property = 'Code'
--order by op.value;



SELECT obj.object_id, obj.name  
FROM T_OBJECT obj WHERE 
--obj.NAME = 'SectionSebp'
--and  
obj.package_id IN  (select Package_id
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données')) AND  NAME NOT IN ('tmp_BP_SE','tmp_GBP','tmp_BC') )


select d.diagram_id  from t_diagram d
where d.name IN( 'REP-Repertoire des barrages MCD_Cible', 'BC-Station Poste et instrument_MCD_Cible','GBP-Gestion des Barrages_MCD_cible','SEBP- Securite et entretien des barrages_MCD_cible');


-- To be confirmed!!!!
select 
os.value as start_val,
os.name as start_name,
c.SourceCard, c.DestCard, c.Start_Object_ID, c.End_Object_ID,
od.value as dest_val,
od.name as dest_name, d.name
from 
t_connector c , 
t_diagramlinks dl ,
(SELECT obj.object_id, obj.name  as name,op.value
FROM T_OBJECT obj , t_objectproperties op
WHERE 
--obj.NAME = 'SectionSebp'
--and  
obj.Object_ID = op.Object_ID
and  
op.Property = 'Code'
and 
obj.package_id IN  (select Package_id
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données')) AND  NAME NOT IN ('tmp_BP_SE','tmp_GBP','tmp_BC') )
) os,

(SELECT obj.object_id, obj.name  as name,op.value
FROM T_OBJECT obj , t_objectproperties op
WHERE 
--obj.NAME = 'SectionSebp'
--and  
obj.Object_ID = op.Object_ID
and  
op.Property = 'Code'
and 
obj.package_id IN  (select Package_id
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données')) AND  NAME NOT IN ('tmp_BP_SE','tmp_GBP','tmp_BC') )
) od
,
(
select d.diagram_id , d.name from t_diagram d
where d.name IN( 'REP-Repertoire des barrages MCD_Cible', 'BC-Station Poste et instrument_MCD_Cible','GBP-Gestion des Barrages_MCD_cible','SEBP- Securite et entretien des barrages_MCD_cible') ) d
where 
 dl.diagramid = d.diagram_id  
and dl.ConnectorID = c.Connector_ID 
and os.object_id = c.start_object_id
and od.object_id = c.end_object_id
order by d.name,os.value 
;

------------------------
select * from t_connector;
select * from t_diagramlinks;


SELECT obj.object_id, obj.name  as name,op.value
FROM T_OBJECT obj , t_objectproperties op
WHERE 
--obj.NAME = 'SectionSebp'
--and  
obj.Object_ID = op.Object_ID
and  
op.Property = 'Code'
and 
obj.package_id IN  (select Package_id
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données')) AND  NAME NOT IN ('tmp_BP_SE','tmp_GBP','tmp_BC') )
ORDER BY op.value;


-----------------------


select 
os.value as start_val,
os.name as start_name,
c.SourceCard, c.DestCard, c.Start_Object_ID, c.End_Object_ID,
--od.value as dest_val,od.name as dest_name, 
d.name
from 
t_connector c , 
t_diagramlinks dl ,
(SELECT obj.object_id, obj.name  as name,op.value
FROM T_OBJECT obj , t_objectproperties op
WHERE 
--obj.NAME = 'SectionSebp'
--and  
obj.Object_ID = op.Object_ID
and  
op.Property = 'Code'
and 
obj.package_id IN  (select Package_id
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données')) AND  NAME NOT IN ('tmp_BP_SE','tmp_GBP','tmp_BC') )
) os --,
/*
(SELECT obj.object_id, obj.name  as name,op.value
FROM T_OBJECT obj , t_objectproperties op
WHERE 
--obj.NAME = 'SectionSebp'
--and  
obj.Object_ID = op.Object_ID
and  
op.Property = 'Code'
and 
obj.package_id IN  (select Package_id
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données')) AND  NAME NOT IN ('tmp_BP_SE','tmp_GBP','tmp_BC') )
) od */
,
(
select d.diagram_id , d.name from t_diagram d
where d.name IN( 'SPHAIR','') ) d 
where 
 dl.diagramid = d.diagram_id  
and dl.ConnectorID = c.Connector_ID 
and os.object_id = c.start_object_id
--and od.object_id = c.end_object_id
order by d.name,os.value 
;


select * from t_diagramlinks;
select * from t_diagramobjects;
select * from t_connector;


--------------------------
--Association per diagram validated

select distinct
os.value as start_val,
os.name as start_name,
c.SourceCard, c.DestCard, c.Start_Object_ID, c.End_Object_ID,c.Name,
od.value as dest_val,od.name as dest_name, 
d.name
from 
t_connector c , 
t_diagramlinks dl ,
(SELECT obj.object_id, obj.name  as name,op.value
FROM T_OBJECT obj , t_objectproperties op
WHERE 
--obj.NAME = 'SectionSebp'
--and  
obj.Object_ID = op.Object_ID
and  
op.Property = 'Code'
and 
obj.package_id IN  (select Package_id
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données')) AND  NAME NOT IN ('tmp_BP_SE','tmp_GBP','tmp_BC') )
) os ,

(SELECT obj.object_id, obj.name  as name,op.value
FROM T_OBJECT obj , t_objectproperties op
WHERE 
--obj.NAME = 'SectionSebp'
--and  
obj.Object_ID = op.Object_ID
and  
op.Property = 'Code'
and 
obj.package_id IN  (select Package_id
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données')) 
AND  NAME NOT IN ('tmp_BP_SE','tmp_GBP','tmp_BC') )
) od 
,
(
select d.diagram_id , d.name from t_diagram d
where d.name IN( 
'F00 - REP_Repertoire des barrages - Global'--, 
--'BC-Station Poste et instrument_Cible',
--'SPHAIR'--,
--'SEBP- Securite et entretien des barrages_cible'
) 
) d 
where 
 dl.diagramid = d.diagram_id  
and dl.ConnectorID = c.Connector_ID 
and os.object_id = c.start_object_id
and od.object_id = c.end_object_id
--and (os.value = 'BP_CONSTITUANT' or od.value = 'BP_CONSTITUANT')
--and (os.value like  'GB_%' and od.value like  'GB_%')
and  (SourceCard like '%*%' and DestCard like '%*%' )
--and (os.value like 'SE_%' or od.value like 'SE_%')

--and c.Connector_Type = 'Association'
--and c.SubType = 'Class'
order by d.name,os.value , od.value
;

select name from t_object where object_id = 86692

;

--List of data entity in a folder 
SELECT 
--obj.object_id, 
obj.name  as name,
op.value
FROM T_OBJECT obj , t_objectproperties op
WHERE 
--obj.NAME = 'SectionSebp'
--and  
obj.Object_ID = op.Object_ID
and  
op.Property = 'Code'
and 
obj.package_id IN  (select Package_id
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données')) AND  
NAME IN ('Tmp_GBP') )

ORDER BY obj.name , op.value ;

select * from t_object where name = 'Pondéré 3';

select * from t_package where Package_ID in (22406,22395); 


SELECT 
--obj.object_id, 
obj.name  as name,
op.value
FROM T_OBJECT obj , t_objectproperties op
WHERE 
--obj.NAME = 'SectionSebp'
--and  
obj.Object_ID = op.Object_ID
and  
op.Property = 'Code'
and 
obj.package_id IN  (select Package_id
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données')) 
--AND  NAME IN ('Tmp_SPHAIR_In_Proress') )
AND op.value ='BC_ZONE_ADMINISTRATIVE')
ORDER BY obj.name , op.value 






--------------------List of object to be validate be business 
SELECT * FROM (
SELECT 
(SELECT NAME FROM T_PACKAGE where package_id = NIV3.Parent_ID) Package_Parent, 
NIV3.NAME Package ,OBJ.NAME Entite , 
--OBJ.NOTE, 
objprop1.value  Table_BD,
replace(replace(replace(replace(replace(replace(replace(OBJ.note, '&#233;', 'é'),'&#224;','a') ,'&#226;','a'),'&#232;','e'),'&#234;','e'), '&#201;','e'), '&#249;', 'ù' ) Note_Commentaire 
--
--OBJ.Stereotype  
FROM T_OBJECT OBJ , t_objectproperties objprop1 ,
(
select Package_id , name , parent_id 
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données'))
)NIV3
 WHERE NIV3.PACKAGE_ID = OBJ.PACKAGE_ID
AND obj.Object_ID = objprop1.Object_ID
AND NIV3.NAME not like 'tmp_%'-- ('tmp_BC' )
AND  NIV3.NAME not in ( 'xx'--,
--'Association'
--,'Organique'
)
and objprop1.value LIKE'SE_%'
--ORDER BY NIV3.NAME , objprop1.value
) v
WHERE v.PACKAGE_PARENT NOT IN ('Source Migration de Power Designer')
Order by Table_BD
;



SELECT * FROM t_connector WHERE Connector_Type ='Association' and SubType = 'Class';

select name , 
 type
, Notes 
from t_attribute

where type in ('Adresse','Courriel','MDSYS.SDO_GEOMETRY','Statut','Téléphone', 'SERVICE')
;


--List of object in a diagram

SELECT o.name, op.value from t_diagramobjects DO,  t_diagram D, t_object o, t_objectproperties op
WHERE DO.diagram_id = D.diagram_id
and do.object_id = o.object_id 
and o.Object_ID = op.Object_ID
and d.name = 'GBP_Gestion des Barrages'
and op.Property = 'Code'
--and op.value LIKE 'GB_%'
order by op.value;






;
--Liste Of entities and tables of a system
select *--entite , table_bd 
from (
SELECT 
(SELECT NAME FROM T_PACKAGE where package_id = NIV3.Parent_ID) Package_Parent, NIV3.NAME Package ,
OBJ.NAME Entite , 
--OBJ.NOTE, 
replace(replace(replace(replace(replace(replace(replace(OBJ.note, '&#233;', 'é'),'&#224;','a') ,'&#226;','a'),'&#232;','e'),'&#234;','e'), '&#201;','e'), '&#249;', 'ù' ) Note_Commentaire ,
objprop1.value  Table_BD 
--OBJ.Stereotype  
FROM T_OBJECT OBJ , t_objectproperties objprop1 ,
(
select Package_id , name , parent_id 
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données'))
)NIV3
 WHERE NIV3.PACKAGE_ID = OBJ.PACKAGE_ID
AND obj.Object_ID = objprop1.Object_ID
AND NIV3.NAME  ='Tmp_CLIMATO_In_Progress'
--AND NIV3.NAME not like 'Tmp_%'-- ('tmp_BC' )
--AND NIV3.NAME = 'Tmp_GES_inProgress'-- ('tmp_BC' )
And NIV3.NAME not like 'Source Migration de Power Designer%' 
AND  NIV3.NAME not in ( 'XX'--,
--'Association'
--,'Organique'
)
--and objprop1.value LIKE'VL_%'
--ORDER BY  objprop1.value -- NIV3.NAME 
) v
where v.package_parent not like 'Source Migration de Power Designer%'  
order by Table_BD ;


SELECT * FROM T_CONNECTOR WHERE NAME = 'Est Affecte'; --65854

SELECT * FROM T_OBJECT WHERE OBJECT_ID = 65854; --no data found

SELECT value FROM t_connectortag WHERE PROPERTY = 'Code' and elementid = 65854; --GB_GARDIEN_BARRAGE


--List of association N:N without attribute with Tag as code = Trechnical Name Validated   -- It could be 1:N with Code also ?????
SELECT DISTINCT TT.VALUE FROM T_CONNECTOR T , t_connectortag TT, t_diagramlinks dl, t_diagram d
WHERE 
T.Connector_ID = TT.ElementID
and dl.ConnectorID = t.Connector_ID
and d.Diagram_ID = dl.DiagramID
--AND T.NAME =  'Est Affecte'
AND TT.Property = 'Code'
and d.name = 'F00 - VZE_Véhicule zéro émission - Global'-- 'SEBP_Securite et entretien des barrages_cible'
and TT.VALUE is not null
;

--List of association Class in a diagram 
SELECT T.* FROM T_CONNECTOR T , t_diagramlinks dl, t_diagram d
WHERE 
 dl.ConnectorID = t.Connector_ID
and d.Diagram_ID = dl.DiagramID
--AND T.NAME =  'Est Affecte'
and d.name =  'F00 - VZE_Véhicule zéro émission - Global'--'SEBP_Securite et entretien des barrages_cible'
AND SourceCard LIKE '%*%' AND DestCard LIKE '%*%'
AND T.Connector_Type ='Association' and T.SubType = 'Class';

;


SELECT * FROM T_CONNECTOR;

select * from t_object where OBJECT_ID = 86629;
select * from t_object where Object_ID = 86572;

SELECT * FROM t_diagramlinks WHERE connectorid = 65854


SELECT * FROM t_connector;

select * from t_diagramlinks where connectorid =65854;

select * from t_diagram d where  d.name = 'GBP-Gestion des Barrages_cible';


select distinct type  from t_attribute
order by type;

select * from t_attribute where type = 'SERVICE';

--Liste des attributs et types validees 
select*-- distinct  v.Data_Type 
from 
(
select 
package_p1.name as 'Parent Folder' , 
package_p2.name as 'Parent Folder1',
package_p3.name as 'Parent Folder2',
package.name as 'Data Source' ,
UPPER(class.name) as 'Table Name',
--a.*,
 UPPER(a.name) as 'Column Name',
a.Stereotype,
 --a.notes,
a.Type as 'Data_Type',
a.length,
 a.Precision, 
 a.Scale , 
a.Derived --,
 --a.[Default] as 'Default_Value',
-- a.AllowDuplicates
--a.ea_guid as CLASSGUID,
--'Attribute' as CLASSTYPE,
--a.name as Name
--,package_p2.name as 'Package level -2',package_p3.name as 'Package level -3'
from (((((t_attribute  a
inner join t_object class on a.object_id = class.object_id)
inner join t_package package on class.package_id = package.package_id)
left join t_package package_p1 on package_p1.package_id = package.parent_id)
left join t_package package_p2 on package_p2.package_id = package_p1.parent_id)
left join t_package package_p3 on package_p3.package_id = package_p2.parent_id)
where 
--UPPER(a.type) like  'LCAR%'
--and 
package_p2.name = 'Catalogue des entités de données'
and package_p1.name != 'Source Migration de Power Designer'
and package_p1.name !=  'Temp'--'Logical Data Model'
 --and class.name ='TH_DROIT'
--AND class.name  = 'DH_DONNEE_RECUEILLIE_7JRS'
--and a.stereotype = 'Attribut'
--Order by class.name , a.name
) v
;

select * from t_attribute where stereotype = 'Attribut'
select * from t_object o where o.name = 'PERSONNE-RESSOURCE';

select t.* from t_attribute t, t_object o where o.name = 'PERSONNE-RESSOURCE' and o.Object_ID = t.Object_ID;

--List of attributs in entities in a package
select  v.*, 
a.name, 
a.type
from (
SELECT 
(SELECT NAME FROM T_PACKAGE where package_id = NIV3.Parent_ID) Package_Parent, NIV3.NAME Package ,
OBJ.NAME Entite , 
--OBJ.NOTE, 
replace(replace(replace(replace(replace(replace(replace(OBJ.note, '&#233;', 'é'),'&#224;','a') ,'&#226;','a'),'&#232;','e'),'&#234;','e'), '&#201;','e'), '&#249;', 'ù' ) Note_Commentaire ,
objprop1.value  Table_BD , oBJ.Object_ID
--OBJ.Stereotype  
FROM T_OBJECT OBJ , t_objectproperties objprop1 ,
(
select Package_id , name , parent_id 
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données'))
)NIV3
 WHERE NIV3.PACKAGE_ID = OBJ.PACKAGE_ID
AND obj.Object_ID = objprop1.Object_ID
AND NIV3.NAME not like 'Tmp_%'-- ('tmp_BC' )
--AND NIV3.NAME = 'Tmp_GES_inProgress'-- ('tmp_BC' )
And NIV3.NAME not like 'Source Migration de Power Designer%' 
AND  NIV3.NAME not in ( 'XX'--,
--'Association'
--,'Organique'
)
--and objprop1.value LIKE'ZE_%'
and objprop1.value= 'GB_JOURNAL_BORD'
--ORDER BY  objprop1.value -- NIV3.NAME 
) v , t_attribute a
where 
a.Object_ID = v.Object_ID
and 
v.package_parent not like 'Source Migration de Power Designer%'
--and a.type like 'java.%'
;



--list if physical table exist

select *--entite , table_bd 
from (
SELECT 
(SELECT NAME FROM T_PACKAGE where package_id = NIV3.Parent_ID) Package_Parent, NIV3.NAME Package ,
OBJ.NAME Entite , 
--OBJ.NOTE, 
replace(replace(replace(replace(replace(replace(replace(OBJ.note, '&#233;', 'é'),'&#224;','a') ,'&#226;','a'),'&#232;','e'),'&#234;','e'), '&#201;','e'), '&#249;', 'ù' ) Note_Commentaire ,
objprop1.value  Table_BD 
--OBJ.Stereotype  
FROM T_OBJECT OBJ , t_objectproperties objprop1 ,
(
select Package_id , name , parent_id 
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données'))
)NIV3
 WHERE NIV3.PACKAGE_ID = OBJ.PACKAGE_ID
AND obj.Object_ID = objprop1.Object_ID
AND NIV3.NAME not like 'Tmp_%'-- ('tmp_BC' )
--AND NIV3.NAME = 'Tmp_GES_inProgress'-- ('tmp_BC' )
And NIV3.NAME not like 'Source Migration de Power Designer%' 
AND  NIV3.NAME not in ( 'XX'--,
--'Association'
--,'Organique'
)
and UPPER(objprop1.value) like  '%GB_BARRAGE_GRO_INTERET%' --'%EV_CARACT_VEHIC%'
--ORDER BY  objprop1.value -- NIV3.NAME 
) v
where v.package_parent not like 'Source Migration de Power Designer%'  
order by Table_BD ;


SELECT o.name, op.value from t_diagramobjects DO,  t_diagram D, t_object o, t_objectproperties op
WHERE DO.diagram_id = D.diagram_id
and do.object_id = o.object_id 
and o.Object_ID = op.Object_ID
and d.name = 'REP_Repertoire des barrages'
and op.Property = 'Code'
and op.value not  LIKE '%CS%'
--AND O.NAME LIKE '%YYYYY%'
order by op.value;



--diagramam Commun 
select distinct
os.value as start_val,
os.name as start_name,
--c.SourceCard, c.DestCard, 
--c.Start_Object_ID, 
--c.End_Object_ID,
--c.Name,
od.value as dest_val,od.name as dest_name, 
d.name
from 
t_connector c , 
t_diagramlinks dl ,
(SELECT obj.object_id, 
obj.name  as name,op.value
FROM T_OBJECT obj , 
t_objectproperties op
WHERE 
--obj.NAME = 'SectionSebp'
--and  
obj.Object_ID = op.Object_ID
and  
op.Property = 'Code'
and 
obj.package_id IN  (select Package_id
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données')) AND  NAME NOT IN ('tmp_BP_SE','tmp_GBP','tmp_BC') )
) os ,

(SELECT obj.object_id, obj.name  as name,op.value
FROM T_OBJECT obj , t_objectproperties op
WHERE 
--obj.NAME = 'SectionSebp'
--and  
obj.Object_ID = op.Object_ID
and  
op.Property = 'Code'
and 
obj.package_id IN  (select Package_id
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données')) 
AND  NAME NOT IN ('tmp_BP_SE','tmp_GBP','tmp_BC') )
) od 
,
(
select d.diagram_id , d.name from t_diagram d
where d.name IN( 
--'REP-Repertoire des barrages_Cible', 
--'BC-Station Poste et instrument_Cible',
'C_Communs_Cible'--,
--'SEBP- Securite et entretien des barrages_cible'
) 
) d 
where 
 dl.diagramid = d.diagram_id  
and dl.ConnectorID = c.Connector_ID 
and os.object_id = c.start_object_id
and od.object_id = c.end_object_id
order by od.value,d.name,os.value
;


---Entity with max connectors

select dest_val, count(dest_val) cnt from
(
select distinct
os.value as start_val,
os.name as start_name,
c.SourceCard, c.DestCard, c.Start_Object_ID, c.End_Object_ID,
c.Name as conn_name,
od.value as dest_val,od.name as dest_name, 
d.name as d_name
from 
t_connector c , 
t_diagramlinks dl ,
(SELECT obj.object_id, obj.name  as name,op.value
FROM T_OBJECT obj , t_objectproperties op
WHERE 
--obj.NAME = 'SectionSebp'
--and  
obj.Object_ID = op.Object_ID
and  
op.Property = 'Code'
and 
obj.package_id IN  (select Package_id
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données')) AND  NAME NOT IN ('tmp_BP_SE','tmp_GBP','tmp_BC') )
) os ,

(SELECT obj.object_id, obj.name  as name,op.value
FROM T_OBJECT obj , t_objectproperties op
WHERE 
--obj.NAME = 'SectionSebp'
--and  
obj.Object_ID = op.Object_ID
and  
op.Property = 'Code'
and 
obj.package_id IN  (select Package_id
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données')) 
AND  NAME NOT IN ('tmp_BP_SE','tmp_GBP','tmp_BC') )
) od 
,
(
select d.diagram_id , d.name from t_diagram d
where d.name IN( 
--'REP-Repertoire des barrages_Cible', 
--'BC-Station Poste et instrument_Cible',
'SPHAIR'--,
--'SEBP- Securite et entretien des barrages_cible'
) 
) d 
where 
 dl.diagramid = d.diagram_id  
and dl.ConnectorID = c.Connector_ID 
and os.object_id = c.start_object_id
and od.object_id = c.end_object_id
--and (os.value = 'BP_CONSTITUANT' or od.value = 'BP_CONSTITUANT')
--and (os.value like  'GB_%' and od.value like  'GB_%')
--and  (SourceCard like '%*%' and DestCard like '%*%' )
--and (os.value like 'SE_%' or od.value like 'SE_%')

--and c.Connector_Type = 'Association'
--and c.SubType = 'Class'
--order by d.name,os.value , od.value

) my_view
group by dest_val
order by cnt desc;


--List of attributs in entities in a package
select  v.*, 
a.name, 
a.type,
a.Length,
a.Precision,
a.Scale
from (
SELECT 
(SELECT NAME FROM T_PACKAGE where package_id = NIV3.Parent_ID) Package_Parent, NIV3.NAME Package ,
OBJ.NAME Entite , 
--OBJ.NOTE, 
replace(replace(replace(replace(replace(replace(replace(OBJ.note, '&#233;', 'é'),'&#224;','a') ,'&#226;','a'),'&#232;','e'),'&#234;','e'), '&#201;','e'), '&#249;', 'ù' ) Note_Commentaire ,
objprop1.value  Table_BD , oBJ.Object_ID
--OBJ.Stereotype  
FROM T_OBJECT OBJ , t_objectproperties objprop1 ,
(
select Package_id , name , parent_id 
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données'))
)NIV3
 WHERE NIV3.PACKAGE_ID = OBJ.PACKAGE_ID
AND obj.Object_ID = objprop1.Object_ID
AND NIV3.NAME not like 'Tmp_%'-- ('tmp_BC' )
--AND NIV3.NAME = 'Tmp_GES_inProgress'-- ('tmp_BC' )
And NIV3.NAME not like 'Source Migration de Power Designer%' 
AND  NIV3.NAME not in ( 'XX'--,
--'Association'
--,'Organique'
)
--and objprop1.value LIKE'GB_%'
--and objprop1.value= 'ZE_PERSONNE_RESSOURCE'
--ORDER BY  objprop1.value -- NIV3.NAME 
) v , t_attribute a
where 
a.Object_ID = v.Object_ID
and 
v.package_parent not like 'Source Migration de Power Designer%'
and a.type like 'java.%'
;


SELECT pk.name  FROM t_package pk WHERE Package_ID = 22394;

SELECT * FROM T_OBJECT OB WHERE OB.NAME = 'INFRACTION' AND OB.Stereotype='Entité données' AND package_id = 22394;
SELECT * FROM T_ATTRIBUTE TA where Object_ID = 145877;


select a.name as 'Column Name',
 a.notes,
 a.Type as 'Type',
 a.length,
 a.Precision, 
 a.Scale, 
 a.Derived,
 a.[Default] as 'Default_Value',
 a.AllowDuplicates from t_attribute A 
 where 
 --A.name = 'numeroSequentiel' and A.ID = 38333;
 A.ID = 38333;


select *  from t_attributetag where ElementID = 38333 and Property in( 'Code', 'AutoNum','Identifiant primaire', 
'LengthType','Longueur','Obligatoire','Précision','property','Type PD original');

select distinct property from t_attributetag;

--List of attributs in entities in a package : Physical code to be compared with database
select  v.*, 
V.table_BD AS EA_TABLE_NAME ,
--a.name,  
atg.value AS EA_COLUMN_NAME
--a.type
from (
SELECT 
(SELECT NAME FROM T_PACKAGE where package_id = NIV3.Parent_ID) Package_Parent, NIV3.NAME Package ,
OBJ.NAME Entite , 
--OBJ.NOTE, 
--replace(replace(replace(replace(replace(replace(replace(OBJ.note, '&#233;', 'é'),'&#224;','a') ,'&#226;','a'),'&#232;','e'),'&#234;','e'), '&#201;','e'), '&#249;', 'ù' ) Note_Commentaire ,
objprop1.value  Table_BD , oBJ.Object_ID
--OBJ.Stereotype  
FROM T_OBJECT OBJ , t_objectproperties objprop1 ,
(
select Package_id , name , parent_id 
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données'))
)NIV3
 WHERE NIV3.PACKAGE_ID = OBJ.PACKAGE_ID
AND obj.Object_ID = objprop1.Object_ID
AND NIV3.NAME not like 'Commun_Cible%'-- ('tmp_BC' )
AND NIV3.NAME not like 'Tmp_%'
--AND NIV3.NAME = 'Tmp_GES_inProgress'-- ('tmp_BC' )
And NIV3.NAME not like 'Source Migration de Power Designer%' 
AND  NIV3.NAME not in ( 'XX'--,
--'Association'
--,'Organique'
)
--and objprop1.value LIKE'ZE_%'
--and objprop1.value= 'BP_CENTRE_SERVICE'
--ORDER BY  objprop1.value -- NIV3.NAME 
) v , t_attribute a, t_attributetag atg
where 
a.Object_ID = v.Object_ID
and 
v.package_parent not like 'Source Migration de Power Designer%'
--and a.type like 'java.%'
and v.table_BD = 'GB_ACTIVITE'
--and v.table_BD LIKE 'BP_%'
and a.ID = atg.ElementID
and atg.Property ='Code'
order by 
V.table_BD ,
atg.value 
;

select * from t_attribute;
select * from t_attributetag;


--List of attributs in entities in a package : Physical code to be compared with database in python------------------------------------
select 
V.table_BD AS EA_TABLE_NAME ,
atg.value AS EA_COLUMN_NAME
from (
SELECT 
(SELECT NAME FROM T_PACKAGE where package_id = NIV3.Parent_ID) Package_Parent, NIV3.NAME Package ,
OBJ.NAME Entite , 
objprop1.value  Table_BD , oBJ.Object_ID
FROM T_OBJECT OBJ , t_objectproperties objprop1 ,
(
select Package_id , name , parent_id 
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données'))
)NIV3
 WHERE NIV3.PACKAGE_ID = OBJ.PACKAGE_ID
AND obj.Object_ID = objprop1.Object_ID
And NIV3.NAME not like 'Source Migration de Power Designer%' 
AND  NIV3.NAME not in ( 'XX'--,
)
) v , t_attribute a, t_attributetag atg
where 
a.Object_ID = v.Object_ID
and 
v.package_parent not like 'Source Migration de Power Designer%'
and v.table_BD LIKE 'BP_BARRAGE%'
and a.ID = atg.ElementID
and atg.Property ='Code'
order by 
V.table_BD ,
atg.value 
;

SELECT * FROM t_diagram where name =  'GBP_Gestion des Barrages';

---Barrage
--List of association N:N without attribute with Tag as code = Trechnical Name Validated   -- It could be 1:N with Code also ?????
select ENTITY_START as ENTITE_DEBUT,
NAME as NOM_CONNECTEUR,
ENTITY_END as ENTITE_FIN,
VALUE AS TABLE_PHYSIQUE

from
(
SELECT DISTINCT TT.VALUE, t.NAME ,
(SELECT name from t_object where object_id = T.start_object_id ) as ENTITY_START,
(SELECT name from t_object where object_id = T.end_object_id ) as ENTITY_END
FROM T_CONNECTOR T , t_connectortag TT, t_diagramlinks dl, t_diagram d
WHERE 
T.Connector_ID = TT.ElementID
and dl.ConnectorID = t.Connector_ID
and d.Diagram_ID = dl.DiagramID
--AND T.NAME =  'Est Affecte'
AND TT.Property = 'Code'
--and d.name = 'GBP_Gestion des Barrages'-- 'SEBP_Securite et entretien des barrages_cible'
and TT.VALUE is not null

AND SourceCard LIKE '%*%' AND DestCard LIKE '%*%'
) V
where  ENTITY_START not like '%YYYYY%'
and ENTITY_END not like '%YYYYY%'
and ENTITY_START not like '%XXXXX%'
and ENTITY_END not like '%XXXXX%'
;

--List of association Class in a diagram 
SELECT T.* 
FROM T_CONNECTOR T , t_diagramlinks dl, t_diagram d -- , t_connectortag TT
WHERE 
 dl.ConnectorID = t.Connector_ID
and d.Diagram_ID = dl.DiagramID
--AND T.NAME =  'Est Affecte'
and d.name =  'GBP_Gestion des Barrages'--'SEBP_Securite et entretien des barrages_cible'
--AND SourceCard LIKE '%*%' AND DestCard LIKE '%*%'
AND T.Connector_Type ='Association' and T.SubType = 'Class'
--and T.Connector_ID = TT.ElementID
--and TT.Property = 'Code'
;

select * from t_connector where name = 'Interesse';

select * from t_connectortag where ElementID = 61761;



select * from t_attributetag where property = 'CODE' and value is not null;
select * from t_objectproperties where property= 'CODE'  and value is not null

;

--Dtecet if entities in temp system package existes in the catalog
select *--entite , table_bd 
from (
SELECT 
(SELECT NAME FROM T_PACKAGE where package_id = NIV3.Parent_ID) Package_Parent, NIV3.NAME Package ,
OBJ.NAME Entite , 
--OBJ.NOTE, 
replace(replace(replace(replace(replace(replace(replace(OBJ.note, '&#233;', 'é'),'&#224;','a') ,'&#226;','a'),'&#232;','e'),'&#234;','e'), '&#201;','e'), '&#249;', 'ù' ) Note_Commentaire ,
objprop1.value  Table_BD 
--OBJ.Stereotype  
FROM T_OBJECT OBJ , t_objectproperties objprop1 ,
(
select Package_id , name , parent_id 
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données'))
)NIV3
 WHERE NIV3.PACKAGE_ID = OBJ.PACKAGE_ID
AND obj.Object_ID = objprop1.Object_ID
AND NIV3.NAME  ='Tmp_CLIMATO_In_Progress'

And NIV3.NAME not like 'Source Migration de Power Designer%' 
AND  NIV3.NAME not in ( 'XX'--,
--'Association'
--,'Organique'
)
) v
where v.package_parent not like 'Source Migration de Power Designer%'  
and exists (select 1 from (
select *--entite , table_bd 
from (
SELECT 
(SELECT NAME FROM T_PACKAGE where package_id = NIV3.Parent_ID) Package_Parent, NIV3.NAME Package ,
OBJ.NAME Entite , 
--OBJ.NOTE, 
replace(replace(replace(replace(replace(replace(replace(OBJ.note, '&#233;', 'é'),'&#224;','a') ,'&#226;','a'),'&#232;','e'),'&#234;','e'), '&#201;','e'), '&#249;', 'ù' ) Note_Commentaire ,
objprop1.value  Table_BD 
--OBJ.Stereotype  
FROM T_OBJECT OBJ , t_objectproperties objprop1 ,
(
select Package_id , name , parent_id 
from t_package 
where parent_id in (
SELECT PACKAGE_ID FROM T_PACKAGE WHERE PARENT_ID = (SELECT PACKAGE_ID FROM T_PACKAGE WHERE  NAME = 'Catalogue des entités de données'))
)NIV3
 WHERE NIV3.PACKAGE_ID = OBJ.PACKAGE_ID
AND obj.Object_ID = objprop1.Object_ID
--AND NIV3.NAME  ='Tmp_CLIMATO_In_Progress'
AND NIV3.NAME not like 'Tmp_%'-- ('tmp_BC' )
--AND NIV3.NAME = 'Tmp_GES_inProgress'-- ('tmp_BC' )
And NIV3.NAME not like 'Source Migration de Power Designer%' 
AND  NIV3.NAME not in ( 'XX'--,
--'Association'
--,'Organique'
)
--and objprop1.value LIKE'VL_%'
--ORDER BY  objprop1.value -- NIV3.NAME 
) v
where v.package_parent not like 'Source Migration de Power Designer%'  
--order by Table_BD 
)  x  where v.Table_BD = x.Table_BD) ;

------


;WITH PackHierarchy AS (
    SELECT PACKAGE_ID , Name, PARENT_ID, 1 AS Level
    FROM T_PACKAGE
    WHERE NAME = 'Catalogue des entités de données' -- Start with top-level manager
    UNION ALL
    SELECT E.PACKAGE_ID, e.Name, e.PARENT_ID, eh.Level + 1
    FROM T_PACKAGE e
    INNER JOIN PackHierarchy eh ON e.parent_id = eh.package_id
)
SELECT PACKAGE_ID , Name, PARENT_ID FROM PackHierarchy 
where name not like 'Tmp%'
and name != 'Commun Cible'
order by name;


;WITH PackHierarchy AS (
    SELECT PACKAGE_ID AS PKG_ID , Name AS PKG_NAME,  PARENT_ID AS PKG_PARID, 1 AS Level
    FROM T_PACKAGE
    WHERE NAME = 'Catalogue des entités de données' -- Start with top-level manager
    UNION ALL
    SELECT E.PACKAGE_ID, e.Name, e.PARENT_ID, eh.Level + 1
    FROM T_PACKAGE e
    INNER JOIN PackHierarchy eh ON e.parent_id = eh.PKG_ID
)
SELECT --PKG_ID , PKG_NAME, PKG_PARID, tobj.name, 
objprop.value AS TABLE_NAME , atg.VALUE as COLUMN_NAME
FROM PackHierarchy , t_object tobj, t_attribute att, t_objectproperties objprop, t_attributetag atg 
where PKG_NAME not like 'Tmp%'
and PKG_NAME != 'Commun Cible'
and tobj.Package_ID = pkg_id 
and tobj.Object_ID = att.Object_ID
and tobj.Object_ID = objprop.Object_ID
and att.id = atg.ElementID
and atg.Property = 'Code'
AND objprop.value LIKE 'GB_%'
order by TABLE_NAME,COLUMN_NAME




 ;WITH PackHierarchy AS (
            SELECT PACKAGE_ID AS PKG_ID , Name AS PKG_NAME,  PARENT_ID AS PKG_PARID, 1 AS Level
            FROM T_PACKAGE
            WHERE NAME = 'Catalogue des entités de données' -- Start with top-level manager
            UNION ALL
            SELECT E.PACKAGE_ID, e.Name, e.PARENT_ID, eh.Level + 1
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.parent_id = eh.PKG_ID
        )
        SELECT --PKG_ID , PKG_NAME, PKG_PARID, tobj.name,
        'Entreprise Architect' as SYSTEME , 'GB'
        AS CODE_SYSTEME , 'SPARXSYSTEM' AS DB_SOURCE, 'SQL Server' AS DB_TYPE,
        objprop.value AS TABLE_NAME , atg.VALUE as COLUMN_NAME
        FROM PackHierarchy , t_object tobj, t_attribute att, t_objectproperties objprop, t_attributetag atg
        where PKG_NAME not like 'Tmp%'
        and PKG_NAME != 'Commun Cible'
        and tobj.Package_ID = pkg_id
        and tobj.Object_ID = att.Object_ID
        and tobj.Object_ID = objprop.Object_ID
        and att.id = atg.ElementID
        and atg.Property = 'Code'
        AND objprop.value LIKE 'BP_%'
		--and  objprop.value = 'BP_BARRAGE'
        order by TABLE_NAME,COLUMN_NAME
        ;



		
 ;WITH PackHierarchy AS (
            SELECT PACKAGE_ID AS PKG_ID , Name AS PKG_NAME,  PARENT_ID AS PKG_PARID, 1 AS Level
            FROM T_PACKAGE
            WHERE NAME = 'Catalogue des entités de données' -- Start with top-level manager
            UNION ALL
            SELECT E.PACKAGE_ID, e.Name, e.PARENT_ID, eh.Level + 1
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.parent_id = eh.PKG_ID
        )
        SELECT --PKG_ID , PKG_NAME, PKG_PARID, tobj.name,
        'Entreprise Architect' as SYSTEME , 'GB'
        AS CODE_SYSTEME , 'SPARXSYSTEM' AS DB_SOURCE, 'SQL Server' AS DB_TYPE,
        objprop.value AS TABLE_NAME , atg.VALUE as COLUMN_NAME
        FROM PackHierarchy , t_object tobj, t_attribute att, t_objectproperties objprop, t_attributetag atg
        where PKG_NAME not like 'Tmp%'
        and PKG_NAME != 'Commun Cible'
        and tobj.Package_ID = pkg_id
        and tobj.Object_ID = att.Object_ID
        and tobj.Object_ID = objprop.Object_ID
        and att.id = atg.ElementID
        and atg.Property = 'Code'
        --AND objprop.value LIKE'GB_%'
		and objprop.value = 'BP_BARRAGE'
        order by TABLE_NAME,COLUMN_NAME
        ;

		 SELECT --PKG_ID , PKG_NAME, PKG_PARID, tobj.name,
        'Entreprise Architect' as SYSTEME , 'GB'
        AS CODE_SYSTEME , 'SPARXSYSTEM' AS DB_SOURCE, 'SQL Server' AS DB_TYPE,
        objprop.value AS TABLE_NAME , atg.VALUE as COLUMN_NAME
        FROM  t_object tobj, t_attribute att, t_objectproperties objprop, t_attributetag atg
        where
         tobj.Object_ID = att.Object_ID
        and tobj.Object_ID = objprop.Object_ID
        and att.id = atg.ElementID
        and atg.Property = 'Code'
        --AND objprop.value LIKE'GB_%'
		and objprop.value = 'BP_BARRAGE'
        order by TABLE_NAME,COLUMN_NAME;



		SELECT obj.Package_ID, obj.ParentID, obj.name, objp.Value, attt.VALUE 
		FROM T_OBJECT OBJ , t_objectproperties OBJP , t_attribute ATT, t_attributetag ATTT
		WHERE OBJ.Object_ID = OBJP.Object_ID
		AND OBJ.Object_ID=ATT.Object_ID
		AND ATT.ID = ATTT.ElementID
		AND attt.Property =  'Code'
		and objp.value = 'BP_BARRAGE'
		and obj.Package_ID =14231
		;

		-----------------------------Requete  hierarchique valide------------------------
		 ;WITH PackHierarchy AS (
            SELECT PACKAGE_ID AS PKG_ID , Name AS PKG_NAME,  PARENT_ID AS PKG_PARID, 1 AS Level
            FROM T_PACKAGE
            WHERE NAME = 'Catalogue des entités de données' -- Start with top-level manager
            UNION ALL
            SELECT E.PACKAGE_ID, e.Name, e.PARENT_ID, eh.Level + 1
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.parent_id = eh.PKG_ID
        )
        SELECT --PKG_ID , PKG_NAME, PKG_PARID, tobj.name,
        'Entreprise Architect' as SYSTEME , 'GB'
        AS CODE_SYSTEME , 'SPARXSYSTEM' AS DB_SOURCE, 'SQL Server' AS DB_TYPE,
        objprop.value AS TABLE_NAME , atg.VALUE as COLUMN_NAME
        FROM PackHierarchy , t_object tobj, t_attribute att, t_objectproperties objprop, t_attributetag atg
        where PKG_NAME not like 'Tmp%'
        and PKG_NAME != 'Commun Cible'
        and tobj.Package_ID = pkg_id
        and tobj.Object_ID = att.Object_ID
        and tobj.Object_ID = objprop.Object_ID
        and att.id = atg.ElementID
        and atg.Property = 'Code'
        --AND objprop.value LIKE'GB_%'
		--and objprop.value = 'BP_BARRAGE'
        order by TABLE_NAME,COLUMN_NAME
        ;
		----------------------

		


		;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			--,CAST(T.PACKAGE_ID AS NVARCHAR(555))  AS  full_paths
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Catalogue des entités de données' -- Start with top-level manager
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			--,CAST(CAST(eh.full_paths AS NVARCHAR(555)) +  '/' + CAST(e.PACKAGE_ID AS NVARCHAR(555)) AS NVARCHAR(555)) AS full_paths
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT --PKG_ID , PKG_NAME, PKG_PARID, tobj.name,
        'Entreprise Architect' as SYSTEME , 'GB'
        AS CODE_SYSTEME , 'SPARXSYSTEM' AS DB_SOURCE, 'SQL Server' AS DB_TYPE,tobj.name AS NAME,
        objprop.value AS TABLE_NAME , atg.VALUE as COLUMN_NAME  ,PKG_NAME,
		FULL_PATH
        FROM PackHierarchy , t_object tobj, t_attribute att, t_objectproperties objprop, t_attributetag atg
        where PKG_NAME not like 'Tmp%'
        and PKG_NAME != 'Commun Cible'
        and tobj.Package_ID = pkg_id
        and tobj.Object_ID = att.Object_ID
        and tobj.Object_ID = objprop.Object_ID
        and att.id = atg.ElementID
        and atg.Property = 'Code'
        --AND objprop.value LIKE'GB_%'
		--and objprop.value = 'BP_BARRAGE'
        order by TABLE_NAME,COLUMN_NAME
        ;

		
			;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Catalogue Entités de données' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT tobj.name AS ENTITY_NAME,
        objprop.value AS TABLE_NAME , atg.VALUE as COLUMN_NAME  ,PKG_NAME,
		FULL_PATH
        FROM PackHierarchy , t_object tobj, t_attribute att, t_objectproperties objprop, t_attributetag atg
        where PKG_NAME not like 'Tmp%'
        and PKG_NAME != 'Commun Cible'
        and tobj.Package_ID = pkg_id
        and tobj.Object_ID = att.Object_ID
        and tobj.Object_ID = objprop.Object_ID
        and att.id = atg.ElementID
        and atg.Property = 'Code'
        --AND atg.VALUE = 'COLONNE_%'
		--and objprop.value = 'BP_BARRAGE'
        order by TABLE_NAME,COLUMN_NAME
        ;



select  c.connector_id , c.Start_Object_ID, c.End_Object_ID, c.DiagramID ,
(select os.name from t_object os where os.object_id = c.Start_Object_ID ) start_obj,
(select od.name from t_object od where od.object_id = c.End_Object_ID ) end_obj
from t_connector c, t_diagram d , t_diagramlinks dl
where dl.DiagramID = c.DiagramID
and dl.ConnectorID = c.Connector_ID
and d.name = 'F00 - REP_Repertoire des barrages - Global' ;


;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Catalogue des entités de données' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT distinct tobj.name AS ENTITY_NAME,
        objprop.value AS TABLE_NAME -- , atg.VALUE as COLUMN_NAME  
		,PKG_NAME,
		FULL_PATH
        FROM PackHierarchy , t_object tobj
		--,COUNT (objprop.value) OVER (PARTITION BYobjprop.value)
		--, t_attribute att
		, t_objectproperties objprop
		--, t_attributetag atg
        where PKG_NAME not like 'Tmp%'
        and PKG_NAME != 'Commun Cible'
        and tobj.Package_ID = pkg_id
        --and tobj.Object_ID = att.Object_ID
        and tobj.Object_ID = objprop.Object_ID
       -- and att.id = atg.ElementID
      --  and atg.Property = 'Code'
        --AND atg.VALUE = 'COLONNE_%'
		and objprop.value = 'SE_VISITE'
        --order by TABLE_NAME --,COLUMN_NAME


		
---

;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Catalogue des entités de données' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT DISTINCT tobj.name AS ENTITY_NAME,
        objprop.value AS TABLE_NAME -- , atg.VALUE as COLUMN_NAME  
		,PKG_NAME,
		FULL_PATH,
		count(1) over (partition by  objprop.value) as NBR_Tab_Duppliquee
        FROM PackHierarchy , t_object tobj
		--,COUNT (objprop.value) OVER (PARTITION BYobjprop.value)
		--, t_attribute att
		, t_objectproperties objprop
		--, t_attributetag atg
        where PKG_NAME not like 'Tmp%'
        and PKG_NAME != 'Commun Cible'
        and tobj.Package_ID = pkg_id
        --and tobj.Object_ID = att.Object_ID
        and tobj.Object_ID = objprop.Object_ID
       -- and att.id = atg.ElementID
      --  and atg.Property = 'Code'
        --AND atg.VALUE = 'COLONNE_%'
		and objprop.value = 'BC_IDENTIFICATION_STATION'
		order by  TABLE_NAME --,COLUMN_NAME
		     ;
		
		
	;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Catalogue des entités de données' -- Start with top-level root
			AND T.Package_ID = 14233 ----------------------------------------------------------!!!!!!!
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT * from	PackHierarchy;

				;


			
;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Catalogue des entités de données' -- Start with top-level root
            AND T.Package_ID = 14233
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  tobj.name AS ENTITY_NAME,
        objprop.value AS TABLE_NAME -- , atg.VALUE as COLUMN_NAME  
		,PKG_NAME,
		FULL_PATH
		,count(1) over (partition by  objprop.value) as NBR_Tab_Duppliquee
        FROM PackHierarchy , t_object tobj
		--,COUNT (objprop.value) OVER (PARTITION BYobjprop.value)
		--, t_attribute att
		, t_objectproperties objprop
		--, t_attributetag atg
        where PKG_NAME not like 'Tmp%'
        and PKG_NAME != 'Commun Cible'
        and tobj.Package_ID = pkg_id
        --and tobj.Object_ID = att.Object_ID
        and tobj.Object_ID = objprop.Object_ID
       -- and att.id = atg.ElementID
      --  and atg.Property = 'Code'
        --AND atg.VALUE = 'COLONNE_%'
		--and objprop.value = 'BP_BARRAGE'
		
        order by TABLE_NAME --,COLUMN_NAME
		        ;

-- Liste of Tables in the catalog EA
;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Catalogue des entités de données' -- Start with top-level root
            AND T.Package_ID = 14233
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  objprop.value AS TABLE_NAME
        FROM PackHierarchy , t_object tobj
		, t_objectproperties objprop
		where PKG_NAME not like 'Tmp%'
        and PKG_NAME != 'Commun Cible'
        and tobj.Package_ID = pkg_id
        and tobj.Object_ID = objprop.Object_ID
        order by TABLE_NAME
		        ;

;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Modele conceptuel de donnees - MCDs' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT PKG_NAME, --PKG_ID, 
		d.name AS DIAGRAM_NAME, TT.VALUE as TABLE_PHYSIQUE, t.NAME AS CONNECTOR_NAME,
		(SELECT name from t_object where object_id = T.start_object_id ) as ENTITY_START,
(SELECT name from t_object where object_id = T.end_object_id ) as ENTITY_END
        FROM PackHierarchy , t_diagram d, T_CONNECTOR T , t_connectortag TT, t_diagramlinks dl
		where PKG_NAME not like 'Tmp%'
        and PKG_NAME != 'Commun Cible'
		and d.Package_ID = PKG_ID
		and UPPER(D.NAME) NOT LIKE '%SOURCE%'
		AND T.Connector_ID = TT.ElementID
and dl.ConnectorID = t.Connector_ID
and d.Diagram_ID = dl.DiagramID
AND TT.Property = 'Code'
--and d.name = 'GBP_Gestion des Barrages'-- 'SEBP_Securite et entretien des barrages_cible'
and TT.VALUE is not null
AND SourceCard LIKE '%*%' AND DestCard LIKE '%*%'
AND TT.VALUE = 'XX'
       
		        ;

SELECT * FROM t_diagram


				---Barrage
--List of association N:N without attribute with Tag as code = Trechnical Name Validated   -- It could be 1:N with Code also ?????
select ENTITY_START as ENTITE_DEBUT,
NAME as NOM_CONNECTEUR,
ENTITY_END as ENTITE_FIN,
VALUE AS TABLE_PHYSIQUE

from
(
SELECT DISTINCT TT.VALUE, t.NAME ,
(SELECT name from t_object where object_id = T.start_object_id ) as ENTITY_START,
(SELECT name from t_object where object_id = T.end_object_id ) as ENTITY_END
FROM T_CONNECTOR T , t_connectortag TT, t_diagramlinks dl, t_diagram d
WHERE 
T.Connector_ID = TT.ElementID
and dl.ConnectorID = t.Connector_ID
and d.Diagram_ID = dl.DiagramID
--AND T.NAME =  'Est Affecte'
AND TT.Property = 'Code'
--and d.name = 'GBP_Gestion des Barrages'-- 'SEBP_Securite et entretien des barrages_cible'
and TT.VALUE is not null

AND SourceCard LIKE '%*%' AND DestCard LIKE '%*%'
) V
where  ENTITY_START not like '%YYYYY%'
and ENTITY_END not like '%YYYYY%'
and ENTITY_START not like '%XXXXX%'
and ENTITY_END not like '%XXXXX%'
;


--List of association Class in a diagram 
SELECT * FROM (
SELECT D.name as DIGARMA_NAME , t.name AS Connector_name,
(SELECT name from t_object where object_id = T.start_object_id ) as ENTITY_START,
(SELECT name from t_object where object_id = T.end_object_id ) as ENTITY_end
FROM T_CONNECTOR T , t_diagramlinks dl, t_diagram d -- , t_connectortag TT
WHERE 
 dl.ConnectorID = t.Connector_ID
and d.Diagram_ID = dl.DiagramID
--AND T.NAME =  'Est Affecte'
--and d.name =  'GBP_Gestion des Barrages'--'SEBP_Securite et entretien des barrages_cible'
AND SourceCard LIKE '%*%' AND DestCard LIKE '%*%'
AND T.Connector_Type ='Association' and T.SubType = 'Class'
--and T.Connector_ID = TT.ElementID
--and TT.Property = 'Code'
AND t.name is not null
) V WHERE ENTITY_START NOT LIKE '%XXXXX%'
AND ENTITY_END NOT LIKE '%XXXXX%'
AND ENTITY_START NOT LIKE '%YYYYY%'
AND ENTITY_END NOT LIKE '%YYYYY%'
AND UPPER(DIGARMA_NAME) NOT LIKE '%SOURCE%'
ORDER BY DIGARMA_NAME

;




;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Modele conceptuel de donnees - MCDs' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT PKG_NAME, --PKG_ID, 
		d.name AS DIAGRAM_NAME, TT.VALUE as TABLE_PHYSIQUE, t.NAME AS CONNECTOR_NAME,
		(SELECT name from t_object where object_id = T.start_object_id ) as ENTITY_START,
(SELECT name from t_object where object_id = T.end_object_id ) as ENTITY_END
        FROM PackHierarchy , t_diagram d, T_CONNECTOR T , t_connectortag TT, t_diagramlinks dl
		where PKG_NAME not like 'Tmp%'
        and PKG_NAME != 'Commun Cible'
		and d.Package_ID = PKG_ID
		and UPPER(D.NAME) NOT LIKE '%SOURCE%'
		AND T.Connector_ID = TT.ElementID
and dl.ConnectorID = t.Connector_ID
and d.Diagram_ID = dl.DiagramID
AND TT.Property = 'Code'
--and d.name = 'GBP_Gestion des Barrages'-- 'SEBP_Securite et entretien des barrages_cible'
and TT.VALUE is not null
AND SourceCard LIKE '%*%' AND DestCard LIKE '%*%'
;


--------------------------------Liste des entites de donnees sources dans le repertoire de migration
 ;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Source Migration de Power Designer' -- Start with top-level root
            --AND T.Package_ID = 14233
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  objprop.value AS TABLE_NAME
        FROM PackHierarchy , t_object tobj
		, t_objectproperties objprop
		where PKG_NAME= 'GBP_GB_Gestion des barrages publics'  -- Repertoire source de migration par systeme
        --and PKG_NAME != 'Commun Cible'
        and tobj.Package_ID = PKG_ID
        and tobj.Object_ID = objprop.Object_ID
        order by TABLE_NAME
---------------------------------Liste des entites de donnees  dans le repertoire de travail Tmp_****
 ;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Catalogue des entités de données' -- Start with top-level root
            --AND T.Package_ID = 14233
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  objprop.value AS TABLE_NAME
        FROM PackHierarchy , t_object tobj
		, t_objectproperties objprop
		where PKG_NAME= 'Tmp_GES_inProgress'  -- Repertoire source de migration par systeme
        --and PKG_NAME != 'Commun Cible'
        and tobj.Package_ID = PKG_ID
        and tobj.Object_ID = objprop.Object_ID
        order by TABLE_NAME



------Liste des entites de donnees dans un  diagram MCD
SELECT o.name, 
op.value,-- o.note,
replace(replace(replace(replace(replace(o.note, '&#233;', 'é'),'&#224;','a') ,'&#226','a'),'&#232;','e'),'&#234','e') note
--o.note  Latin1_General_100_BIN2, 
--cast(cast(o.note AS varchar(1000)) AS varchar(1000) ) Latin1_General_100_CI_AS
from t_diagramobjects DO,  t_diagram D, t_object o, t_objectproperties op
WHERE DO.diagram_id = D.diagram_id
and do.object_id = o.object_id 
and o.Object_ID = op.Object_ID
and d.name = 'CL_Climatologie'
and op.Property = 'Code'
--and op.value LIKE 'GB_%'
ORDER BY op.value,o.name ;



 ;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Source Migration de Power Designer' -- Start with top-level root
            --AND T.Package_ID = 14233
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  objprop.value AS TABLE_NAME
        FROM PackHierarchy , t_object tobj
		, t_objectproperties objprop
		where PKG_NAME= 'GBP_GB_Gestion des barrages publics'  -- Repertoire source de migration par systeme
        --and PKG_NAME != 'Commun Cible'
        and tobj.Package_ID = PKG_ID
        and tobj.Object_ID = objprop.Object_ID
        order by TABLE_NAME;




		;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Source Migration de Power Designer' -- Start with top-level root
            --AND T.Package_ID = 14233
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  objprop.value AS TABLE_NAME
        FROM PackHierarchy , t_object tobj
		, t_objectproperties objprop
		where PKG_NAME= 'GBP_GB_Gestion des barrages publics'  -- Repertoire source de migration par systeme
        --and PKG_NAME != 'Commun Cible'
        and tobj.Package_ID = PKG_ID
        and tobj.Object_ID = objprop.Object_ID
        order by TABLE_NAME
		;


		;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Modele conceptuel de données - MCDs' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT PKG_NAME, --PKG_ID, 
		d.name AS DIAGRAM_NAME, TT.VALUE as TABLE_PHYSIQUE, t.NAME AS CONNECTOR_NAME,
		(SELECT name from t_object where object_id = T.start_object_id ) as ENTITY_START,
(SELECT name from t_object where object_id = T.end_object_id ) as ENTITY_END
        FROM PackHierarchy , t_diagram d, T_CONNECTOR T , t_connectortag TT, t_diagramlinks dl
		where PKG_NAME not like 'Tmp%'
        and PKG_NAME != 'Commun Cible'
		and d.Package_ID = PKG_ID
		and UPPER(D.NAME) NOT LIKE '%SOURCE%'
		AND T.Connector_ID = TT.ElementID
and dl.ConnectorID = t.Connector_ID
and d.Diagram_ID = dl.DiagramID
AND TT.Property = 'Code'
--and d.name = 'GBP_Gestion des Barrages'-- 'SEBP_Securite et entretien des barrages_cible'
and TT.VALUE is not null
AND SourceCard LIKE '%*%' AND DestCard LIKE '%*%'
;

select * from t_diagram where name like '%GBP%';

------Liste des entites de donnees dans un  diagram MCD
SELECT o.name AS Entite, 
op.value AS Table_Physique,-- o.note,
replace(replace(replace(replace(replace(o.note, '&#233;', 'é'),'&#224;','a') ,'&#226','a'),'&#232;','e'),'&#234','e') note
--o.note  Latin1_General_100_BIN2, 
--cast(cast(o.note AS varchar(1000)) AS varchar(1000) ) Latin1_General_100_CI_AS
from t_diagramobjects DO,  t_diagram D, t_object o, t_objectproperties op
WHERE DO.diagram_id = D.diagram_id
and do.object_id = o.object_id 
and o.Object_ID = op.Object_ID
and d.name = 'GBP_Gestion des Barrages'
and op.Property = 'Code'
--and op.value LIKE 'GB_%'
ORDER BY op.value,o.name ;


---------------------------------Liste des entites de donnees  dans le repertoire de travail Tmp_****
 ;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Catalogue des entités de données' -- Start with top-level root
            --AND T.Package_ID = 14233
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  DISTINCT -- tobj.name , 
		objprop.value AS TABLE_NAME
		--, FULL_PATH
        FROM PackHierarchy , t_object tobj
		, t_objectproperties objprop
		where 
		--PKG_NAME = 'Tmp_IQEA_In_Progress'  -- Repertoire source de migration par systeme
        --and 
		PKG_NAME = 'Tmp_Famille_DAT_In_Progress'--'Tmp_EC_Éléments_de_configuration_In_Progress' --'Tmp_Famille_DAT_In_Progress'--
			--AND 			objprop.value = 'SG_INTERVENANT'
        and 
		tobj.Package_ID = PKG_ID
        and tobj.Object_ID = objprop.Object_ID
		       order by TABLE_NAME
;

----Liste des entite dans le catalogue:

---------------------------------Liste des entites de donnees  dans le repertoire de travail Tmp_****
 ;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Catalogue des entités de données' -- Start with top-level root
            --AND T.Package_ID = 14233
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  objprop.value AS TABLE_NAME
        FROM PackHierarchy , t_object tobj
		, t_objectproperties objprop
		where  objprop.value like 'IQ_%'
		--PKG_NAME= 'Tmp_GES_inProgress'  -- Repertoire source de migration par systeme
        --and PKG_NAME != 'Commun Cible'
        and tobj.Package_ID = PKG_ID
        and tobj.Object_ID = objprop.Object_ID
        order by TABLE_NAME;

		----------------Attribut et type
		;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Catalogue des entités de données' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT --distinct 
		tobj.name AS ENTITY_NAME,        
		objprop.value AS TABLE_NAME  , 
		atg.VALUE as COLUMN_NAME , 
		att.name , att.type, att.Length, att.Precision, att.Scale 
		PKG_NAME,		
		FULL_PATH,
		atg.Property ,
		atg.PropertyID,
		atg.ElementID
        FROM PackHierarchy , t_object tobj
		--,COUNT (objprop.value) OVER (PARTITION BYobjprop.value)
		, t_attribute att
		, t_objectproperties objprop
		, t_attributetag atg
        where PKG_NAME not like  'XXX'--'Tmp%'
       -- and PKG_NAME != 'Commun Cible'
        and tobj.Package_ID = pkg_id
        and tobj.Object_ID = att.Object_ID
        and tobj.Object_ID = objprop.Object_ID
       and att.id = atg.ElementID
      and atg.Property  in ( 'Code', 'Identifiant primaire','AutoNum','LengthType','Longueur','Obligatoire','Précision','property','Type PD original')
	 -- and REPLACE(atg.Property,' ' ,'')   in ( 'Code', 'Identifiant primaire','AutoNum','LengthType','Longueur','Obligatoire','Précision','property','Type PD original')
     --AND atg.VALUE = 'NO_BARRAGE'
		and objprop.value = 'BP_BARRAGE'
		and att.name = 'noBarrage'
        --order by TABLE_NAME --,COLUMN_NAME
		;

	

		


		;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Catalogue des entités de données' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT *
        FROM PackHierarchy
		where pkg_name = 'Actif Immobilier Barrage'; --14231

		select * from t_object where name = 'Barrage' and  package_id = 14231; --86545

		select * from t_attribute where object_id = 86545;

		select distinct type  from t_attribute

		select * from t_attribute att where object_id  =86545


	select *from t_attributetag atg  where  ElementID= 38697; 

	select * from t_objectproperties objprop where object_id = 86545;

	--Particular type:
	----------------Attribut et type
		;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Catalogue des entités de données' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT --distinct 
		tobj.name AS ENTITY_NAME,        
		objprop.value AS TABLE_NAME  , 
		atg.VALUE as COLUMN_NAME , 
		att.name , att.type, att.Length, att.Precision, att.Scale 
		PKG_NAME,		
		FULL_PATH,
		atg.Property ,
		atg.PropertyID,
		atg.ElementID
        FROM PackHierarchy , t_object tobj
		--,COUNT (objprop.value) OVER (PARTITION BYobjprop.value)
		, t_attribute att
		, t_objectproperties objprop
		, t_attributetag atg
        where PKG_NAME not like  'XXX'--'Tmp%'
       -- and PKG_NAME != 'Commun Cible'
        and tobj.Package_ID = pkg_id
        and tobj.Object_ID = att.Object_ID
        and tobj.Object_ID = objprop.Object_ID
       and att.id = atg.ElementID
      and atg.Property  in ( 'Code', 'Identifiant primaire','AutoNum','LengthType','Longueur','Obligatoire','Précision','property','Type PD original')
	 -- and REPLACE(atg.Property,' ' ,'')   in ( 'Code', 'Identifiant primaire','AutoNum','LengthType','Longueur','Obligatoire','Précision','property','Type PD original')
     --AND atg.VALUE = 'NO_BARRAGE'
		--and objprop.value = 'BP_BARRAGE'
		--and att.name = 'noBarrage'
        --order by TABLE_NAME --,COLUMN_NAME
		and att.type  IN ( 'CLOB', 'BLOB','double', 'int','java.lang.String', 'java.util.Date', 'MDSYS.SDO_GEOMETRY', 'SDO_GEOMETRY','N(14,4)','SERVICE' )
		--and att.type  like '%java%'
		;


		-- Find object in the catalogue
		 ;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Catalogue des entités de données' -- Start with top-level root
            --AND T.Package_ID = 14233
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  DISTINCT  objprop.value AS TABLE_NAME, FULL_PATH, tobj.Name
        FROM PackHierarchy , t_object tobj
		, t_objectproperties objprop
		where --PKG_NAME= 'Tmp_GES_inProgress'  -- Repertoire source de migration par systeme
        --and PKG_NAME != 'Commun Cible'
        -- FULL_PATH not like '%Temp%'
		--AND 
		tobj.Package_ID = PKG_ID
        and tobj.Object_ID = objprop.Object_ID
		and objprop.value =  'EC_CENTRE_RESPONSABILITE'
        order by TABLE_NAME

---------------------------

	SELECT * FROM t_object where name = 'EC_CENTRE_RESPONSABILITE'; --187766
	SELECT * FROM t_attribute WHERE OBJECT_ID = 187766;
	
	
		;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Catalogue des entités de données' -- Start with top-level root
            --AND T.Package_ID = 14233
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  DISTINCT '''' + objprop.value  + ''',' AS TABLE_NAME --, FULL_PATH, tobj.Name
        FROM PackHierarchy , t_object tobj
		, t_objectproperties objprop
		where PKG_NAME IN ('Tmp_Famille_RA_TG_TA__In_Progress',  -- Repertoire source de migration par systeme
      'IS_REFERENCES_SCIENTIFIQUES','RA_REFERENCES_ADMINISTRATIVES','TA_TERRITOIRES_ADMINISTRATIFS','TG_TERRITOIRES_GEOGRAPHIQUES')
	  
	  --and PKG_NAME != 'Commun Cible'
        -- FULL_PATH not like '%Temp%'
		AND 
		tobj.Package_ID = PKG_ID
        and tobj.Object_ID = objprop.Object_ID
		--and objprop.value =  'EC_CENTRE_RESPONSABILITE'
		AND  tobj.Name NOT LIKE '%XXXXX%'
		AND  tobj.Name NOT LIKE '%YYYYY%'
        order by TABLE_NAME
		;


		 ;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Catalogue des entités de données' -- Start with top-level root
            --AND T.Package_ID = 14233
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  DISTINCT  objprop.value AS TABLE_NAME, FULL_PATH, tobj.Name
        FROM PackHierarchy , t_object tobj
		, t_objectproperties objprop
		where --PKG_NAME= 'Tmp_GES_inProgress'  -- Repertoire source de migration par systeme
        --and PKG_NAME != 'Commun Cible'
        FULL_PATH not like '%Temp%'
		AND 
		tobj.Package_ID = PKG_ID
        and tobj.Object_ID = objprop.Object_ID
		--and objprop.value =  'EC_CENTRE_RESPONSABILITE'
		AND objprop.value IN
		(
		'_Ge80cMVeEfCgXs2EfTEFAQ',
'_GxEfMMVeEfCgXs2EfTEFAQ',
'_GZYX8MVeEfCgXs2EfTEFAQ',
'_HzPG0MVeEfCgXs2EfTEFAQ',
'CE_COURS_DEAU',
'CE_REGION_HYDROGRAPHIQUE',
'EC_ADRESSE',
'EC_ADRESSE_UNITE',
'EC_ARRONDISSEMENT',
'EC_ARRONDISSEMENT_GEO',
'EC_CADASTRE',
'EC_CADASTRE_QUEBEC',
'EC_CATEGORIE_ENTITE',
'EC_CATEGORIE_UNITE',
'EC_CIRCONSCRIPTION_FONCIERE',
'EC_CODE_POSTAL',
'EC_COMMUNAUTE_METRO_GEO',
'EC_DESIGNATION',
'EC_DESIGNATION_PRIMITIVE',
'EC_DESIGNATION_SECONDAIRE',
'EC_ENTITE_TOPONYME',
'EC_FEUILLET',
'EC_FEUILLET_GEO',
'EC_FONCTION',
'EC_JOUR_FERIE',
'EC_LOT',
'EC_MOUVEMENT_MUNCP',
'EC_MRC_GEO',
'EC_MUNICIPALITE_GEO',
'EC_MUNICIPALITE_RETRO_GEO',
'EC_PROVINCE_GEO',
'EC_REG_ADMIN_GEO',
'EC_STATUT',
'EC_TELEPHONE',
'EC_TOPONYME',
'EC_TYPE_ADRESSE',
'EC_TYPE_DESIGN_PRIMITIVE',
'EC_TYPE_INFRACTION',
'EC_TYPE_UNITE_ADMIN',
'EC_UNITE_ADMINISTRATIVE',
'EC_UNITE_MESURE',
'EC_UNITE_REG_ADMIN',
'ECHELLE',
'RA_ARTICLE_LOI',
'RA_ARTICLE_RDP',
'RA_ASSUJETTISSEMENT',
'RA_CODE_SCIAN',
'RA_CORRESP',
'RA_ETAT_JURIDIQUE',
'RA_FORME_JURIDIQUE',
'RA_JOURNAL_BORD',
'RA_LOI',
'RA_ORGANIGRAMME',
'RA_POINT_SERVC_APPRL_TEL',
'RA_POINT_SERVC_EMPL_ELECT',
'RA_POINT_SERVC_MUNCP',
'RA_POINT_SERVC_REG_ADMIN',
'RA_POINT_SERVC_UNITE_ADM',
'RA_POINT_SERVICE',
'RA_RDP',
'RA_SECTR_ACTVT_ECONOMIQUE',
'RA_STATUT_IMMATRICULATION',
'RA_TITRE_SCIAN',
'RA_TYPE_ADRESSE_POSTALE',
'RA_TYPE_APPAREIL_TELEPHONIE',
'RA_TYPE_RESSR_INFORMATIQUE',
'RA_TYPE_UNITE_ADRESSE',
'RA_USAGE_COORD_COMMC',
'RA_VARIABLE_TRAITEMENT',
'RA_VERSION_SCIAN',
'TA_TYPE_MOUVEMENT',
'TG_BASSIN_EGLSL',
'TG_JOURNAL_BORD',
'TG_MUNICIPALITE_20K_GEO',
'TG_TERRIT_EGLSL_20K_GEO',
'TG_TERRIT_EGLSL_GEO',
'TG_ZONE_GIE_GEO'
		)
        order by TABLE_NAME


		
------Liste des entites de donnees dans un  diagram MCD
SELECT distinct o.name, 
op.value,-- o.note,
replace(replace(replace(replace(replace(o.note, '&#233;', 'é'),'&#224;','a') ,'&#226','a'),'&#232;','e'),'&#234','e') note
--o.note  Latin1_General_100_BIN2, 
--cast(cast(o.note AS varchar(1000)) AS varchar(1000) ) Latin1_General_100_CI_AS
from t_diagramobjects DO,  t_diagram D, t_object o, t_objectproperties op
WHERE DO.diagram_id = D.diagram_id
and do.object_id = o.object_id 
and o.Object_ID = op.Object_ID
and d.name = 'RA_TG_TA_Famille_DAT'
and op.Property = 'Code'
and op.value LIKE 'RA_%'
--AND (o.name LIKE '%XXX%' OR o.name LIKE '%YYY%')
ORDER BY op.value,o.name ;


------Liste des entites de donnees dans un  diagram MCD
SELECT o.name AS Entite, 
op.value AS Table_Physique,-- o.note,
replace(replace(replace(replace(replace(o.note, '&#233;', 'é'),'&#224;','a') ,'&#226','a'),'&#232;','e'),'&#234','e') note
--o.note  Latin1_General_100_BIN2, 
--cast(cast(o.note AS varchar(1000)) AS varchar(1000) ) Latin1_General_100_CI_AS
from t_diagramobjects DO,  t_diagram D, t_object o, t_objectproperties op
WHERE DO.diagram_id = D.diagram_id
and do.object_id = o.object_id 
and o.Object_ID = op.Object_ID
and d.name = 'GBP_Gestion des Barrages'
and op.Property = 'Code'
--and op.value LIKE 'GB_%'
ORDER BY op.value,o.name ;


	-- Find object in the catalogue
		 ;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Catalogue Entités de données' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  DISTINCT  objprop.value AS TABLE_NAME, FULL_PATH, tobj.Name, tobj.Stereotype
        FROM PackHierarchy , t_object tobj
		, t_objectproperties objprop
		where --PKG_NAME= 'Tmp_GES_inProgress'  -- Repertoire source de migration par systeme
        --and PKG_NAME != 'Commun Cible'
        FULL_PATH not like '%Temp%'
		AND 
		tobj.Package_ID = PKG_ID
        and tobj.Object_ID = objprop.Object_ID
		and objprop.value LIKE  'HC_HALO_PERCENT%'
        order by TABLE_NAME;


			 ;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'EC - Éléments de configuration' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  DISTINCT  
		CASE WHEN objprop.value IS NULL  THEN tobj.Name  ELSE objprop.value  END AS TABLE_NAME, FULL_PATH, tobj.Name, tobj.Stereotype, tobj.Object_ID
        FROM PackHierarchy , t_object tobj
		, t_objectproperties objprop
		where --PKG_NAME= 'Tmp_GES_inProgress'  -- Repertoire source de migration par systeme
        --and PKG_NAME != 'Commun Cible'
        FULL_PATH not like '%Temp%'
		AND 
		tobj.Package_ID = PKG_ID
        and tobj.Object_ID = objprop.Object_ID
		and objprop.value LIKE  'RA_TYPE_APPAREIL_TELEPHONIE%'
        order by TABLE_NAME;


		Select * from t_object where name = 'CL_INFO_BLOB_TYPE_CONTRAT';

		select * from t_package where Package_ID = 7631;

		 ;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Catalogue Entités de données' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  DISTINCT  '''' +
		CASE WHEN objprop.value IS NULL  THEN tobj.Name  ELSE objprop.value   END + ''''  + ',' AS TABLE_NAME 
		--, FULL_PATH, tobj.Name, tobj.Stereotype
        FROM PackHierarchy , t_object tobj
		, t_objectproperties objprop
		where PKG_NAME= 'Tmp_BDH'  -- Repertoire source de migration par systeme
        --and PKG_NAME != 'Commun Cible'
        --FULL_PATH not like '%Temp%'
		AND tobj.Name  NOT LIKE '%XXXXX%'
		AND 
		tobj.Package_ID = PKG_ID
        and tobj.Object_ID = objprop.Object_ID
		--and objprop.value LIKE  'CL_INFO_BLOB_TYPE_CONTRAT%'
        order by TABLE_NAME;



		SELECT * FROM T_OBJECT where name = 'TYPE APPAREIL TÉLÉPHONIE';
		SELECT * FROM T_OBJECT WHERE Object_ID =185195;

		SELECT * FROM t_connector where Start_Object_ID = 185195 or End_Object_ID = 185195;

		Select * from t_connector where name = 'Supérieure future';
		--117378
		--115458

		SELECT * FROM t_obJECT where Object_ID = 215569;

		select * from t_diagramlinks;
		select * from t_diagramobjects;

	 ;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Catalogue Entités de données' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  DISTINCT 
		CASE WHEN objprop.value IS NULL  THEN tobj.Name  ELSE objprop.value   END  AS TABLE_NAME 
		, FULL_PATH, tobj.Name, tobj.Stereotype
        FROM PackHierarchy , t_object tobj
		, t_objectproperties objprop
		where --PKG_NAME= 'Tmp_BDH'  -- Repertoire source de migration par systeme
        --and PKG_NAME != 'Commun Cible'
       -- AND 
		FULL_PATH not like '%Temp%'
		--AND tobj.Name  NOT LIKE '%XXXXX%'
		AND 
		tobj.Package_ID = PKG_ID
        and tobj.Object_ID = objprop.Object_ID
		--and objprop.value LIKE  'CL_INFO_BLOB_TYPE_CONTRAT%'
       and 		objprop.value
IN
(
'BC_DEFINITION_DONNEE',
'BC_INSTRUMENT',
'BC_LIMITE_DEPASSEMENT',
'BC_STATION',
'BC_UNITE_MESURE',
'DH_CALCUL',
'DH_CODE',
'DH_COMMENTAIRE',
'DH_COURBE_TARAGE',
'DH_DEMANDE_TRAVAIL',
'DH_DONNEE_HISTORIQUE',
'DH_DROIT_PASSAGE',
'DH_ECRITURE_JOURNAL',
'DH_FACTR_CORRC',
'DH_HYDROGRAMME',
'DH_INCRT_DEPSM',
'DH_INSTRUMENT_CONSIDERE',
'DH_JAUGEAGE',
'DH_JOURNAL_BORD',
'DH_METEOGRAMME',
'DH_METHODE_JAUGEAGE',
'DH_NOTE_HYDROGRAMME',
'DH_ORGANISME',
'DH_PERD_CORRC',
'DH_PERD_VALIDATION_DONNEE',
'DH_PERSONNE_CONTACT',
'DH_PLAGE_OPERATION',
'DH_POINT_PIVOT_CORRECTION',
'DH_POINT_PIVOT_COURBE_TARAGE',
'DH_PRECS_UTILS_INCRT',
'DH_RATTC_REPR',
'DH_REPR_NIVLM',
'DH_SITE_JAUGEAGE',
'DH_STATION_HYDRIQUE',
'DH_STATION_TEL',
'DH_UNITE_TRAITEMENT',
'DH_UTILISATEUR',
'DH_VALEUR_PARAMETRE',
'DH_VARIABLE_TRAITEMENT',
'DH_ZERO_INSTRUMENT',
'EC_COORD_LOCALISATION',
'EC_EMPLOYE',
'EC_IDENTIFIANT',
'JR_FENETRE_JOURNAL'
)
 order by TABLE_NAME;


 
 select * from t_object where name = 'TH_SERVITUDE'; --218365
  select * from t_object where name = 'TH_STATUT_SERVITUDE' --218245
 SELECT * FROM t_obJECT where Object_ID = 215569;

		select * from t_diagramlinks;
		select * from t_diagramobjects where object_id = 218235;

		SELECT * FROM T_connector where start_object_id = 218235 or end_object_id = 218235;
		SELECT * FROM T_connector where start_object_id = 218245 or end_object_id = 218245;

		
		 ;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Terrier hydrique' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  DISTINCT 
		CASE WHEN objprop.value IS NULL  THEN tobj.Name  ELSE objprop.value   END  AS TABLE_NAME 
		--, FULL_PATH, tobj.Name, tobj.Stereotype
        FROM PackHierarchy , t_object tobj
		, t_objectproperties objprop
		where PKG_NAME= 'Terrier hydrique'  -- Repertoire source de migration par systeme
        --and PKG_NAME != 'Commun Cible'
        --FULL_PATH not like '%Temp%'
		AND tobj.Name  NOT LIKE '%XXXXX%'
		AND 
		tobj.Package_ID = PKG_ID
        and tobj.Object_ID = objprop.Object_ID
		--and objprop.value LIKE  'CL_INFO_BLOB_TYPE_CONTRAT%'
        order by TABLE_NAME;
	
		 ;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'STH14 - Données' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  DISTINCT tobj.Name TABLE_NAME--, TOBJ.Stereotype --, FULL_PATH
		FROM PackHierarchy , t_object tobj
		WHere PKG_NAME= 'Modèle de données'  
        AND  tobj.Package_ID = PKG_ID
		AND tobj.Name IS  NOT NULL
        order by tobj.Name;

		--Attribute 

		;WITH PackHierarchy AS (
            SELECT PACKAGE_ID AS PKG_ID , Name AS PKG_NAME,  PARENT_ID AS PKG_PARID, 1 AS Level
            FROM T_PACKAGE
            WHERE NAME = 'Temp_GDH_Retro_BD' -- Start with top-level manager
            UNION ALL
            SELECT E.PACKAGE_ID, e.Name, e.PARENT_ID, eh.Level + 1
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.parent_id = eh.PKG_ID
        )
        SELEct    objprop.value AS TABLE_NAME , ATT.NAME AS COL_NAME, atg.VALUE as COLUMN_NAME, atg.Property
        FROM PackHierarchy , t_object tobj, t_attribute att, t_objectproperties objprop, t_attributetag atg
        where PKG_NAME ='Temp_GDH_Retro_BD' 
        and tobj.Package_ID = pkg_id
        and tobj.Object_ID = att.Object_ID
        and tobj.Object_ID = objprop.Object_ID
        and att.id = atg.ElementID
        --and atg.Property = 'Code'
        --AND objprop.value LIKE 'BP_%'
		and  objprop.value = 'HC_CHOIX_VALEUR'
        order by TABLE_NAME,COLUMN_NAME;


			;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Temp_GDH_Retro_BD' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT tobj.name AS ENTITY_NAME,
        objprop.value AS TABLE_NAME , atg.VALUE as COLUMN_NAME  ,PKG_NAME, 		FULL_PATH, atg.Property
        FROM PackHierarchy , t_object tobj, t_attribute att, t_objectproperties objprop, t_attributetag atg
        where tobj.Package_ID = pkg_id
        and tobj.Object_ID = att.Object_ID
        and tobj.Object_ID = objprop.Object_ID
		and att.id = atg.ElementID
       -- and atg.Property = 'Code'
        --AND atg.VALUE = 'COLONNE_%'
		--and objprop.value = 'BP_BARRAGE'
        order by TABLE_NAME,COLUMN_NAME
        ;


		SELECT * FROM T_PACKAGE WHERE NAME = 'Temp_GDH_Retro_BD'; --39651

		SELECT obj.name as table_name , att.name as column_name 
		FROM t_object obj , t_attribute att
		WHERE obj.Package_ID = 39651
		and obj.Object_ID = att.Object_ID
		order by obj.name   , att.name  
		
		;
Select * from T_DIAGRAM where name = 'F00 - GDH_HC Marché des halocarbures - Global';

--Entite et attribute
select obj.name  AS ENTITY_NAME , objp.value AS TABLE_NAME  , att.name AS ATTRIBUTE_NAME , attg.VALUE AS COLUMN_NAME 
from t_diagramobjects diagobj , t_object obj, t_diagram diag, t_objectproperties objp, t_attribute att, t_attributetag attg
where diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name = 'F00 - GDH_HC Marché des halocarbures - Global'
and obj.Object_ID = objp.Object_ID
and objp.property = 'code'
and objp.value like 'HC_%'
and att.Object_ID = obj.Object_ID
and attg.ElementID = att.ID
and attg.Property = 'Code'
ORDER BY objp.value, attg.VALUE
;



SELECT * FROM [SPARXSYSTEM].[dbo].[t_object] obj
where name = 'IMPLICATION';

select * from t_object;
select * from [SPARXSYSTEM].[dbo].[t_attribute];


select * from [SPARXSYSTEM].[dbo].[t_diagram] as diag where diag.name = 'Temp_GDH_Retro_BD';
select * from [SPARXSYSTEM].[dbo].t_package as pack where pack.Package_ID =17794;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--TABLE ET COLONNE PHYSIQUE EA Entite dans un diagram
select obj.name  AS ENTITY_NAME --, att.name AS ATTRIBUTE_NAME , att.Scale, att.Type , att.Length, att.Precision
from [SPARXSYSTEM].[dbo].[t_diagramobjects] as  diagobj, 
[SPARXSYSTEM].[dbo].[t_object] as obj, 
[SPARXSYSTEM].[dbo].[t_diagram] as diag --,  
--[SPARXSYSTEM].[dbo].[t_attribute] as att
where diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name = 'GBP_Modèle physique_RETRO'
--and att.Object_ID = obj.Object_ID
ORDER BY obj.name--, att.name 
;


select obj.name  AS ENTITY_NAME --, att.name AS ATTRIBUTE_NAME , att.Scale, att.Type , att.Length, att.Precision
from [SPARXSYSTEM].[dbo].[t_diagramobjects] as  diagobj, 
[SPARXSYSTEM].[dbo].[t_object] as obj, 
[SPARXSYSTEM].[dbo].[t_diagram] as diag --,  
--[SPARXSYSTEM].[dbo].[t_attribute] as att
where diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name = 'MPD_Generated_From_MCD_GBP'
--and att.Object_ID = obj.Object_ID
ORDER BY obj.name--, att.name 
;

select * from  [SPARXSYSTEM].[dbo].[t_object] where name = 'GB_ACTIVITE'; --234377
select * from [SPARXSYSTEM].[dbo].[t_attribute] where Object_ID =234377;
--SELECT DISTINCT  Stereotype FROM [SPARXSYSTEM].[dbo].[t_Attribute]  WHERE Stereotype = 'PK'


--TABLE ET COLONNE PHYSIQUE EA Entite and attributes
select --OBJ.OBJECT_ID,
obj.name  AS ENTITY_NAME , att.name AS ATTRIBUTE_NAME , att.Scale, att.Type , att.Length, att.Precision
from [SPARXSYSTEM].[dbo].[t_diagramobjects] as  diagobj, 
[SPARXSYSTEM].[dbo].[t_object] as obj, 
[SPARXSYSTEM].[dbo].[t_diagram] as diag,  
[SPARXSYSTEM].[dbo].[t_attribute] as att
where diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name = 'GBP_Modèle physique_RETRO'
and att.Object_ID = obj.Object_ID
AND OBJ.NAME = 'GB_ACTIVITE'
ORDER BY obj.name, att.name ;





;


select --OBJ.OBJECT_ID,
obj.name  AS ENTITY_NAME , att.name AS ATTRIBUTE_NAME , att.Scale, att.Type , att.Length, att.Precision
from [SPARXSYSTEM].[dbo].[t_diagramobjects] as  diagobj, 
[SPARXSYSTEM].[dbo].[t_object] as obj, 
[SPARXSYSTEM].[dbo].[t_diagram] as diag,  
[SPARXSYSTEM].[dbo].[t_attribute] as att
where diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name = 'MPD_Generated_From_MCD_GBP'
and att.Object_ID = obj.Object_ID
AND  obj.name like 'GB_%'
AND OBJ.NAME = 'GB_ACTIVITE'
ORDER BY obj.name, att.name ;

---------------------------------------------------------attribut left outer join ------------------------


--TABLE AND COLUMN AND TYPE FROM REVERSED AND GENERATED

SELECT 
CASE 
WHEN (R_ENTITY_NAME IS NOT NULL AND G_ENTITY_NAME IS NULL) THEN 'MAST BE CREATED'
WHEN (R_ENTITY_NAME IS  NULL AND G_ENTITY_NAME IS NOT NULL) THEN 'MAST BE DELETED' 
WHEN (R_TYPE != G_TYPE) THEN 'DATA TYPE ISSUE' 
WHEN (ISNULL(R_LENGTH,-5) != ISNULL(G_LENGTH,-5)) THEN 'LENGTH ISSUE' 
WHEN (ISNULL(R_PRECISION,-5) != ISNULL(G_PRECISION,-5)) THEN 'PRECSION ISSUE' 
WHEN (ISNULL(R_SCALE,-5) != ISNULL(G_SCALE,-5)) THEN 'SCALE ISSUE' 
ELSE 'OKKKKKKKK'
END AS OPERATION_TO_DO  ,
X.* FROM 
(
SELECT V_RETRO.*, V_GEN.* FROM 
(
select --OBJ.OBJECT_ID,
obj.name  AS R_ENTITY_NAME , att.name AS R_ATTRIBUTE_NAME , att.Scale AS R_SCALE, att.Type AS R_TYPE , att.Length AS R_LENGTH, att.Precision AS R_PRECISION
from [SPARXSYSTEM].[dbo].[t_diagramobjects] as  diagobj, 
[SPARXSYSTEM].[dbo].[t_object] as obj, 
[SPARXSYSTEM].[dbo].[t_diagram] as diag,  
[SPARXSYSTEM].[dbo].[t_attribute] as att
where diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name IN ( 'SG_MPD_RETRO')
and att.Object_ID = obj.Object_ID
--AND OBJ.NAME = 'SG_ADRESSE_LIEU'
--ORDER BY obj.name, att.name
) AS V_RETRO
FULL OUTER JOIN 
(
Select --OBJ.OBJECT_ID,
obj.name  AS G_ENTITY_NAME , att.name AS G_ATTRIBUTE_NAME , att.Scale AS G_SCALE, att.Type AS G_TYPE , att.Length AS G_LENGTH, att.Precision AS G_PRECISION
from [SPARXSYSTEM].[dbo].[t_diagramobjects] as  diagobj, 
[SPARXSYSTEM].[dbo].[t_object] as obj, 
[SPARXSYSTEM].[dbo].[t_diagram] as diag,  
[SPARXSYSTEM].[dbo].[t_attribute] as att
where diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name IN ( 'SG_MPD_GENER')
and att.Object_ID = obj.Object_ID
AND  obj.name like 'SG_%'
--AND OBJ.NAME = 'GB_ACTIVITE'
--ORDER BY obj.name, att.name 
) AS V_GEN 
ON  R_ENTITY_NAME = G_ENTITY_NAME AND R_ATTRIBUTE_NAME = G_ATTRIBUTE_NAME
) X
WHERE 1=1
--R_ENTITY_NAME NOT LIKE '%_ZZ_%'
--AND (R_ENTITY_NAME  IS NULL OR  G_ENTITY_NAME IS NULL )
--AND R_TYPE = 'NUMBER' AND R_PRECISION != G_PRECISION
--(R_ENTITY_NAME  IS NULL OR  G_ENTITY_NAME IS NULL )--'GB_BARRAGE_INTERET_STATION' )
--AND 
--AND (R_TYPE != G_TYPE OR R_LENGTH != G_LENGTH OR R_PRECISION != G_PRECISION OR R_SCALE != G_SCALE)
--AND (R_ENTITY_NAME ='GB_CALCUL' or  G_ENTITY_NAME ='GB_CALCUL') --'GB_BARRAGE_INTERET_STATION' )
--(G_TYPE  != R_TYPE)
--(G_TYPE  = R_TYPE) AND (G_PRECISION != R_PRECISION)
--AND 
--(R_LENGTH != G_LENGTH)
;


--------------
select --OBJ.OBJECT_ID,
obj.name  AS R_ENTITY_NAME , att.name AS R_ATTRIBUTE_NAME , att.Scale AS R_SCALE, att.Type AS R_TYPE , att.Length AS R_LENGTH, att.Precision AS R_PRECISION
from [SPARXSYSTEM].[dbo].[t_diagramobjects] as  diagobj, 
[SPARXSYSTEM].[dbo].[t_object] as obj, 
[SPARXSYSTEM].[dbo].[t_diagram] as diag,  
[SPARXSYSTEM].[dbo].[t_attribute] as att
where diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name IN ( 'SG_MPD_RETRO')
and att.Object_ID = obj.Object_ID
AND OBJ.NAME = 'SG_ADRESSE_LIEU'


select --OBJ.OBJECT_ID,
obj.name  AS R_ENTITY_NAME , att.name AS R_ATTRIBUTE_NAME , att.Scale AS R_SCALE, att.Type AS R_TYPE , att.Length AS R_LENGTH, att.Precision AS R_PRECISION
from [SPARXSYSTEM].[dbo].[t_diagramobjects] as  diagobj, 
[SPARXSYSTEM].[dbo].[t_object] as obj, 
[SPARXSYSTEM].[dbo].[t_diagram] as diag,  
[SPARXSYSTEM].[dbo].[t_attribute] as att
where diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name IN ( 'SG_MPD_GENER')
and att.Object_ID = obj.Object_ID
AND OBJ.NAME = 'SG_ADRESSE_LIEU'


---------------------------------------



SELECT * FROM (
SELECT 
CASE 
WHEN (R_ENTITY_NAME IS NOT NULL AND G_ENTITY_NAME IS NULL) THEN 'MAST BE CREATED'
WHEN (R_ENTITY_NAME IS  NULL AND G_ENTITY_NAME IS NOT NULL) THEN 'MAST BE DELETED' 
WHEN (R_TYPE != G_TYPE) THEN 'DATA TYPE ISSUE' 
WHEN (ISNULL(R_LENGTH,-5) != ISNULL(G_LENGTH,-5)) THEN 'LENGTH ISSUE' 
WHEN (ISNULL(R_PRECISION,-5) != ISNULL(G_PRECISION,-5)) THEN 'PRECSION ISSUE' 
WHEN (ISNULL(R_SCALE,-5) != ISNULL(G_SCALE,-5)) THEN 'SCALE ISSUE' 
ELSE 'OKKKKKKKK'
END AS OPERATION_TO_DO  ,
X.* FROM 
(
SELECT V_RETRO.*, V_GEN.* FROM 
(
select --OBJ.OBJECT_ID,
obj.name  AS R_ENTITY_NAME , att.name AS R_ATTRIBUTE_NAME , att.Scale AS R_SCALE, att.Type AS R_TYPE , att.Length AS R_LENGTH, att.Precision AS R_PRECISION
from [SPARXSYSTEM].[dbo].[t_diagramobjects] as  diagobj, 
[SPARXSYSTEM].[dbo].[t_object] as obj, 
[SPARXSYSTEM].[dbo].[t_diagram] as diag,  
[SPARXSYSTEM].[dbo].[t_attribute] as att
where diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name IN ( 'SE_MPD_RETRO')
and att.Object_ID = obj.Object_ID
--AND OBJ.NAME = 'SG_ACTIVITE'
--ORDER BY obj.name, att.name
) AS V_RETRO
FULL OUTER JOIN 
(
Select --OBJ.OBJECT_ID,
obj.name  AS G_ENTITY_NAME , att.name AS G_ATTRIBUTE_NAME , att.Scale AS G_SCALE, att.Type AS G_TYPE , att.Length AS G_LENGTH, att.Precision AS G_PRECISION
from [SPARXSYSTEM].[dbo].[t_diagramobjects] as  diagobj, 
[SPARXSYSTEM].[dbo].[t_object] as obj, 
[SPARXSYSTEM].[dbo].[t_diagram] as diag,  
[SPARXSYSTEM].[dbo].[t_attribute] as att
where diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name IN ( 'SE_MPD_GENER')
and att.Object_ID = obj.Object_ID
AND  obj.name like 'SE_%'
--AND obj.name not like '[ZZ]%' 
--AND OBJ.NAME = 'SG_ACTIVITE'
--ORDER BY obj.name, att.name 
) AS V_GEN 
ON  R_ENTITY_NAME = G_ENTITY_NAME AND R_ATTRIBUTE_NAME = G_ATTRIBUTE_NAME
) X
WHERE 1=1
) XX
WHERE  --XX.R_ENTITY_NAME NOT LIKE '%ZZ%'
--AND
XX.OPERATION_TO_DO  IN ('MAST BE CREATED' , 'MAST BE DELETED'--,'OKKKKKKKK'
)
AND 
(R_ENTITY_NAME = 'SE_COMPOSANTE' OR   G_ENTITY_NAME = 'SE_COMPOSANTE' )
;



 ;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM   [SPARXSYSTEM].[dbo].[T_PACKAGE] t
            WHERE t.NAME = 'Catalogue Entités de données' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM [SPARXSYSTEM].[dbo].[T_PACKAGE] e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  DISTINCT tobj.Object_ID,  tobj.NAME, objprop.value AS TABLE_NAME, FULL_PATH, tobj.Name, tobj.Stereotype
        FROM  PackHierarchy  , 
		[SPARXSYSTEM].[dbo].[t_object] tobj
		, [SPARXSYSTEM].[dbo].[t_objectproperties] objprop
		where --PKG_NAME = 'Modèle conceptuel de données'  -- Repertoire source de migration par systeme
        --PKG_NAME = 'Modèle physique_RETRO'
        --FULL_PATH not like '%Temp%'
		--AND 
			tobj.Package_ID = PKG_ID
        and tobj.Object_ID = objprop.Object_ID

			and objprop.value LIKE  '%DH_CODE%'
        order by TABLE_NAME;

select att.Name as PK_Name, obj.Name as Table_Name
from [SPARXSYSTEM].[dbo].[t_attribute] att
join [SPARXSYSTEM].[dbo].[t_object] obj on att.Object_ID = obj.Object_ID
where att.PK = 1 and obj.Stereotype = 'table'

select * from [SPARXSYSTEM].[dbo].[t_object]  where object_id = 234377;--234940 ;
Select * from [SPARXSYSTEM].[dbo].[t_attribute] where object_id = 234377;--234940;

SELECT * FROM [SPARXSYSTEM].[dbo].[t_attribute]  WHERE Stereotype = 'PK';
SELECT * FROM [SPARXSYSTEM].[dbo].[t_attribute] WHERE NAME = 'NO_SEQ_ACTVT';
SELECT * FROM [SPARXSYSTEM].[dbo].[t_operation] where Stereotype IN ( 'PK', 'FK','unique','check') and object_id = 234377;
SELECT DISTINCT Stereotype  FROM  [SPARXSYSTEM].[dbo].[t_operation]

select * from [SPARXSYSTEM].[dbo].[t_operationparams] where OperationID = 10302;


SELECT obj.name AS G_TABLE, OP.Stereotype AS G_CONSTRAINT, OPPAR.NAME  AS G_COLUMN FROM 
[SPARXSYSTEM].[dbo].[t_OBJECT] obj, 
[SPARXSYSTEM].[dbo].[t_operation] op , 
[SPARXSYSTEM].[dbo].[t_operationparams] oppar ,
[SPARXSYSTEM].[dbo].[t_diagramobjects] as  diagobj, 
[SPARXSYSTEM].[dbo].[t_diagram] as diag
WHERE OBJ.Object_ID = OP.Object_ID
and op.operationid = oppar.operationid 
AND op.Stereotype IN ( 'PK', 'FK','unique','check')
AND  diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name = 'MPD_Generated_From_MCD_GBP'
AND obj.name LIKE 'GB_CALCUL%'
--and obj.name LIKE 'GB_CALCUL%'
--AND OPPAR.NAME LIKE '%CALCUL%'
;


--Entity Constraints reversed versus generated
SELECT * FROM (
SELECT * FROM 
(
SELECT R.* , G.* FROM (
SELECT obj.name AS R_TABLE, OP.Stereotype AS R_CONSTRAINT, OPPAR.NAME  AS R_COLUMN FROM 
[SPARXSYSTEM].[dbo].[t_OBJECT] obj, 
[SPARXSYSTEM].[dbo].[t_operation] op , 
[SPARXSYSTEM].[dbo].[t_operationparams] oppar ,
[SPARXSYSTEM].[dbo].[t_diagramobjects] as  diagobj, 
[SPARXSYSTEM].[dbo].[t_diagram] as diag
WHERE OBJ.Object_ID = OP.Object_ID
and op.operationid = oppar.operationid 
AND op.Stereotype IN ( 'PK', 'FK')--,'unique','check')
AND  diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name = 'SG_MPD_RETRO'
--ORDER BY obj.name
) R FULL OUTER JOIN 
(
SELECT obj.name AS G_TABLE, OP.Stereotype AS G_CONSTRAINT, OPPAR.NAME  AS G_COLUMN FROM 
[SPARXSYSTEM].[dbo].[t_OBJECT] obj, 
[SPARXSYSTEM].[dbo].[t_operation] op , 
[SPARXSYSTEM].[dbo].[t_operationparams] oppar ,
[SPARXSYSTEM].[dbo].[t_diagramobjects] as  diagobj, 
[SPARXSYSTEM].[dbo].[t_diagram] as diag
WHERE OBJ.Object_ID = OP.Object_ID
and op.operationid = oppar.operationid 
AND op.Stereotype IN ( 'PK', 'FK' )--,'unique','check')
AND  diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name = 'SG_MPD_GENER'
AND obj.name LIKE 'SG_%'
) G
ON (R.R_TABLE = G.G_TABLE AND R.R_CONSTRAINT = G.G_CONSTRAINT AND R.R_COLUMN = G.G_COLUMN)
) X
WHERE   (ISNULL(X.R_TABLE,'ABC') != ISNULL(X.G_TABLE,'EFG') OR   ISNULL(X.R_CONSTRAINT,'ABC') != ISNULL(X.G_CONSTRAINT,'EFG')  OR ISNULL(X.R_COLUMN,'ABC') !=  ISNULL(X.G_COLUMN,'EFG'))
) Y ---WHERE  (Y.R_TABLE = 'SG_PERS_CONTACT_TEL_INTRV' OR  Y.G_TABLE = 'SG_PERS_CONTACT_TEL_INTRV')
;

--Ecart entre entite dans un MPD
SELECT R.* , G.* FROM (
SELECT obj.name AS R_TABLE
FROM
[SPARXSYSTEM].[dbo].[t_OBJECT] obj, 
[SPARXSYSTEM].[dbo].[t_diagramobjects] as  diagobj, 
[SPARXSYSTEM].[dbo].[t_diagram] as diag
WHERE   diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name = 'SE_MPD_RETRO'
--ORDER BY obj.name
) R FULL OUTER JOIN 
(
SELECT obj.name AS G_TABLE
FROM
[SPARXSYSTEM].[dbo].[t_OBJECT] obj, 
[SPARXSYSTEM].[dbo].[t_diagramobjects] as  diagobj, 
[SPARXSYSTEM].[dbo].[t_diagram] as diag
WHERE 
 diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name = 'SE_MPD_GENER'
AND obj.name LIKE 'SE_%'
) G
ON (R.R_TABLE = G.G_TABLE )

WHERE   G_TABLE IS NULL
AND R_TABLE NOT LIKE '%ZZ_%';



--Constraint using Union between reverse and generate-----------------------------------------------------


SELECT * FROM (
SELECT 'REVERSED' AS TYP_MCD , obj.name AS TABLE_, OP.Stereotype AS CONSTRAINT_, OPPAR.NAME  AS COLUMN_ FROM 
[SPARXSYSTEM].[dbo].[t_OBJECT] obj, 
[SPARXSYSTEM].[dbo].[t_operation] op , 
[SPARXSYSTEM].[dbo].[t_operationparams] oppar ,
[SPARXSYSTEM].[dbo].[t_diagramobjects] as  diagobj, 
[SPARXSYSTEM].[dbo].[t_diagram] as diag
WHERE OBJ.Object_ID = OP.Object_ID
and op.operationid = oppar.operationid 
AND op.Stereotype IN ( 'PK', 'FK','unique','check')
AND  diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name IN ( 'SE_MPD_RETRO','')
--AND obj.name LIKE 'SG_FICHE_MILIEU_HUMIDE'
--ORDER BY obj.name
UNION ALL 
SELECT  'GENERATED' AS TYP_MCD ,obj.name AS G_TABLE, OP.Stereotype AS G_CONSTRAINT, OPPAR.NAME  AS G_COLUMN FROM 
[SPARXSYSTEM].[dbo].[t_OBJECT] obj, 
[SPARXSYSTEM].[dbo].[t_operation] op , 
[SPARXSYSTEM].[dbo].[t_operationparams] oppar ,
[SPARXSYSTEM].[dbo].[t_diagramobjects] as  diagobj, 
[SPARXSYSTEM].[dbo].[t_diagram] as diag
WHERE OBJ.Object_ID = OP.Object_ID
and op.operationid = oppar.operationid 
AND op.Stereotype IN ( 'PK', 'FK','unique','check')
AND  diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name IN ( 'SE_MPD_GENER','')
--AND obj.name LIKE 'SG_FICHE_MILIEU_HUMIDE'
) v
--WHERE V.TABLE_ = 'SG_CONCL_ADRESSE_LIEU'
ORDER BY TABLE_, COLUMN_
--WHERE (R.R_TABLE = G.G_TABLE AND R.R_CONSTRAINT = G.G_CONSTRAINT AND R.R_COLUMN = G.G_COLUMN)
--WHERE TABLE_ = 'SE_COMPOSANTE'

;



SELECT * FROM [SPARXSYSTEM].[dbo].[t_operation] ;
SELECT * FROM [SPARXSYSTEM].[dbo].[t_operationparams] ;

SELECT obj.name AS G_TABLE, OP.Stereotype AS G_CONSTRAINT, OPPAR.NAME  AS G_COLUMN , oppar.Pos + 1 AS POSTITION
FROM 
[SPARXSYSTEM].[dbo].[t_OBJECT] obj, 
[SPARXSYSTEM].[dbo].[t_operation] op , 
[SPARXSYSTEM].[dbo].[t_operationparams] oppar ,
[SPARXSYSTEM].[dbo].[t_diagramobjects] as  diagobj, 
[SPARXSYSTEM].[dbo].[t_diagram] as diag
WHERE OBJ.Object_ID = OP.Object_ID
and op.operationid = oppar.operationid 
AND op.Stereotype IN ( 'PK', 'FK','unique','check')
AND  diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name = 'SG_MPD_GENER'
AND obj.name LIKE 'SG_%'
and obj.name ='SG_DOCUMENT_COMPOSANTE'
AND op.Stereotype  = 'FK'
ORDER BY G_TABLE,  op.name, POSTITION
;


SELECT obj.name AS G_TABLE, OP.Stereotype AS G_CONSTRAINT, OPPAR.NAME  AS G_COLUMN , oppar.Pos + 1 AS POSTITION
FROM 
[SPARXSYSTEM].[dbo].[t_OBJECT] obj, 
[SPARXSYSTEM].[dbo].[t_operation] op , 
[SPARXSYSTEM].[dbo].[t_operationparams] oppar ,
[SPARXSYSTEM].[dbo].[t_diagramobjects] as  diagobj, 
[SPARXSYSTEM].[dbo].[t_diagram] as diag
WHERE OBJ.Object_ID = OP.Object_ID
and op.operationid = oppar.operationid 
AND op.Stereotype IN ( 'PK', 'FK','unique','check')
AND  diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name = 'SG_MPD_RETRO'
AND obj.name LIKE 'SG_%'
and obj.name ='SG_DOCUMENT_COMPOSANTE'
AND op.Stereotype  = 'FK'
ORDER BY G_TABLE,  op.name, POSTITION
;

SELECT 'REVERSED' AS TYP_MCD , obj.name AS TABLE_, OP.Stereotype AS CONSTRAINT_, OPPAR.NAME  AS COLUMN_ FROM 
[SPARXSYSTEM].[dbo].[t_OBJECT] obj, 
[SPARXSYSTEM].[dbo].[t_operation] op , 
[SPARXSYSTEM].[dbo].[t_operationparams] oppar ,
[SPARXSYSTEM].[dbo].[t_diagramobjects] as  diagobj, 
[SPARXSYSTEM].[dbo].[t_diagram] as diag
WHERE OBJ.Object_ID = OP.Object_ID
and op.operationid = oppar.operationid 
AND op.Stereotype IN ( 'PK', 'FK','unique','check')
AND  diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name IN ( 'SG_MPD_RETRO','')
AND obj.name =  'SG_CONCL_ADRESSE_LIEU'

;


SELECT  'GENERATED' AS TYP_MCD ,obj.name AS G_TABLE, OP.Stereotype AS G_CONSTRAINT, OPPAR.NAME  AS G_COLUMN FROM 
[SPARXSYSTEM].[dbo].[t_OBJECT] obj, 
[SPARXSYSTEM].[dbo].[t_operation] op , 
[SPARXSYSTEM].[dbo].[t_operationparams] oppar ,
[SPARXSYSTEM].[dbo].[t_diagramobjects] as  diagobj, 
[SPARXSYSTEM].[dbo].[t_diagram] as diag
WHERE OBJ.Object_ID = OP.Object_ID
and op.operationid = oppar.operationid 
AND op.Stereotype IN ( 'PK', 'FK','unique','check')
AND  diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name IN ( 'SG_MPD_GENER','')
AND obj.name =  'SG_CONCL_ADRESSE_LIEU';

SELECT * FROM [SPARXSYSTEM].[dbo].[t_OBJECT] obj  where obj.Stereotype like '%DMU%';
SELECT * FROM [SPARXSYSTEM].[dbo].[t_objectproperties] objprop  where obj.Stereotype like '%DMU%';

--Liste des DMUs Mai 2026
SELECT  distinct obj.name,   
replace(replace(replace(replace(replace(replace(replace(OBJ.note, '&#233;', 'é'),'&#224;','a') ,'&#226;','a'),'&#232;','e'),'&#234;','e'), '&#201;','e'), '&#249;', 'ù' ) Note_Commentaire 
FROM [SPARXSYSTEM].[dbo].[t_OBJECT] obj,
[SPARXSYSTEM].[dbo].[t_objectproperties]  objprop 
where obj.Object_ID = objprop.object_id
AND 
objprop.property = 'Possession' and objprop.Value='DMU'
AND UPPER(obj.name) like '%CHEL%';

-- Composite Key
select op.name , count(1) FROM [SPARXSYSTEM].[dbo].[t_operation] op , [SPARXSYSTEM].[dbo].[t_operationparams] oppar 
where op.Stereotype = 'PK'
and op.operationid = oppar.operationid
group by op.name
having count(1) != 1
;

SELECT * FROM [SPARXSYSTEM].[dbo].[t_OBJECT] obj WHERE obj.name = 'Activite'


	SELECT * FROM [SPARXSYSTEM].[dbo].[t_attributetag] where ElementID in (245300,245301,245302,245303
	--242013,242014,242015,242016,242017
	
	) and property in (
		'Code',
'Identifiant primaire',
'Longueur',
'Obligatoire',
'Précision',
'Type PD original','LengthType','Cdm2PdmOriginAttrId'
);

select * from [SPARXSYSTEM].[dbo].[t_attributeconstraints];


SELECT * FROM [SPARXSYSTEM].[dbo].[t_attributetag] attg;


--PIVOT ATT TAG
select Elementid , Code, Identifiantprimaire, Longueur, Obligatoire, Précision, TypePDoriginal
from
(
  select tatt.ElementID, tatt.value, tatt.property
  from [SPARXSYSTEM].[dbo].[t_attributetag] Tatt where ElementID in (84278,84279,84280)
) d
pivot
(
  max(value)
  for property in (Code, Identifiantprimaire, Longueur, Obligatoire, Précision, TypePDoriginal)
) piv;
- 
 ---Data Type with java !!!!! Or Double
 ;WITH PackHierarchy AS (
          SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM  [SPARXSYSTEM].[dbo].[T_PACKAGE]  t
            WHERE t.NAME =  'Catalogue Entités de données' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM [SPARXSYSTEM].[dbo].[T_PACKAGE] e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT --PKG_ID , PKG_NAME, PKG_PARID, tobj.name,
       -- 'Entreprise Architect' as SYSTEME ,        'HC'
        --AS CODE_SYSTEME , 'SPARXSYSTEM' AS DB_SOURCE, 'SQL Server' AS DB_TYPE,
        tobj.name as Entity_name , objprop.value AS TABLE_NAME , atg.VALUE as COLUMN_NAME, atg.Property, att.Type, FULL_PATH
        FROM PackHierarchy , 
		[SPARXSYSTEM].[dbo].[t_object]  tobj, 
		[SPARXSYSTEM].[dbo].[t_attribute]   att, 
		[SPARXSYSTEM].[dbo].[t_objectproperties]    objprop, 
		[SPARXSYSTEM].[dbo].[t_attributetag]  atg
        where 
		--PKG_NAME not like 'Tmp%'
       -- and 
		PKG_NAME != 'Commun Cible'
        and tobj.Package_ID = pkg_id
        and tobj.Object_ID = att.Object_ID
        and tobj.Object_ID = objprop.Object_ID
        and att.id = atg.ElementID
        and atg.Property = 'Code'
        --AND objprop.value LIKE         'GB_ACTIVITE%'
		--and att.Type like '%java%'
		and att.Type like '%double%'
		--AND  objprop.value like 'SG_%'
		and tobj.name not like '%XXXXX%'
		and tobj.name not like '%YYYYY%'
		--and atg.VALUE = 'DATE_MAJ_NOM_CIDREQ'
        order by TABLE_NAME,COLUMN_NAME
        ;


		SELECT * FROM T_CONNECTOR where name = 'EST_DEPOSE_PAR';

		select distinct DiagramID  from t_connector  order by DiagramID;


		select * from t_diagram where name = 'F00 - GDH_HC Marché des halocarbures - Global'; -- 28455

		select * from t_diagramlinks where DiagramID = '28455';

		select * from t_diagramobjects where Diagram_ID = '28455';

		Select distinct --con.Start_Object_ID, con.End_Object_ID, 
		con.SourceCard, con.DestCard, objsrc.name as source_object, objdest.name as dest_object , con.name, con.Direction
		from  t_connector con, t_object objsrc, t_object objdest, t_diagramobjects diagobj , t_diagram diag, t_diagramlinks diaglink
		where con.Start_Object_ID = objsrc.Object_ID
		and con.End_Object_ID = objdest.Object_ID
		and ( diagobj.Object_ID = con.Start_Object_ID or diagobj.Object_ID = con.End_Object_ID)
		and diagobj.Diagram_ID = diag.Diagram_ID
		and diag.name = 'GES_Émission des véhicules automobiles'
		--and (objsrc.name = 'CHOIX VALEUR' or objdest.name ='CHOIX VALEUR')
		--and (con.SourceCard like '%*%' AND con.DestCard like '%*%' )
		and diaglink.ConnectorID = con.Connector_ID
		and diaglink.DiagramID = diag.Diagram_ID 
		--and diagobj.Object_ID = obj.object_id
		;

		SELECT obj.name , diag.name as diagram_name  FROM t_diagram diag , t_diagramobjects diagobj  , t_object obj
		where diag.name = 'F00 - GDH_HC Marché des halocarbures - Global' and diag.Diagram_ID = diagobj.Diagram_ID
		and obj.Object_ID = diagobj.Object_ID
		;

		select * from t_diagram;
		select * from t_diagramobjects;
		select * from t_diagramlinks;
		select * from t_connector
		


		select * from t_connector where name  = 'Est associé à';
		--[SPARXSYSTEM].[dbo].[t_object]
		--------------------Composite Association per diagram -------------
		;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM  [SPARXSYSTEM].[dbo].[T_PACKAGE]  t
            WHERE t.NAME = 'Modele conceptuel de données - MCDs' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM [SPARXSYSTEM].[dbo].[T_PACKAGE] e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  distinct PKG_NAME, --PKG_ID, 
		d.name AS DIAGRAM_NAME, TT.VALUE as TABLE_PHYSIQUE, t.NAME AS CONNECTOR_NAME, t.subtype,
		(SELECT name from [SPARXSYSTEM].[dbo].[t_object] t_object where object_id = T.start_object_id ) as ENTITY_START,
(SELECT name from  [SPARXSYSTEM].[dbo].[t_object] t_object where object_id = T.end_object_id ) as ENTITY_END, t.*
        FROM PackHierarchy ,  [SPARXSYSTEM].[dbo].[t_diagram]  d, [SPARXSYSTEM].[dbo].[T_CONNECTOR]  T ,
		[SPARXSYSTEM].[dbo].[t_connectortag]  TT, [SPARXSYSTEM].[dbo].[t_diagramlinks]  dl
		where --PKG_NAME not like 'Tmp%'
        --and
		PKG_NAME != 'Commun Cible'
		and d.Package_ID = PKG_ID
		--and UPPER(D.NAME) NOT LIKE '%SOURCE%'
		AND T.Connector_ID = TT.ElementID
and dl.ConnectorID = t.Connector_ID
and d.Diagram_ID = dl.DiagramID
AND TT.Property = 'Code'
--and t.SubType = 'Weak'
and d.name  IN
('SEBP_Securite et entretien des barrages' --'GBP_Gestion des Barrages'
--, 'EPL_Environnement_Plage'
)-- 'SEBP_Securite et entretien des barrages_cible'
--and TT.VALUE is not null
--and  t.name = 'Utilise'
--AND ( t.SourceIsAggregate = 2 or t.DestIsAggregate = 2) -- For composite link
AND SourceCard LIKE '%*%' AND DestCard LIKE '%*%'
--AND ENTITY_START ='SG_INTERVENANT'
ORDER BY ENTITY_START
;


;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM  [SPARXSYSTEM].[dbo].[T_PACKAGE]  t
            WHERE t.NAME = 'Modele conceptuel de données - MCDs' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM [SPARXSYSTEM].[dbo].[T_PACKAGE] e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  distinct PKG_NAME, --PKG_ID, 
		d.name AS DIAGRAM_NAME, TT.VALUE as TABLE_PHYSIQUE, t.NAME AS CONNECTOR_NAME, t.subtype,
		(SELECT name from [SPARXSYSTEM].[dbo].[t_object] t_object where object_id = T.start_object_id ) as ENTITY_START,
(SELECT name from  [SPARXSYSTEM].[dbo].[t_object] t_object where object_id = T.end_object_id ) as ENTITY_END, t.*
        FROM PackHierarchy ,  [SPARXSYSTEM].[dbo].[t_diagram]  d, [SPARXSYSTEM].[dbo].[T_CONNECTOR]  T ,
		[SPARXSYSTEM].[dbo].[t_connectortag]  TT, [SPARXSYSTEM].[dbo].[t_diagramlinks]  dl
		where PKG_NAME != 'Commun Cible'
		and d.Package_ID = PKG_ID
		AND T.Connector_ID = TT.ElementID
and dl.ConnectorID = t.Connector_ID
and d.Diagram_ID = dl.DiagramID
AND TT.Property = 'Code'
and d.name  IN
('SEBP_Securite et entretien des barrages' )
AND ( t.SourceIsAggregate = 2 or t.DestIsAggregate = 2)
ORDER BY ENTITY_START
;


	;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM  [SPARXSYSTEM].[dbo].[T_PACKAGE]  t
            WHERE t.NAME = 'Modele conceptuel de données - MCDs' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM [SPARXSYSTEM].[dbo].[T_PACKAGE] e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  distinct PKG_NAME, --PKG_ID, 
		d.name AS DIAGRAM_NAME, TT.VALUE as TABLE_PHYSIQUE, t.NAME AS CONNECTOR_NAME, t.subtype,
		(SELECT name from [SPARXSYSTEM].[dbo].[t_object] t_object where object_id = T.start_object_id ) as ENTITY_START,
(SELECT name from  [SPARXSYSTEM].[dbo].[t_object] t_object where object_id = T.end_object_id ) as ENTITY_END --, t.*
        FROM PackHierarchy ,  [SPARXSYSTEM].[dbo].[t_diagram]  d, [SPARXSYSTEM].[dbo].[T_CONNECTOR]  T ,
		[SPARXSYSTEM].[dbo].[t_connectortag]  TT, [SPARXSYSTEM].[dbo].[t_diagramlinks]  dl
		where --PKG_NAME not like 'Tmp%'
        --and
		PKG_NAME != 'Commun Cible'
		and d.Package_ID = PKG_ID
		--and UPPER(D.NAME) NOT LIKE '%SOURCE%'
		AND T.Connector_ID = TT.ElementID
and dl.ConnectorID = t.Connector_ID
and d.Diagram_ID = dl.DiagramID
AND TT.Property = 'Code'
--and t.SubType = 'Weak'
and d.name IN
('SG_Sago' --'GBP_Gestion des Barrages'
--, 'EPL_Environnement_Plage'
)-- 'SEBP_Securite et entretien des barrages_cible'
--and TT.VALUE is not null
--and  t.name = 'Utilise'
--AND ( t.SourceIsAggregate = 2 or t.DestIsAggregate = 2) -- For composite link
--AND SourceCard LIKE '%*%' AND DestCard LIKE '%*%'
--AND ENTITY_START ='SG_INTERVENANT'
ORDER BY ENTITY_START


SELECT * FROM [SPARXSYSTEM].[dbo].[t_diagram]  d WHERE D.NAME = 'SG_Sago';


SELECT * FROM (
SELECT D.name as DIGARMA_NAME , t.name AS Connector_name,
(SELECT name from t_object where object_id = T.start_object_id ) as ENTITY_START,
(SELECT name from t_object where object_id = T.end_object_id ) as ENTITY_end, T.Connector_Type,T.SubType
FROM T_CONNECTOR T , t_diagramlinks dl, t_diagram d -- , t_connectortag TT
WHERE 
 dl.ConnectorID = t.Connector_ID
and d.Diagram_ID = dl.DiagramID
--AND T.NAME =  'Est Affecte'
and d.name =  'F00 - GDH_HC Marché des halocarbures - Global'--'SEBP_Securite et entretien des barrages_cible'
--AND SourceCard LIKE '%*%' AND DestCard LIKE '%*%'
AND T.Connector_Type ='Association' and T.SubType = 'Class'
--and T.Connector_ID = TT.ElementID
--and TT.Property = 'Code'
AND t.name is not null
) V WHERE ENTITY_START NOT LIKE '%XXXXX%'
AND ENTITY_END NOT LIKE '%XXXXX%'
AND ENTITY_START NOT LIKE '%YYYYY%'
AND ENTITY_END NOT LIKE '%YYYYY%'
AND UPPER(DIGARMA_NAME) NOT LIKE '%SOURCE%'
ORDER BY DIGARMA_NAME;


-- Objet commun liaison 
Select distinct --con.Start_Object_ID, con.End_Object_ID, 
		con.SourceCard, con.DestCard, objsrc.name as source_object, objdest.name as dest_object , con.name, con.Direction, con.Connector_Type, con.SubType, con.Stereotype
		from  t_connector con, t_object objsrc, t_object objdest, t_diagramobjects diagobj , t_diagram diag, t_diagramlinks diaglink
		where con.Start_Object_ID = objsrc.Object_ID
		and con.End_Object_ID = objdest.Object_ID
		and ( diagobj.Object_ID = con.Start_Object_ID or diagobj.Object_ID = con.End_Object_ID)
		and diagobj.Diagram_ID = diag.Diagram_ID
		--and diag.name = 'F00 - GDH_HC Marché des halocarbures - Global'
		--and (objsrc.name = 'CHOIX VALEUR' or objdest.name ='CHOIX VALEUR')
		--and (con.SourceCard like '%*%' AND con.DestCard like '%*%' )
		and diaglink.ConnectorID = con.Connector_ID
		and diaglink.DiagramID = diag.Diagram_ID 
		--and diagobj.Object_ID = obj.object_id
		--and objsrc.name like 'c_%'
		--AND  REGEXP_LIKE(V.source_object, '(.)*[^0-9]$')  ??????
		and ( UPPER(SUBSTRING(objsrc.name, 1, 2)) = 'C_' OR UPPER(SUBSTRING(objdest.name, 1, 2)) = 'C_')
		;
		--[SPARXSYSTEM].[dbo].[t_attributetag]
		

		SELECT * FROM [SPARXSYSTEM].[dbo].[t_attribute] Tatt WHERE object_id = 215255;

		SELECT * FROM [SPARXSYSTEM].[dbo].[t_attributetag] where ElementID in (84278,84279,84280) and property in (
		'Code',
'Identifiant primaire',
'Longueur',
'Obligatoire',
'Précision',
'Type PD original'
);

--PIVOT ATT TAG
select Elementid , Code, Identifiantprimaire, Longueur, Obligatoire, Précision, TypePDoriginal
from
(
  select tatt.ElementID, tatt.value, tatt.property
  from [SPARXSYSTEM].[dbo].[t_attributetag] Tatt where ElementID in (84278,84279,84280)
) d
pivot
(
  max(value)
  for property in (Code, Identifiantprimaire, Longueur, Obligatoire, Précision, TypePDoriginal)
) piv;


	-- Find object in the catalogue -------------------------------------------
		  ;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM   [SPARXSYSTEM].[dbo].[T_PACKAGE] t
            WHERE t.NAME = 'Catalogue Entités de données' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM [SPARXSYSTEM].[dbo].[T_PACKAGE] e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  DISTINCT tobj.Object_ID,  tobj.NAME, objprop.value AS TABLE_NAME, FULL_PATH, tobj.Name, tobj.Stereotype
        FROM  PackHierarchy  , 
		[SPARXSYSTEM].[dbo].[t_object] tobj
		, [SPARXSYSTEM].[dbo].[t_objectproperties] objprop
		where --PKG_NAME = 'Modèle conceptuel de données'  -- Repertoire source de migration par systeme
        --PKG_NAME = 'Modèle physique_RETRO'
        --FULL_PATH not like '%Temp%'
		--AND 
			tobj.Package_ID = PKG_ID
        and tobj.Object_ID = objprop.Object_ID
		--AND tobj.Stereotype = 'Objet information'
			and objprop.value LIKE  '%SE_CLASSEMENT_BARRAGE%'
        order by TABLE_NAME


		SELECT * FROM [SPARXSYSTEM].[dbo].[t_objectproperties] where Object_ID = 47600 ;
		SELECT * FROM [SPARXSYSTEM].[dbo].t_objecttypes ;
		SELECT * FROM [SPARXSYSTEM].[dbo].t_problemtypes;
		
		 SELECT * FROM [SPARXSYSTEM].[dbo].t_attribute WHERE UPPER(NAME) LIKE '%PERSPECTIVE%'
		 SELECT * FROM [SPARXSYSTEM].[dbo].t_attributetag WHERE UPPER(VALUE) LIKE '%PERSPECTIVE%'

		-- Find information object  in the root volet information 20 Mai 2026 Mercredi
		
		;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM   [SPARXSYSTEM].[dbo].[T_PACKAGE] t
            WHERE t.NAME = 'Volet Information' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM [SPARXSYSTEM].[dbo].[T_PACKAGE] e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  DISTINCT --tobj.Object_ID,  
		tobj.NAME, objprop.Property, objprop.value AS Val, FULL_PATH --, tobj.Stereotype
        FROM  PackHierarchy  , 
		[SPARXSYSTEM].[dbo].[t_object] tobj
		, [SPARXSYSTEM].[dbo].[t_objectproperties] objprop
		where tobj.Package_ID = PKG_ID
        and tobj.Object_ID = objprop.Object_ID
		AND tobj.Stereotype = 'Objet information'
		and tobj.NAME IS NOT NULL
        order by tobj.NAME
		
	
	--OBJET INFO AND PROPERTY MAI 20 Mercredi
	SELECT TOBJDOM.name AS DOMAIN ,TOBJSUJ.name as SUJET , tobj.name AS OBJInformation,  tobj.Stereotype,objprop.Property, objprop.value AS Val	
	FROM [SPARXSYSTEM].[dbo].[T_PACKAGE] TPACK , [SPARXSYSTEM].[dbo].[T_PACKAGE] TPACK_PARENT ,
	[SPARXSYSTEM].[dbo].[T_OBJECT] TOBJ, [SPARXSYSTEM].[dbo].[T_OBJECT] TOBJSUJ,  [SPARXSYSTEM].[dbo].[T_OBJECT] TOBJDOM, [SPARXSYSTEM].[dbo].[t_objectproperties] objprop
	WHERE 
	TPACK.Parent_ID = TPACK_PARENT.Package_ID
	AND TPACK.NAME = 'Volet Information'
	AND TPACK_PARENT.NAME = 'AEM'
	AND TOBJ.PACKAGE_ID = TPACK.PACKAGE_ID
	and tobj.Stereotype in ('Domaine Information','Sujet Information','Objet Information')
	AND tobj.name IS NOT NULL
	and TOBJ.parentid = TOBJSUJ.Object_ID
	and TOBJSUJ.ParentID = TOBJDOM.Object_ID
	AND TOBJDOM.name = '06 Client'
	AND TOBJSUJ.name = '06.01 Information Client'
	AND tobj.name ='06. Client'
	and   tobj.Object_ID = objprop.Object_ID
	order by TOBJDOM.name,TOBJSUJ.name,tobj.name
	
	----PIVOT Objet Information Propriete 
	SELECT DOMAIN, SUJET, OBJInformation ,
	[1-Classification],
[2-Catégorisation],
[3-Droits - Restrictions],
[4-Cycle de vie],
[5-Diffusion],
[6-Valeur - Imputabilité],
[7-Portée],
[Cote DIC],
[Domaine AE],
[Domaine informationnel],
[Données ouvertes],
[Entente Partage],
[Finalité],
[Géolocalisé],
[Identifiant],
[Information importée],
[Référence Légale],
[Renseignement personnel],
[Source officiell]
	FROM (
	SELECT TOBJDOM.name AS DOMAIN ,TOBJSUJ.name as SUJET , tobj.name AS OBJInformation,  tobj.Stereotype,objprop.Property AS PROP , objprop.value AS Val	
	FROM [SPARXSYSTEM].[dbo].[T_PACKAGE] TPACK , [SPARXSYSTEM].[dbo].[T_PACKAGE] TPACK_PARENT ,
	[SPARXSYSTEM].[dbo].[T_OBJECT] TOBJ, [SPARXSYSTEM].[dbo].[T_OBJECT] TOBJSUJ,  [SPARXSYSTEM].[dbo].[T_OBJECT] TOBJDOM, [SPARXSYSTEM].[dbo].[t_objectproperties] objprop
	WHERE 
	TPACK.Parent_ID = TPACK_PARENT.Package_ID
	AND TPACK.NAME = 'Volet Information'
	AND TPACK_PARENT.NAME = 'AEM'
	AND TOBJ.PACKAGE_ID = TPACK.PACKAGE_ID
	and tobj.Stereotype in ('Domaine Information','Sujet Information','Objet Information')
	AND tobj.name IS NOT NULL
	and TOBJ.parentid = TOBJSUJ.Object_ID
	and TOBJSUJ.ParentID = TOBJDOM.Object_ID
	AND TOBJDOM.name = '06 Client'
	AND TOBJSUJ.name = '06.01 Information Client'
	AND tobj.name ='06. Client'
	and   tobj.Object_ID = objprop.Object_ID
	--order by TOBJDOM.name,TOBJSUJ.name,tobj.name
	) D
	PIVOT 
	(
	MAX(VAL) FOR PROP IN ([1-Classification],
[2-Catégorisation],
[3-Droits - Restrictions],
[4-Cycle de vie],
[5-Diffusion],
[6-Valeur - Imputabilité],
[7-Portée],
[Cote DIC],
[Domaine AE],
[Domaine informationnel],
[Données ouvertes],
[Entente Partage],
[Finalité],
[Géolocalisé],
[Identifiant],
[Information importée],
[Référence Légale],
[Renseignement personnel],
[Source officiell]
) 
	) PIV;


	--Mai 21  Applications et DMUs
	SELECT  obj.name,
	replace(replace(replace(replace(replace(replace(replace(OBJ.note, '&#233;', 'é'),'&#224;','a') ,'&#226;','a'),'&#232;','e'),'&#234;','e'), '&#201;','e'), '&#249;', 'ù' ) Note_Commentaire 
		FROM [SPARXSYSTEM].[dbo].[t_OBJECT] obj
	WHERE  obj.Stereotype in ('Application','Service applicatif');


	--- Proprieete des applications et DMUs 

	 SELECT  obj.name,   obj.Stereotype,
replace(replace(replace(replace(replace(replace(replace(OBJ.note, '&#233;', 'é'),'&#224;','a') ,'&#226;','a'),'&#232;','e'),'&#234;','e'), '&#201;','e'), '&#249;', 'ù' ) Note_Commentaire 
FROM [SPARXSYSTEM].[dbo].[t_OBJECT] obj,
[SPARXSYSTEM].[dbo].[t_objectproperties]  objprop 
where obj.Object_ID = objprop.object_id
AND objprop.property = 'Possession' and objprop.Value='DMU'
and  obj.Stereotype in ('Application','Service applicatif');



 SELECT  distinct obj.name,  objprop.property, objprop.value  
--replace(replace(replace(replace(replace(replace(replace(OBJ.note, '&#233;', 'é'),'&#224;','a') ,'&#226;','a'),'&#232;','e'),'&#234;','e'), '&#201;','e'), '&#249;', 'ù' ) Note_Commentaire 
FROM [SPARXSYSTEM].[dbo].[t_OBJECT] obj,
[SPARXSYSTEM].[dbo].[t_objectproperties]  objprop 
where obj.Object_ID = objprop.object_id
--AND  obj.name = 'BDH04 - DMU_BDH Terrain'
and  obj.Stereotype in ('Application','Service applicatif')
--and objprop.property = 'Possession' 
--and objprop.Value='DMU'
AND obj.name = 'BDH04 - DMU_BDH Terrain'
order by obj.name,  objprop.property
;
--


 SELECT   NOM,  
 AdresseURLenProduction,
BaseDeDonnees,
CategorieSecurite,
CoteClassification,
CoteConfidentialite,
CoteDisponibilite,
CoteIntegrite,
CoteProtection,
DateArchivage,
DateDelestage,
DateMAJModelisation,
DateMiseEnProduction,
Etat,
HauteDisponibilite,
IdCMDB,
LieuPrincipalHebergement,
ListeRessourcesTIetAffaires,
NomUADetenteur,
Possession,
ProfilSecurite,
Progiciel,
ServiceEssentiel,
[Type],
VersionDeployee,
VersionModelisee,
Volumetrie
FROM 
(
SELECT  distinct obj.name AS NOM,  objprop.property AS PROP, objprop.value  AS VAL
--replace(replace(replace(replace(replace(replace(replace(OBJ.note, '&#233;', 'é'),'&#224;','a') ,'&#226;','a'),'&#232;','e'),'&#234;','e'), '&#201;','e'), '&#249;', 'ù' ) Note_Commentaire 
FROM [SPARXSYSTEM].[dbo].[t_OBJECT] obj,
[SPARXSYSTEM].[dbo].[t_objectproperties]  objprop 
where obj.Object_ID = objprop.object_id
--AND  obj.name = 'BDH04 - DMU_BDH Terrain'
and  obj.Stereotype in ('Application','Service applicatif')
--and objprop.property = 'Possession' 
--and objprop.Value='DMU'
AND obj.name like '%BDH%'
--order by obj.name,  objprop.property
) 	D 
PIVOT 
	(
	MAX(VAL) FOR PROP IN (
	 AdresseURLenProduction,
BaseDeDonnees,
CategorieSecurite,
CoteClassification,
CoteConfidentialite,
CoteDisponibilite,
CoteIntegrite,
CoteProtection,
DateArchivage,
DateDelestage,
DateMAJModelisation,
DateMiseEnProduction,
Etat,
HauteDisponibilite,
IdCMDB,
LieuPrincipalHebergement,
ListeRessourcesTIetAffaires,
NomUADetenteur,
Possession,
ProfilSecurite,
Progiciel,
ServiceEssentiel,
[Type],
VersionDeployee,
VersionModelisee,
Volumetrie
)
) PIV;





select  obj.Stereotype from [SPARXSYSTEM].[dbo].[t_OBJECT] obj 





	
		select Elementid , Code, Identifiantprimaire, Longueur, Obligatoire, Précision, TypePDoriginal
from
(
  select tatt.ElementID, tatt.value, tatt.property
  from [SPARXSYSTEM].[dbo].[t_attributetag] Tatt where ElementID in (84278,84279,84280)
) d
pivot
(
  max(value)
  for property in (Code, Identifiantprimaire, Longueur, Obligatoire, Précision, TypePDoriginal)
) piv;
 --


 --[SPARXSYSTEM].[dbo].[t_object] 

 -- Find data entity in  in the information  catalogue
		 ;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM [SPARXSYSTEM].[dbo].[T_PACKAGE]   t
            WHERE t.NAME = 'Volet Information' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM [SPARXSYSTEM].[dbo].[T_PACKAGE]  e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  DISTINCT  objprop.value AS TABLE_NAME, FULL_PATH, tobj.Name, tobj.Stereotype
        FROM PackHierarchy ,
		[SPARXSYSTEM].[dbo].[t_object]   tobj
		, [SPARXSYSTEM].[dbo].[t_objectproperties]  objprop
		where --PKG_NAME= 'Tmp_GES_inProgress'  -- Repertoire source de migration par systeme
        --and PKG_NAME != 'Commun Cible'
        --FULL_PATH not like '%Temp%'
		--AND 
		tobj.Package_ID = PKG_ID
        and tobj.Object_ID = objprop.Object_ID
		--and objprop.value LIKE  'SE_CLASSEMENT_BARRAGE%'
		--and Stereotype = 'Entité données'
        order by TABLE_NAME;
 --

 SELECT * FROM [SPARXSYSTEM].[dbo].t_PACKAGE WHERE NAME = 'Vue d''ensemble des systèmes et applications';
 SELECT * FROM [SPARXSYSTEM].[dbo].t_diagram WHERE NAME = 'Vue d''ensemble des systèmes et applications-sans lien'


  SELECT  DISTINCT  src.Stereotype
    FROM [SPARXSYSTEM].[dbo].[t_connector]  con
INNER JOIN  [SPARXSYSTEM].[dbo].[t_object]  src ON con.Start_Object_ID = src.Object_ID
INNER JOIN  [SPARXSYSTEM].[dbo].[t_object] trg ON con.End_Object_ID = trg.Object_ID

-- Matrice Fonction d'affaire  et objet d'information   mai 2026

 SELECT 
    src.Name AS [Fonction Affaire], 
	trg.Name AS [Objet Information],
    --src.Object_Type AS [Source Type],
   -- con.Connector_Type AS [Relationship], 
	con.Direction--,
    --trg.Name AS [Target Name]--, 
   -- trg.Object_Type AS [Target Type]
FROM [SPARXSYSTEM].[dbo].[t_connector]  con
INNER JOIN  [SPARXSYSTEM].[dbo].[t_object]  src ON con.Start_Object_ID = src.Object_ID
INNER JOIN  [SPARXSYSTEM].[dbo].[t_object] trg ON con.End_Object_ID = trg.Object_ID
WHERE con.Stereotype = 'Accède'--'Dependency' -- Change to your matrix's connector type
  AND 
  src.Stereotype = 'Fonction affaires'-- 'Requirement' -- Filter by your source element type
  AND trg.Stereotype = 'Objet Information'--'Requirement' -- 
 and   src.Name = '01.06.01 Tenir la comptabilité analytique des coûts unitaires'


 -- Matrice Fonction d'affaire  et oApplication   mai 2026

 SELECT 
 trg.Name AS [Fonction Affaire],
    src.Name AS [Application]--, 	
    --src.Object_Type AS [Source Type],
   -- con.Connector_Type AS [Relationship], 
	--con.Direction--,
    --trg.Name AS [Target Name]--, 
   -- trg.Object_Type AS [Target Type]
FROM [SPARXSYSTEM].[dbo].[t_connector]  con
INNER JOIN  [SPARXSYSTEM].[dbo].[t_object]  src ON con.Start_Object_ID = src.Object_ID
INNER JOIN  [SPARXSYSTEM].[dbo].[t_object] trg ON con.End_Object_ID = trg.Object_ID
WHERE con.Stereotype = 'Soutient'--'Dependency' -- Change to your matrix's connector type
 AND 
 (
  (src.Stereotype = 'Application'-- 'Requirement' -- Filter by your source element type
  AND trg.Stereotype = 'Fonction affaires')--'Requirement' -- 
-- OR 
-- (src.Stereotype = 'Fonction affaires'-- 'Requirement' -- Filter by your source element type
--  AND trg.Stereotype = 'Application')
  )
  AND src.Name like '%GB%'
 --
 --Liste des fonctions d'affaire pour BBP
  SELECT DISTINCT 
 trg.Name AS [Fonction Affaire]--,
    --src.Name AS [Application], 	
    --src.Object_Type AS [Source Type],
   -- con.Connector_Type AS [Relationship], 
	--con.Direction--,
    --trg.Name AS [Target Name]--, 
   -- trg.Object_Type AS [Target Type]
FROM [SPARXSYSTEM].[dbo].[t_connector]  con
INNER JOIN  [SPARXSYSTEM].[dbo].[t_object]  src ON con.Start_Object_ID = src.Object_ID
INNER JOIN  [SPARXSYSTEM].[dbo].[t_object] trg ON con.End_Object_ID = trg.Object_ID
WHERE con.Stereotype = 'Soutient'--'Dependency' -- Change to your matrix's connector type
 AND 
 (
  (src.Stereotype = 'Application'-- 'Requirement' -- Filter by your source element type
  AND trg.Stereotype = 'Fonction affaires')--'Requirement' -- 
-- OR 
-- (src.Stereotype = 'Fonction affaires'-- 'Requirement' -- Filter by your source element type
--  AND trg.Stereotype = 'Application')
  )
  AND src.Name like '%GBP%'
  order by trg.Name;

  -----------Objet d'information pour BDH via les fonctions d'affaire commune aux objets info et application --20 mai 2026
   SELECT DISTINCT 
    src.Name AS [Fonction Affaire], 
	trg.Name AS [Objet Information]
   FROM [SPARXSYSTEM].[dbo].[t_connector]  con
INNER JOIN  [SPARXSYSTEM].[dbo].[t_object]  src ON con.Start_Object_ID = src.Object_ID
INNER JOIN  [SPARXSYSTEM].[dbo].[t_object] trg ON con.End_Object_ID = trg.Object_ID
WHERE con.Stereotype = 'Accède'
  AND 
  src.Stereotype = 'Fonction affaires'
  AND trg.Stereotype = 'Objet Information'
  AND src.Name   IN 
  (    SELECT DISTINCT 
 trg.Name AS [Fonction Affaire]
   FROM [SPARXSYSTEM].[dbo].[t_connector]  con
INNER JOIN  [SPARXSYSTEM].[dbo].[t_object]  src ON con.Start_Object_ID = src.Object_ID
INNER JOIN  [SPARXSYSTEM].[dbo].[t_object] trg ON con.End_Object_ID = trg.Object_ID
WHERE con.Stereotype = 'Soutient'
  AND src.Stereotype = 'Application'
  AND trg.Stereotype = 'Fonction affaires'
    AND src.Name like '%GB%'
	)
	ORDER BY trg.Name
	;


select  --objsrc.name  as Start_object, -- ,objsrc.Stereotype as SrcSteriotype, 
 DISTINCT objtgt.name as End_object --,objtgt.Stereotype as TgtSteriotype, 
 --conn.name connector_name ,conn.Direction, conn.Connector_Type
from 
[SPARXSYSTEM].[dbo].t_diagram   diag ,
[SPARXSYSTEM].[dbo].t_diagramlinks   diagL ,
[SPARXSYSTEM].[dbo].t_connector   conn,
[SPARXSYSTEM].[dbo].t_object     objsrc,
[SPARXSYSTEM].[dbo].t_object     objtgt
where 
 diag.name = 'Portée Données - Informations'
and diagL.ConnectorID = conn.Connector_ID
AND DIAGL.DiagramID = DIAG.Diagram_ID
and objsrc.Object_ID = conn.Start_Object_ID
and objtgt.Object_ID = conn.End_Object_ID
AND conn.Connector_Type='Realisation'
--AND ( objsrc.name = '09. Barrage' or objtgt.name = '09. Barrage')
order by objtgt.name
;

select  DISTINCT objsrc.name  as Start_object, -- ,objsrc.Stereotype as SrcSteriotype, 
  objtgt.name as End_object --,objtgt.Stereotype as TgtSteriotype, 
 --conn.name connector_name ,conn.Direction, conn.Connector_Type
from 
[SPARXSYSTEM].[dbo].t_diagram   diag ,
[SPARXSYSTEM].[dbo].t_diagramlinks   diagL ,
[SPARXSYSTEM].[dbo].t_connector   conn,
[SPARXSYSTEM].[dbo].t_object     objsrc,
[SPARXSYSTEM].[dbo].t_object     objtgt
where 
 diag.name = 'Portée Données - Informations'
and diagL.ConnectorID = conn.Connector_ID
AND DIAGL.DiagramID = DIAG.Diagram_ID
and objsrc.Object_ID = conn.Start_Object_ID
and objtgt.Object_ID = conn.End_Object_ID
AND conn.Connector_Type='Realisation'
--AND ( objsrc.name = '09. Barrage' or objtgt.name = '09. Barrage')
order by objtgt.name
;

--Activity - application function et fonctions affaire

SELECT * FROM [SPARXSYSTEM].[dbo].[t_object]   obj  where obj.Stereotype like '%Archi%'and  
obj.name =  '1.3 Gestion des paramètres des stations, postes et intruments de référence pour gérer les barrages'--obj.Object_Type = 'ApplicationFunction';

select * from [SPARXSYSTEM].[dbo].[t_objectproperties] objprop where objprop.Object_ID = 275275;



select  DISTINCT objsrc.name  as Start_object,  objsrc.Stereotype as SrcSteriotype,  objsrc.Object_Type as SRC_TYPE,
  objtgt.name as End_object ,objtgt.Stereotype as TgtSteriotype, objtgt.Object_Type AS TGT_TYPE --, 
 --conn.name connector_name ,conn.Direction, conn.Connector_Type
from 
[SPARXSYSTEM].[dbo].t_diagram   diag ,
[SPARXSYSTEM].[dbo].t_diagramlinks   diagL ,
[SPARXSYSTEM].[dbo].t_connector   conn,
[SPARXSYSTEM].[dbo].t_object     objsrc,
[SPARXSYSTEM].[dbo].t_object     objtgt
where 
 diag.name = '2 - Relation entre portée fonctionnelle et affaire'
and diagL.ConnectorID = conn.Connector_ID
AND DIAGL.DiagramID = DIAG.Diagram_ID
and objsrc.Object_ID = conn.Start_Object_ID
and objtgt.Object_ID = conn.End_Object_ID
AND conn.Connector_Type='Dependency'
--AND ( objsrc.name = '09. Barrage' or objtgt.name = '09. Barrage')
and objsrc.name = '1.Gestion des paramètres nécessaires pour opérer les barrages'
order by objtgt.name




--Avec le tag physique = code = nom BD
select  DISTINCT objsrc.name  as Start_object, objprop.Value Table_Physique, -- ,objsrc.Stereotype as SrcSteriotype, 
  objtgt.name as End_object --,objtgt.Stereotype as TgtSteriotype, 
 --conn.name connector_name ,conn.Direction, conn.Connector_Type
from 
[SPARXSYSTEM].[dbo].t_diagram   diag ,
[SPARXSYSTEM].[dbo].t_diagramlinks   diagL ,
[SPARXSYSTEM].[dbo].t_connector   conn,
[SPARXSYSTEM].[dbo].t_object     objsrc,
[SPARXSYSTEM].[dbo].t_object     objtgt,
[SPARXSYSTEM].[dbo].[t_objectproperties] objprop
where 
 diag.name = 'Portée Données - Informations'
and diagL.ConnectorID = conn.Connector_ID
AND DIAGL.DiagramID = DIAG.Diagram_ID
and objsrc.Object_ID = conn.Start_Object_ID
and objtgt.Object_ID = conn.End_Object_ID
AND conn.Connector_Type='Realisation'
--AND ( objsrc.name = '09. Barrage' or objtgt.name = '09. Barrage')
AND  objsrc.Object_ID = objprop.Object_ID
order by objtgt.name
;

--Liste des objets dans un diagramme MCD sans correspondance dans le MCCD 
 select obj.name  AS ENTITY_NAME , 
objp.value AS TABLE_NAME,
replace(replace(replace(replace(replace(obj.note, '&#233;', 'é'),'&#224;','a') ,'&#226','a'),'&#232;','e'),'&#234','e') As Note   
from [SPARXSYSTEM].[dbo].[t_diagramobjects]  diagobj , 
[SPARXSYSTEM].[dbo].[t_object] obj, 
[SPARXSYSTEM].[dbo].[t_diagram] diag, 
[SPARXSYSTEM].[dbo].[t_objectproperties] objp 
where diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name = 'GBP_Gestion des Barrages'
and obj.Object_ID = objp.Object_ID
and objp.property = 'code'
--ORDER BY objp.value
and obj.name not in (
select  DISTINCT objsrc.name  as Start_object --, objprop.Value Table_Physique, -- ,objsrc.Stereotype as SrcSteriotype, 
 -- objtgt.name as End_object --,objtgt.Stereotype as TgtSteriotype, 
 --conn.name connector_name ,conn.Direction, conn.Connector_Type
from 
[SPARXSYSTEM].[dbo].t_diagram   diag ,
[SPARXSYSTEM].[dbo].t_diagramlinks   diagL ,
[SPARXSYSTEM].[dbo].t_connector   conn,
[SPARXSYSTEM].[dbo].t_object     objsrc,
[SPARXSYSTEM].[dbo].t_object     objtgt,
[SPARXSYSTEM].[dbo].[t_objectproperties] objprop
where 
 diag.name = 'Portée Données - Informations'
and diagL.ConnectorID = conn.Connector_ID
AND DIAGL.DiagramID = DIAG.Diagram_ID
and objsrc.Object_ID = conn.Start_Object_ID
and objtgt.Object_ID = conn.End_Object_ID
AND conn.Connector_Type='Realisation'
--AND ( objsrc.name = '09. Barrage' or objtgt.name = '09. Barrage')
AND  objsrc.Object_ID = objprop.Object_ID
--order by objtgt.name
)

		
--test d extension  e filtrant par diagramme 20 mai 2026
 SELECT DISTINCT 
    src.Name AS [Fonction Affaire], 
	trg.Name AS [Objet Information],
	 diag.Name as [Diagram Name]
   FROM [SPARXSYSTEM].[dbo].[t_connector]  con
INNER JOIN  [SPARXSYSTEM].[dbo].[t_object]  src ON con.Start_Object_ID = src.Object_ID
INNER JOIN  [SPARXSYSTEM].[dbo].[t_object] trg ON con.End_Object_ID = trg.Object_ID
INNER JOIN  [SPARXSYSTEM].[dbo].[t_diagramlinks] diagl ON diagl.ConnectorID = con.Connector_ID
INNER JOIN  [SPARXSYSTEM].[dbo].[t_diagram] diag ON diag.Diagram_ID = diagl.DiagramID
WHERE con.Stereotype = 'Accède'
  AND 
  src.Stereotype = 'Fonction affaires'
  AND trg.Stereotype = 'Objet Information'
 and diag.Name = 'Portée informationnelle' ---Filtrer par diagramme --
  AND src.Name   IN 
  (    SELECT DISTINCT 
 trg.Name AS [Fonction Affaire]
   FROM [SPARXSYSTEM].[dbo].[t_connector]  con
INNER JOIN  [SPARXSYSTEM].[dbo].[t_object]  src ON con.Start_Object_ID = src.Object_ID
INNER JOIN  [SPARXSYSTEM].[dbo].[t_object] trg ON con.End_Object_ID = trg.Object_ID
WHERE con.Stereotype = 'Soutient'
  AND src.Stereotype = 'Application'
  AND trg.Stereotype = 'Fonction affaires'
    AND src.Name like '%GB%'
	)
	ORDER BY trg.Name;


 SELECT distinct Stereotype 
 FROM [SPARXSYSTEM].[dbo].[t_connector] ;

 --entite de donnees dans un diagram POUR Dossier Architecture Avril 2026
select  --distinct 
obj.name  AS ENTITY_NAME , 
objp.value AS TABLE_NAME,
replace(replace(replace(replace(replace(obj.note, '&#233;', 'é'),'&#224;','a') ,'&#226','a'),'&#232;','e'),'&#234','e') As Note  --, att.name AS ATTRIBUTE_NAME , attg.VALUE AS COLUMN_NAME 
from [SPARXSYSTEM].[dbo].[t_diagramobjects]  diagobj , 
  [SPARXSYSTEM].[dbo].[t_object] obj, 
 [SPARXSYSTEM].[dbo].[t_diagram] diag, 
  [SPARXSYSTEM].[dbo].[t_objectproperties] objp --, t_attribute att, t_attributetag attg
where diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name = 'BC_Station Poste et instrument'
and obj.Object_ID = objp.Object_ID
and objp.property = 'code'
--and obj.name    like '%YYYYY%'
--AND obj.name LIKE 'EC_%'
--and att.Object_ID = obj.Object_ID
--and attg.ElementID = att.ID
--and attg.Property = 'Code'
--AND attg.VALUE = 'PERSONNE_CONTACT_PLAGE' --IS NULL
ORDER BY objp.value--, attg.VALUE

SELECT * FROM [SPARXSYSTEM].[dbo].t_xref;


  -- Object in application layer --DMU et applications
		 ;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM [SPARXSYSTEM].[dbo].[T_PACKAGE]   t
            WHERE t.NAME =  'Gestion des actifs immobliers de types barrages_ en travail'--'Gestion des actifs immobilier de type barrages' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM [SPARXSYSTEM].[dbo].[T_PACKAGE]  e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )

        SELECT  DISTINCT --PKG_NAME, PKG_ID, diag.name as digram, 
		obj.name , obj.Stereotype
        FROM PackHierarchy , [SPARXSYSTEM].[dbo].t_diagram diag,
		[SPARXSYSTEM].[dbo].[t_diagramobjects]  diagobj , 
  [SPARXSYSTEM].[dbo].[t_object] obj
 		--[SPARXSYSTEM].[dbo].[t_object]   tobj
	     where PKG_NAME = 'Vue d''ensemble des systèmes et applications - Gestion des actifs immobiliers de type "barrage"'--'Vue d''ensemble des systèmes et applications'
		 and diag.name = 'Vue d''ensemble des systèmes et applications - Gestion des actifs immobiliers de type "barrage"_SANS LIEN'--'Vue d''ensemble des systèmes et applications-sans lien'
		 AND  PKG_ID = diag.Package_ID
		AND  diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
order by obj.name
;





		SELECT * FROM  [SPARXSYSTEM].[dbo].t_diagram;
 --




 	 ;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM [SPARXSYSTEM].[dbo].[T_PACKAGE]   t
            WHERE t.NAME = 'Volet Information' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM [SPARXSYSTEM].[dbo].[T_PACKAGE]  e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  DISTINCT  objprop.value AS TABLE_NAME, FULL_PATH, tobj.Name, tobj.Stereotype
        FROM PackHierarchy ,
		[SPARXSYSTEM].[dbo].[t_object]   tobj
		, [SPARXSYSTEM].[dbo].[t_objectproperties]  objprop
		where --PKG_NAME= 'Tmp_GES_inProgress'  -- Repertoire source de migration par systeme
        --and PKG_NAME != 'Commun Cible'
        --FULL_PATH not like '%Temp%'
		--AND 
		tobj.Package_ID = PKG_ID
        and tobj.Object_ID = objprop.Object_ID
		--and objprop.value LIKE  'HC_DECLARATION%'
		and Stereotype = 'Entité données'
        order by TABLE_NAME;

		select tobj.object_id ,tobj.Name , tobj.parentid  from [SPARXSYSTEM].[dbo].[t_object]   tobj where tobj.Stereotype = 'Objet information';
		select * from [SPARXSYSTEM].[dbo].[t_package] where name = 'AEM';
		select * from [SPARXSYSTEM].[dbo].[t_package] where name = 'Volet Information' and version = '0.3';
		
		--Objet  information
		select * from [SPARXSYSTEM].[dbo].[t_object]  where package_id =7385 
		AND Stereotype In ('Domaine information', 'Objet information','Sujet information') Order by name;

		
--PIVOT ATT TAG
select Elementid , Code, Identifiantprimaire, Longueur, Obligatoire, Précision, TypePDoriginal
from
(
  select tatt.ElementID, tatt.value, tatt.property
  from [SPARXSYSTEM].[dbo].[t_attributetag] Tatt where ElementID in (84278,84279,84280)
) d
pivot
(
  max(value)
  for property in (Code, Identifiantprimaire, Longueur, Obligatoire, Précision, TypePDoriginal)
) piv;

SELECT * FROM [SPARXSYSTEM].[dbo].[t_attributetag] Tatt WHERE ElementID in (84278,84279,84280)
SELECT * FROM [SPARXSYSTEM].[dbo].[t_attribute] att WHERE ATT.NAME = 'CODE_LOGIQUE_CALCUL';

SELECT att.name, att.Type  from  [SPARXSYSTEM].[dbo].[t_attribute]  att where att.type like '%java%';

 -- --------------------------------------------------------------------------Find Entite et attribute in a diagram avec prorietes : Cle primaire , ...
SELECT ENTITY_NAME,TABLE_NAME, SUM(PK) SPK FROM
(
SELECT  ENTITY_NAME,TABLE_NAME,ATTRIBUTE_NAME , CODE, "Identifiant primaire" ,Obligatoire,Longueur, Précision , "Type PD original" ,
CASE WHEN "Identifiant primaire" = 'Vrai' THEN 1 ELSE 0 END AS PK
FROM (
select obj.name  AS ENTITY_NAME , objp.value AS TABLE_NAME  , att.name AS ATTRIBUTE_NAME , attg.VALUE AS COLUMN_NAME, ATTG.PROPERTY 
from 
[SPARXSYSTEM].[dbo].[t_diagramobjects]  diagobj , 
[SPARXSYSTEM].[dbo].[t_object]   obj, 
[SPARXSYSTEM].[dbo].[t_diagram]  diag, 
[SPARXSYSTEM].[dbo].[t_objectproperties]  objp, 
[SPARXSYSTEM].[dbo].[t_attribute]  att, 
[SPARXSYSTEM].[dbo].[t_attributetag]   attg
where diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name = 'GBP_Gestion des Barrages'
and obj.Object_ID = objp.Object_ID
and objp.property = 'code'
--and objp.value like 'HC_%'
and att.Object_ID = obj.Object_ID
and attg.ElementID = att.ID
--and attg.Property = 'Code'
--AND attg.VALUE IS NULL

and attg.property in (
		'Code',
'Identifiant primaire',
'Longueur',
'Obligatoire',
'Précision',
'Type PD original'
)
--ORDER BY objp.value, attg.VALUE;
) D
pivot
(
  max(COLUMN_NAME)
  for property in (Code, [Identifiant primaire], Longueur, Obligatoire, Précision, [Type PD original])
) piv
) V
GROUP BY ENTITY_NAME,TABLE_NAME
HAVING SUM(PK) = 0

;




--Propertity attributes pvoted

SELECT  ENTITY_NAME,TABLE_NAME,ATTRIBUTE_NAME , CODE, "Identifiant primaire" ,Obligatoire,Longueur, Précision , "Type PD original" ,
CASE WHEN "Identifiant primaire" = 'Vrai' THEN 1 ELSE 0 END AS PK
FROM (
select obj.name  AS ENTITY_NAME , objp.value AS TABLE_NAME  , att.name AS ATTRIBUTE_NAME , attg.VALUE AS COLUMN_NAME, ATTG.PROPERTY 
from 
[SPARXSYSTEM].[dbo].[t_diagramobjects]  diagobj , 
[SPARXSYSTEM].[dbo].[t_object]   obj, 
[SPARXSYSTEM].[dbo].[t_diagram]  diag, 
[SPARXSYSTEM].[dbo].[t_objectproperties]  objp, 
[SPARXSYSTEM].[dbo].[t_attribute]  att, 
[SPARXSYSTEM].[dbo].[t_attributetag]   attg
where diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name = 'GBP_Gestion des Barrages'
and obj.Object_ID = objp.Object_ID
and objp.property = 'code'
--and objp.value like 'GB_ACTIVITE_%'
and att.Object_ID = obj.Object_ID
and attg.ElementID = att.ID
--and attg.Property = 'Code'
--AND attg.VALUE IS NULL
and attg.property in (
		'Code',
'Identifiant primaire',
'Longueur',
'Obligatoire',
'Précision',
'Type PD original'
)
--ORDER BY objp.value, attg.VALUE;
) D
pivot
(
  max(COLUMN_NAME)
  for property in (Code, [Identifiant primaire], Longueur, Obligatoire, Précision, [Type PD original])
) piv
WHERE TABLE_NAME LIKE 'GB_ACTIVITE%'






 -- Find Entite only entity in a diagram

SELECT * FROM T_OBJECT  WHERE NAME = 'MOTIF JOURNAL';
--22408
--18742
--30800



SELECT NAME  FROM [SPARXSYSTEM].[dbo].[t_package] WHERE Package_ID IN (16365, 22408,18742,30800);



--Liste des entites de donnees dans un diagram MCD Avril 2026
select  distinct 
obj.name  AS ENTITY_NAME , 
objp.value AS TABLE_NAME  --, att.name AS ATTRIBUTE_NAME , attg.VALUE AS COLUMN_NAME 
from [SPARXSYSTEM].[dbo].[t_diagramobjects]  diagobj , 
  [SPARXSYSTEM].[dbo].[t_object] obj, 
 [SPARXSYSTEM].[dbo].[t_diagram] diag, 
  [SPARXSYSTEM].[dbo].[t_objectproperties] objp --, t_attribute att, t_attributetag attg
where diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name ='SEBP_Securite et entretien des barrages' --'GBP_Gestion des Barrages'--'DH_Banque de données hydriques'-- --'SEBP_Securite et entretien des barrages'
and obj.Object_ID = objp.Object_ID
and objp.property = 'code'
--and obj.name    like '%YYYYY%'
--AND obj.name LIKE 'EC_%'
--and att.Object_ID = obj.Object_ID
--and attg.ElementID = att.ID
--and attg.Property = 'Code'
--AND attg.VALUE = 'PERSONNE_CONTACT_PLAGE' --IS NULL
ORDER BY objp.value--, attg.VALUE
;


--Objet d infos dans un diagram
select  
obj.name  AS ENTITY_NAME , OBJ.Stereotype--, 
--objp.value AS TABLE_NAME  --, att.name AS ATTRIBUTE_NAME , attg.VALUE AS COLUMN_NAME 
from 
 [SPARXSYSTEM].[dbo].t_diagramobjects  diagobj , 
[SPARXSYSTEM].[dbo].t_object   obj, 
[SPARXSYSTEM].[dbo].t_diagram   diag --, t_objectproperties objp --, t_attribute att, t_attributetag attg
where diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name = 'Portée Données - Informations'
--and obj.Object_ID = objp.Object_ID
--and objp.property = 'code'
--and obj.name    like '%YYYYY%'
--AND obj.name LIKE 'EC_%'
--and att.Object_ID = obj.Object_ID
--and attg.ElementID = att.ID
--and attg.Property = 'Code'
--AND attg.VALUE = 'PERSONNE_CONTACT_PLAGE' --IS NULL
--ORDER BY objp.value--, attg.VALUE
;



SELECT * FROM [SPARXSYSTEM].[dbo].[t_connector];
select * from [SPARXSYSTEM].[dbo].t_diagram   diag;
SELECT * FROM [SPARXSYSTEM].[dbo].t_diagramlinks; --INSTANCE_ID
SELECT  * FROM [SPARXSYSTEM].[dbo].t_diagramobjects ; --INSTANCE_ID



select  distinct 
obj.name  AS ENTITY_NAME , OBJ.Stereotype, conn.Direction,
(select distinct objs.name from [SPARXSYSTEM].[dbo].t_object   objs where  objS.Object_ID =  conn.Start_Object_ID)  AS Source_Obj,
(select distinct  objs.name from [SPARXSYSTEM].[dbo].t_object   objs where  objS.Object_ID =  conn.End_Object_ID) AS Target_Obj
--objp.value AS TABLE_NAME  --, att.name AS ATTRIBUTE_NAME , attg.VALUE AS COLUMN_NAME 
from 
 [SPARXSYSTEM].[dbo].t_diagramobjects  diagobj , 
[SPARXSYSTEM].[dbo].t_object   obj, 
[SPARXSYSTEM].[dbo].t_diagram   diag ,-- t_objectproperties objp --, t_attribute att, t_attributetag attg
[SPARXSYSTEM].[dbo].t_diagramlinks   diagl,
[SPARXSYSTEM].[dbo].[t_connector]   conn
where diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name = 'Portée Données - Informations'
and diag.Diagram_ID = diagl.DiagramID
and diagl.ConnectorID= conn.Connector_ID
and obj.Stereotype in ('Entité données','Objet information')
and obj.name  ='09. Barrage'
--and obj.Object_ID = objp.Object_ID
--and objp.property = 'code'
--and obj.name    like '%YYYYY%'
--AND obj.name LIKE 'EC_%'
--and att.Object_ID = obj.Object_ID
--and attg.ElementID = att.ID
--and attg.Property = 'Code'
--AND attg.VALUE = 'PERSONNE_CONTACT_PLAGE' --IS NULL
--ORDER BY objp.value--, attg.VALUE
;


select  
obj.name  AS ENTITY_NAME , OBJ.Stereotype--, 
--objp.value AS TABLE_NAME  --, att.name AS ATTRIBUTE_NAME , attg.VALUE AS COLUMN_NAME 
from 
 [SPARXSYSTEM].[dbo].t_diagramobjects  diagobj , 
[SPARXSYSTEM].[dbo].t_object   obj, 
[SPARXSYSTEM].[dbo].t_diagram   diag --, t_objectproperties objp --, t_attribute att, t_attributetag attg
where diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name = 'Vue d''ensemble des systèmes et applications-sans lien'
and OBJ.Stereotype = 'Application'
--and obj.Object_ID = objp.Object_ID
--and objp.property = 'code'
--and obj.name    like '%YYYYY%'
--AND obj.name LIKE 'EC_%'
--and att.Object_ID = obj.Object_ID
--and attg.ElementID = att.ID
--and attg.Property = 'Code'
--AND attg.VALUE = 'PERSONNE_CONTACT_PLAGE' --IS NULL
--ORDER BY objp.value--, attg.VALUE

--Castor DIAG OBJECT
select  
obj.name  AS ENTITY_NAME , OBJ.Stereotype--, 
--objp.value AS TABLE_NAME  --, att.name AS ATTRIBUTE_NAME , attg.VALUE AS COLUMN_NAME 
from 
 [SPARXSYSTEM].[dbo].t_diagramobjects  diagobj , 
[SPARXSYSTEM].[dbo].t_object   obj, 
[SPARXSYSTEM].[dbo].t_diagram   diag --, t_objectproperties objp --, t_attribute att, t_attributetag attg
where diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name = 'Vue d''ensemble CASTOR'
and OBJ.Stereotype = 'Application'
;

--CASTOR et SEBP DIAG OBJECT AND LINKS  APPLICATION et DMUs Mai 2026
select objsrc.name  Start_object ,
objtgt.name End_object, conn.name connector_name ,conn.Direction
, conn.Start_Object_ID as src_obj_id , conn.END_Object_ID as tgt_obj_id
 --objp.value AS TABLE_NAME  --, att.name AS ATTRIBUTE_NAME , attg.VALUE AS COLUMN_NAME 
from 
[SPARXSYSTEM].[dbo].t_diagram   diag ,--, t_objectproperties objp --, t_attribute att, t_attributetag attg
[SPARXSYSTEM].[dbo].t_diagramlinks   diagL ,
[SPARXSYSTEM].[dbo].t_connector   conn,
[SPARXSYSTEM].[dbo].t_object  objsrc,
[SPARXSYSTEM].[dbo].t_object  objtgt--,
--[SPARXSYSTEM].[dbo].t_diagramobjects  diagobj
where 
 diag.name = 'Vue d''ensemble CASTOR'
and diagL.ConnectorID = conn.Connector_ID
AND DIAGL.DiagramID = DIAG.Diagram_ID
and  conn.Start_Object_ID = objsrc.object_ID
and  conn.End_Object_ID = objtgt.object_ID
 --and diagobj.Diagram_ID = diag.Diagram_ID
--and (
--(objsrc.Object_ID = diagobj.Object_ID and diagobj.Diagram_ID = diag.Diagram_ID)
--or
--(objtgt.Object_ID = diagobj.Object_ID and diagobj.Diagram_ID = diag.Diagram_ID)
--)
and 
objsrc.Object_ID in (Select  obj.Object_ID from  [SPARXSYSTEM].[dbo].t_diagramobjects  diagobj , [SPARXSYSTEM].[dbo].t_object   obj, [SPARXSYSTEM].[dbo].t_diagram   diag
where diagobj.Object_ID = obj.Object_ID and diagobj.Diagram_ID = diag.Diagram_ID and diag.name = 'Vue d''ensemble CASTOR' and OBJ.Stereotype = 'Application')

and 
(objtgt.Object_ID in (Select  obj.Object_ID from  [SPARXSYSTEM].[dbo].t_diagramobjects  diagobj , [SPARXSYSTEM].[dbo].t_object   obj, [SPARXSYSTEM].[dbo].t_diagram   diag
where diagobj.Object_ID = obj.Object_ID and diagobj.Diagram_ID = diag.Diagram_ID and diag.name = 'Vue d''ensemble CASTOR' and OBJ.Stereotype = 'Application'))
order by objsrc.name 


--BDH et GBP thematique Object Links;
select DISTINCT objsrc.name  Start_object ,
objtgt.name End_object, conn.name connector_name ,conn.Direction
--, conn.Start_Object_ID as src_obj_id --, conn.END_Object_ID as tgt_obj_id
 --objp.value AS TABLE_NAME  --, att.name AS ATTRIBUTE_NAME , attg.VALUE AS COLUMN_NAME 
from 
[SPARXSYSTEM].[dbo].t_diagram   diag ,--, t_objectproperties objp --, t_attribute att, t_attributetag attg
[SPARXSYSTEM].[dbo].t_diagramlinks   diagL ,
[SPARXSYSTEM].[dbo].t_connector   conn,
[SPARXSYSTEM].[dbo].t_object  objsrc,
[SPARXSYSTEM].[dbo].t_object  objtgt--,
--[SPARXSYSTEM].[dbo].t_diagramobjects  diagobj
where 
 diag.name = 'Vue d''ensemble des systèmes et applications'
and diagL.ConnectorID = conn.Connector_ID
AND DIAGL.DiagramID = DIAG.Diagram_ID
and  conn.Start_Object_ID = objsrc.object_ID
and  conn.End_Object_ID = objtgt.object_ID
 --and diagobj.Diagram_ID = diag.Diagram_ID
--and (
--(objsrc.Object_ID = diagobj.Object_ID and diagobj.Diagram_ID = diag.Diagram_ID)
--or
--(objtgt.Object_ID = diagobj.Object_ID and diagobj.Diagram_ID = diag.Diagram_ID)
--)
and 
objsrc.Object_ID in (Select  obj.Object_ID from  [SPARXSYSTEM].[dbo].t_diagramobjects  diagobj , [SPARXSYSTEM].[dbo].t_object   obj, [SPARXSYSTEM].[dbo].t_diagram   diag
where diagobj.Object_ID = obj.Object_ID and diagobj.Diagram_ID = diag.Diagram_ID and diag.name = 'Vue d''ensemble des systèmes et applications' and OBJ.Stereotype = 'Application')
and 
(objtgt.Object_ID in (Select  obj.Object_ID from  [SPARXSYSTEM].[dbo].t_diagramobjects  diagobj , [SPARXSYSTEM].[dbo].t_object   obj, [SPARXSYSTEM].[dbo].t_diagram   diag
where diagobj.Object_ID = obj.Object_ID and diagobj.Diagram_ID = diag.Diagram_ID and diag.name = 'Vue d''ensemble des systèmes et applications' and OBJ.Stereotype = 'Application'))
order by objsrc.name ;

-----------------------

Select  obj.Object_ID from  [SPARXSYSTEM].[dbo].t_diagramobjects  diagobj , [SPARXSYSTEM].[dbo].t_object   obj, [SPARXSYSTEM].[dbo].t_diagram   diag
where diagobj.Object_ID = obj.Object_ID and diagobj.Diagram_ID = diag.Diagram_ID and diag.name = 'Vue d''ensemble CASTOR' and OBJ.Stereotype = 'Application'

SELECT * FROM [SPARXSYSTEM].[dbo].t_object ;
SELECT * FROM [SPARXSYSTEM].[dbo].t_object;;
SELECT * FROM [SPARXSYSTEM].[dbo].t_diagramlinks; --instance_id
SELECT * FROM [SPARXSYSTEM].[dbo].t_connector;
select * from  [SPARXSYSTEM].[dbo].t_diagramobjects  diagobj ; --instance_id

select  
obj.name  AS ENTITY_NAME , OBJ.Stereotype--, 
--objp.value AS TABLE_NAME  --, att.name AS ATTRIBUTE_NAME , attg.VALUE AS COLUMN_NAME 
from 
 [SPARXSYSTEM].[dbo].t_diagramobjects  diagobj , 
[SPARXSYSTEM].[dbo].t_object   obj, 
[SPARXSYSTEM].[dbo].t_diagram   diag ,--, t_objectproperties objp --, t_attribute att, t_attributetag attg
[SPARXSYSTEM].[dbo].t_diagramlinks   diagL 
where diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name = 'Portée Données - Informations'
and OBJ.Stereotype IN ( 'Objet information','Entité données')
AND obj.name   = '09. Barrage'
AND DIAGL.DiagramID = DIAG.Diagram_ID
--and diagL.Instance_ID = diagobj.Instance_ID
--and obj.Object_ID = objp.Object_ID
--and objp.property = 'code'
--and obj.name    like '%YYYYY%'
--AND obj.name LIKE 'EC_%'
--and att.Object_ID = obj.Object_ID
--and attg.ElementID = att.ID
--and attg.Property = 'Code'
--AND attg.VALUE = 'PERSONNE_CONTACT_PLAGE' --IS NULL
--ORDER BY objp.value--, attg.VALUE
----------------
select * from [SPARXSYSTEM].[dbo].t_diagram;
select object_id  from [SPARXSYSTEM].[dbo].t_diagramobjects diagobj , [SPARXSYSTEM].[dbo].t_diagram diag
where diagobj.Diagram_ID = diag.Diagram_ID
and diag.name = 'DH_Banque de données hydriques';
--------------OBjet MCCD et MCD   Barrage Avril 2026------------------------------------------
SELECT * FROM (
select (select obj.name from [SPARXSYSTEM].[dbo].t_object    obj  where conn.Start_Object_ID = obj.object_id )  Data_Entity_Start_object ,
(select obj.name from [SPARXSYSTEM].[dbo].t_object    obj  where conn.END_Object_ID = obj.object_id )  Information_End_object, conn.name connector_name ,conn.Direction
, conn.Start_Object_ID as src_obj_id , conn.END_Object_ID as tgt_obj_id
 --objp.value AS TABLE_NAME  --, att.name AS ATTRIBUTE_NAME , attg.VALUE AS COLUMN_NAME 
from 
[SPARXSYSTEM].[dbo].t_diagram   diag ,--, t_objectproperties objp --, t_attribute att, t_attributetag attg
[SPARXSYSTEM].[dbo].t_diagramlinks   diagL ,
[SPARXSYSTEM].[dbo].t_connector   conn
where 
 diag.name = 'Portée Données - Informations'
and diagL.ConnectorID = conn.Connector_ID
AND DIAGL.DiagramID = DIAG.Diagram_ID
) V
--where v.Information_End_object = '09. Barrage'
where src_obj_id in 
(
select object_id  from [SPARXSYSTEM].[dbo].t_diagramobjects diagobj , [SPARXSYSTEM].[dbo].t_diagram diag
where diagobj.Diagram_ID = diag.Diagram_ID
and diag.name = 'GBP_Gestion des Barrages'
)
order by  v.Information_End_object
;

--OBjet MCCD et MCD   Barrage Avril 2026 without Sub Querries 

select  objsrc.name  as Start_object ,objsrc.Stereotype as SrcSteriotype, --, (select obj.name from [SPARXSYSTEM].[dbo].t_object    obj  where conn.Start_Object_ID = obj.object_id )  Data_Entity_Start_object ,
 objtgt.name as End_object ,objtgt.Stereotype as TgtSteriotype, -- (select obj.name from [SPARXSYSTEM].[dbo].t_object    obj  where conn.END_Object_ID = obj.object_id )  Information_End_object, 
 conn.name connector_name ,conn.Direction, conn.Connector_Type
--, conn.Start_Object_ID as src_obj_id , conn.END_Object_ID as tgt_obj_id
 --objp.value AS TABLE_NAME  --, att.name AS ATTRIBUTE_NAME , attg.VALUE AS COLUMN_NAME 
from 
[SPARXSYSTEM].[dbo].t_diagram   diag ,--, t_objectproperties objp --, t_attribute att, t_attributetag attg
[SPARXSYSTEM].[dbo].t_diagramlinks   diagL ,
[SPARXSYSTEM].[dbo].t_connector   conn,
[SPARXSYSTEM].[dbo].t_object     objsrc,
[SPARXSYSTEM].[dbo].t_object     objtgt
where 
 diag.name = 'Portée Données - Informations'
and diagL.ConnectorID = conn.Connector_ID
AND DIAGL.DiagramID = DIAG.Diagram_ID
and objsrc.Object_ID = conn.Start_Object_ID
and objtgt.Object_ID = conn.End_Object_ID
AND conn.Connector_Type='Realisation'
--AND ( objsrc.name = '09. Barrage' or objtgt.name = '09. Barrage')
order by objtgt.name
 
;

select  objsrc.name  as Start_object ,objsrc.Stereotype as SrcSteriotype, 
 objtgt.name as End_object ,objtgt.Stereotype as TgtSteriotype,  
 conn.name connector_name ,conn.Direction, conn.Connector_Type
 from 
[SPARXSYSTEM].[dbo].t_diagram   diag ,
[SPARXSYSTEM].[dbo].t_diagramlinks   diagL ,
[SPARXSYSTEM].[dbo].t_connector   conn,
[SPARXSYSTEM].[dbo].t_object     objsrc,
[SPARXSYSTEM].[dbo].t_object     objtgt
where 
 diag.name = 'Portée Données - Informations'
and diagL.ConnectorID = conn.Connector_ID
AND DIAGL.DiagramID = DIAG.Diagram_ID
and objsrc.Object_ID = conn.Start_Object_ID
and objtgt.Object_ID = conn.End_Object_ID
AND conn.Connector_Type='Realisation'
AND ( objsrc.name = '09. Barrage' or objtgt.name = '09. Barrage')

SELECT * FROM (
select  objsrc.name  as Start_object ,objsrc.Stereotype as SrcSteriotype, 
 objtgt.name as End_object ,objtgt.Stereotype as TgtSteriotype,  
 conn.name connector_name ,conn.Direction, conn.Connector_Type, conn.Start_Object_ID as src_obj_id , conn.End_Object_ID as tgt_obj_id
 from 
[SPARXSYSTEM].[dbo].t_diagram   diag ,
[SPARXSYSTEM].[dbo].t_diagramlinks   diagL ,
[SPARXSYSTEM].[dbo].t_connector   conn,
[SPARXSYSTEM].[dbo].t_object     objsrc,
[SPARXSYSTEM].[dbo].t_object     objtgt
where 
 diag.name = 'Portée Données - Informations'
and diagL.ConnectorID = conn.Connector_ID
AND DIAGL.DiagramID = DIAG.Diagram_ID
and objsrc.Object_ID = conn.Start_Object_ID
and objtgt.Object_ID = conn.End_Object_ID
AND conn.Connector_Type='Realisation'
--AND ( objsrc.name = '09. Barrage' or objtgt.name = '09. Barrage')
) V
--where v.Information_End_object = '09. Barrage'
where src_obj_id   in 
(
select object_id  from [SPARXSYSTEM].[dbo].t_diagramobjects diagobj , [SPARXSYSTEM].[dbo].t_diagram diag
where diagobj.Diagram_ID = diag.Diagram_ID
and diag.name = 'GBP_Gestion des Barrages'
)
order by  v.Start_object


SELECT * FROM T_PACKAGE WHERE NAME = 'test_STH';

SELECT * --Name , Stereotype 
FROM T_OBJECT where package_id = 38736;



SELECT * FROM t_object;

select  distinct obj.name  AS ENTITY_NAME , objp.value AS TABLE_NAME, OBJ.ea_guid  --, att.name AS ATTRIBUTE_NAME , attg.VALUE AS COLUMN_NAME 
from t_diagramobjects diagobj , t_object obj, t_diagram diag, t_objectproperties objp --, t_attribute att, t_attributetag attg
where diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name in ( 'F00 - GDH_HC Marché des halocarbures - Global',
'F01 - GDH_HC Marché des halocarbures - Identité des acteurs',
'F02 - GDH_HC Marché des halocarbures - Dépôt de renseignements',
'F03 - GDH_HC Marché des halocarbures - Catalogue des halocarbures',
'F04 - GDH_HC Marché des halocarbures - Commerce d''halocarbures',
'F05 - GDH_HC Marché des halocarbures - Pilotage Journalisation'
)
and obj.Object_ID = objp.Object_ID
and objp.property = 'code'
--and objp.value   like 'JR_%'
--and att.Object_ID = obj.Object_ID
--and attg.ElementID = att.ID
--and attg.Property = 'Code'
--AND attg.VALUE IS NULL
--ORDER BY objp.value, attg.VALUE;


-- list package tree
 ;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Catalogue Entités de données' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  ph.PKG_NAME, ph.FULL_PATH, ph.PKG_ID
        FROM PackHierarchy ph
		;


	-- Check unicity object in the catalogue
		 ;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Catalogue Entités de données' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  DISTINCT  objprop.value AS TABLE_NAME, ph.FULL_PATH, tobj.Name AS ENTITY_NAME, tobj.Stereotype, objprop.Property, objprop.value
        FROM PackHierarchy ph , t_object tobj, t_objectproperties objprop
		where --PKG_NAME= 'Tmp_GES_inProgress'  -- Repertoire source de migration par systeme
        --and PKG_NAME != 'Commun Cible'
        --FULL_PATH not like '%Temp%'
		
		PKG_NAME = 'Tmp_CLIMATO_In_Progress'
		AND 
		tobj.Package_ID = ph.PKG_ID
        and tobj.Object_ID = objprop.Object_ID
		--and objprop.value NOT LIKE  'SG_%'
		--and objprop.value NOT LIKE  'EC_%'
		--and objprop.value NOT LIKE  'CE_%'
		--and objprop.value NOT LIKE  'RA_%'
		--and objprop.value NOT LIKE  'PE_%'
		AND tobj.Name NOT LIKE '%XXXXX%'
		AND tobj.Name NOT LIKE '%YYYYY%'
		AND tobj.Name NOT LIKE '%Copy%'
		--AND tobj.Name NOT LIKE 'C_%'
		and objprop.Property = 'Code'
		--AND tobj.Stereotype  = 'Entité données'
		--AND  objprop.value LIKE  'SG_CONCL_LIEU_INTRV%'
		--and  tobj.Name = 'BAIL'
        order by TABLE_NAME;

		SELECT * FROM T_package where name = 'Demande de service'; --38740
				SELECT * FROM t_object where Package_ID = 38740; --218355 for  BAIL

		select * from t_objectproperties where object_id = 218355 and property= 'Code';

		 ;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Catalogue Entités de données' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT   objprop.value AS TABLE_NAME,  COUNT(objprop.value)  AS NB_TABLE --, ph.FULL_PATH, tobj.Name AS ENTITY_NAME, tobj.Stereotype
        FROM PackHierarchy ph , t_object tobj, t_objectproperties objprop
		where 
		tobj.Package_ID = ph.PKG_ID
        and tobj.Object_ID = objprop.Object_ID
		--and  FULL_PATH not like '%Temp%'
		and objprop.value LIKE  '%SG_PERSONNE_CONTACT_INTRV%'
		AND tobj.Name NOT LIKE '%XXXXX%'
		AND tobj.Name NOT LIKE '%YYYYY%'
		AND tobj.Name NOT LIKE '%Copy%'
		AND tobj.Name NOT LIKE 'C_%'
		and objprop.Property = 'Code'
		AND tobj.Stereotype  = 'Entité données'
		GROUP BY objprop.value
		HAVING COUNT(objprop.value) !=1		
        order by COUNT(objprop.value) 



		SELECT * FROM T_OBJECT WHERE NAME = 'DÉCLARATION' and Package_ID = 22393; --obj id = 145661
		SELECT * FROm  t_package where package_id in (22408,22393,30816);

		select * from t_objectproperties where Object_ID = 145661;

select distinct-- obj.name  AS ENTITY_NAME , 
objp.value AS TABLE_NAME  --, att.name AS ATTRIBUTE_NAME , attg.VALUE AS COLUMN_NAME 
from t_diagramobjects diagobj , t_object obj, t_diagram diag, t_objectproperties objp, t_attribute att, t_attributetag attg
where diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name = 'GMDR_Gestion des matières dangereuses et résiduelles'
and obj.Object_ID = objp.Object_ID
and objp.property = 'code'
--and objp.value like 'HC_%'
and att.Object_ID = obj.Object_ID
and attg.ElementID = att.ID
and attg.Property = 'Code'
--AND attg.VALUE LIKE  '%YYY%'
--AND obj.NAME LIKE   '%YYY%'
--ORDER BY objp.value, attg.VALUE


select distinct  obj.name  AS ENTITY_NAME , objp.value AS TABLE_NAME -- , att.name AS ATTRIBUTE_NAME , attg.VALUE AS COLUMN_NAME 
from t_diagramobjects diagobj , t_object obj, t_diagram diag, t_objectproperties objp, t_attribute att, t_attributetag attg
where diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name = 'CL_Climatologie'
and obj.Object_ID = objp.Object_ID
and objp.property = 'code'
--and objp.value like 'HC_%'
and att.Object_ID = obj.Object_ID
and attg.ElementID = att.ID
and attg.Property = 'Code'
AND obj.NAME  LIKE '%YYYY%'
--ORDER BY objp.value, attg.VALUE
;


-- Find object in the catalogue
		 ;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Catalogue Entités de données' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  DISTINCT  '''' + objprop.value + ''','  AS TABLE_NAME , FULL_PATH, tobj.Name, tobj.Stereotype
        FROM PackHierarchy , t_object tobj
		, t_objectproperties objprop
		where --PKG_NAME= 'tmp_GTS'  -- Repertoire source de migration par systeme
        --and PKG_NAME != 'Commun Cible'
        --FULL_PATH not like '%Temp%'
		--AND 
		tobj.Package_ID = PKG_ID
        and tobj.Object_ID = objprop.Object_ID
		and objprop.value LIKE  'SE_CLASSEMENT_BARRAGE%'
        order by TABLE_NAME;

		----------------------------
	 ;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM T_PACKAGE t
            WHERE t.NAME = 'Catalogue Entités de données' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM T_PACKAGE e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  DISTINCT   objprop.value   AS TABLE_NAME , FULL_PATH, tobj.Name, tobj.Stereotype
        FROM PackHierarchy , t_object tobj
		, t_objectproperties objprop
		where --PKG_NAME= 'Tmp_GES_inProgress'  -- Repertoire source de migration par systeme
        --and PKG_NAME != 'Commun Cible'
        FULL_PATH not like '%Temp%'
		AND 
		tobj.Package_ID = PKG_ID
        and tobj.Object_ID = objprop.Object_ID
		--and objprop.value LIKE  'EC_IDENTIFIANT%'
        --order by TABLE_NAME;
		AND   objprop.value
IN (
'EC_EMPLOYE',
'EC_IDENTIFIANT',
'EC_MUNICIPALITE',
'GT_AUTRE_ADRESSE_AFFECTEE',
'GT_CARACTERISTIQUE_DOSSIER',
'GT_CATEGORIE_CONTAMINANT',
'GT_CONTAMINANT',
'GT_CONTEXTE_INSITU',
'GT_ELEMENT_DECLENCHEUR',
'GT_FICHE_CONTA_MILIEU_RECPT',
'GT_FICHE_TC_CARACTER_DOSSIER',
'GT_FICHE_TC_NIVEAU_CONTAMIN',
'GT_FICHE_TERRAIN_CONTAMINE',
'GT_JOURNAL_BORD',
'GT_JOURNAL_BORD_SUIVI',
'GT_LIEU_CONTAMINE',
'GT_MILIEU_RECEPTEUR',
'GT_MOMENT_QUALITE_SOLS',
'GT_NATURE_TRAVAUX',
'GT_NIVEAU_CONTAMINATION',
'GT_TECHNIQUE_REHABILITATION',
'GT_TRAIT_INSITU_CONTAMINANT',
'GT_TRAITEMENT_INSITU',
'GT_TRAVAUX',
'GT_TRAVAUX_TECH_REHABILI',
'GT_TYPE_CONTAMINATION',
'GT_TYPE_PROPRIETAIRE',
'GT_TYPE_SOL',
'JR_FENETRE_JOURNAL',
'JR_MOTIF_JOURNAL',
'JR_TYPE_TRANSACTION',
'SG_DOCUMENT_DELIVRE',
'SG_INTERVENANT',
'SG_LIEU_INTERVENTION'
);




SELECT * FROM t_objecT  WHERE NAME = 'TableSimple_GB'; --189146
select * from t_diagramobjects where Object_ID  = 189146 ;



select  --distinct 
obj.name  AS ENTITY_NAME , 
objp.value AS TABLE_NAME  --, att.name AS ATTRIBUTE_NAME , attg.VALUE AS COLUMN_NAME 
from t_diagramobjects diagobj ,
t_object obj,
t_diagram diag,
t_objectproperties objp --, t_attribute att, t_attributetag attg
where diagobj.Object_ID = obj.Object_ID
and diagobj.Diagram_ID = diag.Diagram_ID
and diag.name = 'GBP_Gestion des Barrages'
and obj.Object_ID = objp.Object_ID
and objp.property = 'code'
--and obj.name    like '%YYYYY%'
--AND obj.name LIKE 'EC_%'
--and att.Object_ID = obj.Object_ID
--and attg.ElementID = att.ID
--and attg.Property = 'Code'
--AND objp.VALUE  like  '%SIMP%' --IS NULL
and obj.name = 'TableSimple_GB'
ORDER BY objp.value--, attg.VALUE;


select * from [SPARXSYSTEM].[dbo].[t_attribute];

--List of association Class in a diagram 
SELECT * FROM (
SELECT D.name as DIGARMA_NAME , t.name AS Connector_name,
(SELECT name from [SPARXSYSTEM].[dbo].[t_object]  where object_id = T.start_object_id ) as ENTITY_START,
(SELECT name from [SPARXSYSTEM].[dbo].[t_object] where object_id = T.end_object_id ) as ENTITY_end
FROM [SPARXSYSTEM].[dbo].[T_CONNECTOR]  T ,  [SPARXSYSTEM].[dbo].[t_diagramlinks] dl,  [SPARXSYSTEM].[dbo].[t_diagram]  d -- , t_connectortag TT
WHERE 
 dl.ConnectorID = t.Connector_ID
and d.Diagram_ID = dl.DiagramID
--AND T.NAME =  'Est Affecte'
and d.name =  'SG_Sago'--'SEBP_Securite et entretien des barrages_cible'
AND SourceCard LIKE '%*%' AND DestCard LIKE '%*%'
AND T.Connector_Type ='Association' and T.SubType = 'Class'
--and T.Connector_ID = TT.ElementID
--and TT.Property = 'Code'
AND t.name is not null
) V WHERE ENTITY_START NOT LIKE '%XXXXX%'
AND ENTITY_END NOT LIKE '%XXXXX%'
AND ENTITY_START NOT LIKE '%YYYYY%'
AND ENTITY_END NOT LIKE '%YYYYY%'
AND UPPER(DIGARMA_NAME) NOT LIKE '%SOURCE%'
ORDER BY DIGARMA_NAME;





;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM   [SPARXSYSTEM].[dbo].[T_PACKAGE] t
            WHERE t.NAME = 'Catalogue Entités de données' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM [SPARXSYSTEM].[dbo].[T_PACKAGE] e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  objprop.value, Count(1) Nombre 
        FROM  PackHierarchy  , 
		[SPARXSYSTEM].[dbo].[t_object] tobj
		, [SPARXSYSTEM].[dbo].[t_objectproperties] objprop
		
		where tobj.Package_ID = PKG_ID
        and tobj.Object_ID = objprop.Object_ID AND PKG_NAME not like 'Tmp'
		and Tobj.NAME  not like '%XXXXX%' and Tobj.NAME  not like '%YYYYY%'
			Group by  objprop.value 
			Having count(1) !=1
   
   
   ;WITH PackHierarchy AS (
            SELECT t.PACKAGE_ID AS PKG_ID , t.Name AS PKG_NAME, t.PARENT_ID AS PARENT_ID, 1 AS Level 
			,CAST(t.Name AS NVARCHAR(555))  AS  FULL_PATH
			FROM   [SPARXSYSTEM].[dbo].[T_PACKAGE] t
            WHERE t.NAME = 'Catalogue Entités de données' -- Start with top-level root
            UNION ALL
            SELECT e.PACKAGE_ID AS PKG_ID, e.Name AS PKG_NAME, e.PARENT_ID, eh.Level + 1
			,CAST(CAST(eh.FULL_PATH AS NVARCHAR(555)) +  '/' + CAST(e.name AS NVARCHAR(555)) AS NVARCHAR(555)) AS FULL_PATH
            FROM [SPARXSYSTEM].[dbo].[T_PACKAGE] e
            INNER JOIN PackHierarchy eh ON e.PARENT_ID = eh.PKG_ID
        )
        SELECT  DISTINCT tobj.Object_ID,  tobj.NAME, objprop.value AS TABLE_NAME, FULL_PATH, tobj.Name, tobj.Stereotype
        FROM  PackHierarchy  , 
		[SPARXSYSTEM].[dbo].[t_object] tobj
		, [SPARXSYSTEM].[dbo].[t_objectproperties] objprop
		where --PKG_NAME = 'Modèle conceptuel de données'  -- Repertoire source de migration par systeme
        --PKG_NAME = 'Modèle physique_RETRO'
        --FULL_PATH not like '%Temp%'
		--AND 
			tobj.Package_ID = PKG_ID
        and tobj.Object_ID = objprop.Object_ID
			and objprop.value LIKE  'CE_COURS_DEAU'
        order by TABLE_NAME



		SELECT TOBJDOM.name AS DOMAIN ,TOBJSUJ.name as SUJET , tobj.name AS OBJInformation, tobj.Stereotype, 
		replace(replace(replace(replace(replace(replace(replace(replace(replace(tOBJ.note, '&#233;', 'é'),'&#224;','a') ,'&#226;','a'),'&#232;','e'),'&#234;','e'), '&#201;','e'), '&#249;', 'ù' ), '&#171',''),'&#187','') Note_Commentaire 
FROM [SPARXSYSTEM].[dbo].[T_PACKAGE] TPACK , [SPARXSYSTEM].[dbo].[T_PACKAGE] TPACK_PARENT ,
[SPARXSYSTEM].[dbo].[T_OBJECT] TOBJ, [SPARXSYSTEM].[dbo].[T_OBJECT] TOBJSUJ,  [SPARXSYSTEM].[dbo].[T_OBJECT] TOBJDOM
WHERE 
TPACK.Parent_ID = TPACK_PARENT.Package_ID
AND TPACK.NAME = 'Volet Information'
AND TPACK_PARENT.NAME = 'AEM'
AND TOBJ.PACKAGE_ID = TPACK.PACKAGE_ID
and tobj.Stereotype in ('Domaine Information','Sujet Information','Objet Information')
AND tobj.name IS NOT NULL
and TOBJ.parentid = TOBJSUJ.Object_ID
and TOBJSUJ.ParentID = TOBJDOM.Object_ID
--AND TOBJDOM.name = '06 Client'
--AND TOBJSUJ.name = '06.01 Information Client'
--AND tobj.name ='06. Client'
order by TOBJDOM.name,TOBJSUJ.name,tobj.name



SELECT * FROM [SPARXSYSTEM].[dbo].[T_XREF] WHERE upper(DESCRIPTION) like '%APPLICATIONFUNCTION%';