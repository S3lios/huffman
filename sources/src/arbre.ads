--Module du type T_Arbre
--Un arbre est représenté par une racine, une valeur, et deux arbres fils (gauche et droite)
--Pour accéder à un sous arbre, on utilise un "chemin" (equivalent d'indice pour les listes) correspondant à un entier strictement positif
--Le chemin se suit comme ceci :
--    Si le chemin vaut 1, on est au bon endroit
--    Sinon si le chemin est pair, on va a gauche et on divise le chemin par deux
--    Sinon (si c'est impair), on va a droite et on divise le chemin par deux (on garde la partie entière)
generic
   type T_Element is private;
   with procedure Affichage_Element(Element : in T_Element);
    with function Est_Egal_Element(Element1 : in T_Element; Element2 : in T_Element) return Boolean;

package ARBRE is
   type T_Arbre is private;

   Chemin_Hors_Arbre_Exception : Exception;
   Arbre_Vide_Exception : Exception;

   -- Initialise un arbre binaire
   procedure Initialiser(Arbre : out T_Arbre);

   -- Initialise un arbre binaire
   procedure Initialiser_Valeur(Arbre : out T_Arbre; Valeur : in Integer; Element : in T_Element);

   --Verifie si un arbre est nul
   function Est_Vide(Arbre : in T_Arbre) return Boolean;

   --Vide l'arbre
   procedure Vider(Arbre : in out T_Arbre);

   --VÃ©rifie si un arbre n'est qu'une feuille
   function Est_Feuille(Arbre : in T_Arbre) return Boolean;

   --V�rifie si un chemin est une feuille
   --Exception : Chemin_Hors_Arbre_Exception si le chemin fait sortir de l'arbre
   function Est_Feuille_Chemin(Arbre : In T_arbre; Chemin : Integer) return Boolean;

   --Fusionne deux arbres
   procedure Fusionner(Arbre1 : in out T_Arbre; Arbre2 : in T_Arbre; Element : T_Element);

   --Renvoie la valeur de l'arbre
   --Exception : Arbre_Vide_Exception si l'arbre est vide
   function Valeur(Arbre : in T_Arbre) return Integer;

   --Renvoie le sous arbre en suivant le chemin
   --Exception : Chemin_Hors_Arbre_Exception si le chemin fait sortir de l'arbre
   procedure Sous_Arbre(Arbre : in T_Arbre; Chemin : in Integer; Arbre_Sortie : out T_Arbre);

   --Ajoute un Element en suivant un chemin
   --Exception : Chemin_Hors_Arbre_Exception si le chemin fait sortir de l'arbre
   procedure Ajouter(Arbre : in out T_Arbre;Valeur : in Integer; Element : in T_Element; Chemin : in Integer);

   --Supprime un sous arbre Ã  partir du chemin
   --Exception : Chemin_Hors_Arbre_Exception si le chemin fait sortir de l'arbre
   procedure Supprimer(Arbre : in out T_Arbre; Chemin : in Integer);

   --Affiche l'arbre
   procedure Afficher(Arbre : in T_Arbre);

    --Vérifie si deux arbres sont égaux
   function Est_Egal(Arbre1 : in T_Arbre; Arbre2 : in T_Arbre) return Boolean;

   --Donne l'�l�ment de la racine
   --Exception : Arbre_Vide_Exception si l'arbre est vide
   function Element(Arbre : in T_Arbre) return T_Element;

   --Donne l'�lement d'un chemin
   --Exception : Chemin_Hors_Arbre_exception
   function Element_Chemin(Arbre : in T_Arbre; Chemin : Integer) return T_Element;

    -- Appliquer un traitement (Traiter) pour chaque Element d'un arbre.
    generic
        with procedure Traiter (Valeur: in out Integer; Element : in out T_Element);
    procedure Pour_Chaque (Arbre : in out T_Arbre);

private
   type T_Cellule;
   type T_Arbre is access T_Cellule;
   type T_Cellule is record
      Element : T_Element;
      Valeur : Integer;
      Arbre_G : T_Arbre;
      Arbre_D : T_Arbre;
   end record;

end ARBRE;
