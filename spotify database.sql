-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);


                              -----Exploratory data analysis------




select count(*) from spotify;   ---20594---

select count(distinct artist) from spotify;		---	---2074----	


select count (distinct album ) from spotify ;      ---11854---

select count (distinct album_type ) from spotify ;    ---3---

select max(duration_min) from spotify;   ---77.93--

select min(duration_min) from spotify;---0--


select * from spotify where duration_min =0;

delete from spotify where duration_min =0;

select distinct channel from spotify;  ---6673---- 



select distinct most_played_on  from spotify; 

select count(most_played_on) from spotify where most_played_on = 'Youtube';  ----4900---

select count(most_played_on) from spotify where most_played_on = 'Spotify'; --15692--



							------ DATA ANALYSIS LEVEL ONE ---------


---1)Retrieve the names of all tracks that have more than 1 billion streams0.



select * from spotify 
where stream > 2200000000



--- 2)list the album and its count by using group by function.


select album,count(*) from spotify group by 1;


--- 3)Get the total number of comments for tracks where licensed = TRUE.


select comments ,licensed from spotify where licensed ='true';     ---14060---


--- 4)Find all tracks that belong to the album type single.

select track,album_type from spotify where album_type ='single';



--- 5)Count the total number of tracks by each artist.



select artist 
       ,count(*) total_arrtist 
	   from spotify 
	   group by artist
	   order by 2  ;



			-----------			------medium level --------------------------

 ---1) calculated the average denceability  of Track in  each ablum 				

 select album,
         avg (danceability) as avg_danceability
		 from spotify
		 	group by 1
			 order by 2 desc;
			---- same problem----

select 
      artist,
	  avg(energy) as avg_energy from spotify group by 1 		
			 	
-- 2) find the top 5 tracks with the hightest energy level	--

select
      track,
	  max (energy)
      from spotify
	  group by 1
	  order by 2 desc
	  limit 5;

	  -----same problem----
select 
      title,
	  max (views)
	  from spotify
	  group by 1
	  order by 2 desc
	  limit 5;

 -- 3) list all the tracks along with the views and likes where offical_video =true



select track,  
       sum (views) as total_views,
	   sum(likes) as total_views
	   from spotify
	   where official_video = 'true'
	   group by 1 	order by 2 desc;             ----1000 of 13651


select 
      track,
	  sum(views) as total_viwes,
	  sum(likes) as total_likes
	  from spotify
	  where official_video= 'true'
	  group by 1 order by 2 desc;
	   


-- 4) for  each  album, calculated the  total view oa all associated  tracks .


select 
       album,
	   track,
	   sum(views) as total_view
	   from spotify
	   group by 1 , 2
	   order by 3 desc;



select
       album,
	   track,
	   sum(views) as total_views 
	   from spotify
	   group by 1,2
	 

	  
---5) retrrive the track name that have been  stremed  on spotify  in each album
	  
	 
SELECT * FROM
(SELECT

     track, 
	 -- most_played_on,
	 COALESCE(SUM(CASE WHEN most_played_on ='Youtube' THEN stream END ),0) as streamed_on_youtube,
	 COALESCE (SUM(CASE WHEN most_played_on ='Spotify' THEN stream END ),0) as streamed_on_spotify
from  spotify
group by 1 
) 
where 
       	streamed_on_spotify > streamed_on_youtube
	    and 
        streamed_ON_youtube <>0
		order by 2 desc;


select * from

(select  
      track, 
	   coalesce (sum (CASE WHEN most_played_on ='Youtube' THEN stream END),0) as streamed_on_youtube,
	   coalesce (sum (CASE WHEN most_played_on ='Spotify' THEN stream END),0)  as streamed_on_spotify
	  -- most_played_on
from spotify
group by 1)

where 
      streamed_on_youtube> streamed_on_spotify
and 
streamed_on_spotify <>0
order by 2 desc;
	   
       


--------------------------ADCANCED LEVEL QUESTIONS ----------

-- 1) find  the top 3 most-viewed track  for each artist using windows functions----


----find out each artist  and total views  for each track 
----track with the heighest view  for each artists
----dense rank
----cte and filter  ranks<=3 


with Ranking_artists   ----- this will help us to get top most-views  3 artists track 
as
(select 
       artist,
	   track,
	   sum(views) as total_views,
	   dense_rank () over (partition by  artist order by sum(views)desc) as rank ---- this will give the rank for artist with diffrent track like 12345--
from spotify
group by 1,2
order by 1,3 desc
)
select * from Ranking_artists
where rank <=3;
 

---2) write a quary  to finnd  tracks where  the liveness  score is above the average 


select *from spotify
select avg(liveness) from spotify;	 --- frist find the average of livness						---0.19--



 select track ,artist, liveness from spotify
where liveness >(select avg(liveness) from spotify);


---3) use a with clause  to calculated the diffrece between the highest and the lowest energy values  for track in each column.

 --- first put the min ,max aggragation function and 
 --- use with cte function
 ----then diffrece min- max  from cte


  
with cte
as
(select 
		album,
		max(energy) as maxenergy,
        min(energy) as minenergy
from spotify
group by 1
)
select  album,
      maxenergy - minenergy as diff_energy

 from cte
 order by 1;











