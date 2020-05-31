USE stock_exchange;

CREATE OR REPLACE VIEW client_info (
  id,
  name, 
  surname, 
  status, 
  gender,
  birthday,
  accounts,
  shares,
  deals
  ) AS 
  SELECT 
    c.id,
    c.first_name, 
    c.last_name,
    st.status,
    p.gender,
    p.birthday,
    COUNT(DISTINCT b.id),
    COUNT(DISTINCT s.id),
    COUNT(DISTINCT t.buyer_id) + COUNT(DISTINCT t.seller_id)
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
  GROUP BY c.id
  ORDER BY c.id;


CREATE OR REPLACE VIEW shares_info_for_non_qualified_investors (
  id,
  ISIN,
  company,
  address,
  shares_outstanding,
  investors
  ) AS 
  SELECT 
    s.id,
    s.ISIN,
    s.name,
    i.address,
    s.shares_outstanding,
    COUNT(DISTINCT cs.client_id)
      FROM shares AS s
        JOIN issuers AS i
          ON i.share_id = s.id  
        JOIN clients_shares AS cs
          ON cs.share_id = s.id 
  WHERE s.for_non_quals = 1
  GROUP BY s.id
  ORDER BY s.id;


SELECT * FROM client_info

SELECT * FROM shares_info_for_non_qualified_investors

