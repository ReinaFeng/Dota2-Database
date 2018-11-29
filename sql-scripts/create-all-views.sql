-- View Win Rate for User
-- This query will allow you to find the percentage of games that a specific User has won.
CREATE OR REPLACE VIEW user_view1 AS
SELECT a.steam_id, cast((a.win_match) AS decimal(7,2))/cast((b.total_match) AS decimal(7,2)) AS win_rate
FROM (
  SELECT steam_id, count(match_id) as win_match
  FROM 
    player
  WHERE win=1
  GROUP BY 
    steam_id) a 
  LEFT JOIN (
    SELECT 
      steam_id, count(match_id) as total_match
    FROM 
      player
    GROUP BY steam_id) b 
    ON a.steam_id = b.steam_id
Order by win_rate
;

-- View Hero By Win Rate
-- This query will allow you to sort the Heroes by their win rate.
CREATE OR REPLACE VIEW hero_view1 AS
SELECT t2.name as hero_name, t1.win_rate
FROM (
  SELECT 
    a.hero_id, cast((a.win_match) AS decimal(7,2))/cast((b.total_match) AS decimal(7,2)) as win_rate
  FROM (
    SELECT 
      hero_id, count(match_id) as win_match
    FROM 
      player
     WHERE win=1
     GROUP BY hero_id) a 
  LEFT JOIN (
    SELECT 
      hero_id, count(match_id) as total_match
    FROM 
      player
    GROUP BY hero_id) b 
    ON a.hero_id = b.hero_id) t1 
    LEFT JOIN hero t2 on t1.hero_id = t2.hero_id
ORDER BY win_rate
;

-- TODO this is wrong
-- View A User's Favorite Hero
-- This query will return the Hero that a given User uses most frequently in their Matches.
CREATE OR REPLACE VIEW user_hero2 AS
SELECT *
FROM(
	SELECT 
    steam_id, hero_id, count(*) as Times
	FROM 
    player
	GROUP BY 
    player.hero_id) as frq_hero, hero
WHERE 
  hero.hero_id=frq_hero.hero_id
ORDER BY 
  frq_hero.Times
;

--TODO This is broken because user_item hase no steam_id
-- View The Most Common Item for a Hero
-- This query will tell you what Item is most commonly used by a given Hero.
CREATE OR REPLACE VIEW item_hero AS
SELECT 
  hero.name AS hero_name, item.name AS item_name, it_times.times
FROM(
  SELECT 
    hero_item.hero_id, hero_item.item_id, count(*) AS times
  FROM(
    SELECT 
      player.match_id, player.hero_id, user_item.item_id
    FROM 
      user_item, player
    WHERE 
      player.player_slot=user_item.player_slot AND player.match_id=user_item.match_id) AS hero_item
  GROUP BY 
    hero_item.hero_id, hero_item.item_id) AS it_times, hero, item
WHERE 
  hero.hero_id=it_times.hero_id AND item.item_id=it_times.item_id
ORDER BY 
  it_times.times
;

-- View Winners of a Match
-- This query will return which Players won a specific Match
CREATE OR REPLACE VIEW match_view1 AS
Select personaname, profileurl, hero_id, steam_id, match_id
from users join player using (steam_id) 
where player.win=1
;

-- CREATE VIEW
-- find kill, death, assist for each user with a specific hero
CREATE OR REPLACE VIEW user_hero_view1 AS
SELECT 
  player.steam_id, 
  hero.name as hero,
  max(kills) as max_kill,
  avg(kills) as avg_kill,
  min(kills) as min_kill,
  max(death) as max_death,
  avg(death) as avg_death,
  min(death) as min_death,
  max(assists) as max_assist,
  avg(assists) as avg_assist,
  min(assists) as min_assist
FROM 
  player, hero
WHERE
  player.hero_id = hero.hero_id
GROUP BY 
  player.steam_id, hero.name
;

------- find kill,death,assist for each user
CREATE OR REPLACE VIEW all_user_stats AS
SELECT 
  steam_id,
  max(kills) as max_kill,
  avg(kills) as avg_kill,
  min(kills) as min_kill,
  max(death) as max_death,
  avg(death) as avg_death,
  min(death) as min_death,
  max(assists) as max_assist,
  avg(assists) as avg_assist,
  min(assists) as min_assist
FROM 
  player
GROUP BY
  steam_id
;

------ find kill, death, assist for each hero
CREATE OR REPLACE VIEW all_hero_stats AS
SELECT 
  hero.name as hero,
  max(kills) as max_kill,
  avg(kills) as avg_kill,
  min(kills) as min_kill,
  max(death) as max_death,
  avg(death) as avg_death,
  min(death) as min_death,
  max(assists) as max_assist,
  avg(assists) as avg_assist,
  min(assists) as min_assist
FROM 
  player, hero
WHERE 
  player.hero_id = hero.hero_id
GROUP BY
  hero.name
;

------ find last_hits, denies for each hero
CREATE OR REPLACE VIEW hero_view2 AS
SELECT 
  hero.name as hero,
  max(last_hits) as max_last_hit,
  avg(last_hits) as avg_last_hit,
  min(last_hits) as min_last_hit,
  max(denies) as max_deny,
  avg(denies) as avg_deny,
  avg(denies) as min_deny
FROM 
  player, hero
WHERE 
  player.hero_id=hero.hero_id
GROUP BY
  hero.name
;

ALTER TABLE user_item ALTER COLUMN player_slot TYPE integer USING (player_slot::integer);

SELECT
  *
FROM 
  item_hero
WHERE
  times=(
    SELECT 
      max(times)
    FROM
      item_hero
    WHERE
      hero_name='Invoker' AND item_name!='empty')
  AND
    hero_name='Invoker';


SELECT 
  hero_name, item_name, times
FROM   
  item_name item1
  JOIN 
    hero_name hero1
  ON 
    c1.country=ct.code
WHERE  
  item_name.population=(SELECT MAX(times)
    FROM city c2
    WHERE c1.country=c2.country)
ORDER BY country