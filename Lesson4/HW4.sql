USE vk;

SHOW TABLES;

SELECT * FROM users LIMIT 10;

SELECT * FROM users WHERE created_at > updated_at;

UPDATE users SET updated_at = CURRENT_TIMESTAMP() WHERE created_at > updated_at;

SELECT * FROM users WHERE created_at > updated_at;

DESC users;

DESC profiles;

SELECT * FROM profiles LIMIT 10;

ALTER TABLE profiles ADD COLUMN photo_id INT UNSIGNED;

DESC profiles;

DESC messages;

SELECT * FROM messages LIMIT 20;

SELECT COUNT(*) FROM users;

SELECT COUNT(*) FROM communities;

-- вернуться к community_id в messages - исправить количество 

DESC media;

SELECT * FROM media LIMIT 10;

SELECT * FROM media WHERE created_at > updated_at;

UPDATE media SET updated_at = CURRENT_TIMESTAMP() WHERE created_at > updated_at;

SELECT * FROM media_types ORDER BY id;

TRUNCATE media_types; 

INSERT INTO media_types (name) VALUES
  ('photo'),
  ('video'),
  ('audio');

SELECT * FROM media_types ORDER BY id;

SELECT * FROM media LIMIT 10;

UPDATE media SET media_type_id = FLOOR(1 + RAND() * 3);

CREATE TEMPORARY TABLE exts(
  name VARCHAR(10)
);

INSERT INTO exts VALUES
  ('jpeg'),
  ('png'),
  ('mov'),
  ('avi'),
  ('mpeg');

SELECT * FROM exts;
  
UPDATE media SET filename = CONCAT(
  'https://dropbox.com/vk/',
  filename,
  '.',
  (SELECT name FROM exts ORDER BY RAND() LIMIT 1)
);

SELECT * FROM media LIMIT 10;

SELECT * FROM media ORDER BY size;

UPDATE media SET size = FLOOR(10000 + RAND() * 999999) WHERE size < 10000;

UPDATE media SET metadata = CONCAT(
  '{"owner":"', 
  (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = user_id),
  '"}'
); 

SELECT * FROM media LIMIT 10;

DESC media;

DESC friendship;

SELECT * FROM friendship;

SELECT * FROM friendship WHERE requested_at > confirmed_at;

UPDATE friendship SET confirmed_at = CURRENT_TIMESTAMP() WHERE requested_at > confirmed_at;

SELECT * FROM friendship_statuses;

TRUNCATE friendship_statuses;

INSERT INTO friendship_statuses (name) VALUES
  ('Requested'),
  ('Confirmed'),
  ('Rejected');

SELECT * FROM friendship_statuses ORDER BY id;

SELECT * FROM friendship LIMIT 10;

UPDATE friendship SET status_id = FLOOR(1 + RAND() * 3);

SELECT * FROM communities;

DELETE FROM communities WHERE id > 20;

SELECT * FROM communities ORDER BY id;

SELECT * FROM communities_users;

UPDATE IGNORE communities_users SET community_id = FLOOR(1 + RAND() * 20);

DESC messages;

ALTER TABLE messages MODIFY COLUMN community_id INT UNSIGNED;

ALTER TABLE messages MODIFY COLUMN to_user_id INT UNSIGNED;

UPDATE messages SET community_id = FLOOR(1 + RAND() * 20);

SELECT * FROM messages LIMIT 20;

