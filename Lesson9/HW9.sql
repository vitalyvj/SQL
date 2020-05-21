-- Задание 9.1.1

CREATE DATABASE sample;

USE sample;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

START TRANSACTION;

INSERT INTO sample.users SELECT * FROM shop.users WHERE id = 1;

DELETE FROM shop.users WHERE id = 1;

COMMIT;


-- Задание 9.1.2

USE shop;

CREATE OR REPLACE VIEW product_catalog (product, catalog) AS 
  SELECT p.name, c.name FROM products AS p
    JOIN catalogs AS c
      ON c.id = p.catalog_id;

SELECT * FROM product_catalog;


-- Задание 9.1.3

CREATE TABLE task3 (
  id SERIAL PRIMARY KEY,
  created_at DATE DEFAULT NULL
);

INSERT INTO task3 (created_at) VALUES
  ('2018-08-01'), (NULL), (NULL),
  ('2016-08-04'), (NULL), (NULL), (NULL), (NULL), (NULL), (NULL), (NULL), (NULL), (NULL), (NULL), (NULL),
  ('2018-08-16'),
  ('2018-08-17'), (NULL), (NULL), (NULL), (NULL), (NULL), (NULL), (NULL), (NULL), (NULL), (NULL), (NULL), (NULL), (NULL), (NULL);

SELECT 
  IF(
    id < 10,
    CONCAT('2018-08-0', id),
    CONCAT('2018-08-', id))
    AS date,
  IF(created_at IS NULL, 0, 1)
    AS bool
  FROM task3; 


-- Задание 9.1.4

CREATE TABLE task4 (
  id SERIAL PRIMARY KEY,
  created_at DATE
);

INSERT INTO task4 SELECT * FROM task3;

UPDATE task4 SET created_at = (
  SELECT CONCAT('2018-08-', FLOOR(1 + (RAND() * 31))));

DELETE FROM task4 WHERE id NOT IN (
  SELECT * FROM (
    SELECT id FROM task4
      ORDER BY created_at DESC
      LIMIT 5) AS to_save);

SELECT * FROM task4;


-- Задание 9.3.1

DROP FUNCTION IF EXISTS hello;

DELIMITER //

CREATE FUNCTION hello()
RETURNS TINYTEXT NO SQL
BEGIN
    SET @var = HOUR(NOW());
    IF @var BETWEEN 6 AND 11 THEN 
      RETURN 'Доброе утро';
    ELSEIF @var BETWEEN 12 AND 17 THEN 
      RETURN 'Добрый день';
    ELSEIF @var BETWEEN 18 AND 23 THEN 
      RETURN 'Добрый вечер';  
    ELSE 
      RETURN 'Доброй ночи';  
    END IF;
END //

DELIMITER ;

SELECT NOW(), hello();


-- Задание 9.3.2

DROP TRIGGER IF EXISTS not_null_insert;
DROP TRIGGER IF EXISTS not_null_update;

DELIMITER //

CREATE TRIGGER not_null_insert BEFORE INSERT ON products
FOR EACH ROW 
BEGIN 
  IF NEW.name IS NULL AND NEW.description IS NULL THEN 
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Columns name and description can't be NULL at the same time" ;
  END IF;
END //

CREATE TRIGGER not_null_update BEFORE UPDATE ON products
FOR EACH ROW 
BEGIN 
  IF NEW.name IS NULL AND NEW.description IS NULL THEN 
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Columns name and description can't be NULL at the same time" ;
  END IF;
END //

DELIMITER ;


INSERT INTO products (price) VALUES (30000);

INSERT INTO products (name, price) VALUES ('Intel Core i7-9700', 30000);

SELECT * FROM products;

UPDATE products SET name = NULL WHERE name = 'Intel Core i7-9700';


-- Задание 9.3.3

DROP FUNCTION IF EXISTS fibo;

DELIMITER //

CREATE FUNCTION fibo(num INT)
RETURNS INT DETERMINISTIC
BEGIN
  DECLARE a INT DEFAULT 0;
  DECLARE b INT DEFAULT 1;
  DECLARE c INT DEFAULT 0;
    IF num = 1 THEN SET c = 1;
    END IF;
    WHILE num > 1 DO
      SET c = a + b;
      SET a = b;
      SET b = c;
      SET num = num - 1;
    END WHILE;
RETURN c;
END //

DELIMITER ;


SELECT fibo(10);

