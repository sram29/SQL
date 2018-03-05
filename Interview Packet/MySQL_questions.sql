# --- Copyright - Health eHeart Group 2018 ---

-- INSTRUCTIONS:
-- In MySQL, start by building the following tables and inserting these values.
-- Then submit your answers and code to the 3 questions below.

CREATE TABLE users (
  id INT,
  name VARCHAR(100)
);

CREATE TABLE colors (
  id INT,
  user_id INT,
  color VARCHAR(100)
);

INSERT INTO users VALUES(1,'Thomas');
INSERT INTO users VALUES(2,'Mary');
INSERT INTO users VALUES(6,'Betty');
INSERT INTO colors VALUES(1,2,'red');
INSERT INTO colors VALUES(2,4,'blue');
INSERT INTO colors VALUES(2,5,'green');


-- QUESTIONS:

-- 1. Get all the records of "users" whom are found in table colors,
-- 	and whom are not found in table users.

-- 2. Join the two tables so that every user in either table is present
-- and so that you have the following three columns: user_id, color, name

-- 3. Rewrite the table schema definitions above to insure that
-- only a unique user id may be created in table users
-- and that color records may only be created with a valid user_id from table users.




