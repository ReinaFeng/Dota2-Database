CREATE TABLE use_item (
  item varchar(20) REFERENCES item(item_id),
  match_id varchar(20) REFERENCES match(match_id),
  steam_id varchar(20) REFERENCES users(steam_id)
);