import os
import pandas as pd
from sqlalchemy import create_engine
from sqlalchemy.exc import SQLAlchemyError
import logging

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[logging.StreamHandler()]
)

def detect_separator(file_path):
    """Detects the separator used in a CSV file."""
    try:
        with open(file_path, 'r') as file:
            first_line = file.readline()
            # Check for common separators
            for sep in [',', ';', '\t', ' ']:
                if sep in first_line:
                    return sep
    except FileNotFoundError as e:
        logging.error(f"File not found: {e}")
    return ','  # Fallback to comma if no separator is detected

def load_data_to_postgres(data_directory, engine):
    """Load CSV files from a directory into PostgreSQL."""
    try:
        for filename in os.listdir(data_directory):
            if filename.endswith('.csv'):
                file_path = os.path.join(data_directory, filename)
                logging.info(f"Processing file: {filename}")

                # Detect the separator
                separator = detect_separator(file_path)
                logging.info(f"Detected separator: '{separator}'")

                # Read CSV file
                df = pd.read_csv(file_path, sep=separator, usecols=lambda column: column not in ['Unnamed: 0'], low_memory=False)

                # Prepare table name by converting the filename to lowercase
                table_name = os.path.splitext(filename)[0].lower()

                # Load DataFrame into PostgreSQL
                df.to_sql(table_name, engine, schema='raw', if_exists='replace', index=False)
                logging.info(f"Uploaded {filename} to table '{table_name}'.")

        logging.info("All files have been processed.")
    except (OSError, SQLAlchemyError) as e:
        logging.error(f"An error occurred: {e}")

def main():
    # PostgreSQL connection settings
    DB_USER = "postgres"
    DB_PASS = "postgres"
    DB_HOST = "localhost"
    DB_PORT = "5432"
    DB_NAME = "gostudent"

    # PostgreSQL connection string
    connection_string = f"postgresql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
    
    try:
        # Create a SQLAlchemy engine
        engine = create_engine(connection_string)
        logging.info("Successfully connected to the database.")

        # Directory containing the CSV files
        data_directory = 'data'

        # Load data to PostgreSQL
        load_data_to_postgres(data_directory, engine)
    
    except SQLAlchemyError as e:
        logging.error(f"Database connection failed: {e}")

if __name__ == '__main__':
    main()
