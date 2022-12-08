DROP TABLE IF EXISTS equipe CASCADE;
CREATE TABLE equipe
  (
    id_equipe   INT,
    nom_equipe  VARCHAR(100) NOT NULL,
    pays_equipe VARCHAR(100) NOT NULL,
    PRIMARY KEY(id_equipe)
  );

DROP TABLE IF EXISTS match CASCADE;
CREATE TABLE match
  (
    id_match       INTEGER,
    id_equipe_1    INTEGER NOT NULL,
    id_equipe_2    INTEGER NOT NULL,
    score_equipe_1 INTEGER NOT NULL,
    score_equipe_2 INTEGER NOT NULL,
    date_match     DATE NOT NULL,
    duree_match    INT,
    PRIMARY KEY(id_match),
    FOREIGN KEY(id_equipe_1) REFERENCES equipe(id_equipe),
    FOREIGN KEY(id_equipe_2) REFERENCES equipe(id_equipe)
  );

DROP TABLE IF EXISTS penalite CASCADE;
CREATE TABLE penalite
  (
    id_penalite   INT,
    type_penalite VARCHAR(100) NOT NULL,
    PRIMARY KEY(id_penalite)
  );

DROP TABLE IF EXISTS role CASCADE;
CREATE TABLE role
  (
    id_role  INT,
    nom_role VARCHAR(100),
    PRIMARY KEY(id_role)
  );

DROP TABLE IF EXISTS joueur CASCADE;
CREATE TABLE joueur
  (
    id_joueur      INT,
    pseudo_joueur  VARCHAR(100) NOT NULL,
    nom_joueur     VARCHAR(100) NOT NULL,
    date_naissance DATE NOT NULL,
    id_role        INT NOT NULL,
    id_equipe      INT NOT NULL,
    PRIMARY KEY(id_joueur),
    FOREIGN KEY(id_role) REFERENCES role(id_role),
    FOREIGN KEY(id_equipe) REFERENCES equipe(id_equipe)
  );

DROP TABLE IF EXISTS personnage_fictif CASCADE;
CREATE TABLE personnage_fictif
  (
    id_personnage  INT,
    nom_personnage VARCHAR(100),
    id_role        INT NOT NULL,
    PRIMARY KEY(id_personnage),
    FOREIGN KEY(id_role) REFERENCES role(id_role)
  );

DROP TABLE IF EXISTS avoir_penalite CASCADE;
CREATE TABLE avoir_penalite
  (
    id_equipe   INT,
    id_joueur   INT,
    id_penalite INT,
    PRIMARY KEY(id_equipe, id_joueur, id_penalite),
    FOREIGN KEY(id_equipe) REFERENCES equipe(id_equipe),
    FOREIGN KEY(id_joueur) REFERENCES joueur(id_joueur),
    FOREIGN KEY(id_penalite) REFERENCES penalite(id_penalite)
  );

DROP TABLE IF EXISTS statistiques_match CASCADE;
CREATE TABLE statistiques_match
  (
    id_equipe    INT,
    id_joueur    INT,
    id_match     INT,
    nombre_kills INT,
    nombre_morts INT,
    PRIMARY KEY(id_equipe, id_joueur, id_match),
    FOREIGN KEY(id_equipe) REFERENCES equipe(id_equipe),
    FOREIGN KEY(id_joueur) REFERENCES joueur(id_joueur),
    FOREIGN KEY(id_match) REFERENCES match(id_match)
  );

DROP TABLE IF EXISTS classement CASCADE;
CREATE TABLE classement
  (
    position         INTEGER NOT NULL,
    id_equipe        INTEGER NOT NULL,
    nombre_victoires INTEGER NOT NULL,
    nombre_defaites  INTEGER NOT NULL,
    matchs_joues           INT,
    ratio                  INT,
    enchainement_victoires INT,
    PRIMARY KEY(id_equipe),
    FOREIGN KEY(id_equipe) REFERENCES equipe(id_equipe)
  );

INSERT INTO equipe (id_equipe, nom_equipe, pays_equipe) VALUES
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

INSERT INTO role VALUES 
  (1, 'assassins'),
  (2, 'mages'),
  (3, 'tanks'),
  (4, 'tireurs'),
  (5, 'supports'),
  (6, 'combattants');

INSERT INTO joueur (id_joueur, pseudo_joueur, nom_joueur , date_naissance , id_equipe, id_role) VALUES
  (1, 'Faker', 'Lee Sang-hyeok' , '07/05/1996' ,  1, 1),
  (2, 'Zeus', 'Choi Woo-je' ,'31/01/2004' , 1, 1),
  (3, 'Oner' , 'Mun Hyeon-jun' ,'24/12/2002' , 1, 1),
  (4, 'Gumayusi' , 'Lee Min-hyeong', '06/02/2002' , 1, 1),
  (5, 'Keria' , 'Ryu Min-seok' , '14/10/2002' , 1, 1),
  (6, 'Doran' , 'Choi Hyeon-joon' , '22/07/2000',2, 1),
  (7, 'Peanut' , 'Han Wang-ho' , '03/02/1998' , 2, 1),
  (8, 'Chovy' , 'Jeong Ji-hoon' , '03/03/2001' , 2, 1),
  (9, 'Peyz' , 'Kim Su-hwan' , '05/12/2005' , 2, 1),
  (10, 'Delight' , 'Yoo Hwan-joong' , '12/09/2002' , 2, 1),
  (11, 'Rascal' , 'Kim Kwang-hee' , '16/10/1997' , 3, 1),
  (12, 'Croco' , 'Kim Dong-beom' , '23/02/2000' , 3, 1), 
  (13, 'FATE' , 'Yoo Su-hyeok' , '22/08/2000' , 3, 1),
  (14 , 'Deokdam' , 'Seo Dae-gil' , '25/02/2000', 3, 1),
  (15 , 'BeryL' , 'Cho Geon-hee' , '01/04/1997', 3, 1),
  (16 , 'Burdol' , 'Noh Tae-yoon' , '25/12/2003' , 4, 1),
  (17 , 'Willer' , 'Kim Jeong-hyeon' , '24/04/2003' , 4, 1),
  (18 , 'Clozer' , 'Lee Ju-hyeon' , '27/07/2003', 4, 1),
  (19 , 'Envyy' , 'Lee Myeong-joon' , '07/04/2000', 4, 1),
  (20 , 'Kael' , 'Kim Jin-hong' , '11/02/2004' , 4, 1),
  (21 , 'Canna' , 'Kim Chang-dong' , '11/02/2000' , 5, 1),
  (22 , 'Canyon' , 'Kim Geon-bu' , '18/06/2001' , 5, 1),
  (23 , 'ShowMaker' , 'Heo su' , '22/07/2002' , 5, 1),
  (24 , 'Deft' , 'Kim Hyuk-kyu' , '23/10/1996' , 5, 1),
  (25 , 'Kellin'  , 'Kim Hyeong-gyu ' , '01/02/2001' ,5, 1),
  (26 , 'Kiin' , 'Kim Gi-in' , '28/05/1998' , 6, 1),
  (27 , 'Cuzz' , 'Moon Woo-chan' , '30/10/2001' , 6, 1), 
  (28 , 'Bdd' , 'Gwak Bo-seong' , '01/03/1999' , 6, 1),
  (29 , 'Aiming' , 'Kim Ha-ram' , '20/07/2000' , 6, 1), 
  (30 , 'Lehends' , 'Son Si-woo' , '24/12/1998' , 6, 1),
  (31 , 'DuDu' , 'Lee Dong-ju' , '08/03/2001' , 7, 1),
  (32 , 'YoungJae' , 'Ko Yeong-jae' , '16/11/2002', 7, 1),
  (33 , 'BuLLDoG ' , 'Lee Tae-young' , '15/04/2005' , 7, 1),
  (34 , 'Taeyoon' , 'Kim Tae-yoon' , '06/02/2002' , 7, 1),
  (35 , 'Jun' , 'Yoon Se-jun' , '02/08/2000' , 7, 1), 
  (36 , 'DnDn' , 'Park Geun-woo' , '18/05/2001' , 8, 1),
  (37 , 'Sylvie' , 'Lee Seung-bok' , '12/04/2002' , 8, 1),
  (38 , 'vital' , 'Ha In-seong' , '16/09/2002' , 8, 1),
  (39 , 'FIESTA' , 'An Hyeon-seo' , '05/04/2003' , 8, 1),
  (40 , 'Peter' , 'Jeong Yoon-su' , '28/04/2003' , 8, 1),
  (41 , 'Morgan' , 'Park Gi-tae' , '26/09/2002' , 9, 1),
  (42 , 'Hena' , 'Park Jeung-hwan' , '10/08/2000' , 9, 1),
  (43 ,'Effort' , 'Park Jeung-hwan' , '23/11/2001' , 9, 1),
  (44 , 'Lava' , 'Kim Tae-hoon' , '14/07/1999' , 9, 1),
  (45 , 'UmTi' , 'Eom Seong-hyeon' , '06/02/2000' , 9 , 1), 
  (46 , 'Kingen' , 'Hwang Seong-hoon' , '11/03/2000' , 10, 1),
  (47, 'Clid' , 'Kim Tae-min' , '07/07/1999' , 10, 1),
  (48 , 'Zeka' , 'Kim Geon-woo' , '28/11/2002',10, 1),
  (49 , 'Viper' , 'Park Do-hyeon' , '19/10/2000' , 10, 1),
  (50, 'Life', 'Kim Jeong-min' , '07/07/2000', 10, 1);

INSERT INTO match VALUES 
  (1, 1, 2, 5, 1, '06/07/2022', 45),
  (2, 2, 3, 1, 0, '07/07/2022', 25),
  (3, 3, 4, 0, 2, '08/07/2022', 29),
  (4, 4, 5, 1, 3, '09/07/2022', 40),
  (5, 5, 6, 0, 1, '10/07/2022', 30),
  (6, 6, 7, 2, 1, '11/07/2022', 24),
  (7, 7, 8, 3, 1, '12/07/2022', 34),
  (8, 8, 9, 2, 0, '13/07/2022', 40),
  (9, 9, 10, 1, 2, '14/07/2022', 36),
  (10, 10, 1, 0, 3, '25/07/2022', 41);

INSERT INTO penalite VALUES 
  (1, 'retard'), 
  (2, 'absence'),
  (3, 'tricherie'),
  (4, 'dopage'),
  (5, 'insultes');

INSERT INTO avoir_penalite VALUES
  (1,2,1),
  (1,3,3),
  (3,12,1),
  (6,30,5),
  (7,35,1),
  (8,39,5),
  (9,41,4);

INSERT INTO classement VALUES
  (1, 1, 10, 5),
  (2, 2, 8, 7),
  (3, 3, 7, 8),
  (4, 4, 6, 9),
  (5, 5, 5, 10);