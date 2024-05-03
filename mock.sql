-- Mock data for user table
INSERT INTO user (username, password) VALUES
                                          ('john_doe', 'password123'),
                                          ('jane_smith', 'securePass'),
                                          ('bob_jones', 'bobspassword');

-- Mock data for toy_listing table
INSERT INTO toy_listing (initial_price, category, name, start_age, end_age, secret_min_price, closing_datetime, increment, start_datetime, username) VALUES
                                                                                                                                                         (20.00, 'action_figure', 'Spiderman ', 5, 10, 15.00, '2024-05-10 12:00:00', 2.00, '2024-05-03 12:00:00', 'john_doe'),
                                                                                                                                                         (15.00, 'board_game', 'Monopoly', 8, 99, 10.00, '2024-05-15 18:00:00', 1.00, '2024-05-05 09:00:00', 'jane_smith'),
                                                                                                                                                         (10.00, 'stuffed_animal', 'Teddy Bear', 0, 5, 7.00, '2024-05-08 15:00:00', 0.50, '2024-05-01 10:00:00', 'bob_jones');

-- Mock data for action_figure table
INSERT INTO action_figure (toy_id, height, can_move, character_name) VALUES
    (1, 10.5, TRUE, 'Spiderman');

-- Mock data for board_game table
INSERT INTO board_game (toy_id, player_count, brand, is_cards_game) VALUES
    (2, 4, 'Hasbro', FALSE);
-- Mock data for stuffed_animal table
INSERT INTO stuffed_animal (toy_id, color, brand, animal) VALUES
    (3, 'Brown', 'Build-A-Bear', 'Bear');
-- Mock data for bid table
INSERT INTO bid (time, price, username, toy_id, is_auto_bid) VALUES
                                                                 ('2024-05-05 12:30:00', 25.00, 'jane_smith', 1, FALSE),
                                                                 ('2024-05-06 09:45:00', 12.50, 'bob_jones', 3, FALSE),
                                                                 ('2024-05-07 14:20:00', 17.50, 'john_doe', 2, TRUE);

-- Mock data for sale table
INSERT INTO sale (date, toy_id, b_id) VALUES
                                          ('2024-05-10 12:05:00', 1, 1),
                                          ('2024-05-08 15:10:00', 3, 2);

-- Mock data for alert table
INSERT INTO alert (alert_id, name, max_price, category, min_price, age_range, username) VALUES
                                                                                            ('AL001', 'Spiderman action_figure Alert', 30.00, 'action_figure', 10.00, '5-10', 'john_doe'),
                                                                                            ('AL002', 'Monopoly Alert', 20.00, 'board_game', 8.00, '8+', 'jane_smith');

-- Mock data for report table
INSERT INTO report (report_id, date, total_earnings, admin_id, earnings_per, best_selling) VALUES
                                                                                               ("id1", '2024-05-10', 75.00, 'admin', 25.00, 'Spiderman action_figure'),
                                                                                               ("id2", '2024-05-08', 30.00, 'admin', 15.00, 'Teddy Bear');

-- Mock data for automatic_bid table
INSERT INTO automatic_bid (increment, secret_max_price, last_bid_id, toy_id) VALUES
                                                                                 (2.00, 35.00, 1, 1),
                                                                                 (1.00, 18.00, 2, 3);

-- Mock data for question table
INSERT INTO question (question_text, q_id, username) VALUES
                                                         ('What is the recommended age for this toy?', '4', 'john_doe'),
                                                         ('Is this board_game suitable for adults?', '5', 'jane_smith');

-- Mock data for answer table
INSERT INTO answer (q_id, c_id, answer_text) VALUES
                                                 ('4', 'sammy', 'The recommended age range for this toy is 5-10 years old.'),
                                                 ('5', 'sammy', 'Yes, this board_game is suitable for adults.');