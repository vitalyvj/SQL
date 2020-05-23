-- Задание 11.1.1

USE shop;

DROP TABLE IF EXISTS logs;

CREATE TABLE logs (
  id SERIAL PRIMARY KEY,
  table_name VARCHAR(255) NOT NULL,
  primary_key INT NOT NULL,
  value_name VARCHAR(255) NOT NULL,
  created_at DATETIME DEFAULT NOW()
) ENGINE = ARCHIVE;

SHOW TABLE STATUS LIKE 'logs';

DROP TRIGGER IF EXISTS insert_users;
DROP TRIGGER IF EXISTS insert_catalogs;
DROP TRIGGER IF EXISTS insert_products;

DELIMITER $

CREATE TRIGGER insert_users AFTER INSERT ON users
FOR EACH ROW 
BEGIN 
  INSERT INTO logs VALUES (
    DEFAULT,
    'users',
    NEW.id,
    NEW.name,
    DEFAULT);
END $

CREATE TRIGGER insert_catalogs AFTER INSERT ON catalogs
FOR EACH ROW 
BEGIN 
  INSERT INTO logs VALUES (
    DEFAULT,
    'catalogs',
    NEW.id,
    NEW.name,
    DEFAULT);
END $

CREATE TRIGGER insert_products AFTER INSERT ON products
FOR EACH ROW 
BEGIN 
  INSERT INTO logs VALUES (
    DEFAULT,
    'products',
    NEW.id,
    NEW.name,
    DEFAULT);
END $

DELIMITER ;


INSERT INTO users 
  (name, birthday_at) 
VALUES 
  ('Владимир', '1952-10-07');

INSERT INTO catalogs 
  (name) 
VALUES 
  ('Дисководы');

INSERT INTO products 
  (name, price, catalog_id) 
VALUES 
  ('FDD 5.25"', 500, 6);

SELECT * FROM logs;


-- Задание 11.1.2

DESC users;

DROP TABLE IF EXISTS ten;
CREATE TABLE ten (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO ten 
  (name, birthday_at) 
VALUES 
  ('Владимир', '1952-10-07');

INSERT INTO 
  ten (name, birthday_at)
SELECT
  name, birthday_at
FROM 
  ten;

INSERT INTO 
  ten (name, birthday_at)
SELECT
  ten.name, ten.birthday_at
FROM 
  ten
    JOIN
  ten AS 2nd
    JOIN 
  ten AS 3rd;

-- итого 10 значений в таблице ten 
SELECT * FROM ten;

-- вставляем 1 000 000 значений в таблицу users
INSERT INTO 
  users (name, birthday_at) 
SELECT
  ten.name, ten.birthday_at
FROM 
  ten
    JOIN
  ten AS 2nd
    JOIN 
  ten AS 3rd
    JOIN 
  ten AS 4th
    JOIN 
  ten AS 5th
    JOIN 
  ten AS 6th;

SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM logs;


-- Задание 11.2.1

vitaly@VirtualBox:~$ redis-cli

127.0.0.1:6379> MSET 192.168.0.1 5 192.168.0.2 8 192.168.0.3 10 192.168.0.4 1 192.168.0.5 20 
OK

127.0.0.1:6379> KEYS *
1) "myset:__rand_int__"
2) "192.168.0.5"
3) "192.168.0.4"
4) "key:__rand_int__"
5) "counter:__rand_int__"
6) "192.168.0.2"
7) "mylist"
8) "192.168.0.1"
9) "192.168.0.3"

127.0.0.1:6379> MGET 192.168.0.1 192.168.0.2 192.168.0.3 192.168.0.4 192.168.0.5
1) "5"
2) "8"
3) "10"
4) "1"
5) "20"

127.0.0.1:6379> INCR 192.168.0.1
(integer) 6

127.0.0.1:6379> INCR 192.168.0.4
(integer) 2

127.0.0.1:6379> MGET 192.168.0.1 192.168.0.2 192.168.0.3 192.168.0.4 192.168.0.5
1) "6"
2) "8"
3) "10"
4) "2"
5) "20"


-- Задание 11.2.2

127.0.0.1:6379> HSET name Vladimir bigboss@kremlin.ru
(integer) 1

127.0.0.1:6379> HSET name Donald greatboss@whitehouse.com
(integer) 1

127.0.0.1:6379> HSET email bigboss@kremlin.ru Vladimir
(integer) 1

127.0.0.1:6379> HSET email greatboss@whitehouse.com Donald
(integer) 1

127.0.0.1:6379> HGET name Vladimir
"bigboss@kremlin.ru"

127.0.0.1:6379> HGET email greatboss@whitehouse.com
"Donald"


-- Задание 11.2.3

vitaly@VirtualBox:~$ mongo
MongoDB shell version v3.6.3
connecting to: mongodb://127.0.0.1:27017
MongoDB server version: 3.6.3

> use shop
switched to db shop

> db.shop.insert({categoty: 'Процессоры', name: 'Intel Core i3-8100', description: 'Процессор для настольных персональных компьютеров, основанных на платформе Intel', price: 7890.00})
WriteResult({ "nInserted" : 1 })

> db.shop.insert({categoty: 'Процессоры', name: 'Intel Core i5-7400', description: 'Процессор для настольных персональных компьютеров, основанных на платформе Intel', price: 12700.00})
WriteResult({ "nInserted" : 1 })

> db.shop.insert({categoty: 'Процессоры', name: 'AMD FX-8320E', description: 'Процессор для настольных персональных компьютеров, основанных на платформе AMD', price: 4780.00})
WriteResult({ "nInserted" : 1 })

> db.shop.insert({categoty: 'Процессоры', name: 'AMD FX-8320', description: 'Процессор для настольных персональных компьютеров, основанных на платформе AMD', price: 7120.00})
WriteResult({ "nInserted" : 1 })

> db.shop.insert({categoty: 'Материнские платы', name: 'ASUS ROG MAXIMUS X HERO', description: 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', price: 19310.00})
WriteResult({ "nInserted" : 1 })

> db.shop.insert({categoty: 'Материнские платы', name: 'Gigabyte H310M S2H', description: 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', price: 4790.00})
WriteResult({ "nInserted" : 1 })

> db.shop.insert({categoty: 'Материнские платы', name: 'MSI B250M GAMING PRO', description: 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', price: 5060.00})
WriteResult({ "nInserted" : 1 })

> db.shop.find()
{ "_id" : ObjectId("5ec9a8bd6c3a3d7f7460a2b5"), "categoty" : "Процессоры", "name" : "Intel Core i3-8100", "description" : "Процессор для настольных персональных компьютеров, основанных на платформе Intel", "price" : 7890 }
{ "_id" : ObjectId("5ec9a8bd6c3a3d7f7460a2b6"), "categoty" : "Процессоры", "name" : "Intel Core i5-7400", "description" : "Процессор для настольных персональных компьютеров, основанных на платформе Intel", "price" : 12700 }
{ "_id" : ObjectId("5ec9a8bd6c3a3d7f7460a2b7"), "categoty" : "Процессоры", "name" : "AMD FX-8320E", "description" : "Процессор для настольных персональных компьютеров, основанных на платформе AMD", "price" : 4780 }
{ "_id" : ObjectId("5ec9a8bd6c3a3d7f7460a2b8"), "categoty" : "Процессоры", "name" : "AMD FX-8320", "description" : "Процессор для настольных персональных компьютеров, основанных на платформе AMD", "price" : 7120 }
{ "_id" : ObjectId("5ec9a8bd6c3a3d7f7460a2b9"), "categoty" : "Материнские платы", "name" : "ASUS ROG MAXIMUS X HERO", "description" : "Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX", "price" : 19310 }
{ "_id" : ObjectId("5ec9a8bd6c3a3d7f7460a2ba"), "categoty" : "Материнские платы", "name" : "Gigabyte H310M S2H", "description" : "Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX", "price" : 4790 }
{ "_id" : ObjectId("5ec9a8bd6c3a3d7f7460a2bb"), "categoty" : "Материнские платы", "name" : "MSI B250M GAMING PRO", "description" : "Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX", "price" : 5060 }

