DROP DATABASE IF EXISTS db;
CREATE DATABASE db;
USE db;

CREATE TABLE user
(
    username VARCHAR(30) PRIMARY KEY,
    password VARCHAR(30)
);

INSERT into user
VALUES ('testUser', '0000');

CREATE TABLE toy_listing
(
    initial_price    double,
    category         varchar(50),
    name             varchar(50),
    start_age        int,
    end_age          int,
    secret_min_price double,
    closing_datetime datetime,
    increment        double,
    toy_id           INT AUTO_INCREMENT,
    start_datetime   datetime,
    username         varchar(30) NOT NULL,
    primary key (toy_id),
    foreign key (username) references user (username)
);


CREATE TABLE action_figure
(
    toy_id    INT NOT NULL,
    height    DOUBLE,
    can_move  BOOLEAN,
    character_name VARCHAR(50),
    PRIMARY KEY (toy_id),
    FOREIGN KEY (toy_id) REFERENCES toy_listing (toy_id) on delete cascade
);

CREATE TABLE board_game
(
    toy_id        INT NOT NULL,
    player_count  INT,
    brand         VARCHAR(50),
    is_cards_game BOOLEAN,
    PRIMARY KEY (toy_id),
    FOREIGN KEY (toy_id) REFERENCES toy_listing (toy_id) on delete cascade
);

CREATE TABLE stuffed_animal
(
    toy_id INT NOT NULL,
    color  VARCHAR(30),
    brand  VARCHAR(50),
    animal VARCHAR(100),
    PRIMARY KEY (toy_id),
    FOREIGN KEY (toy_id) REFERENCES toy_listing (toy_id) on delete cascade
);

CREATE TABLE admin(
                      id varchar(30),
                      password varchar(30),
                      Primary key (id));

INSERT into admin
VALUES ('admin', '1000');

CREATE TABLE customer_representative(
                                                  id varchar(30),
                                                  password varchar(30),
                                                  Primary Key (id));

CREATE TABLE admin_creates(
                              a_id varchar(30),
                              c_id varchar(30),
                              FOREIGN KEY(a_id) REFERENCES admin(id),
                              FOREIGN KEY(c_id) REFERENCES customer_representative(id)
);

CREATE TABLE bid (
                     b_id INT AUTO_INCREMENT,
                     time DateTime,
                     price double,
                     username varchar(30) NOT NULL,
                     toy_id int NOT NULL,
                     Primary Key (b_id),
                     Foreign key (username) references user(username),
                     Foreign key (toy_id) references toy_listing(toy_id));

CREATE TABLE sale(
                     sale_id varchar(9),
                     date datetime,
                     toy_id int NOT NULL,
                     b_id int NOT NULL,
                     Primary key (sale_id),
                     Foreign key (toy_id) references toy_listing(toy_id),
                     Foreign key (b_id) references bid(b_id));

CREATE TABLE alert(
                      alert_id varchar(9),
                      name varchar(50),
                      max_price double,
                      category varchar(40),
                      min_price double,
                      age_range char(5),
                      username varchar(30) NOT NULL,
                      Primary key (alert_id),
                      Foreign key (username) references user(username));

CREATE TABLE report(
                       report_id varchar(9),
                       date datetime,
                       total_earnings double,
                       admin_id varchar(30) NOT NULL,
                       earnings_per double,
                       best_selling varchar(100),
                       Primary key (report_id),
                       Foreign key (admin_id) references admin(id));

CREATE TABLE automatic_bid(
                              ab_id int auto_increment,
                              increment double,
                              secret_max_price double,
                              last_bid_id int NOT NULL,
                              toy_id int NOT NULL,
                              Primary Key (ab_id, last_bid_id),
                              Foreign key (toy_id) references toy_listing(toy_id),
                              Foreign key (last_bid_id) references bid(b_id) on delete cascade);

CREATE TABLE question(
                         text varchar(500),
                         c_id varchar(30),
                         username varchar(30) NOT NULL,
                         Primary Key (text),
                         Foreign key (c_id) references customer_representative(id),
                         Foreign key (username)  references user(username));
