-- Procedura zwracajaca informacje o sredniej gestosci produktow, ktore wytworzyl pracownik, ktorego id podano jako parametr

CREATE OR REPLACE Procedure SredniaGestosc (p_id_prac Int)
AS
v_srednia material.gestosc%type;
v_name Varchar(30);
v_info Varchar2(200);
BEGIN
  SELECT AVG(gestosc) INTO v_srednia FROM material 
  JOIN produkty ON material.id_material = produkty.material
  JOIN pracownicy ON produkty.pracownik = pracownicy.id_pracownik
  WHERE id_pracownik = p_id_prac;

  SELECT imie || ' ' || nazwisko INTO v_name FROM pracownicy WHERE pracownicy.id_pracownik = p_id_prac;
  
  IF v_srednia IS NULL
  THEN
      v_info := 'Pracownik ' || v_name || ' o id ' || p_id_prac || ' nie wytworzyl zadnych produktow.';
  ELSE
      v_info := 'Srednia gestosc produktow, ktore wytworzyl pracownik ' || v_name || ' o id ' || p_id_prac || ' wynosi ' || v_srednia;
  END IF;
  
  dbms_output.put_line(v_info);
END;

-- Procedura zwiekszajaca pensje pracownikom pracujacym z narzedziem lub surowcem, ktorego id podano jako parametr o tyle procent, ile pracuja w firmie 
CREATE OR REPLACE Procedure podwyzkans (p_id_ns Int)
AS
  CURSOR pracns IS SELECT id_pracownik, data_zatrudnienia, pensja FROM pracownicy
  JOIN produkty ON produkty.pracownik = pracownicy.id_pracownik
  JOIN produkt_obrobka ON produkty.numer_seryjny = produkt_obrobka.id_produkt
  JOIN obrobki ON obrobki.id_obrobka = produkt_obrobka.id_obrobka
  JOIN obrobki_ns ON obrobki_ns.id_obrobka = obrobki.id_obrobka
  JOIN narzedziaisurowce ON obrobki_ns.id_obrobka = narzedziaisurowce.id
  WHERE narzedziaisurowce.id = p_id_ns;
 
 v_proc FLOAT(32);
 v_id_prac pracownicy.id_pracownik%type;
 v_data_zat pracownicy.data_zatrudnienia%type;
 v_pensja pracownicy.pensja%type;
BEGIN
  OPEN pracns;
  LOOP FETCH pracns INTO v_id_prac, v_data_zat, v_pensja;
  EXIT WHEN pracns%NotFound;
    SELECT ((EXTRACT (YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM (SELECT data_zatrudnienia FROM pracownicy WHERE id_pracownik = v_id_prac))) / 100)
    INTO v_proc FROM dummy;
    UPDATE pracownicy SET pensja = v_pensja + v_pensja * v_proc WHERE id_pracownik = v_id_prac;
  END LOOP;    
END;


-- Wyzwalacz nie pozwalajacy na tworzenie bulbulatorow z innych materialow niz aluminium (dla jednego wstawianego rekordu)

CREATE OR REPLACE TRIGGER TylkoAlBlb 
BEFORE INSERT ON produkty
FOR EACH ROW
DECLARE
  v_mat_gat material.gatunek%type;
  v_typ_nazwa typ.nazwa%type;
BEGIN
  SELECT gatunek INTO v_mat_gat FROM material WHERE material.id_material = :new.material;
  SELECT nazwa INTO v_typ_nazwa FROM typ WHERE typ.id_typ = :new.typ;

  IF ((v_mat_gat NOT LIKE 'Aluminium%') AND (v_typ_nazwa LIKE 'BULBULATOR'))
  THEN 
    raise_application_error(-20320,'Bulbulatory moga byc tylko aluminiowe!');
  END IF;
END;

-- Wyzwalacz zapewniajacy unikalnosc kolumny 'gatunek' w tabeli 'material'

CREATE OR REPLACE TRIGGER UnikGat
AFTER INSERT OR UPDATE ON material
DECLARE
  v_bef INT;
  v_aft INT;
BEGIN
  SELECT COUNT(1) INTO v_bef FROM (SELECT DISTINCT gatunek FROM material);
  SELECT COUNT(1) id_material INTO v_aft FROM material;

  IF v_bef <> v_aft
  THEN 
    raise_application_error(-20300,'W bazie danych nie może być dwa razy opisany ten sam gatunek!');
  END IF;
END;