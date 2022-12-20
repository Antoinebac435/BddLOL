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
    points                  INT,
    enchainement_victoires INT,
    PRIMARY KEY(id_equipe),
    FOREIGN KEY(id_equipe) REFERENCES equipe(id_equipe)
  );
  
  
DROP TABLE IF EXISTS classement_meilleurs_tueurs CASCADE;
CREATE TABLE classement_meilleurs_tueurs
  (
    id_joueur         INTEGER NOT NULL,
    id_equipe        INTEGER NOT NULL,
    nombre_de_victimes INTEGER NOT NULL
  );
 
DROP TABLE IF EXISTS statistiques_joueurs CASCADE;
CREATE TABLE statistiques_joueurs
  (
    id_joueur      INTEGER,
    total_victimes INTEGER,
    total_morts    INTEGER
  );


DROP TABLE IF EXISTS champions  CASCADE;
CREATE TABLE champions (
   id_champ INTEGER primary key ,
   nom varchar(255),
   role varchar(255)
);

DROP TABLE IF EXISTS joueur_exclu  CASCADE;
CREATE TABLE joueur_exclu (
   nom_joueur_exclu varchar(255) ,
   type_exclusion INT

);




INSERT INTO equipe (id_equipe, nom_equipe, pays_equipe) VALUES
  (1, 'SK Telecom T1', 'Coree du Sud'),
  (2, 'Gen.G', 'Coree du Sud'),
  (3, 'DragonX', 'Coree du Sud'),
  (4, 'Liiv SANDBOX', 'Coree du Sud'),
  (5, 'DWG KIA', 'Coree du Sud'),
  (6, 'KT Rolster' , 'Coree du Sud'),
  (7, 'Kwangdong Freecs' , 'Coree du Sud'),
  (8, 'Nogshim RedForce' , 'Coree du Sud'),
  (9, 'Fredit BRION' , 'Coree du Sud'),
  (10, 'Hanwha Life Esports' , 'Coree du Sud');

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
  (1,1,0,0,0,0,0), 
  (2,2,0,0,0,0,0), 
  (3,3,0,0,0,0,0), 
  (4,4,0,0,0,0,0), 
  (5,5,0,0,0,0,0), 
  (6,6,0,0,0,0,0), 
  (7,7,0,0,0,0,0), 
  (8,8,0,0,0,0,0), 
  (9,9,0,0,0,0,0), 
  (10,10,0,0,0,0,0) ; 


INSERT INTO statistiques_joueurs VALUES
  (1,0,0), 
  (2,0,0), 
  (3,0,0), 
  (4,0,0), 
  (5,0,0), 
  (6,0,0), 
  (7,0,0), 
  (8,0,0), 
  (9,0,0), 
  (10,0,0), 
  (11,0,0), 
  (12,0,0), 
  (13,0,0), 
  (14,0,0), 
  (15,0,0), 
  (16,0,0), 
  (17,0,0), 
  (18,0,0), 
  (19,0,0), 
  (20,0,0), 
  (21,0,0), 
  (22,0,0), 
  (23,0,0), 
  (24,0,0), 
  (25,0,0), 
  (26,0,0), 
  (27,0,0), 
  (28,0,0), 
  (29,0,0), 
  (30,0,0), 
  (31,0,0), 
  (32,0,0), 
  (33,0,0), 
  (34,0,0), 
  (35,0,0), 
  (36,0,0), 
  (37,0,0), 
  (38,0,0), 
  (39,0,0), 
  (40,0,0), 
  (41,0,0), 
  (42,0,0), 
  (43,0,0), 
  (44,0,0), 
  (45,0,0), 
  (46,0,0), 
  (47,0,0), 
  (48,0,0), 
  (49,0,0), 
  (50,0,0) ;




INSERT INTO champions (id_champ , nom, role) VALUES
(1,'Jax','TOP'),
(2,'Sona','SUP'),
(3,'Tristana','ADC'),
(4,'Varus','ADC'),
(5,'Fiora','TOP'),
(6,'Singed','TOP'),
(7,'Tahm Kench','TOP'),
(8,'LeBlanc','MID'),
(9,'Thresh','SUP'),
(10,'Karma','SUP'),
(11,'Jhin','ADC'),
(12,'Rumble','TOP'),
(13,'Udyr','JUG'),
(14,'Lee Sin','JUG'),
(15,'Yorick','TOP'),
(16,'Ornn','TOP'),
(17,'Kayn','JUG'),
(18,'Kassadin','MID'),
(19,'Sivir','ADC'),
(20,'Miss Fortune','ADC'),
(21,'Draven','ADC'),
(22,'Yasuo','MID'),
(23,'Kayle','TOP'),
(24,'Shaco','JUG'),
(25,'Renekton','TOP'),
(26,'Hecarim','JUG'),
(27,'Fizz','MID'),
(28,'KogMaw	','ADC'),
(29,'Maokai	','JUG'),
(30,'Lissandra','MID'),
(31,'Jinx	','ADC'),
(32,'Urgot','TOP'),
(33,'Fiddlesticks','JUG'),
(34,'Galio','MID'),
(35,'Pantheon','MID'),
(36,'Talon','MID'),
(37,'Gangplank','TOP'),
(38,'Ezreal','ADC'),
(39,'Gnar','TOP'),
(40,'Teemo','TOP'),
(41,'Annie','MID'),
(42,'Mordekaiser','TOP'),
(43,'Azir','MID'),
(44,'Kennen	','TOP'),
(45,'Riven','TOP'),
(46,'ChoGath','TOP'),
(47,'Aatrox','TOP'),
(48,'Poppy','JUG'),
(49,'Taliyah','JUG'),
(50,'Illaoi	','TOP'),
(51,'Heimerdinger','SUP'),
(52,'Alistar','SUP'),
(53,'Xin Zhao','JUG'),
(54,'Lucian	','ADC'),
(55,'Volibear','JUG'),
(56,'Sejuani','JUG'),
(57,'Nidalee','JUG'),
(59,'Leona','SUP'),
(60,'Zed','MID'),
(61,'Blitzcrank','SUP'),
(62,'Rammus','JUG'),
(63,'VelKoz','MID'),
(64,'Caitlyn','ADC'),
(65,'Trundle','JUG'),
(66,'Kindred','JUG'),
(67,'Quinn','TOP'),
(68,'Ekko','MID'),
(69,'Nami','SUP'),
(70,'Swain','MID'),
(71,'Taric','SUP'),
(72,'Syndra','MID'),
(73,'Rakan','SUP'),
(74,'Skarner','JUG'),
(75,'Braum','SUP'),
(76,'Veigar','MID'),
(77,'Xerath','MID'),
(78,'Corki','MID'),
(79,'Nautilus','SUP'),
(80,'Ahri	','MID'),
(81,'Jayce','TOP'),
(82,'Darius','TOP'),
(83,'Tryndamere','TOP'),
(84,'Janna','SUP'),
(85,'Elise','JUG'),
(86,'Vayne','ADC'),
(87,'Brand','MID'),
(88,'Graves','JUG'),
(89,'Soraka','SUP'),
(90,'Xayah','ADC'),
(91,'Karthus','JUG'),
(92,'Vladimir','MID'),
(93,'Zilean','SUP'),
(94,'Katarina','MID'),
(95,'Shyvana','JUG'),
(96,'Warwick','JUG'),
(97,'Ziggs','MID'),
(98,'Kled','TOP'),
(99,'KhaZix','JUG'),
(100,'Olaf	','TOP'),
(101,'Twisted Fate','MID'),
(102,'Nunu','JUG'),
(103,'Rengar','JUG'),
(104,'Bard	','SUP'),
(105,'Irelia','TOP'),
(106,'Ivern','JUG'),
(107,'Wukong','TOP'),
(108,'Ashe','ADC'),
(109,'Kalista','ADC'),
(110,'Akali','MID'),
(111,'Vi	','JUG'),
(112,'Amumu','JUG'),
(113,'Lulu	','SUP'),
(114,'Morgana','SUP'),
(115,'Nocturne','JUG'),
(116,'Diana','JUG'),
(117,'Aurelion Sol','MID'),
(118,'Zyra','SUP'),
(119,'Viktor','MID'),
(120,'Cassiopeia','MID'),
(121,'Nasus','TOP'),
(122,'Twitch','ADC'),
(123,'DrMundo','TOP'),
(124,'Orianna','MID'),
(125,'Evelynn','JUG'),
(126,'RekSai','JUG'),
(127,'Lux','SUP'),
(128,'Sion','TOP'),
(129,'Camille','TOP'),
(130,'Master Yi','JUG'),
(131,'Ryze','MID'),
(132,'Malphite','TOP'),
(133,'Anivia','MID'),
(134,'Shen','TOP'),
(135,'Jarvan IV','JUG'),
(136,'Malzahar','MID'),
(137,'Zac','JUG'),
(138,'Gragas','TOP') ;



INSERT INTO match VALUES 
  (1,1,2,2,0,'01/11/2022',59), 
  (2,1,3,3,4,'10/11/2022',72), 
  (3,1,4,5,1,'18/11/2022',65), 
  (4,1,5,4,2,'25/11/2022',55), 
  (5,1,6,0,1,'02/12/2022',54), 
  (6,1,7,2,1,'07/12/2022',60), 
  (7,1,8,5,4,'11/12/2022',59), 
  (8,1,9,2,0,'14/12/2022',62), 
  (9,1,10,3,1,'16/12/2022',48), 

  (10,2,3,0,5,'02/11/2022',70), 
  (11,2,4,3,1,'11/11/2022',52), 
  (12,2,5,2,4,'19/11/2022',49), 
  (13,2,6,1,0,'26/11/2022',74), 
  (14,2,7,4,3,'03/12/2022',54), 
  (15,2,8,2,5,'08/12/2022',47), 
  (16,2,9,2,0,'12/12/2022',63), 
  (17,2,10,5,3,'15/12/2022',70), 

  (18,3,4,1,4,'03/11/2022',45), 
  (19,3,5,5,2,'12/11/2022',54), 
  (20,3,6,4,1,'20/11/2022',65), 
  (21,3,7,0,3,'27/11/2022',61), 
  (22,3,8,3,2,'04/12/2022',59), 
  (23,3,9,4,5,'09/12/2022',63), 
  (24,3,10,1,0,'13/12/2022',69), 

  (25,4,5,3, 0,'04/11/2022',67), 
  (26,4,6,5,1,'13/11/2022',73), 
  (27,4,7,2,4,'21/11/2022',72), 
  (28,4,8,2,0,'28/11/2022',60), 
  (29,4,9,1,4,'05/12/2022',70), 
  (30,4,10,5,3,'10/12/2022',61), 

  (31,5,6,5,3,'05/11/2022',58), 
  (32,5,7,4,2,'14/11/2022',49), 
  (33,5,8,0,1,'22/11/2022',65), 
  (34,5,9,1,0,'29/11/2022',59), 
  (35,5,10,4,5,'06/12/2022',45), 

  (36,6,7,3,2,'06/11/2022',64), 
  (37,6,8,2,0,'15/11/2022',73), 
  (38,6,9,5,4,'23/11/2022',57), 
  (39,6,10,1,3,'30/11/2022',63), 

  (40,7,8,5,1,'16/11/2022',72), 
  (41,7,9,4,0,'24/11/2022',52), 
  (42,7,10,2,3,'01/12/2022',74), 

  (43,8,9,1,3,'08/11/2022',73), 
  (44,8,10,2,4,'17/11/2022',68), 

  (45,9,10,5,0,'09/11/2022',60) ;