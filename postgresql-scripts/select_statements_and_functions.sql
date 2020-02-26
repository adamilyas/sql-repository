CREATE TABLE account(
    user_id serial PRIMARY KEY,
    username VARCHAR (50) UNIQUE NOT NULL,
    password VARCHAR (50) NOT NULL,
    email VARCHAR (355) UNIQUE NOT NULL,
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP
 );

-- Prepare data
-- INSERT AND RETURN TABLE OF INSERTED ROWS
INSERT INTO ACCOUNT (username, password, email) VALUES 
	('bob612312', '1231234', 'bo12312b5@email'),
	('sam234234', '1231234', 'sam234234@email'),
	('dan234', '1231234', 'dan234@email')
RETURNING ACCOUNT;

INSERT INTO ACCOUNT (username, password, email, created_on) VALUES 
	('alan2234', '1231234', 'alan2234@email', now() + '3m'),
	('del4234', '1231234', 'del4234@email', now() + '3m'),
	('ram324', '1231234', 'ram324@email', now() + '4m')
RETURNING ACCOUNT;

DROP FUNCTION IF EXISTS get_all_accounts;

CREATE OR REPLACE FUNCTION get_all_accounts()
RETURNS TABLE (res json) 
AS $$
	BEGIN RETURN QUERY
		SELECT row_to_json(account) FROM account;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_account_by_username(input_json json)
RETURNS TABLE (res json)
AS $$
	DECLARE
		input_username text := (input_json->>'username')::text;

	BEGIN RETURN QUERY
		SELECT row_to_json(account) FROM account where username = input_username;
	END;
$$ LANGUAGE plpgsql;

select get_account_by_username('{"username": "dan234"}'::json);