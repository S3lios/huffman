--Definition des listes chainées
--L'indice 0 correspond au premier élement
generic
   type T_Element is private;
   with function Valeur(Element : in T_Element) return Integer;
   with function Est_Egal_Element(Element1 : in T_Element; Element2 : in T_Element) return Boolean;
package LISTE_C is
   type T_Liste is private;

   Indice_Hors_Champ_Exception : Exception;
   Liste_Vide_Exception : Exception;
   Element_Non_Present_Exception : Exception;


   --Vider une liste
   procedure Vider(Liste : in out T_Liste);

   --Vérifie si la liste est vide
   function Est_Vide(Liste : in T_Liste) return Boolean;

   --Initialiser une liste
   procedure Initialiser(Liste : in out T_Liste);

   --Ajouter un élement à la fin de la liste
   procedure Ajouter_Fin(Liste : in out T_Liste; Element : in T_Element);

   --Ajouter un élement au début  de la liste
   procedure Ajouter_Debut(Liste : in out T_Liste; Element : in T_Element);

   --Ajouter un element à l'indice donné dans la liste
   -- Exception : Indice_Hors_Champ_Exception si l'indice est plus grand que la taille de la liste ou n�gatif
   procedure Ajouter_Indice(Liste : in out T_Liste; Element : in T_Element; Indice : in Integer);

   --Donne le nombre d'élement de la liste
   function Taille(Liste : In T_Liste) return Integer;

   --Renvoie laliste sans le premier �lement.
   -- Exception : Liste_Vide_Exception si la liste est vide.
   function Sous_Liste(Liste : In T_Liste) return T_Liste;


   --Supprime et renvoie un élement à partir de son indice de la liste.
   --Exception : Indice_Hors_Champ_Exception si l'indice est plus grand que la taille de la liste ou n�gatif
   function Extraire_Indice(Liste: in out T_Liste; Indice : in Integer) return T_Element;

   --Supprime l'element et renvoie son indice dans la liste (première occurence seulement)
   --Exception : Element_Non_Present_Exception si l'element n'est pas dans la liste
   function Extraire_Element(Liste : in out T_Liste; Element : in T_Element) return Integer;

   --Supprime et renvoie le premier Element de la liste
   --Exception : Liste_Vide_exception si la liste est vide
   function Extraire_Debut(Liste : in out T_Liste) return T_Element;

   --Supprime et renvoie le dernier Element de la liste
   --Exception : Liste_Vide_exception si la liste est vide
   function Extraire_Fin(Liste : in out T_Liste) return T_Element;

   --Supprime un element à partir de son indice de la liste.
   --Exception : Indice_Hors_Champ_Exception si l'indice est plus grand que la taille de la liste ou n�gatif
   procedure Retirer_Indice(Liste: in out T_Liste; Indice : in Integer);

   --Supprime l'element dans la liste (première occurence seulement)
   --Exception : Element_Non_Present_Exception si l'element n'est pas dans la liste
   procedure Retirer_Element(Liste : in out T_Liste; Element : in T_Element);

   --Supprime le premier Element de la liste
   --Exception : Liste_Vide_exception si la liste est vide
   procedure Retirer_Debut(Liste : in out T_Liste);

   --Supprime le dernier Element de la liste
   --Exception : Liste_Vide_exception si la liste est vide
   procedure Retirer_Fin(Liste : in out T_Liste);

   --Renvoie le premier indice d'une valeur présente dans la liste.
   --Exception : Element_Non_Present_Exception si l'�lement n'est pas pr�sent
   function Indice_Element(Liste : in T_Liste; Element : in T_Element) return Integer;

   --Renvoie la donnéee correspondant à l'indice
   --Exception : Indice_Hors_Champ_Exception si l'indice est plus grands que la taille de la liste ou n�gatif
   function Element_Indice(Liste : in T_Liste; Indice : in Integer) return T_Element;

   --Renvoie le premier élement de la liste
   --Exception : Liste_Vide_exception si la liste est vide
   function Premier_Element(Liste : in T_Liste) return T_Element;

   --Renvoie le dernier Element de la liste
   --Exception : Liste_Vide_exception si la liste est vide
   function Dernier_Element(Liste : in T_Liste) return T_Element;

   --Renvoie l'Element le plus petit de la liste
   function Min(Liste: in T_Liste) return T_Element;
   --Retire et renvoie le minimum de la liste
   function Retirer_Min(Liste: in out T_Liste) return T_Element;
   --Renvoie l'Element le plus grand de la liste
   function Max(Liste: in T_Liste) return T_Element;
   --Retire et renvoie le maximum de la liste
   function Retirer_Max(Liste: in out T_Liste) return T_Element;

   --Ajoute la liste 1 a la fin de la liste 2
   procedure Append(Liste1 : in T_Liste; Liste2 : in out T_Liste);
   --Vérifie si 2 listes sont égales
   function Est_Egal(Liste1 : in T_Liste; Liste2 : in T_Liste) return Boolean;

   -- Appliquer un traitement (Traiter) pour chaque Element d'une liste.
    generic
      with procedure Traiter (Element : in out T_Element);
    procedure Pour_Chaque (Liste : in out T_Liste);


private
   type T_Cellule;
   type T_Liste is access T_Cellule;
   type T_Cellule is record
      Element : T_Element;
      Suivant: T_Liste;
   end record;

end LISTE_C;
