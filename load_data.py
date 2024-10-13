import os
import pandas as pd
from sqlalchemy import create_engine

def detect_separator(file_path):
    with open(file_path, 'r') as f:
        # Read the first line
        first_line = f.readline()
        # Check for common separators
        if ',' in first_line:
            return ','
        elif ';' in first_line:
            return ';'
        elif '\t' in first_line:
            return '\t'
        elif ' ' in first_line:
            return ' '
    return ','  

DB_USER = "postgres"
DB_PASS = "postgres"  
DB_HOST = "localhost"
DB_PORT = "5432"
DB_NAME = "gostudent"

#postger conn
connection_string = f"postgresql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}"


engine = create_engine(connection_string)

data_directory = 'data'

for filename in os.listdir(data_directory):
    if filename.endswith('.csv'):
        file_path = os.path.join(data_directory, filename)

        #get dynamically the separator
        sep = detect_separator(file_path)

        # Read the CSV file
        df = pd.read_csv(file_path, sep=sep, usecols=lambda column: column not in ['Unnamed: 0'],low_memory=False)

        table_name = os.path.splitext(filename)[0].lower()  # Converts to lowercase

        # Write DataFrame to PostgreSQL
        df.to_sql(table_name, engine, schema='raw', if_exists='replace', index=False)
        print(f"Uploaded {filename} to table {table_name}.")

print("All files have been processed.")
