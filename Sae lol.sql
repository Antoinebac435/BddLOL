Sae lol

-- EQUIPE --
CREATE TABLE teams (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  region TEXT NOT NULL
);
-----------------------------

-- Tuples Equipe --
INSERT INTO teams (id, name, region) VALUES
  (1, 'SK Telecom T1', 'South Korea'),
  (2, 'Gen.G', 'South Korea'),
  (3, 'DragonX', 'South Korea'),
  (4, 'Liiv SANDBOX', 'South Korea'),
  (5, 'DWG KIA', 'South Korea'),
  (6, 'KT Rolster' , 'South Korea'),
  (7, 'Kwangdong Freecs' , 'South Korea'),
  (8, 'Nogshim RedForce' , 'South Korea'),
  (9, 'Fredit BRION' , 'South Korea'),
  (10, 'Hanwha Life Esports' , 'South Korea');
--------------------------


-- JOUEUR --
CREATE TABLE players (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  truename TEXT NOT NULL,
  birth date NOT NULL, 
  team_id INTEGER NOT NULL,
  FOREIGN KEY (team_id) REFERENCES teams (id));

-- TUPLES JOUEUR --
INSERT INTO players (id, name, truename , birth , team_id) VALUES
  (1, 'Faker', 'Lee Sang-hyeok' , '07/05/1996' ,  1),
  (2, 'Zeus', 'Choi Woo-je' ,'31/01/2004' , 1),
  (3, 'Oner' , 'Mun Hyeon-jun' ,'24/12/2002' , 1),
  (4, 'Gumayusi' , 'Lee Min-hyeong', '06/02/2002' , 1),
  (5, 'Keria' , 'Ryu Min-seok' , '14/10/2002' , 1),
  (6, 'Doran' , 'Choi Hyeon-joon' , '22/07/2000',2),
  (7, 'Peanut' , 'Han Wang-ho' , '03/02/1998' , 2),
  (8, 'Chovy' , 'Jeong Ji-hoon' , '03/03/2001' , 2),
  (9, 'Peyz' , 'Kim Su-hwan' , '05/12/2005' , 2),
  (10, 'Delight' , 'Yoo Hwan-joong' , '12/09/2002' , 2),
  (11, 'Rascal' , 'Kim Kwang-hee' , '16/10/1997' , 3),
  (12, 'Croco' , 'Kim Dong-beom' , '23/02/2000' , 3), 
  (13, 'FATE' , 'Yoo Su-hyeok' , '22/08/2000' , 3),
  (14 , 'Deokdam' , 'Seo Dae-gil' , '25/02/2000', 3),
  (15 , 'BeryL' , 'Cho Geon-hee' , '01/04/1997', 3),
  (16 , 'Burdol' , 'Noh Tae-yoon' , '25/12/2003' , 4),
  (17 , 'Willer' , 'Kim Jeong-hyeon' , '24/04/2003' , 4),
  (18 , 'Clozer' , 'Lee Ju-hyeon' , '27/07/2003', 4),
  (19 , 'Envyy' , 'Lee Myeong-joon' , '07/04/2000', 4),
  (20 , 'Kael' , 'Kim Jin-hong' , '11/02/2004' , 4),
  (21 , 'Canna' , 'Kim Chang-dong' , '11/02/2000' , 5),
  (22 , 'Canyon' , 'Kim Geon-bu' , '18/06/2001' , 5),
  (23 , 'ShowMaker' , 'Heo su' , '22/07/2002' , 5),
  (24 , 'Deft' , 'Kim Hyuk-kyu' , '23/10/1996' , 5),
  (25 , 'Kellin'  , 'Kim Hyeong-gyu ' , '01/02/2001' ,5),
  (26 , 'Kiin' , 'Kim Gi-in' , '28/05/1998' , 6),
  (27 , 'Cuzz' , 'Moon Woo-chan' , '30/10/2001' , 6), 
  (28 , 'Bdd' , 'Gwak Bo-seong' , '01/03/1999' , 6),
  (29 , 'Aiming' , 'Kim Ha-ram' , '20/07/2000' , 6), 
  (30 , 'Lehends' , 'Son Si-woo' , '24/12/1998' , 6),
  (31 , 'DuDu' , 'Lee Dong-ju' , '08/03/2001' , 7),
  (32 , 'YoungJae' , 'Ko Yeong-jae' , '16/11/2002', 7),
  (33 , 'BuLLDoG ' , 'Lee Tae-young' , '15/04/2005' , 7),
  (34 , 'Taeyoon' , 'Kim Tae-yoon' , '06/02/2002' , 7),
  (35 , 'Jun' , 'Yoon Se-jun' , '02/08/2000' , 7), 
  (36 , 'DnDn' , 'Park Geun-woo' , '18/05/2001' , 8),
  (37 , 'Sylvie' , 'Lee Seung-bok' , '12/04/2002' , 8),
  (38 , 'vital' , 'Ha In-seong' , '16/09/2002' , 8),
  (39 , 'FIESTA' , 'An Hyeon-seo' , '05/04/2003' , 8),
  (40 , 'Peter' , 'Jeong Yoon-su' , '28/04/2003' , 8),
  (41 , 'Morgan' , 'Park Gi-tae' , '26/09/2002' , 9),
  (42 , 'Hena' , 'Park Jeung-hwan' , '10/08/2000' , 9),
  (43 ,'Effort' , 'Park Jeung-hwan' , '23/11/2001' , 9),
  (44 , 'Lava' , 'Kim Tae-hoon' , '14/07/1999' , 9),
  (45 , 'UmTi' , 'Eom Seong-hyeon' , '06/02/2000' , 9 ), 
  (46 , 'Kingen' , 'Hwang Seong-hoon' , '11/03/2000' , 10),
  (47, 'Clid' , 'Kim Tae-min' , '07/07/1999' , 10),
  (48 , 'Zeka' , 'Kim Geon-woo' , '28/11/2002',10),
  (49 , 'Viper' , 'Park Do-hyeon' , '19/10/2000' , 10),
  (50, 'Life', 'Kim Jeong-min' , '07/07/2000', 10);

------------


-- MATCH , avec score , gagnant--
CREATE TABLE matches (
  id INTEGER PRIMARY KEY,
  team1_id INTEGER NOT NULL,
  team2_id INTEGER NOT NULL,
  team1_score INTEGER NOT NULL,
  team2_score INTEGER NOT NULL,
  winner_id INTEGER NOT NULL,
  FOREIGN KEY (team1_id) REFERENCES teams (id),
  FOREIGN KEY (team2_id) REFERENCES teams (id),
  FOREIGN KEY (winner_id) REFERENCES teams (id)
);

-- Tuples match , id du match , les deux equipe , le score eq1 et eq2 et gagnant--
INSERT INTO matches (id, team1_id, team2_id, team1_score, team2_score, winner_id) VALUES
  (1, 1, 3, 3, 2, 1),
  (2, 2, 4, 2, 3, 4),
  (3, 5, 6, 1, 3, 6);
----------





-- Simulation de match --
CREATE OR REPLACE FUNCTION simulate_match(team1_id INTEGER, team2_id INTEGER)
RETURNS INTEGER
AS
BEGIN
  -- générer des scores aléatoires pour chaque équipe
  team1_score := DBMS_RANDOM.VALUE(1, 3);
  team2_score := DBMS_RANDOM.VALUE(1, 3);

  -- déterminer l'équipe gagnante
  IF team1_score > team2_score THEN
    winner_id := team1_id;
  ELSE
    winner_id := team2_id;
  END IF;

  -- enregistrer les résultats du match dans la table matches
  INSERT INTO matches (team1_id, team2_id, team1_score, team2_score, winner_id)
  VALUES (team1_id, team2_id, team1_score, team2_score, winner_id);

  -- retourner l'identifiant de l'équipe gagnante
  RETURN winner_id;
END;




-- classement--
CREATE TABLE rankings (
  id INTEGER PRIMARY KEY,
  team_id INTEGER NOT NULL,
  wins INTEGER NOT NULL,
  losses INTEGER NOT NULL,
  FOREIGN KEY (team_id) REFERENCES teams (id)
);

INSERT INTO rankings (id, team_id, wins, losses) VALUES
  (1, 1, 10, 5),
  (2, 2, 8, 7),
  (3, 3, 7, 8),
  (4, 4, 6, 9),
  (5, 5, 5, 10);





-- TRIGGER qui mets a jour le rank en fontion de la victoire ou defaite
CREATE OR REPLACE TRIGGER update_rankings
AFTER INSERT ON matches
FOR EACH ROW
BEGIN
  -- incrémenter le nombre de victoires de l'équipe gagnante
  UPDATE rankings
  SET wins = wins + 1
  WHERE team_id = :new.winner_id;

  -- incrémenter le nombre de défaites de l'équipe perdante
  UPDATE rankings
  SET losses = losses + 1
  WHERE team_id <> :new.winner_id;
END;