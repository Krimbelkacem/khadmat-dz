from bson.objectid import ObjectId
from config.db import mongo


class Skill:
    def __init__(self, name):
        self.name = name

    def save(self):
        # Save the skill to the database
        skill_data = {'name': self.name}
        mongo.db.skills.insert_one(skill_data)

    @staticmethod
    def find_by_id(id):
        skill_data = mongo.db.skills.find_one({'_id': ObjectId(id)})
        if skill_data:
            return Skill(skill_data['name'])
        return None
