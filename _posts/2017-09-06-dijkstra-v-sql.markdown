---
layout: post
title: "Dijkstra v SQL"
tags:
 - SQL
 - Dijkstra
---
# Na čem jsem pracoval
Posledních několik dní jsem strávil implementací a optimalizací dijkstrova algoritmu v plpgsql.

# Implementace
Výsledkem mého snažení je funkce **dijkstra**, která přebírá 2 id zastávek mezi kterými je třeba najít cestu, aktuální čas a vrací navštívené zastávky spolu s časem, který zabralo se na ně dostat. Níže je uvedená celá implementace funkce.

```sql
CREATE OR REPLACE FUNCTION dijkstra(varchar, varchar, interval) RETURNS
TABLE(
	id VARCHAR,
	travel_time INTERVAL
)
AS $$
DECLARE
	from_id ALIAS FOR $1;
	to_id ALIAS FOR $2;
	actual_time ALIAS FOR $3;
	nearest_stop RECORD;
	alternative_travel_time INTERVAL;
	neighbor RECORD;
BEGIN
	DROP TABLE IF EXISTS distances;
	DROP TABLE IF EXISTS previous_stops;
	DROP TABLE IF EXISTS priority_queue;
	-- Assign to every node a tentative distance value: set it to zero for our initial node and to infinity for all other nodes.
	CREATE TEMPORARY TABLE distances AS
		(SELECT stop_id, CASE stop_id
						WHEN from_id THEN INTERVAL '00:00:00' -- zero time for source node
						ELSE INTERVAL '99:59:59' -- Infinity for rest
					END	AS distance
					FROM stops);
		    
	CREATE TEMPORARY TABLE previous_stops AS
		SELECT stop_id origin, ''::VARCHAR destination FROM stops;

	-- Create priority queue and fill it with all stops
	CREATE TEMPORARY TABLE priority_queue AS 
		SELECT stop_id FROM stops;
        
   	-- Until queue is not empty     
	WHILE (SELECT COUNT(*) FROM priority_queue) != 0 LOOP
		-- Select stop with lowest distance in queue
		SELECT INTO nearest_stop p.stop_id, d.distance FROM priority_queue p JOIN distances d ON p.stop_id = d.stop_id ORDER BY distance ASC LIMIT 1;
		-- If we reached destination or stop with lowest priority is infinite stop loop
		IF nearest_stop.stop_id = to_id OR nearest_stop.distance >= INTERVAL '99:59:59' THEN
		  exit;
		END IF;
		-- Remove selected stop from queue
		DELETE FROM priority_queue p WHERE p.stop_id = nearest_stop.stop_id;
		-- FOR each neighbor of selected queue
		FOR neighbor IN SELECT * FROM nearest_stops(nearest_stop.stop_id, actual_time + nearest_stop.distance) LOOP
			alternative_travel_time := nearest_stop.distance + time_duration(neighbor.travel_time, nearest_stop.distance);
			IF alternative_travel_time < (SELECT distance FROM distances WHERE stop_id = neighbor.id) THEN
			    -- Set new distance to the neighbor
			    UPDATE distances SET distance = alternative_travel_time WHERE stop_id = neighbor.id;
			    -- Set new previous stop of our nearest stop
			    UPDATE previous_stops SET destination = nearest_stop.stop_id WHERE origin = neighbor.id;
			END IF;
		END LOOP;
	END LOOP;

	-- Reconstruct path from previous_stops 
	RETURN QUERY
		WITH RECURSIVE stop_path(id) AS (
				SELECT to_id
				UNION 
				SELECT prev.destination FROM stop_path p, previous_stops prev WHERE p.id = prev.origin AND prev.origin != ''
				)
		SELECT s.id, distance FROM stop_path s
		JOIN distances d
		ON s.id = d.stop_id;
END;
$$ LANGUAGE plpgsql;
```
Funkce využívá 2 další funkce a to **nearest_stop**, která vrací další zastávky, které následují v grafu. Dělá to tak, že nalezne zastávky na které se lze dostat ze spojů, které jezdí přes výchozí stanici a zároveň započítá zastávky, které jsou v určité vzdálenosti od výchozí stanice. Její implementace je následující:

```sql
CREATE OR REPLACE FUNCTION nearest_stops(varchar, interval) RETURNS
TABLE(
	id VARCHAR,
	travel_time INTERVAL
)
AS $$
DECLARE
	id ALIAS FOR $1;
	actual_time ALIAS FOR $2;
	geog geography;
BEGIN
	-- Save geography so we don't have to select it every time
	geog := (SELECT geom::geography FROM stops WHERE stop_id = id);
	RETURN QUERY
	WITH
		trips_with_stop AS (SELECT trip_id tid, stop_sequence seq
							FROM stop_times
							WHERE id = stop_id)
		SELECT stop_id sid, MIN(departure_time::INTERVAL) - actual_time travel_time FROM trips_with_stop
								JOIN stop_times ON tid = trip_id
								WHERE stop_sequence = (seq + 1) AND departure_time::INTERVAL >= actual_time
                GROUP BY sid
                UNION
                SELECT * FROM (SELECT stop_id, ROUND(ST_Distance(geom::geography, geog) / 1.4)::VARCHAR::INTERVAL t FROM stops) distances WHERE distances.t <= INTERVAL '00:10:00';
END;
$$ LANGUAGE plpgsql
   STABLE;
```
Poslední pomocná funkce **time_duration**  jednoduše přebírá dva intervaly a vrací čas, který mezi ními uběhl. Používá se pro relaxaci hrany
```sql
CREATE OR REPLACE FUNCTION time_duration(interval, interval) RETURNS INTERVAL
AS $$
DECLARE
	time_interval_a ALIAS FOR $1;
    time_interval_b ALIAS FOR $2;
BEGIN
	IF time_interval_a > time_interval_b THEN
		RETURN time_interval_a - time_interval_b;
    	ELSE
		RETURN time_interval_b - time_interval_a;
	END IF;
END;
$$ LANGUAGE plpgsql
   IMMUTABLE;
```
# Použití
Použití je relativně přímočaré. 
```sql
SELECT stop_name FROM dijkstra('U306Z102', 'U46Z1', '11:00:00') d JOIN stops s ON d.id = s.stop_id ORDER BY d.travel_time ASC;
```
Níže je uvedený výsledek a vizualizace nalezené cesty.
![Výsledek](https://i.imgur.com/upyrYt6.png)

![Cesta](https://i.imgur.com/QCbeBUW.png)
# Problémy součásné implementace
Současná implementace má několik problémů:

První problém je v tom, že algoritmus může naplánovat cestu, která nezahrnuje jízdu v žádném dopravním prostředku ovšem zahrnuje hodně přebíhání mezi jednotlivými zastávkami. Toto by bylo poměrně jednoduše řešitelné omezením počtu přeběhnutí mezi zástávkami.

Další problém je, že ne vždy se navržené výsledky shodují s idosem, který používám jako referenční implementaci.

Asi nejpalčivějším problémem je ovšem rychlost. Dotaz, který jsem uvedl v sekci použití zabral celých 14 s. Ačkoliv se mi za posledních pár dní podařilo tento problém zmenšit (původní implementace počítala cestu déla, jak 1 minutu), pořád mi příjde, že aplikaci zabere výpočet nepřiměřeně dlouho pro účel výpočtu heatmapy. 

