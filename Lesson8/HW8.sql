-- Задание 8.1

SELECT SUM(user_likes) AS ten_youngest_user_likes FROM 
  (SELECT p.user_id, COUNT(l.target_id) as user_likes
      FROM profiles AS p
        LEFT JOIN likes AS l
          ON l.target_id = p.user_id AND l.target_type_id = 2
      GROUP BY user_id
      ORDER BY p.birthday DESC
      LIMIT 10)
  AS user_likes;

  
-- Задание 8.2

SELECT 
    CASE 
      WHEN gender = 'm' THEN 'men'
      WHEN gender = 'f' THEN 'women'
    END AS winners,
    COUNT(*) AS likes
  FROM profiles AS p
    JOIN likes AS l
      ON l.user_id = p.user_id
  GROUP BY gender
  ORDER BY likes DESC
  LIMIT 1;
  

-- Задание 8.3

SELECT 
    u.id, 
    first_name, 
    last_name, 
    (
      COUNT(DISTINCT l.id) + 
      COUNT(DISTINCT m.id) + 
      COUNT(DISTINCT ms.id) + 
      COUNT(DISTINCT p.id)
    ) AS activity
  FROM users AS u
    LEFT JOIN likes AS l
      ON l.user_id = u.id 
    LEFT JOIN media AS m
      ON m.user_id = u.id 
    LEFT JOIN messages AS ms
      ON ms.from_user_id = u.id 
    LEFT JOIN posts AS p
      ON p.user_id = u.id
  GROUP BY u.id 
  ORDER BY activity, u.id
  LIMIT 10;

