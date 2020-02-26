DROP DATABASE IF EXISTS trabajitos;
GO

CREATE DATABASE trabajitos;
GO

USE trabajitos;
GO

CREATE TABLE exp_laborals(
	id_exp_laboral INT IDENTITY NOT NULL PRIMARY KEY,
	empresa VARCHAR(30) NOT NULL,
	descripcio TEXT NOT NULL,
	data_inici DATETIME NOT NULL CHECK (data_inici>= '01-01-1950' and data_inici<=GETDATE()),
	data_fi DATETIME,
	candidat CHAR NOT NULL,
	CONSTRAINT Ck_exp_laborals_data_fi CHECK (data_fi >= data_inici and data_fi<=GETDATE())
);

CREATE TABLE candidats(
	nif CHAR NOT NULL PRIMARY KEY CHECK (LEN(nif)=9),
	nom VARCHAR(30) NOT NULL,
	cognoms VARCHAR(30) NOT NULL,
	telefon CHAR(9) NOT NULL CHECK (LEN(telefon)=9),
	email VARCHAR(30) NOT NULL CHECK (email LIKE '%@%.es' or email LIKE '%@%.com' or email LIKE '%@%.cat'),
	data_naixament DATETIME NOT NULL CHECK (data_naixament>= '01-01-1920' and data_naixament<=GETDATE()),
	poblacio INT NOT NULL,

);

CREATE TABLE candidats_titulacions(
	candidat CHAR NOT NULL,
	titulacio INT NOT NULL,
	any_inici INT NOT NULL CHECK (any_inici >= 1950 and any_inici<=YEAR(GETDATE())),
	any_fi INT,
	CONSTRAINT Pk_candidat_titulacio PRIMARY KEY (candidat, titulacio),
	CONSTRAINT Ck_candidats_titulacions_any_fi CHECK (any_fi >= any_inici and any_fi<=YEAR(GETDATE()))

);

CREATE TABLE titulacions(
	id_titulacio INT IDENTITY NOT NULL PRIMARY KEY,
	nom VARCHAR(30) NOT NULL,
	grau VARCHAR(30) CHECK (grau in ('técnic','técnic superior','diplomat','llicenciat')),

);

CREATE TABLE candidats_ofertes(
	candidat CHAR NOT NULL,
	oferta CHAR(10) NOT NULL,
	estat CHAR NOT NULL CHECK (estat = 'E' or estat='A' or estat='D'),
	CONSTRAINT Pk_candidat_oferta PRIMARY KEY (candidat, oferta),

);

CREATE TABLE ofertes(
	codi CHAR(10) NOT NULL PRIMARY KEY CHECK (LEN(codi)=10 and codi LIKE 'OFR%'),
	data DATETIME NOT NULL DEFAULT GETDATE() CHECK (data<=GETDATE()),
	descripcio TEXT NOT NULL,
	num_vacants INT NOT NULL DEFAULT 1 CHECK (num_vacants>=1),
	sou DECIMAL(5,2) NOT NULL DEFAULT 900 CHECK (sou >=600 and sou<=10000),
	tipus_contracte CHAR NOT NULL CHECK (tipus_contracte = 'L' or tipus_contracte='P'),
	categoria INT NOT NULL DEFAULT 1,
	empresa INT NOT NULL,

);

CREATE TABLE categories(
	id_categoria INT IDENTITY NOT NULL PRIMARY KEY,
	nom VARCHAR(30) NOT NULL,

);

CREATE TABLE empreses(
	id_empresa INT IDENTITY NOT NULL PRIMARY KEY,
	rao_social VARCHAR(30) NOT NULL,
	email_contacte VARCHAR(30) NOT NULL,
	num_empleats INT NOT NULL CHECK (num_empleats >= 1),
	website VARCHAR(30) CHECK (website LIKE 'http://%.es' or website LIKE 'http://%.com' or website LIKE 'http://%.org' ),
	url_logo VARCHAR(30) CHECK (url_logo LIKE '%.jpg' or url_logo LIKE '%.gif' or url_logo LIKE '%.png' ),
	poblacio INT NOT NULL,

);

CREATE TABLE poblacions(
	id_poblacio INT IDENTITY NOT NULL PRIMARY KEY,
	nom VARCHAR(30) NOT NULL,
	provincia INT NOT NULL,

);

CREATE TABLE provincies(
	id_provincia INT IDENTITY NOT NULL PRIMARY KEY,
	nom VARCHAR(30) NOT NULL,

);

/*exp_laborals*/
ALTER TABLE exp_laborals
	ADD FOREIGN KEY (candidat) REFERENCES candidats(nif)
		ON UPDATE CASCADE;

/*candidats*/
ALTER TABLE candidats	
	ADD FOREIGN KEY (poblacio) REFERENCES poblacions(id_poblacio)
		ON UPDATE CASCADE;

/*candidats_titulacions*/
ALTER TABLE candidats_titulacions	
	ADD FOREIGN KEY (candidat) REFERENCES candidats(nif)
		ON UPDATE CASCADE;

ALTER TABLE candidats_titulacions
	ADD FOREIGN KEY (titulacio) REFERENCES titulacions(id_titulacio)
		ON UPDATE CASCADE;

/*candidats_ofertes*/
ALTER TABLE candidats_ofertes	
	ADD FOREIGN KEY (candidat) REFERENCES candidats(nif)
		ON UPDATE CASCADE;

ALTER TABLE candidats_ofertes
	ADD FOREIGN KEY (oferta) REFERENCES ofertes(codi)
		ON UPDATE CASCADE;

/*ofertes*/
ALTER TABLE ofertes
	ADD FOREIGN KEY (categoria) REFERENCES categories(id_categoria)
		ON UPDATE CASCADE;

ALTER TABLE ofertes
	ADD FOREIGN KEY (empresa) REFERENCES empreses(id_empresa)
		ON UPDATE CASCADE;

/*empreses*/
ALTER TABLE empreses
	ADD FOREIGN KEY (poblacio) REFERENCES poblacions(id_poblacio)
		/*ON UPDATE CASCADE*/;

/*poblacions*/
ALTER TABLE poblacions
	ADD FOREIGN KEY (provincia) REFERENCES provincies(id_provincia)
		ON UPDATE CASCADE;

/*candidats*/
ALTER TABLE candidats
	ADD FOREIGN KEY (poblacio) REFERENCES poblacions(id_poblacio);
