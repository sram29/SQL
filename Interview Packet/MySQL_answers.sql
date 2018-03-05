# --- Copyright - Health eHeart Group 2018 ---

-- INSTRUCTIONS:
-- In MySQL, start by building the following tables and inserting these values.
-- Then submit your answers and code to the 3 questions below.
-- Create Database interview; 
-- use interview;

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

SELECT  * FROM  colors
WHERE  user_id NOT IN (SELECT id FROM users);

-- 2. Join the two tables so that every user in either table is present
-- and so that you have the following three columns: user_id, color, name

SELECT colors.user_id,colors.color,users.name FROM colors left Join users on users.id = colors.user_id
union
SELECT colors.user_id,colors.color,users.name From colors right join users on users.id=colors.user_id;

-- 3. Rewrite the table schema definitions above to insure that
-- only a unique user id may be created in table users
-- and that color records may only be created with a valid user_id from table users.
DROP TABLE IF EXISTS users;

Create TABLE users (
  id INT,
  name VARCHAR(100),
  UNIQUE KEY (id)
);

DROP TABLE IF EXISTS colors;

CREATE TABLE colors (
  id INT,
  user_id INT,
  color VARCHAR(100),
  FOREIGN KEY (user_id)
     REFERENCES users(id)
     ON DELETE CASCADE
);



