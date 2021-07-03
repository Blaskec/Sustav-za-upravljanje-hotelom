DROP DATABASE IF EXISTS sustav_za_upravljanje_hotelom;
CREATE DATABASE sustav_za_upravljanje_hotelom;
USE sustav_za_upravljanje_hotelom;

CREATE TABLE mjesto_prebivalista (
	id_mjesto_prebivalista SERIAL AUTO_INCREMENT,
    drzava VARCHAR(50) NOT NULL,
    grad VARCHAR(50) NOT NULL, 
    postanski_broj VARCHAR(20) NOT NULL, 
    adresa VARCHAR(50) NOT NULL,
    CONSTRAINT mjesto_prebivalista_id_mjesto_p_pk PRIMARY KEY (id_mjesto_prebivalista)
); -- ID OD 1000 PA NA DALJE

CREATE TABLE gost (
	id_gost SERIAL AUTO_INCREMENT,
    ime VARCHAR(20) NOT NULL,
    prezime VARCHAR(20) NOT NULL,
    OIB VARCHAR(30) NOT NULL,
    broj_osobne_iskaznice VARCHAR(30) NOT NULL,
    id_mjesto_prebivalista BIGINT UNSIGNED NOT NULL,
    datum_rodenja DATE NOT NULL,
    CONSTRAINT gost_id_gost_pk PRIMARY KEY (id_gost),
    CONSTRAINT gost_broj_oi_uq UNIQUE (broj_osobne_iskaznice),
    CONSTRAINT gost_oib_uq UNIQUE (OIB),
    CONSTRAINT gost_mp_fk FOREIGN KEY (id_mjesto_prebivalista) REFERENCES mjesto_prebivalista(id_mjesto_prebivalista)
); -- ID OD 1 PA NA DALJE

CREATE TABLE zvanje (
	id_zvanje SERIAL AUTO_INCREMENT, 
    naziv VARCHAR(50) NOT NULL,
    opis_posla TEXT NOT NULL,
    plaća_HRK DECIMAL(7,2) NOT NULL,
    CONSTRAINT zvanje_id_zvanje_pk PRIMARY KEY (id_zvanje),
    CONSTRAINT zvanje_plaća_min CHECK (plaća_HRK >= 4000) 
); -- ID OD 50 PA NA DALJE

CREATE TABLE djelatnik (
	id_djelatnik SERIAL AUTO_INCREMENT, 
    ime VARCHAR(20) NOT NULL,
    prezime VARCHAR(20) NOT NULL,
    id_zvanje BIGINT UNSIGNED NOT NULL, 
    datum_zaposljenja DATE NOT NULL,
    CONSTRAINT djelatnik_id_djelatnik_pk PRIMARY KEY (id_djelatnik),
    CONSTRAINT djelatnik_zvanje_fk FOREIGN KEY (id_zvanje) REFERENCES zvanje(id_zvanje)
); -- ID OD 1 PA NA DALJE

CREATE TABLE soba (
	id_soba SERIAL AUTO_INCREMENT, 
	sifra VARCHAR(10) NOT NULL DEFAULT '', 
	kat VARCHAR(10) NOT NULL,
	standardna_cijena DECIMAL(7,2), 
	vrsta VARCHAR(5) NOT NULL,
    CONSTRAINT soba_id_soba_pk PRIMARY KEY (id_soba)
); -- ID OD 100 PA NA DALJE

CREATE TABLE sezona (
	id_sezona SERIAL AUTO_INCREMENT, 
	kategorija CHAR NOT NULL, 
    naziv VARCHAR(15) NOT NULL,
	multiplikator_cijene DECIMAL(4,2) NOT NULL,
    CONSTRAINT sezona_id_sezona_pk PRIMARY KEY (id_sezona)
); -- ID OD 11 PA NA DALJE

CREATE TABLE aranzman (
	id_aranzman SERIAL AUTO_INCREMENT,
	naziv VARCHAR(20) NOT NULL, 
    opis_aranzmana TEXT NOT NULL,
	cijena DECIMAL(7,2) NOT NULL,
    CONSTRAINT aranzman_id_aranzman_pk PRIMARY KEY (id_aranzman)
); -- ID OD 111 PA NA DALJE

CREATE TABLE dodatne_usluge (
	id_dodatne_usluge SERIAL AUTO_INCREMENT, 
    naziv VARCHAR(50) NOT NULL,
    cijena DECIMAL(7,2) NOT NULL,
    CONSTRAINT dodatne_usluge_id_dodatne_u_pk PRIMARY KEY (id_dodatne_usluge)
); -- ID OD 1 PA NA DALJE

CREATE TABLE rezervacija (
	id_rezervacija SERIAL AUTO_INCREMENT, 
    id_soba BIGINT UNSIGNED NOT NULL, 
    id_gost BIGINT UNSIGNED NOT NULL, 
    id_sezona BIGINT UNSIGNED NOT NULL DEFAULT 0, 
    id_aranzman BIGINT UNSIGNED NOT NULL, 
    pocetak_rezervacije DATE NOT NULL, 
    kraj_rezervacije DATE NOT NULL, 
    broj_osoba TINYINT NOT NULL DEFAULT 1,
    CONSTRAINT rezervacija_id_rezervacija_pk PRIMARY KEY (id_rezervacija),
    CONSTRAINT rezervacija_soba_fk FOREIGN KEY (id_soba) REFERENCES soba(id_soba),
    CONSTRAINT rezervacija_gost_fk FOREIGN KEY (id_gost) REFERENCES gost(id_gost),
    CONSTRAINT rezervacija_sezona_fk FOREIGN KEY (id_sezona) REFERENCES sezona(id_sezona),
    CONSTRAINT rezervacija_aranzman_fk FOREIGN KEY (id_aranzman) REFERENCES aranzman(id_aranzman),
    CONSTRAINT rezervacija_check_broj_osoba CHECK (broj_osoba>0)
); -- ID OD 500 PA NA DALJE

CREATE TABLE odabrani_gosti (
	id_odabrani_gost SERIAL AUTO_INCREMENT, 
    id_gost BIGINT UNSIGNED NOT NULL, 
    id_rezervacija BIGINT UNSIGNED NOT NULL,
    CONSTRAINT odabrani_gost_id_odabrani_g_pk PRIMARY KEY (id_odabrani_gost),
    CONSTRAINT odabrani_gost_gost_fk FOREIGN KEY (id_gost) REFERENCES gost(id_gost),
    CONSTRAINT odabrani_gost_rezervacija_fk FOREIGN KEY (id_rezervacija) REFERENCES rezervacija(id_rezervacija) ON DELETE CASCADE
); -- ID OD 100 PA NA DALJE

CREATE TABLE odabrane_usluge (
	id_odabrane_usluge SERIAL AUTO_INCREMENT,  
	id_dodatne_usluge BIGINT UNSIGNED NOT NULL, 
	id_rezervacija BIGINT UNSIGNED NOT NULL, 
    kolicina INTEGER NOT NULL, 
    CONSTRAINT odabrane_usluge_id_odabrane_u_pk PRIMARY KEY (id_odabrane_usluge),
    CONSTRAINT odabrane_usluge_dodatne_u_fk FOREIGN KEY (id_dodatne_usluge) REFERENCES dodatne_usluge(id_dodatne_usluge),
    CONSTRAINT odabrane_usluge_rezervacija_fk FOREIGN KEY (id_rezervacija) REFERENCES rezervacija(id_rezervacija) ON DELETE CASCADE,
    CONSTRAINT odabrane_usluge_check_kolicina CHECK (kolicina>0)
); -- ID OD 10000 PA NA DALJE

CREATE TABLE racun (
	id_racun SERIAL AUTO_INCREMENT, 
	sifra VARCHAR(12) NOT NULL DEFAULT '0-0-0',  
	id_rezervacija BIGINT UNSIGNED NOT NULL,  
	id_djelatnik BIGINT UNSIGNED NOT NULL,  
	datum_i_vrijeme_izdavanja DATETIME NOT NULL,
	ukupna_cijena DECIMAL(10,2) DEFAULT 0.00,
    CONSTRAINT racun_id_racun_pk PRIMARY KEY (id_racun),
    CONSTRAINT racun_djelatnik_fk FOREIGN KEY (id_djelatnik) REFERENCES djelatnik(id_djelatnik),
    CONSTRAINT racun_rezervacija_fk FOREIGN KEY (id_rezervacija) REFERENCES rezervacija(id_rezervacija)
); -- ID OD 20000 PA NA DALJE

CREATE TABLE arhiva_rezervacija (
    id_rezervacija SERIAL AUTO_INCREMENT, 
    id_soba BIGINT UNSIGNED NOT NULL, 
    id_gost BIGINT UNSIGNED NOT NULL, 
    id_sezona BIGINT UNSIGNED NOT NULL DEFAULT 0, 
    id_aranzman BIGINT UNSIGNED NOT NULL, 
    pocetak_rezervacije DATE NOT NULL, 
    kraj_rezervacije DATE NOT NULL, 
    broj_osoba TINYINT NOT NULL DEFAULT 1,
    vrijeme_brisanja DATETIME DEFAULT now());
    
CREATE TABLE arhiva_racun (
    id_racun SERIAL AUTO_INCREMENT, 
    sifra VARCHAR(12) NOT NULL DEFAULT '0-0-0',  
    id_rezervacija BIGINT UNSIGNED NOT NULL,  
    id_djelatnik BIGINT UNSIGNED NOT NULL,  
    datum_i_vrijeme_izdavanja DATETIME NOT NULL,
    ukupna_cijena DECIMAL(10,2) DEFAULT 0.00,
    vrijeme_brisanja DATETIME DEFAULT now()
);

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<  UPITI, POGLEDI, FUNKCIJE, PROCEDURE, OKIDAČI  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>> -- 
-- <<<<<<<<< ŽUŽIĆ UPITI, POGLEDI, FUNKCIJE, PROCEDURE, OKIDAČI >>>>>>>>> --
-- DROP FUNCTION broj_gostiju_po_rezervaciji;
DELIMITER //
CREATE FUNCTION broj_gostiju_po_rezervaciji(id INT) RETURNS INTEGER
DETERMINISTIC
BEGIN
 DECLARE rezultat INTEGER DEFAULT 0;
 SELECT COUNT(*) INTO rezultat FROM odabrani_gosti GROUP BY id_rezervacija HAVING id_rezervacija = id;
 RETURN rezultat+1;
END//
DELIMITER ;

-- DROP PROCEDURE broj_gostiju_update;
DELIMITER //
CREATE PROCEDURE broj_gostiju_update(id INT)
BEGIN
 UPDATE rezervacija SET broj_osoba = broj_gostiju_po_rezervaciji(id) WHERE id_rezervacija = id;
END //
DELIMITER ;

-- DROP TRIGGER ai_broj_osoba_rezervacija;
DELIMITER //
CREATE TRIGGER ai_broj_osoba_rezervacija
 AFTER INSERT ON odabrani_gosti
 FOR EACH ROW
BEGIN
 CALL broj_gostiju_update(new.id_rezervacija);
END//
DELIMITER ;

-- DROP FUNCTION ukupna_cijena_po_rezervaciji;
DELIMITER //
CREATE FUNCTION ukupna_cijena_po_rezervaciji(id INT) RETURNS DECIMAL(7,2) 
DETERMINISTIC
BEGIN
 DECLARE cijene_odabranih_usluga DECIMAL(10,2) DEFAULT 0.00;
 DECLARE cijene_sobe_po_danima DECIMAL(10,2) DEFAULT 0.00;
 DECLARE cijena_aranzmana DECIMAL(10,2) DEFAULT 0.00;
 DECLARE ukupna_cijena DECIMAL(10,2) DEFAULT 0.00;
 DECLARE multiplikator DECIMAL(10,2) DEFAULT 0.00;
 -- ODABRANE USLUGE
 -- ovaj upit sprema ukupnu cijenu odabranih_usluga za određenu rezervaciju u varijablu cijene_odabranih_usluga
 SELECT SUM(cijena*kolicina) INTO cijene_odabranih_usluga FROM odabrane_usluge NATURAL JOIN dodatne_usluge GROUP BY id_rezervacija HAVING id_rezervacija = id;
 -- ODABRANA SOBA
 -- ovaj upit sprema cijenu sobe pomnozeno s brojem dana u rezervaciji u varijablu cijene_sobe_po_danima
 SELECT (standardna_cijena * DATEDIFF(kraj_rezervacije, pocetak_rezervacije)) INTO cijene_sobe_po_danima FROM rezervacija NATURAL JOIN soba NATURAL JOIN sezona WHERE id_rezervacija = id;
 -- ODABRAN ARANZMAN
 -- ovaj upit sprema cijenu aranzmana za određenu rezervaciju u varijablu cijena_aranzmana
 SELECT cijena INTO cijena_aranzmana FROM rezervacija NATURAL JOIN aranzman WHERE id_rezervacija = id;
 -- ODABRANA SEZONA
 -- ovaj upit sprema multiplikator_cijene za određenu rezervaciju u varijablu multiplikator
 SELECT multiplikator_cijene INTO multiplikator FROM rezervacija NATURAL JOIN soba NATURAL JOIN sezona WHERE id_rezervacija = id;
 -- UKUPNA CIJENA RACUNA
 -- sve se zbraja i mnozi s multiplikatorom
 SET ukupna_cijena = cijene_odabranih_usluga + cijene_sobe_po_danima + cijena_aranzmana;
 RETURN multiplikator * ukupna_cijena;
END//
DELIMITER ;

-- DROP TRIGGER bi_ukupna_cijena_na_racunu;
DELIMITER //
CREATE TRIGGER bi_ukupna_cijena_na_racunu
 BEFORE INSERT ON racun
 FOR EACH ROW
BEGIN
 SET new.ukupna_cijena = ukupna_cijena_po_rezervaciji(new.id_rezervacija);
END//
DELIMITER ;

-- DROP FUNCTION gen_sifra_sobe;
DELIMITER //
CREATE FUNCTION gen_sifra_sobe(p_id_sobe VARCHAR(10), p_kat VARCHAR(10), p_vrsta VARCHAR(10)) RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN 
    DECLARE prvi_dio VARCHAR(10); -- id_sobe
    DECLARE drugi_dio VARCHAR(10); -- kat
    DECLARE treci_dio VARCHAR(10); -- vrsta
    
    IF p_id_sobe != 0 THEN
		SET prvi_dio = p_id_sobe;
	ELSE 
		SET prvi_dio = (SELECT id_soba FROM soba ORDER BY id_soba DESC LIMIT 1)+1;
	END IF;
    IF p_kat = 'prvi' THEN
		SET drugi_dio = '1';
	ELSEIF p_kat = 'drugi' THEN
		SET drugi_dio = '2';
	ELSEIF p_kat = 'treći' THEN
		SET drugi_dio = '3';
	ELSEIF p_kat = 'četvrti' THEN
		SET drugi_dio = '4';
	ELSEIF p_kat = 'peti' THEN
		SET drugi_dio = '5';
	ELSEIF p_kat = 'šesti' THEN
		SET drugi_dio = '6';
	END IF;
    SET treci_dio = p_vrsta;
	
    RETURN CONCAT(prvi_dio,"-",drugi_dio,"-",treci_dio);
END //
DELIMITER ;

-- DROP TRIGGER bi_sifra_sobe;    
DELIMITER //
CREATE TRIGGER bi_sifra_sobe
    BEFORE INSERT ON soba
    FOR EACH ROW
BEGIN
    SET new.sifra = gen_sifra_sobe(new.id_soba, new.kat, new.vrsta);
END //
DELIMITER ;

-- DROP PROCEDURE slobodne_sobe_datum_i_vrsta;
DELIMITER //
CREATE PROCEDURE slobodne_sobe_datum_i_vrsta(odabrani_pocetak DATE, odabrani_kraj DATE, odabrana_vrsta VARCHAR(5))
BEGIN
 SELECT * FROM soba LEFT OUTER JOIN rezervacija ON rezervacija.id_soba = soba.id_soba
	WHERE 
		vrsta LIKE odabrana_vrsta 
		AND ((((pocetak_rezervacije > odabrani_pocetak) AND (pocetak_rezervacije > odabrani_kraj)) OR ((kraj_rezervacije < odabrani_pocetak) AND (kraj_rezervacije < odabrani_kraj))) OR id_rezervacija IS NULL);
END //
DELIMITER ;
-- CALL slobodne_sobe_datum_i_vrsta('2021-01-12','2021-01-22','SGL'); 

-- procedura koja prikaze zaradu po mjesecima za odabranu godinu
-- DROP PROCEDURE broj_zarade_za_odredenu_godinu_po_mjesecima;
DELIMITER //
CREATE PROCEDURE broj_zarade_za_odredenu_godinu_po_mjesecima(odabrana_godina YEAR)
BEGIN
	SELECT CONCAT('Godina: ', odabrana_godina, '.', '    Mjesec: ', mjeseci.mjesec, '.') AS DATUM, COALESCE(ZARADA, 0) FROM
	(SELECT DISTINCT MONTH(datum_i_vrijeme_izdavanja) AS mjesec FROM racun) AS mjeseci LEFT JOIN
	(SELECT MONTH(datum_i_vrijeme_izdavanja) AS mjesec, SUM(ukupna_cijena) AS zarada FROM racun
		WHERE YEAR(datum_i_vrijeme_izdavanja) = odabrana_godina
		GROUP BY MONTH(datum_i_vrijeme_izdavanja)) AS zarada_po_mjesecima 
        ON mjeseci.mjesec=zarada_po_mjesecima.mjesec
        ORDER BY mjeseci.mjesec;
 END //
DELIMITER ;
-- CALL broj_zarade_za_odredenu_godinu_po_mjesecima(2020); 

-- Prikazuje zaradu za svaku godinu
CREATE VIEW prikaz_zarade_za_sve_godine AS
SELECT YEAR(datum_i_vrijeme_izdavanja) AS GODINA, (SUM(ukupna_cijena)) AS ZARADA FROM racun
		GROUP BY YEAR(datum_i_vrijeme_izdavanja)
        ORDER BY datum_i_vrijeme_izdavanja;

-- Prikazuje goste i njihove informacije za svaku rezervaciju
CREATE VIEW pregled_gostiju_u_pojedinoj_rezervaciji AS
SELECT CONCAT('Rezervacija:  ', id_rezervacija) AS id_rezervacija, 
	   CONCAT('Booker ime:  ', ime) AS ime, CONCAT('Booker prezime:  ', prezime) AS prezime,
	   CONCAT('Booker OIB:  ', OIB) AS OIB, CONCAT('Booker broj osobne iskaznice:  ', broj_osobne_iskaznice) AS broj_osobne_iskaznice,
       CONCAT('Booker datum rođenja:  ', DATE_FORMAT(datum_rodenja, '%d.%M.%Y')) AS datum_rodenja, 
       CONCAT('Booker država:  ', drzava) AS drzava, CONCAT('Booker grad:  ', grad) AS grad,
       CONCAT('Booker poštanski broj:  ', postanski_broj) AS postanski_broj, CONCAT('Booker adresa:  ', adresa) AS adresa
	FROM rezervacija 
    NATURAL JOIN gost 
    NATURAL JOIN mjesto_prebivalista 
UNION
SELECT CONCAT('Rezervacija:  ', r.id_rezervacija) AS id_rezervacija, 
	   CONCAT('Odabrani gost ime:  ', ime) AS ime, CONCAT('Odabrani gost prezime:  ', prezime) AS prezime,
       CONCAT('Odabrani gost OIB:  ', OIB) AS OIB, CONCAT('Odabrani gost broj osobne iskaznice:  ', broj_osobne_iskaznice) AS broj_osobne_iskaznice,
       CONCAT('Odabrani gost datum rođenja:  ',  DATE_FORMAT(datum_rodenja, '%d.%M.%Y')) AS datum_rodenja, 
       CONCAT('Odabrani gost država:  ', drzava) AS drzava, CONCAT('Odabrani gost grad:  ', grad) AS grad,
       CONCAT('Odabrani gost poštanski broj:  ', postanski_broj) AS postanski_broj, CONCAT('Odabrani gost adresa:  ', adresa) AS adresa
	FROM rezervacija AS r
	JOIN odabrani_gosti AS o_g ON r.id_rezervacija = o_g.id_rezervacija
	JOIN gost ON gost.id_gost = o_g.id_gost
    NATURAL JOIN mjesto_prebivalista
ORDER BY id_rezervacija;

-- DROP TRIGGER provjera_godina_rođenja;
DELIMITER //
CREATE TRIGGER provjera_godina_rođenja_gost
 BEFORE INSERT ON gost
 FOR EACH ROW
BEGIN
 IF new.datum_rodenja > NOW() THEN
	SIGNAL SQLSTATE '40000'
	SET MESSAGE_TEXT = "Datum rodjenja ne može biti veći od trenutnog datuma!";
 END IF;
END//
DELIMITER ;

-- DROP TRIGGER provijera unosa imena i prezimena kod kupaca;
DELIMITER //
CREATE TRIGGER special_char_check
 BEFORE INSERT ON gost
 FOR EACH ROW
BEGIN
 
 DECLARE i INT DEFAULT 1 ;
 DECLARE j INT DEFAULT 1 ;
 DECLARE slovo CHAR;
 DECLARE greska TEXT;
      for_petlja: LOOP
		 SET slovo = SUBSTRING(new.ime,i,1);
         IF (HEX(slovo)<HEX("'") || HEX(slovo)>HEX("'")) && 
			(HEX(slovo)<HEX('A') || HEX(slovo)>HEX('Z')) && 
            (HEX(slovo)<HEX('a') || HEX(slovo)>HEX('z')) &&
			(HEX(slovo)<HEX('À') || HEX(slovo)>HEX('Ö')) &&
			(HEX(slovo)<HEX('Ø') || HEX(slovo)>HEX('ö')) &&
			(HEX(slovo)<HEX('ø') || HEX(slovo)>HEX('ƿ')) &&
			(HEX(slovo)<HEX('Ǆ') || HEX(slovo)>HEX('ʯ')) &&
			(HEX(slovo)<HEX('Έ') || HEX(slovo)>HEX('Ј')) &&
			(HEX(slovo)<HEX('Љ') || HEX(slovo)>HEX('߿')) &&
			(HEX(slovo)<HEX('ࢠ') || HEX(slovo)>HEX('₿')) &&
			(HEX(slovo)<HEX('⺀') || HEX(slovo)>HEX('你')) &&
			(HEX(slovo)<HEX('') || HEX(slovo)>HEX(''))
         THEN 
			SET greska = CONCAT("Greška: Ne možete unijeti ime ", new.ime, " jer sadrži zabranjen znak ", slovo);
			SIGNAL SQLSTATE '40000'
			SET MESSAGE_TEXT = greska;
		 END IF;
         IF i=LENGTH(new.ime) THEN
            LEAVE for_petlja;
         END IF;
         SET i = i + 1;
   END LOOP for_petlja;
   
   for_petlja2: LOOP
		 SET slovo = SUBSTRING(new.prezime,j,1);
         IF (HEX(slovo)<HEX("'") || HEX(slovo)>HEX("'")) && 
            (HEX(slovo)<HEX('A') || HEX(slovo)>HEX('Z')) && 
            (HEX(slovo)<HEX('a') || HEX(slovo)>HEX('z')) &&
			(HEX(slovo)<HEX('À') || HEX(slovo)>HEX('Ö')) &&
			(HEX(slovo)<HEX('Ø') || HEX(slovo)>HEX('ö')) &&
			(HEX(slovo)<HEX('ø') || HEX(slovo)>HEX('ƿ')) &&
			(HEX(slovo)<HEX('Ǆ') || HEX(slovo)>HEX('ʯ')) &&
			(HEX(slovo)<HEX('Έ') || HEX(slovo)>HEX('Ј')) &&
			(HEX(slovo)<HEX('Љ') || HEX(slovo)>HEX('߿')) &&
			(HEX(slovo)<HEX('ࢠ') || HEX(slovo)>HEX('₿')) &&
			(HEX(slovo)<HEX('⺀') || HEX(slovo)>HEX('你')) &&
			(HEX(slovo)<HEX('') || HEX(slovo)>HEX(''))
         THEN 
			SET greska = CONCAT("Greška: Ne možete unijeti prezime ", new.prezime, " jer sadrži zabranjen znak ", slovo);
			SIGNAL SQLSTATE '40000'
			SET MESSAGE_TEXT = greska;
		 END IF;
         IF j=LENGTH(new.prezime) THEN
            LEAVE for_petlja2;
         END IF;
         SET j = j + 1;
   END LOOP for_petlja2;
 
END//
DELIMITER ;

CREATE VIEW prikaz_rezervacija_i_odabranih_usluga AS
	SELECT id_rezervacija,
		   DATEDIFF(kraj_rezervacije,pocetak_rezervacije) AS broj_dana,
           id_odabrane_usluge,
           naziv,
           kolicina,
           cijena*kolicina AS cijena 
	FROM rezervacija 
    NATURAL JOIN odabrane_usluge 
    NATURAL JOIN dodatne_usluge;

-- <<<<<<<<< BLAŠKOVIĆ UPITI, POGLEDI, FUNKCIJE, PROCEDURE, OKIDAČI >>>>>>>>> --
-- DROP FUNCTION izracun_sezone;
DELIMITER //    
CREATE FUNCTION izracun_sezone(pocetni_datum DATE, krajnji_datum DATE) RETURNS INTEGER
	DETERMINISTIC
	BEGIN
    DECLARE duljina_boravka INTEGER;
    
    DECLARE ljeto_pocetak DATE;
    DECLARE ljeto_kraj DATE; 
    
    DECLARE jesen_pocetak DATE;
    DECLARE jesen_kraj DATE;
    
    DECLARE zima_pocetak DATE;
    DECLARE zima_kraj DATE;
        
	DECLARE proljece_pocetak DATE;
    DECLARE proljece_kraj DATE;
    
    SET ljeto_pocetak = CONCAT(EXTRACT(YEAR FROM pocetni_datum),"-","06","-","21"); 
    SET ljeto_kraj = CONCAT(EXTRACT(YEAR FROM pocetni_datum),"-","09","-","23"); 
    
    SET jesen_pocetak = CONCAT(EXTRACT(YEAR FROM pocetni_datum),"-","09","-","23"); 
    SET jesen_kraj = CONCAT(EXTRACT(YEAR FROM pocetni_datum),"-","12","-","21"); 
    
    IF MONTH(pocetni_datum)=1 OR MONTH(pocetni_datum)=2 OR MONTH(pocetni_datum)=3 THEN
		SET zima_pocetak = CONCAT(EXTRACT(YEAR FROM pocetni_datum)-1,"-","12","-","21"); 
		SET zima_kraj = CONCAT(EXTRACT(YEAR FROM pocetni_datum),"-","03","-","21");
	ELSEIF MONTH(pocetni_datum)=12 THEN
		SET zima_pocetak = CONCAT(EXTRACT(YEAR FROM pocetni_datum),"-","12","-","21"); 
		SET zima_kraj = CONCAT(EXTRACT(YEAR FROM pocetni_datum)+1,"-","03","-","21");
    END IF;

    SET proljece_pocetak = CONCAT(EXTRACT(YEAR FROM pocetni_datum),"-","03","-","21"); 
    SET proljece_kraj = CONCAT(EXTRACT(YEAR FROM pocetni_datum),"-","06","-","21"); 
    SET duljina_boravka = -1;
    SELECT DATEDIFF(krajnji_datum,pocetni_datum) INTO duljina_boravka;
    IF duljina_boravka > 60 THEN RETURN 0;
    END IF;
		CASE
			-- LJETO
			WHEN pocetni_datum BETWEEN ljeto_pocetak AND ljeto_kraj 
				THEN
                IF pocetni_datum=ljeto_kraj AND duljina_boravka>1
					THEN RETURN 12;
				ELSEIF pocetni_datum=ljeto_kraj AND duljina_boravka=1
					THEN RETURN 11;
				ELSEIF ljeto_kraj - pocetni_datum >  krajnji_datum - ljeto_kraj
					THEN RETURN 11;
				ELSE RETURN 12;
                END IF;
			-- JESEN
			WHEN pocetni_datum BETWEEN jesen_pocetak AND jesen_kraj 
				THEN
                IF pocetni_datum=jesen_kraj AND duljina_boravka>1
					THEN RETURN 13;
				ELSEIF pocetni_datum=jesen_kraj AND duljina_boravka=1
					THEN RETURN 12;
				ELSEIF jesen_kraj - pocetni_datum >  krajnji_datum - jesen_kraj
					THEN RETURN 12;
				ELSE RETURN 13;
                END IF;
			-- ZIMA
			WHEN pocetni_datum BETWEEN zima_pocetak AND zima_kraj
				THEN
                IF pocetni_datum=zima_kraj AND duljina_boravka>1
					THEN RETURN 14;
				ELSEIF pocetni_datum=zima_kraj AND duljina_boravka=1
					THEN RETURN 13;
				ELSEIF zima_kraj - pocetni_datum >  krajnji_datum - zima_kraj
					THEN RETURN 13;
				ELSE RETURN 14;
                END IF;
			-- PROLJECE
			WHEN pocetni_datum BETWEEN proljece_pocetak AND proljece_kraj 
				THEN
                IF pocetni_datum=proljece_kraj AND duljina_boravka>1
					THEN RETURN 11;
				ELSEIF pocetni_datum=proljece_kraj AND duljina_boravka=1
					THEN RETURN 14;
				ELSEIF proljece_kraj - pocetni_datum >  krajnji_datum - proljece_kraj
					THEN RETURN 14;
				ELSE RETURN 11;
                END IF;
			ELSE 
				RETURN 0;
		END CASE;
 
	END //
DELIMITER ;

-- DROP TRIGGER bi_rezervacija;
DELIMITER //
CREATE TRIGGER bi_rezervacija
    BEFORE INSERT ON rezervacija
    FOR EACH ROW
BEGIN
    DECLARE tekst_greske TEXT;
    DECLARE soba_vrsta VARCHAR(5);
    DECLARE soba_sifra VARCHAR(15);
    
    SELECT vrsta INTO soba_vrsta
        FROM soba
        WHERE soba.id_soba = new.id_soba;
        
    SELECT sifra INTO soba_sifra
        FROM soba
        WHERE soba.id_soba = new.id_soba;    
        
    IF new.pocetak_rezervacije>new.kraj_rezervacije OR new.pocetak_rezervacije=new.kraj_rezervacije THEN
        SET tekst_greske = CONCAT("Greška kod unosa rezervacije sa ID-em ",new.id_rezervacija,". Molimo unesite ispravno datume početka i kraja rezervacije!");
        SIGNAL SQLSTATE '40000'
        SET MESSAGE_TEXT = tekst_greske;
    END IF;
    
    SET new.id_sezona = izracun_sezone(new.pocetak_rezervacije, new.kraj_rezervacije);
    
    IF new.id_sezona = 0 THEN
        SET tekst_greske = CONCAT("Greška kod unosa rezervacije sa ID-em ",new.id_rezervacija,". Maksimalan broj dana koji možete rezervirati je 60. Molimo ispravite podatke!");
        SIGNAL SQLSTATE '40000'
        SET MESSAGE_TEXT = tekst_greske;
    END IF;
    
    IF soba_sifra NOT IN (SELECT sifra FROM soba LEFT OUTER JOIN rezervacija ON rezervacija.id_soba = soba.id_soba
    WHERE 
        vrsta LIKE soba_vrsta 
        AND ((((pocetak_rezervacije > new.pocetak_rezervacije) AND (pocetak_rezervacije > new.kraj_rezervacije)) OR ((kraj_rezervacije < new.pocetak_rezervacije) AND (kraj_rezervacije < new.kraj_rezervacije))) OR id_rezervacija IS NULL)) THEN
        SET tekst_greske = CONCAT("Greška kod unosa rezervacije sa ID-em ",new.id_rezervacija,". Soba koju ste odabrali je zauzeta u ovom razdoblju!");
        SIGNAL SQLSTATE '40000'
        SET MESSAGE_TEXT = tekst_greske;
    END IF;
END //
DELIMITER ;

-- DROP FUNCTION gen_sifra_racuna;
DELIMITER //
CREATE FUNCTION gen_sifra_racuna(p_id_racun INTEGER, p_id_rezervacija INTEGER, p_id_djelatnik INTEGER) RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN 
    DECLARE prvi_dio VARCHAR(10); -- zadnje 3 znamenke racuna
    DECLARE drugi_dio VARCHAR(10); -- id_rezervacija
    DECLARE treci_dio VARCHAR(10); -- id_djelatnik
    IF p_id_racun != 0 THEN
		SELECT SUBSTRING(p_id_racun, -3) 
        INTO prvi_dio;
	ELSE 
		SET prvi_dio = (SELECT SUBSTRING(id_racun, -3) FROM racun ORDER BY id_racun DESC LIMIT 1)+1;
	END IF;
        
    SET drugi_dio = p_id_rezervacija;
    SET treci_dio = p_id_djelatnik;
      
    RETURN CONCAT(prvi_dio,"-",drugi_dio,"-",treci_dio);
END //
DELIMITER ;

-- DROP TRIGGER bi_sifra_racuna;    
DELIMITER //
CREATE TRIGGER bi_sifra_racuna
    BEFORE INSERT ON racun
    FOR EACH ROW
BEGIN
    SET new.sifra = gen_sifra_racuna(new.id_racun, new.id_rezervacija, new.id_djelatnik);
END //
DELIMITER ;

-- provjerava OIB i broj osobne iskaznice za goste Republike Hrvatske   
-- DROP PROCEDURE provjera_hrv_podataka;
DELIMITER //
CREATE PROCEDURE provjera_hrv_podataka()
BEGIN
        DECLARE gost_temp INTEGER;
        DECLARE finish INTEGER DEFAULT 0;
        DECLARE gost_temp_ime VARCHAR(50);
        DECLARE gost_temp_prezime VARCHAR(50);
        DECLARE gost_temp_oib VARCHAR(50);
        DECLARE gost_temp_boi VARCHAR(50);
        
        DECLARE cur CURSOR FOR 
            SELECT id_gost
            FROM gost
            NATURAL JOIN mjesto_prebivalista
            WHERE drzava = 'Hrvatska';
            
        DECLARE CONTINUE HANDLER
            FOR NOT FOUND SET finish = 1;
        OPEN cur;
        DROP TABLE IF EXISTS hrPodaci;
        CREATE TEMPORARY TABLE hrPodaci(
            id SERIAL,
            id_gost INTEGER,
            gost_ime VARCHAR(30) NOT NULL,
            gost_prezime VARCHAR(30) NOT NULL,
            oib_rezultat VARCHAR(100) NOT NULL,
            broj_osobne_iskaznice_rezultat VARCHAR(100) NOT NULL);
        
        iteriraj_goste: LOOP
        FETCH cur INTO gost_temp;
        
        IF finish = 1 THEN
            LEAVE iteriraj_goste;
        END IF;

SELECT ime INTO gost_temp_ime
            FROM gost
            WHERE id_gost = gost_temp;
        SELECT prezime INTO gost_temp_prezime
            FROM gost
            WHERE id_gost = gost_temp;
        SELECT broj_osobne_iskaznice INTO gost_temp_boi
            FROM gost
            WHERE id_gost = gost_temp;
        SELECT oib INTO gost_temp_oib
            FROM gost
            WHERE id_gost = gost_temp;    
          
        IF LENGTH(gost_temp_oib) !=11 THEN
            IF LENGTH(gost_temp_boi)!=9 THEN
                INSERT INTO hrPodaci (id_gost,gost_ime,gost_prezime,oib_rezultat,broj_osobne_iskaznice_rezultat) VALUES(gost_temp,gost_temp_ime,gost_temp_prezime,'OIB - pogrešno upisan!', 'Br. osobne - pogrešno upisan');
            ELSE 
                INSERT INTO hrPodaci (id_gost,gost_ime,gost_prezime,oib_rezultat,broj_osobne_iskaznice_rezultat) VALUES(gost_temp,gost_temp_ime,gost_temp_prezime,'OIB - pogrešno upisan!', 'Br. osobne - OK!');
            END IF; 
        ELSE 
            IF LENGTH(gost_temp_boi)!=9 THEN
                INSERT INTO hrPodaci (id_gost,gost_ime,gost_prezime,oib_rezultat,broj_osobne_iskaznice_rezultat) VALUES(gost_temp,gost_temp_ime,gost_temp_prezime,'OIB - OK!', 'Br. osobne - pogrešno upisan');
            ELSE 
                INSERT INTO hrPodaci (id_gost,gost_ime,gost_prezime,oib_rezultat,broj_osobne_iskaznice_rezultat) VALUES(gost_temp,gost_temp_ime,gost_temp_prezime,'OIB - OK!', 'Br. osobne - OK!');
            END IF; 
        END IF;
        END LOOP iteriraj_goste;
        CLOSE cur;
        
        SELECT *
            FROM hrPodaci;
     END //
     DELIMITER ;
-- CALL provjera_hrv_podataka();
     
-- Prikazuje ime i prezime gosta te broj rezervacija koji je on napravio skupa sa ukupnom svotom novca koju je potrosio
    CREATE VIEW prikaz_gostiju_ukupni_podaci AS
    SELECT gost.ime, gost.prezime, COUNT(*) AS broj_rezervacija, SUM(ukupna_cijena) AS ukupno_potroseno
        FROM gost
        NATURAL JOIN rezervacija
        NATURAL JOIN racun
        GROUP BY gost.id_gost;
        
DROP FUNCTION IF EXISTS broj_nocenja_soba;
DELIMITER //
CREATE FUNCTION broj_nocenja_soba(p_id_soba INTEGER) RETURNS INTEGER
DETERMINISTIC
BEGIN
    DECLARE rezultat INTEGER DEFAULT 0;
    SELECT COUNT(*) AS broj_nocenja_sobe INTO rezultat
        FROM soba
        NATURAL JOIN rezervacija
        WHERE soba.id_soba = p_id_soba AND NOW()>kraj_rezervacije
        GROUP BY id_soba;
    RETURN rezultat;
END //
DELIMITER ;

DELIMITER //
    CREATE PROCEDURE provjera_stanja_soba()
    BEGIN
    DECLARE soba_temp INTEGER;
    DECLARE finish INTEGER DEFAULT 0;
    DECLARE sifra_temp VARCHAR (50);
    DECLARE broj_nocenja_temp INTEGER DEFAULT 0;
    DECLARE kat_temp VARCHAR(10);
    DECLARE stanje_temp VARCHAR(100);
    DECLARE standardna_cijena_temp DECIMAL(7,2);
    DECLARE prosjecni_iznos_odrzavanja_temp DECIMAL(7,2);
    
    DECLARE cur CURSOR FOR
        SELECT id_soba
        FROM soba;
    DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finish = 1;
    OPEN cur;
    DROP TABLE IF EXISTS sobe_stanja;
        CREATE TEMPORARY TABLE sobe_stanja(
        id SERIAL,
        sifra VARCHAR(50),
        kat VARCHAR(10),
        standardna_cijena DECIMAL(7,2),
        broj_nocenja INTEGER NOT NULL,
        stanje VARCHAR(100),
        prosjecni_iznos_odrzavanja DECIMAL(7,2)
        );
    iteriraj_sobe: LOOP
    FETCH cur INTO soba_temp;
        IF finish = 1 THEN
            LEAVE iteriraj_sobe;
        END IF;
        
    SELECT sifra INTO sifra_temp
        FROM soba
        WHERE id_soba = soba_temp;
    SELECT kat INTO kat_temp
        FROM soba
        WHERE id_soba = soba_temp;
    SELECT standardna_cijena INTO standardna_cijena_temp
        FROM soba
        WHERE id_soba = soba_temp;
    SELECT broj_nocenja_soba(id_soba) INTO broj_nocenja_temp
        FROM soba
        WHERE id_soba = soba_temp;
    IF broj_nocenja_temp>0 THEN
        SET prosjecni_iznos_odrzavanja_temp = broj_nocenja_temp*(0.1*standardna_cijena_temp);
    ELSE
        SET prosjecni_iznos_odrzavanja_temp = 0.05*standardna_cijena_temp;
    END IF;
    CASE
        WHEN broj_nocenja_temp = 0 THEN
            SET stanje_temp = "Stanje izvrsno. U sobi se nije noćilo. Dodatnih troškova nema!";
        WHEN broj_nocenja_temp BETWEEN 1 AND 5 THEN
            SET stanje_temp = "Soba je malo korištena. Potrebno održavanje svakih 10 dana!";
        WHEN broj_nocenja_temp BETWEEN 6 AND 15 THEN
            SET stanje_temp = "Soba je umjereno korištena. Potrebno održavanje svakih 7 dana!";
        WHEN broj_nocenja_temp BETWEEN 16 AND 50 THEN
            SET stanje_temp = "Soba je dosta korištena. Potrebno održavanje svaka 4 dana!";
        WHEN broj_nocenja_temp > 50 THEN
            SET stanje_temp = "Soba je jako puno korištena. Potrebno održavanje svaki dan";
        END CASE;
        INSERT INTO sobe_stanja (sifra,kat,standardna_cijena,broj_nocenja,stanje,prosjecni_iznos_odrzavanja)
            VALUES (sifra_temp,kat_temp,standardna_cijena_temp,broj_nocenja_temp,stanje_temp,prosjecni_iznos_odrzavanja_temp);
        END LOOP iteriraj_sobe;
        CLOSE cur;
        
        SELECT * 
            FROM sobe_stanja;
    END //
    DELIMITER ;
-- CALL provjera_stanja_soba();

CREATE VIEW racun_prikaz AS
    SELECT racun.sifra,racun.datum_i_vrijeme_izdavanja,
           CONCAT(djelatnik.ime, ' ', djelatnik.prezime) AS racun_izdao,
           CONCAT (gost.ime, ' ', gost.prezime) AS rezervirao,racun.ukupna_cijena
        FROM racun
        NATURAL JOIN rezervacija
        NATURAL JOIN gost
        INNER JOIN djelatnik
        ON djelatnik.id_djelatnik = racun.id_djelatnik;
        
CREATE VIEW rezervacija_bez_racuna AS    
    SELECT rezervacija.id_rezervacija AS rezervacija_id, CONCAT(gost.ime, ' ', gost.prezime) AS rezervirao,
           aranzman.naziv AS aranzman, soba.sifra AS sifra_sobe, sezona.naziv AS sezona,
           rezervacija.pocetak_rezervacije, rezervacija.kraj_rezervacije, rezervacija.broj_osoba  
        FROM rezervacija
        LEFT JOIN racun
        ON rezervacija.id_rezervacija = racun.id_rezervacija
        NATURAL JOIN gost
        INNER JOIN  sezona
            ON sezona.id_sezona = rezervacija.id_sezona
        INNER JOIN aranzman
            ON aranzman.id_aranzman = rezervacija.id_aranzman
        INNER JOIN soba
            ON soba.id_soba = rezervacija.id_soba
        WHERE racun.id_rezervacija IS NULL;
        
-- <<<<<<<<< LORBEK UPITI, POGLEDI, FUNKCIJE, PROCEDURE, OKIDAČI >>>>>>>>> --
-- upit za broj rezervacija po sezoni
CREATE VIEW broj_rezervacija_po_sezoni AS
SELECT
    SUM(IF(id_sezona = '11', 1, 0)) AS ljetne_rezervacije,
    SUM(IF(id_sezona = '12', 1, 0)) AS jesenske_rezervacije,
    SUM(IF(id_sezona = '13', 1, 0)) AS zimske_rezervacije,
    SUM(IF(id_sezona = '14', 1, 0)) AS proljetne_rezervacije
FROM rezervacija;

-- upit za zaposlenike zaposlene duže od 20 godina
CREATE VIEW zaposlenici_zaposleni_duže_od_20_godina AS
SELECT *
    FROM djelatnik
    WHERE datum_zaposljenja < NOW() - INTERVAL 20 YEAR;

-- upit za goste koji imaju najduži boravak
CREATE VIEW goste_koji_imaju_najduži_boravak AS
SELECT gost.ime, gost.prezime, DATEDIFF(rezervacija.kraj_rezervacije, rezervacija.pocetak_rezervacije) AS duljina_boravka
    FROM gost, rezervacija
        WHERE gost.id_gost = rezervacija.id_gost
        ORDER BY duljina_boravka
        DESC LIMIT 10;

-- najčešće države gostiju
CREATE VIEW najčešće_države_gostiju AS
SELECT drzava
    FROM mjesto_prebivalista
    GROUP BY drzava
    ORDER BY COUNT(drzava)
    DESC LIMIT 3;

-- pogled za popularnost aranzmana
CREATE VIEW najpopularniji_aranzmani AS
        SELECT aranzman.naziv, COUNT(rezervacija.id_aranzman) AS broj_aranzmana
            FROM aranzman
            LEFT JOIN rezervacija ON (aranzman.id_aranzman = rezervacija.id_aranzman)
            GROUP BY aranzman.id_aranzman;

-- pogled koji prikazuje zaposlenike s plaćom većom od 15 000 kuna
CREATE VIEW najprinosniji_zaposlenici AS
    SELECT djelatnik.ime AS Ime, djelatnik.prezime AS Prezime, zvanje.naziv AS Radno_Mjesto, zvanje.plaća_HRK AS Plaća
        FROM djelatnik
        NATURAL JOIN zvanje
        WHERE (zvanje.plaća_HRK > 15000)
        GROUP BY id_djelatnik;
        
-- okidač za točnost datuma zapošljavanja
    DELIMITER //
    CREATE TRIGGER bi_djelatnik_gd
        BEFORE INSERT ON djelatnik
        FOR EACH ROW
    BEGIN
        IF new.datum_zaposljenja > NOW() THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Pogrešan datum unesen!';
        END IF;
    END //
    DELIMITER ;
    
    -- okidač za stvaranja backup tablice podataka ako je djelatnik uklonjen
    DELIMITER //
    CREATE TRIGGER ad_backup_zaposlenika
        AFTER DELETE ON djelatnik
        FOR EACH ROW
    BEGIN
        CREATE TEMPORARY TABLE backup_djelatnik LIKE djelatnik;
        INSERT INTO backup_djelatnik(id_djelatnik, ime, prezime, id_zvanje, datum_zaposljenja)
        VALUES (OLD.id_djelatnik, OLD.ime, OLD.prezime, OLD.id_zvanje, OLD.datum_zaposljenja);
    END //
    DELIMITER ;
    
    -- procedura za izracunavanje prosjeka racuna gostiju tijekom proljeca
    -- DROP PROCEDURE prosjek_potrosnje_proljece;
    DELIMITER //
    CREATE PROCEDURE prosjek_potrosnje_proljece()
    BEGIN
        SELECT AVG(ukupna_cijena) FROM racun
        LEFT OUTER JOIN rezervacija ON racun.id_rezervacija = rezervacija.id_rezervacija
        WHERE rezervacija.id_sezona = '14';
    END //
    DELIMITER ;
    -- CALL prosjek_potrosnje_proljece();
    
    -- procedura za smanjivanje cijena soba koje se nisu rezervirane zadnjih mjesec dana
    -- DROP PROCEDURE sm_cijena_soba;
    DELIMITER //
    CREATE PROCEDURE sm_cijena_soba()
    BEGIN
        UPDATE soba
        SET standardna_cijena = standardna_cijena - (standardna_cijena * (15/100))
            WHERE soba.id_soba IN 
                (SELECT * FROM
                    (SELECT id_soba AS rez_sb FROM rezervacija
                        NATURAL JOIN soba
                        WHERE rezervacija.kraj_rezervacije < NOW() - INTERVAL 1 MONTH
                        ) AS prv);
    END //
    DELIMITER ;
    -- CALL sm_cijena_soba();
    
  -- okidač za zabranu unošenja samo brojki za adresu
    DELIMITER //
    CREATE TRIGGER bi_adresa_zabrana
        BEFORE INSERT ON mjesto_prebivalista
        FOR EACH ROW
    BEGIN
        IF NEW.adresa REGEXP '^[0-9]*$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Adresa ne smije sadržavati samo brojke!';
        END IF;
    END //
    DELIMITER ;
    
    -- okidač koji se nadovezuje na prijašnje za provjeru broja gostiju po sobi
	-- DROP TRIGGER ai_cetiri_gosta;
	DELIMITER //
	CREATE TRIGGER ai_cetiri_gosta
	 AFTER INSERT ON odabrani_gosti
	 FOR EACH ROW 
	 FOLLOWS ai_broj_osoba_rezervacija
	BEGIN
	 IF (SELECT rezervacija.broj_osoba FROM rezervacija WHERE rezervacija.broj_osoba > 4) THEN
		SIGNAL SQLSTATE '40000'
		SET MESSAGE_TEXT = "Dozvoljeno je maksimalno četiri gosta po sobi!";
	 END IF;
	END //
	DELIMITER ;
    
-- <<<<<<<<< BASTIJANIĆ UPITI, POGLEDI, FUNKCIJE, PROCEDURE, OKIDAČI >>>>>>>>> --
-- djelatnik sa najvećim brojem računa
CREATE VIEW djelatnik_sa_najvećim_brojem_računa AS
SELECT d.* FROM racun
	NATURAL JOIN djelatnik AS d
	GROUP BY id_djelatnik
	ORDER BY COUNT(*) DESC
	LIMIT 1;
    
-- najpopularnija usluga
CREATE VIEW najpopularnija_usluga AS
SELECT d.* FROM odabrane_usluge
	NATURAL JOIN dodatne_usluge AS d
	GROUP BY id_dodatne_usluge
	ORDER BY COUNT(*) DESC
	LIMIT 1;
    
-- najpopularnija soba
CREATE VIEW najpopularnija_soba AS
SELECT s.* FROM rezervacija
	NATURAL JOIN soba AS s
	WHERE kraj_rezervacije > NOW() - INTERVAL 2 MONTH
	GROUP BY id_soba
	ORDER BY COUNT(*) DESC
	LIMIT 1;
    
-- koji su gosti trenutno u hotelu 
CREATE VIEW gosti_trenutno_u_hotelu AS
SELECT id_rezervacija, ime, prezime, sifra FROM rezervacija
	NATURAL JOIN gost
	NATURAL JOIN soba
	WHERE pocetak_rezervacije <= NOW() AND kraj_rezervacije > NOW();

-- provjerava je li cijena preskupa pri INSERTU za dodatne usluge
DELIMITER //
CREATE TRIGGER provjera_cijene_dodatne_usluge_i
    BEFORE INSERT ON dodatne_usluge
    FOR EACH ROW
BEGIN
    IF new.cijena > 2000 THEN
        SIGNAL SQLSTATE '40000'
        SET MESSAGE_TEXT = "Ne možete unijeti tako skupu uslugu";
    END IF;
END //
DELIMITER ;

-- provjerava je li cijena preskupa pri UPDATE-u za dodatne usluge
DELIMITER //
CREATE TRIGGER provjera_cijene_dodatne_usluge_u
    BEFORE UPDATE ON dodatne_usluge
    FOR EACH ROW
BEGIN

    IF new.cijena > 2000 THEN 
        SIGNAL SQLSTATE '40000'
        SET MESSAGE_TEXT = "Ne možete unijeti tako skupu uslugu";
    END IF;
END //
DELIMITER ;

-- provjerava je li cijena preskupa pri UPDATE-u za aranzman
DELIMITER //
CREATE TRIGGER provjera_aranzman_u
    BEFORE UPDATE ON aranzman
    FOR EACH ROW
BEGIN
    IF new.cijena > 2000 THEN 
        SIGNAL SQLSTATE '40000'
        SET MESSAGE_TEXT = "Ne možete unijeti tako skupi aranžman";
    END IF;
END //
DELIMITER ;

-- provjerava je li cijena preskupa pri INSERTU za aranzman
DELIMITER //
CREATE TRIGGER provjera_aranzman_i
    BEFORE INSERT ON aranzman
    FOR EACH ROW
BEGIN
    IF new.cijena > 2000 THEN 
        SIGNAL SQLSTATE '40000'
        SET MESSAGE_TEXT = "Ne možete unijeti tako skupi aranžman";
    END IF;
END //
DELIMITER ;

-- manjivanje cijene nepopularne usluge
DELIMITER //
CREATE PROCEDURE smanjivanje_cijene_nepopularne_usluge(postotak int)
BEGIN
UPDATE dodatne_usluge 
	SET cijena = cijena - cijena * postotak / 100
	WHERE id_dodatne_usluge IN 
    (SELECT * FROM
		(SELECT id_dodatne_usluge FROM odabrane_usluge
            NATURAL JOIN dodatne_usluge
            GROUP BY id_dodatne_usluge
            ORDER BY COUNT(*) 
            ASC
            LIMIT 3) AS p);
END //
DELIMITER ;

-- povecavanje cijene popularne usluge
DELIMITER //
CREATE PROCEDURE povecavanje_cijene_popularne_usluge(postotak int)
BEGIN

UPDATE dodatne_usluge 
	SET cijena = cijena + cijena * postotak / 100
	WHERE id_dodatne_usluge IN 
    (SELECT * FROM
		(SELECT id_dodatne_usluge FROM odabrane_usluge
            NATURAL JOIN dodatne_usluge
            GROUP BY id_dodatne_usluge
            ORDER BY COUNT(*) 
            DESC
            LIMIT 3) AS p);
END //
DELIMITER ;

-- trigger koji pri brisanju rezervacije brise i racun vezan za tu rezervaciju to jest
-- ponasa se kao (ON CASCADE DELETE za racun) te sprema one rezervacije u arhivu koje su
-- starije od 10 godina
DELIMITER //
CREATE TRIGGER bd_rezervacija
	BEFORE DELETE ON rezervacija
	FOR EACH ROW
BEGIN
	DELETE FROM racun WHERE racun.id_rezervacija=old.id_rezervacija;
    IF old.kraj_rezervacije < NOW() - INTERVAL 10 YEAR THEN
		INSERT INTO arhiva_rezervacija (id_rezervacija,  id_soba, id_gost,  id_sezona, id_aranzman, pocetak_rezervacije, kraj_rezervacije,  broj_osoba) 
			VALUES  
		(old.id_rezervacija, 
		old.id_soba, 
		old.id_gost, 
		old.id_sezona, 
		old.id_aranzman, 
		old.pocetak_rezervacije, 
		old.kraj_rezervacije, 
		old.broj_osoba);
    END IF;
END//
DELIMITER ;

-- ako se racun brise dodaje se u arhivu ako je stariji od 10 godina
DELIMITER //
CREATE TRIGGER bd_racun
	BEFORE DELETE ON racun
	FOR EACH ROW
BEGIN
	DECLARE kraj_rezervacije_provjera DATE;
    
	SELECT kraj_rezervacije INTO kraj_rezervacije_provjera FROM rezervacija WHERE old.id_rezervacija=rezervacija.id_rezervacija;
    
    IF kraj_rezervacije_provjera < NOW() - INTERVAL 10 YEAR THEN
		INSERT INTO arhiva_racun (id_racun, sifra, id_rezervacija, id_djelatnik,  datum_i_vrijeme_izdavanja, ukupna_cijena) 
		VALUES 
		(old.id_racun,
		old.sifra, 
		old.id_rezervacija, 
		old.id_djelatnik, 
		old.datum_i_vrijeme_izdavanja, 
		old.ukupna_cijena);
	END IF;
END//
DELIMITER ;

-- procedura koja brise sve razervacije i racune starije od 10 godina i sprema i u  
-- arhiv ne spremajući odabrane usluge i odabrane goste
DELIMITER //
CREATE PROCEDURE arhiviranje()
BEGIN
	DELETE FROM rezervacija 
			WHERE kraj_rezervacije < NOW() - INTERVAL 10 YEAR;
END //
DELIMITER ;

-- provjerava može li gost potrošiti sve usluge koje će platiti, odnosno ako ce biti u hotelu 5 dana nesmije rezervirati 6 dana 
-- fitnesa nego samo do 5, isto je napravljeno za usluge koje se rezerviraju na sate
DELIMITER //
CREATE TRIGGER provjera_usluge
    BEFORE INSERT ON odabrane_usluge
    FOR EACH ROW
BEGIN
   DECLARE broj_dana INT;
   DECLARE ime_usluge VARCHAR(50);
   DECLARE greska TEXT;
   SELECT DATEDIFF(kraj_rezervacije, pocetak_rezervacije) INTO broj_dana FROM rezervacija
	   WHERE id_rezervacija = new.id_rezervacija;
   SELECT naziv INTO ime_usluge FROM dodatne_usluge
	   WHERE id_dodatne_usluge = new.id_dodatne_usluge;

   IF ime_usluge LIKE '%/dan' AND broj_dana < new.kolicina THEN
		SET greska = CONCAT("Greska!", " Za odabranu uslugu id: ", new.id_odabrane_usluge,". Unesite kolicinu usluge u trajanju dana, premalo dana boravka previše dana usluge!");
        SIGNAL SQLSTATE '40000'
        SET MESSAGE_TEXT = greska;
   END IF;
   IF ime_usluge LIKE '%/sat' AND broj_dana < new.kolicina/24 THEN 
		SET greska = CONCAT("Greska!", " Za odabranu uslugu id: ", new.id_odabrane_usluge,". Unesite kolicinu usluge u trajanju dana, premalo dana boravka previše sati usluge!");
        SIGNAL SQLSTATE '40000'
        SET MESSAGE_TEXT = greska;
   END IF;
END //
DELIMITER ;

-- zabranjen unos premale sobe za broj gostiju koji su rezervirali
DELIMITER //
CREATE TRIGGER provjera_rezervacija_soba
    AFTER INSERT ON odabrani_gosti
    FOR EACH ROW
    FOLLOWS ai_cetiri_gosta
BEGIN
    DECLARE soba_vrsta VARCHAR(10);
    DECLARE kapacitet INT;
    DECLARE id_sobe INT;
    DECLARE greska TEXT;
    SELECT id_soba INTO id_sobe FROM rezervacija NATURAL JOIN odabrani_gosti WHERE id_rezervacija=new.id_rezervacija;
    SELECT vrsta INTO soba_vrsta FROM soba WHERE id_soba = id_sobe;
    IF soba_vrsta LIKE 'SGL' THEN SET kapacitet = 1;
    ELSEIF soba_vrsta LIKE 'DBL' THEN SET kapacitet = 2;
    ELSEIF soba_vrsta LIKE 'TRPL' THEN SET kapacitet = 3;
    ELSEIF soba_vrsta LIKE 'QDPL' THEN SET kapacitet = 4;
    END IF;
    IF kapacitet < (SELECT broj_osoba FROM rezervacija NATURAL JOIN odabrani_gosti WHERE id_rezervacija=new.id_rezervacija) THEN 
		SET greska = CONCAT("Greska! Za rezervaciju id: ", new.id_rezervacija, ". Premala soba izaberi drugu sa više kapaciteta!");
		SIGNAL SQLSTATE '40000'
        SET MESSAGE_TEXT = greska;
    END IF;
END //
DELIMITER ;

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<  UNOSI  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>> -- 
 INSERT INTO mjesto_prebivalista VALUES 
	-- Bastijanić
	(1000, "Hrvatska", "Pula", 52100, "Uskočka ulica 1" ),
    (1001, "Hrvatska", "Pula", 52100, "Osječka ulica 12" ),
    (1002, "Hrvatska", "Zagreb", 10000, "Trg Bana Jelačića 15" ),
    (1003, "Hrvatska", "Poreč", 52440, "Ulica Stipe Rajka 1"),
    (1004, "Hrvatska", "Poreč", 52440, "Pazinska ulica 2"),
    (1005, "Njemačka", "Köln", 50739, "Uracher Str. 6-8"),
    (1006, "Francuska", "Courbevoie", 92600, "19 Rue Auguste Bailly"),
    (1007, "Francuska", "Saint-Germain-au-Mont-d'Or", 69650, "2 Allée des Pervenches"),
    (1008, "Belgija", "Gent", 9000, "Patijntjestraat 62"),
    (1009, "Belgija", "Gent", 9000 , "Tennisbaanstraat 29"),
    (1010, "Belgija", "Gent", 9000, "Koning Albertlaan 15"),
	-- Blašković
	(1011, "SAD", "New York", 10030, "2471 Gateway Avenue" ),
	(1012, "Francuska", "Pariz", 75000, "70 Faubourg Saint Honoré" ),
	(1013, "SAD", "Helena", 59601, "4704 Peck Street"),
	(1014, "Estonija", "Narva", 69501, "Luige tee 39"),
	(1015, "Rusija", "Moskva", 103132, "Tatarskaya St., 7, apt. 57"),
	(1016, "Kina", "Xi'an", 710049, "Jie Fang Nan Lu 432"),
	(1017, "Hrvatska", "Cavtat", 20210, "Frankopanska ulica 31"),
	(1018, "Hrvatska", "Poreč", 52440, "Vukovarska ulica 11"),
	(1019, "Italija", "Firenca", 50100, "Enrico Forlanini 18"),
	(1020, "Bosna i Hercegovina", "Jajce", 70101, "Kralja Tvrtka 8"),
    -- Žužić
	(1021, "Francuska", "Lambersart", 59130, "36 Place Napoléon"),
	(1022, "Italija", "Arcidosso", 58031, "Via Medina 43"),
	(1023, "Italija", "Badiola", 06070, "Vico Giganti 61"),
	(1024, "Italija", "Bozzana", 38020, "Vicolo Calcirelli 125"),
	(1025, "Njemačka", "Martofte", 5390, "Lille Vibyvej 53"),
	(1026, "Island", "Kirkjubæjarklaustur", 880, "Hlíðarvegur 26"),
	(1027, "Švedska", "Klagerup", 23017, "Mogata Sjöhagen 7"),
	(1028, "Švedska", "Smygehamn", 23022, "Bonaröd 60"),
	(1029, "Švicarska", "Emmenbrücke", 6020, "Wingertweg 89"),
    (1030, "Australija", "Narrack", 3824, "44 Spring Creek Road"),
    -- Lorbek
    (1031, "Finska", "Jyväskylä", 40400, "Kangasmoisionkatu 84"),
    (1032, "Njemačka", "Oelsnitz", 08602, "Kantstraße 79"),
    (1033, "Finska", "Tampere", 33560, "Ysitie 12"),
    (1034, "Mađarska", "Gyulafirátót", 8412, "Izabella u. 69."),
    (1035, "Norveška", "Harstad", 9406, "Bøhns gate 201"),
    (1036, "Francuska", "Levallois-Perret", 92300, "34 rue du Paillle en queue"),
    (1037, "Nizozemska", "Enschede", 7535, "Hogelandstraat 167"),
    (1038, "Belgija", "Brussels", 1070, "Herentalsebaan 181"),
    (1039, "Portugal", "Rebordões", 4795, "R Costa 42"),
    (1040, "Slovenija", "Struge", 1313, "Dunajska 75");

INSERT INTO gost VALUES 
	-- Bastijanić
	(1, "Marko", 		"Vargek", 		"93959475603", 		"222455886", 		1000, STR_TO_DATE("13.1.1990.", "%d.%m.%Y.")),
	(2, "Danko", 		"Papić", 		"2340519874", 		"211131313",		1001, STR_TO_DATE("1.1.1975.", "%d.%m.%Y.")),
	(3, "Ivana", 		"Kindl", 		"27805514564", 		"314436213586",		1006, STR_TO_DATE("1.1.1980.", "%d.%m.%Y.")),
	(4, "Bepo", 		"Radolović", 	"22205114564", 		"411122225", 		1002, STR_TO_DATE("1.1.1960.", "%d.%m.%Y.")),
	(5, "Francois", 	"Dembele", 		"23405519221", 		"5111221275213", 	1007, STR_TO_DATE("1.1.2000.", "%d.%m.%Y.")),
	(6, "David", 		"Goliatus", 	"73405619224", 		"3411221272553", 	1010, STR_TO_DATE("1.1.1998.", "%d.%m.%Y.")),
	(7, "Darko", 		"Majmunčić", 	"93405819834", 		"7212221272", 		1003, STR_TO_DATE("1.1.2001.", "%d.%m.%Y.")),
	(8, "Popio", 		"Sokić", 		"23405513874", 		"9111221272353",	1005, STR_TO_DATE("1.1.1990.", "%d.%m.%Y.")),
	(9, "Osman", 		"N'Tongo", 		"23435519874", 		"2125361272353", 	1009, STR_TO_DATE("1.1.1995.", "%d.%m.%Y.")),
	(10, "Samurai", 	"Jack", 		"23405522874", 		"1122342212798", 	1008, STR_TO_DATE("1.1.1950.", "%d.%m.%Y.")),
    -- Blašković
	(11, "Marin", 		"Petrović", 	"95147285322", 		"887412695", 		1017, STR_TO_DATE("5.11.1992.", "%d.%m.%Y.")),
    (12, "Ivica", 		"Butković", 	"63528877419", 		"22514409509", 		1018, STR_TO_DATE("15.2.2000.", "%d.%m.%Y.")),
    (13, "Zvonko",		"Ahmetović", 	"74889652377", 		"0214417895200", 	1020, STR_TO_DATE("2.2.1972.", "%d.%m.%Y.")),
    (14, "Roberto", 	"Alesi", 		"85441798521745", 	"D7-521889035", 	1019, STR_TO_DATE("1.7.1961.", "%d.%m.%Y.")),
    (15, "John", 		"Vargas",		"552177895632571", 	"N3-P52174887", 	1011, STR_TO_DATE("5.11.2001.", "%d.%m.%Y.")),
    (16, "Anne", 		"Vargas", 		"996058074163854", 	"O-8-T5214789",  	1011, STR_TO_DATE("28.5.1998.", "%d.%m.%Y.")),
    (17, "Jane", 		"Martinez", 	"258774040856983", 	"J-4-T2284900",  	1013, STR_TO_DATE("18.8.1955.", "%d.%m.%Y.")),
    (18, "Yuri", 		"Krylov", 		"3557417488547", 	"Z-84577421", 	 	1014, STR_TO_DATE("23.12.1984.", "%d.%m.%Y.")),
    (19, "Gregory", 	"Yermolayev", 	"22147805063811", 	"66058471958152-O", 1015, STR_TO_DATE("3.3.1993.", "%d.%m.%Y.")),
    (20, "Ilona", 		"Yermolayev", 	"88745215847853", 	"22147785693005-O", 1015, STR_TO_DATE("20.2.1990.", "%d.%m.%Y.")),
    -- Žužić
    (21, "Sigurdór",	"Sigurðarson", 	"453217806867", 	"3583499493-S",		1026, STR_TO_DATE("3.3.1979", "%d.%m.%Y.")),
    (22, "Virginio",	"Napolitani", 	"337959258", 		"IT-22-5363", 		1024, STR_TO_DATE("26.1.1975", "%d.%m.%Y.")),
    (23, "Degna",   	"Napolitani", 	"3557371854", 		"IT-22-5437", 		1024, STR_TO_DATE("8.6.1995", "%d.%m.%Y.")),
    (24, "Chiara",  	"Napolitani", 	"3835692474", 		"IT-31-4485", 		1024, STR_TO_DATE("21.9.1972", "%d.%m.%Y.")),
    (25, "Alida", 		"Lucchese", 	"3647787190", 		"IT-82-2522", 		1023, STR_TO_DATE("9.6.1936", "%d.%m.%Y.")),
    (26, "Tito", 		"Lucchese", 	"3737633196", 		"IT-82-1896", 		1023, STR_TO_DATE("26.9.1935", "%d.%m.%Y.")),
    (27, "Petra", 		"Arvidsson", 	"460602-1782",		"95112696019", 		1027, STR_TO_DATE("26.8.1965", "%d.%m.%Y.")),
    (28, "Mathilda",	"Arvidsson", 	"470212-7244", 		"57898618173", 		1027, STR_TO_DATE("12.2.1987", "%d.%m.%Y.")),
    (29, "Dennis", 		"Feierabend", 	"364265964", 		"492919025992", 	1025, STR_TO_DATE("26.8.1985", "%d.%m.%Y.")),
    (30, "Cameron", 	"Warnes", 		"67769560", 		"AU491316167 ", 	1030, STR_TO_DATE("24.10.1998", "%d.%m.%Y.")),
    -- Lorbek
    (31, "Seija", 		"Tumala", 		"99293259", 		"260963-159D", 		1031, STR_TO_DATE("4.8.1967", "%d.%m.%Y.")),    
    (32, "Lukas", 		"Kuester", 		"15266636", 		"59770177481", 		1032, STR_TO_DATE("31.10.1986", "%d.%m.%Y.")),
    (33, "Esa",   		"Vuorinen", 	"25686343", 		"140979-3233", 		1033, STR_TO_DATE("14.9.1979", "%d.%m.%Y.")),
    (34, "Fredek",		"Hegedüs", 		"60812262", 		"4502243461216", 	1034, STR_TO_DATE("8.6.1983", "%d.%m.%Y.")),
    (35, "Ema",   		"Loken", 		"38936677", 		"93756622396", 		1035, STR_TO_DATE("20.9.1954", "%d.%m.%Y.")),
    (36, "Vincent",	    "Levasseur", 	"15069175", 		"1000232820059-67", 1036, STR_TO_DATE("23.9.1972", "%d.%m.%Y.")),
    (37, "Brechje", 	"Franssen",		"88812345", 		"431925537", 		1037, STR_TO_DATE("1.5.1992", "%d.%m.%Y.")),
    (38, "Lirienne", 	"Riquier", 		"75934198", 		"196062489", 		1038, STR_TO_DATE("28.2.1975", "%d.%m.%Y.")),
    (39, "Vitór", 		"Rocha", 		"31938425", 		"15553626", 		1039, STR_TO_DATE("14.1.1965", "%d.%m.%Y.")),
    (40, "Vidosav", 	"Sirotić", 		"78065578", 		"715396578", 		1040, STR_TO_DATE("2.7.1945", "%d.%m.%Y.")),
	-- Bastijanić
	(41, "Ivana", 		"Vargek", 		"276066579782", 	"30-8712-5012", 	1021, STR_TO_DATE("10.4.2000", "%d.%m.%Y.")),
    (42, "Matko", 		"Vargek", 		"709816065612", 	"01-19-23-532", 	1021, STR_TO_DATE("9.5.1975", "%d.%m.%Y.")),
    (43, "Davor", 		"Papić", 		"32775708652", 		"BO942790182", 		1022, STR_TO_DATE("25.12.2000", "%d.%m.%Y.")),
    (44, "Danko", 		"Kindl", 		"39264323972", 		"HV199279252", 		1022, STR_TO_DATE("12.8.1994", "%d.%m.%Y.")),
    (45, "Zoran", 		"Radolović", 	"35133066752", 		"DT332273432", 		1022, STR_TO_DATE("27.2.1999", "%d.%m.%Y.")),
    (46, "Ivana", 		"Radolović", 	"38422293162", 		"AJ623781332", 		1022, STR_TO_DATE("12.5.1989", "%d.%m.%Y.")),
    (47, "Mala", 		"Dembele", 		"520-89652752", 	"910630-28552", 	1028, STR_TO_DATE("30.6.1991", "%d.%m.%Y.")),
    (48, "Mirko", 		"Goliatus", 	"4123673592", 		"2222222222211", 	1029, STR_TO_DATE("27.8.1978", "%d.%m.%Y.")),
    (49, "Ngolo", 		"Arizen", 		"2804842122", 		"1213213113123", 	1029, STR_TO_DATE("25.7.1989", "%d.%m.%Y.")),
    (50, "Nino", 		"Sokić", 		"68066801602", 		"12321321322132", 	1029, STR_TO_DATE("22.9.1989", "%d.%m.%Y.")),
	-- Blašković
	(51,"Anica", 		"Petrović",		"588743050834",		"665248919",		1017,STR_TO_DATE("05.05.1990.", "%d.%m.%Y.")),
	(52,"Vanya", 		"Yermolayev",	"21745015887823",	"34198765633005-P", 1015,STR_TO_DATE("11.02.2015.", "%d.%m.%Y.")),
	(53,"Nikita", 		"Krylov",		"1187898528284",	"IO-15577333",		1014,STR_TO_DATE("28.03.1985.", "%d.%m.%Y.")),
	(54,"Martha", 		"Olson",		"5892065815574",	"39532236811",		1013,STR_TO_DATE("12.04.1979.", "%d.%m.%Y.")),
	(55,"Dragica", 		"Ahmetović",	"74815962326",		"959815178482",		1020,STR_TO_DATE("12.12.1970.", "%d.%m.%Y.")),
	(56,"Senad", 		"Ahmetović",	"40356201879",		"1247741472374",	1020,STR_TO_DATE("5.10.2003.", "%d.%m.%Y.")),
	(57,"Sandra", 		"Alesi",		"0028793302159",	"MJ514774723",		1019,STR_TO_DATE("30.05.1959.", "%d.%m.%Y.")),
	(58,"Snježana", 	"Damianić",		"74122038057",		"632591487",		1018,STR_TO_DATE("2.06.2000.", "%d.%m.%Y.")),
	(59,"Yue", 			"Yan Ch'ang",	"2477854632158954",	"BB-654121777823",	1016,STR_TO_DATE("22.10.1955.", "%d.%m.%Y.")),
	(60,"Lin ", 		"Yan Ch'ang",	"0087056321589651",	"QT-1508741465289", 1016,STR_TO_DATE("1.07.1960.", "%d.%m.%Y.")),
	-- Žužić
    (61, "Alice", 		"Roux", 		"27606657978", 		"30-8712-501", 		1021, STR_TO_DATE("10.4.1976", "%d.%m.%Y.")),
    (62, "Davet", 		"Roux", 		"70981606561", 		"01-19-23-53", 		1021, STR_TO_DATE("9.5.1974", "%d.%m.%Y.")),
    (63, "Gabriele", 	"Milanesi", 	"3277570865", 		"BO94279018", 		1022, STR_TO_DATE("25.12.1964", "%d.%m.%Y.")),
    (64, "Ermenegilda", "Milanesi", 	"3926432397", 		"HV19927925", 		1022, STR_TO_DATE("12.8.1994", "%d.%m.%Y.")),
    (65, "Rosalia", 	"Milanesi", 	"3513306675", 		"DT33227343", 		1022, STR_TO_DATE("23.2.1989", "%d.%m.%Y.")),
    (66, "Edgardo", 	"Milanesi", 	"3842229316", 		"AJ62378133", 		1022, STR_TO_DATE("12.5.1964", "%d.%m.%Y.")),
    (67, "Thomas",  	"Hellström", 	"520-8965275", 		"910630-2855", 		1028, STR_TO_DATE("30.5.1991", "%d.%m.%Y.")),
    (68, "Eliane", 	 	"Keller", 		"412367359", 		"AOWNKM4ZSD2", 		1029, STR_TO_DATE("23.2.1968", "%d.%m.%Y.")),
    (69, "Frau",   	 	"Keller", 		"280484212", 		"BKJLNPMT4KF", 		1029, STR_TO_DATE("21.1.1994", "%d.%m.%Y.")),
    (70, "Fritz",   	"Keller", 		"6806680160", 		"JGKXYSHBPB5", 		1029, STR_TO_DATE("22.9.1960", "%d.%m.%Y.")),
	-- Lorbek
    (71, "Stana",		"Sirotić", 		"87050486", 		"132013975", 		1040, STR_TO_DATE("6.2.1948", "%d.%m.%Y.")),
	(72, "Lojzka",		"Sirotić", 		"54620424", 		"787602386", 		1040, STR_TO_DATE("12.9.1969", "%d.%m.%Y.")),
	(73, "Isak", 		"Sirotić", 		"88037678", 		"974569346", 		1040, STR_TO_DATE("25.1.1975", "%d.%m.%Y.")),
	(74, "Aino", 		"Vuorinen", 	"19352901", 		"211185-037J", 		1033, STR_TO_DATE("6.11.1981", "%d.%m.%Y.")),
	(75, "Päiviö", 		"Vuorinen", 	"20905391", 		"011071-545L", 		1033, STR_TO_DATE("3.3.1996", "%d.%m.%Y.")),
	(76, "Remi", 		"Levasseur", 	"22448168", 		"537024260", 		1036, STR_TO_DATE("14.2.1989", "%d.%m.%Y.")),
	(77, "Bernard", 	"Levasseur", 	"04181877", 		"691784131", 		1036, STR_TO_DATE("1.5.1972", "%d.%m.%Y.")),
	(78, "Dani", 		"Tumala", 		"35157380", 		"141047-3107", 		1031, STR_TO_DATE("13.4.1988", "%d.%m.%Y.")),
	(79, "Jarl", 		"Loken", 		"65515456", 		"886825362", 		1035, STR_TO_DATE("16.12.1955", "%d.%m.%Y.")),
	(80, "Rafael",  	"Rocha", 		"98661592", 		"700516718", 		1039, STR_TO_DATE("10.8.1968", "%d.%m.%Y."));

INSERT INTO soba (id_soba,sifra,kat,standardna_cijena,vrsta)VALUES 
	-- Bastijanić
	(100, DEFAULT, "prvi", 100, "SGL"),
	(101, DEFAULT, "prvi", 200, "DBL"),
	(102, DEFAULT, "prvi", 200, "DBL"),
	(103, DEFAULT, "prvi", 300, "TRPL"),
	(104, DEFAULT, "prvi", 350, "TRPL"),
	(105, DEFAULT, "prvi", 400, "QDPL"),
	(106, DEFAULT, "prvi", 400, "QDPL"),
	(107, DEFAULT, "prvi", 400, "QDPL"),
	(108, DEFAULT, "prvi", 450, "QDPL"),
	(109, DEFAULT, "prvi", 200, "SGL"),
	(110, DEFAULT, "prvi", 200, "DBL"),
    -- Blašković
    (111, DEFAULT, "peti", 150, "SGL"),
    (112, DEFAULT, "treći", 280, "TWIN"),
    (113, DEFAULT, "drugi", 125, "SGL"),
    (114, DEFAULT, "prvi", 405, "QDPL"),
    (115, DEFAULT, "četvrti", 375, "QDPL"),
    (116, DEFAULT, "drugi", 345, "TRPL"),
    (117, DEFAULT, "drugi", 405, "QDPL"),
    (118, DEFAULT, "četvrti", 485, "TRPL"),
    (119, DEFAULT, "šesti", 300, "TWIN"),
    (120, DEFAULT, "prvi", 290, "DBL"),
    -- Žužić
    (121, DEFAULT, "drugi", 125, "DBL"),
    (122, DEFAULT, "drugi", 120, "TWIN"),
    (123, DEFAULT, "treći", 150, "SGL"),
    (124, DEFAULT, "treći", 125, "DBL"),
    (125, DEFAULT, "treći", 100, "SGL"),
    (126, DEFAULT, "četvrti", 280, "TRPL"),
    (127, DEFAULT, "četvrti", 215, "TWIN"),
    (128, DEFAULT, "četvrti", 175, "SGL"),
    (129, DEFAULT, "peti", 400, "DBL"),
    (130, DEFAULT, "šesti", 550, "QDPL"),
    -- Lorbek
    (131, DEFAULT, "šesti", 400, "QDPL"),
    (132, DEFAULT, "treći", 300, "SGL"),
    (133, DEFAULT, "prvi", 275, "TWIN"),
    (134, DEFAULT, "peti", 150, "QDPL"),
    (135, DEFAULT, "treći", 430, "DBL"),
    (136, DEFAULT, "drugi", 220, "TRPL"),
    (137, DEFAULT, "šesti", 190, "TWIN"),
    (138, DEFAULT, "četvrti", 450, "TRPL"),
    (139, DEFAULT, "drugi", 500, "QDPL"),
    (140, DEFAULT, "šesti", 575, "SGL");
    
INSERT INTO dodatne_usluge VALUES 
	-- Bastijanić
	(1, "Wellness/dan", 200),
	(2, "Šampanjac/kom ", 1000),
	(3, "Najam Bicikla/sat", 40),
	(4, "Dodatni ručak", 50),
	(5, "Teretana/dan", 45),
	(6, "Nadoplata za kućnog ljubimca/po ljubimcu", 250),
    -- Blašković
    (7, "Dječja igraonica/sat", 35),
    (8, "Vanjski bazen/dan", 50),
    (9, "Parking/dan", 30),
    (10, "Turistička mapa/kom", 10),
    (11, "Dostava razne hrane/dan", 50),
    (12, "Kabelska televizija/dan", 30),
    -- Žužić
    (13, "Dodatni ručnik/kom", 15),
    (14, "Karaoke/sat", 40),
    (15, "Klima/dan", 40),
    (16, "Brži internet/dan", 20),
    (17, "Masažna stolica/sat", 45),
    (18, "Hladnjak/dan", 35),
    -- Lorbek
    (19, "Sauna/sat", 90),
    (20, "Turska kupelj/sat", 150),
    (21, "Dodatna večera", 50),
    (22, "Privatna plaža/dan", 300),
    (23, "Vozač/sat", 100),
    (24, "Najam helikoptera/dan", 1500);
    
INSERT INTO aranzman VALUES 
	(111, 'RO', 'Room Only: Pružanje stambenog smještaja bez obroka', 0.00),
	(114, 'BB', 'Bed & Breakfast: Pružanje stambenog smještaja s doručkom', 50.00),
	(115, 'HB', 'Polu Pansion: doručak i večera', 100.00),
	(116, 'FB', 'Puni Pansion: doručak, ručak i večera', 200.00),
	(117, 'AI', 'All Inclusive: konzumiranje hrane i pića u bilo kojoj količini, ograničenje za alkoholna pića', 300.00),
	(118, 'UAI', 'Ultra All Inclusive: raznolik jelovnik tokom dana uz veliki izbor toplih predjela jela, deserti i alkohol', 500.00);

INSERT INTO sezona VALUES 
	(11, 'A', "Ljeto", 2.00),
	(12, 'B', "Jesen", 1.25),
	(13, 'C', "Zima", 1.00),
	(14, 'D', "Proljeće", 1.50);
    
INSERT INTO zvanje VALUES 
	(50, "Direktor", "Izvršni direktor", 25850.00),
	(51, "Financijski direktor", "Upravlja hotelskim financijama, donosi financijski plan za svaku godinu", 21200.00),
	(52, "Upravni službenik", "Odgovoran za poslovnu administraciju, uključujući svakodnevno poslovanje i cjelokupnu izvedbu", 16750.00),
	(53, "Službenik za komunikaciju", "Odgovoran za komunikaciju sa zaposlenicima, medijima, zajednicom i javnošću", 15840.00),
	(54, "Glavni analitičar", "Odgovoran za analizu i tumačenje podataka", 15200.00),
	(55, "Direktor za inovacije i investicije", "Odgvoran za inovacije, investicije poput banaka, osgiuravatelja itd", 16100.00),
	(56, "Direktor marketinga", "Odgovoran za marketing", 17480.00),
	(57, "Strateški direktor", "Odgovoran za strategiju i upravljanje hotelom", 14400.00),
	(58, "Glavni mrežni službenik", "Odgovoran za web prisutnost hotela i cijelokupnu internetsku prisutnost", 11150.00),
	(59, "Analitičar", "Analiza podataka", 9500.00),
	(60, "Sakupljač podataka", "Sakuplja podatke i šalje na analizu", 9250.00),
	(61, "Oglašivač", "Bavi se reklamacijom hotela", 8150.00),
	(62, "Web dizajner", "Bavi se izradom dizajna za web stranicu hotela", 8900.00),
	(63, "Web programer", "Bavi se izradom web aplikacije hotela", 11225.00),
	(64, "Database dizajner", "Bavi se izradom baze podataka hotela", 10480.00),
	(65, "Korisnička podrška", "Bavi se komunikacijom sa klijentima", 5820.00),
	(66, "Web administrator", "Održava web stranicu hotela", 8100.00),
	(67, "Mrežni upravitelj", "Vodi i popravlja hotelsku računalnu mrežu", 7400.00),
	(68, "Službenik u osiguranju", "Odgovaran za osiguranje hotelske inventure", 7250.00),
	(69, "Administrator nabave", "Bavi se nabavom potrebština za hotel", 6600.00),
	(70, "Hotelski liječnik", "Brine se o zdravlju osoblja i gostiju", 9150.00),
	(71, "Glavni recepcioner", "Najviša pozicija na recepciji, radi administrativne poslove", 7880.00),
	(72, "Recepcioner", "Vrši rezervacije uživo, predaje gostima ključeve soba i daje informacije", 6125.00),
	(73, "Glavni kuhar", "Voditelj u kuhinji, priprema hranu, provjerava kvalitetu hrane", 8200.00),
	(74, "Pomoćni kuhar", "Priprema hranu u kuhinji", 6000.00),
	(75, "Glavni konobar", "Voditelj konobarenja", 7500.00),
	(76, "Konobar", "Donosi gostima i piće hranu i naplačuje", 5750.00),
	(77, "Servir", "Donosi gostima hranu i sprema stolove", 4440.00),
	(78, "Čistać", "Čiste blagavanoicu, kuhinju, recepciju", 4985.00),
	(79, "Domar", "Popravlja manje kvarove u hotelu", 4000.00),
	(80, "Vrtlar", "Brine o okolišu hotela", 4200.00),
	(81, "Spremač", "Posprema i čisti sobe", 4800.00),
	(82, "Dostavljač", "Dostavlju hranu i piće u sobe", 4100.00);

INSERT INTO djelatnik VALUES 
	-- Bastijanić
	(1, "Filip", "Dautović", 50, STR_TO_DATE("13.1.2010.", "%d.%m.%Y.")),
	(2, "David", "Martinčić", 78, STR_TO_DATE("17.4.2018.", "%d.%m.%Y.")),
	(3, "Marko", "Savić", 78, STR_TO_DATE("17.4.2018.", "%d.%m.%Y.")),
	(4, "Lovre", "Gavrilović", 78, STR_TO_DATE("20.4.2014.", "%d.%m.%Y.")),
	(5, "Čika", "Bošnjak", 76, STR_TO_DATE("20.4.2014.", "%d.%m.%Y.")),
	(6, "Barbara", "Čekić", 72, STR_TO_DATE("20.8.2020.", "%d.%m.%Y.")),
	(7, "Filip", "Markić", 72, STR_TO_DATE("13.1.2020.", "%d.%m.%Y.")),
	(8, "David", "Skoko", 73, STR_TO_DATE("17.4.2018.", "%d.%m.%Y.")),
	(9, "Ivana", "Savić", 77, STR_TO_DATE("17.4.2018.", "%d.%m.%Y.")),
	(10, "Sunčana", "Darkić", 77, STR_TO_DATE("22.4.2016.", "%d.%m.%Y.")),
	(11, "Lea", "Matić", 77, STR_TO_DATE("20.4.2016.", "%d.%m.%Y.")),
	(12, "Tea", "Bačić", 74, STR_TO_DATE("22.9.2017.", "%d.%m.%Y.")),
	(13, "Štef", "Bezezić", 51, STR_TO_DATE("22.9.2010.", "%d.%m.%Y.")),
	(14, "Ivan", "Kovač", 70, STR_TO_DATE("22.9.2010.", "%d.%m.%Y.")),
	(15, "Blaženka", "Šarić", 82, STR_TO_DATE("11.3.2015.", "%d.%m.%Y.")),
	(16, "Toni", "Stojanović", 81, STR_TO_DATE("11.6.2018.", "%d.%m.%Y.")),
	(17, "Goran", "Petrović", 81, STR_TO_DATE("11.6.2013.", "%d.%m.%Y.")),
	(18, "Irena", "Perić", 81, STR_TO_DATE("11.6.2015.", "%d.%m.%Y.")),
	(19, "Marin", "Galić", 81, STR_TO_DATE("11.8.2011.", "%d.%m.%Y.")),
	(20, "Darko", "Galić", 75, STR_TO_DATE("21.8.2013.", "%d.%m.%Y.")),
    -- Lorbek
    (21, "Domagoj", "Radolović", 53, STR_TO_DATE("3.5.1976.", "%d.%m.%Y.")),
	(22, "Dominik", "Vrkić", 54, STR_TO_DATE("4.4.2000.", "%d.%m.%Y.")),
	(23, "Vanja", "Vrbanović", 69, STR_TO_DATE("12.2.2003.", "%d.%m.%Y.")),
	(24, "Goran", "Garić", 64, STR_TO_DATE("19.11.1996.", "%d.%m.%Y.")),
	(25, "Ksenija", "Gorički", 64, STR_TO_DATE("1.6.2013.", "%d.%m.%Y.")),
	(26, "Lara", "Vidak", 69, STR_TO_DATE("2.3.1999.", "%d.%m.%Y.")),
	(27, "Marina", "Dobrić", 65, STR_TO_DATE("5.3.1995.", "%d.%m.%Y.")),
	(28, "Božica", "Šintić", 68, STR_TO_DATE("31.10.1994.", "%d.%m.%Y.")),
	(29, "Božo", "Kolar", 77, STR_TO_DATE("11.11.2014.", "%d.%m.%Y.")),
	(30, "David", "Maras", 69, STR_TO_DATE("6.4.2006.", "%d.%m.%Y.")),
	(31, "Dinko", "Delibegović", 74, STR_TO_DATE("15.6.1954.", "%d.%m.%Y.")),
	(32, "Adrijan", "Zavidović", 69, STR_TO_DATE("23.7.2001.", "%d.%m.%Y.")),
	(33, "Denis", "Bare", 65, STR_TO_DATE("5.9.2009.", "%d.%m.%Y.")),
	(34, "Stjepan", "Marak", 78, STR_TO_DATE("12.8.2013.", "%d.%m.%Y.")),
	(35, "Tome", "Karamar", 69, STR_TO_DATE("2.2.1991.", "%d.%m.%Y.")),
	(36, "Patrik", "Janeš", 66, STR_TO_DATE("13.12.2003.", "%d.%m.%Y.")),
	(37, "Florijan", "Vulić", 76, STR_TO_DATE("9.2.2004.", "%d.%m.%Y.")),
	(38, "Jelena", "Babić", 65, STR_TO_DATE("3.3.2010.", "%d.%m.%Y.")),
	(39, "Tatjana", "Babeli", 66, STR_TO_DATE("1.3.1978.", "%d.%m.%Y.")),
	(40, "Rea", "Soldo", 65, STR_TO_DATE("28.1.1996.", "%d.%m.%Y.")),
    -- Žužić
	(41, "Đurđica", "Pavić", 68, STR_TO_DATE("25.2.2013", "%d.%m.%Y.")),
	(42, "Velibor", "Župan", 52, STR_TO_DATE("10.2.2014", "%d.%m.%Y.")),
	(43, "Marta", "Ilić", 72, STR_TO_DATE("17.3.2014", "%d.%m.%Y.")),
	(44, "Silvijo", "Branković", 71, STR_TO_DATE("6.2.2015", "%d.%m.%Y.")),
	(45, "Dragica", "Novak", 81, STR_TO_DATE("2.6.2015", "%d.%m.%Y.")),
	(46, "Emilija", "Bogdanić", 80, STR_TO_DATE("11.6.2015", "%d.%m.%Y.")),
	(47, "Milenko", "Knežević", 61, STR_TO_DATE("13.10.2015", "%d.%m.%Y.")),
	(48, "Renata", "Adamić", 59, STR_TO_DATE("3.8.2016", "%d.%m.%Y.")),
	(49, "Grgur", "Perko", 79, STR_TO_DATE("16.8.2016", "%d.%m.%Y.")),
	(50, "Zorka", "Medved", 81, STR_TO_DATE("8.12.2016", "%d.%m.%Y.")),
	(51, "Zlata", "Grbić", 59, STR_TO_DATE("15.2.2017", "%d.%m.%Y.")),
	(52, "Stevo", "Jugovac", 77, STR_TO_DATE("29.9.2017", "%d.%m.%Y.")),
	(53, "Kristijan", "Pavletić", 56, STR_TO_DATE("19.7.2018", "%d.%m.%Y.")),
	(54, "Branimir", "Kovačević", 82, STR_TO_DATE("9.8.2018", "%d.%m.%Y.")),
	(55, "Đurđa", "Zorić", 76, STR_TO_DATE("24.9.2018", "%d.%m.%Y.")),
	(56, "Goran", "Filipović", 67, STR_TO_DATE("31.10.2018", "%d.%m.%Y.")),
	(57, "Maja", "Vlahović", 62, STR_TO_DATE("22.2.2019", "%d.%m.%Y.")),
	(58, "Sandi", "Golub", 74, STR_TO_DATE("8.3.2019", "%d.%m.%Y.")),
	(59, "Igor", "Franjić", 74, STR_TO_DATE("6.6.2019", "%d.%m.%Y.")),
	(60, "Tomo", "Nikolić", 65, STR_TO_DATE("10.7.2019", "%d.%m.%Y.")),
     -- Blašković
    (61, "Ivica", "Ivanović", 76, STR_TO_DATE("17.8.2017", "%d.%m.%Y.")),
	(62, "Sara", "Knezović", 80, STR_TO_DATE("18.9.2002", "%d.%m.%Y.")),
	(64, "Katarina", "Maras", 78, STR_TO_DATE("2.11.2010", "%d.%m.%Y.")),
	(65, "Max", "Tijanić", 79, STR_TO_DATE("19.5.2006", "%d.%m.%Y.")),
	(66, "Michelle", "Kovačić", 61, STR_TO_DATE("16.3.2004", "%d.%m.%Y.")),
	(67, "Darko", "Horvat", 72, STR_TO_DATE("23.12.2012", "%d.%m.%Y.")),
	(68, "Petar", "Jovanović", 60, STR_TO_DATE("02.02.2018", "%d.%m.%Y.")),
	(69, "Ivona", "Licul", 60, STR_TO_DATE("12.06.2015", "%d.%m.%Y.")),
	(70, "Martina", "Kolar", 59, STR_TO_DATE("05.12.2011", "%d.%m.%Y.")),
	(71, "Nikola", "Tominović", 63, STR_TO_DATE("15.07.2007", "%d.%m.%Y.")),
	(72, "Dean", "Selak", 63, STR_TO_DATE("11.11.2009", "%d.%m.%Y.")),
	(73, "Siniša", "Novak", 80, STR_TO_DATE("30.01.2003", "%d.%m.%Y.")),
	(74, "Petar", "Stanković", 74, STR_TO_DATE("15.07.2007", "%d.%m.%Y.")),
	(75, "Milorad", "Ivanov", 74, STR_TO_DATE("23.03.2009", "%d.%m.%Y.")),
	(76, "Milan", "Grgić", 74, STR_TO_DATE("29.04.2011", "%d.%m.%Y.")),
	(77, "Nikola", "Klarić", 74, STR_TO_DATE("5.05.2001", "%d.%m.%Y.")),
	(78, "Petar", "Marković", 53, STR_TO_DATE("15.07.2007", "%d.%m.%Y.")),
	(79, "Aleksandar", "Vuković", 61, STR_TO_DATE("15.05.2020", "%d.%m.%Y.")),
	(80, "Marko", "Kralj", 61, STR_TO_DATE("05.03.2012", "%d.%m.%Y.")),
	(81, "Domagoj", "Rajković", 57, STR_TO_DATE("15.04.2012", "%d.%m.%Y.")),
	(82, "Petar", "Jurić", 58, STR_TO_DATE("03.03.2003", "%d.%m.%Y.")),
	(83, "Katarina", "Butković", 81, STR_TO_DATE("05.07.2019", "%d.%m.%Y.")),
	(84, "Eldina", "Gajić", 81, STR_TO_DATE("12.09.2019", "%d.%m.%Y.")),
	(85, "Andrej", "Miletić", 67, STR_TO_DATE("29.10.2012", "%d.%m.%Y.")),
	(86, "Sanja", "Lovrić", 81, STR_TO_DATE("05.07.2019", "%d.%m.%Y.")),
	(87, "Mauro", "Kos", 55, STR_TO_DATE("13.02.2020", "%d.%m.%Y.")),
	(88, "Slobodanka", "Jugovac", 76, STR_TO_DATE("10.12.2019", "%d.%m.%Y.")),
	(89, "Rahela", "Adamić", 77, STR_TO_DATE("23.04.2019", "%d.%m.%Y.")),
	(90, "Dražen", "Golub", 78, STR_TO_DATE("18.02.2018", "%d.%m.%Y.")),
	(91, "Vatroslav", "Novak", 72, STR_TO_DATE("9.01.2019", "%d.%m.%Y."));
    
INSERT INTO rezervacija VALUES
--   id, id_soba, id_gost, id_sezona, id_aranzman, pocetak, kraj, broj_gostiju
	-- Bastijanić
	(500, 103, 1, DEFAULT, 111, STR_TO_DATE("20.4.2021.", "%d.%m.%Y."), STR_TO_DATE("25.4.2021.", "%d.%m.%Y."), DEFAULT),
    (501, 101, 2, DEFAULT, 114, STR_TO_DATE("20.4.2021.", "%d.%m.%Y."), STR_TO_DATE("27.4.2021.", "%d.%m.%Y."), DEFAULT),
    (502, 102, 3, DEFAULT, 114, STR_TO_DATE("20.4.2021.", "%d.%m.%Y."), STR_TO_DATE("30.4.2021.", "%d.%m.%Y."), DEFAULT),
    (503, 104, 4, DEFAULT, 118, STR_TO_DATE("30.4.2021.", "%d.%m.%Y."), STR_TO_DATE("10.5.2021.", "%d.%m.%Y."), DEFAULT),
    (504, 108, 5, DEFAULT, 118, STR_TO_DATE("30.7.2020.", "%d.%m.%Y."), STR_TO_DATE("10.8.2020.", "%d.%m.%Y."), DEFAULT),
    (505, 107, 6, DEFAULT, 118, STR_TO_DATE("10.8.2020.", "%d.%m.%Y."), STR_TO_DATE("20.8.2020.", "%d.%m.%Y."), DEFAULT),
    (506, 101, 7, DEFAULT, 115, STR_TO_DATE("10.8.2020.", "%d.%m.%Y."), STR_TO_DATE("22.8.2020.", "%d.%m.%Y."), DEFAULT),
    (507, 102, 8, DEFAULT, 115, STR_TO_DATE("10.8.2020.", "%d.%m.%Y."), STR_TO_DATE("24.8.2020.", "%d.%m.%Y."), DEFAULT),
    (508, 100, 9, DEFAULT, 115, STR_TO_DATE("10.2.2020.", "%d.%m.%Y."), STR_TO_DATE("24.2.2020.", "%d.%m.%Y."), DEFAULT),
    (509, 125, 9, DEFAULT, 115, STR_TO_DATE("10.2.2020.", "%d.%m.%Y."), STR_TO_DATE("26.2.2020.", "%d.%m.%Y."), DEFAULT),
    (510, 105, 10, DEFAULT, 111, STR_TO_DATE("10.2.2020.", "%d.%m.%Y."), STR_TO_DATE("11.2.2020.", "%d.%m.%Y."), DEFAULT),
    -- Blašković
	(511, 112, 59, DEFAULT, 116, STR_TO_DATE("14.01.2021", "%d.%m.%Y."), STR_TO_DATE("12.03.2021", "%d.%m.%Y."), DEFAULT),
    (512, 119, 15, DEFAULT, 114, STR_TO_DATE("20.06.2021", "%d.%m.%Y."), STR_TO_DATE("27.06.2021", "%d.%m.%Y."), DEFAULT),
    (513, 119, 12, DEFAULT, 118, STR_TO_DATE("15.01.2019", "%d.%m.%Y."), STR_TO_DATE("30.01.2019", "%d.%m.%Y."), DEFAULT),
    (514, 118, 55, DEFAULT, 115, STR_TO_DATE("8.03.2020", "%d.%m.%Y."), STR_TO_DATE("12.03.2020", "%d.%m.%Y."), DEFAULT),
    (515, 120, 14, DEFAULT, 116, STR_TO_DATE("05.09.1998", "%d.%m.%Y."), STR_TO_DATE("05.10.1998", "%d.%m.%Y."), DEFAULT),
    (516, 112, 11, DEFAULT, 116, STR_TO_DATE("15.08.2006", "%d.%m.%Y."), STR_TO_DATE("18.08.2006", "%d.%m.%Y."), DEFAULT),
    (517, 115, 20, DEFAULT, 117, STR_TO_DATE("13.04.2018", "%d.%m.%Y."), STR_TO_DATE("20.04.2018", "%d.%m.%Y."), DEFAULT),
    (518, 112, 18, DEFAULT, 115, STR_TO_DATE("28.12.2011", "%d.%m.%Y."), STR_TO_DATE("01.01.2012", "%d.%m.%Y."), DEFAULT),
    (519, 120, 54, DEFAULT, 114, STR_TO_DATE("12.06.1999", "%d.%m.%Y."), STR_TO_DATE("01.07.1999", "%d.%m.%Y."), DEFAULT),
    (520, 113, 14, DEFAULT, 115, STR_TO_DATE("12.11.1981", "%d.%m.%Y."), STR_TO_DATE("12.12.1981", "%d.%m.%Y."), DEFAULT),
    -- Žužić
	(521, 121, 25, DEFAULT, 115, STR_TO_DATE("10.1.2021", "%d.%m.%Y."), STR_TO_DATE("5.3.2021", "%d.%m.%Y."), DEFAULT),
    (522, 121, 28, DEFAULT, 116, STR_TO_DATE("11.1.2020", "%d.%m.%Y."), STR_TO_DATE("3.3.2020", "%d.%m.%Y."), DEFAULT),
    (523, 125, 21, DEFAULT, 115, STR_TO_DATE("10.1.2021", "%d.%m.%Y."), STR_TO_DATE("14.1.2021", "%d.%m.%Y."), DEFAULT),
    (524, 124, 61, DEFAULT, 118, STR_TO_DATE("15.7.2018", "%d.%m.%Y."), STR_TO_DATE("28.7.2018", "%d.%m.%Y."), DEFAULT),
    (525, 125, 29, DEFAULT, 117, STR_TO_DATE("22.6.2019", "%d.%m.%Y."), STR_TO_DATE("28.6.2019", "%d.%m.%Y."), DEFAULT),
    (526, 126, 22, DEFAULT, 115, STR_TO_DATE("26.4.2019", "%d.%m.%Y."), STR_TO_DATE("2.5.2019", "%d.%m.%Y."), DEFAULT),
    (527, 127, 30, DEFAULT, 115, STR_TO_DATE("14.7.2019", "%d.%m.%Y."), STR_TO_DATE("22.7.2019", "%d.%m.%Y."), DEFAULT),
    (528, 130, 66, DEFAULT, 111, STR_TO_DATE("23.3.2018", "%d.%m.%Y."), STR_TO_DATE("28.3.2018", "%d.%m.%Y."), DEFAULT),
    (529, 125, 67, DEFAULT, 114, STR_TO_DATE("1.9.2019", "%d.%m.%Y."), STR_TO_DATE("18.9.2019", "%d.%m.%Y."), DEFAULT),
    (530, 130, 70, DEFAULT, 116, STR_TO_DATE("25.11.2018", "%d.%m.%Y."), STR_TO_DATE("5.12.2018", "%d.%m.%Y."), DEFAULT),
    -- Lorbek
    (531, 131, 31, DEFAULT, 111, STR_TO_DATE("8.1.2021", "%d.%m.%Y."), STR_TO_DATE("7.3.2021", "%d.%m.%Y."),  DEFAULT),
	(532, 137, 35, DEFAULT, 114, STR_TO_DATE("27.12.2020", "%d.%m.%Y."), STR_TO_DATE("5.1.2021", "%d.%m.%Y."),  DEFAULT),
	(533, 133, 39, DEFAULT, 118, STR_TO_DATE("2.2.2021", "%d.%m.%Y."), STR_TO_DATE("3.3.2021", "%d.%m.%Y."),  DEFAULT),
	(534, 134, 71, DEFAULT, 117, STR_TO_DATE("4.5.2013", "%d.%m.%Y."), STR_TO_DATE("15.5.2013", "%d.%m.%Y."),  DEFAULT),
	(535, 136, 78, DEFAULT, 115, STR_TO_DATE("7.8.2015", "%d.%m.%Y."), STR_TO_DATE("20.8.2015", "%d.%m.%Y."),  DEFAULT),
	(536, 125, 40, DEFAULT, 111, STR_TO_DATE("4.10.1993", "%d.%m.%Y."), STR_TO_DATE("10.10.1993", "%d.%m.%Y."),  DEFAULT),
	(537, 135, 80, DEFAULT, 114, STR_TO_DATE("30.12.2010", "%d.%m.%Y."), STR_TO_DATE("9.1.2011", "%d.%m.%Y."),  DEFAULT),
	(538, 125, 75, DEFAULT, 115, STR_TO_DATE("23.3.2004", "%d.%m.%Y."), STR_TO_DATE("1.4.2004", "%d.%m.%Y."),  DEFAULT),
	(539, 138, 38, DEFAULT, 117, STR_TO_DATE("30.6.1999", "%d.%m.%Y."), STR_TO_DATE("7.7.1999", "%d.%m.%Y."),  DEFAULT),
	(540, 139, 39, DEFAULT, 116, STR_TO_DATE("15.7.2020", "%d.%m.%Y."), STR_TO_DATE("29.7.2020", "%d.%m.%Y."),  DEFAULT);

INSERT INTO odabrani_gosti VALUES
--   id, id_gost, id_rezervacija
	-- Bastijanić
	(101, 41, 500), -- id_gost_koji je rezervirao - 1
    (102, 42, 500), -- id_gost_koji je rezervirao - 1
    (103, 43, 501), -- id_gost_koji je rezervirao - 2
    (104, 44, 502), -- id_gost_koji je rezervirao - 3
    (105, 45, 503), -- id_gost_koji je rezervirao - 4
    (106, 46, 503), -- id_gost_koji je rezervirao - 4
    (107, 47, 504), -- id_gost_koji je rezervirao - 5
    (108, 48, 505), -- id_gost_koji je rezervirao - 6
    (109, 49, 506), -- id_gost_koji je rezervirao - 7
    (110, 50, 507), -- id_gost_koji je rezervirao - 8
	-- Blašković
	(201, 60, 511), -- id_gost_koji je rezervirao - 59
	(202, 16, 512), -- id_gost_koji je rezervirao - 15
	(203, 58, 513), -- id_gost_koji je rezervirao - 12
	(204, 13, 514), -- id_gost_koji je rezervirao - 55
	(205, 56, 514), -- id_gost_koji je rezervirao - 55
	(206, 57, 515), -- id_gost_koji je rezervirao - 14
	(207, 51, 516), -- id_gost_koji je rezervirao - 11
	(208, 19, 517), -- id_gost_koji je rezervirao - 20
	(209, 52, 517), -- id_gost_koji je rezervirao - 20
	(210, 53, 518), -- id_gost_koji je rezervirao - 18
	(211, 17, 519), -- id_gost_koji je rezervirao - 54
	-- Žužić
    (302, 26, 521), -- id_gost_koji je rezervirao - 25
    (304, 28, 522), -- id_gost_koji je rezervirao - 28
    (307, 62, 524), -- id_gost_koji je rezervirao - 61
    (310, 23, 526), -- id_gost_koji je rezervirao - 29
    (311, 24, 526), -- id_gost_koji je rezervirao - 29
    (314, 64, 528), -- id_gost_koji je rezervirao - 66
    (315, 65, 528), -- id_gost_koji je rezervirao - 66
    (316, 66, 528), -- id_gost_koji je rezervirao - 66
    (319, 69, 530), -- id_gost_koji je rezervirao - 70
    (320, 70, 530), -- id_gost_koji je rezervirao - 70
    -- Lorbek
    (405, 71, 536), -- id_gost_koji je rezervirao - 40
	(416, 72, 536), -- id_gost_koji je rezervirao - 40
	(427, 73, 540), -- id_gost_koji je rezervirao - 39
	(434, 26, 540), -- id_gost_koji je rezervirao - 39
	(438, 39, 537), -- id_gost_koji je rezervirao - 80
	(452, 74, 538), -- id_gost_koji je rezervirao - 75
	(460, 33, 538), -- id_gost_koji je rezervirao - 75
	(479, 76, 535), -- id_gost_koji je rezervirao - 78
	(485, 36, 535), -- id_gost_koji je rezervirao - 78
	(496, 79, 532); -- id_gost_koji je rezervirao - 35

INSERT INTO odabrane_usluge VALUES
--   id, id_dodatna_usluga, id_rezervacija	
	-- Batijanić
    (10000, 1, 500, 2),
    (10001, 2, 501, 3),
    (10002, 3, 502, 7),
    (10003, 4, 502, 2),
    (10004, 5, 502, 4),
    (10005, 6, 502, 1),
    (10006, 7, 503, 1),
    (10007, 8, 503, 2),
    (10008, 9, 503, 1),
    (10009, 10, 503, 15),
    (10010, 8, 504, 2),
    (10011, 23, 504, 5),
    (10012, 12, 506, 5),
    (10013, 6, 507, 1),
    (10014, 18, 507, 1),
    (10015, 14, 508, 4),
	-- Blašković
	(10101, 8, 511, 2),
    (10102, 9, 511, 8),
    (10103, 16, 511, 1),
    (10104, 9, 512, 7),
    (10105, 13, 512, 2),
    (10106, 5, 512, 4),
    (10107, 15, 512, 1),
    (10108, 17, 513, 1),
    (10109, 19, 513, 2),
    (10110, 2, 513, 1),
    (10111, 9, 513, 15),
    (10112, 8, 514, 2),
    (10113, 23, 514, 4),
    (10114, 12, 514, 4),
    (10115, 6, 514, 1),
    (10116, 18, 515, 1),
    (10117, 14, 515, 4),
    (10118, 16, 515, 1),
    (10119, 11, 515, 1),
    (10120, 15, 516, 1),
    (10121, 9, 516, 3),
    (10122, 7 ,517, 12),
    (10123, 12, 517, 7),
    (10124, 20, 517, 1),
    (10125, 11, 517, 1),
    (10126, 24, 518, 1),
    (10127, 2, 518, 2),
    (10128, 6, 518, 5),
    (10129, 9, 518, 4),
    (10130, 10, 519, 2),
    (10131, 13, 519, 4),
    (10132, 18, 519, 1),
    (10133, 23, 519, 5),
    (10134, 1, 519, 10),
    (10135, 16, 520, 30),
    (10136, 11, 520, 30),
    (10137, 23, 520, 7),
    (10138, 5, 520, 15),
	-- Žužić
	(10201, 13, 521, 2),
    (10202, 15, 521, 1),
    (10203, 8, 522, 1),
    (10204, 19, 523, 1),
    (10205, 2, 524, 2),
    (10206, 24, 524, 1),
    (10207, 16, 525, 1),
    (10208, 22, 525, 1),
    (10209, 1, 525, 1),
    (10210, 23, 525, 1),
    (10211, 3, 526, 3),
    (10212, 10, 526, 3),
    (10213, 4, 526, 1),
    (10214, 17, 526, 1), 
    (10215, 6, 528, 4),
    (10216, 11, 529, 1),
	(10217, 12, 529, 1),
    (10218, 2, 530, 1),
    (10219, 18, 530, 1),
    (10220, 20, 530, 1),
    -- Lorbek
    (10301, 6, 531, 4),
	(10302, 23, 531, 2),
	(10303, 18, 533, 1),
	(10304, 16, 533, 3),
	(10305, 24, 533, 1),
	(10306, 13, 534, 7),
	(10307, 11, 534, 5),
	(10308, 8, 536, 1),
	(10309, 2, 536, 3),
	(10310, 21, 532, 4),
	(10311, 14, 532, 1),
	(10312, 13, 540, 3),
	(10313, 1, 540, 5),
	(10314, 20, 538, 1),
	(10315, 10, 538, 2),
	(10316, 17, 539, 9);
    
INSERT INTO racun VALUES
--   id, sifra,  id_rezervacija,  id_djelatnik, sifra, datum_i_vrijeme,  ukupna_cijena
	-- Bastijanić
    (20000, DEFAULT, 500, 6, STR_TO_DATE("25.4.2020. 18:18:18", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
    (20001, DEFAULT, 501, 6, STR_TO_DATE("27.4.2020. 17:30:18", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
    (20002, DEFAULT, 502, 7, STR_TO_DATE("30.4.2020. 21:24:11", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
    (20003, DEFAULT, 503, 7, STR_TO_DATE("5.5.2020. 14:56:8", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
    (20004, DEFAULT, 504, 7, STR_TO_DATE("10.5.2020. 19:14:10", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
    (20005, DEFAULT, 505, 7, STR_TO_DATE("11.6.2020. 12:25:29", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
    (20006, DEFAULT, 506, 6, STR_TO_DATE("15.9.2020. 10:33:53", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
    (20007, DEFAULT, 507, 44, STR_TO_DATE("8.6.2020. 19:2:22", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
    (20008, DEFAULT, 508, 43, STR_TO_DATE("21.12.2020. 23:1:46", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
    (20009, DEFAULT, 509, 6, STR_TO_DATE("14.2.2020. 20:3:57", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
    (20010, DEFAULT, 510, 44, STR_TO_DATE("17.10.2020. 10:5:55", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
	-- Blašković
	(20101, DEFAULT, 511, 6, STR_TO_DATE("10.01.2020. 17:10:18", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
    (20102, DEFAULT, 512, 7, STR_TO_DATE("10.12.2020. 20:37:21", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
    (20103, DEFAULT, 513, 44, STR_TO_DATE("05.09.2018. 17:25:7", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
    (20104, DEFAULT, 514, 44, STR_TO_DATE("17.11.2019. 18:14:8", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
    (20105, DEFAULT, 515, 67, STR_TO_DATE("02.01.1998. 12:25:29", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
    (20106, DEFAULT, 516, 6, STR_TO_DATE("15.9.2005. 10:58:43", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
    (20107, DEFAULT, 517, 44, STR_TO_DATE("5.4.2018. 18:25:22", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
    (20108, DEFAULT, 518, 43, STR_TO_DATE("20.12.2011. 15:34:46", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
    (20109, DEFAULT, 519, 44, STR_TO_DATE("3.2.1999. 16:43:57", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
    (20110, DEFAULT, 520, 44, STR_TO_DATE("15.9.1980. 15:22:55", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
	-- Žužić
	(20201, DEFAULT, 521, 6, STR_TO_DATE("10.5.2020. 17:10:18", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
	(20202, DEFAULT, 522, 44, STR_TO_DATE("24.9.2020. 20:37:21", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
	(20203, DEFAULT, 523, 7, STR_TO_DATE("14.12.2020. 17:25:7", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
	(20204, DEFAULT, 524, 43, STR_TO_DATE("13.6.2018. 18:14:8", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
	(20205, DEFAULT, 525, 6, STR_TO_DATE("18.5.2019. 12:25:29", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
	(20206, DEFAULT, 526, 7, STR_TO_DATE("12.2.2019. 10:58:43", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
	(20207, DEFAULT, 527, 7, STR_TO_DATE("2.7.2019. 18:25:22", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
	(20208, DEFAULT, 528, 43, STR_TO_DATE("1.3.2018. 15:34:46", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
	(20209, DEFAULT, 529, 6, STR_TO_DATE("1.8.2019. 16:43:57", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
	(20210, DEFAULT, 530, 7, STR_TO_DATE("25.10.2018. 15:22:55", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
    -- Lorbek
    (20301, DEFAULT, 531, 44, STR_TO_DATE("17.6.2020. 8:12:45", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
	(20302, DEFAULT, 532, 7, STR_TO_DATE("27.12.2019. 10:30:34", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
	(20303, DEFAULT, 533, 6, STR_TO_DATE("2.2.2020. 22:58:01", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
	(20304, DEFAULT, 534, 43, STR_TO_DATE("4.5.2013. 13:45:43", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
	(20305, DEFAULT, 535, 6, STR_TO_DATE("7.8.2015. 9:01:25", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
	(20306, DEFAULT, 536, 7, STR_TO_DATE("4.10.1993. 7:42:06", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
	(20307, DEFAULT, 537, 7, STR_TO_DATE("30.12.2010. 11:00:30", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
	(20308, DEFAULT, 538, 44, STR_TO_DATE("23.3.2004. 19:14:59", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
	(20309, DEFAULT, 539, 44, STR_TO_DATE("30.6.1999. 23:52:18", "%d.%m.%Y. %H:%i:%s"), DEFAULT),
	(20310, DEFAULT, 540, 6, STR_TO_DATE("15.7.2020. 4:43:02", "%d.%m.%Y. %H:%i:%s"), DEFAULT);

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<  TRANSAKCIJA  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>> -- 
-- <<<<<<<<< BLAŠKOVIĆ >>>>>>>>> --
SET AUTOCOMMIT = FALSE;
DROP PROCEDURE IF EXISTS izradaRezervacije;
DELIMITER //
CREATE PROCEDURE izradaRezervacije()
BEGIN
    DECLARE mp_id INTEGER DEFAULT 0;
    
    DECLARE booker_ime VARCHAR(50);
    DECLARE booker_prezime VARCHAR(50);
    DECLARE booker_oib VARCHAR(50);
    DECLARE booker_boi VARCHAR(50);
    DECLARE booker_dr DATE;
    DECLARE booker_id INTEGER;
    
    DECLARE od_soba_id INTEGER;
    DECLARE od_aranzman_id INTEGER;
    DECLARE od_pocetak_rezervacije DATE;
    DECLARE od_kraj_rezervacije DATE;
    DECLARE rezervacija_id INTEGER;
    
    DECLARE flag1 INTEGER DEFAULT 0;
    DECLARE flag2 INTEGER DEFAULT 0;
    DECLARE gosti_temp_br INTEGER DEFAULT 0;
    
    DECLARE id_gost_temp INTEGER;
    DECLARE ime_gost_temp VARCHAR(30);
    DECLARE prezime_gost_temp VARCHAR(50);
    DECLARE oib_gost_temp VARCHAR(50);
    DECLARE boi_gost_temp VARCHAR(50);
    DECLARE dr_gost_temp DATE;
    
    DECLARE odabrane_usluge_br INTEGER DEFAULT 0;
    DECLARE id_odabrane_usluge_temp INTEGER;
    DECLARE id_dodatne_usluge_temp INTEGER;
    DECLARE odabrane_usluge_kolicina_temp INTEGER;
    
    DECLARE cur1 CURSOR FOR
        SELECT id_gost
        FROM gosti_temp;
    DECLARE cur2 CURSOR FOR
        SELECT id_odabrane_usluge
        FROM temp_odabrane_usluge;
    DECLARE EXIT HANDLER FOR 1062
     BEGIN
        ROLLBACK;
        SELECT 'Došlo je do greške, duplicate entry';
     END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
     BEGIN
        ROLLBACK;
        SELECT 'Došlo je do greške, izrada rezervacije je obustavljena!';
     END;
#___________________________________________________________________________________________    
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
    START TRANSACTION;
        #Mjesto prebivalista insert
        INSERT INTO mjesto_prebivalista (drzava,grad,postanski_broj,adresa)
            SELECT drzava,grad,postanski_broj,adresa FROM odabrano_mjesto_prebivalista;
        #Fetch id_mjesto_prebivalista INTO mp_id
        SELECT id_mjesto_prebivalista INTO mp_id
            FROM mjesto_prebivalista 
            ORDER BY id_mjesto_prebivalista DESC
            LIMIT 1;
        #Fetch ime INTO booker_ime
        SELECT ime INTO booker_ime
            FROM temp_booker;
        #Fetch prezime INTO booker_prezime
        SELECT prezime INTO booker_prezime
            FROM temp_booker;
        #Fetch oib INTO booker_oib
        SELECT oib INTO booker_oib
            FROM temp_booker;
        #Fetch broj_osobne_iskaznice INTO booker_boi
        SELECT broj_osobne_iskaznice INTO booker_boi
            FROM temp_booker;
        #Fetch datum_rodenja INTO booker_dr
        SELECT datum_rodenja INTO booker_dr
            FROM temp_booker;
        #Insert booker into GOST
        
        IF (SELECT COUNT(OIB) FROM gost WHERE oib=booker_oib) = 0 THEN
			INSERT INTO gost (ime,prezime,oib,broj_osobne_iskaznice,id_mjesto_prebivalista,datum_rodenja)
				VALUES(booker_ime,booker_prezime,booker_oib,booker_boi,mp_id,booker_dr);
			#Fetch booker ID INTO booker_id
			SELECT id_gost INTO booker_id
				FROM gost 
				ORDER BY id_gost DESC 
				LIMIT 1;
		ELSE 
			SET booker_id=(SELECT id_gost FROM gost WHERE oib=booker_oib);
		END IF;
        
		#Fetch id_soba INTO od_soba
        SELECT id_soba INTO od_soba_id
            FROM temp_rezervacija;
        #Fetch id_aranzman INTO od_aranzman_id
        SELECT id_aranzman INTO od_aranzman_id
            FROM temp_rezervacija;
        #Fetch pocetak_rezervacije INTO od_pocetak_rezervacije
        SELECT pocetak_rezervacije INTO od_pocetak_rezervacije
            FROM temp_rezervacija;
        #Fetch kraj_rezervacije INTO od_kraj_rezervacije
        SELECT kraj_rezervacije INTO od_kraj_rezervacije
            FROM temp_rezervacija;
        #Insert rezervacija
            -- ID sezona 11 -> jer se racuna preko bi_rezervacija triggera
            -- broj_osoba DEFAULT -> jer se racuna preko ai_broj_osoba_rezervacija triggera
        INSERT INTO rezervacija (id_soba,id_gost,id_sezona,id_aranzman,pocetak_rezervacije,kraj_rezervacije,broj_osoba)
            VALUES(od_soba_id,booker_id,11,od_aranzman_id,od_pocetak_rezervacije,od_kraj_rezervacije,DEFAULT);
        #Fetch id_rezervacija INTO rezervacija_id
        SELECT id_rezervacija INTO rezervacija_id
            FROM rezervacija 
            ORDER BY id_rezervacija DESC 
            LIMIT 1;
        #________________________________________________
        #Spremanje broja dodatnih gostiju u gosti_temp_br
        BEGIN
        DECLARE CONTINUE HANDLER 
            FOR NOT FOUND
            SET flag1 = 1;
        SELECT COUNT(*) INTO gosti_temp_br
            FROM gosti_temp; 
        IF gosti_temp_br > 0 THEN
            OPEN cur1;
		iteriraj_gosti_temp: LOOP
            FETCH cur1 INTO id_gost_temp;
                IF flag1 = 1 THEN
                    LEAVE iteriraj_gosti_temp;
                END IF;
             #Fetch temp_gost ime   
             SELECT ime INTO ime_gost_temp 
                FROM gosti_temp
                WHERE id_gost = id_gost_temp;
            #Fetch temp_gost prezime   
             SELECT prezime INTO prezime_gost_temp
                FROM gosti_temp
                WHERE id_gost = id_gost_temp;
             #Fetch temp_gost oib   
             SELECT oib INTO oib_gost_temp
                FROM gosti_temp
                WHERE id_gost = id_gost_temp;
            #Fetch temp_gost broj_osobne_iskaznice   
             SELECT broj_osobne_iskaznice INTO boi_gost_temp
                FROM gosti_temp
                WHERE id_gost = id_gost_temp; 
            #Fetch temp_gost datum rodenja   
             SELECT datum_rodenja INTO dr_gost_temp
                FROM gosti_temp
                WHERE id_gost = id_gost_temp; 
                
			IF (SELECT COUNT(OIB) FROM gost WHERE oib=oib_gost_temp) = 0 THEN
                    INSERT INTO gost (ime,prezime,oib,broj_osobne_iskaznice,id_mjesto_prebivalista,datum_rodenja)
                        VALUES (ime_gost_temp,prezime_gost_temp,oib_gost_temp,boi_gost_temp,mp_id,dr_gost_temp);
                    INSERT INTO odabrani_gosti (id_gost,id_rezervacija)
                        VALUES (LAST_INSERT_ID(),rezervacija_id);    
			ELSE
				SET id_gost_temp=(SELECT id_gost FROM gost WHERE oib=oib_gost_temp);
				INSERT INTO odabrani_gosti (id_gost,id_rezervacija)
					VALUES (id_gost_temp,rezervacija_id); 
			END IF;
            
            END LOOP iteriraj_gosti_temp;
            CLOSE cur1;
        END IF;
        END;            
		#________________________________________________
        #Spremanje broja odabranih usluga u odabrane_usluge_br
        BEGIN
        DECLARE CONTINUE HANDLER 
            FOR NOT FOUND
            SET flag2 = 1;
        SELECT COUNT(*) INTO odabrane_usluge_br
            FROM temp_odabrane_usluge; 
        IF odabrane_usluge_br > 0 THEN
            OPEN cur2;
            iteriraj_temp_odabrane_usluge: LOOP
            FETCH cur2 INTO id_odabrane_usluge_temp;
                IF flag2 = 1 THEN
                    LEAVE iteriraj_temp_odabrane_usluge;
                END IF;
            #Fetch id_dodatne_usluge    
             SELECT id_dodatne_usluge INTO id_dodatne_usluge_temp 
                FROM temp_odabrane_usluge
                WHERE id_odabrane_usluge = id_odabrane_usluge_temp;
            #Fetch kolicina    
             SELECT kolicina INTO odabrane_usluge_kolicina_temp 
                FROM temp_odabrane_usluge
                WHERE id_odabrane_usluge = id_odabrane_usluge_temp;
                
                    INSERT INTO odabrane_usluge (id_dodatne_usluge,id_rezervacija,kolicina)
                        VALUES (id_dodatne_usluge_temp,rezervacija_id,odabrane_usluge_kolicina_temp);
        END LOOP iteriraj_temp_odabrane_usluge;
        CLOSE cur2;
        END IF;
        END;
            COMMIT;
            SELECT CONCAT('Transaction commited!');
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS izradaRacuna;
DELIMITER //
CREATE PROCEDURE izradaRacuna(IN p_id_rezervacija INTEGER, IN p_djelatnik_ime VARCHAR(30), IN p_djelatnik_prezime VARCHAR(50))
BEGIN
    DECLARE id_djelatnika INTEGER DEFAULT 0;
    SELECT id_djelatnik INTO id_djelatnika
        FROM djelatnik
        WHERE ime = p_djelatnik_ime AND prezime = p_djelatnik_prezime;
    BEGIN
    DECLARE EXIT HANDLER FOR 1216
        BEGIN
        ROLLBACK;
                CASE 
                    WHEN (p_id_rezervacija NOT IN (SELECT id_rezervaciaj FROM rezervacija))
                        THEN SELECT CONCAT('Unijeli ste ID za nepostojeću rezervaciju!');
                    WHEN (id_djelatnika = 0)
                        THEN SELECT CONCAT('Djelatnik nije pronađen');
                END CASE;
        END;
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
     BEGIN
        ROLLBACK;
        SELECT 'Došlo je do greške, izrada računa je obustavljena!';
     END;
        END;
        
    SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
    START TRANSACTION;
        INSERT INTO racun (sifra,id_rezervacija,id_djelatnik,datum_i_vrijeme_izdavanja,ukupna_cijena)
            VALUES (DEFAULT,p_id_rezervacija,id_djelatnika,NOW(),DEFAULT);
    COMMIT;
    SELECT CONCAT('Transaction commited!');
END //
DELIMITER ;



-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<  OVLASTI  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>> -- 
ALTER USER 'root'@'localhost' IDENTIFIED BY 'root';
DROP USER 'gost';
CREATE USER 'gost' IDENTIFIED BY '';
GRANT SELECT ON sustav_za_upravljanje_hotelom.soba TO gost;
GRANT SELECT ON sustav_za_upravljanje_hotelom.dodatne_usluge TO gost;
GRANT SELECT ON sustav_za_upravljanje_hotelom.sezona TO gost;
GRANT SELECT ON sustav_za_upravljanje_hotelom.aranzman TO gost;
GRANT SELECT ON sustav_za_upravljanje_hotelom.rezervacija TO gost;

GRANT CREATE,INSERT,SELECT,DROP ON sustav_za_upravljanje_hotelom.temp_rezervacija TO gost;
GRANT CREATE,INSERT,SELECT,DROP ON sustav_za_upravljanje_hotelom.odabrano_mjesto_prebivalista TO gost;
GRANT CREATE,INSERT,SELECT,DROP,DELETE ON sustav_za_upravljanje_hotelom.gosti_temp TO gost;
GRANT CREATE,INSERT,SELECT,DROP ON sustav_za_upravljanje_hotelom.odabrani_period TO gost;
GRANT CREATE,REFERENCES ON sustav_za_upravljanje_hotelom.gosti_temp TO gost;
GRANT REFERENCES ON sustav_za_upravljanje_hotelom.* TO gost;
GRANT EXECUTE ON FUNCTION sustav_za_upravljanje_hotelom.izracun_sezone TO gost;

GRANT INSERT ON sustav_za_upravljanje_hotelom.rezervacija TO gost;
GRANT CREATE,INSERT,DROP,SELECT ON sustav_za_upravljanje_hotelom.temp_rezervacija TO gost;
GRANT INSERT ON sustav_za_upravljanje_hotelom.gost TO gost;
GRANT INSERT ON sustav_za_upravljanje_hotelom.mjesto_prebivalista TO gost;
GRANT INSERT ON sustav_za_upravljanje_hotelom.odabrani_gosti TO gost;
GRANT INSERT ON sustav_za_upravljanje_hotelom.odabrane_usluge TO gost;
GRANT CREATE,INSERT,DROP,SELECT ON sustav_za_upravljanje_hotelom.temp_odabrane_usluge TO gost;
GRANT INSERT ON sustav_za_upravljanje_hotelom.odabrani_gosti TO gost;
GRANT CREATE,INSERT,DROP,SELECT ON sustav_za_upravljanje_hotelom.temp_odabrani_gosti TO gost;
GRANT CREATE,INSERT,DROP,SELECT ON sustav_za_upravljanje_hotelom.temp_booker TO gost;
DROP USER 'djelatnik';
CREATE USER 'djelatnik' IDENTIFIED BY 'djelatnik';
GRANT SELECT,INSERT,UPDATE ON sustav_za_upravljanje_hotelom.* TO djelatnik;
