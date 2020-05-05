SHOW DATABASES;

CREATE DATABASE homework_lesson5;

USE homework_lesson5;


-- Задание 1.1

CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,  
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  created_at VARCHAR(100) NULL,
  updated_at VARCHAR(100) NULL
);

DESC users;

INSERT INTO users (last_name, first_name) VALUES
  ('Иванов', 'Петр'),
  ('Сидоров', 'Иван'),
  ('Петров', 'Иван'),
  ('Путин', 'Владимир'),
  ('Трамп', 'Дональд');

UPDATE users SET created_at = NOW(), updated_at = NOW();

SELECT * FROM users;


-- Задание 1.2

TRUNCATE users;

INSERT INTO users (last_name, first_name, created_at, updated_at) VALUES
  ('Иванов', 'Петр', '20.10.2017 8:10', '25.05.2018 18:15'),
  ('Сидоров', 'Иван', '07.01.2015 3:15', '20.02.2020 12:00'),
  ('Петров', 'Иван', '22.02.2016 5:25', '20.12.2019 12:55'),
  ('Путин', 'Владимир', '01.01.2000 0:01', '01.03.2020 23:30'),
  ('Трамп', 'Дональд', '20.01.2017 0:01', '22.02.2020 22:25');

UPDATE users SET created_at = STR_TO_DATE(created_at, '%d.%m.%Y %H:%i'), updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %H:%i');

ALTER TABLE users MODIFY COLUMN created_at DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE users MODIFY COLUMN updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

DESC users;

SELECT * FROM users;


-- Задание 1.3

CREATE TABLE storehouses_products (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,  
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED
);

INSERT INTO storehouses_products (storehouse_id, product_id, value) VALUES
  (10, 100, 0),
  (20, 200, 2500),
  (30, 300, 0),
  (40, 400, 30),
  (50, 500, 500),
  (60, 600, 1);

SELECT * FROM storehouses_products;

SELECT * FROM storehouses_products ORDER BY value;

SELECT * FROM storehouses_products ORDER BY IF(value = 0, 1, 0), value;


-- Задание 1.4

ALTER TABLE users ADD COLUMN birthday_at DATE AFTER last_name;

UPDATE users SET birthday_at = '1990-10-05' WHERE id = 1;
UPDATE users SET birthday_at = '1985-05-20' WHERE id = 2;
UPDATE users SET birthday_at = '1982-08-29' WHERE id = 3;
UPDATE users SET birthday_at = '1952-10-07' WHERE id = 4;
UPDATE users SET birthday_at = '1946-06-14' WHERE id = 5;

SELECT first_name, last_name, birthday_at FROM users;

SELECT 
  first_name, last_name, MONTHNAME(birthday_at) AS birthday_month 
FROM users 
WHERE MONTHNAME(birthday_at) IN ('May', 'August');


-- Задание 1.5

CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255)
);

INSERT INTO catalogs (name) VALUES
  ('Процессоры'),
  ('Материнские платы'),
  ('Видеокарты'),
  ('Жесткие диски'),
  ('Оперативная память');

SELECT * FROM catalogs;

SELECT * FROM catalogs WHERE id IN (5, 1, 2);

SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY FIELD(id, 5, 1, 2);


-- Задание 2.1

SELECT first_name, last_name, birthday_at FROM users;

SELECT first_name, last_name, birthday_at, TIMESTAMPDIFF(YEAR, birthday_at, NOW()) AS age FROM users;

SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW())), 1) AS average_age FROM users;  


-- Задание 2.2

SELECT first_name, last_name, birthday_at FROM users;

SELECT first_name, last_name, CONCAT(YEAR(NOW()), DATE_FORMAT(birthday_at, '-%m-%d')) AS birthday_day FROM users;

SELECT first_name, last_name, DAYNAME(CONCAT(YEAR(NOW()), DATE_FORMAT(birthday_at, '-%m-%d'))) AS birthday_day FROM users;

SELECT 
  DAYNAME(CONCAT(YEAR(NOW()), DATE_FORMAT(birthday_at, '-%m-%d'))) AS birthday_day, 
  COUNT(*) AS users_quantity 
FROM users 
GROUP BY birthday_day;

SELECT 
  DAYNAME(CONCAT(YEAR(NOW()), DATE_FORMAT(birthday_at, '-%m-%d'))) AS birthday_day, 
  COUNT(*) AS users_quantity 
FROM users 
GROUP BY birthday_day
ORDER BY users_quantity DESC;


-- Задание 2.3

SELECT id FROM users;

SELECT ROUND(EXP(SUM(LOG(id)))) AS product FROM users;

