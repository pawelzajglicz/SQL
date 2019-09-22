
--Pracownicy zatrudnieni w czwartek
SELECT  id_pracownik, imie, nazwisko, data_zatrudnienia FROM PRACOWNICY WHERE TO_CHAR(pracownicy.data_zatrudnienia, 'DAY') LIKE 'CZWARTEK%';

--Wszystkie produkty wytworzone przez pracownika o id = 5 oprócz plaskownikow oraz produktow miedzianych
SELECT produkty.numer_seryjny, typ.nazwa, material.gatunek FROM produkty
INNER JOIN typ ON produkty.typ = typ.id_typ
INNER JOIN material ON material.id_material = produkty.material
WHERE   produkty.pracownik = 5 AND typ.nazwa <> 'PLASKOWNIK'
INTERSECT
SELECT produkty.numer_seryjny, typ.nazwa, material.gatunek FROM produkty
INNER JOIN typ ON produkty.typ = typ.id_typ
INNER JOIN material ON material.id_material = produkty.material
WHERE   produkty.pracownik = 5 AND material.gatunek <> 'Miedz techniczna';

--Inna wersja tego zapytania
SELECT produkty.numer_seryjny, typ.nazwa, material.gatunek FROM produkty, typ, material
WHERE (produkty.typ = typ.id_typ AND material.id_material = produkty.material) AND
(produkty.pracownik = 5 AND material.gatunek <> 'Miedz techniczna') AND
(produkty.pracownik = 5 AND typ.nazwa <> 'PLASKOWNIK');

--Wszystkie produkty przy produkcji, ktorych stosuje sie olej hartowniczy
SELECT produkty.numer_seryjny, produkty.nazwa FROM produkty
INNER JOIN produkt_obrobka ON produkty.numer_seryjny = produkt_obrobka.id_produkt
--JOIN obrobki USING (id_obrobka)
INNER JOIN obrobki ON obrobki.id_obrobka = produkt_obrobka.id_obrobka
--JOIN obrobki_ns USING (id_obrobka)
INNER JOIN obrobki_ns ON obrobki_ns.id_obrobka = obrobki.id_obrobka
INNER JOIN narzedziaisurowce ON obrobki_ns.id_obrobka = narzedziaisurowce.id
WHERE narzedziaisurowce.nazwa = 'Woda';

--Dla każdego pracownika wyswietl jego przelozonego
SELECT prac.nazwisko Pracownik, kier.nazwisko Kierownik from pracownicy prac, pracownicy kier
WHERE prac.kierownik = kier.id_pracownik;

--Wyswietlenie jakie produkty powstaly z jakich materialow oraz materialow, z ktorych nie wytworzono jeszcze produktow
SELECT material.gatunek, produkty.numer_seryjny, produkty.nazwa FROM material
LEFT OUTER JOIN produkty ON produkty.material = material.id_material ORDER BY material.gatunek;

--Wyswietlenie ile litrow wody potrzeba do wytworzenia wszystkich produktów
SELECT SUM(obrobki_ns.ilosc) FROM produkty
INNER JOIN produkt_obrobka ON produkty.numer_seryjny = produkt_obrobka.id_produkt
INNER JOIN obrobki ON obrobki.id_obrobka = produkt_obrobka.id_obrobka
INNER JOIN obrobki_ns ON obrobki_ns.id_obrobka = obrobki.id_obrobka
INNER JOIN narzedziaisurowce ON obrobki_ns.id_ns = narzedziaisurowce.id
WHERE narzedziaisurowce.nazwa = 'Woda';

--Wyswietlenie obrobek, ktore sa stosowane co najmniej do dwoch produktow
SELECT obrobki.opis, COUNT(*) FROM obrobki
INNER JOIN produkt_obrobka ON obrobki.id_obrobka = produkt_obrobka.id_obrobka
INNER JOIN produkty ON produkty.numer_seryjny = produkt_obrobka.id_produkt
GROUP BY obrobki.opis
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;

--Wypisanie pracownikow zatrudnonych w tym samym roku co pracownik o id 8, bedacych jednoczesnie mlodszymi od niego
SELECT pracownicy.nazwisko FROM pracownicy
WHERE ((TO_CHAR(pracownicy.data_zatrudnienia, 'YYYY') LIKE 
 TO_CHAR((SELECT pracownicy.data_zatrudnienia FROM pracownicy WHERE pracownicy.id_pracownik = 8), 'YYYY'))) AND
 (pracownicy.data_urodzenia > (SELECT pracownicy.data_urodzenia FROM pracownicy WHERE pracownicy.id_pracownik = 8));
 
 --Wypisanie nieużywanych narzędzi i surowcow
SELECT narzedziaisurowce.nazwa FROM narzedziaisurowce
MINUS
SELECT DISTINCT narzedziaisurowce.nazwa FROM narzedziaisurowce
INNER JOIN obrobki_ns ON narzedziaisurowce.id = obrobki_ns.id_ns
INNER JOIN obrobki ON obrobki_ns.id_obrobka = obrobki.id_obrobka
INNER JOIN produkt_obrobka ON obrobki.id_obrobka = produkt_obrobka.id_obrobka
INNER JOIN produkty ON produkt_obrobka.id_produkt = produkty.numer_seryjny;

--Wypisanie produktow, ktore sa malowane
SELECT produkty.nazwa FROM produkty
INNER JOIN produkt_obrobka ON produkty.numer_seryjny = produkt_obrobka.id_produkt
WHERE produkt_obrobka.id_obrobka =
(SELECT produkt_obrobka.id_obrobka FROM produkt_obrobka
WHERE EXISTS (SELECT 'x' FROM produkty
             WHERE produkt_obrobka.id_obrobka = (SELECT obrobki.id_obrobka FROM obrobki WHERE opis = 'Malowanie')));
			 
			 
--Policzenie ile produktow jest wytworzonych z danego materialu
SELECT material.id_material, material.gatunek,
    (SELECT COUNT(*)
    FROM produkty 
    WHERE produkty.material = material.id_material) "Liczba produktow"
FROM material
GROUP BY material.id_material, material.gatunek;
