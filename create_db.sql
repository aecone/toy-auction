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

CREATE TABLE toy_listing
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