drop table if exists land cascade;
create table land (
   name text primary key
);

drop table if exists gewichtsklasse cascade;
create table gewichtsklasse (
  name text primary key,
  maximalgewicht decimal,
  minimalgewicht decimal,
  CHECK (name IN ('Flyweight', 'Bantamweight', 'Featherweight',
  'Lightweight', 'Welterweight', 'Middleweight', 'Light Heavyweight', 'Heavyweight'))
);

drop table if exists event cascade;
create table event (
  name text primary key,
  datum date,
  zuschauerzahl integer,
  einnahmen decimal,
  in_land text REFERENCES land (name)
);

drop table if exists kampf cascade;
create table kampf (
  id serial primary key,
  rundenzahl integer CHECK (rundenzahl >= 1 AND rundenzahl <= 5),
  ergebnisart text CHECK (ergebnisart IN ('Sub', 'KO', 'Draw', 'Dec', 'Disq')),
  siegrunde integer,
  siegminute decimal,
  titelkampf boolean,
  enthaltenIn text REFERENCES event (name),
  stattgefunden_in text REFERENCES gewichtsklasse (name),
  maincard boolean
);

drop table if exists kampfer cascade;
create table kampfer (
  name text primary key,
  gewicht decimal,
  grosse decimal,
  reichweite decimal,
  geb_datum date,
  sizereachratio decimal,
  auslage text,
  slpm decimal,
  str_acc decimal CHECK (str_acc > 0 AND str_acc < 1),
  sapm decimal,
  str_def decimal, CHECK(str_def > 0 AND str_def < 1),
  td_avg decimal,
  td_acc decimal, CHECK(td_acc > 0 AND td_acc < 1),
  td_def decimal, CHECK(td_def > 0 AND td_def < 1),
  sub_avg decimal,
  gym text,
  background text,
  vertritt text REFERENCES land (name)
);

drop table if exists kampf_kampfer cascade;
create table kampf_kampfer (
  kampf serial REFERENCES kampf (id),
  kampfer text REFERENCES kampfer (name),
  takedowns integer,
  sig_treffer integer
);