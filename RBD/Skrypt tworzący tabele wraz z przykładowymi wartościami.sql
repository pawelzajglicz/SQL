DROP TABLE PRODUKTY CASCADE CONSTRAINTS;

DROP TABLE TYP CASCADE CONSTRAINTS;

DROP TABLE PRACOWNICY CASCADE CONSTRAINTS;

DROP TABLE MATERIAL CASCADE CONSTRAINTS;

DROP TABLE OBROBKI CASCADE CONSTRAINTS;

DROP TABLE OBROBKI_NS CASCADE CONSTRAINTS;

DROP TABLE NARZEDZIAISUROWCE CASCADE CONSTRAINTS;

DROP TABLE PRODUKT_OBROBKA CASCADE CONSTRAINTS;


CREATE TABLE PRODUKTY (
			 NUMER_SERYJNY NUMBER(38) PRIMARY KEY,
			 NAZWA VARCHAR2(20) NOT NULL,
             MATERIAL NUMBER (38) NOT NULL,
             PRACOWNIK NUMBER (38) NOT NULL,
             TYP NUMBER (38) NOT NULL
);

CREATE TABLE TYP (
			 ID_TYP NUMBER(38) PRIMARY KEY,
			 NAZWA VARCHAR2(20) NOT NULL,
			 NR_RYSUNKU VARCHAR2(20) NOT NULL,
             KONSTRUKTOR NUMBER(38) NOT NULL
);

CREATE TABLE PRACOWNICY(
			 ID_PRACOWNIK NUMBER(38) PRIMARY KEY,
			 PENSJA NUMBER(38) NOT NULL,
			 DATA_URODZENIA DATE NOT NULL,
			 DATA_ZATRUDNIENIA DATE NOT NULL,
			 IMIE VARCHAR2(20) NOT NULL,
			 NAZWISKO VARCHAR2(20) NOT NULL,
			 STANOWISKO VARCHAR2(30) NOT NULL,
             KIEROWNIK NUMBER (38)
);

CREATE TABLE MATERIAL(
			 ID_MATERIAL NUMBER(38) PRIMARY KEY,
			 GATUNEK VARCHAR2(20) NOT NULL,
			 GRANICA_PLASTYCZNOSCI NUMBER(38) NOT NULL,
			 GRANICA_WYTRZYMALOSCI NUMBER(38) NOT NULL,
			 GESTOSC NUMBER(38) NOT NULL
);

CREATE TABLE OBROBKI(
	ID_OBROBKA NUMBER(38) PRIMARY KEY,
	OPIS VARCHAR(500) NOT NULL
);

CREATE TABLE OBROBKI_NS(
             ID_OBROBKA NUMBER (38),
             ID_NS NUMBER (38),
			 ILOSC NUMBER(38) NOT NULL,
             PRIMARY KEY (ID_OBROBKA, ID_NS)
);

CREATE TABLE NARZEDZIAISUROWCE(
			 ID NUMBER(38) PRIMARY KEY,
			 NAZWA VARCHAR2(20) NOT NULL,
			 OPIS VARCHAR2(200)
);

CREATE TABLE PRODUKT_OBROBKA(
			 ID_PRODUKT NUMBER(38),
			 ID_OBROBKA NUMBER(38),
             PRIMARY KEY (ID_PRODUKT, ID_OBROBKA)
);


ALTER TABLE PRODUKTY ADD CONSTRAINT FK_PRODUKTY_MATERIAL FOREIGN KEY (MATERIAL) REFERENCES MATERIAL;
ALTER TABLE PRODUKTY ADD CONSTRAINT FK_PRODUKTY_PRACOWNIK FOREIGN KEY (PRACOWNIK) REFERENCES PRACOWNICY; 
ALTER TABLE PRODUKTY ADD CONSTRAINT FK_PRODUKTY_TYP FOREIGN KEY (TYP) REFERENCES TYP;

ALTER TABLE TYP ADD CONSTRAINT FK_TYP_PRACOWNICY FOREIGN KEY (KONSTRUKTOR) REFERENCES PRACOWNICY;

ALTER TABLE PRACOWNICY ADD CONSTRAINT FK_PRACOWNICY_PRACOWNICY FOREIGN KEY (KIEROWNIK) REFERENCES PRACOWNICY;

ALTER TABLE PRODUKT_OBROBKA ADD CONSTRAINT FK_PRODUKTY_PRODUKT_OBROBKA FOREIGN KEY (ID_PRODUKT) REFERENCES PRODUKTY;
ALTER TABLE PRODUKT_OBROBKA ADD CONSTRAINT FK_OBROBKI_PRODUKT_OBROBKA FOREIGN KEY (ID_OBROBKA) REFERENCES OBROBKI;

ALTER TABLE OBROBKI_NS ADD CONSTRAINT FK_OBROBKI_NS_OBROBKI FOREIGN KEY (ID_OBROBKA) REFERENCES OBROBKI;
ALTER TABLE OBROBKI_NS ADD CONSTRAINT FK_OBROBKI_NS_NARZEDZIAISUROWC FOREIGN KEY (ID_NS) REFERENCES NARZEDZIAISUROWCE;

INSERT INTO MATERIAL(ID_MATERIAL, GATUNEK, GRANICA_PLASTYCZNOSCI, GRANICA_WYTRZYMALOSCI, GESTOSC) VALUES (1, 'Miedz techniczna', 33, 210, 8.93);
INSERT INTO MATERIAL(ID_MATERIAL, GATUNEK, GRANICA_PLASTYCZNOSCI, GRANICA_WYTRZYMALOSCI, GESTOSC) VALUES (2, 'Aluminium 6082-T6', 255, 300, 2.70);
INSERT INTO MATERIAL(ID_MATERIAL, GATUNEK, GRANICA_PLASTYCZNOSCI, GRANICA_WYTRZYMALOSCI, GESTOSC) VALUES (3, 'Stal St3S', 340, 400, 7.87);
INSERT INTO MATERIAL(ID_MATERIAL, GATUNEK, GRANICA_PLASTYCZNOSCI, GRANICA_WYTRZYMALOSCI, GESTOSC) VALUES (4, 'Stal 316L', 200, 605, 7.85);

INSERT INTO PRACOWNICY(ID_PRACOWNIK, PENSJA, DATA_URODZENIA, DATA_ZATRUDNIENIA, IMIE, NAZWISKO, STANOWISKO, KIEROWNIK)
            VALUES (1, 5500, '1972-06-17', '1995-03-12', 'STEFAN', 'HULA', 'DYREKTOR', NULL);
INSERT INTO PRACOWNICY(ID_PRACOWNIK, PENSJA, DATA_URODZENIA, DATA_ZATRUDNIENIA, IMIE, NAZWISKO, STANOWISKO, KIEROWNIK)
            VALUES (2, 4000, '1990-07-15', '2006-04-20', 'IWONA', 'PTAK', 'KSIEGOWA', 1);
INSERT INTO PRACOWNICY(ID_PRACOWNIK, PENSJA, DATA_URODZENIA, DATA_ZATRUDNIENIA, IMIE, NAZWISKO, STANOWISKO, KIEROWNIK)
            VALUES (3, 3500, '1981-12-07', '1995-04-17', 'MACIEJ', 'DINO', 'SPRZEDAWCA', 1);
INSERT INTO PRACOWNICY(ID_PRACOWNIK, PENSJA, DATA_URODZENIA, DATA_ZATRUDNIENIA, IMIE, NAZWISKO, STANOWISKO, KIEROWNIK)
            VALUES (4, 3000, '1977-01-17', '1996-12-11', 'ANDRZEJ', 'SZYMCZAK', 'BRYGADZISTA', 1);
INSERT INTO PRACOWNICY(ID_PRACOWNIK, PENSJA, DATA_URODZENIA, DATA_ZATRUDNIENIA, IMIE, NAZWISKO, STANOWISKO, KIEROWNIK)
            VALUES (5, 2800, '1979-08-27', '1999-07-12', 'MAREK', 'HUMBAK', 'PRACOWNIK PRODUKCYJNY', 4);
INSERT INTO PRACOWNICY(ID_PRACOWNIK, PENSJA, DATA_URODZENIA, DATA_ZATRUDNIENIA, IMIE, NAZWISKO, STANOWISKO, KIEROWNIK)
            VALUES (6, 2700, '1975-01-07', '1997-03-12', 'STEFAN', 'RYBA', 'PRACOWNIK PRODUKCYJNY', 4);
INSERT INTO PRACOWNICY(ID_PRACOWNIK, PENSJA, DATA_URODZENIA, DATA_ZATRUDNIENIA, IMIE, NAZWISKO, STANOWISKO, KIEROWNIK)
            VALUES (7, 3000, '1986-10-17', '2012-08-06', 'MARIA', 'KOT', 'MLODSZA KSIEGOWA', 2);
INSERT INTO PRACOWNICY(ID_PRACOWNIK, PENSJA, DATA_URODZENIA, DATA_ZATRUDNIENIA, IMIE, NAZWISKO, STANOWISKO, KIEROWNIK)
            VALUES (8, 4000, '1976-12-25', '1997-09-04', 'JAN', 'PIES', 'KONSTRUKTOR', 1);
INSERT INTO PRACOWNICY(ID_PRACOWNIK, PENSJA, DATA_URODZENIA, DATA_ZATRUDNIENIA, IMIE, NAZWISKO, STANOWISKO, KIEROWNIK)
            VALUES (9, 4000, '1978-02-15', '1997-11-15', 'ELZBIETA', 'WALEC', 'KONSTRUKTOR', 1);
            
                       
INSERT INTO TYP(ID_TYP, NAZWA, NR_RYSUNKU, KONSTRUKTOR) VALUES (1, 'PLASKOWNIK', 'PL-1A', 8);
INSERT INTO TYP(ID_TYP, NAZWA, NR_RYSUNKU, KONSTRUKTOR) VALUES (2, 'BULBULATOR', 'BLB-2C', 9);
INSERT INTO TYP(ID_TYP, NAZWA, NR_RYSUNKU, KONSTRUKTOR) VALUES (3, 'KSZTALTOWNIK-T', 'KT-1B', 9);
INSERT INTO TYP(ID_TYP, NAZWA, NR_RYSUNKU, KONSTRUKTOR) VALUES (4, 'RURA', 'RR-5A', 8);
INSERT INTO TYP(ID_TYP, NAZWA, NR_RYSUNKU, KONSTRUKTOR) VALUES (5, 'DRUT', 'DR-1A', 9);
INSERT INTO TYP(ID_TYP, NAZWA, NR_RYSUNKU, KONSTRUKTOR) VALUES (6, 'GLOWKA-MLOTKA', 'GM-2A', 8);

INSERT INTO PRODUKTY(NUMER_SERYJNY, NAZWA, MATERIAL, PRACOWNIK, TYP) VALUES (1, 'PL-AL', 2, 5, 1);
INSERT INTO PRODUKTY(NUMER_SERYJNY, NAZWA, MATERIAL, PRACOWNIK, TYP) VALUES (2, 'PL-ST', 3, 6, 1);
INSERT INTO PRODUKTY(NUMER_SERYJNY, NAZWA, MATERIAL, PRACOWNIK, TYP) VALUES (3, 'BLB-MD', 1, 5, 2);
INSERT INTO PRODUKTY(NUMER_SERYJNY, NAZWA, MATERIAL, PRACOWNIK, TYP) VALUES (4, 'GM-ST', 3, 5, 6);
INSERT INTO PRODUKTY(NUMER_SERYJNY, NAZWA, MATERIAL, PRACOWNIK, TYP) VALUES (5, 'BLB-AL', 2, 6, 2);
INSERT INTO PRODUKTY(NUMER_SERYJNY, NAZWA, MATERIAL, PRACOWNIK, TYP) VALUES (6, 'BLB-ST', 3, 6, 2);
INSERT INTO PRODUKTY(NUMER_SERYJNY, NAZWA, MATERIAL, PRACOWNIK, TYP) VALUES (7, 'GM-MD', 1, 5, 6);
INSERT INTO PRODUKTY(NUMER_SERYJNY, NAZWA, MATERIAL, PRACOWNIK, TYP) VALUES (8, 'RR-MD', 1, 5, 4);
INSERT INTO PRODUKTY(NUMER_SERYJNY, NAZWA, MATERIAL, PRACOWNIK, TYP) VALUES (9, 'RR-AL', 2, 6, 4);

INSERT INTO OBROBKI(ID_OBROBKA, OPIS) VALUES(1,'Hartowanie z 800 stopni');
INSERT INTO OBROBKI(ID_OBROBKA, OPIS) VALUES(2,'Odpuszczanie w 300 stopniach');
INSERT INTO OBROBKI(ID_OBROBKA, OPIS) VALUES(3,'Normalizacja');
INSERT INTO OBROBKI(ID_OBROBKA, OPIS) VALUES(4,'Odpuszczanie w 550 stopniach');
INSERT INTO OBROBKI(ID_OBROBKA, OPIS) VALUES(5,'Przesycanie z 700 stopni');
INSERT INTO OBROBKI(ID_OBROBKA, OPIS) VALUES(6,'Starzenie w 400 stopniach');
INSERT INTO OBROBKI(ID_OBROBKA, OPIS) VALUES(7,'Starzenie w 450 stopniach');
INSERT INTO OBROBKI(ID_OBROBKA, OPIS) VALUES(8,'BRAK');
INSERT INTO OBROBKI(ID_OBROBKA, OPIS) VALUES(9,'Malowanie');
INSERT INTO OBROBKI(ID_OBROBKA, OPIS) VALUES(10,'Szlifowanie');
INSERT INTO OBROBKI(ID_OBROBKA, OPIS) VALUES(11,'Wykrajanie');

INSERT INTO PRODUKT_OBROBKA(ID_PRODUKT, ID_OBROBKA) VALUES (1, 6);
INSERT INTO PRODUKT_OBROBKA(ID_PRODUKT, ID_OBROBKA) VALUES (1, 7);
INSERT INTO PRODUKT_OBROBKA(ID_PRODUKT, ID_OBROBKA) VALUES (2, 1);
INSERT INTO PRODUKT_OBROBKA(ID_PRODUKT, ID_OBROBKA) VALUES (2, 2);
INSERT INTO PRODUKT_OBROBKA(ID_PRODUKT, ID_OBROBKA) VALUES (1, 5);
INSERT INTO PRODUKT_OBROBKA(ID_PRODUKT, ID_OBROBKA) VALUES (2, 4);
INSERT INTO PRODUKT_OBROBKA(ID_PRODUKT, ID_OBROBKA) VALUES (3, 8);
INSERT INTO PRODUKT_OBROBKA(ID_PRODUKT, ID_OBROBKA) VALUES (6, 1);
INSERT INTO PRODUKT_OBROBKA(ID_PRODUKT, ID_OBROBKA) VALUES (6, 4);
INSERT INTO PRODUKT_OBROBKA(ID_PRODUKT, ID_OBROBKA) VALUES (4, 1);
INSERT INTO PRODUKT_OBROBKA(ID_PRODUKT, ID_OBROBKA) VALUES (4, 2);
INSERT INTO PRODUKT_OBROBKA(ID_PRODUKT, ID_OBROBKA) VALUES (4, 9);

INSERT INTO NARZEDZIAISUROWCE(ID, NAZWA, OPIS) VALUES (1, 'Woda', 'Woda do hartowania');
INSERT INTO NARZEDZIAISUROWCE(ID, NAZWA, OPIS) VALUES (2, 'Olej', 'Olej do hartowania');
INSERT INTO NARZEDZIAISUROWCE(ID, NAZWA, OPIS) VALUES (3, 'Piec', 'Piec hartownicze');
INSERT INTO NARZEDZIAISUROWCE(ID, NAZWA, OPIS) VALUES (4, 'Wanna mala', 'Wanna do hartowania o malych wymiarach');
INSERT INTO NARZEDZIAISUROWCE(ID, NAZWA, OPIS) VALUES (5, 'Wanna duza', 'Wanna do hartowania o duzych wymiarach');
INSERT INTO NARZEDZIAISUROWCE(ID, NAZWA, OPIS) VALUES (6, 'Wykrojnik', 'Wykrojnik laserowy');
INSERT INTO NARZEDZIAISUROWCE(ID, NAZWA, OPIS) VALUES (7, 'Szlifierka', 'Szlifierka ręczna');
INSERT INTO NARZEDZIAISUROWCE(ID, NAZWA, OPIS) VALUES (8, 'Spawarka', 'Spawarka MIG-MAG');
INSERT INTO NARZEDZIAISUROWCE(ID, NAZWA, OPIS) VALUES (9, 'Farba nb', 'Farba niebieska');

INSERT INTO OBROBKI_NS(ID_OBROBKA, ID_NS, ILOSC) VALUES(1, 2, 15);
INSERT INTO OBROBKI_NS(ID_OBROBKA, ID_NS, ILOSC) VALUES(1, 1, 15);
INSERT INTO OBROBKI_NS(ID_OBROBKA, ID_NS, ILOSC) VALUES(1, 4, 1);
INSERT INTO OBROBKI_NS(ID_OBROBKA, ID_NS, ILOSC) VALUES(2, 3, 1);
INSERT INTO OBROBKI_NS(ID_OBROBKA, ID_NS, ILOSC) VALUES(9, 9, 7);
INSERT INTO OBROBKI_NS(ID_OBROBKA, ID_NS, ILOSC) VALUES(10, 7, 1);
INSERT INTO OBROBKI_NS(ID_OBROBKA, ID_NS, ILOSC) VALUES(11, 6, 1);
INSERT INTO OBROBKI_NS(ID_OBROBKA, ID_NS, ILOSC) VALUES(5, 3, 1);
INSERT INTO OBROBKI_NS(ID_OBROBKA, ID_NS, ILOSC) VALUES(5, 1, 15);
INSERT INTO OBROBKI_NS(ID_OBROBKA, ID_NS, ILOSC) VALUES(7, 3, 1);