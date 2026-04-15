-- 10. TABELITE ÜHENDAMINE

-- 10.1. Kõik eelarveread eelarve tabelist ja nendega seotud müügiesindaja nimi müügiesindajate tabelist.
select *
from budget_table AS bt
left join sales_rep_table as srt
on bt.sales_rep_id = srt.sales_rep_id 
;

-- 10.3. Kõik müügiesindajad müügiesindajate tabelist ja nendega seotud eelarveread eelarve tabelist.
select *
from sales_rep_table as srt 
left join budget_table as bt 
on srt.sales_rep_id  = bt.sales_rep_id 
;

-- 10.4. Näita ainult ridu, millel on müügiesindaja nii eelarve tabelis kui ka väärtus müügiesindajate tabelis.
select *
from sales_rep_table as srt
inner join budget_table as bt 
on srt.sales_rep_id  = bt.sales_rep_id 
;

-- 10.5. Näita kõiki ridu eelarve tabelist ja kõiki ridu müügiesindaja tabelist.
select *
from budget_table bt  
full outer join sales_rep_table srt 
on bt.sales_rep_id = srt.sales_rep_id 
;

-- 10.6. Näita ridu eelarve tabelist, millele pole müügiesindaja tabelis müügiesindajat kirjeldatud.
select *
from budget_table bt 
left join sales_rep_table srt 
on bt.sales_rep_id = srt.sales_rep_id 
where srt.sales_rep_id is null
;

-- 10.7. Näita ridu müügiesindaja tabelist, millele pole kirjeldatud ridu eelarve tabelis.
select *
from sales_rep_table srt 
left join budget_table bt 
on srt.sales_rep_id = bt.sales_rep_id 
where bt.sales_rep_id is null 
;

-- 10.8. Näita müügiesindajaid, kellel on puudu eelarve või müügiesindaja tabelist rida.
select bt.sales_rep_id, srt.sales_rep_id 
from sales_rep_table srt 
full outer join budget_table bt 
on srt.sales_rep_id = bt.sales_rep_id 
where srt.sales_rep_id is null or bt.sales_rep_id is null 
;

-- 10.9. Näita ridu müügitabelist, millel on olemas müügiesindaja info eelarve ja müügiesindaja tabelis.
select *
from sales_table st 
inner join budget_table bt on st.sales_rep_id = bt.sales_rep_id 
inner join sales_rep_table srt on st.sales_rep_id = srt.sales_rep_id
;

