-- Задание 2

select 
	name "Наименование", 
	duration "Продолжительность"
from 
	tracks
where 
	duration = (select MAX(duration) from tracks);


select 
	name "Наименование"
from 
	tracks
where 
	duration >= '00:03:30'
order by duration;


select 
	name "Наименование" 
from 
	collection
where 
	release_date between '2018' and '2020';


select 
	name "Исполнитель" 
from 
	actors
where 
	name not like '% %';

select 
	name "Наименование"
from 
	tracks
where 
	name ilike 'my %'
	or name ilike '% my'
	or name ilike '% my %'
	or name ilike 'my'
	or name ilike 'мой %'
	or name ilike '% мой'
	or name ilike '% мой %'
	or name ilike 'мой';




-- Задание 3

select 
	g.name "Жанр",
	count(distinct (gc.actorid)) "Количество исполнителей"
from
	genres g	
join genreconnections gc on g.genresid = gc.genresid
group by g.name;

/* Добрый день, в лекциях говорится про джойны, вот я впринципи решил с помощью джойна, это не сложно,
 но я много работал в sql и я прывык к констркции с помощью которой я решил то же задание еще раз,
 результат одинаковый, на сколько вариант который ниже, без джойнов хуже чем с джойном, и почему.
 Мне удобнее когда просто закидываешь таблицы нужные во фром, и в where перечисляешь все связи айдишников через энд
 */

select 
	g.name "Жанр",
	count(distinct (gc.actorid)) "Количество исполнителей"
from
	genres g, 
	genreconnections gc
where 
	g.genresid = gc.genresid 
group by g.name;


select  
	count(tr.trackid) "Количество треков"
from tracks tr
join alboms a ON tr.albom_id = a.albomid
where a.release_date between '2019' and '2020';



select 
	a.name "Наименование", 
	avg(t.duration) "Средняя продолжительность треков"
from 
	alboms a,
	tracks t 
where 
	t.albom_id = a.albomid 
group by a.name;


select 
	act.name "Исполнитель"
from 
	alboms a,
	albomconnectors ac,
	actors act 
where 
	a.albomid = ac.albomid 
	and ac.actorid = act.actorid 
	and act."name" not in (select act.name from actors act 
							join albomconnectors ac on act.actorid = ac.actorid 
							join alboms a on ac.albomid = a.albomid 
							where a.release_date like '2020')
group by act.name;


select 
	col.name "Коллекция"
from
	actors a,
	albomconnectors ac,
	alboms alb,
	tracks tr,
	collectconnections cc,
	collection col
where
	a.actorid = ac.actorid 
	and ac.albomid = alb.albomid 
	and alb.albomid = tr.albom_id 
	and tr.trackid = cc.trackid 
	and cc.collectionid = col.collectionid 
	and a.name = 'Боб Дилан';
	
	
--Задание 4	

/*select
	alb.name "Наименование альбома"
from
	alboms alb,
	albomconnectors ac
where
	alb.albomid = ac.albomid 
	and ac.actorid in (select 
	distinct (a.actorid)
from
	actors a	
join genreconnections gc on a.actorid = gc.actorid 
where (select count(distinct (gc2.genresid)) from actors a2	
		left join genreconnections gc2 on a2.actorid = gc2.actorid
		where a2.name = a.name 
		group by a2.name) >1);*/	
	
	
select 
	distinct (alb.name) "Наименование альбома"
from 
	alboms alb
JOIN albomconnectors ac ON alb.albomid = ac.albomid 
JOIN genreconnections gc ON gc.actorid = ac.actorid 
GROUP BY alb.albomid , gc.actorid  
HAVING COUNT(gc.genresid) > 1;


/*Про треки которых нет в коллекциях, У меня в базе у все треки находятся в какой-то коллекции, 
но впринципи вроде запрос должен быть такой*/	
	
select 
	tr.name "Наименвоание трека"
from 
	tracks tr
left join collectconnections cc on tr.trackid = cc.trackid 
where cc.collectionid is null;


select 
	a.name "Исполнитель"
from 
	actors a,
	albomconnectors ac,
	tracks tr
where 
	a.actorid = ac.actorid 
	and ac.albomid = tr.albom_id 
	and tr.trackid  in (select tr1.trackid from tracks tr1
						where duration = (select min(duration) from tracks));


/*select 
	alb.name "Наименовнование альбома"
from
	tracks tr
join alboms alb on tr.albom_id = alb.albomid 
group by alb.name
having count(tr.albom_id) = (select min(track_count)
    						from (select count(tr2.albom_id) track_count
        							from tracks tr2
        							join alboms alb2 on tr2.albom_id = alb2.albomid 
        							group by alb2.name) counts);*/
        							
        						
select 
	alb.name "Наименовнование альбома"
from 
	alboms alb
join tracks tr ON alb.albomid = tr.albom_id
group by alb.albomid
having count(tr.trackid) = (select count(tr1.trackid) FROM tracks tr1
							    group by tr1.albom_id
							    order by 1
							    limit 1);        						
        						
