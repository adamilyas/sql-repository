import pyodbc

"""
pip install odbc

Documentation here: https://github.com/mkleehammer/pyodbc/wiki/Cursor
"""

def query_from_hive(query_string:str) -> list:
    DSN = "my dsn"

    results = []
    try:
        conn = pyodbc.connect(f'DSN={DSN}', autocommit=True)
        cursor = conn.cursor()

        cursor.execute(query_string)
        # print(cursor.fetchone())
        results = cursor.fetchall()
        cursor.close()
        conn.close()
    except Exception as e:
        print(e.with_traceback())

    return results

if __name__ == "__main__":
    query_string = """
    select * from some_table limit 4"""

    query_results = query_from_hive(query_string)
    for row in query_results:
        print(row)