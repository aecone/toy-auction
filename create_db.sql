DROP DATABASE IF EXISTS db;
CREATE DATABASE db;
USE db;

CREATE TABLE users(
    username VARCHAR(30) PRIMARY KEY,
    password VARCHAR(30)
);

INSERT into users values ('admin','0000');
INSERT into users values ('test','admin');