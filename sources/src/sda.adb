with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Unchecked_Deallocation;
package body SDA is

	procedure Free is
		new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_SDA);


	procedure Initialiser(Sda: out T_SDA) is
   begin
      Sda := null;
	end Initialiser;


	function Est_Vide (Sda : T_SDA) return Boolean is
	begin
		return (Sda = Null);
	end;


	function Taille (Sda : in T_SDA) return Integer is
   begin
      if Sda = Null then
         return 0;
      else
         return 1+Taille(Sda.Suivant);
      end if;

	end Taille;


	procedure Enregistrer (Sda : in out T_SDA ; Cle : in T_Cle ; Donnee : in T_Donnee) is
   begin
      if Sda = Null then
         Sda := new T_Cellule;
         Sda.all := (Cle, Donnee, Null);
      else
         if Sda.all.Cle = Cle then
            Sda.all.Donnee := Donnee;
         else
            Enregistrer (Sda.all.Suivant, Cle, Donnee);
         end if;
      end if;
	end Enregistrer;


	function Cle_Presente (Sda : in T_SDA ; Cle : in T_Cle) return Boolean is
	begin
      if Sda = Null then
         return False;
      else
         if Est_Egal_Cle(Sda.all.Cle,Cle) then
            return True;
         else
            return Cle_Presente(Sda.All.Suivant, Cle);
         end if;
      end if;
	end;


	function La_Donnee (Sda : in T_SDA ; Cle : in T_Cle) return T_Donnee is
   begin
      if Sda = Null then
         raise Cle_Absente_Exception;
      else
         if Est_Egal_Cle(Sda.all.Cle, Cle) then
            return Sda.all.Donnee;
         else
            return La_Donnee(Sda.all.Suivant, Cle);
         end if;
      end if;


	end La_Donnee;


   function La_Cle (Sda : in T_SDA ; Donnee : in T_Donnee) return T_Cle is
   begin
      if Sda = Null then
         raise Cle_Absente_Exception;
      else
         if Sda.all.Donnee = Donnee then
            return Sda.all.Cle;
         else
            return La_Cle(Sda.all.Suivant, Donnee);
         end if;
      end if;
   end La_CLe;
   
	procedure Supprimer (Sda : in out T_SDA ; Cle : in T_Cle) is
      Sda_Temp : T_SDA;
   begin
      if Sda = null then
         raise Cle_Absente_Exception;
      else
         if Sda.all.Cle = Cle then
            Sda_Temp := Sda;
            Sda := Sda.all.Suivant;
            Free(Sda_Temp);
         else
            Supprimer(Sda.all.Suivant, Cle);
         end if;
      end if;
	end Supprimer;


	procedure Vider (Sda : in out T_SDA) is
	begin
      if Sda = Null then
         Null;
      else
         Vider(Sda.all.Suivant);
         Free(Sda);
      end if;

	end Vider;


	procedure Pour_Chaque (Sda : in out T_SDA) is
	begin
         if Sda = null then
            null;
         else
            begin
                 Traiter(Sda.all.Cle, Sda.all.Donnee);
            exception
                when others => 
                	New_Line;
                	Put("Erreur de traitement");
                   
               
            end;
            Pour_Chaque(Sda.all.Suivant);
         end if;
   end Pour_Chaque;

end SDA;
