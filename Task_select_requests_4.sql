--количество исполнителей в каждом жанре:
SELECT g.title, count(ga.genre_id) FROM genres_authors ga
	JOIN genres g ON ga.genre_id = g.id
	GROUP BY g.title;

--количество треков, вошедших в альбомы 2019-2020 годов:
SELECT count(t.title) FROM tracks t
	JOIN albums a ON t.album_id = a.id
	--WHERE a.YEAR = '2019' or a.YEAR = '2020'
	WHERE a."year" BETWEEN '2019' AND '2020';

--средняя продолжительность треков по каждому альбому:
SELECT a.title AS albums, date_trunc('seconds', avg(t.duration)) FROM albums a
	JOIN tracks t ON t.album_id = a.id
	GROUP BY a.title;

--все исполнители, которые не выпустили альбомы в 2020 году:
SELECT name FROM authors
	WHERE name NOT in (
		SELECT authors.name FROM albums 
		JOIN albums_authors aa ON aa.album_id = albums.id
		JOIN authors ON aa.author_id = authors.id
		WHERE albums.year  = '2020'
		)
	ORDER BY authors.name;

--названия сборников, в которых присутствует конкретный исполнитель (выберите сами):
select DISTINCT c.title FROM albums_authors aa
	JOIN authors a ON aa.author_id = a.id
	JOIN albums a2 ON aa.album_id = a2.id 
	JOIN tracks t ON t.album_id = a2.id
	JOIN tracks_collections tc ON tc.track_id = t.id 
	JOIN collections c ON tc.collection_id = c.id 
	WHERE a.name LIKE 'Dizi Rem';

--название альбомов, в которых присутствуют исполнители более 1 жанра:
SELECT DISTINCT a.title FROM albums a 
	JOIN albums_authors aa ON aa.album_id = a.id
	JOIN authors a2 ON aa.author_id = a2.id 
	JOIN genres_authors ga ON ga.author_id = a2.id
	GROUP BY a.title , a2.name
	HAVING count(ga.genre_id) > 1;

--наименование треков, которые не входят в сборники:
SELECT t.title  FROM tracks t 
	JOIN tracks_collections tc ON tc.track_id = t.id
	WHERE tc.collection_id IS NULL;

--исполнителя(-ей), написавшего самый короткий по продолжительности трек 
--(теоретически таких треков может быть несколько):
SELECT a.name, t.duration FROM authors a
	JOIN albums_authors aa ON aa.author_id = a.id 
	JOIN albums a2 ON aa.album_id = a2.id 
	JOIN tracks t ON t.album_id = a2.id
	WHERE t.duration = (SELECT min(t.duration) FROM tracks t) 
	GROUP BY a.name, t.duration;

--название альбомов, содержащих наименьшее количество треков:
SELECT a.title AS albums FROM albums a 
	JOIN tracks t ON t.album_id = a.id
	GROUP BY a.title 
	HAVING count(t.title) = (
		SELECT count(*) FROM tracks t2
		GROUP BY t2.album_id
		ORDER BY t2.album_id
		LIMIT 1);
	
