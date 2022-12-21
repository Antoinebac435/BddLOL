------------------------------------------------------------------------------------------------
---- NOM : ajout_equipe                                                                     ----
---- DESCRIPTION : Ce trigger va se déclancher lorsque l'on va vouloir ajouter une équipe.  ----
---- VERIFICATION : Il va vérifier que l'équipe est coréenne (réglement du jeu).            ----
------------------------------------------------------------------------------------------------


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
---- NOM : ajout_joueur                                                                     ----
---- DESCRIPTION : Ce trigger va se déclancher lorsque l'on va vouloir ajouter un joueur .  ----
----                                                                                        ----
---- VERIFICATION : Un joueur doit                                                          ----
----                  -- Posséder un pseudo valide ( non utilisé par les autres joueurs )   ----
----                  -- Posséder un rôle qui existe dans la table rôle                     ----
----                  -- Appartenir à une équipe (qui doit être existante)                  ----
------------------------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------------------------
---- NOM : ajout_match                                                                        ----
---- DESCRIPTION : Ce trigger va se déclancher lorsque l'on va ajouter un match.              ----
----                                                                                          ----
---- VERIFICATION :                                                                           ----
----            -- Les scores ne doivent pas être égaux (il n'existe pas de match nul)        ----
----            -- Les équipes qui jouent doivent être des équipes existantes                 ----
----           -- Les équipes qui jouent ne doivent pas déjà avoir joué l'une contre l'autre  ----
----            -- Les équipes ne peuvent pas jouer contre elles-mêmes                        ----
--------------------------------------------------------------------------------------------------

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

  IF (new.id_equipe_1 = new.id_equipe_2) THEN
    RAISE EXCEPTION 'Une équipe ne peut pas jouer contre elle-même';
  END IF;

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

--------------------------------------------------------------------------------------------------------
---- NOM : remplir_statistiques_joueurs                                                             ----
---- DESCRIPTION : Ce trigger va ajouter les infos d'un joueur dans la table statistiques_joueurs   ----
---- dès lors qu'il est ajouté dans la table joueur                                                 ----
--------------------------------------------------------------------------------------------------------

CREATE or REPLACE function remplir_statistiques_joueurs()
RETURNS trigger
as $$

BEGIN

    INSERT INTO statistiques_joueurs values (new.id_joueur);

    RETURN new;

END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER remplir_statistiques_joueurs
AFTER INSERT ON joueur
FOR EACH ROW
EXECUTE PROCEDURE remplir_statistiques_joueurs();

--------------------------------------------------------------------------------------------------------
---- NOM : set_statistiques_joueurs                                                                 ----
---- DESCRIPTION : Ce trigger va modifier les statistiques du joueur à chaque fois que              ----
---- celui-ci joue. C'est à dire, lorsqu'il va faire un match, et marquer (faire des victimes),     ----
---- son nombre total de victimes va être modifié. De même pour son nombre total de morts.          ----
--------------------------------------------------------------------------------------------------------

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
execute procedure set_statistiques_joueurs();

--------------------------------------------------------------------------------------------------------
---- NOM : set_statistiques_match                                                                   ----
---- DESCRIPTION : Ce trigger va simuler les statistiques d'un joueur, ses actions lorsqu'un        ----
---- match est joué :                                                                               ----
---- C'est à dire son nombre de victimes, le nombre de fois où il est mort...                       ----
--------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION set_statistiques_match() 
RETURNS trigger 
as $$ 
DECLARE 
    mon_curseur_stats_match cursor for select joueur.id_joueur, match.id_match, joueur.id_equipe from joueur 
    inner join match on match.id_equipe_1 = joueur.id_equipe or match.id_equipe_2 = joueur.id_equipe
    where id_match = new.id_match  order by joueur.id_equipe asc ; 

    v_id_match  match.id_match%TYPE;     
    v_id_joueur joueur.id_joueur%TYPE; 
    v_id_equipe joueur.id_equipe%TYPE ; 
    v_id_personnage personnage_fictif.id_personnage%TYPE;

BEGIN

  OPEN mon_curseur_stats_match ; 

  LOOP 
  FETCH mon_curseur_stats_match INTO v_id_joueur, v_id_match, v_id_equipe ;
  EXIT WHEN NOT FOUND; 

  -- Récupère aléatoirement un personnage parmi ceux ayant le même rôle que celui du joueur
  SELECT INTO v_id_personnage id_personnage FROM personnage_fictif
  WHERE id_role in (
    SELECT id_role FROM joueur WHERE id_joueur = v_id_joueur
  ) ORDER BY random() limit 1;
  -- Simule des statistiques (valeurs entre 0 et 45)
  INSERT INTO statistiques_match values (v_id_match,v_id_equipe, v_id_joueur, v_id_personnage, floor(random() * 45 + 0),  floor(random() * 45 + 0)) ; 

  END LOOP ;

  CLOSE mon_curseur_stats_match ; 

  RETURN new; 

END; 
$$
LANGUAGE plpgsql; 

CREATE TRIGGER set_statistiques_match
AFTER INSERT ON match
FOR EACH ROW 
execute procedure set_statistiques_match();

--------------------------------------------------------------------------------------------------------
---- NOM : remplir_classement                                                                       ----
---- DESCRIPTION : Ce trigger va remplir le classement dès lors qu'une équipe est                   ----
---- ajoutée au tournoi                                                                             ----
--------------------------------------------------------------------------------------------------------

CREATE or REPLACE function remplir_classement()
RETURNS trigger
as $$

DECLARE

    v_position INTEGER;

BEGIN

    SELECT INTO v_position count(position) + 1 FROM classement;
    INSERT INTO classement VALUES (v_position, new.id_equipe);

    RETURN new;

END;
$$ 
LANGUAGE plpgsql;

CREATE TRIGGER remplir_classement
AFTER INSERT ON equipe
FOR EACH ROW
EXECUTE PROCEDURE remplir_classement();

--------------------------------------------------------------------------------------------------------
---- NOM : update_classement                                                                        ----
---- DESCRIPTION : Ce trigger va modifier le classement à chaque fois qu'un match est joué.         ----
----                                                                                                ----
---- DIFFICULTE : Les enchainements de victoires doivent être pris en compte.                       ----
---- On doit faire un curseur/loop à la fin des updates, pour réactualiser le classement.           ----
--------------------------------------------------------------------------------------------------------

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

  CLUSTER classement USING ordre_position;
  -- Victoire équipe 1
  if new.score_equipe_1 > new.score_equipe_2 THEN 
    UPDATE classement SET nombre_victoires = nombre_victoires+ 1, 
    nombre_defaites = nombre_defaites, 
    matchs_joues = matchs_joues + 1, 
    points = points + 3 , 
    enchainement_victoires = enchainement_victoires + 1
    WHERE id_equipe = new.id_equipe_1 ;

    UPDATE classement SET nombre_victoires = nombre_victoires, 
    nombre_defaites = nombre_defaites +1, 
    matchs_joues = matchs_joues + 1, 
    points = points + 1, 
    enchainement_victoires = 0
    WHERE id_equipe = new.id_equipe_2 ;



  -- Victoire équipe 2
  elsif new.score_equipe_1 < new.score_equipe_2 THEN 
    UPDATE classement SET nombre_victoires = nombre_victoires+ 1, 
    nombre_defaites = nombre_defaites, 
    matchs_joues = matchs_joues + 1, 
    points = points + 3, 
    enchainement_victoires = enchainement_victoires + 1
    WHERE id_equipe = new.id_equipe_2 ;

    UPDATE classement SET nombre_victoires = nombre_victoires, 
    nombre_defaites = nombre_defaites +1, 
    matchs_joues = matchs_joues + 1, 
    points = points + 1, 
     enchainement_victoires = 0
    WHERE id_equipe = new.id_equipe_1 ;

  end if ; 



  -- Mis à jour du classement après les updates
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
execute procedure update_classement();

-------------------------------------------------------------------------------------------------------------------------
---- NOM : penalite_classement                                                                                       ----
---- DESCRIPTION : Ce trigger va modifier le classement à chaque fois qu'un joueur a commit une faute                ----
----    -	Retard = -1 points à l’équipe.                                                                             ----
----    -	Absence = -2 points à l’équipe.                                                                            ----
----    -	Tricherie = -3 points à l’équipe.                                                                          ----
----    -	Insultes = -5 points à l’équipe si elle comporte un total de 5 joueurs ou plus, ayant réalisé cette faute. ----
----    -	Dopage = Exclusion du joueur.                                                                              ----
----                                                                                                                 ----
---- DIFFICULTE :                                                                                                    ----
---- Chaque type d'insulte à dû être analysé car les sanctions n'étaient pas les mêmes.                              ----
---- Après chaque update, le classement doit être re-analysé et modifié (puisqu'on a modifié les points)             ----
-------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION penalite_classement() 
RETURNS trigger 
as $$ 
DECLARE 
curseur_update cursor for select * from classement order by points desc; 
  i int := 1 ; 

  v_position INT ; 
  v_id_equipe INT ; 
  v_nombre_victoires INT ; 
  v_nombre_defaites INT ; 
  v_matchs_joues INT ; 
  v_points INT ;

  nom_joueur_exclu VARCHAR ; 
  nombre_insulte INT ; 
  nom_penalite VARCHAR ; 
  nombre_point_actuel INT ; 
BEGIN 

  CLUSTER classement USING ordre_position;

  nom_penalite = (select type_penalite from penalite where id_penalite =  new.id_penalite ) ; 
  nombre_point_actuel  = (select points from classement where id_equipe  = new.id_equipe)  ; 

  if(nom_penalite = 'retard' or nom_penalite = 'insultes') THEN  
    if (nombre_point_actuel - 1) < 0 THEN 
      UPDATE classement SET points = 0
      WHERE id_equipe = new.id_equipe ;
    else 
    UPDATE classement SET points = points - 1 
      WHERE id_equipe = new.id_equipe ;
    end if ; 

  elsif(nom_penalite = 'absence' ) THEN 
    if (nombre_point_actuel - 2) < 0 THEN 
        UPDATE classement SET points = 0
        WHERE id_equipe = new.id_equipe ;
      else 
      UPDATE classement SET points = points - 2 
        WHERE id_equipe = new.id_equipe ;
      end if ; 

   
  elsif(nom_penalite = 'tricherie' ) THEN 
    if (nombre_point_actuel - 3) < 0 THEN 
          UPDATE classement SET points = 0
          WHERE id_equipe = new.id_equipe ;
        else 
        UPDATE classement SET points = points - 3 
          WHERE id_equipe = new.id_equipe ;
        end if ; 

  elsif(nom_penalite = 'dopage') THEN 
    nom_joueur_exclu = (select nom_joueur from joueur where id_joueur = new.id_joueur) ;
    INSERT INTO joueur_exclu values (nom_joueur_exclu, new.id_penalite) ; 

    DELETE FROM avoir_penalite where id_joueur = new.id_joueur ; 
    DELETE FROM statistiques_match where id_joueur = new.id_joueur ; 
    DELETE FROM statistiques_joueurs where id_joueur = new.id_joueur ; 
    DELETE FROM joueur where id_joueur = new.id_joueur ;


  end if ; 

  -- Mis à jour du classement 
  OPEN curseur_update ; 
    LOOP 
    FETCH curseur_update INTO v_position, v_id_equipe, v_nombre_victoires, v_nombre_defaites, v_matchs_joues, v_points ;
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

    CLOSE curseur_update; 

    RETURN new  ; 


END; 
$$
LANGUAGE plpgsql; 



CREATE TRIGGER penalite_classement
AFTER INSERT ON avoir_penalite 
FOR EACH ROW 
execute procedure penalite_classement();

--------------------------------------------------------------------------------------------------------
---- NOM : classement_meilleur_joueur                                                               ----
---- DESCRIPTION : Ce trigger va modifier le classement des meilleurs joueurs                       ----    
---- Le classement contient les 10 meilleurs joueurs.                                               ----
---- Les meilleurs joueurs sont ceux qui ont tué le plus de personnes.                              ----
----                                                                                                ----
---- DIFFICULTE :                                                                                   ----
---- Les statistiques des joueurs évoluent trop aléatoirement pour faire des updates.               ----    
---- Nous avons donc fait le choix de supprimer tous les tuples du classement à chaque              ----
---- modification -> pour par la suite, réinsérer les vrais meilleurs joueurs (avec modification)   ----
---- à l'aide d'un select avec un order by et une limite                                            ----
--------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION classement_meilleur_joueur() 
RETURNS trigger 
as $$ 
DECLARE 
  curseur_meilleur_joueur cursor for select id_joueur,  total_victimes from statistiques_joueurs order by total_victimes desc limit 10; 

  v_id_meilleur_joueur INT ; 
  v_total_victimes_meilleur_joueur INT ; 
  v_nom_meilleur_joueur VARCHAR ; 


BEGIN 

  DELETE FROM classement_meilleur_joueur ; 

  OPEN curseur_meilleur_joueur ; 
  LOOP 
  FETCH curseur_meilleur_joueur INTO v_id_meilleur_joueur, v_total_victimes_meilleur_joueur ;
  EXIT WHEN NOT FOUND;

  v_nom_meilleur_joueur = (select nom_joueur from joueur where id_joueur =v_id_meilleur_joueur ) ; 
  INSERT INTO classement_meilleur_joueur VALUES (v_id_meilleur_joueur, v_nom_meilleur_joueur, v_total_victimes_meilleur_joueur ) ; 

  end loop ; 
  close curseur_meilleur_joueur ; 
  return new; 



END; 
$$
LANGUAGE plpgsql; 

CREATE TRIGGER classement_meilleur_joueur
AFTER INSERT OR UPDATE ON statistiques_joueurs 
FOR EACH ROW 
execute procedure classement_meilleur_joueur();

--------------------------------------------------------------------------------------------------------
---- NOM : ajout_remplaçant                                                                         ----
---- DESCRIPTION : Cette fonction permet de rajouter un remplaçant ( dans le cas où un joueur       ----
---- a été exclu de la compétition).                                                                ----
----                                                                                                ----
---- VERIFICATION :                                                                                 ----
----    -- Une équipe ne doit pas être pleine (5 joueurs max)                                       ----
----                                                                                                ----
---- DIFFICULTE :                                                                                   ----
---- Nous devons chercher l'identifiant disponible dans l'équipe pour l'attribuer au                ----
---- joueur remplaçant.                                                                             ----
---- Pour cela, on va parcourir chaque identifiant des joueurs de l'équipe                          ----
---- Et insérer le joueur remplaçant, et lui attribuer un id,  dès que l'id est disponible          ----
--------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION ajout_remplaçant(nom_remplacant varchar, pseudo_remplacant VARCHAR, date_naissance_remplacant DATE,  
id_role_remplacant INT, equipe_du_remplacant INT) 
RETURNS VOID
as $$ 
DECLARE 
  nombre_joueur_equipe INT ;  
  indice_boucle INT; 
  joueur_ajoute boolean := False ; 
  valeur INT ; 

  indice_depart INT := (select id_joueur from joueur where id_equipe = equipe_du_remplacant order by id_joueur asc limit 1) ; 


BEGIN 

  nombre_joueur_equipe = (select count(*) from joueur where id_equipe = equipe_du_remplacant) ; 

  if nombre_joueur_equipe = 5 THEN 
    raise exception 'L equipe est déjà pleine, vous ne pouvez pas ajouter de joueurs' ; 
  else 
    indice_boucle = indice_depart ; 
    loop 
    EXIT when indice_boucle > indice_depart +5 ; 

    if not exists (select id_joueur from joueur where  id_joueur = indice_boucle) THEN 
      INSERT INTO joueur values ( indice_boucle, pseudo_remplacant,nom_remplacant, date_naissance_remplacant, id_role_remplacant , equipe_du_remplacant) ; 
      joueur_ajoute = True ;
    else 
      indice_boucle = indice_boucle + 1 ; 
    end if ; 
    end loop ; 
  end if ;


  -- Le joueur manquant se trouvait au debut 
  if joueur_ajoute = False THEN 
    valeur = (select id_joueur from joueur where id_equipe = equipe_du_remplacant order by id_joueur asc limit 1) -1  ; 
    INSERT INTO joueur values ( valeur, pseudo_remplacant,nom_remplacant, date_naissance_remplacant, id_role_remplacant , equipe_du_remplacant) ; 

  end if ; 



END; 
$$
LANGUAGE plpgsql; 



-----------------------------------------

CREATE OR REPLACE FUNCTION classement_perso_fictif() 
RETURNS trigger
as $$ 
DECLARE 

  mon_curseur_personnage_fictif cursor for select id_personnage , count(id_personnage) as nombre from statistiques_match 
  group by id_personnage order by count(id_personnage) desc limit 20 ;

  
  v_id_perso_fictif INT ; 
  v_nom_perso_fictif VARCHAR ; 
  v_nombre_perso_fictif INT ; 
  


BEGIN 

  DELETE FROM classement_personnage_fictif ; 

  OPEN mon_curseur_personnage_fictif ; 
  LOOP 
  FETCH mon_curseur_personnage_fictif INTO v_id_perso_fictif, v_nombre_perso_fictif ;
  EXIT WHEN NOT FOUND;

  v_nom_perso_fictif = (select nom_personnage from personnage_fictif where id_personnage = v_id_perso_fictif) ; 
  
  INSERT INTO classement_personnage_fictif VALUES (v_nom_perso_fictif, 'a  été  utilisé  ' || v_nombre_perso_fictif || '  fois  dans  cette competition') ; 

  end loop ; 
  close mon_curseur_personnage_fictif ; 
  return new; 



END; 
$$
LANGUAGE plpgsql; 

CREATE TRIGGER classement_perso_fictif
AFTER INSERT ON statistiques_match 
FOR EACH ROW 
execute procedure classement_perso_fictif(); 