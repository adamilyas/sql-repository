-- POSTGRESQL 12
-- DROP SCHEMA IF EXISTS account CASCADE;
CREATE SCHEMA api;

CREATE TABLE api.account(
    user_id serial PRIMARY KEY,
    username VARCHAR (50) UNIQUE NOT NULL,
    password VARCHAR (50) NOT NULL,
    email VARCHAR (355) UNIQUE NOT NULL,
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP
 );


-- Prepare data
-- INSERT AND RETURN TABLE OF INSERTED ROWS
INSERT INTO api.ACCOUNT (username, password, email, created_on) VALUES
	('bob612312', '1231234', 'bo12312b5@email', NULL),
	('anne612312', '1231234', 'anne1234@email', NULL),
	('loca234234', '1231234', 'loca234234@email', NULL),
	('daybodyn234', '1231234', 'danyboy234@email', NULL),
	('alanasda2234', '1231234', 'alan234sdf2234@email', now() + '3m'),
	('del21sdfa4234', '1231234', 'del234sdf4234@email', now() + '3m'),
	('ram1234asd324', '1231234', 'ram234sdf324@email', now() + '4m');

-- USING plpgsql
CREATE OR REPLACE FUNCTION api.insert_to_account(input_json json)
RETURNS TABLE (res json)
AS $$
	DECLARE
		input_username text := (input_json->>'username')::text;
		input_password text := (input_json->>'password')::text;
		input_email text := (input_json->>'email')::text;

	BEGIN 
	RETURN QUERY
	
		INSERT INTO api.ACCOUNT (username, password, email) VALUES 
		(input_username, input_password, input_email)
		RETURNING ROW_TO_JSON(account);
	END;
$$ LANGUAGE plpgsql;


-- USING LANGUAGE sql
-- Note: https://stackoverflow.com/questions/24755468/difference-between-language-sql-and-language-plpgsql-in-postgresql-functions

-- Function and return inserted
CREATE OR REPLACE FUNCTION api.add_account(_username varchar, _password varchar, _email varchar) RETURNS api.ACCOUNT AS $$
    INSERT INTO api.ACCOUNT (username, password, email) VALUES (_username, _password, _email)
	RETURNING ACCOUNT;
$$ LANGUAGE sql;

-- Function without returning
CREATE OR REPLACE FUNCTION api.add_account_returns_void(_username varchar, _password varchar, _email varchar) RETURNS VOID AS $$
    INSERT INTO api.account (username, password, email) VALUES (_username, _password, _email);
$$ LANGUAGE sql;





-- Function and RETURN JSON
CREATE OR REPLACE FUNCTION api.add_account_return_json(_username varchar, _password varchar, _email varchar) RETURNS TABLE (J JSON) AS $$
    INSERT INTO api.ACCOUNT (username, password, email) VALUES (_username, _password, _email)
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
CREATE OR REPLACE FUNCTION api.add_account_input_json_return_json(input_json json) RETURNS TABLE (J JSON) AS $$
    INSERT INTO api.ACCOUNT (username, password, email) VALUES 
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









CREATE OR REPLACE FUNCTION api.get_all_accounts()
RETURNS TABLE (res json) 
AS $$
	BEGIN RETURN QUERY
		SELECT row_to_json(api.account);
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION api.get_account_by_username(input_json json)
RETURNS TABLE (res json)
AS $$
	DECLARE
		input_username text := (input_json->>'username')::text;

	BEGIN RETURN QUERY
		SELECT row_to_json(account) FROM account where username = input_username;
	END;
$$ LANGUAGE plpgsql;

create role web_anon nologin;
grant web_anon to postgres;

grant usage on schema api to web_anon;
grant select on api.account to web_anon;

