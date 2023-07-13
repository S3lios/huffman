with Ada.Unchecked_Deallocation;

package body LISTE_C is

   procedure Free is
     new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_Liste);

   procedure Vider(Liste: in out T_Liste) is
   begin
      if Liste = Null then
         Null;
      else
         Vider(Liste.all.Suivant);
         Free(Liste);
      end if;
   end Vider;

   function Sous_Liste(Liste : In T_Liste) return T_Liste is
   begin
      if Est_Vide(Liste) then
         raise Liste_Vide_Exception;
      else
         return  Liste.all.Suivant;
       end if;
   end;


   function Est_Vide(Liste : in T_Liste) return Boolean is
   begin
      return Liste = Null;
   end;

   procedure Initialiser(Liste: in out T_Liste) is
   begin
      Liste := Null;
   end Initialiser;

   procedure Append(Liste1 : in T_Liste; Liste2 : in out T_Liste) is
   begin
      if Liste1 = null then
         null;
      else
         Ajouter_Fin(Liste2, Premier_Element(Liste1));
         Append(Liste1.all.Suivant, Liste2);
      end if;
   end Append;


   procedure Ajouter_Fin(Liste : in out T_Liste; Element : in T_Element) is
   begin
      if Liste = Null then
         Liste := new T_Cellule;
         Liste.all.Element := Element;
      else
         Ajouter_Fin(Liste.all.Suivant, Element);
      end if;
   end Ajouter_Fin;

   procedure Ajouter_Debut(Liste : in out T_Liste; Element : in T_Element) is
      newList : T_Liste;
   begin
      if Liste = Null then
         Liste := new T_Cellule;
         Liste.all.Element := Element;
      else
         newList := Liste;
         Liste := new T_Cellule;
         Liste.all.Element := Element;
         Liste.all.Suivant := newList;
      end if;
   end Ajouter_Debut;

   procedure Ajouter_Indice(Liste : in out T_Liste; Element : in T_Element; Indice : Integer) is
      newList : T_Liste;
   begin
      if Indice < 0 then
         raise Indice_Hors_Champ_Exception;
      else
         if Indice = 0 then
            newList := new T_Cellule;
            newList.all.Element := Element;
            newList.all.Suivant := Liste;
            Liste := newList;
         elsif Liste /= null then
            Ajouter_Indice(Liste.all.Suivant, Element, Indice-1);
         else
            raise Indice_Hors_Champ_Exception;
         end if;
      end if;

   end Ajouter_Indice;


   function Taille(Liste : in T_Liste) return Integer is
   begin
      if Liste = Null then
         return 0;
      else
         return Taille(Liste.all.Suivant) + 1;
      end if;
   end Taille;



   function Extraire_Indice(Liste : in out T_Liste; Indice : in Integer) return T_Element is
      newListe : T_Liste;
      Element : T_Element;
   begin
      if Indice < 0 then
         raise Indice_Hors_Champ_Exception;
      else
         if Liste = Null then
            raise Indice_Hors_Champ_Exception;
         elsif Indice = 0 then
            newListe := Liste;
            Liste := Liste.all.Suivant;
            Element := newListe.all.Element;
            Free(newListe);
            return Element;
         else
            return Extraire_Indice(Liste.all.Suivant, Indice-1);
         end if;
      end if;

      end Extraire_Indice;

   --Permet d'extraire un élement tout en renvoyant l'indice de sa position
   procedure Sous_Extraire_Element(Liste : in out T_Liste; Element : in T_Element; Indice : in out Integer) is
        newListe : T_Liste;
   begin
      if Liste = Null then
         raise Element_Non_Present_Exception;
      else
         if Liste.all.Element /= Element then
            Indice := Indice + 1;
            Sous_Extraire_Element(Liste.all.Suivant, Element, Indice);
         else
            newListe := Liste;
            Liste := Liste.all.Suivant;
            Free(newListe);
         end if;
      end if;
   end Sous_Extraire_Element;

   function Extraire_Element(Liste : in out T_Liste; Element : in T_Element) return Integer is
     Indice : Integer;
   begin
      Indice := 0;
      Sous_Extraire_Element(Liste, Element, Indice);
      return Indice;
   end Extraire_Element;

   function Extraire_Debut(Liste : in out T_Liste) return T_Element is
      newList : T_Liste;
      Element : T_Element;
   begin
      if Liste = Null then
         raise Liste_Vide_Exception;
      else
         newList := Liste;
         Liste := Liste.all.Suivant;
         Element := newList.all.Element;
         Free(newList);
         return Element;
      end if;
   end Extraire_Debut;

   function Extraire_Fin(Liste : in out T_Liste) return T_Element is
      Element : T_Element;
   begin
      if Liste = Null then
         raise Liste_Vide_Exception;
      else
         if Liste.all.Suivant = null then
            Element := Liste.all.Element;
            Free(Liste);
            return Element;
         else
            return Extraire_Fin(Liste.all.Suivant);
         end if;
      end if;
   end Extraire_Fin;


   procedure Retirer_Indice(Liste : in out T_Liste; Indice : in Integer) is
      Element : T_Element;
   begin
      Element := Extraire_Indice(Liste, Indice);
   end;

   procedure Retirer_Element(Liste : in out T_Liste; Element : in T_Element) is
      Indice : Integer;
   begin
      Indice:= Extraire_Element(Liste, Element);
   end;

   procedure Retirer_Debut(Liste : in out T_Liste) is
      Element : T_Element;
   begin
      Element := Extraire_Debut(Liste);
   end;

   procedure Retirer_Fin(Liste : in out T_Liste) is
      Element : T_Element;
   begin
      Element := Extraire_Fin(Liste);
   end;


   function Indice_Element(Liste : in T_Liste; Element : in T_Element) return Integer is
      cursor : T_Liste;
      Ind : Integer;
      Find : Boolean;
   begin
      Ind := -1;
      Find := False;
      cursor := Liste;
      while ((cursor /= Null) and not Find) loop
         Find := cursor.all.Element = Element;
         Ind := Ind + 1;
      end loop;
      if Find then
         return Ind;
      else
         raise Element_Non_Present_Exception;
      end if;
   end Indice_Element;

   function Element_Indice(Liste : in T_Liste; Indice : in Integer) return T_Element is
   begin
      if Indice < 0 then
         raise Indice_Hors_Champ_Exception;
      else
         if Liste = Null then
            raise Indice_Hors_Champ_Exception;
         elsif Indice = 0 then
            return Liste.all.Element;
         else
            return Element_Indice(Liste.all.Suivant, Indice-1);
         end if;
      end if;
   end Element_Indice;

   function Premier_Element(Liste : in T_Liste) return T_Element is
   begin
      return Element_Indice(Liste, 0);
   end Premier_Element;

   function Dernier_Element(Liste : in T_Liste) return T_Element is
   begin
      if Liste = null then
         raise Liste_Vide_Exception;
      elsif Liste.all.Suivant = null then
         return Liste.all.Element;
      else
         return Dernier_Element(Liste.all.Suivant);
      end if;
   end Dernier_Element;

   procedure Pour_Chaque(Liste : in out T_Liste) is
   begin
      if Liste = null then
         null;
      else
         Traiter(Liste.all.Element);
         Pour_Chaque(Liste.all.Suivant);
      end if;
   end Pour_Chaque;


   function Min(Liste : in T_Liste) return T_Element is
      Mini_Elem : T_Element;
   begin
      if Liste = Null then
         raise Liste_Vide_Exception;
      elsif Liste.all.Suivant = Null then
         return Liste.all.Element;
      else
         Mini_Elem := Min(Liste.all.Suivant);
         if Valeur(Liste.all.Element) < Valeur(Mini_Elem) then
            return Liste.all.Element;
         else
            return Mini_Elem;
         end if;
      end if;
   end Min;

   function Retirer_Min(Liste : in out T_Liste) return T_Element is
      Element_Min : T_Element;
   begin
      Element_Min := Min(Liste);
      Retirer_Element(Liste, Element_Min);
      return Element_Min;
   end Retirer_Min;


   function Max(Liste : in T_Liste) return T_Element is
      Max_Elem : T_Element;
   begin
      if Liste = Null then
         raise Liste_Vide_Exception;
      elsif Liste.all.Suivant = Null then
         return Liste.all.Element;
      else
         Max_Elem := Max(Liste.all.Suivant);
         if Valeur(Max_Elem) > Valeur(Liste.all.Element) then
            return Max_Elem;
         else
            return Liste.all.Element;
         end if;
      end if;

   end Max;

   function Retirer_Max(Liste : in out T_Liste) return T_Element is
      Element_Max : T_Element;
   begin
      Element_Max := Max(Liste);
      Retirer_Element(Liste, Element_Max);
      return Element_Max;
   end Retirer_Max;

   function Est_Egal(Liste1: in T_Liste; Liste2 : in T_Liste) return Boolean is
   begin
      if Liste1 = Liste2 then
         return True;
      else
         if Liste1 = null or Liste2 = null then
                return False;
         elsif Est_Egal_Element(Liste1.all.Element,Liste2.all.Element) then
                return Est_Egal(Liste1.all.Suivant, Liste2.all.Suivant);
         else
            return False;
         end if;
      end if;
   end Est_Egal;



end LISTE_C;
