with Ada.Text_IO;           use Ada.Text_IO;            --Affichage de texte dans la console
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;    --Affichage des entiers dans la console
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;  --Utilisation de Unbounded_String
with Ada.Command_Line;      use Ada.Command_Line;       --Lecture des arguments en console
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;  --Pour la lecture/Ã©criture des fichiers
with arbre;                                             --Package arbre
with liste_c;                                           --Package pour listes chainÃ©es

procedure decompresser is

   --DECLARATION DES TYPES
   type T_Octet is mod 2**8;
   type T_Bit is mod 2**1;
   type T_Option is (NORMAL, MINIBAVARD, BAVARD);

   --Fonction nï¿½cessaire pour les packages


   -- Objectif :
   --     Verifie si deux bits ont la meme valeur.
   --
   -- Nom :
   --     Est_Egal_Bit
   --
   -- Parametres :
   --     Bit1 : In T_Octet -- Le premier bit a comparer
   --     Bit2 : In T_Octet -- Le deuxieme bit a comparer
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
   --    Vï¿½rifie si deux octets ont la meme valeur
   --
   -- Nom :
   --     Est_Egal_Octet
   --
   -- Parametres :
   --     Octet1 : In T_Octet -- Le premier octet a comparer
   --     Octet2 : In T_Octet -- Le deuxieme octet a comparer
   --
   -- Type de retour :
   --     Boolean
   --
   -- Exemples :
   --     Est_Egal_Octet(125,125) = True
   --     Est_Egal_Octet(0,1) = False
   --     Est_Egal_Octet(15,52) = False
   --     Est_Egal_Octet(256,1) = True
   function Est_Egal_Octet(Octet1 : in T_Octet; Octet2 : in T_Octet) return Boolean is
   begin
      return Octet1 = Octet2;
   end Est_Egal_Octet;

   -- Objectif :
   --    Renvoie la valeur du bit (0 ou 1)
   --
   -- Nom :
   --     Val_Bit
   --
   -- Parametres :
   --     Bit : In T_Bit - Le bit d'on on veut la valeur
   --
   -- Type de retour :
   --     Integer
   --
   -- Exemples :
   --     Val_Bit(0) = 0
   --     Val_Bit(1) = 1
   function Val_Bit(Bit : In T_Bit) return Integer is
   begin
     return Integer(Bit);
   end;


   -- Objectif :
   --    Renvoie la valeur de l'octet (0 Ã  255)
   --
   -- Nom :
   --     Val_Octet
   --
   -- Parametres :
   --     Octet : In T_Octet - L'octet d'on on veut la valeur
   --
   -- Type de retour :
   --     Integer
   --
   -- Exemples :
   --     Val_Bit(0) = 0
   --     Val_Bit(243) = 243
   --     Val_Bit(-1) = 255
   function Val_Octet(Octet : In T_Octet) return Integer is
   begin
     return Integer(Octet);
   end;

   -- Objectif :
   --    Afficher un octet en montrant sa valeur dans la table ASCII
   --
   -- Nom :
   --    Affichage_Octet
   --
   -- Parametres :
   --     Octet : In T_Octet -- L'octet a afficher
   --
   -- Exemples :
   --     Affichage_Octet(65) -> Affiche "A"
   --     Affichage_Octet(30) -> Affiche RS
   --     Affichage_Octet(32) -> Affiche " "
   procedure Affichage_Octet(Octet : In T_Octet) is
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
            when 17 => Put("SUB");
            when 27 => Put("ESC");
            when 28 => Put("FS");
            when 29 => Put("GS");
            when 30 => Put("RS");
            when 31 => Put("US");
            when others => null;
         end case;
      end if;
   end Affichage_Octet;

   --Declaration des packages
   package Pack_Octet_Arbre is new arbre(T_Element => T_Octet, Affichage_Element => Affichage_Octet, Est_Egal_Element => Est_Egal_Octet);
   use Pack_Octet_Arbre;

   package Pack_Bit_Liste is new liste_c(T_Element => T_Bit, Valeur => Val_Bit, Est_Egal_Element => Est_Egal_Bit);
   use Pack_Bit_Liste;

   package Pack_Octet_Liste is new liste_c(T_Element => T_Octet, Valeur => Val_Octet, Est_Egal_Element => Est_Egal_Octet);
   use Pack_Octet_Liste;


   ---Declaration des fonctions d'affichage



   -- Objectif :
   --    Affiche la valeur d'un bit
   --
   -- Nom :
   --     Affichage_bit
   --
   -- Parametre :
   --    Bit : In T_Bit -- Le bit a afficher
   --
   -- Exemples :
   --    Affichage_Bit(0) -> Affiche 0
   --    Affichage_Bit(1) -> Affiche 1
   procedure Affichage_Bit(Bit : in out T_Bit) is
   begin
      Put(Integer(Bit), 1);
   end;

   -- Objectif :
   --    Affiche la valeur d'un octet sous sa forme binaire
   --
   -- Nom :
   --    Affichage_SOctet
   --
   -- Parametre :
   --    Octet : In T_Octet -- L'octet a afficher
   --
   -- Exemples :
   --    Affichage_SOctet(123) -> Affiche :01111011
   --    Affichage_SOctet(0) -> Affiche :00000000
   --    Affichage_SOctet(-1) -> Affiche :11111111
   --    Affichage_SOctet(8) -> Affiche :00001000
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
      Put(" ");
   end Affichage_SOctet;

   -- Objectif :
   --    Affiche une suite d'octet
   --
   -- Nom :
   --    Affichage_LOctet
   --
   -- Parametres :
   --    Liste_Octet : In Pack_Bit_List.T_Liste -- La liste � afficher
   --
   -- Exemples :
   --    Affichage_Code(1->2->0->255) -> Affiche 00000001 00000020 00000000 11111111
   --    Affichage_Code(Liste_Vide) -> N'affiche rien
   procedure Affichage_LOctet is new Pack_Octet_Liste.Pour_Chaque(Affichage_SOctet);


   -- Objectif :
   --    Affiche un code binaire
   --
   -- Nom :
   --    Affichage_Code
   --
   -- Parametres :
   --    Code : In Pack_Bit_List.T_Liste -- Le code ï¿½ afficher
   --
   -- Exemples :
   --    Si le code est la liste de bit ->1->1->0->1->E:In Pack_Bit_List.T_Liste --
   --        Affichage_Code(code) -> Affiche : 1101
   --    Si le code est la liste de bit ->E:
   --        Affichage_Code(code) -> N'Affiche rien
   --    Si le code est la liste de bit ->1->E:
   --        Affichage_Code(code) -> Affiche : 1
   procedure Affichage_Code is new Pack_Bit_Liste.Pour_Chaque(Affichage_Bit);



   --Declaration des variables
   Nom_Du_Fichier_Compresse : Unbounded_String;
   Arbre_Huffman : T_Arbre;

   Fichier : Ada.Streams.Stream_IO.File_Type;
   Fichier_Compresse : Ada.Streams.Stream_IO.File_Type;

   i : Integer;
   Octet : T_Octet;

   S : Stream_Access;
   S_C : Stream_Access;

   Option : T_Option;                                    -- Defini l'option de l'utilisateur



   -----------------------------------------------------------------------------
   -------------------------------- Raffinage 4 --------------------------------
   -----------------------------------------------------------------------------


   -- Objectif :
   --    Convertir un code (une suite de bits) en chemin correspondant dans un arbre.
   -- Nom :
   --    Conv_Code_Chemin
   --
   -- Parametres :
   --    Code : In PAck_Bit_Liste.T_Liste - Le code à convertir
   --
   -- Type de retour :
   --    Integer - Le chemin correspondant au code.
   --
   -- Exemples :
   --    Conv_Code_Chemin(0110) = 22 car 22 = 0+(1+(1+(0+(1*2))*2)*2)*2
   --    Conv_Code_Chemin(110) = 11 car 11 = 1+(1+(0+(1*2))*2)*2
   --    Conv_Code_Chemin(Code nul) = 1 par défintiion
   --    Conv_Code_Chemin(0) = 2 car 2 = 0+(1*2)
   --    Conv_Code_Chemin(1) = 3 car 3 = 1+(1*2)
   function Conv_Code_Chemin(Code : In Pack_Bit_Liste.T_Liste) return Integer is
   begin
      if Est_Vide(Code) then
        return 1;
      else
        return Integer(Premier_Element(Code)) + 2*Conv_Code_Chemin(Sous_Liste(Code));
      end if;
   end;




   -- Objectif :
   --    Agi en fonction de la valeur du Bit pour construire la table de dÃ©codage et le code d'un octet
   --
   -- Nom :
   --    Agir_Selon_Bit
   --
   -- Parametres :
   --    Table_Decodage : In Out T_SDA - La SDA qui va Ãªtre construite
   --    Bit : In T_Bit - Le bit qui va dire ce que l'on doit faire
   --    Suite_Octets : In Out Pack_Octet_Liste.T_Liste - La liste contenant les octets restant Ã  ajouter dans Table_Decodage
   --    Code : In Out Pack_Bit_Liste.T_Liste - Le Code Ã  construire qui va coder le prochaine octet.
   --
   -- Preconditions :
   --     NON Est_Vide(Suite_Octets)
   --     NON (Est_Vide(Code) ET Bit = 1)
   -- Postconditions :
   --     Taille(Suite_Octets) = Taille(Suite_Octets'Avant) - Integer(Bit)
   --     Taille(Table_Decodage) = Taille(table_Decodage'Avant) + Integer(Bit)
   --     Dernier_Element(Code) = Bit OU (Bit = 1 ET Est_Vide(Code))
   --
   -- Exemples :
   --     On prend pour les exemples: Table_Decodage = (001 | 35) --> (01 |Â 90) , Suite_Octets = 35->23->10->56
   --     Si Code = 001110:
   --         Agir_Selon_Bit(Table_Decodage, 0, Suite_Octets, Code)
   --                          -> Table_Decodage et Suite_Octets n'ont pas changÃ©. Code = 0011100
   --         Agir_Selon_Bit(Table_Decodage, 1, Suite_Octets, Code)
   --                          -> Table_Decodage = (001 | 35) --> (01 |Â 90) --> (001110 | 35), Suite_Octets = 23->10->56, Code = 001111
   --     Si Code = 001111:
   --         Agir_Selon_Bit(Table_Decodage, 0, Suite_Octets, Code)
   --                          -> Table_Decodage et Suite_Octets n'ont pas changÃ©. Code = 0011110
   --         Agir_Selon_Bit(Table_Decodage, 1, Suite_Octets, Code)
   --                          -> Table_Decodage = (001 | 35) --> (01 |Â 90) --> (001111 | 35), Suite_Octets = 23->10->56, Code = 01
   --    Si Code = 1111:
   --         Agir_Selon_Bit(Table_Decodage, 0, Suite_Octets, Code)
   --                          -> Table_Decodage et Suite_Octets n'ont pas changÃ©. Code = 11110
   --         Agir_Selon_Bit(Table_Decodage, 1, Suite_Octets, Code)
   --                          -> Table_Decodage = (001 | 35) --> (01 |Â 90) --> (1111 | 35), Suite_Octets = 23->10->56, Code est vide
   --    Si Code est vide:
   --         Agir_Selon_Bit(Table_Decodage, 0, Suite_Octets, Code)
   --                          -> Table_Decodage et Suite_Octets n'ont pas changÃ©. Code = 0
   procedure Agir_Selon_Bit(Arbre_Huffman : in out T_Arbre; Bit : in T_Bit; Suite_Octets : in out Pack_Octet_Liste.T_Liste; Code : in out Pack_Bit_Liste.T_liste) is
         Chemin : Integer;

   begin
      if Bit = 0 then
         Ajouter_Fin(Code,0);
         Chemin := Conv_Code_Chemin(Code);
         Ajouter(Arbre_Huffman, 0, 0, Chemin);
      else
         Chemin := Conv_Code_Chemin(Code);
         Ajouter(Arbre_Huffman, 0, Extraire_Debut(Suite_Octets), Chemin);
         while Dernier_Element(Code) = 1 loop
            Retirer_Fin(Code);
         end loop;
         if not Est_Vide(Code) then
            Retirer_Fin(Code);
            Ajouter_Fin(Code,1);
            Chemin := Conv_Code_Chemin(Code);
            Ajouter(Arbre_Huffman, 0, 0, Chemin);
         end if;
      end if;
   exception when Pack_Bit_Liste.Liste_Vide_Exception => null;

   end Agir_Selon_Bit;

   -- Objectif :
   --    Ajoute le bit de poids fort de l'octet au Code. Decale ensuite tout les bits de l'octet vers la gauche et actualiser la mÃ©moire
   --    permettant de stocker combien de bit "utile" il reste dans l'octet.
   --
   -- Nom :
   --   Actualiser
   --
   -- Parametres :
   --   Octet : In Out T_Octet - L'octet oÃ¹ l'on doit lire le bit de poids fort
   --   i : In Out Integer - Le compteur de bit utile restant dans l'octet
   --   Code : In Out Pack_Bit_Liste.T_Liste - Le code oÃ¹ l'on rajoute le bit utile
   --
   -- Preconditions :
   --   1 <= i <= 8
   --
   -- Postconditions :
   --   0 <= i <= 7
   --   Dernier_Element(Code) = Octet/128
   --
   -- Exemples :
   --   Si Octet = 01110100, i = 7, Code = 01
   --       Actualiser(Octet, i, Code) -> Octet = 11101000, i = 6, Code = 010
   --   Si Octet = 11100100, i = 5, Code = 10
   --       Actualiser(Octet, i, Code) -> Octet = 11001000, i = 4, Code = 101
   procedure Actualiser(Octet : in out T_Octet; i : in out Integer; Code : in out Pack_Bit_Liste.T_Liste) is
      Bit : T_Bit;
   begin
      Bit := T_Bit(Octet/128);
      Octet := Octet*2;
      i := i-1;
      Ajouter_Fin(Code, Bit);
   end Actualiser;

   -- Objectif :
   --    Ecire un octet dans le fichier decompresse si le code est la clÃ© de cet octet dans la table de dÃ©codage.
   --    Si le code est bien la clÃ© d'un octet, alors on rÃ©initialise le code
   --
   -- Nom :
   --    Ecrire_Octet_Si_Besoin
   --
   -- Parametres :
   --     Table_Decodage : In T_SDA - La table de dÃ©codage
   --     S : In Out Stream_Access - Le stream permettant d'Ã©cire dans le fichier
   --     Code : In Out Pack_Bit_Liste.T_Liste - Le code actuel
   --
   -- Exemples :
   --     On prend Table_Decodage = (001 | 35) --> (01 |Â 90), S le stream du fichier oÃ¹ Ã©crire
   --     Si Code = 011:
   --         Ecrire_Octet_Si_Besoin(Table_Decodage, S, Code) -> Ne fait rien
   --     Si Code = 01:
   --         Ecrire_Octet_Si_Besoin(Table_Decodage, S, Code) -> Code = Vide, et on Ã©crit l'octet 90 Ã  la fin du fichier dont le stream est S
   procedure Ecrire_Octet_Si_Besoin(Arbre_Huffman : in T_Arbre; S : in out Stream_Access; Code  : in out Pack_Bit_Liste.T_Liste) is
      Chemin : Integer;
   begin
      Chemin := Conv_Code_Chemin(Code);
      if Est_Feuille_Chemin(Arbre_Huffman, Chemin) then
         T_Octet'Write(S, Element_Chemin(Arbre_Huffman, Chemin));
         Vider(Code);
      end if;
   end Ecrire_Octet_Si_Besoin;
   -----------------------------------------------------------------------------
   -------------------------------- Raffinage 3 --------------------------------
   -----------------------------------------------------------------------------

   -- Objectif :
   --    Permet de rÃ©cupÃ©rer la suite d'octets prÃ©sent au dÃ©but d'un fichier, et de mettre l'octet -1 (fin de fichier)
   --    Ã  l'indice correspondant au premier octets trouvÃ©.
   --
   -- Nom :
   --    Recuperer_Suite_Octet
   --
   -- Parametres :
   --     S_C : In Out Stream_Access - Le stream permettant de lire le fichier
   --     Suite_Octets : Out Pack_Octet_Liste.T_Liste
   --
   -- Preconditions :
   --     Existe deux octets Ã©gaux Ã  la suite dans le fichier
   --
   -- Exemples :
   --     Si le fichier vaut 3-48-234-0-17-17-99-...-129-255
   --        Recuperer_Suite_Octet(S_C, Suite_Octets) -> Suite_Octets = 48->234->0->255->17 et le curseur de S_C se situe aprÃ¨s le deuxiÃ¨me 17
   --     Si le fichier vaut 1-48-234-0-17-17-99-...-129-255
   --        Recuperer_Suite_Octet(S_C, Suite_Octets) -> Suite_Octets = 48->255->234->0->17 et le curseur de S_C se situe aprÃ¨s le deuxiÃ¨me 17
   procedure Recuperer_Suite_Octet(S_C : in out Stream_Access; Suite_Octets : out Pack_Octet_Liste.T_Liste) is
      Ind_Fin_Fichier : Integer;
      Octet : T_Octet;
      Octet_Pre : T_Octet;
   begin
      Ind_Fin_Fichier := Integer(T_Octet'Input(S_C));
      Octet_Pre := T_Octet(Ind_Fin_Fichier);
      Initialiser(Suite_Octets);
      Octet := T_Octet'Input(S_C);
      while Octet /= Octet_Pre loop
         Ajouter_Fin(Suite_Octets, Octet);
         Octet_Pre := Octet;
         Octet := T_Octet'Input(S_C);
      end loop;
      Ajouter_Indice(Suite_Octets, -1, Ind_Fin_Fichier);
   end Recuperer_Suite_Octet;

   -- Objectif :
   --    Creer l'abre de huffman à partir de la suite de bit au debut du fichier compresse
   --
   -- Nom :
   --    Creer_Arbre_Huffman
   --
   -- Parametres :
   --    S_C : In Out Stream_Access - Le stream permettant la lecture du fichier
   --    Suite_Octets : In Out Pack_Octet_Liste.T_Liste - Liste des octets correspond aux caractères à mettre dans l'arbre
   --    Arbre_Huffman : Out T_Arbre -- Arbre qui va être créé
   --    Octet : Out T_Octet - Le dernier octet qui a été lu, et dont on a enlevé les bits utilisés pour créer l'arbre
   --    i : Out Integer - Le nombre de bit utile restant Ã  l'octet
   --
   -- Precondition :
   --   Le nombre de bit égal a  1 dans le fichier >= Taille(Suite_Octets)
   --
   -- Postcondition :
   --   Est_Vide(Suite_Octets)
   --
   -- Exemples :
   --     Fichier : "01000000 01100000 01010000"
   --     Creer_Arbre_Huffman(S_C, Suite_Octets, Arbre_Huffman, Octet, i) --> Arbre_Huffman : Element=0, Valeur = 4, ArbreG = ( (a) | 2), ArbreD = ( (b) | 2)
   --
   procedure Creer_Arbre_Huffman(S_C : in out Stream_Access; Suite_Octets : in out Pack_Octet_Liste.T_Liste; Arbre_Huffman : out T_Arbre; Octet : out T_Octet; i: out Integer) is
      Bit : T_Bit;
      Code : Pack_Bit_Liste.T_Liste;
   begin
      Octet := 0;
      Initialiser(Code);
      Initialiser_Valeur(Arbre_Huffman, 0, 0);
      loop
         Octet := T_Octet'Input(S_C);
         i := 8;
         loop
            Bit := T_Bit(Octet/128);
            Octet := Octet * 2;
            i := i-1;
            if Option = BAVARD then
               Affichage_Bit(Bit);
            end if;
            Agir_Selon_Bit(Arbre_Huffman, Bit, Suite_Octets, Code);
            exit when i = 0 or Est_Vide(Code);
         end loop;
         exit when Est_Vide(Code);
      end loop;
   end Creer_Arbre_Huffman;


   -----------------------------------------------------------------------------
   -------------------------------- Raffinage 2 --------------------------------
   -----------------------------------------------------------------------------

   -- Objectif :
   --    RecupÃ©rer les paramÃ¨tres lors de l'appel de la procedure decompression.
   --    Si l'utilisateur ne rentre aucune ou trop de paramÃ¨tre, une CONSTRAINT_ERROR est levÃ©.
   --    Si l'utilisateur ne rentre pas un fichier compressÃ© (n'ayant pas l'extension .hff), CONSTRAINT_ERROR est levÃ©, avec un message d'erreur.
   --
   -- Nom :
   --    Recuperer_Parametre
   --
   -- Parametres :
   --     Nom_Du_Fichier_Compresse : Out Unbounded_String - Le nom du fichier Ã  dÃ©compresser
   --     Option : Out T_Option : L'option de l'utilisateur. Soit NORMAL (pas d'affichage), soit MINIBAVARD (affichage apide), soit BAVARD (affichage complet)
   --
   -- Exemples :
   --     Lors de l'appel dans un terminal :
   --         ./decompression Exemple.hff
   procedure Recuperer_Parametre(Nom_Du_Fichier_Compresse : out Unbounded_String; Option : out T_Option) is
      n : Integer;
   begin
       case (Argument_Count) is
      	when (1) => Nom_Du_Fichier_Compresse := To_Unbounded_String(Argument(1));
      	            Option := NORMAL;
      	when (2) => Nom_Du_Fichier_Compresse := To_Unbounded_String(Argument(2));
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
                       Put("Syntaxe incorrect. Merci de rentrer une syntaxe correct : ./cdeompresser [OPT] {nom_du_fichier}");
                       raise CONSTRAINT_ERROR;
      end case;
      n := Length(Nom_Du_Fichier_Compresse);
      if To_String(Nom_Du_Fichier_Compresse)((n-3)..n) /= ".hff" then
         Put_Line("Merci de rentrer le nom d'un fichier compresse possedant l'extension .hff");
         raise CONSTRAINT_ERROR;
      end if;
   end Recuperer_Parametre;

   -- Objectif :
   --    Calculer la table de dÃ©codage en rÃ©cupÃ©rant la suite d'octets
   --
   -- Nom :
   --    Calcul_Table_Decodage
   --
   -- Parametres :
   --    S_C : In Out Stream_Access - Le stream permettant de lire le fichier compresse
   --    Table_Decodage : Out T_SDA - La table de dÃ©codage a calculer
   --    Octet : Out T_Octet - Le dernier Octet lu oÃ¹ on a dÃ©ja enlevÃ© les bits utilisÃ©
   --    i : Out Integer - Le nombre de bits utile restant dans l'Octet
   --
   -- Exemples :
   --    Les nombres avec un tirets sont les Octets Ã©cris en dÃ©cimaux. Les autres sont Ã©cris en binaire
   --    Si le fichier vaut : 3-48-234-0-17-17-0011001110101100...
   --        Calcul_Table_Decodage(S_C, Table_Decodage, Octet, i)
   --                     -> Table_Decodage = (00 | 48) -> (01Â | 234) -> (100 | 0) -> (101 | 255) -> (11 | 17), Octet =01011000, i = 7 et le curseur de S_C se situe juste avant les "..."
   procedure Calcul_Arbre_Huffman(S_C :in out Stream_Access; Arbre_Huffman : out T_Arbre; Octet : out T_Octet; i: out Integer) is
      Suite_Octets : Pack_Octet_Liste.T_Liste;
   begin
      if Option = BAVARD then
         Put_Line("Recuperation de la suite d'octets ...");
      end if;
      Recuperer_Suite_Octet(S_C, Suite_Octets);
      if Option = BAVARD then
         New_Line;
         Affichage_LOctet(Suite_Octets);
         New_Line;
         New_Line;
         Put_Line("Recuperation de la suite de bits et cr�ation de l'arbre...");
      end if;
      Creer_Arbre_Huffman(S_C, Suite_Octets, Arbre_Huffman, Octet, i);
      if Option = BAVARD then
         New_Line;
         Put_Line("Arbre de Huffman ... ");
         Afficher(Arbre_Huffman);
      end if;
      Vider(Suite_Octets);
   end Calcul_Arbre_Huffman;

   -- Objectif :
   --    Ecire le fichier decompresse grace au fichier compresse
   --
   -- Nom :
   --     Ecrire_Fichier
   --
   -- Parametres :
   --     S : In Out Stream_Access - Le stream permettant d'Ã©crire dans le fichier decompresse
   --     S_C : In Out Stream_Access - Le stream permettant de lire dans le fichier compressse
   --     Table_Decodage : In T_SDA - La table de dÃ©codage pour dÃ©coder le fichier compresse
   --     Octet : In Out T_Octet - Le dernier Octet dÃ©ja lu avec seulement les bits utiles restants
   --     i : In Out Integer - Le nombre de bits utiles restants a l'Octet
   --
   -- Exemples :
   --     Table_Decodage = (00 | 48) -> (01Â | 234) -> (100 | 0) -> (101 | 255) -> (11 | 17)
   --     Ce qui reste Ã  lire dans le fichier compressÃ© : 001001100101100010010100
   --     Ecrire_Fichier(S,S_C,Table_Decodage, Octet, i) -> Dans le fichier dÃ©compressÃ© est Ã©crit : 48-0-17-48-255-0-234-48-255 (Octet = 00000000, i = 2)
   procedure Ecrire_Fichier(S : in out Stream_Access; S_C : Stream_Access; Arbre_Huffman : in T_Arbre; Octet : in out T_Octet; i : in out Integer) is
      Code : Pack_Bit_Liste.T_Liste;
      Chemin : Integer;
   begin
      Initialiser(Code);
      Chemin := 1;
      while not (Element_Chemin(Arbre_Huffman, Chemin) = -1 and End_Of_File(Fichier_Compresse)) loop
         while i /= 0 and (not (Element_Chemin(Arbre_Huffman, Chemin) = -1 and End_Of_File(Fichier_Compresse))) loop
            Ecrire_Octet_Si_Besoin(Arbre_Huffman, S, Code);
            Actualiser(Octet,i,Code);
            Chemin := Conv_Code_Chemin(Code);
         end loop;
         if not (Element_Chemin(Arbre_Huffman, Chemin) = -1 and End_Of_File(Fichier_Compresse)) then
            Octet := T_Octet'Input(S_C);
            i := 8;
         end if;
      end loop;
      Vider(Code);

   end Ecrire_Fichier;

   -----------------------------------------------------------------------------
   -------------------------------- Raffinage 1 --------------------------------
   -----------------------------------------------------------------------------
begin

   Recuperer_Parametre(Nom_Du_Fichier_Compresse, Option);

   if Option >= MINIBAVARD then
     Put_Line("Decompression de '"&To_String(Nom_Du_Fichier_Compresse)&"' ...");
   end if;
   begin
      Open(Fichier_Compresse, In_File, To_String(Nom_Du_Fichier_Compresse));
   exception when others => Put("Impossible d'ouvrir le fichier compress�. Etes vous sur d'avoir donn� le nom d'un fichier correct ?");
                         raise Constraint_Error;
   end;
   S_C := Stream(Fichier_Compresse);

   Calcul_Arbre_Huffman(S_C, Arbre_Huffman, Octet, i);
   Create(Fichier, Out_File, To_String(Nom_Du_Fichier_Compresse)(1..(Length(Nom_Du_Fichier_Compresse)-4)));
   if Option = BAVARD then
      New_Line;
      Afficher(Arbre_Huffman);
      New_Line;
   end if;

   if Option >= MINIBAVARD then
      Put_Line("Ecriture du fichier decompresse ...");
   end if;


   S := Stream(Fichier);
   Ecrire_Fichier(S, S_C, Arbre_Huffman, Octet, i);
   if Option = MINIBAVARD or Option = BAVARD then
     Put("Decompression de '"&To_String(Nom_Du_Fichier_Compresse)&"' terminee");
   end if;
   Close(Fichier);
   Close(Fichier_Compresse);
   Vider(Arbre_Huffman);
   exception when others => New_Line;
       Put("Arret du programme");
end decompresser;
