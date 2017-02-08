CREATE TABLE users (
id INTEGER PRIMARY KEY,
fname TEXT NOT NULL,
lname TEXT NOT NULL

);

CREATE TABLE questions(
id INTEGER PRIMARY KEY,
title TEXT NOT NULL,
body TEXT,
author_id INTEGER NOT NULL,

FOREIGN KEY (author_id) REFERENCES users(id)

);

CREATE TABLE questions_follows (
id INTEGER PRIMARY KEY,
question_id INTEGER NOT NULL,
user_id INTEGER NOT NULL,

FOREIGN KEY (question_id) REFERENCES questions(id),
FOREIGN KEY (user_id) REFERENCES user(id)


);

CREATE TABLE replies (
id INTEGER PRIMARY KEY,
question_id INTEGER NOT NULL,
parent_reply_id INTEGER,
user_id INTEGER NOT NULL,
body TEXT NOT NULL,

FOREIGN KEY (question_id) REFERENCES questions(id),
FOREIGN KEY (user_id) REFERENCES users(id),
FOREIGN KEY (parent_reply_id) REFERENCES replies(id)

);

CREATE TABLE question_likes (
id INTEGER PRIMARY KEY,
question_id INTEGER NOT NULL,
user_id INTEGER NOT NULL,

FOREIGN KEY (question_id) REFERENCES questions(id),
FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO
  users(fname, lname)
VALUES
  ('VINSON', 'CHEN'),
  ('Dallas', 'hall');

INSERT INTO
  questions(title, body, author_id)
VALUES
  ("Life the universe and everything", "What?", 2),
  ("What's the answer to question 1?", "Nobody knows", 1),
  ("huh?", "F'real", 1),
  ("Whats for breakfast?", "Is it eggs? Love eggs.", 2);

INSERT INTO
  replies(question_id, parent_reply_id, user_id, body)
VALUES
  (1, NULL, 1, "42");

INSERT INTO
  replies(question_id, parent_reply_id, user_id, body)
VALUES
  (1, 1, 2, "WROONG!\nCHECK UR SOURCES!!");

INSERT INTO
  replies(question_id, parent_reply_id, user_id, body)
VALUES
  (1, 2, 1, "UNFOLLOW");

INSERT INTO
  questions_follows (question_id, user_id)
VALUES
  (1, 2),
  (1, 1),
  (2, 1);

INSERT INTO
  question_likes(question_id, user_id)
VALUES
  (1, 1),
  (1, 2),
  (1, 1),
  (2, 1),
  (4, 1),
  (4, 1),
  (3, 2),
  (3, 2),
  (3, 2),
  (3, 2),
  (3, 2),
  (3, 2),
  (3, 2);
