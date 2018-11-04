CREATE TABLE item (
  item_id varchar(20) PRIMARY KEY,
  cost int,
  en_name varchar(50) UNIQUE,
  cn_name varchar(50) UNIQUE,
  name varchar(50) UNIQUE,
  recipe varchar(5),
  secret_shop varchar(5),
  side_shop varchar(5)
);