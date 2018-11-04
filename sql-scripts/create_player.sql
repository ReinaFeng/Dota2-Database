CREATE TABLE player (
  assists int,
  death int,
  game_mode char(2),
  hero_id char(3),
  kills int,
  leaver_status boolean,
  match_id char(10),
  party_size int,
  player_slot int,
  radiant_win boolean,
  steam_id char(9),
  Constraint pk Primary Key (match_id, steam_id),
  Constraint fk_steam_id Foreign Key (steam_id) References users (steam_id),
  Constraint fk_match_id Foreign Key (match_id) References match (match_id)
);