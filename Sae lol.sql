---------------------------
-- SAE LEAGUE OF LEGENDS -- 
---------------------------

-- EQUIPE --
CREATE TABLE equipe (
  id_equipe INTEGER PRIMARY KEY,
  nom_equipe TEXT NOT NULL,
  region_equipe TEXT NOT NULL
);


-----------------------------

-- Tuples Equipe --
INSERT INTO equipe (id_equipe, nom_equipe, region_equipe) VALUES
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
CREATE TABLE joueurs (
  id_joueur INTEGER PRIMARY KEY,
  pseudo_jeu TEXT NOT NULL,
  nom_joueur TEXT NOT NULL,
  datenaissance date NOT NULL, 
  id_team INTEGER NOT NULL,
  -- id_role INT NOT NULL,
  FOREIGN KEY (id_team) REFERENCES equipe (id));
  -- FOREIGN KEY(id_role) REFERENCES Rôle(id_role),



-- TUPLES JOUEUR --
INSERT INTO joueurs (id_joueur, pseudo_jeu, nom_joueur , datenaissance , id_team) VALUES
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
CREATE TABLE matchs (
  id_match INTEGER PRIMARY KEY,
  equipe1_id INTEGER NOT NULL,
  equipe2_id INTEGER NOT NULL,
  equipe1_score INTEGER NOT NULL,
  equipe2_score INTEGER NOT NULL,
  date_match DATE NOT NULL, 
  duree_match INT,
  FOREIGN KEY (equipe1_id) REFERENCES equipe (id),
  FOREIGN KEY (equipe2_id) REFERENCES equipe (id)
);


INSERT INTO matchs VALUES 
  (1, 1, 2, 5, 1, '06/07/2022', 45),
  (2, 2, 3, 1, 0, '07/07/2022', 25),
  (3, 3, 4, 0, 2, '08/07/2022', 29),
  (4, 4, 5, 1, 3, '09/07/2022', 40),
  (5, 5, 6, 0, 1, '10/07/2022', 30),
  (6, 6, 7, 2, 1, '11/07/2022', 24),
  (7, 7, 8, 3, 1, '12/07/2022', 34),
  (8, 8, 9, 2, 0, '13/07/2022', 40),
  (9, 9, 10, 1, 2, '14/07/2022', 36),
  (10, 10, 1, 0, 3, '25/07/2022', 41)






CREATE TABLE penalite(
  id_penalite INT PRIMARY KEY,
  type_penalite VARCHAR(50) NOT NULL,
);

INSERT INTO penalite VALUES 
  (1, 'Retard'), 
  (2, 'Absence'),
  (3, 'Tricherie'),
  (4, 'Dopage'),
  (5, 'Insultes')
  



CREATE TABLE statistiques_equipe(
  id_stastistiques INT PRIMARY KEY,
  nombre_victoires INT,
  nombre_défaites INT,
);



CREATE TABLE role(
  id_role INT PRIMARY KEY,
  nom_role VARCHAR(50),
);

INSERT INTO role VALUES 
  (1, 'assassins'),
  (2, 'mages'),
  (3, 'tanks'),
  (4, 'tireurs'),
  (5, 'supports'),
  (6, 'combattants')




CREATE TABLE classement(
  position INT PRIMARY KEY,
  victoires INT,
  défaites INT,
  matchs_joués INT,
  ratio INT,
  enchainement_victoires INT,
);



CREATE TABLE personnage_fictif(
  id_personnage INT PRIMARY KEY,
  nom_personnage VARCHAR(50),
  id_role INT NOT NULL,
  FOREIGN KEY(id_role) REFERENCES role(id_role)
);


-- Pour Antoine ça 




CREATE TABLE avoir_penalite(
  id_equipe INT,
  id_joueur INT,
  id_penalite INT,
  PRIMARY KEY(id_equipe, id_joueur, id_penalite),
  FOREIGN KEY(id_equipe) REFERENCES equipe(id_equipe),
  FOREIGN KEY(id_joueur) REFERENCES joueurs(id_joueur),
  FOREIGN KEY(id_penalite) REFERENCES penalite(id_penalite)
);

  

INSERT INTO avoir_penalite VALUES
  (1,2,1),
  (1,3,3),
  (3,12,1),
  (6,30,5),
  (7,35,1),
  (8,39,5),
  (9,41,4)



CREATE TABLE statistiques_match(
  id_equipe INT,
  id_joueur INT,
  id_match INT,
  nombre_kills INT,
  nombre_morts INT,
  PRIMARY KEY(id_equipe, id_joueur, id_match),
  FOREIGN KEY(id_equipe) REFERENCES equipe(id_equipe),
  FOREIGN KEY(id_joueur) REFERENCES joueur(id_joueur),
  FOREIGN KEY(id_match) REFERENCES matchs(id_match)
);



CREATE TABLE marquer_point(
   id_match INT,
   id_match_1 INT,
   PRIMARY KEY(id_match, id_match_1),
   FOREIGN KEY(id_match) REFERENCES matchs(id_match),
   FOREIGN KEY(id_match_1) REFERENCES matchs(id_match)
);







---------------------
--- TRIGER ---------
--------------------




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
  FOREIGN KEY (team_id) REFERENCES equipe (id)
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