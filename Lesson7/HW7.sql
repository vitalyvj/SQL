CREATE DATABASE shop;

USE shop;

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  description TEXT COMMENT 'Описание',
  price DECIMAL (11,2) COMMENT 'Цена',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id)
) COMMENT = 'Товарные позиции';

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel', 7890.00, 1),
  ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel', 12700.00, 1),
  ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD', 4780.00, 1),
  ('AMD FX-8320', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = 'Заказы';

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
  id SERIAL PRIMARY KEY,
  order_id INT UNSIGNED,
  product_id INT UNSIGNED,
  total INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных товарных позиций',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Состав заказа';


-- Задание 7.1

INSERT INTO orders 
  (user_id)
  SELECT id FROM users;
  
UPDATE orders SET user_id = FLOOR(1 + (RAND() * (SELECT COUNT(*) FROM users)));

SELECT * FROM orders;

INSERT INTO orders_products 
  (order_id)
  SELECT id FROM orders;

UPDATE orders_products SET order_id = FLOOR(1 + (RAND() * (SELECT COUNT(*) FROM orders)));
UPDATE orders_products SET product_id = FLOOR(1 + (RAND() * (SELECT COUNT(*) FROM products)));
UPDATE orders_products SET total = FLOOR(1 + (RAND() * 10));

SELECT * FROM orders_products;

SELECT DISTINCT users.id, users.name FROM users JOIN orders ON users.id = orders.user_id;


-- Задание 7.2

SELECT 
  p.id, 
  p.name AS 'product', 
  p.description, 
  c.name AS 'catalog' 
  FROM products AS p 
  JOIN catalogs AS c 
  ON p.catalog_id = c.id;


-- Задание 7.3

CREATE DATABASE homework_lesson7;

USE homework_lesson7;

CREATE TABLE flights (
  id SERIAL PRIMARY KEY,
  flights_from VARCHAR(255),
  flights_to VARCHAR(255)
);

CREATE TABLE cities (
  label VARCHAR(255),
  name VARCHAR(255)
);

INSERT INTO flights VALUES 
  (DEFAULT, 'moscow', 'omsk'),
  (DEFAULT, 'novgorod', 'kazan'),
  (DEFAULT, 'irkutsk', 'moscow'),
  (DEFAULT, 'omsk', 'irkutsk'), 
  (DEFAULT, 'moscow', 'kazan');
  
INSERT INTO cities VALUES 
  ('moscow', 'Москва'),
  ('irkutsk', 'Иркутск'),
  ('novgorod', 'Новгород'),
  ('kazan', 'Казань'), 
  ('omsk', 'Омск');

SELECT * FROM flights; 

SELECT 
  f.id, 
  c.name AS flights_from, 
  (SELECT name FROM cities WHERE f.flights_to = label) AS flights_to
  FROM flights AS f 
  JOIN cities AS c 
  ON f.flights_from = c.label 
  ORDER BY f.id;

