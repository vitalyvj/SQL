USE stock_exchange;


-- 10 самых торгуемых компаний на бирже 

SELECT s.name, SUM(price * quantity) AS trades
  FROM transactions AS t
    JOIN shares AS s
      ON s.id = t.share_id 
  GROUP BY t.share_id
  ORDER BY trades DESC
  LIMIT 10;


-- 10 самых дорогих компаний, торгующихся на бирже

SELECT s.name, ROUND(AVG(t.price) * s.shares_outstanding) AS cap
  FROM transactions AS t
    JOIN shares AS s
      ON s.id = t.share_id 
  GROUP BY t.share_id
  ORDER BY cap DESC 
  LIMIT 10;


-- количество акций в портфелях самых молодых 10 инвесторов

SELECT CONCAT(c.first_name, c.last_name) AS investor, COUNT(cs.share_id) AS shares
  FROM clients_shares AS cs
    JOIN shares AS s
      ON s.id = cs.share_id 
    JOIN clients AS c
      ON c.id = cs.client_id 
    JOIN profiles AS p
      ON p.client_id = c.id
  GROUP BY cs.client_id
  ORDER BY p.birthday DESC 
  LIMIT 10;


-- средняя капитализация компаний, торгующихся на бирже

SELECT ROUND(AVG(cap)) AS avgerage_cap FROM 
  (SELECT s.name, ROUND(AVG(t.price) * s.shares_outstanding) AS cap
    FROM transactions AS t
      JOIN shares AS s
        ON s.id = t.share_id 
    GROUP BY t.share_id)
  AS cap;

