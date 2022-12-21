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
    nom_role VARCHAR(3),
    PRIMARY KEY(id_role)
  );

DROP TABLE IF EXISTS joueur CASCADE;
CREATE TABLE joueur
  (
    id_joueur      INT,
    pseudo_joueur  VARCHAR(100) NOT NULL,
    nom_joueur     VARCHAR(100) NOT NULL,
    date_naissance DATE NOT NULL,
    id_equipe      INT NOT NULL,
    id_role        INT NOT NULL,
    PRIMARY KEY(id_joueur),
    FOREIGN KEY(id_role)   REFERENCES role(id_role),
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
    FOREIGN KEY(id_equipe)   REFERENCES equipe(id_equipe),
    FOREIGN KEY(id_joueur)   REFERENCES joueur(id_joueur),
    FOREIGN KEY(id_penalite) REFERENCES penalite(id_penalite)
  );

DROP TABLE IF EXISTS statistiques_match CASCADE;
CREATE TABLE statistiques_match
  (
    id_match      INT,
    id_equipe     INT,
    id_joueur     INT,
    id_personnage INT,
    nombre_kills  INT,
    nombre_morts  INT,
    PRIMARY KEY(id_equipe, id_joueur, id_match),
    FOREIGN KEY(id_match)  REFERENCES match(id_match),
    FOREIGN KEY(id_equipe) REFERENCES equipe(id_equipe),
    FOREIGN KEY(id_joueur) REFERENCES joueur(id_joueur)
  );

DROP TABLE IF EXISTS classement CASCADE;
CREATE TABLE classement
  (
    position               INTEGER NOT NULL,
    id_equipe              INTEGER NOT NULL,
    nombre_victoires       INTEGER NOT NULL DEFAULT 0,
    nombre_defaites        INTEGER NOT NULL DEFAULT 0,
    matchs_joues           INT DEFAULT 0,
    points                 INT DEFAULT 0,
    enchainement_victoires INT DEFAULT 0,
    PRIMARY KEY(id_equipe),
    FOREIGN KEY(id_equipe) REFERENCES equipe(id_equipe)
  );
 
DROP TABLE IF EXISTS statistiques_joueurs CASCADE;
CREATE TABLE statistiques_joueurs
  (
    id_joueur      INTEGER NOT NULL,
    total_victimes INTEGER DEFAULT 0,
    total_morts    INTEGER DEFAULT 0
  );

DROP TABLE IF EXISTS joueur_exclu CASCADE;
CREATE TABLE joueur_exclu
  (
    nom_joueur_exclu VARCHAR(100),
    type_exclusion   INT
  );

DROP TABLE IF EXISTS classement_meilleur_joueur CASCADE;
CREATE TABLE classement_meilleur_joueur
  (
    id_joueur      INT,
    nom_joueur     VARCHAR(100) NOT NULL,
    nombre_victime INT
  );

DROP TABLE IF EXISTS classement_personnage_fictif CASCADE;
CREATE TABLE classement_personnage_fictif
  (
    nom_personnage     VARCHAR(100) NOT NULL,
    total_utilisations VARCHAR(100)
  );

------------------------------------------------------------------------------------------------

/* Pour organiser le classement en fonction de la position */
CREATE INDEX ordre_position ON classement (position);