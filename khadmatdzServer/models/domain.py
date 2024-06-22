from bson.objectid import ObjectId
from config.db import mongo


class Domain:
    def __init__(self, name):
        self.name = name

    def save(self):
        # Save the domain to the database
        mongo.db.domains.insert_one({
            'name': self.name
        })

    @staticmethod
    def find_by_id(id):
        domain_data = mongo.db.domains.find_one({'_id': ObjectId(id)})
        if domain_data:
            return Domain(domain_data['name'])
        return None
