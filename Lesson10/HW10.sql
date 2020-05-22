-- Задание 10.1

USE vk;

CREATE INDEX users_first_name_idx ON users(first_name);

CREATE INDEX users_last_name_idx ON users(last_name);

CREATE INDEX users_first_name_idx ON users(first_name);

CREATE UNIQUE INDEX users_email_uq ON users(email);

CREATE INDEX users_created_at_idx ON users(created_at);

CREATE INDEX users_updated_at_idx ON users(updated_at);

CREATE INDEX profiles_birthday_idx ON profiles(birthday);

CREATE INDEX profiles_city_idx ON profiles(city);

CREATE INDEX profiles_country_idx ON profiles(country);

CREATE INDEX posts_head_idx ON posts(head);

CREATE INDEX posts_body_idx ON posts(body);

CREATE INDEX posts_community_id_idx ON posts(community_id);

CREATE INDEX posts_created_at_idx ON posts(created_at);

CREATE INDEX posts_updated_at_idx ON posts(updated_at);

CREATE INDEX messages_from_user_id_idx ON messages(from_user_id);

CREATE INDEX messages_to_user_id_idx ON messages(to_user_id);

CREATE INDEX messages_from_user_id_to_user_id_idx ON messages(from_user_id, to_user_id);

CREATE INDEX media_user_id_idx ON media(user_id);

CREATE INDEX media_user_id_filename_idx ON media(user_id, filename);

CREATE INDEX media_created_at_idx ON media(created_at);

CREATE INDEX media_updated_at_idx ON media(updated_at);

CREATE INDEX likes_user_id_idx ON likes(user_id);

CREATE INDEX likes_user_id_target_id_idx ON likes(user_id, target_id);

CREATE INDEX likes_user_id_target_type_id_idx ON likes(user_id, target_type_id);

CREATE INDEX friendship_user_id_idx ON friendship(user_id);

CREATE INDEX friendship_friend_id_idx ON friendship(friend_id);

CREATE UNIQUE INDEX friendship_user_id_friend_id_uq ON friendship(user_id, friend_id);

CREATE INDEX communities_users_community_id_user_id_idx ON communities_users(community_id, user_id);

CREATE INDEX communities_users_user_id_community_id_idx ON communities_users(user_id, community_id);

CREATE INDEX communities_name_idx ON communities(name);


-- Задание 10.2

SELECT DISTINCT 
  c.name AS 'group name',
  (SELECT COUNT(DISTINCT user_id) / MAX(community_id) FROM communities_users) AS average,
  --  FIRST_VALUE(CONCAT(u.first_name, ' ', u.last_name)) OVER w AS youngest,
  --  LAST_VALUE(CONCAT(u.first_name, ' ', u.last_name)) OVER w AS oldest,
  MAX(p.birthday) OVER w AS youngest,
  MIN(p.birthday) OVER w AS oldest,
  COUNT(cu.user_id) OVER w AS group_users,
  COUNT(u.id) OVER() AS all_users,
  COUNT(cu.user_id) OVER w / COUNT(u.id) OVER() * 100 AS 'quota, %'
    FROM communities AS c
      JOIN communities_users AS cu
      JOIN profiles AS p
      JOIN users AS u
        ON c.id = cu.community_id AND cu.user_id = p.user_id AND p.user_id = u.id 
          WINDOW w AS (PARTITION BY c.name -- ORDER BY p.birthday);
);