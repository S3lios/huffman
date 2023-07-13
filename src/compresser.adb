with Ada.Text_IO;           use Ada.Text_IO;            --Affichage de texte dans la console
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;    --Affichage des entiers dans la console
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;  --Utilisation de Unbounded_String
with Ada.Command_Line;      use Ada.Command_Line;       --Lecture des arguments en console
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;  --Pour la lecture/Ã©criture des fichiers
with Ada.Long_Long_Integer_Text_IO; use Ada.Long_Long_Integer_Text_IO; --Pour stocker de très grands nombres
with sda;                                               --Package SDA
with arbre;                                             --Package pour les arbres
with liste_c;                                           --Package pour listes chainÃ©es

procedure Compresser is
   --Declaration des types fondamentaux
   type T_Octet is mod 2**8;
   type T_Bit is mod 2**1;
   type T_Option is (NORMAL, BAVARD, MINIBAVARD);

   --Declaration des fonctions nécessaires a la declaration des packages
   
    -- Objectif :
    --     Afficher un octet en montrant sa valeur dans la table ASCII
    --
    -- Nom :
    --     Affichage_Octet
    --
    -- Paramètres :
    --     Octet : In T-Octet -- L'octet à afficher
    --
    -- Exemples :
    --     Affichage_Octet(65) -> Affiche "A"
    --     Affichage_Octet(30) -> Affiche "RS"
    --     Affichage_Octet(32) -> Affiche " "
    --
   procedure Affichage_Octet(Octet : in T_Octet) is
      Charac : Character;
   begin
      if Octet = -1 then
         Put("'\$'");
      elsif Octet > 31 then
         Charac := Character'Val(Integer(Octet));
         Put("'"&Charac&"'");
      else
         case Octet is
            when 1 => Put("SOH");
            when 2 => Put("STX");
            when 3 => Put("ETX");
            when 4 => Put("EOT");
            when 5 => Put("ENQ");
            when 6 => Put("ACK");
            when 7 => Put("BEL");
            when 8 => Put("BS");
            when 9 => Put("HT");
            when 10 => Put("LF");
            when 11 => Put("VT");
            when 12 => Put("FF");
            when 13 => Put("CR");
            when 14 => Put("SO");
            when 15 => Put("SI");
            when 16 => Put("DLE");
            when 17 => Put("DC1");
            when 18 => Put("DC2");
            when 19 => Put("DC3");
            when 20 => Put("DC4");
            when 21 => Put("NAK");
            when 22 => Put("SYN");
            when 23 => Put("ETB");
            when 24 => Put("CAN");
            when 25 => Put("EM");
            when 26 => Put("SUB");
            when 27 => Put("ESC");
            when 28 => Put("FS");
            when 29 => Put("GS");
            when 30 => Put("RS");
            when 31 => Put("US");
            when others => null;
         end case;
      end if;
   end Affichage_Octet;

    -- Objectif :
    --     Calculer la valeur d'un bit
    --
    -- Nom :
    --     Valeur_Bit
    --
    -- Paramètres :
    --     Bit : In T_Bit -- Le bit dont la valeur est à calculer
    --     
    -- Type de retour :
    --     Integer
    --
    -- Exemples :
    --     Valeur_Bit(0) = 0
    --     Valeur_Bit(1) = 1
    --     Valeur_Bit(-1) = 1
    function Valeur_Bit(Bit : in T_Bit) return Integer is
    begin       
        return Integer(Bit);
    end Valeur_Bit;

    --- Objectif :
    --     Calculer la valeur d'un octet
    --
    -- Nom :
    --     Valeur_Octet
    --
    -- Paramètres :
    --     Octet : In T_Octet -- Le bit dont la valeur est à calculer
    --     
    -- Type de retour :
    --     Integer
    --
    -- Exemples :
    --     Valeur_Octet(0) = 0
    --     Valeur_Octet(256) = 0
    --     Valeur_Octet(1) = 1
    --     Valeur_Octet(-1) = 255
    function Valeur_Octet(Octet : in T_Octet) return Integer is
    begin
        return Integer(Octet);
    end Valeur_Octet;
    
    -- Objectif :
    --     Vérifier si deux bit ont la même valeur.
    --
    -- Nom :
    --     Est_Egal_Bit
    --
    -- Paramètres :
    --     Bit1 : In T_Bit -- Le premier bit à comparer
    --     Bit2 : In T_Bit -- Le deuxième bit à comparer
    --     
    -- Type de retour :
    --     Boolean
    --
    -- Exemples :
    --     Est_Egal_Bit(0,0) = True
    --     Est_Egal_Bit(0,1) = False
    --     Est_Egal_Bit(1,0) = False
    --     Est_Egal_Bit(1,1) = True
   function Est_Egal_Bit(Bit1 : in T_Bit; Bit2 : in T_Bit) return Boolean is
   begin
      return Bit1 = Bit2;
   end Est_Egal_Bit;

    -- Objectif :
    --     Vérifier si deux octet ont la même valeur
    --
    -- Nom :
    --     Est_Egal_Octet
    --
    -- Paramètres :
    --     Octet1 : In T_Octet -- Le premier octet à comparer
    --     Octet2 : In T_Octet -- Le deuxième octet à comparer
    --
    -- Type de retour :
    --     Boolean
    --
    -- Exemples :
    --     Est_Egal_Octet(125,125) = True
    --     Est_Egal_Octet(0,1) = False
    --     Est_Egal_Octet(256,1) = True
    --     Est_Egal_Octet(15,52) = False
   function Est_Egal_Octet(Octet1 : in T_Octet; Octet2 : in T_Octet) return Boolean is
   begin
      return Octet1 = Octet2;
   end Est_Egal_Octet;

   --Declaration des packages
   package Pack_Octet_Arbre is new arbre(T_Element => T_Octet, Affichage_Element => Affichage_Octet, Est_Egal_Element => Est_Egal_Octet);
   use Pack_Octet_Arbre;

   package Pack_Bit_Liste is new liste_c(T_Element => T_Bit, Valeur => Valeur_Bit, Est_Egal_Element => Est_Egal_Bit);
   use Pack_Bit_Liste;

   package Pack_Octet_Liste is new liste_c(T_Element => T_Octet, Valeur => Valeur_Octet, Est_Egal_Element => Est_Egal_Octet);
   use Pack_Octet_Liste;

    package Pack_Arbre_Liste is new liste_c(T_Element => T_Arbre, Valeur => Pack_Octet_Arbre.Valeur, Est_Egal_Element => Pack_Octet_Arbre.Est_Egal);

   package Pack_Octet_BitListe_Sda is new sda(T_Cle => T_Octet, T_Donnee => Pack_Bit_Liste.T_Liste, Est_Egal_Cle => Est_Egal_Octet);
   use Pack_Octet_BitListe_Sda;

   package Pack_Octet_Integer_Sda is new sda(T_Cle => T_Octet, T_Donnee => Integer, Est_Egal_Cle => Est_Egal_Octet);
   use Pack_Octet_Integer_Sda;

   --Fonction d'affichage
   
    -- Objectif :
    --     Afficher un octet et son nombre d'Occurrences dans le fichier à compresser
    --
    -- Nom :
    --     Sous_Affichage_Occurrences
    --
    -- Paramètres :
    --     Octet : In T_Octet -- Octet à afficher
    --     Occurrence : In Integer -- Entier correspondant au nombre d'Occurrences de l'octet
    --
    -- Exemples :
    --     Sous_Affichage_Occurrences(65,125) -> Afficher "A" --> 125
    --     Sous_Affichage_Occurrences(30,0) -> Affiche "RS" --> 0
    --     Sous_Affichage_Occurrences(32,500) -> Affiche " " --> 500
    --
    procedure Sous_Affichage_Occurrences(Octet : in out T_Octet; Occurrence : in out Integer) is
   begin
      Affichage_Octet(Octet);
      Put("-->");
      Put(Occurrence,1);
      New_Line;
   end Sous_Affichage_Occurrences;

    -- Objectif :
    --     Afficher tous les octet et leur nombre d'Occurrences d'une SDA
    --
    -- Nom :
    --     Affichage_Occurrences
    --
    -- Paramètres :
    --     Liste_Occurrences : In Pack_Octet_Integer_Sda.T_Sda -- SDA dont les octet et Occurrences sont à afficher
    --
    -- Exemples :
    --     Soit une SDA Liste_Occurrences contenant : (62 | 125) --> (30 | 0) --> (32, 500)
    --     Affichage_Occurrences(Liste_Occurrences) -> Affiche "A" --> 125
    --                                                       "RS" --> 0
    --                                                       " " --> 500
   procedure Affichage_Occurrences is new Pack_Octet_Integer_Sda.Pour_Chaque(Sous_Affichage_Occurrences);

    -- Objectif :
    --     Afficher un bit
    --
    -- Nom :
    --     Affichage_Bit
    --
    -- Paramètres :
    --     Bit : In T_Bit -- Le bit à afficher
    --
    -- Exemples :
    --     Affichage_Bit(1) -> Affiche 1
    --     Affichege_Bit(0) -> Affiche 0
   procedure Affichage_Bit(Bit : in out T_Bit) is
   begin
      Put(Integer(Bit),1);
   end Affichage_Bit;
   
    -- Objectif :
    --     Afficher un octet en binaire
    --
    -- Nom :
    --     Affichage_SOctet
    --
    -- Paramètres :
    --     Octet : In T_Octet -- Octet à afficher en binaire
    --
    -- Exemples :
    --     Affichage_SOctet(255) -> Affiche 11111111
    --     Affichage_SOctet(3) -> Affiche 00000011
    --     Affichage_SOctet(64) -> Affiche 01000000
    --     Affichage_SOctet(15) -> Affiche 00001111
   procedure Affichage_SOctet(Octet : in out T_Octet) is
      Bit : T_Bit;
      S_Octet : T_Octet;
   begin
      S_Octet := Octet;
      for i in 1..8 loop
         Bit := T_Bit(S_Octet/128);
         Affichage_Bit(Bit);
         S_Octet := S_Octet * 2;
      end loop;
   end Affichage_SOctet;
   
    -- Objectif :
    --     Afficher tous les octet dans une liste chaînée
    --
    -- Nom :
    --     Affichage_Octets
    --
    -- Paramètres :
    --     Liste_Octets : In Pack_Octet_Liste.T_Liste -- Liste d'octets à afficher
    --
    -- Exemples :
    --     Soit une liste chaînée Liste_Octets contenant : (255) --> (3) --> (64) --> (15)
    --     Affichage_Octets(Liste_Octets) -> Affiche 11111111
    --                                               00000011
    --                                               01000000
    --                                               00001111
   procedure Affichage_Octets is new Pack_Octet_Liste.Pour_Chaque(Affichage_SOctet);   

    -- Objectif :
    --     Afficher les bits d'un code sous forme de liste chaînée
    --
    -- Nom :
    --     Affichage_Code
    --
    -- Paramètres :
    --     Code : In Pack_Bit_Liste.T_Liste -- Code à afficher
    --
    -- Exemples :
    --     Soit une liste chaînée Code contenant : (1) --> (0) --> (0) --> (1)
    --     Affichage_Code(Code) -> Affiche 1001
   procedure Affichage_Code is new Pack_Bit_Liste.Pour_Chaque(Affichage_Bit);

    -- Objectif :
    --     Afficher le codage d'un octet
    --
    -- Nom :
    --     Affichage_Codage
    --
    -- Paramètres :
    --     Octet : In T_Octet -- L'octet dont le codage est à afficher
    --     Code : In Pack_Bit_Liste.T_Liste -- Le code à afficher
    -- Exemples :
    --     Soit un octet Octet de valeur 62
    --     Soit un code Code correspondant à l'octet contenant : (1) --> (0) --> (0) --> (1)
    --     Affichage_Codage(Octet, Code) -> Affiche "A" --> 1001
   procedure Affichage_Codage(Octet : in out T_Octet; Code : in out Pack_Bit_Liste.T_Liste) is
   begin
      Affichage_Octet(Octet);
      Put("-->");
      Affichage_Code(Code);
      New_Line;
   end Affichage_Codage;

    -- Objectif :
    --     Afficher la table de codage de Huffman (octets et leur code) (SDA)
    --
    -- Nom :
    --     Affihage_Tab_Huffman
    --
    -- Paramètres :
    --     Tab_Huffman : In Pack_Octet_BitListe_Sda.T_Sda -- Table de codage à afficher
    --
    -- Exemples :
    --     Soit une SDA Tab_Huffman contenant : (62 | 1001) --> (30 | 0101) --> (32 | 0110)
    --     Affichage_Tab_Huffman(Tab_Huffman) -> Affiche "A" --> 1001
    --                                                   "RS" --> 0101
    --                                                   " " --> 0110
   procedure Affichage_Tab_Huffman is new Pack_Octet_BitListe_Sda.Pour_Chaque(Affichage_Codage);
   
   
    -- Objectif :
    --     Libérer l'espace occupé par un code (liste chaînée)
    --
    -- Nom :
    --     Sous_Vidage_Table_Huffman
    --
    -- Paramètres :
    --     Octet : In T_Octet -- Octet dont le code est à éliminer
    --     Code : In Pack_Bit_Liste.T_Liste -- Code à éliminer
    --
    -- Exemples :
    --     Sous_Vidage_Table_Huffman(62,Code) -> Code = null
    --
   procedure Sous_Vidage_Table_Huffman(Octet : in out T_Octet; Code : in out Pack_Bit_Liste.T_Liste) is
   begin
   	Vider(Code);
   end Sous_Vidage_Table_Huffman;
   
    -- Objectif :
    --     Vider la table de huffman (libérer la mémoire que la table occupe)
    --
    -- Nom :
    --     Vidage_Table_Huffman
    --
    -- Paramètres :
    --     Tab_Huffman : In Out Pack_Octet_BitListe_Sda.T_Sda -- Table de codage à vider
    --
    -- Exemples : 
    --     Vidage_Table_Huffman(Tab_Huffman) -> Tab_Huffman = null
    --
   procedure Vidage_Table_Huffman is new Pack_Octet_BitListe_Sda.Pour_Chaque(Sous_Vidage_Table_Huffman);
   
   --Declaration des variables
   Nom_Du_Fichier : Unbounded_String;                   --Nom du fichier Ã  compresser

   Tableau_Occurrences : Pack_Octet_Integer_Sda.T_Sda;   --Tableau des Occurrences
   Table_Huffman : Pack_Octet_BitListe_Sda.T_SDA;       --Table de codage
   Arbre_Huffman : T_Arbre;                             --Arbre de Huffman

   Fichier : Ada.Streams.Stream_IO.File_Type;
   Fichier_Compresse : Ada.Streams.Stream_IO.File_Type;

   S : Stream_Access;                                    --Accès au fichier à compresser
   S_C : Stream_Access;                                  --Accès au fichier compressé
   
   Option : T_Option;                                    -- Defini l'option de l'utilisateur
   
   Compteur : Long_Long_Integer;                                   --Compteur permettant de calculer la taille du fichier compresse (pour opt bavard)
   Nb_Octet : Long_Long_Integer;                                   --Nombre d'octet du fichier a compresser
   
   ----------------------------------------------------------------------------- 
   -------------------------------- Raffinage 5 --------------------------------
   -----------------------------------------------------------------------------                                                
   
    -- Objectif :
    --     Assembler des bits 1 par 1 pour fabriquer un octet puis l'écrire dans le fichier compressé une fois complet
    --
    -- Nom :
    --     Assembler_Bit_Octet
    --
    -- Paramètres :
    --     S_C : In Out Stream_Access -- Accès au fichier compressé
    --     Octet : In Out T_Octet -- Octet à compléter et écrire
    --     Bit : in T_Bit -- Bit à ajouter à l'octet
    --     i : In Out Integer -- Taille de l"Octet" 
    --
    -- Exemples : 
    --     Assembler_Bit_Octet(S_C, 32, 1, 6) --> Octet = 65, i=7  
    --     Assembler_Bit_Octet(S_C, 65, 1, 7) --> Octet = 131, i=8 donc on écrit l'octet dans le fichier
    procedure Assembler_Bit_Octet(S_C : in out Stream_Access; Octet : in out T_Octet; Bit : in T_Bit; i : in out Integer) is
   begin
      Octet := (Octet * 2) or T_Octet(Bit);
      i := i+1;
      if i = 8 then
         T_Octet'Write(S_C, Octet);
         Octet := 0;
         i := 0;
         Compteur := Compteur + 1;
      end if;
   end Assembler_Bit_Octet;

    -- Objectif :
    --     Placer l'Octet marquant la fin du fichier en récupérant son code dans la table de codage
    --
    -- Nom :
    --     Ecrire_Code_Fin_Fichier
    --
    -- Paramètres :
    --     S_C : In Out Stream_Access -- Accès au fichier compressé 
    --     Table_Huffman : in Pack_Octet_BitListe_Sda.T_Sda -- Table de codage
    --     Octet : in out T_Octet -- Octet à écrire contenant le marqueur de fin de fichier
    --     i : in out Integer -- Taille de l'octet
    -- Exemples : 
    --     Si (-1) (marqueur de fin de fichier) est codé par 1 (001) et i=0 :
    --     Ecrire_Code_Fin_Fichier(S_C, Table_Huffman, 0, 0) --> Octet 00100000 est écrit dans le fichier 
    --
   procedure Ecrire_Code_Fin_Fichier(S_C : in out Stream_Access; Table_Huffman : in Pack_Octet_BitListe_Sda.T_Sda; Octet : in out T_Octet; i : in out Integer) is
      Code : Pack_Bit_Liste.T_Liste;
      Bit : T_Bit;
   begin
      Append(La_Donnee(Table_Huffman, -1), Code);
      while not Est_Vide(Code) loop
         Bit := Pack_Bit_Liste.Extraire_Debut(Code);
         Assembler_Bit_Octet(S_C, Octet, Bit, i);
      end loop;
      while i < 8 and i /= 0 loop
         Octet := Octet*2;
         i := i+1;
      end loop;
      if i = 8 then
          T_Octet'Write(S_C, Octet);
          Compteur := Compteur + 1;
      end if;
   end Ecrire_Code_Fin_Fichier;


   ----------------------------------------------------------------------------- 
   -------------------------------- Raffinage 4 --------------------------------
   -----------------------------------------------------------------------------
   
    -- Objectif :
    --     Initialiser la liste d'arbres de Huffman
    --
    -- Nom :
    --     Initialiser_Liste_Arbre_Huffman
    --
    -- Paramètres :
    --     Tableau_Occurrences : in out Pack_Octet_Integer_Sda.T_SDA -- Tableau des Occurrences de chaque cractère
    --     Liste_Arbre_Huffman : out Pack_Arbre_Liste.T_Liste -- La liste d'arbre à initialiser
    --
    -- Exemples : 
    --     Si le tableau des Occurrences comprend les éléments : (65 | 5) --> ('66 | 4) on aura
    --     Initialiser_Liste_Arbre_Huffman(Tableau_Occurrences, Liste_Arbre_Huffman) --> Liste_Arbre_Huffman contiendra 2 Arbre (feuilles) : (5 | 65) et (4 | 66)
    procedure Initialiser_Liste_Arbre_Huffman(Tableau_Occurrences : in out Pack_Octet_Integer_Sda.T_SDA; Liste_Arbre_Huffman : out Pack_Arbre_Liste.T_Liste) is
        
    -- Objectif :
    --     Initialiser un arbre et son contenu et l'ajouter à la liste d'arbres
    --
    -- Nom :
    --     Arbre_Elementaire
    --
    -- Paramètres :
    --     Octet : in out T_Octet -- L'octet "valeur" de l'arbre
    --     Occurrence : in out Integer -- Le nombre d'Occurrences de l'octet
    --
    -- Exemples : 
    --     Arbre_Elementaire(20,12) crée un arbre (feuille) de valeur 12 et d'élément 20 et l'ajoute à la liste
      procedure Arbre_Elementaire(Octet : in out T_Octet; Occurrence : in out Integer) is
         Arbre : T_Arbre;
      begin
         Initialiser_Valeur(Arbre, Occurrence, Octet);
         Pack_Arbre_Liste.Ajouter_Fin(Liste_Arbre_Huffman, Arbre);
      end Arbre_Elementaire;
        
    -- Objectif :
    --     Ajouter tous les arbres élémentaires issus du tableau des Occurrences dans la liste d'arbres
    --
    -- Nom :
    --     Arbre_Elementaires
    --
    -- Paramètres :
    --     Liste_Arbre_Huffman : in out Pack_Octet_Integer_Sda.T_Sda -- Liste à remplir
    -- Exemples :
    --     Même chose que pour Arbre_Elementaire mais avec plusieurs arbres issus du tableau des Occurrences complet
      procedure Arbre_Elementaires is new Pack_Octet_Integer_Sda.Pour_Chaque(Arbre_Elementaire);

   begin
        Pack_Arbre_Liste.Initialiser(Liste_Arbre_Huffman);
        Arbre_Elementaires(Tableau_Occurrences);
    end Initialiser_Liste_Arbre_Huffman;

    -- Objectif :
    --     Réduire la taille de la liste en fusionnant les 2 arbre de valeur les plus faibles
    --
    -- Nom :
    --     Reduire
    --
    -- Paramètres :
    --     Liste_Arbre_Huffman : in out Pack_Arbre_Liste.T_Liste -- Liste à réduire
    --
    -- Exemples :
    --     Arbre1 : ( 66 | 4 ) Arbre2 : ( 65 | 5 ) dans la liste
    --     Reduire(Liste_Arbre_Huffman) --> La liste devient une liste contenant un arbre avec pour paramètres : Valeur = 9, Element = 0, ArbreG = Arbre1, ArbreD = Arbre2
    procedure Reduire(Liste_Arbre_Huffman : in out Pack_Arbre_Liste.T_Liste) is
      Arbre_Min1 : T_Arbre;
      Arbre_Min2 : T_Arbre;
    begin
      Arbre_Min1 := Pack_Arbre_Liste.Retirer_Min(Liste_Arbre_Huffman);
      Arbre_Min2 := Pack_Arbre_Liste.Retirer_Min(Liste_Arbre_Huffman);
      Fusionner(Arbre_Min1, Arbre_Min2, 0);
      Pack_Arbre_Liste.Ajouter_Fin(Liste_Arbre_Huffman, Arbre_Min1);
    end Reduire;

    -- Objectif :
    --     Créer la table de codage de Huffman par parcours infixe de l'arbre de Huffman
    --
    -- Nom :
    --     Créer_Tab_Inf
    --
    -- Paramètres :
    --     Arbre : in T_Arbre -- Arbre de Huffman
    --     Code : in out Pack_Bit_Liste.T_Liste -- Code de l'élément présent dans l'arbre visé 
    --     Table_Huffman : in out Pack_Octet_BitListe_Sda.T_SDA -- Table de codage 
    -- Exemples :
    --     On prend l'arbre Valeur = 9, Element = 0, ArbreG = Arbre1, ArbreD = Arbre2, Arbre1 : Element = 66 Valeur 4 ; Arbre2 : Element = 65 Valeur = 5 , Code est vide au départ
    --     Creer_Tab_Inf(Arbre, Code, Table_Huffman) crée la table : (0 | 66) , (1 | 65)
    procedure Creer_Tab_Inf(Arbre : in T_Arbre; Code : in out Pack_Bit_Liste.T_Liste; Table_Huffman : in out Pack_Octet_BitListe_Sda.T_SDA) is

      Sous_Arbre_G : T_Arbre;
      Sous_Arbre_D : T_Arbre;
      Code_C : Pack_Bit_Liste.T_Liste;
    begin
      if Est_Feuille(Arbre) then

         Initialiser(Code_C);
         Pack_Bit_Liste.Append(Code, Code_C);
         Pack_Octet_BitListe_Sda.Enregistrer(Table_Huffman, Element(Arbre), Code_C );
      else
         Ajouter_Fin(Code, 0);
         Sous_Arbre(Arbre, 2, Sous_Arbre_G);
         Sous_Arbre(Arbre, 3, Sous_Arbre_D);
         Creer_Tab_Inf(Sous_Arbre_G, Code, Table_Huffman);
         Retirer_Fin(Code);
         Ajouter_Fin(Code,1);
         Creer_Tab_Inf(Sous_Arbre_D, Code, Table_Huffman);
         Retirer_Fin(Code);
      end if;
    end Creer_Tab_Inf;

    -- Objectif :
    --     Calculer la suite d'octet présents dans la table de codage à écrire dans le document compressé
    --
    -- Nom :
    --     Calculer_Suite_Octets
    --
    -- Paramètres :
    --     Table_Huffman : in out Pack_Octet_BitListe_Sda.T_SDA -- Table de codage
    --     Suite_Octets : out Pack_Octet_Liste.T_Liste -- Liste d'octets à calculer
    --
    -- Exemples :
    --     Avec la table précédente  (0 | 66) , (1 | 65) , (00 | (-1))
    --     Calculer_Suite_Octets(Table_Huffman, Suite_Octets) crée la suite d'octets : (2 ; 0 ; 1)
   procedure Calculer_Suite_Octets(Table_Huffman : in out Pack_Octet_BitListe_Sda.T_SDA; Suite_Octets : out Pack_Octet_Liste.T_Liste) is
        
    -- Objectif :
    --     Ajouter un octet à la fin de la liste
    --
    -- Nom :
    --     AjoutOctet
    --
    -- Paramètres :
    --     Octet : in out T_Octet
    --     Code : in out Pack_Bit_Liste.T_Liste
    --
    -- Exemples :
    --     Liste vide, Octet 64
    --     AjoutOctet(Octet,Code) ajoute 64 à la liste
      procedure AjoutOctet(Octet : in out T_Octet; Code : in out Pack_Bit_Liste.T_Liste) is
      begin
         Ajouter_Fin(Suite_Octets, Octet);
      end AjoutOctet;
        
    -- Objectif :
    --     Ajouter tous les octets de la table de huffman à la liste d'octets
    --
    -- Nom :
    --     AjoutOctets
    --
    -- Paramètres :
    --     Table_Huffman : in Pack_Octet_BitListe_Sda.T_SDA
    --
    -- Exemples :
    --     Avec la table précédente  (0 | 66) , (1 | 65) , (00 | (-1))
    --     AjoutOctets(Table) --> la liste est alors (0, 1, 00)
      procedure AjoutOctets is new Pack_Octet_BitListe_Sda.Pour_Chaque(AjoutOctet);
   begin
     Initialiser(Suite_Octets);
     AjoutOctets(Table_Huffman);
     Ajouter_Debut(Suite_Octets, T_Octet(Extraire_Element(Suite_Octets, -1)));
     Ajouter_Fin(Suite_Octets,Dernier_Element(Suite_Octets));
   end Calculer_Suite_Octets;

    -- Objectif :
    --     Ecrire la suite de bits par parcours infixe dans le fichier compressé
    --
    -- Nom :
    --     Ecrire_Suite_Bits
    --
    -- Paramètres :
    --     S_C : in out Stream_Access -- Accès au fichier compressé
    --     Suite_Bits : in out Pack_Bit_Liste.T_Liste -- Suite de bits construite par parcours infixe de l'arbre
    --     Octet : in out T_Octet -- Octet à compléter pour pouvoir l'écrire dans le fichier
    --     i : in out Integer -- Longueur de l'octet
    --
    -- Exemples :
    --     On prend l'arbre Valeur = 9, Element = 0, ArbreG = Arbre1, ArbreD = Arbre2, Arbre1 : Element = 66 Valeur 4 ; Arbre2 : Element = 65 Valeur = 5
    --     Ecrire_Suite_Bits(S_C, Suite_Bits, Octet, i) --> Ecrit 011
   procedure Ecrire_Suite_Bits(S_C : in out Stream_Access; Suite_Bits : in out Pack_Bit_Liste.T_Liste; Octet : in out T_Octet; i : in out Integer) is
        
    -- Objectif :
    --     Ajouter un bit à un octet incomplet pour l'écire dans le fichier une fois complet
    --
    -- Nom :
    --     Assemblage_Bit
    --
    -- Paramètres :
    --     Bit : in out T_Bit -- Bit à ajouter
    --
    -- Exemples :
    --     Bit : 1   octet : 101 (5)
    --     Assemblage_Bit(Bit) --> Octet : 1011
      procedure Assemblage_Bit(Bit : in out T_Bit) is
      begin
         Assembler_Bit_Octet(S_C,Octet,Bit,i);
      end Assemblage_Bit;
        
    -- Objectif :
    --     Ecrire tous les bits d'une liste de bits dans le fichier compressé
    --
    -- Nom :
    --     Ecriture_Bits
    --
    -- Paramètres :
    --     Liste_Bits : in out Pack_Bit_Liste.T_Liste -- Liste à écrire
    --
    -- Exemples :
    --     Liste_Bits : (1,0,1,1,0,1,1,1)
    --     Ecriture_Bits(Liste_Bits) --> Ecrit dans le fichier 10110111
      procedure Ecriture_Bits is new Pack_Bit_Liste.Pour_Chaque(Assemblage_Bit);
   begin
      Ecriture_Bits(Suite_Bits);
   end Ecrire_Suite_Bits;

    -- Objectif :
    --     Ecrire la suite d'octet correpondant au message compressé dans le fichier compressé, compléte avec  des 0 si un octet est incomplet
    --
    -- Nom :
    --     Ecrire_Octets_Fichier
    --
    -- Paramètres :
    --     S : in out Steam_Access -- Accès au fichier non compressé
    --     S_C : in out Stream_Access -- Accès au fichier compressé
    --     Table_Huffman : in out Pack_Octet_BitListe_Sda.T_SDA -- Table de codage de Huffman
    --     Octet : in out T_Octet -- Octet à compléter / écrire au fur et à mesure
    --     i : in out Integer -- Longueur de l'octet
    --
    -- Exemples :
    --     un texte "abab" avec a codé par 0 et b par 1 et (-1) codé par 00 (fin de fichier)
    --     Ecrire_Octets_Fichier(S, S_C, Table_Huffman, Octet, i) --> écrit 01010000 (1 octet au lieu de 4)
   procedure Ecrire_Octets_Fichier( S : in out Stream_Access; S_C :in out Stream_Access; Table_Huffman : in out Pack_Octet_BitListe_Sda.T_SDA; Octet : in out T_Octet; i : in out Integer) is
      Code : Pack_Bit_Liste.T_Liste;
      Element : T_Octet;
      Bit : T_Bit;
   begin
      while not End_Of_File(Fichier) loop
         Element := T_Octet'Input(S);
         Pack_Bit_Liste.Append(La_Donnee(Table_Huffman, Element), Code);
         while not Est_Vide(Code) loop
            Bit := Extraire_Debut(Code);
            Assembler_Bit_Octet(S_C,Octet, Bit, i);
         end loop;
      end loop;
      Ecrire_Code_Fin_Fichier(S_C, Table_Huffman, Octet, i);
   end Ecrire_Octets_Fichier;


   ----------------------------------------------------------------------------- 
   -------------------------------- Raffinage 3 --------------------------------
   -----------------------------------------------------------------------------
   
    -- Objectif :
    --     Calculer le nombre d'Occurrences de chaque caractère présent dans le fichier à compresser et l'enregistrer dans une SDA
    --
    -- Nom :
    --     Calcul_Occurrences
    --
    -- Paramètres :
    --     S : in out Stream_Access -- Accès au fichier à compresser
    --     Tableau_Occurrences : out Pack_Octet_Integer_Sda.T_SDA -- Tableau des Occurrences de chaque caractère
    --
    -- Exemples :
    --     Texte "abab"
    --     Calcul_Occurrences(S,Tableau_Occurrences) --> Tableau_Occurrences : ((a) | 2) --> ((b) | 2) avec (a) et (b) les codes ASCII en octet de a et b
   procedure Calcul_Occurrences(S : in out Stream_Access; Tableau_Occurrences : out Pack_Octet_Integer_Sda.T_SDA) is
        Octet : T_Octet;

    begin
        Initialiser(Tableau_Occurrences);
        Enregistrer(Tableau_Occurrences, -1, 0);
        while not End_Of_File(Fichier) loop
            Octet := T_Octet'Input(S);

            begin
                Enregistrer(Tableau_Occurrences, Octet, La_Donnee(Tableau_Occurrences,Octet)+1);
            exception when Pack_Octet_Integer_Sda.Cle_Absente_Exception
                    => Enregistrer(Tableau_Occurrences,Octet,1);
            end;

        end loop;
   end Calcul_Occurrences;

    -- Objectif :
    --     Creer l'arbre de huffman à partir du tableau des Occurrences
    --
    -- Nom :
    --     Creer_Arbre_Huffman
    --
    -- Paramètres :
    --     Table_Occurrences : in out Pack_Octet_Integer_Sda.T_SDA -- Tableau des Occurrences de chaque caractère dans le fichier
    --     Arbre_Huffman : out T_Arbre -- Arbre de Huffman, arbre binaire nécessaire au codage de Huffman
    --
    -- Exemples :
    --     Table_Occurrences : ((a) | 2) --> ((b) | 2) avec (a) et (b) les codes ASCII en octet de a et b
    --     Creer_Arbre_Huffman(Table_Occurrences, Arbre_Huffman) --> Arbre_Huffman : Element=0, Valeur = 4, ArbreG = ( (a) | 2), ArbreD = ( (b) | 2)
   procedure Creer_Arbre_Huffman(Table_Occurrences : in out Pack_Octet_Integer_Sda.T_SDA; Arbre_Huffman : out T_Arbre) is
        Liste_Arbre_Huffman : Pack_Arbre_Liste.T_Liste;
    begin
        Initialiser_Liste_Arbre_Huffman(Table_Occurrences, Liste_Arbre_Huffman);
        while Pack_Arbre_Liste.Taille(Liste_Arbre_Huffman) > 1 loop
            Reduire(Liste_Arbre_Huffman);
        end loop;
        Arbre_Huffman := Pack_Arbre_Liste.Premier_Element(Liste_Arbre_Huffman);
        Pack_Arbre_Liste.Vider(Liste_Arbre_Huffman);

   end Creer_Arbre_Huffman;

    -- Objectif :
    --     Creer la table de codage de Huffman à partir de l'arbre de Huffman
    --
    -- Nom :
    --     Creer_Table_Huffman
    --
    -- Paramètres :
    --     Arbre_Huffman : in T_Arbre -- Arbre de Huffman
    --     Table_Huffman : out Pack_Octet_BitListe_Sda.T_SDA -- table de codage de Huffman
    -- Exemples :
    --     Arbre_Huffman : Element=0, Valeur = 4, ArbreG = ( (a) | 2), ArbreD = ( (b) | 2)
    --     Creer_Table_Huffman(Arbre_Huffman, Table_Huffman) --> Table_Huffman : ((a) | 0) --> ((b) | 1)
   procedure Creer_Table_Huffman(Arbre_Huffman : in T_Arbre; Table_Huffman : out Pack_Octet_BitListe_Sda.T_SDA) is
        Code : Pack_Bit_Liste.T_Liste;
    begin
        Initialiser(Table_Huffman);
        Initialiser(Code);
        Creer_Tab_Inf(Arbre_Huffman, Code, Table_Huffman);
        Vider(Code);
   end Creer_Table_Huffman;

    
    -- Objectif :
    --     Initialiser le fichier compressé avec les octets de codage (complète avec des 0 si Octet pas complet)
    --
    -- Nom :
    --     Initialiser_Fichier_Compresse
    --
    -- Paramètres :
    --     S_C : in Stream_Access -- Accès au fichier compressé
    --     Table_Huffman : in out Pack_Octet_BitListe_Sda.T_SDA -- Table de codage de Huffman
    -- Exemples :
    --     Table_Huffman : ((a) | 0) --> ((b) | 1)
    --     Initialiser_Fichier_Compresse(S_C, Table_Huffman) --> écrit 01000000
   procedure Initialiser_Fichier_Compresse(S_C : in Stream_Access; Table_Huffman : in out Pack_Octet_BitListe_Sda.T_SDA) is
      Suite_Octets : Pack_Octet_Liste.T_Liste;
        
    -- Objectif :
    --     Ecrire un octet dans un fichier et compter le nombre d'octet écrit
    --
    -- Nom :
    --     Ecrire
    --
    -- Paramètres :
    --     Octet : in out T_Octet -- Octet à écrire
    --     
    -- Exemples :
    --     Octet : 01001100
    --     Ecrire(Octet) --> écrit dans le fichier 01001100 et incrémente Compteur de 1
      procedure Ecrire(Octet : in out T_Octet) is
      begin
         T_Octet'Write(S_C, Octet);
         Compteur := Compteur + 1;
      end Ecrire;
        
    -- Objectif :
    --     Calculer et écrire la suite d'octet de la table de codage
    --
    -- Nom :
    --     Ecrire_Suite
    --
    -- Paramètres :
    --     Liste_Octet : in out Pack_Octet_Liste.T_Liste -- Liste des octets de la table
    --
    -- Exemples :
    --     Liste octets : (10101010 , 01010101)
    --     Ecrire_Suite(Liste_Octet) --> Ecrit 1010101001010101
      procedure Ecrire_Suite is new Pack_Octet_Liste.Pour_Chaque(Traiter => Ecrire);

   begin

      Calculer_Suite_Octets(Table_Huffman, Suite_Octets);
      Ecrire_Suite(Suite_Octets);
      Vider(Suite_Octets);

   end Initialiser_Fichier_Compresse;

    -- Objectif :
    --     Calculer la suite de bits par parcours infixe
    --
    -- Nom :
    --     Calcul_Suite_Bits
    --
    -- Paramètres :
    --     Arbre : in T_Arbre -- Arbre de Huffman
    --     Suite_Bits : in out Pack_Bit_Liste.T_Liste -- Suite de bit infixe
    -- Exemples :
    --      Arbre : Element=0, Valeur = 4, ArbreG = ( (a) | 2), ArbreD = ( (b) | 2)
    --      Calcul_Suite_Bits(Arbre, Suite_Bits) --> Suite_Bits : (0) -> (1) -> (1)
   procedure Calcul_Suite_Bits(Arbre : in T_Arbre; Suite_Bits : in out Pack_Bit_Liste.T_Liste) is
      S_Arbre : T_Arbre;
   begin
      if Est_Vide(Arbre) then
         raise Constraint_Error;
      elsif Est_Feuille(Arbre) then
         Ajouter_Fin(Suite_Bits,1);
      else
         Ajouter_Fin(Suite_Bits,0);
         Sous_Arbre(Arbre, 2, S_Arbre);
         Calcul_Suite_Bits(S_Arbre, Suite_Bits);
         Sous_Arbre(Arbre, 3, S_Arbre);
         Calcul_Suite_Bits(S_Arbre, Suite_Bits);
      end if;
   end Calcul_Suite_Bits;

    -- Objectif :
    --     Ecrire le fichier compressé
    --
    -- Nom :
    --     Ecrire_Fichier_Compresse
    --
    -- Paramètres :
    --     S : in out Stream_Access -- Accès au fichier à compressé
    --     S_C : in out Stream_Access -- Accès au fichier compressé
    --     Suite_Bits : in out Pack_Bit_Liste.T_Liste -- Suite de bits par parcours infixe de l'arbre
    --     Table_Huffman : in out Pack_Octet_BitListe_Sda.T_SDA -- Table de codage de Huffman
    --
    -- Exemples :
    --     Suite_Bits : (0) -> (1) -> (1) et Table_Huffman : ((a) | 0) --> ((b) | 1) et fichier : "abab"
    --     Ecrire_Fichier_Compresse(S, S_C, Suite_Bits, Table_Huffman) --> écrit dans le fichier 01100000 01010000
   procedure Ecrire_Fichier_Compresse(S : in out Stream_Access; S_C : in out Stream_Access; Suite_Bits : in out Pack_Bit_Liste.T_Liste; Table_Huffman : in out Pack_Octet_BitListe_Sda.T_SDA) is
      Octet : T_Octet;
      i : Integer;
   begin
      i := 0;
      Octet := 0;
      Ecrire_Suite_Bits(S_C, Suite_Bits, Octet, i);
      Ecrire_Octets_Fichier(S, S_C, Table_Huffman, Octet, i);
   end Ecrire_Fichier_Compresse;


   ----------------------------------------------------------------------------- 
   -------------------------------- Raffinage 2 --------------------------------
   -----------------------------------------------------------------------------
   
    -- Objectif :
   --    Recuperer les parametres lors de l'appel de la procedure decompression.
   --    Si l'utilisateur ne rentre aucune ou trop de parametre, une CONSTRAINT_ERROR est levee.
   --
   -- Nom :
   --    Recuperer_Parametre
   --
   -- Parametres :
   --     Nom_Du_Fichier : Out Unbounded_String - Le nom du fichier à compresser
   --     Option : Out T_Option : L'option de l'utilisateur. Soit NORMAL (pas d'affichage), soit MINIBAVARD (affichage rapide), soit BAVARD (affichage complet)
   --
   -- Exemples :
   --     Lors de l'appel dans un terminal :
   --         ./compression Exemple.txt
   procedure Recuperer_Parametre(Nom_Du_Fichier : out Unbounded_String; Option : out T_Option) is
   begin
      case (Argument_Count) is
      	when (1) => Nom_Du_Fichier := To_Unbounded_String(Argument(1));
      	            Option := NORMAL;
      	when (2) => Nom_Du_Fichier := To_Unbounded_String(Argument(2));
      	            if Argument(1) = "-b" then
      	            	Option := BAVARD;
      	            elsif Argument(1) = "-mb" then
      	            	Option := MINIBAVARD;
      	            elsif Argument(1) = "-n" then
      	                Option := NORMAL;
      	            else
      	            	   Put("L'option n'a pas �t� trouv�. Les options existantes sont -n, -mb, -b"); 
                       raise CONSTRAINT_ERROR;
      	            end if;
         when others =>
                       Put("Syntaxe incorrect. Merci de rentrer une syntaxe correct : ./compresser [OPT] {nom_du_fichier}");
                       raise CONSTRAINT_ERROR;
      end case;
   end Recuperer_Parametre;

   -- Objectif :
   --     Creer l'arbre et la table de Huffman
   --
   -- Nom :
   --     Creer_Arbre_Table_Huffman
   --
   -- Parametres :
   --     S : In Out Stream_Access -- Accès au fichier à décompresser
   --     Table_Huffman : out Pack_Octet_BitListe_Sda.T_SDA -- Table de codage à créer
   --     Arbre_Huffman : out T_Arbre -- Arbre de Huffman à créer
   --     Tableau_Occurrences : out Pack_Octet_Integer_Sda.T_Sda -- Tableau des Occurrences des caractères
   --    
   -- Exemples :
   --     Fichier : "abab"
   --     Creer_Arbre_Table_Huffman(S, Table_Huffman, Arbre_Huffman, Tableau_Occurrences) --> Tableau_Occurrences : ( (a) | 2 ) --> ( (b) | 2 ) ; Arbre_Huffman : Element=0, Valeur = 4, ArbreG = ( (a) | 2), ArbreD = ( (b) | 2)
   --     Table_Huffman : ((a) | 0) --> ((b) | 1)
   procedure Creer_Arbre_Table_Huffman(S : in out Stream_Access; Table_Huffman : out Pack_Octet_BitListe_Sda.T_SDA; Arbre_Huffman : out T_Arbre; Tableau_Occurrences : out Pack_Octet_Integer_Sda.T_Sda ) is
   begin

      if Option = BAVARD then
      	Put_Line("Calcul des Occurrences ...");
      end if;
      --Creation de l'arbre et de la table de Huffman
      Calcul_Occurrences(S, Tableau_Occurrences);
      if Option = BAVARD then
        Affichage_Occurrences(Tableau_Occurrences);
        New_Line;
        Put_Line("Calcul de l'arbre de Huffman ...");
      end if;
      Creer_Arbre_Huffman(Tableau_Occurrences, Arbre_Huffman);
      if Option = BAVARD then
          Afficher(Arbre_Huffman);
          New_Line;
          Put_Line("Calcul de la table de codage ...");
      end if;
          
      Creer_Table_Huffman(Arbre_Huffman, Table_Huffman);
      
      if Option = BAVARD then
          Affichage_Tab_Huffman(Table_Huffman);
          New_Line;
      end if;
 

   end Creer_Arbre_Table_Huffman;

    -- Objectif :
    --     Creer et écrire le fichier compressé
    --
    -- Nom :
    --     Creer_Fichier_Compresse
    --
    -- Paramètres :
    --     S : in out Stream_Access -- Accès au fichier à compresser
    --     S_C : in out Stream_Access -- Accès au fichier compressé
    --     Table_Huffman : in out Pack_Octet_BitListe_Sda.T_SDA -- Table de codage de Huffman
    --     Arbre_Huffman : in T_Arbre -- Arbre de Huffman
    --
    -- Exemples :
    --     Arbre_Huffman : Element=0, Valeur = 4, ArbreG = ( (a) | 2), ArbreD = ( (b) | 2)
    --     Table_Huffman : ((a) | 0) --> ((b) | 1)
    --     Fichier : "abab"
    --     Creer_Fichier_Compresse(S, S_C, Table_Huffman, Arbre_Huffman) --> écrit le fichier 01000000 01100000 01010000
   procedure Creer_Fichier_Compresse(S : in out Stream_Access; S_C : in out Stream_Access; Table_Huffman : in out Pack_Octet_BitListe_Sda.T_SDA; Arbre_Huffman : in T_Arbre) is
      Suite_Bits : Pack_Bit_Liste.T_Liste;
   begin
      --Creation du fichier compresse
      Initialiser_Fichier_Compresse(S_C, Table_Huffman);
      Initialiser(Suite_Bits);
      if Option = BAVARD then
         Put_Line("Calcul de la suite de bits ...");
      end if;
      Calcul_Suite_Bits(Arbre_Huffman, Suite_Bits);
      if Option = BAVARD then
         Affichage_Code(Suite_Bits);
         New_Line;
      end if;
      Ecrire_Fichier_Compresse(S, S_C, Suite_Bits, Table_Huffman);
      Vider(Suite_Bits);

   end Creer_Fichier_Compresse;


   ----------------------------------------------------------------------------- 
   -------------------------------- Raffinage 1 --------------------------------
   -----------------------------------------------------------------------------
begin


   Recuperer_Parametre(Nom_Du_Fichier, Option);

   Open(Fichier, In_File, To_String(Nom_Du_Fichier));
   Create(Fichier_Compresse, Out_File, To_String(Nom_Du_Fichier)&".hff");
   S := Stream(Fichier);
   S_C := Stream(Fichier_Compresse);

   if Option = BAVARD or Option = MINIBAVARD then
       Put_Line("Compression du fichier '"&To_String(Nom_Du_Fichier)&"' ...");
   end if;

   --Creation de la table de Huffman
   Creer_Arbre_Table_Huffman(S, Table_Huffman, Arbre_Huffman, Tableau_Occurrences);

   if Option = BAVARD then 
       Put_Line("Ecriture du fichier compresse '"&To_String(Nom_Du_Fichier)&".hff' ...");
   end if;
   
   --Creation du fichier compresse
   Reset(Fichier, In_File);
   Compteur := 0;
   Creer_Fichier_Compresse(S, S_C, Table_Huffman, Arbre_Huffman);        
   
   if Option = BAVARD or Option = MINIBAVARD then
      Put_Line("Compression de '"&To_String(Nom_Du_Fichier)&"' terminee.");
      Put("Taux de compression : ");
      Nb_Octet := Long_Long_Integer(Valeur(Arbre_Huffman));
      if Compteur*1000/Nb_Octet - (Compteur*100/Nb_Octet)*10 > 5 then
         Put(100-(Compteur*100/Nb_Octet + 1), 1);
      else
         Put(100-Compteur*100/Nb_Octet, 1);
      end if;
      Put("%.");
   end if;

   --Fermeture des fichiers et vidage des structures de donnees
   Close(Fichier);
   Close(Fichier_Compresse);
   Vider(Arbre_Huffman);
   Vidage_Table_Huffman(Table_Huffman); --Vide les codes a l'interieur de la table de Huffman
   Vider(Table_Huffman);
   Vider(Tableau_Occurrences);
exception when others =>
      New_Line;
      Put("Arret du programme ...");
end Compresser;
