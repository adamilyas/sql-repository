import psycopg2

USER = "postgres"
PASSWORD = "password"
LOCALHOST = "127.0.0.1"
PORT = "5432"
DATABASE = "users"

def test_connection():
    try:
        connection = psycopg2.connect(user = USER,
                                    password = PASSWORD,
                                    host = LOCALHOST,
                                    port = PORT,
                                    database = DATABASE)
        cursor = connection.cursor()
        # Print PostgreSQL Connection properties
        print ( connection.get_dsn_parameters(),"\n")

        # Print PostgreSQL version
        cursor.execute("SELECT version();")
        record = cursor.fetchone()
        print("You are connected to - ", record,"\n")
    except (Exception, psycopg2.Error) as error :
        print ("Error while connecting to PostgreSQL", error)
    finally:
        #closing database connection.
        cursor.close()
        connection.close()
        print("PostgreSQL connection is closed")

def query_from_db(query_statement, connection):
    """
    query_statement: select * from table
    connection: use `psycopg2.connect`
    Returns
        List of tuple (rows)
    """
    if connection:
        cursor = connection.cursor()
        cursor.execute(query_statement)
        results = cursor.fetchall() 
        return results
    else:
        print("Connection Error")
        return []


if __name__ == "__main__":
    test_connection()
