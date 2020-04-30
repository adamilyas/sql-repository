-- POSTGRES

CREATE TABLE account(
    user_id serial PRIMARY KEY,
    username VARCHAR (50) UNIQUE NOT NULL,
    password VARCHAR (50) NOT NULL,
    email VARCHAR (355) UNIQUE NOT NULL,
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP
 );

INSERT INTO ACCOUNT (username, password, email) VALUES 
	('bob612312', '1231234', 'bo12312b5@email'),
	('sam234234', '1231234', 'sam234234@email'),
	('dan234', '1231234', 'dan234@email')
RETURNING ACCOUNT;

CREATE OR REPLACE FUNCTION update_password_return_username(input_user_id int, new_password text) 
RETURNS text
AS $$
  DECLARE
    account_username text;

  BEGIN 
    UPDATE account  
    SET password = new_password
    WHERE user_id=input_user_id
      returning account.username into account_username;
      
    return account_username;
  END;
$$
LANGUAGE plpgsql;

select update_password_return_username(3, 'password');
