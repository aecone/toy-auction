DROP DATABASE IF EXISTS db;
CREATE DATABASE db;
USE db;

CREATE TABLE users
(
    username VARCHAR(30) PRIMARY KEY,
    password VARCHAR(30)
);

INSERT into users
VALUES ('admin', '0000');

INSERT into users
VALUES ('test', 'admin');

CREATE TABLE Toy_Listing
(
    initial_price    double,
    name             varchar(50),
    start_age        int,
    end_age          int,
    secret_min_price double,
    closing_datetime datetime,
    increment        double,
    toy_id           INT AUTO_INCREMENT,
    start_datetime   datetime,
    username         varchar(40) NOT NULL,
    primary key (toy_id),
    foreign key (username) references users (username)
);

CREATE TABLE Action_Figure
(
    toy_id    INT NOT NULL,
    height    DOUBLE,
    can_move  BOOLEAN,
    character_name VARCHAR(50),
    PRIMARY KEY (toy_id),
    FOREIGN KEY (toy_id) REFERENCES Toy_Listing (toy_id) on delete cascade
);

CREATE TABLE Board_Game
(
    toy_id        INT NOT NULL,
    player_count  INT,
    brand         VARCHAR(50),
    is_cards_game BOOLEAN,
    PRIMARY KEY (toy_id),
    FOREIGN KEY (toy_id) REFERENCES Toy_Listing (toy_id) on delete cascade
);

CREATE TABLE Stuffed_Animal
(
    toy_id INT NOT NULL,
    color  VARCHAR(30),
    brand  VARCHAR(50),
    animal VARCHAR(100),
    PRIMARY KEY (toy_id),
    FOREIGN KEY (toy_id) REFERENCES Toy_Listing (toy_id) on delete cascade
);
