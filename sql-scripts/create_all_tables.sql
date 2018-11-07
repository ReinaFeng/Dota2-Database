DROP TABLE user_item;
DROP TABLE hero_roles;
DROP TABLE Player;
DROP TABLE users;
DROP TABLE Match;
DROP TABLE hero;
DROP TABLE item;


-----
CREATE TABLE item (
  item_id varchar(20) PRIMARY KEY,
  cost int,
  en_name varchar(50),
  name varchar(50) UNIQUE,
  recipe varchar(5),
  secret_shop varchar(5),
  side_shop varchar(5)
);


-----
CREATE TABLE hero (
  hero_id varchar(3) PRIMARY KEY,
  name varchar(30),
  primary_attr varchar(30),
  attack_type varchar(30),
  legs int
);

-----
CREATE TABLE match(
  all_gg_counts int,
  barracks_status_dire int,
  barracks_status_radiant int,
  cluster1 int,
  dire_logo varchar(255),
  dire_score int,
  dire_team_id varchar(20),
  duration1 int,
  engine int,
  first_blood_time varchar(20),
  game_mode int,
  human_players int,
  league_name varchar(50),
  leagueid varchar(50),
  match_id varchar(20) primary key,
  negative_votes int,
  positive_votes int,
  radiant_gold_adv int,
  radiant_logo varchar(255),
  radiant_score int,
  radiant_team varchar(20),
  radiant_win int,
  radiant_xp_adv int,
  region int,
  replay_url varchar(255),
  start_time varchar(12),
  tower_status_dire int,
  tower_status_radiant int,
  version1 int,
  constraint bool_radiant_win check(radiant_win in(1,0))
);


------
CREATE TABLE users(
    avatarfull varchar(255),
    competitive_rank varchar(50),
    is_contributor varchar(5) NOT NULL,
    last_login varchar(20),
    leaderboard_rank varchar(50),
    loccountrycode varchar(10),
    mmr_estimate int,
    name varchar(50),
    personaname varchar(50),
    profileurl varchar(255),
    solo_competitive_rank int,
    steam_id varchar(9) primary key,
    constraint contributor check(is_contributor in ('True','False'))
);


-----
CREATE TABLE Player
(
kda int NOT NULL,
assists int NOT NULL,
death int NOT NULL,
denies int NOT NULL,
game_mode char(2),
gpm int NOT NULL,
hero_demage int NOT NULL,
hero_id varchar(3) NOT NULL,
kills int NOT NULL,
last_hits int NOT NULL,
leaver_status int NOT NULL,
llevel int NOT NULL,
match_id varchar(20),
player_slot int,
steam_id varchar(9) default '000000000',
total_gold int NOT NULL,
tower_damage int NOT NULL,
win int,
xpm int NOT NULL,
Constraint player_pk Primary Key (match_id, player_slot),
Constraint fk_steam_id Foreign Key (steam_id) References Users (steam_id),
Constraint fk_match_id Foreign Key (match_id) References Match (match_id),
Constraint fk_hero_id Foreign Key(hero_id) References hero (hero_id),
Constraint player_slot check (player_slot in (1,2,3,4,5,6,7,8,9,10)),
Constraint leaver_status check (leaver_status in (0,1)),
Constraint win check(win in (0, 1))
);


-----
CREATE TABLE hero_roles (
  hero_id varchar(3) REFERENCES hero(hero_id),
  role varchar(24),
  Constraint pk Primary Key (hero_id, role)
);


-----
CREATE TABLE user_item (
  item_id varchar(20) REFERENCES item(item_id),
  item_slot varchar(1),
  match_id varchar(20) REFERENCES match(match_id),
  player_slot varchar(3),
  Constraint user_item_pk Primary key (match_id, player_slot, item_slot)
);

--- In table ‘Player’, kda is a derived attribute, so we write this trigger to compute kda.
CREATE OR REPLACE TRIGGER compute_kda
BEFORE INSERT OR UPDATE ON Player
BEGIN
    if (:new.death = 0) then :new.kda := :new.kills + :new.assists;
    elsif (:new.death <> 0) then :new.kda := (:new.kills + :new.assists)/(:new.death);
    end if;
END;
