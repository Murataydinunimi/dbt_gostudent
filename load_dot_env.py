import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Read the variables
DB_USER = os.getenv('DB_USER')
DB_PASS = os.getenv('DB_PASS')
DB_HOST = os.getenv('DB_HOST')
DB_PORT = os.getenv('DB_PORT')
DB_NAME = os.getenv('DB_NAME')
USER = os.getenv('USER')
# Print or use these values as needed
print(f"Connecting to database {DB_NAME} at {DB_HOST}:{DB_PORT} as {DB_USER}")
