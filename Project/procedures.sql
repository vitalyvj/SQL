USE stock_exchange;

  
-- процерура вывода информации о клиенте по фамилии

DROP PROCEDURE IF EXISTS client_information;

DELIMITER $ 

CREATE PROCEDURE client_information (client_surname VARCHAR(255))
BEGIN
  SELECT 
    c.id AS client_id,
    c.first_name AS name, 
    c.last_name AS surname,
    st.status AS client_status,
    CASE 
      WHEN p.gender = 'm' THEN 'man'
      WHEN p.gender = 'f' THEN 'woman'
    END AS gender,
    p.birthday AS birthday,
    COUNT(DISTINCT b.id) AS accounts,
    COUNT(DISTINCT s.id) AS shares,
    COUNT(DISTINCT t.buyer_id) + COUNT(DISTINCT t.seller_id) AS deals
      FROM clients AS c
        JOIN statuses AS st
          ON st.id = c.status_id 
        JOIN profiles AS p
          ON p.client_id = c.id
        JOIN clients_brokers AS cb
          ON cb.client_id = c.id 
        JOIN brokers AS b
          ON b.id = cb.broker_id 
        JOIN clients_shares AS cs
          ON cs.client_id = c.id 
        JOIN shares AS s
          ON s.id = cs.share_id 
        JOIN transactions AS t
          ON t.buyer_id = c.id OR t.seller_id = c.id 
  WHERE c.last_name LIKE client_surname
  GROUP BY client_id;
END $

DELIMITER ;


-- проверка

CALL client_information('Kemmer');
CALL client_information('Lind');


-- процерура вывода списка клиентов брокера по его названию

DROP PROCEDURE IF EXISTS broker_clients;

DELIMITER $ 

CREATE PROCEDURE broker_clients (broker VARCHAR(255))
BEGIN
  SELECT 
    CONCAT(c.last_name, ' ', c.first_name) AS client,
    CASE 
      WHEN p.gender = 'm' THEN 'man'
      WHEN p.gender = 'f' THEN 'woman'
    END AS gender,
    p.birthday AS birthday,
    st.status AS client_status
    FROM clients AS c
      JOIN clients_brokers AS cb
        ON cb.client_id = c.id 
      JOIN brokers AS b
        ON b.id = cb.broker_id
      JOIN profiles AS p
        ON p.client_id = c.id
      JOIN statuses AS st
        ON st.id = c.status_id         
  WHERE b.name LIKE broker
  ORDER BY c.last_name; 
END $

DELIMITER ;


-- проверка

CALL broker_clients('Weissnat-Schulist');
CALL broker_clients('Reynolds group');

