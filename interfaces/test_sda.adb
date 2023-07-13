with Ada.Text_IO;   use Ada.Text_IO;
with sda;

procedure test_sda is
   package package_test is new
     SDA(T_Cle => Integer, T_Donnee => Integer);
   use package_test;

  --Initialise une sda avec des valeurs
   procedure Initialiser_Valeur(Sda :out  T_SDA) is
   begin
      Initialiser(Sda);
      Enregistrer(Sda, 2, 2);
      Enregistrer(Sda, 3, 100);
      Enregistrer(Sda, 1, 1);
      Enregistrer(Sda, -90, 90);
      Enregistrer(Sda, 4, 3);
      Enregistrer(Sda,20,1);
   end Initialiser_Valeur;


   --Test les fonctions permettant d'accéder à des valeurs
   procedure Test_Recuperation is
      Sda : T_SDA;
   begin
      Initialiser_Valeur(Sda);
      pragma Assert(La_Cle(Sda, 90) = -90);
      pragma Assert(La_Donnee(Sda,4) = 3);
      pragma Assert(Cle_Presente(Sda, 1));
      pragma Assert(not Cle_Presente(Sda, 102));
      pragma Assert(La_Cle(Sda, 1) = 1);
      Vider(Sda);
   end Test_Recuperation;

   --Test des procedures d'enregistrement et de supression de valeur
   procedure Test_Enregistrement is
      Sda : T_SDA;
   begin
      Initialiser_Valeur(Sda);
      Enregistrer(Sda, -90, 45);
      pragma Assert(La_Cle(Sda, 90) = -45);
      Supprimer(Sda, 1);
      pragma Assert(not Cle_Presente(Sda, 1));
      Enregistrer(Sda, 102, 3);
      pragma Assert(Cle_Presente(Sda, 102));
      Vider(Sda);
   end Test_Enregistrement;

   procedure Test_Taille_Est_Vide_Traiter is
      Sda: T_SDA;
   begin
      Initialiser(Sda);
      pragma Assert(Est_Vide(Sda));
      pragma Assert(Taille(Sda) = 0);
      Initialiser_Valeur(Sda);
      pragma Assert(not Est_Vide(Sda));
      Supprimer(Sda,1);
      Supprimer(Sda,-90);
      Supprimer(Sda,4);
      Supprimer(Sda,2);
      Supprimer(Sda,3);
      Supprimer(Sda, 20);
      pragma Assert(Est_Vide(Sda));
      Initialiser_Valeur(Sda);
      pragma Assert(Taille(Sda)=6);
      Supprimer(Sda,-90);
      pragma Assert(Taille(Sda)=5);
      Vider(Sda);
      pragma Assert(Est_Vide(Sda));
      pragma Assert(Taille(Sda)=0);

   end Test_Taille_Est_Vide_Traiter;


   --Test de la procedure Pour_Chaque
   procedure Test_Pour_Chaque is
      Sda : T_SDA;

      procedure Mise_Au_Carre(Cle : in out Integer; Donnee :in out Integer) is
      begin
         Donnee := Donnee*Donnee;
      end Mise_Au_Carre;

      procedure Egalite(Cle : in out Integer; Donnee : in out Integer) is
      begin
         Donnee := Cle;
         Cle := Cle*2;
      end Egalite;

      procedure PC_Carre is new Pour_Chaque(Mise_Au_Carre);
      procedure PC_Egalite is new Pour_Chaque(Egalite);
   begin
      Initialiser_Valeur(Sda);
      PC_Carre(Sda);
      pragma Assert(La_Donnee(Sda, 4) = 9);
      pragma Assert(La_Cle(Sda, 10000) = 3);
      PC_Egalite(Sda);
      pragma Assert(La_Cle(Sda,3) = 6);
      pragma Assert(La_Donnee(Sda,8) = 4);
      Vider(Sda);

   end Test_Pour_Chaque;
begin
   Test_Enregistrement;
   Test_Recuperation;
   Test_Taille_Est_Vide_Traiter;
   Test_Pour_Chaque;
   Put("Tous les tests sont passés");

end test_sda;
