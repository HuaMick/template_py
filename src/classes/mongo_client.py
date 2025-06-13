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
    return dbs
