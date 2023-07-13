with Ada.Unchecked_Deallocation;
with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Integer_Text_IO;    use Ada.Integer_Text_IO;


package body ARBRE is

   procedure Free is
     new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_Arbre);

   procedure Initialiser(Arbre: out T_Arbre) is
   begin
      Arbre := Null;
   end;

   procedure Initialiser_Valeur(Arbre : out T_Arbre; Valeur : in Integer; Element : in T_Element) is
   begin
      Arbre := new T_Cellule;
      Arbre.all.Element := Element;
      Arbre.all.Valeur := Valeur;
      Arbre.all.Arbre_G := Null;
      Arbre.all.Arbre_D := Null;
   end Initialiser_Valeur;

   function Est_Vide(Arbre : in T_Arbre) return Boolean is
   begin
      return Arbre = Null;
   end Est_Vide;

   procedure Vider(Arbre : in out T_Arbre) is
   begin
      if Arbre = Null then
         Null;
      else
         Vider(Arbre.all.Arbre_G);
         Vider(Arbre.all.Arbre_D);
         Free(Arbre);
      end if;
   end Vider;

   function Est_Feuille(Arbre : in T_Arbre) return Boolean is
   begin
      if Arbre = Null then
         return False;
      else
         return Arbre.all.Arbre_G = Null and Arbre.all.Arbre_D = Null;
      end if;
   end Est_Feuille;

   procedure Fusionner(Arbre1 : in out T_Arbre; Arbre2 : in T_Arbre; Element : T_Element) is
      Arbre_Temp : T_Arbre;
   begin
      Arbre_Temp := new T_Cellule;
      Arbre_Temp.all.Valeur := Arbre1.all.Valeur + Arbre2.all.Valeur;
      Arbre_Temp.all.Arbre_G := Arbre1;
      Arbre_Temp.all.Arbre_D := Arbre2;
      Arbre_Temp.all.Element := Element;
      Arbre1 := Arbre_Temp;
   end Fusionner;

   function Valeur(Arbre : in T_Arbre) return Integer is
   begin
      if Arbre = Null then
         raise Arbre_Vide_Exception;
      else
         return Arbre.all.Valeur;
      end if;
   end Valeur;

   procedure Sous_Arbre(Arbre : in T_Arbre; Chemin : in Integer; Arbre_Sortie : out T_Arbre) is
   begin
      if Chemin = 1 then
         Arbre_Sortie := Arbre;
      elsif Chemin <= 0 then
         raise Chemin_Hors_Arbre_Exception;
      else
         if Arbre = null then
            raise Chemin_Hors_Arbre_Exception;
         else

            if (Chemin mod 2) = 0 then
               Sous_Arbre(Arbre.all.Arbre_G, Chemin/2, Arbre_Sortie);
            else
               Sous_Arbre(Arbre.all.Arbre_D, Chemin/2, Arbre_Sortie);
            end if;
         end if;
      end if;
   end Sous_Arbre;

   procedure Ajouter(Arbre : in out T_Arbre; Valeur : in Integer; Element : T_Element; Chemin : in Integer) is
   begin
      if Chemin = 1 then
         Vider(Arbre);
         Arbre := new T_Cellule;
         Arbre.all.Element := Element;
         Arbre.all.Valeur := Valeur;
      elsif Chemin <= 0 then
         raise Chemin_Hors_Arbre_Exception;
      else
         if Arbre = null then
            raise Chemin_Hors_Arbre_Exception;
         else
            if Chemin mod 2 = 0 then
               Ajouter(Arbre.all.Arbre_G, Valeur, Element, Chemin/2);
            else
               Ajouter(Arbre.all.Arbre_D, Valeur, Element, Chemin/2);
            end if;
         end if;
      end if;
   end Ajouter;

   function Est_Feuille_Chemin(Arbre : In T_arbre; Chemin : Integer) return Boolean is
      S_Arbre : T_Arbre;
   begin
      Sous_Arbre(Arbre, Chemin, S_Arbre);
      return Est_Feuille(S_Arbre);
   end;

   function Element_Chemin(Arbre : in T_Arbre; Chemin : Integer) return T_Element is
      S_Arbre : T_Arbre;
   begin
      Sous_Arbre(Arbre, Chemin, S_Arbre);
      return Element(S_Arbre);
   end;



   procedure Supprimer(Arbre : in out T_Arbre; Chemin : in Integer) is
   begin
      if Chemin = 1 then
         Vider(Arbre);
      elsif Chemin <= 0 then
         raise Chemin_Hors_Arbre_Exception;
      else
         if Arbre = null then
            raise Chemin_Hors_Arbre_Exception;
         else
            if Chemin mod 2 = 0 then
               Supprimer(Arbre.all.Arbre_G, Chemin/2);
            else
               Supprimer(Arbre.all.Arbre_G, Chemin/2);
            end if;
         end if;
      end if;
   end Supprimer;

   function Inverse_Chemin(Chemin : in Integer) return Integer is
      Chemin_I : Integer;
      C_Chemin : Integer;
   begin
      C_Chemin := Chemin;
      Chemin_I := 1;
      while C_Chemin /= 1 loop
         Chemin_I := Chemin_I*2+(C_Chemin mod 2);
         C_Chemin := C_Chemin/2;
      end loop;
      return Chemin_I;
   end;
  --Permet d'afficher un sous arbre à une certaine profondeur, et en connaissant si c'est un fils gauche ou un fils droite
   procedure Sous_Afficher(Arbre : in T_Arbre; Chemin : in Integer) is
      Calc_Chemin : Integer;
   begin
      if Arbre = null then
         null;
      else
         if Chemin = 1 then
            Put("(");
            Put(Arbre.all.Valeur,1);
            Put(") ");
            Affichage_Element(Arbre.all.Element);
            New_Line;
            Sous_Afficher(Arbre.all.Arbre_G, 2);
            Sous_Afficher(Arbre.all.Arbre_D, 3);
         else
            Calc_Chemin := Inverse_Chemin(Chemin);
            if Calc_Chemin mod 2 = 0 and Calc_Chemin/2 /= 1 then
               Put("  |");
            elsif Calc_Chemin/2 /= 1 then
               Put("   ");
            end if;
            Calc_Chemin := Calc_Chemin/2;
            while Calc_Chemin > 3 loop
               if Calc_Chemin mod 2 = 0 then
                  Put("     |");
               else
                  Put("      ");
               end if;
               Calc_Chemin := Calc_Chemin/2;

            end loop;
            if Chemin <= 3 then
               Put("  \--");
            else
               Put("     \--");
            end if;
            Put(Chemin mod 2,1);
            Put("--");
            Put("(");
            Put(Arbre.all.Valeur,1);
            Put(") ");
            Affichage_Element(Arbre.all.Element);
            New_Line;
            Sous_Afficher(Arbre.all.Arbre_G, Chemin*2);
            Sous_Afficher(Arbre.all.Arbre_D, Chemin*2+1);
         end if;
      end if;
   end Sous_Afficher;

   function Element(Arbre : in T_Arbre) return T_Element is
   begin
      if Arbre = null then
         raise Arbre_Vide_Exception;
      else
         return Arbre.all.Element;
      end if;
   end Element;


   procedure Afficher(Arbre : in T_Arbre) is
   begin
      if Arbre = null then
         Put("--E");
      else
         Sous_Afficher(Arbre, 1);
      end if;
   end Afficher;

   procedure Pour_Chaque(Arbre : in out T_Arbre) is
   begin
      if Arbre = null then
         null;
      else
         Traiter(Arbre.all.Valeur,Arbre.all.Element);
         Pour_Chaque(Arbre.all.Arbre_G);
         Pour_Chaque(Arbre.all.Arbre_D);
      end if;

    end Pour_Chaque;

    function Est_Egal(Arbre1 : in T_Arbre; Arbre2 : in T_Arbre) return Boolean is
    begin
        if Arbre1 = Arbre2 then
            return True;
        elsif Arbre1 = null or Arbre2 = null then
            return False;
        elsif Arbre1.all.Valeur = Arbre2.all.Valeur and Est_Egal_Element(Arbre1.all.Element, Arbre2.all.Element) then
            return Est_Egal(Arbre1.all.Arbre_G, Arbre2.all.Arbre_G) and Est_Egal(Arbre1.all.Arbre_D, Arbre2.all.Arbre_D);
        else
            return False;
        end if;

    end;






end ARBRE;
