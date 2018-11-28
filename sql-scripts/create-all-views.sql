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

--This isn't necessary
-- View Users By Win Rate
-- This query will allow you to sort all the Users in our database by their win rate.
-- CREATE OR REPLACE VIEW user_view2 AS
-- Select a.steam_id
--          ,(a.win_match)/(b.total_match) as win_rate
-- From (select steam_id, count(match_id) as win_match
--            from player
--            where win=1
--            group by steam_id) a left join
--          (select steam_id, count(match_id) as total_match
--           from player
--          group by steam_id) b on a.steam_id = b.steam_id
-- Order by win_rate
-- ;

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
select *
from (
	select player.hero_id, count(*) as Times
	from player
	group by player.hero_id) as frq_hero, hero
where hero.hero_id=frq_hero.hero_id
Order by frq_hero.Times
;

-- View The Most Common Item for a Hero
-- This query will tell you what Item is most commonly used by a given Hero.
CREATE OR REPLACE VIEW item_hero AS
select hero.name, item.name, it_times.times
from(
select hero_item.hero_id,hero_item.item_id, count(*) as times
from (
	select player.match_id, player.hero_id, user_item.item_id
	from user_item, player
	where player.steam_id=user_item.steam_id and player.match_id=user_item.match_id)as hero_item
group by hero_item.item_id)as it_times, hero, item
where hero.hero_id=it_times.hero_id and item.item_id=it_times.item_id
order by it_times.times
;

-- View Winners of a Match
-- This query will return which Players won a specific Match
CREATE OR REPLACE VIEW match_view1 AS
Select personaname, profileurl, hero_id, steam_id, match_id
from users join player using (steam_id) 
where player.win=1
;

----- CREATE VIEW
------ find kill, death, assist for each user with a specific hero
CREATE OR REPLACE VIEW user_hero_view1
select Player.steam_id
     ,Hero.name as hero
     ,max(kills) as max_kill
     ,avg(kills) as avg_kill
     ,min(kills) as min_kill
     ,max(deaths) as max_death
     ,avg(deaths) as avg_death
     ,min(deaths) as min_death
     ,max(assists) as max_assist
     ,avg(assists) as avg_assist
     ,min(assists) as min_assist
from Player p, hero h
where p.hero_id = h.hero_id
group by P.steam_id, H.name
;

------- find kill,death,assist for each user
CREATE OR REPLACE VIEW user_view1
select steam_id
     ,max(kills) as max_kill
     ,avg(kills) as avg_kill
     ,min(kills) as min_kill
     ,max(deaths) as max_death
     ,avg(deaths) as avg_death
     ,min(deaths) as min_death
     ,max(assists) as max_assist
     ,avg(assists) as avg_assist
     ,min(assists) as min_assist
from Player
group by steam_id
;

------ find kill, death, assist for each hero
CREATE OR REPLACE VIEW hero_view1
select hero.name as hero
     ,max(kills) as max_kill
     ,avg(kills) as avg_kill
     ,min(kills) as min_kill
     ,max(deaths) as max_death
     ,avg(deaths) as avg_death
     ,min(deaths) as min_death
     ,max(assists) as max_assist
     ,avg(assists) as avg_assist
     ,min(assists) as min_assist
from Player, hero
where player.hero_id = hero.hero_id
group by Hero.name
;

------ find last_hits, denies for each hero
CREATE OR REPLACE VIEW hero_view2
select hero.name as hero
     ,max(last_hits) as max_last_hit
     ,avg(last_hits) as avg_last_hit
     ,min(last_hits) as min_last_hit
     ,max(denies) as max_deny
     ,avg(denies) as avg_deny
     ,avg(denies) as min_deny
from Player, hero
where Player.hero_id = hero.hero_id
group by Hero.name
;
