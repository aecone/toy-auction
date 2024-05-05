DROP DATABASE IF EXISTS db;

CREATE DATABASE db;

USE db;

CREATE TABLE user
(
    username VARCHAR(30) PRIMARY KEY,
    password VARCHAR(30)
);

INSERT INTO user
VALUES      ('testUser',
             '0000');

CREATE TABLE toy_listing
(
    initial_price    DOUBLE,
    category         VARCHAR(50),
    name             VARCHAR(50),
    start_age        INT,
    end_age          INT,
    secret_min_price DOUBLE,
    closing_datetime DATETIME,
    increment        DOUBLE,
    toy_id           INT auto_increment,
    start_datetime   DATETIME,
    username         VARCHAR(30) NOT NULL,
    openStatus       INT DEFAULT 1,
    PRIMARY KEY (toy_id),
    FOREIGN KEY (username) REFERENCES user (username) ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE action_figure
(
    toy_id         INT NOT NULL,
    height         DOUBLE,
    can_move       BOOLEAN,
    character_name VARCHAR(50),
    PRIMARY KEY (toy_id),
    FOREIGN KEY (toy_id) REFERENCES toy_listing (toy_id) ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE board_game
(
    toy_id        INT NOT NULL,
    player_count  INT,
    brand         VARCHAR(50),
    is_cards_game BOOLEAN,
    PRIMARY KEY (toy_id),
    FOREIGN KEY (toy_id) REFERENCES toy_listing (toy_id) ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE stuffed_animal
(
    toy_id INT NOT NULL,
    color  VARCHAR(30),
    brand  VARCHAR(50),
    animal VARCHAR(100),
    PRIMARY KEY (toy_id),
    FOREIGN KEY (toy_id) REFERENCES toy_listing (toy_id) ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE admin
(
    id       VARCHAR(30),
    password VARCHAR(30),
    PRIMARY KEY (id)
);

INSERT INTO admin
VALUES      ('admin',
             '1000');

CREATE TABLE customer_representative
(
    id       VARCHAR(30),
    password VARCHAR(30),
    PRIMARY KEY (id)
);

CREATE TABLE alert(
                      alert_id int auto_increment,
                      name varchar(50),
                      max_price double,
                      category varchar(40),
                      min_price double,
                      age_range char(5),
                      username varchar(30) NOT NULL,
                      is_custom_alert boolean default false,
                      custom_alert_status boolean default false,
                      Primary key (alert_id),
                      Foreign key (username) references user(username) ON DELETE CASCADE
                          ON UPDATE CASCADE);

INSERT INTO customer_representative
VALUES      ('sammy',
             '1010');

CREATE TABLE admin_creates
(
    a_id VARCHAR(30),
    c_id VARCHAR(30),
    FOREIGN KEY(a_id) REFERENCES admin(id),
    FOREIGN KEY(c_id) REFERENCES customer_representative(id)
);

INSERT INTO admin_creates
VALUES      ('admin',
             'sammy');

CREATE TABLE bid
(
    b_id        INT auto_increment,
    time        DATETIME,
    price       DOUBLE,
    username    VARCHAR(30) NOT NULL,
    toy_id      INT NOT NULL,
    is_auto_bid BOOLEAN,
    bid_status varchar(10) default 'active',
    PRIMARY KEY (b_id),
    FOREIGN KEY (username) REFERENCES user(username)ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (toy_id) REFERENCES toy_listing(toy_id) ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE sale
(
    sale_id INT auto_increment,
    date    DATETIME,
    toy_id  INT NOT NULL,
    b_id    INT NOT NULL,
    PRIMARY KEY (sale_id),
    FOREIGN KEY (toy_id) REFERENCES toy_listing(toy_id) ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (b_id) REFERENCES bid(b_id)ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE report
(
    report_id      VARCHAR(9),
    date           DATETIME,
    total_earnings DOUBLE,
    admin_id       VARCHAR(30) NOT NULL,
    earnings_per   DOUBLE,
    best_selling   VARCHAR(100),
    PRIMARY KEY (report_id),
    FOREIGN KEY (admin_id) REFERENCES admin(id)ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE automatic_bid
(
    ab_id            INT auto_increment,
    increment        DOUBLE,
    secret_max_price DOUBLE,
    last_bid_id      INT NOT NULL,
    toy_id           INT NOT NULL,
    active           boolean default 1,
    PRIMARY KEY (ab_id, last_bid_id),
    FOREIGN KEY (toy_id) REFERENCES toy_listing(toy_id)ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (last_bid_id) REFERENCES bid(b_id) ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE question
(
    question_text VARCHAR(500),
    q_id          VARCHAR(30),
    username      VARCHAR(30),
    PRIMARY KEY (q_id),
    FOREIGN KEY (username) REFERENCES user(username) ON DELETE CASCADE ON
        UPDATE CASCADE
);

CREATE TABLE answer
(
    q_id        VARCHAR(30),
    c_id        VARCHAR(30),
    answer_text VARCHAR(500),
    PRIMARY KEY (q_id),
    FOREIGN KEY(q_id) REFERENCES question(q_id) ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY(c_id) REFERENCES customer_representative(id) ON DELETE CASCADE
        ON UPDATE CASCADE
);
--
-- MOCKS
--
INSERT INTO question
VALUES      ('Is there a general FAQ?',
             "2",
             "testuser");

INSERT INTO question
VALUES      (
                'How do I delete my account? I accidentally created my account with the wrong email.'
                ,
                "3",
                "testuser");

-- Mock data for user table
INSERT INTO user
(username,
 password)
VALUES      ('john_doe',
             'password123'),
            ('jane_smith',
             'securePass'),
            ('bob_jones',
             'bobspassword');

-- Mock data for toy_listing table
INSERT INTO toy_listing
(initial_price,
 category,
 name,
 start_age,
 end_age,
 secret_min_price,
 closing_datetime,
 increment,
 start_datetime,
 username)
VALUES      (20.00,
             'action_figure',
             'Spiderman ',
             5,
             10,
             15.00,
             '2024-05-10 12:00:00',
             2.00,
             '2024-05-03 12:00:00',
             'john_doe'),
            (15.00,
             'board_game',
             'Monopoly',
             8,
             99,
             10.00,
             '2024-05-15 18:00:00',
             1.00,
             '2024-05-05 09:00:00',
             'jane_smith'),
            (10.00,
             'stuffed_animal',
             'Teddy Bear',
             0,
             5,
             7.00,
             '2024-05-08 15:00:00',
             0.50,
             '2024-05-01 10:00:00',
             'bob_jones');

-- Mock data for action_figure table
INSERT INTO action_figure
(toy_id,
 height,
 can_move,
 character_name)
VALUES      (1,
             10.5,
             true,
             'Spiderman');

-- Mock data for board_game table
INSERT INTO board_game
(toy_id,
 player_count,
 brand,
 is_cards_game)
VALUES      (2,
             4,
             'Hasbro',
             false);

-- Mock data for stuffed_animal table
INSERT INTO stuffed_animal
(toy_id,
 color,
 brand,
 animal)
VALUES      (3,
             'Brown',
             'Build-A-Bear',
             'Bear');

-- Mock data for bid table
INSERT INTO bid
(time,
 price,
 username,
 toy_id,
 is_auto_bid)
VALUES      ('2024-05-05 12:30:00',
             25.00,
             'jane_smith',
             1,
             false),
            ('2024-05-06 09:45:00',
             12.50,
             'bob_jones',
             3,
             false),
            ('2024-05-07 14:20:00',
             17.50,
             'john_doe',
             2,
             true);

-- Mock data for sale table
INSERT INTO sale
(date,
 toy_id,
 b_id)
VALUES      ('2024-05-10 12:05:00',
             1,
             1),
            ('2024-05-08 15:10:00',
             3,
             2);

-- Mock data for alert table
INSERT INTO alert
(
    name,
    max_price,
    category,
    min_price,
    age_range,
    username)
VALUES      (
                'Spiderman action_figure Alert',
                30.00,
                'action_figure',
                10.00,
                '5-10',
                'john_doe'),
            ('Monopoly Alert',
             20.00,
             'board_game',
             8.00,
             '8+',
             'jane_smith');

-- Mock data for report table
INSERT INTO report
(report_id,
 date,
 total_earnings,
 admin_id,
 earnings_per,
 best_selling)
VALUES      ("id1",
             '2024-05-10',
             75.00,
             'admin',
             25.00,
             'Spiderman action_figure'),
            ("id2",
             '2024-05-08',
             30.00,
             'admin',
             15.00,
             'Teddy Bear');

-- Mock data for automatic_bid table
INSERT INTO automatic_bid
(increment,
 secret_max_price,
 last_bid_id,
 toy_id)
VALUES      (2.00,
             35.00,
             1,
             1),
            (1.00,
             18.00,
             2,
             3);

-- Mock data for question table
INSERT INTO question
(question_text,
 q_id,
 username)
VALUES      ('What is the recommended age for this toy?',
             '4',
             'john_doe'),
            ('Is this board_game suitable for adults?',
             '5',
             'jane_smith');

-- Mock data for answer table
INSERT INTO answer
(q_id,
 c_id,
 answer_text)
VALUES      ('4',
             'sammy',
             'The recommended age range for this toy is 5-10 years old.'),
            ('5',
             'sammy',
             'Yes, this board_game is suitable for adults.'),
            ('2',
             'sammy',
             'We have not set up one, but you can contact us directly if you have any questions.');

-- Insert an auto bid into the bid table
INSERT INTO bid (time, price, username, toy_id, is_auto_bid)
VALUES (NOW(), 20, 'testUser', 2, 1);

-- Insert an automatic bid into the automatic_bid table
INSERT INTO automatic_bid (increment, secret_max_price, last_bid_id, toy_id)
VALUES (.6, 40, LAST_INSERT_ID(), 2);

INSERT INTO bid (time, price, username, toy_id, is_auto_bid)
VALUES (DATE_ADD(NOW(), INTERVAL 1 MINUTE), 24, 'jane_smith', 2, 0);

-- Inserting dummy data for custom alerts
INSERT INTO alert (name, max_price, category, min_price, age_range, username, is_custom_alert)
VALUES
    ('Action Figure Alert', 20.99, 'action_figure', 10.00, '5-10', 'testUser',
     true),
    ('Stuffed Animal Alert', 15.50, 'stuffed_animal', 5.00, '3-8', 'testUser',
     true),
    ('Board Game Alert', 29.99, 'board_game', 15.00, '8-12', 'testUser', true);