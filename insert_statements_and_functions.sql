-- POSTGRESQL 12

CREATE TABLE account(
    user_id serial PRIMARY KEY,
    username VARCHAR (50) UNIQUE NOT NULL,
    password VARCHAR (50) NOT NULL,
    email VARCHAR (355) UNIQUE NOT NULL,
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP
 );

/*
DELETE FROM ACCOUNT;
DROP FUNCTION IF EXISTS add_account;
DROP FUNCTION IF EXISTS add_account_return_json;
DROP FUNCTION IF EXISTS add_account_input_json_return_json;
*/

-- ORIGINAL QUERY
INSERT INTO ACCOUNT (username, password, email) VALUES ('bob612312', '1231234', 'bo12312b5@email') RETURNING ACCOUNT;

-- Function and return inserted
CREATE OR REPLACE FUNCTION add_account(_username varchar, _password varchar, _email varchar) RETURNS ACCOUNT AS $$
    INSERT INTO ACCOUNT (username, password, email) VALUES (_username, _password, _email)
	RETURNING ACCOUNT;
$$ LANGUAGE sql;

-- Function without returning
CREATE OR REPLACE FUNCTION add_account_returns_void(_username varchar, _password varchar, _email varchar) RETURNS VOID AS $$
    INSERT INTO ACCOUNT (username, password, email) VALUES (_username, _password, _email);
$$ LANGUAGE sql;

-- Function and RETURN JSON
CREATE OR REPLACE FUNCTION add_account_return_json(_username varchar, _password varchar, _email varchar) RETURNS TABLE (J JSON) AS $$
    INSERT INTO ACCOUNT (username, password, email) VALUES (_username, _password, _email)
	RETURNING json_build_object(
		'user_id', ACCOUNT.user_id,
		'username', ACCOUNT.username,
		'password', ACCOUNT.password,
		'email', ACCOUNT.email,
		'created_on', ACCOUNT.created_on,
		'last_login', ACCOUNT.last_login
	);
$$ LANGUAGE sql;

-- INPUT JSON, RETURN JSON
-- EXAMPLE QUERY: SELECT add_account_input_json_return_json ('{"username": "a", "password": "p", "email":A@E}'::json);
-- get method using (input->>ATTRIBUTE_NAME)::TYPE
CREATE OR REPLACE FUNCTION add_account_input_json_return_json(input_json json) RETURNS TABLE (J JSON) AS $$
    INSERT INTO ACCOUNT (username, password, email) VALUES 
	(
		(input_json->>'username' )::VARCHAR,
		(input_json->>'password' )::VARCHAR, 
		(input_json->>'email' )::VARCHAR
	)
	RETURNING json_build_object(
		'user_id', ACCOUNT.user_id,
		'username', ACCOUNT.username,
		'password', ACCOUNT.password,
		'email', ACCOUNT.email,
		'created_on', ACCOUNT.created_on,
		'last_login', ACCOUNT.last_login
	);
$$ LANGUAGE sql;

-- example queries
SELECT add_account('bob6', '1234', 'bob5@email');
SELECT add_account_return_json('bob6', '1234', 'bob5@email');
SELECT add_account_input_json_return_json (
	'{"username": "adam", "password": "pass12", "email":"adam_new_email"}'::json);
