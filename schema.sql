CREATE SEQUENCE diefacevalue_id_seq;

CREATE TABLE DieFaceValue (
    id        INT PRIMARY KEY NOT NULL DEFAULT nextval('diefacevalue_id_seq'),
    face_id   INT             NOT NULL,
    face_name VARCHAR(30)     NOT NULL,
    range_min INT             NOT NULL,
    range_max INT             NOT NULL
);

CREATE SEQUENCE dieface_id_seq;

CREATE TABLE DieFace (
    id        INT PRIMARY KEY NOT NULL DEFAULT nextval('dieface_id_seq'),
    die_id    INT             NOT NULL,
    length    INT             NOT NULL
);

CREATE SEQUENCE die_id_seq;

CREATE TABLE Die (
    id       INT PRIMARY KEY NOT NULL DEFAULT nextval('die_id_seq'),
    game_id  INT             NOT NULL,
    die_name VARCHAR(30)     NOT NULL,
    CONSTRAINT UC_Die UNIQUE (die_name, game_id)
);

CREATE SEQUENCE game_id_seq;

CREATE TABLE Game (
    id             INT PRIMARY KEY NOT NULL DEFAULT nextval('game_id_seq'),
    chat_id        VARCHAR(60)     NOT NULL,
    game_name      VARCHAR(40)     NOT NULL,
    CONSTRAINT UC_Game UNIQUE (chat_id, game_name)
);

-- The following have not been tested

CREATE OR REPLACE PROCEDURE remove_DieFace(dieFaceIdArg IN int) AS
BEGIN
    DELETE FROM DieFace       WHERE id         = dieFaceIdArg;
    DELETE FROM DieFace_Side  WHERE dieface_id = dieFaceIdArg;
    DELETE FROM DieFace_Range WHERE dieface_id = dieFaceIdArg;
END remove_DieFace;

CREATE OR REPLACE PROCEDURE remove_Die(dieIdArg IN int) AS
DECLARE
    CURSOR DieFace_Die_cursor IS SELECT id FROM DieFace WHERE die_id = dieIdArg;
BEGIN
    DELETE FROM Die WHERE id = dieIdArg;

    FOR DieFace_Die_id IN DieFace_Die_cursor
    LOOP
        remove_DieFace(DieFace_Die_id);
    END LOOP;
END remove_Die;

CREATE OR REPLACE PROCEDURE remove_Game(gameIdArg IN int) AS
DECLARE
    CURSOR Die_game_cursor IS SELECT id FROM DieFace WHERE die_id = dieIdArg;
BEGIN

    DELETE FROM Game WHERE id = gameIdArg;

    FOR Die_Game_id IN Die_Game_cursor
    LOOP
        remove_Die(Die_Game_id);
    END LOOP;
END remove_Game;
