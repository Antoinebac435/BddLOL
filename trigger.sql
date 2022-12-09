Sae lol

------------------------------
-- Trigger de vérification 
-- --------------------------

-- Trigger qui vérifie que l'équipe insérée soit bien une équipe Coréenne
CREATE OR REPLACE FUNCTION ajout_equipe() 
RETURNS trigger 
as $$ 
BEGIN 
  if (new.pays_equipe) <> 'South Korea' THEN 
    raise exception 'Cette équipe n est pas coréenne : elle ne peut pas jouer' ; 
  END IF ; 

  RETURN new; 

END; 
$$
LANGUAGE plpgsql; 


CREATE TRIGGER ajout_equipe
BEFORE INSERT ON equipe
FOR EACH ROW 
execute procedure ajout_equipe() ; 



------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------


-- Trigger qui vérifie si le joueur ajouté : 
-- - Possède un pseudo valide ( non utilisé par les autres joueurs ) 
-- - Possède un rôle qui existe dans la table role 
-- - Appartient à une équipe (qui doit être existante) 

-- NE FONCTIONNE PAS !! 

-- Trigger qui vérifie que l'équipe insérée soit bien une équipe Coréenne
CREATE OR REPLACE FUNCTION ajout_joueur() 
RETURNS trigger 
as $$ 
DECLARE 
    mon_curseur cursor for select pseudo_joueur, id_role, id_equipe from joueur ; 
    v_pseudo  joueur.pseudo_joueur%TYPE; 
    v_id_role joueur.id_role%TYPE ; 
    v_id_equipe joueur.id_equipe%TYPE ; 

    role_existe INT ; -- 1 -> le role existe / 0 sinon
    equipe_existe INT ; -- 1 -> le role existe / 0 sinon

BEGIN 

  open mon_curseur;  
  role_existe = 0 ; 
  equipe_existe = 0 ;           
  
  LOOP 
  FETCH mon_curseur INTO v_pseudo, v_id_role, v_id_equipe ;
  EXIT WHEN NOT FOUND; 
  if new.pseudo_joueur LIKE v_pseudo THEN 
    raise notice 'Le joueur ne peut avoir le même pseudo qu un joueur déjà existant' ;
  END IF ; 
  
  IF new.id_role = v_id_role THEN 
    role_existe = 1 ; 
  END IF;
  
  IF new.id_equipe = v_id_equipe THEN 
    equipe_existe = 1 ;
  END IF; 
  END LOOP ; 

  IF (role_existe = 1) AND (equipe_existe = 1) THEN
    RETURN new ;
  ELSE
    raise notice 'Vous ne pouvez pas insérer ce tuple' ;
  END IF ; 

END; 
$$
LANGUAGE plpgsql; 




CREATE TRIGGER ajout_joueur
BEFORE INSERT ON joueur
FOR EACH ROW 
execute procedure ajout_joueur() ; 


INSERT INTO joueur values (55,'Faker','test','2004-01-31',1, 1 ) ;
DELETE FROM joueur where id_joueur = 55 ; 


------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------





-- Trigger qui vérifie que lorsqu'on ajoute un match : le score n'est pas nul 
-- On ne peut pas avoir de match nul
CREATE OR REPLACE FUNCTION ajout_match() 
RETURNS trigger 
as $$ 
BEGIN 
  if (new.score_equipe_1 = new.score_equipe_2) THEN 
    raise exception 'Il ne peut pas y avoir de match nul' ; 
  END IF ; 

  RETURN new; 

END; 
$$
LANGUAGE plpgsql; 


CREATE TRIGGER ajout_match
BEFORE INSERT ON match
FOR EACH ROW 
execute procedure ajout_match() ; 

INSERT INTO match VALUES (11,10,5,5,5,'2022-07-25',52) ; 

DELETE FROM MATCH where id_match = 11 ; 


------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

CREATE TABLE statistiques_joueurs 
(   id_joueur INTEGER,
    nombre_victimes_total INT, 
    nombre_morts_total INT

);



-- Trigger qui va remplir la table statistiques match à chaque fois que l'on va ajouté 
-- un tuple dans match. 
-- Pour cela on va le nombre de victimes réalisés et le nombre de morts ; seront inscrits aléatoirement 

CREATE OR REPLACE FUNCTION set_statistiques_joueurs() 
RETURNS trigger 
as $$ 
DECLARE 
  v_nombre_victimes INT ; 
  v_nombre_morts INT ; 
BEGIN 
  SELECT nombre_victimes_total, nombre_morts_total INTO v_nombre_victimes, v_nombre_morts 
  from statistiques_joueurs where id_joueur = new.id_joueur ; 

  IF v_nombre_victimes IS NULL AND v_nombre_victimes IS NULL THEN 
    INSERT INTO statistiques_joueurs VALUES (new.id_joueur,  new.nombre_kills, new.nombre_morts) ; 

  ELSIF v_nombre_victimes IS NULL AND v_nombre_victimes IS NOT NULL THEN 
    INSERT INTO statistiques_joueurs VALUES (new.id_joueur,  new.nombre_kills, v_nombre_morts + new.nombre_morts) ; 
  
  ELSIF v_nombre_victimes IS NOT NULL AND v_nombre_victimes IS  NULL THEN 
    INSERT INTO statistiques_joueurs VALUES (new.id_joueur,  v_nombre_victimes + new.nombre_kills , new.nombre_morts ) ; 
  ELSE 
    INSERT INTO statistiques_joueurs VALUES (new.id_joueur,  v_nombre_victimes + new.nombre_kills , v_nombre_morts + new.nombre_morts) ; 
  END IF ; 


  RETURN new; 

END; 
$$
LANGUAGE plpgsql; 



CREATE TRIGGER set_statistiques_joueurs
AFTER INSERT ON statistiques_match
FOR EACH ROW 
execute procedure set_statistiques_joueurs()
;



INSERT INTO statistiques_match (id_equipe, id_joueur, id_match, nombre_kills, nombre_morts)VALUES (1,5, 1, 10, 5 ); 
INSERT INTO statistiques_match (id_equipe, id_joueur, id_match, nombre_kills, nombre_morts)VALUES (1,4, 1, 15, 12 ); 
INSERT INTO statistiques_match (id_equipe, id_joueur, id_match, nombre_kills, nombre_morts)VALUES (1,4, 10, 20, 4 ); 



------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------





