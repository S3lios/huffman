
-- DÃ©finition de structures de donnees associatives sous forme d'une liste
-- chaine associative (SDA).
generic
	type T_Cle is private;
	type T_Donnee is private;

package SDA is
   
   Cle_Absente_Exception  : Exception;	-- une cle est absente d'un SDA

	type T_SDA is limited private;

   -- Initialiser une Sda.  La Sda ty est vide.
	procedure Initialiser(Sda: out T_SDA);


	-- Est-ce qu'une Sda est vide ?
	function Est_Vide (Sda : T_SDA) return Boolean;


	-- Obtenir le nombre d'elements d'une Sda. 
	function Taille (Sda : in T_SDA) return Integer;


	-- Enregistrer une DonnÃ©e associÃ©e Ã  une ClÃ© dans une Sda.
	-- Si la cle est deja  presente dans la Sda, sa donnee est changee.
	procedure Enregistrer (Sda : in out T_SDA ; Cle : in T_Cle ; Donnee : in T_Donnee);

	-- Supprimer la DonnÃ©e associÃ©e Ã  une ClÃ© dans une Sda.
	-- Exception : Cle_Absente_Exception si ClÃ© n'est pas utilisÃ©e dans la Sda
	procedure Supprimer (Sda : in out T_SDA ; Cle : in T_Cle);


	-- Savoir si une Cle est prÃ©sente dans une Sda.
	function Cle_Presente (Sda : in T_SDA ; Cle : in T_Cle) return Boolean;


	-- Obtenir la donnee associee a  une Cle dans la Sda.
	-- Exception : Cle_Absente_Exception si Clee n'est pas utilisÃ©e dans l'Sda
	function La_Donnee (Sda : in T_SDA ; Cle : in T_Cle) return T_Donnee;

   
   -- Retourne la cle de la première occurence d'une donnée
   -- Exception : Donnee_Absente_Exception
   function La_Cle (Sda : in T_SDA; Donnee : in T_Donnee) return T_Cle;
   
   
	-- Supprimer tous les Elements d'une Sda.
	procedure Vider (Sda : in out T_SDA);


	-- Appliquer un traitement (Traiter) pour chaque couple d'une Sda.
	generic
      with procedure Traiter (Cle : in out T_Cle; Donnee: in out T_Donnee);
   procedure Pour_Chaque (Sda : in out T_SDA);

private

   type T_Cellule;
   type T_SDA is access T_Cellule;
   type T_Cellule is record
      Cle : T_Cle;
      Donnee : T_Donnee;
      Suivant : T_SDA;
   end record;
   
end SDA;
