---crear tabla con usuarios con más de 20 peliculas vistas y menos de 800

drop table if exists usuarios_sel;

create table usuarios_sel as 

select userId,
count(*) as cnt_rat
from ratings
group by userId
having cnt_rat >=20 and cnt_rat <=800;

----procesamientos---

drop table if exists consolidacion;

create table consolidacion as
               select * from movies as m
               inner join ratings as r on m.movieId= r.movieId;

                    
---crear tabla con peliculas que han sido vistas por más de 5 usuarios
drop table if exists movies_sel;

create table movies_sel as select movieId ,
                         count(*) as cnt_rat
                         from ratings
                         group by movieId
                         having cnt_rat>=3;


-------crear tablas filtradas de libros, usuarios y calificaciones ----

drop table if exists ratings_final;

create table ratings_final as
select t.movieId, 
t.title, 
t.genres, 
t.userId, 
t.rating, 
t.timestamp 
from consolidacion as t 
inner join usuarios_sel as u 
on t.userId = u.userId
inner join movies_sel as m
on m.movieId = t.movieId;

------ Cambio del fomrato de la fecha --------
drop table if exists base_lista2;

create table base_lista2 as
SELECT
title, 
genres, 
userId, 
rating, 
movieId,
timestamp
from ratings_final;

drop table if exists filtro3;
create table filtro3 as
               select round(avg(rating),2) as rating, count(*) as read_num,   movieId
               from base_lista2
               group by title
               having read_num > 5;

drop table if exists base_lista3;
create table base_lista3 as
select t.movieId, 
t.title, 
t.genres, 
t.userId, 
t.rating, 
t.timestamp 
from filtro3 as u
inner join base_lista2 as t 
on u.movieId = t.movieId;

drop table if exists filtro_rat;
create table filtro_rat as
select a.userId,
                                a.movieId,
                                a.rating,
                                a.timestamp
                                from ratings a
                                inner join usuarios_sel c
                                on a.userId =c.userId
                                inner join movies_sel b
                                on a.movieId =b.movieId;



drop table if exists filtro_rat2;
create table filtro_rat2 as
select a.userId,
                                a.movieId,
                                a.rating,
                                a.timestamp
                                from filtro_rat as a
                                INNER JOIN filtro3 as b
                                on a.movieId =b.movieId ;


drop table if exists consolidacion2;
create table consolidacion2 as
select a.userId,
                                a.movieId,
                                a.rating,
                                b.title,
                                b.genres
                                from filtro_rat2 as a
                                INNER JOIN movies as b
                                on a.movieId=b.movieId;