CREATE OR REPLACE VIEW user_view1 AS
Select a.steam_id
         ,(a.win_match)/(b.total_match) as win_rate
From (select steam_id, count(match_id) as win_match
           from player
           where win=1
           group by steam_id) a left join
         (select steam_id, count(match_id) as total_match
          from player
         group by steam_id) b on a.steam_id = b.steam_id
;

CREATE OR REPLACE VIEW user_view2 AS
Select a.steam_id
         ,(a.win_match)/(b.total_match) as win_rate
From (select steam_id, count(match_id) as win_match
           from player
           where win=1
           group by steam_id) a left join
         (select steam_id, count(match_id) as total_match
          from player
         group by steam_id) b on a.steam_id = b.steam_id
Order by win_rate
;

CREATE OR REPLACE VIEW hero_view1 AS
Select t2.name as hero_name
          ,t1.win_rate
From
       (Select a.hero_id
                   ,(a.win_match)/(b.total_match) as win_rate
        From (select hero_id, count(match_id) as win_match
                    from player
           where win=1
           group by hero_id) a left join
         (select hero_id, count(match_id) as total_match
          from player
         group by hero_id) b on a.hero_id = b.hero_id
) t1 left join hero t2 on t1.hero_id = t2.hero_id
Order by win_rate
;

//TODO this is wrong
CREATE OR REPLACE VIEW user_hero2 AS
select *
from (
	select player.hero_id, count(*) as Times
	from player
	group by player.hero_id) as frq_hero, hero
where hero.hero_id=frq_hero.hero_id
Order by frq_hero.Times
;

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

CREATE OR REPLACE VIEW match_view1 AS
Select personaname, profileurl, hero_id, steam_id, match_id
from users join player using (steam_id) 
where player.win=1
;

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
