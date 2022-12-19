
CREATE OR REPLACE FUNCTION ajout_equipe() 
RETURNS trigger 
as $$ 
BEGIN 
  if (new.pays_equipe) <> 'Coree du Sud' THEN 
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
-- - Possède un rôle qui existe dans la table rôle 
-- - Appartient à une équipe (qui doit être existante) 
-- Est ce que je rajoute la condition : que l'équipe auxquel appartient le joueur n'est pas déjà au max des 5 joueurs ? 



CREATE OR REPLACE FUNCTION ajout_joueur() 
RETURNS trigger 
as $$ 
DECLARE 
    mon_curseur_pseudo_joueur cursor for select pseudo_joueur from joueur ; 
    v_pseudo  joueur.pseudo_joueur%TYPE; 

BEGIN 

  open mon_curseur_pseudo_joueur;  
   
  LOOP 
  FETCH mon_curseur_pseudo_joueur INTO v_pseudo ;
  EXIT WHEN NOT FOUND; 

  if new.pseudo_joueur LIKE v_pseudo THEN 
    raise exception 'Le joueur ne peut avoir le même pseudo qu un joueur déjà existant' ;
  END IF ; 
  END LOOP ; 
  close mon_curseur_pseudo_joueur ; 

  -- Pour éviter de faire des curseurs 
  if not exists (select * from equipe where id_equipe = new.id_equipe) THEN 
    raise exception 'Le joueur nappartient pas à une equipe existante' ;

  elsif not exists (select * from role where id_role = new.id_role) THEN 
    raise exception 'Le joueur ne possede pas un role deja existant' ;

  else 
    return new ; 

  end if ; 

END; 
$$
LANGUAGE plpgsql; 



CREATE TRIGGER ajout_joueur
BEFORE INSERT ON joueur
FOR EACH ROW 
execute procedure ajout_joueur() ; 



------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------





-- Trigger qui vérifie que :
-- Le score ne soit pas nul (il n'existe pas de match nul) 
-- L'équipe qui joue soit bien une équipe existante
-- Que les équipes n'ont pas déjà joué le même match 
-- Que la date du match soit bien comprise entre le ... et ... (règlement imposé) (pas encore fait)

CREATE OR REPLACE FUNCTION ajout_match() 
RETURNS trigger 
as $$ 
DECLARE 
  mon_curseur_equipe cursor for select id_equipe from equipe ;
  mon_curseur_match cursor for select id_equipe_1, id_equipe_2 from match ;

  id_equipe_match_deja_joue_1 INT ; 
  id_equipe_match_deja_joue_2 INT ; 

  equipe_existe1 boolean := FALSE; 
  equipe_existe2 boolean := FALSE; 
  indice_equipe INT ; 
  
BEGIN 
  open mon_curseur_equipe;
  open mon_curseur_match;


  LOOP 
  FETCH mon_curseur_equipe INTO indice_equipe ;
  EXIT WHEN NOT FOUND; 

  -- Test si l'équipe existe
  if new.id_equipe_1 = indice_equipe  THEN 
    equipe_existe1 = TRUE ; 
  END IF; 

  if new.id_equipe_2 = indice_equipe  THEN 
    equipe_existe2 = TRUE ; 
  END IF; 
  END LOOP ;
  CLOSE mon_curseur_equipe;


  LOOP 
  FETCH mon_curseur_match INTO id_equipe_match_deja_joue_1, id_equipe_match_deja_joue_2 ;
  EXIT WHEN NOT FOUND; 

  -- Test si le match a déjà été joué
  IF((new.id_equipe_1 = id_equipe_match_deja_joue_1) AND (new.id_equipe_2 = id_equipe_match_deja_joue_2)) 
  OR ((new.id_equipe_1 = id_equipe_match_deja_joue_2) AND (new.id_equipe_2 = id_equipe_match_deja_joue_1)) THEN 
      raise exception 'Le match a deja ete joue' ;
  END IF ;  
  END LOOP ;
  CLOSE mon_curseur_match;


  if (new.score_equipe_1 = new.score_equipe_2) THEN 
    raise exception 'Il ne peut pas y avoir de match nul' ; 
  END IF ; 

  if (equipe_existe1 = FALSE) OR (equipe_existe2 = FALSE)  THEN 
    raise exception 'Une des equipes nexiste pas' ; 
  END IF ;

  RETURN new ;


END; 
$$
LANGUAGE plpgsql; 


CREATE TRIGGER ajout_match
BEFORE INSERT ON match
FOR EACH ROW 
execute procedure ajout_match() ; 





------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------




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

  if not exists (select * from statistiques_joueurs where id_joueur = new.id_joueur) THEN 
    INSERT INTO statistiques_joueurs VALUES (new.id_joueur, 0,0) ; 
  end if ; 

  UPDATE statistiques_joueurs SET total_victimes = total_victimes+ new.nombre_kills, total_morts = total_morts+ new.nombre_morts
  WHERE id_joueur = new.id_joueur; 

  RETURN new; 

END; 
$$
LANGUAGE plpgsql; 



CREATE TRIGGER set_statistiques_joueurs
AFTER INSERT ON statistiques_match
FOR EACH ROW 
execute procedure set_statistiques_joueurs()
;





------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------






-- Trigger qui va se déclencher quand on ajoute un match. 
-- Il va simuler avec un random : le nombre de victimes qu'un joueur peut faire, le nb de morts qu'un joueur peut avoir 
-- Et le mettre dans la table statistiques matchs. 

-- Il va falloir la rentrer avant set_statistiques_joueurs() MAIS AUSSI avant toutes les insertions 

CREATE OR REPLACE FUNCTION set_statistiques_match() 
RETURNS trigger 
as $$ 
DECLARE 
    mon_curseur_stats_match cursor for select joueur.id_joueur, match.id_match, joueur.id_equipe from joueur 
    inner join match on match.id_equipe_1 = joueur.id_equipe or match.id_equipe_2 = joueur.id_equipe
    where id_match = new.id_match  order by joueur.id_equipe asc ; 

    
    v_id_joueur joueur.id_joueur%TYPE; 
    v_id_equipe joueur.id_equipe%TYPE ; 
    v_id_match  match.id_match%TYPE; 

BEGIN

  OPEN mon_curseur_stats_match ; 

  LOOP 
  FETCH mon_curseur_stats_match INTO v_id_joueur, v_id_match, v_id_equipe ;
  EXIT WHEN NOT FOUND; 

  INSERT INTO statistiques_match values (v_id_equipe, v_id_joueur,v_id_match,  floor(random() * 45 + 0),  floor(random() * 45 + 0)) ; 

  END LOOP ;

  CLOSE mon_curseur_stats_match ; 

  RETURN new; 

END; 
$$
LANGUAGE plpgsql; 

CREATE TRIGGER set_statistiques_match
AFTER INSERT ON match
FOR EACH ROW 
execute procedure set_statistiques_match()
;



------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION update_classement() 
RETURNS trigger 
as $$ 
DECLARE 

  mon_curseur_classement cursor for select * from classement order by points desc; 
  i int := 1 ; 


  v_position INT ; 
  v_id_equipe INT ; 
  v_nombre_victoires INT ; 
  v_nombre_defaites INT ; 
  v_matchs_joues INT ; 
  v_points INT ;



BEGIN 
  if new.score_equipe_1 > new.score_equipe_2 THEN 
    -- Victoire equipe 1
    UPDATE classement SET nombre_victoires = nombre_victoires+ 1, 
    nombre_defaites = nombre_defaites, 
    matchs_joues = matchs_joues + 1, 
    points = points + 3 
    WHERE id_equipe = new.id_equipe_1 ;

    UPDATE classement SET nombre_victoires = nombre_victoires, 
    nombre_defaites = nombre_defaites +1, 
    matchs_joues = matchs_joues + 1, 
    points = points + 1 
    WHERE id_equipe = new.id_equipe_2 ;

    UPDATE classement SET enchainement_victoires = enchainement_victoires + 1
    WHERE id_equipe = new.id_equipe_1;
    
    UPDATE classement SET enchainement_victoires = 0
    WHERE id_equipe = new.id_equipe_2;

  elsif new.score_equipe_1 < new.score_equipe_2 THEN 
    -- Victoire equipe 2
    UPDATE classement SET nombre_victoires = nombre_victoires+ 1, 
    nombre_defaites = nombre_defaites, 
    matchs_joues = matchs_joues + 1, 
    points = points + 3 
    WHERE id_equipe = new.id_equipe_2 ;

    UPDATE classement SET nombre_victoires = nombre_victoires, 
    nombre_defaites = nombre_defaites +1, 
    matchs_joues = matchs_joues + 1, 
    points = points + 1 
    WHERE id_equipe = new.id_equipe_1 ;

    UPDATE classement SET enchainement_victoires = enchainement_victoires + 1
    WHERE id_equipe = new.id_equipe_2;
    
    UPDATE classement SET enchainement_victoires = 0
    WHERE id_equipe = new.id_equipe_1;

  end if ; 


  OPEN mon_curseur_classement ; 
  LOOP 
  FETCH mon_curseur_classement INTO v_position, v_id_equipe, v_nombre_victoires, v_nombre_defaites, v_matchs_joues, v_points ;
  EXIT WHEN NOT FOUND;

  UPDATE classement SET position = i, 
  id_equipe = v_id_equipe, 
  nombre_victoires = v_nombre_victoires, 
  nombre_defaites = v_nombre_defaites, 
  matchs_joues = v_matchs_joues, 
  points = v_points 
  WHERE id_equipe = v_id_equipe ;
  
  i = i + 1 ; 
  END LOOP ;

  CLOSE mon_curseur_classement; 

  RETURN new ; 


END; 
$$
LANGUAGE plpgsql; 

  


CREATE TRIGGER update_classement
AFTER INSERT ON match
FOR EACH ROW 
execute procedure update_classement()
;