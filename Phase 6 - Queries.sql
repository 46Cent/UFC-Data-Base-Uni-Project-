--10 schnellste Kämpfe--
SELECT id, siegminute, kampfer.name, ergebnisart
FROM kampf k
JOIN kampf_kampfer kk ON k.id = kk.kampf
JOIN kampfer ON kk.kampfer = kampfer.name
WHERE siegrunde = 1 AND rolle IN ('W')
ORDER BY siegminute
LIMIT 10;

--Anteil der Kämpfe nach Gewichtsklasse--
SELECT stattgefunden_in, COUNT(stattgefunden_in)
FROM kampf
GROUP BY stattgefunden_in;

--Kämpfer mit meisten Siegen--
SELECT kampfer, COUNT(rolle) AS wins
FROM kampf_kampfer
WHERE rolle = 'W'
GROUP BY kampfer
ORDER BY COUNT(rolle) DESC
LIMIT 10;

--Kämpfer mit meisten Takedowns--
SELECT DISTINCT kampfer, SUM(takedowns) AS summe_takedowns
FROM kampf_kampfer
GROUP BY kampfer
ORDER BY SUM(takedowns) desc;

--Kampflose Kämpfer--
SELECT COUNT(name)
FROM kampfer k
LEFT JOIN kampf_kampfer kk on k.name = kk.kampfer
WHERE kk.kampf IS NULL;

--Meiste Kämpfe / Jahr--
SELECT f.name, EXTRACT(YEAR FROM e.datum) AS jahr, COUNT(*) AS fights_per_year
FROM kampf_kampfer kk
JOIN kampf k ON kk.kampf = k.id
JOIN event e ON k.enthalten_in = e.name
JOIN kampfer f ON kk.kampfer = f.name
GROUP BY f.name, jahr
ORDER BY COUNT(kk.kampfer) desc;

--ov's in der UFC--
SELECT *
FROM kampfer
WHERE name LIKE '%ov'

--Wachstum der Organisation--
SELECT EXTRACT(YEAR FROM e.datum) AS jahr, COUNT(e.name) AS anzahl_events
FROM event e
GROUP BY jahr
ORDER BY jahr;

--Welche Auslage ist die "effektivste" ?--
SELECT
k.auslage,
COUNT(*) FILTER (WHERE kk.rolle = 'W')::decimal / COUNT(*) AS win_rate
FROM kampfer k
JOIN kampf_kampfer kk ON kk.kampfer = k.name
GROUP BY k.auslage
ORDER BY win_rate DESC;

--Wie enden Kämpfe (meistens)--
SELECT ergebnisart, COUNT(*)
FROM kampf
GROUP BY ergebnisart