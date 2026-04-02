CREATE SCHEMA todoapp;

CREATE TABLE todoapp.users(
	id 		SERIAL PRIMARY KEY,
	version BIGINT NOT NULL DEFAULT 1,
	full_name VARCHAR(100) NOT NULL CHECK(LENGTH(full_name) > 0),
	phone_number VARCHAR(15) NOT NULL CHECK(LENGTH(phone_number) > 10 AND LENGTH(phone_number) < 15 AND
	    (phone_number ~ '^\+?[0-9]+$' )
	)
);

CREATE TABLE todoapp.tasks(
	id            SERIAL                   PRIMARY KEY,
	version       BIGINT          NOT NULL DEFAULT 1,
	title         VARCHAR(100)    NOT NULL CHECK(LENGTH(title) > 0),
	description   VARCHAR(1000)            CHECK(LENGTH(description) BETWEEN 1 AND 1000),
	completed     BOOLEAN         NOT NULL DEFAULT FALSE,
	created_at    TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
	completed_at  TIMESTAMPTZ     CHECK(completed_at > created_at),
	CHECk(completed = FALSE AND completed_at IS NULL
		OR 
		completed = TRUE AND completed_at IS NOT NULL AND completed_at >= created_at
	),
	author_user_id INTEGER        NOT NULL REFERENCES todoapp.users(id) ON DELETE CASCADE
);