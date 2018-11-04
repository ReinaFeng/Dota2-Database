CREATE TABLE hero_roles (
  hero_id int REFERENCES hero(id),
  role varchar(24)
);