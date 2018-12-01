CREATE TRIGGER user_hero
BEFORE INSERT OR UPDATE ON player
FOR EACH ROW
Declare cnt Int;
Begin
  SELECT COUNT(*) INTO cnt
  FROM player
  WHERE match_id = :new.match_id AND hero_id = :new.hero_id
  IF(cnt > 0) THEN
		RAISE_APPLICATION_ERROR(-20004, 'invalid model');
	END IF;
End;