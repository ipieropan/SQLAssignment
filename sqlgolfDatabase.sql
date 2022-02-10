drop database sqlgolfDatabase;
create database sqlgolfDatabase;
use sqlgolfDatabase;

create table players(
	personId int8 not null,
    playerName varchar(20) not null,
    age tinyint not null,
    primary key(personId)
)engine=InnoDB;

create table golfCompetition(
	competitionName varchar(20) not null,
    competitionDate date not null,
    primary key(competitionName)
)engine=InnoDB;

create table weather(
	weatherType varchar(20) not null,
    windSpeed tinyint,
    primary key(weatherType)
)engine=InnoDB;

create table construction(
	serialNumber smallint not null auto_increment,
    hardness varchar(10) not null,
    primary key(serialNumber)
)engine=InnoDB;

create table jacket(
	brand varchar(15) not null,
    size varchar(10) not null,
    material varchar(20) not null,
    playerId int8 not null,
    primary key(brand, playerId),
    foreign key(playerId) references players(personId)
)engine=InnoDB;

create table golfclub(
	clubNumber varchar(20) not null,
    material varchar(20) not null,
    playerId int8 not null,
    constructionSerial smallint not null,
    primary key(playerId, clubNumber),
    foreign key(playerId) references players(personId),
    foreign key(constructionSerial) references construction(serialNumber)
)engine=InnoDB;

create table competitionWeather(
	weatherType varchar(20) not null,
    weatherConditionTime time not null,
    competitionName varchar(20) not null,
    foreign key(competitionName) references golfCompetition(competitionName),
    foreign key(weatherType) references weather(weatherType)
)engine=InnoDB;

create table competitionPresence(
	competitionName varchar(20) not null,
    competitionDate date not null,
    playerId int8 not null,
    foreign key(competitionName) references golfCompetition(competitionName),
    foreign key(playerId) references players(personId)
)engine=InnoDB;

-- Player name: JohanAndersson / age: 25 
insert into players(personId, playerName, age) value(199701137951, 'Johan Andersson', 25);

-- Players: Johan Andersson, Nicklas Jansson, Annika Persson and Me
insert into players(personId, playerName, age) values(200110238975, 'Annika Persson', 20);
insert into players(personId, playerName, age) values(200101233566, 'Nicklas Jansson', 21);
insert into players(personId, playerName, age) values(198010230001, 'Igor Pieropan', 41);

-- Competition name: Big Golf Cup Skövde / date: 10/06-2021
insert into golfCompetition(competitionName, competitionDate) values('Big Golf Cup Skövde', '2021-06-10');

-- Weather: Rain Hagel / Wind speed: 10
insert into weather(weatherType, windSpeed) values('Hagel', 10);
insert into competitionWeather(weatherType, weatherConditionTime, competitionName) values('Hagel', '12:00','Big Golf Cup Skövde');

-- Johan num of jackets: 2 / material: Fleece and Goretex
insert into jacket(brand, size, material, playerId) values('Lacoste', 'L', 'Fleece', 199701137951);
insert into jacket(brand, size, material, playerId) values('Fila', 'XL', 'Goretex', 199701137951);

-- adding some more jackets --
insert into jacket(brand, size, material, playerId) values('Louis Vitton', 'XL', 'Goretex', 200110238975);
insert into jacket(brand, size, material, playerId) values("Levi's", 'XL', 'Goretex', 200110238975);
insert into jacket(brand, size, material, playerId) values("Lacoste", 'XL', 'Goretex', 198010230001);

-- Niklas club material: Wood / hardness: 10
-- Annika club material: Wood / hardness: 5
-- Igor club material: Diamond / hardness: 100 (God's golf club)
insert into construction(hardness) values('100 HRC');
insert into construction(hardness) values('10 HRC');
insert into construction(hardness) values('5 HRC');
insert into golfclub(clubNumber, material, playerId, constructionSerial) values('#3', 'Wood', 200101233566, '1');
insert into golfclub(clubNumber, material, playerId, constructionSerial) values('#3', 'Wood', 200110238975, '2');
insert into golfclub(clubNumber, material, playerId, constructionSerial) values('#1', 'Diamond', 198010230001, '3');

-- Every player playing --
insert into competitionPresence(competitionName, competitionDate, playerId) values('Big Golf Cup Skövde', '2021-06-10', 200110238975);
insert into competitionPresence(competitionName, competitionDate, playerId) values('Big Golf Cup Skövde', '2021-06-10', 200101233566);
insert into competitionPresence(competitionName, competitionDate, playerId) values('Big Golf Cup Skövde', '2021-06-10', 199701137951);

-- use database --
-- Johan Age --
select age from players where playerName='Johan Andersson';

-- Big Golf Cup Skövde date --
select competitionDate from golfCompetition where competitionName = 'Big Golf Cup Skövde';

-- Johans club material --
select material from golfClub where playerId= (select personId from players where playerName='Johan Andersson');

-- Johans jackets --
select * from jacket where playerId = (select personId from players where playerName='Johan Andersson');	

-- PLayers in the cup --
select * from players where personId in (select playerId from competitionpresence where competitionName = 'Big Golf Cup Skövde');

-- wind in Big Golf Cup SKövde --
select windspeed from weather where weatherType in (select weatherType from competitionWeather where competitionName = 'Big Golf Cup Skövde');

-- Players under 30 --
select * from players where age < 30;

-- Delete jackets -- 
delete from jacket where playerId = (select personId from players where playerName = 'Johan Andersson');

-- Delete Niklas --
delete from jacket where playerId = (select personId from players where playerName = 'Nicklas Jansson');
delete from competitionPresence where playerId = (select personId from players where playerName = 'Nicklas Jansson');
delete from golfClub where playerId = (select personId from players where playerName = 'Nicklas Jansson');
delete from players where playerName = 'Nicklas Jansson' limit 1;

-- Average age --
select avg(age) as avgAge from players;
