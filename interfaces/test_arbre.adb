with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;

with arbre;

procedure test_arbre is

   procedure Affichage_Entier(Valeur : in Integer) is
   begin
      if Valeur /= 0 then
         Put("'");
         Put(Valeur,1);
         Put("'");
      end if;
   end Affichage_Entier;


   package arbre_b is new
     arbre(T_Element => Integer, Affichage_Element => Affichage_Entier);
   use arbre_b;

   --Initialise un arbre non vide à utiliser pour les tests
   procedure Initialiser_Valeur_Arbre(Arbre : out T_Arbre) is
      Arbre_2 : T_Arbre;
   begin
      Initialiser_Valeur(Arbre, 1, 10);
      Initialiser_Valeur(Arbre_2,2, 20);
      Fusionner(Arbre, Arbre_2, 0);
      Initialiser_Valeur(Arbre_2,3,30);
      Fusionner(Arbre, Arbre_2, 0);
      Initialiser_Valeur(Arbre_2,4,40);
      Fusionner(Arbre,Arbre_2, 0);
   end Initialiser_Valeur_Arbre;

   --Test les procédures Est_Vide et Vider_Arbre
   procedure Tester_Est_Vide is

      Arbre : T_Arbre;
   begin
      Initialiser(Arbre);
      pragma assert(Est_Vide(Arbre));
      Initialiser_Valeur_Arbre(Arbre);
      pragma assert(not Est_Vide(Arbre));
      Vider(Arbre);
      pragma assert(Est_Vide(Arbre));

   end Tester_Est_Vide;

   --Test Valeur, Fusionner, Est_Feuille, Ajouter, Supprimer
   procedure Tester_VFEFAS is
      Arbre : T_Arbre;
      Arbre2 : T_Arbre;
      Arbre_3 : T_Arbre;
   begin
      Initialiser_Valeur(Arbre, 1, 10);
      pragma assert(Est_Feuille(Arbre));
      Ajouter(Arbre, 2, 20, 3);
      Ajouter(Arbre, 3, 30, 2);
      pragma assert(not  Est_Feuille(Arbre));
      Sous_Arbre(Arbre,1, Arbre_3);
      pragma assert(Est_Feuille(Arbre_3));
      Supprimer(Arbre, 2);
      Supprimer(Arbre, 3);
      pragma assert(Est_Feuille(Arbre));
      Vider(Arbre);
      Initialiser_Valeur(Arbre, 1, 10);
      Initialiser_Valeur(Arbre2, 2, 20);
      Fusionner(Arbre,Arbre2, 0);
      pragma assert(not Est_Feuille(Arbre));
      pragma assert(Valeur(Arbre)=30);
      Vider(Arbre);
      Vider(Arbre2);


   end Tester_VFEFAS;

    procedure Tester_Pour_chaque is
        Arbre : T_Arbre;
        Somme: Integer;
        procedure Sommer (Valeur : in out Integer; Element : in out Integer) is
        begin
            Somme := Somme + Element;
        end;
        procedure Sommer is
                new Pour_Chaque (Sommer);
    begin
        Initialiser_Valeur_Arbre(Arbre);
        Somme := 0;
        Sommer (Arbre);
        pragma Assert (Somme = 100);
        Vider(Arbre);
    end Tester_Pour_chaque;


   --Tester l'affichage (manuellement)
   procedure Test_Afficher is
      Arbre : T_Arbre;
   begin
      Initialiser_Valeur_Arbre(Arbre);
      Afficher(Arbre);
   end Test_Afficher;


begin
    Tester_Est_Vide;
    Tester_VFEFAS;
    Tester_Pour_chaque;
    Test_Afficher;
    Put("Tous les tests sont passés");
end test_arbre;
