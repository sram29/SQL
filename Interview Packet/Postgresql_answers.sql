--- Copyright - Health eHeart Group 2018 ---

-- INSTRUCTIONS:
-- Assume that the following tables exist in Redshift.
-- Redshift and PSQL syntax are often the same, so you should be able to create these tables in a PSQL database locally.
-- Submit your answers and code to the 4 questions below.

DROP TABLE IF EXISTS daily_steps;

CREATE TABLE daily_steps (
    id int PRIMARY KEY,
    user_id int,
    step_date date,
    band_type varchar,
    steps int
);


INSERT INTO daily_steps VALUES 
    (1, 310334, '2017-08-17', 'Aria', 8234),
    (2, 310334, '2017-08-19', 'Aria-Deluxe', 10000),
    (3, 310334, '2017-08-20', 'Aria', 25),
    (4, 320843, '2017-08-18', ' Aria', 5264),
    (5, 320843, '2017-08-17', 'Blue Aria', 7254),
    (6, 320843, '2017-08-20', 'Aria ', NULL),
    (7, 320843, '2017-08-18', 'Fit', 18352),
    (8, 320843, '2017-08-19', 'Fit', 324),
    (9, 310334, '2017-08-24', 'Aria', 11892);


-- QUESTIONS

-- 1. List the unique types of bands in this dataset and how many measurements you have per band type
SELECT
DISTINCT band_type, count(*) as measurements
FROM
daily_steps
GROUP BY 1;

-- 2. Add to this table a new column "step_category" that recodes steps into the following categories:
-- -- A) Null --> 0
-- -- B) X<5000 --> 1
-- -- C) 5000<= X <= 10000 --> 2
-- -- D) X>10000 --> 3
ALTER TABLE daily_steps
ADD COLUMN STEP_CATEGORY INT;
UPDATE daily_steps
SET STEP_CATEGORY = 0
FROM daily_steps
WHERE STEPS = null;
UPDATE daily_steps
SET STEP_CATEGORY = 1
FROM daily_steps
WHERE STEPS < 5000;
UPDATE daily_steps
SET STEP_CATEGORY = 2
FROM daily_steps
WHERE STEPS >= 5000 and STEPS <= 10000;
UPDATE daily_steps
SET STEP_CATEGORY = 3
FROM daily_steps
WHERE STEPS > 10000;


-- 3. Add a new column to this table representing the cumulative step average 
-- for each user for all prior days of step-data
ALTER TABLE daily_steps
  ADD COLUMN CUMULATIVE_STEP_AVG INT;
UPDATE daily_steps
SET CUMULATIVE_STEP_AVG = STEPS where ID = 1;
UPDATE daily_steps
SET CUMULATIVE_STEP_AVG = ((select steps from daily_steps where id > 1) + (
  select CUMULATIVE_STEP_AVG
  FROM (SELECT ID, CUMULATIVE_STEP_AVG, ROW_NUMBER() OVER (ORDER BY ID) as rn from daily_steps) as temp
  where rn > 1)) where ID > 1;

-- 4. Identify two or more problems with the data quality or the calculation of the average,
-- which we would want to fix or discuss

-- The user 320843 seems to be using a different device each day and this gives an improper count for the user
-- The date in the table seems to be in a random order thereby not giving an overview of data in a periodical manner