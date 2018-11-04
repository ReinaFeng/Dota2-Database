CREATE TABLE users (
    steam_id varchar(20) primary key,
    avatarfull varchar(255),
    competitive_rank varchar(50),
    is_contributor varchar(5),
    last_login varchar(20),
    leaderboard_rank varchar(50),
    loccountrycode varchar(10),
    mmr_estimate int,
    name varchar(50),
    personaname varchar(50),
    profileurl varchar(255),
    solo_competitive_rank int
);