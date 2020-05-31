USE stock_exchange;

DESC brokers;

DESC clients;

ALTER TABLE clients 
  ADD CONSTRAINT clients_status_id_fk
    FOREIGN KEY (status_id) REFERENCES statuses(id)
      ON DELETE CASCADE;
    
DESC clients_brokers;

ALTER TABLE clients_brokers 
  ADD CONSTRAINT clients_brokers_client_id_fk
    FOREIGN KEY (client_id) REFERENCES clients(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT clients_brokers_broker_id_fk
    FOREIGN KEY (broker_id) REFERENCES brokers(id)
      ON DELETE CASCADE;

DESC clients_shares;

ALTER TABLE clients_shares 
  ADD CONSTRAINT clients_shares_client_id_fk
    FOREIGN KEY (client_id) REFERENCES clients(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT clients_shares_share_id_fk
    FOREIGN KEY (share_id) REFERENCES shares(id)
      ON DELETE CASCADE;
    
DESC issuers;

ALTER TABLE issuers 
  ADD CONSTRAINT issuers_share_id_fk
    FOREIGN KEY (share_id) REFERENCES shares(id)
      ON DELETE CASCADE;
    
DESC prices_data;

ALTER TABLE prices_data
  ADD CONSTRAINT prices_data_share_id_fk
    FOREIGN KEY (share_id) REFERENCES shares(id)
      ON DELETE CASCADE;

    
DESC profiles;

ALTER TABLE profiles 
  ADD CONSTRAINT profiles_client_id_fk
    FOREIGN KEY (client_id) REFERENCES clients(id)
      ON DELETE CASCADE;   
    
DESC shares;
     
DESC statuses;

DESC trading_modes;

DESC transactions;

ALTER TABLE transactions 
  ADD CONSTRAINT transactions_buyer_id_fk
    FOREIGN KEY (buyer_id) REFERENCES clients(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT transactions_seller_id_fk
    FOREIGN KEY (seller_id) REFERENCES clients(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT transactions_share_id_fk
    FOREIGN KEY (share_id) REFERENCES shares(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT transactions_trading_mode_id_fk
    FOREIGN KEY (trading_mode_id) REFERENCES trading_modes(id)
      ON DELETE CASCADE;
      

CREATE INDEX clients_first_name_idx ON clients(first_name);
CREATE INDEX clients_last_name_idx ON clients(last_name);
CREATE INDEX clients_created_at_idx ON clients(created_at);

CREATE INDEX clients_brokers_client_id_broker_id_idx ON clients_brokers(client_id, broker_id);

CREATE INDEX clients_shares_client_id_share_id_idx ON clients_shares(client_id, share_id);

CREATE INDEX issuers_created_at_idx ON issuers(created_at);

CREATE INDEX profiles_birthday_idx ON profiles(birthday);
CREATE INDEX profiles_address_idx ON profiles(address);
CREATE INDEX profiles_created_at_idx ON profiles(created_at);

CREATE INDEX shares_created_at_idx ON shares(created_at);
CREATE INDEX shares_for_non_quals ON shares(for_non_quals);

CREATE INDEX transactions_buyer_id_seller_id_idx ON transactions(buyer_id, seller_id);
CREATE INDEX transactions_buyer_id_share_id_idx ON transactions(buyer_id, share_id);
CREATE INDEX transactions_seller_id_share_id_idx ON transactions(seller_id, share_id);

