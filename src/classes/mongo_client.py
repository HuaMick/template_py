from pymongo import MongoClient

from typing import Dict

def initialize(
    connectionStrings:Dict[str, str]
):
    dbs = {}
    for database, connectionString in connectionStrings.items():
        client = MongoClient(connectionString)
        # Test connection by requesting server info
        try:
            client.server_info()
        except Exception as e:
            raise ConnectionError(f"Failed to connect to MongoDB {database}: {str(e)}")
        dbs[database] = client
    
    # Check the connection
    print("\nDatabase connections initialized successfully!")
    print(f"Staging DB: {dbs["stg"]}")
    print(f"Production DB: {dbs["prd"]}")
    return dbs
