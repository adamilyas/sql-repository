import sys
import argparse
import csv
import json
from os import path

"""
TODO: THIS SCRIPT IS STILL IN DEV.

Run this script via command line, cd to directory where file is and run
$ python ./generate_sql_script.py -i INPUT_FILE_NAME.csv -t table_name
"""

def create_parser():
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input", help="Input File Path", required=True, type=argparse.FileType('r', encoding='UTF-8')) 
    parser.add_argument("-t", "--table", help="Table name", required=True) 
    
    parser.add_argument("-o", "--output", help="Output File Path", type=argparse.FileType('w', encoding='UTF-8'))
    parser.add_argument("-v", "--verbose", help="Print insert statements", action="store_true")
    p = parser.parse_args()
    return p

def process_parser(parser):
    infile = parser.input
    infile_name = infile.name
    outfile = parser.output
    if outfile is None:
        
        outfile_name = path.splitext(infile_name)[0] + ".sql"
        outfile = open(outfile_name, "w")
        parser.output = outfile
    
    return parser
        
def generate_statement(field_names, table, values):

    col_name_string = str(field_names[0])
    for col_name in field_names[1:]:
        col_name_string += ", " + col_name
        
    values = tuple(values)

    statement = "INSERT INTO %s (%s) VALUES %s;\n" % (table, col_name_string, values)
    return statement

def load_data_from_csv(infile, outfile, table, verbose=False):

    csv_reader = csv.reader(infile, delimiter=',')
    first_row_flag = True
    for row in csv_reader:
        if first_row_flag:
            header = row
            first_row_flag = False
        else:
            statement = generate_statement(header, table, row)
            outfile.write(statement)
            if p.verbose:
                print(statement)

def load_data_from_json(infile, outfile, table, verbose=False):
    json_reader = json.load(infile)
    for row in json_reader:
        header = row.keys()
        value = row.values()
        statement = generate_statement(header, table, value)
        outfile.write(statement)
        if p.verbose:
            print(statement)            

if __name__ == "__main__":
    p = create_parser()
    p = process_parser(p)
    infile = p.input
    outfile = p.output
    if ".csv" in infile.name:
        load_data_from_csv(infile, outfile, p.table, p.verbose)
    elif ".json" in infile.name:
        load_data_from_json(infile, outfile, p.table, p.verbose)

    infile.close()
    outfile.close()

    print(f'Generated SQL script at: {path.abspath(outfile.name)}')
