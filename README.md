# Spotify-Data-Exploration-with-SQL-

This repository contains SQL queries for analyzing data from a Spotify dataset. The project includes exploratory data analysis, data manipulation, and advanced query tasks such as window functions and Common Table Expressions (CTEs).

![SPOTIFY  IMG](https://github.com/user-attachments/assets/265d661f-432a-4d0c-8772-77e4e05667f4)
[Spotify SQL Project.pdf](https://github.com/user-attachments/files/17364727/Spotify.SQL.Project.pdf)

```sql
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
```
##Exploratory Data Analysis

*Total Rows in the Table

```sql
SELECT COUNT(*) FROM spotify;
-- Output: 20594
```

*Unique Artists, Albums, and Album Types

```sql
SELECT COUNT(DISTINCT artist) FROM spotify;
-- Output: 2074

SELECT COUNT(DISTINCT album) FROM spotify;
-- Output: 11854

SELECT COUNT(DISTINCT album_type) FROM spotify;
-- Output: 3
```

*Minimum and Maximum Duration of Tracks

```sql
SELECT MAX(duration_min) FROM spotify;
-- Output: 77.93

SELECT MIN(duration_min) FROM spotify;
-- Output: 0
```

*Remove Tracks with 0 Duration

```sql
DELETE FROM spotify WHERE duration_min = 0;

```

*Count by Most Played On (Spotify vs. YouTube)

```sql
SELECT COUNT(most_played_on) FROM spotify WHERE most_played_on = 'Youtube';
-- Output: 4900

SELECT COUNT(most_played_on) FROM spotify WHERE most_played_on = 'Spotify';
-- Output: 15692
```

##Basic Data Analysis

*Retrieve Tracks with More Than 2 Billion Streams

```sql
SELECT * FROM spotify WHERE stream > 2200000000;
```

*List Album and Track Count

```sql
SELECT album, COUNT(*) FROM spotify GROUP BY album;
```

*Total Comments for Licensed Tracks

```sql
SELECT SUM(comments) FROM spotify WHERE licensed = TRUE;
```

* Tracks that Belong to "Single" Album Type
```sql
SELECT track FROM spotify WHERE album_type = 'single';
```

*Count of Tracks by Each Artist

```sql
SELECT artist, COUNT(*) AS total_tracks
FROM spotify
GROUP BY artist
ORDER BY total_tracks DESC;
```

##Medium-Level Queries

*Average Danceability per Album

```sql
SELECT album, AVG(danceability) AS avg_danceability
FROM spotify
GROUP BY album
ORDER BY avg_danceability DESC;
```

*Top 5 Tracks with Highest Energy Levels

```sql
SELECT track, MAX(energy) AS max_energy
FROM spotify
GROUP BY track
ORDER BY max_energy DESC
LIMIT 5;
```

*Tracks with Views and Likes for Official Videos

```sql
SELECT track, SUM(views) AS total_views, SUM(likes) AS total_likes
FROM spotify
WHERE official_video = TRUE
GROUP BY track
ORDER BY total_views DESC;
```

*Total Views for Each Album

```sql
SELECT album, SUM(views) AS total_views
FROM spotify
GROUP BY album
ORDER BY total_views DESC;
```

*Retrieve Tracks Streamed More on Spotify Than YouTube

```sql
SELECT track,
    COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END), 0) AS streamed_on_youtube,
    COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END), 0) AS streamed_on_spotify
FROM spotify
GROUP BY track
HAVING streamed_on_spotify > streamed_on_youtube;
```

##Advanced-Level Queries

*Top 3 Most-Viewed Tracks for Each Artist Using Window Functions
```sql
WITH Ranking_artists AS (
    SELECT artist, track, SUM(views) AS total_views,
           DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM(views) DESC) AS rank
    FROM spotify
    GROUP BY artist, track
)
SELECT * FROM Ranking_artists
WHERE rank <= 3;
```

* Tracks with Liveness Above Average
```sql
SELECT track, artist, liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify);
```

*Difference Between Highest and Lowest Energy for Each Album

```sql
WITH cte AS (
    SELECT album, MAX(energy) AS max_energy, MIN(energy) AS min_energy
    FROM spotify
    GROUP BY album
)
SELECT album, (max_energy - min_energy) AS energy_difference
FROM cte;
```


## Author - VIRAJ LOHAKARE

This project showcases SQL skills essential for database management and analysis. For more content on SQL and data analysis, connect with me through the following channels:


- **LinkedIn**: [Connect with me professionally](www.linkedin.com/in/
viraj-lohakare-b15006321)



Thank you for your interest in this project!
  





