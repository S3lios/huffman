with Ada.Text_IO;           use Ada.Text_IO;
with liste_c;


procedure test_liste_c is
   function Valeur(Element : in Integer) return Integer is
      begin
          return Element;
   end Valeur;

   function Est_Egal_Element(Entier1 : Integer; Entier2 : Integer) return Boolean is
   begin
      return Entier1 = Entier2;
   end;


   package liste is new
     liste_c(T_Element => Integer, Valeur => Valeur, Est_Egal_Element=>Est_Egal_Element);
   use liste;


   --Initialise une liste utilisée dans les tests
   procedure Initialiser_Valeur(Liste : out T_Liste) is
   begin
      Initialiser(Liste);
      Ajouter_Fin(Liste,3);
      Ajouter_Debut(Liste,1);
      Ajouter_Indice(Liste,2,1);
      Ajouter_Fin(Liste,4);
      --Liste = 1,2,3,4
   end Initialiser_Valeur;


   --Tester la fonction Est_Vide.
   procedure Tester_Est_Vide is
      Liste :  T_Liste;
   begin
      Initialiser(Liste);
      pragma Assert(Est_Vide(Liste));
      Ajouter_Fin(Liste, 1);
      pragma Assert(not Est_Vide(Liste));
      Retirer_Fin(Liste);
      pragma Assert(Est_Vide(Liste));
      Ajouter_Fin(Liste, 1);
      Ajouter_Fin(Liste, 1);
      pragma Assert(not Est_Vide(Liste));
      Vider(Liste);
      pragma Assert(Est_Vide(Liste));
   end Tester_Est_Vide;

   --Test des fonctions extraire
   procedure Tester_Extraire is
      Liste : T_Liste;
   begin
      Initialiser_Valeur(Liste);
      pragma Assert(Extraire_Fin(Liste) = 4);
      pragma Assert(Extraire_Element(Liste, 2) = 3);
      pragma Assert(Extraire_Indice(Liste, 0) = 1);
      Vider(Liste);
   end Tester_Extraire;

   --Tests des fonctions pour accéder à un élément
   procedure Tester_Elements is
      Liste : T_Liste;
   begin
      Initialiser_Valeur(Liste);
      pragma Assert(Dernier_Element(Liste) = 4);
      pragma Assert(Premier_Element(Liste) = 1);
      pragma Assert(Element_Indice(Liste, 2) = 3);
      pragma Assert(Element_Indice(Liste, 2) = 3);
      Vider(Liste);
   end Tester_Elements;

   --Tests des fonctions de comparaison
   procedure Tester_Min_Max_Egal is
      Liste : T_Liste;
      Liste2 : T_Liste;
   begin
      Initialiser_Valeur(Liste);
      Initialiser_Valeur(Liste2);
      pragma Assert(Est_Egal(Liste, Liste2));
      pragma Assert(Min(Liste) = 1);
      pragma Assert(Max(Liste) = 4);
      pragma Assert(Retirer_Min(Liste) = 1);
      pragma Assert(Min(Liste) = 2);
      pragma Assert(Retirer_Max(Liste) = 4);
      pragma Assert(Max(Liste) = 3);
      pragma Assert(not  Est_Egal(Liste, Liste2));
      Vider(Liste);
      Vider(Liste2);
   end Tester_Min_Max_Egal;

   --Test de la fonction pour chaque
    procedure Tester_Pour_chaque is
        Liste : T_Liste;
        Somme: Integer;
        procedure Sommer (Element : in out Integer) is
        begin
            Somme := Somme + Element;
        end;

        procedure Sommer is
                new Pour_Chaque(Sommer);
    begin
        Initialiser_Valeur(Liste);
        Somme := 0;
        Sommer (Liste);
        pragma Assert (Somme = 10);
        Vider(Liste);
    end Tester_Pour_chaque;

begin
   Tester_Est_Vide;
   Tester_Elements;
   Tester_Extraire;
   Tester_Min_Max_Egal;
   Tester_Pour_chaque;
   Put("Tous les tests sont passés");
end test_liste_c;
