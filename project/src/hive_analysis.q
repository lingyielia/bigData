-- beeline
-- !connect jdbc:hive2://babar.es.its.nyu.edu:10000/

create database full;
use full;

CREATE EXTERNAL TABLE flow (
  station INT,
  time_of_day INT,
  day_of_week INT,
  flow_count INT,
  start_date STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION '/user/lz1714/project/hiveInput/full/flow';

CREATE EXTERNAL TABLE flowgroup (
  station INT,
  day_of_week INT,
  time_of_day INT,
  flow_sum FLOAT,
  start_date STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';

INSERT OVERWRITE TABLE flowgroup
SELECT station,
       day_of_week,
       time_of_day,
       SUM(flow_count) AS flow_sum,
       start_date
FROM flow
GROUP BY station, start_date, time_of_day, day_of_week
GROUPING SETS((station, start_date, time_of_day, day_of_week));
-- ORDER BY station ASC, start_date ASC, time_of_day ASC;


CREATE EXTERNAL TABLE incident (
  station INT,
  day_of_week INT,
  type STRING,
  time_of_day INT,
  start_date STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION '/user/lz1714/project/hiveInput/full/incid';

-- join two tables `flow` and `incident`
-- +------------+----------------+----------------+---------------+---------------+-------------+--+
-- | f.station  | f.day_of_week  | f.time_of_day  | f.flow_count  | f.start_date  |   i.type    |
-- +------------+----------------+----------------+---------------+---------------+-------------+--+
SELECT f.station, f.day_of_week, f.time_of_day, f.flow_count, f.start_date, i.type
FROM flow f LEFT OUTER JOIN incident i
ON (f.station = i.station AND f.time_of_day = i.time_of_day AND f.start_date = i.start_date);

-- group incident records
-- +----------+--------------+--------------+-------------+------------+--+
-- | station  | day_of_week  | time_of_day  | start_date  | incid_cnt  |
-- +----------+--------------+--------------+-------------+------------+--+
-- open a new table to store the result
CREATE EXTERNAL TABLE incident_count (
  station INT,
  day_of_week INT,
  time_of_day INT,
  start_date STRING,
  incid_cnt INT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';

INSERT OVERWRITE TABLE incident_count
SELECT station,
       MIN(day_of_week) AS day_of_week,
       time_of_day,
       start_date,
       COUNT(*) AS incid_cnt
FROM incident
GROUP BY station, time_of_day, start_date
GROUPING SETS((station, time_of_day, start_date));

-- join two tables `flow` and `incident_count`
-- +------------+----------------+----------------+---------------+---------------+--------------+--+
-- | f.station  | f.day_of_week  | f.time_of_day  | f.flow_count  | f.start_date  | i.incid_cnt  |
-- +------------+----------------+----------------+---------------+---------------+--------------+--+
CREATE EXTERNAL TABLE merged (
  station INT,
  day_of_week INT,
  time_of_day INT,
  flow_count INT,
  start_date STRING,
  incid_cnt INT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';

INSERT OVERWRITE TABLE merged
SELECT f.station, f.day_of_week, f.time_of_day, f.flow_sum, f.start_date, i.incid_cnt
FROM flowgroup f LEFT OUTER JOIN incident_count i
ON (f.station = i.station AND f.time_of_day = i.time_of_day AND f.start_date = i.start_date);

-- add column `incid_ineff` == incident in effect
-- +------------+----------------+----------------+---------------+---------------+--------------+----------------+--+
-- | m.station  | m.day_of_week  | m.time_of_day  | m.flow_count  | m.start_date  | m.incid_cnt  | m.incid_ineff  |
-- +------------+----------------+----------------+---------------+---------------+--------------+----------------+--+
-- | 0          | 6              | 5              | 30            | 06122016      | 1            | 1              |
-- | 0          | 6              | 3              | 220           | 06122016      | NULL         | 0              |
-- | 0          | 6              | 5              | 10            | 05302017      | NULL         | 0              |
-- | 0          | 1              | 2              | 70            | 05302017      | 2            | 1              |
-- | 0          | 1              | 5              | 50            | 05302017      | NULL         | 0              |
-- +------------+----------------+----------------+---------------+---------------+--------------+----------------+--+
CREATE EXTERNAL TABLE merged_final (
  station INT,
  day_of_week INT,
  time_of_day INT,
  flow_count INT,
  start_date STRING,
  incid_cnt INT,
  incid_ineff INT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';

INSERT OVERWRITE TABLE merged_final
SELECT station,
       day_of_week,
       time_of_day,
       flow_count,
       start_date,
       incid_cnt,
       CASE WHEN incid_cnt > 0 THEN 1
            ELSE                    0
        END incid_ineff
FROM merged;
-- to see where the table `merged_final` stored
-- SHOW CREATE TABLE merged_final;


-- each station, day_of_week, time_of_day has 2 records
-- (1 in-effect and 1 not in-effect)
-- +------------+----------------+----------------+----------------+-------------+-------------+----------------+--+
-- | g.station  | g.day_of_week  | g.time_of_day  | g.incid_ineff  | g.flow_avg  | g.flow_std  | g.sample_size  |
-- +------------+----------------+----------------+----------------+-------------+-------------+----------------+--+
-- | 0          | 1              | 2              | 0              | 45.0        | 5.0         | 2              |
-- | 0          | 1              | 2              | 1              | 70.0        | 0.0         | 1              |
-- | 0          | 6              | 5              | 0              | 170.0       | 0.0         | 1              |
-- | 0          | 6              | 5              | 1              | 115.0       | 105.0       | 2              |
-- +------------+----------------+----------------+----------------+-------------+-------------+----------------+--+
CREATE EXTERNAL TABLE grouped (
  station INT,
  day_of_week INT,
  time_of_day INT,
  incid_ineff INT,
  flow_avg FLOAT,
  flow_std FLOAT,
  sample_size INT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';

INSERT OVERWRITE TABLE grouped
SELECT station,
       day_of_week,
       time_of_day,
       incid_ineff,
       AVG(flow_count) AS flow_avg,
       STDDEV_POP(flow_count) AS flow_std,
       count(1) AS sample_size
FROM merged_final
GROUP BY station, day_of_week, time_of_day, incid_ineff
GROUPING SETS((station, day_of_week, time_of_day, incid_ineff))
ORDER BY station ASC, day_of_week ASC, time_of_day ASC, incid_ineff ASC;


-- reduce 2 records to 1 using streaming script
-- +----------+--------------+--------------+--------------+---------------+--+
-- | station  | day_of_week  | time_of_day  | flow_avg_no  | flow_avg_yes  |
-- +----------+--------------+--------------+--------------+---------------+--+
-- | 0        | 1            | 2            | 45.0         | 70.0          |
-- | 0        | 6            | 5            | 170.0        | 115.0         |
-- +----------+--------------+--------------+--------------+---------------+--+
add file hdfs://dumbo/user/lz1714/project/hiveInput/python_code/combine_records.py;

CREATE EXTERNAL TABLE flatted (
  station INT,
  day_of_week INT,
  time_of_day INT,
  flow_avg_no FLOAT,
  flow_avg_yes FLOAT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';

INSERT OVERWRITE TABLE flatted
SELECT TRANSFORM (station, day_of_week, time_of_day, incid_ineff,
                  flow_avg, flow_std, sample_size)
USING 'python combine_records.py'
AS station, day_of_week, time_of_day, flow_avg_no, flow_avg_yes
FROM grouped;

-- calculate mean, std, sample size for these two samples
SELECT (AVG(flow_avg_yes) - AVG(flow_avg_no)) / SQRT(POW(STDDEV_POP(flow_avg_yes), 2)/COUNT(flow_avg_yes) + POW(STDDEV_POP(flow_avg_no), 2)/COUNT(flow_avg_no)) AS Z
FROM flatted;
