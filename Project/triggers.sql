USE stock_exchange;


-- триггер для ограничения транзакций для неквалифицированных инвесторов

DROP TRIGGER IF EXISTS shares_for_non_qualified_investors;

DELIMITER $

CREATE TRIGGER shares_for_non_qualified_investors BEFORE INSERT ON transactions
FOR EACH ROW 
BEGIN 
  IF 
    NEW.buyer_id IN (SELECT id FROM clients WHERE status_id = 2)
      AND 
    NEW.share_id IN (SELECT id FROM shares WHERE for_non_quals = 0)
  THEN 
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Only qualified investors can buy this share" ;
  END IF;
END $

DELIMITER ;


-- проверка

INSERT INTO transactions (buyer_id, seller_id, share_id, price, quantity, trading_mode_id) VALUES
  ('1', '3', '2', '1000', '100', '1')

INSERT INTO transactions (buyer_id, seller_id, share_id, price, quantity, trading_mode_id) VALUES
  ('2', '3', '1', '1000', '100', '1')
  
INSERT INTO transactions (buyer_id, seller_id, share_id, price, quantity, trading_mode_id) VALUES
  ('2', '3', '2', '1000', '100', '1')


-- триггер для формирования таблицы с движением цены на акции

DROP TRIGGER IF EXISTS shares_prices_data;

DELIMITER $

CREATE TRIGGER shares_prices_data AFTER INSERT ON transactions
FOR EACH ROW 
BEGIN 
  INSERT INTO prices_data VALUES (
    DEFAULT,
    NEW.share_id,
    NEW.price,
    DEFAULT);
END $

DELIMITER ;


-- проверка

INSERT INTO transactions (buyer_id, seller_id, share_id, price, quantity, trading_mode_id) VALUES
  ('1', '3', '2', '1000', '100', '1')

SELECT * FROM prices_data;
  
