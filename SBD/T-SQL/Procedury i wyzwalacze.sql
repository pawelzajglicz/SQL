-- Procedura zwracajaca liczbe kosntruktorow pracujacych z materialami, ktorych granica plastycznosci miesci sie w zakresie +-15% od wartosci podanej jako parametr
CREATE PROCEDURE find_konst_plast @Wartosc INT, @Info Varchar(128) Output
 AS
 BEGIN
	DECLARE @Low Int = @Wartosc * 0.85, @High Int = @Wartosc * 1.15;
	SELECT DISTINCT id_pracownik FROM pracownicy
		JOIN typ ON typ.konstruktor = pracownicy.id_pracownik
		JOIN produkty ON typ.id_typ = produkty.typ
		JOIN material ON material.id_material = produkty.material
	WHERE granica_plastycznosci BETWEEN @Low AND @HIGH;
	SET @Info = 'Liczba konstruktorow pracujaca z materialami z zakresu ' + Cast(@Low as Varchar) + ' - ' 
	+ Cast(@High as Varchar) + ' wynosi ' + Cast(@@ROWCOUNT as Varchar) + '.';
END;

DECLARE @Infor Varchar(128);
EXEC find_konst_plast 230, @Infor Output;
Print @Infor;


-- Procedura podwyzszajaca pensje pracownikom wytwarzajacym produkty z materialu o id danym jako parametr o x procent pracownikom pracujacym
-- mniej niz y lat i z procent pozostalym, gdzie x, y i z są dawane jako parametry do procedury
CREATE PROCEDURE Podw_mat @Mat_id INT, @Lata Int, @M_podw Int, @W_podw Int
 AS
 BEGIN
	DECLARE Do_podw CURSOR FOR SELECT DISTINCT id_pracownik, data_zatrudnienia FROM pracownicy
	JOIN produkty ON produkty.pracownik = pracownicy.id_pracownik
	JOIN material ON material.id_material = produkty.material
	WHERE material.id_material = @Mat_id;
	DECLARE @Id_prac Int, @Data_zat Date;
	BEGIN
		OPEN Do_podw
		FETCH NEXT FROM Do_podw INTO @Id_prac, @Data_zat;
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF (SELECT YEAR(GETDATE() -  Cast((SELECT data_zatrudnienia FROM pracownicy WHERE id_pracownik = @Id_prac) As Datetime)) - 1900) < @Lata
				UPDATE pracownicy SET pensja = pensja + pensja * @M_podw / 100 WHERE id_pracownik = @Id_prac;
			ELSE
				UPDATE pracownicy SET pensja = pensja + pensja * @W_podw / 100 WHERE id_pracownik = @Id_prac;
			FETCH NEXT FROM Do_podw INTO @Id_prac, @Data_zat;
		END;
	END;
	CLOSE Do_podw;
	DEALLOCATE Do_Podw;
END;

EXEC Podw_mat 1, 15, 50, 100;

-- Wyzwalacz, ktory podczas usuwania rekordu z tabeli 'NarzedziaISurowce' usuwa wszystkie produkty, przy ktorych produkcji byly one uzywane oraz obrobki podczas, ktorych byly uzywane(dla jednego usuwanego rekordu)
CREATE TRIGGER Del_prod ON narzedziaisurowce
FOR DELETE
AS
Begin

	SELECT numer_seryjny INTO tmp FROM produkty WHERE produkty.numer_seryjny IN (SELECT produkty.numer_seryjny FROM produkty
	JOIN produkt_obrobka ON produkty.numer_seryjny = produkt_obrobka.id_produkt
	JOIN obrobki ON obrobki.id_obrobka = produkt_obrobka.id_obrobka
	JOIN obrobki_ns ON obrobki_ns.id_obrobka = obrobki.id_obrobka
	WHERE obrobki_ns.id_ns = (SELECT id FROM Deleted));

	DELETE FROM produkty WHERE produkty.numer_seryjny IN (SELECT numer_seryjny FROM tmp);
	DELETE FROM produkt_obrobka WHERE produkt_obrobka.id_produkt IN (SELECT numer_seryjny FROM tmp);

	DROP TABLE tmp;

	DELETE FROM obrobki WHERE obrobki.id_obrobka IN (SELECT obrobki.id_obrobka FROM obrobki
	JOIN obrobki_ns ON obrobki_ns.id_obrobka = obrobki.id_obrobka
	WHERE obrobki_ns.id_ns = (SELECT id FROM Deleted));

	DELETE FROM obrobki_ns WHERE obrobki_ns.id_ns IN (SELECT obrobki_ns.id_ns FROM obrobki_ns
	WHERE obrobki_ns.id_ns = (SELECT id FROM Deleted));
END;

-- Wyzwalacz, ktory wymusza, aby nowa pensja byla wyzsza od poprzedniej i nie nizsza niz 3/4 
-- sredniej pensji juz po zmianach pensji
ALTER TRIGGER Sprawdz_placa ON pracownicy
FOR UPDATE
AS
BEGIN
	DECLARE @Srednia075 Int = (SELECT AVG(pensja) FROM
	(SELECT pensja FROM inserted
	 UNION ALL
	 SELECT pensja FROM pracownicy WHERE pracownicy.id_pracownik NOT IN (SELECT id_pracownik FROM inserted)
	) wszystkie_pensje ) * 0.75;

	
	DECLARE Sprawdz_pensja CURSOR FOR SELECT id_pracownik, pensja FROM inserted;
	DECLARE @Id_prac Int, @Pensja Int;
	BEGIN	
		OPEN Sprawdz_pensja
		FETCH NEXT FROM Sprawdz_pensja INTO @Id_prac, @Pensja;
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF (@Pensja < (SELECT pensja FROM deleted WHERE deleted.id_pracownik = @Id_prac) OR @Pensja < @Srednia075)
			BEGIN
				ROLLBACK;
				BREAK;
			END;
			FETCH NEXT FROM Sprawdz_pensja INTO @Id_prac, @Pensja;
		END;
	END;
	CLOSE Sprawdz_pensja;
	DEALLOCATE Sprawdz_pensja;
END;