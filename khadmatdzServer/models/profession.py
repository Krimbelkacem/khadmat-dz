from bson.objectid import ObjectId
from config.db import mongo


class Profession:
    def __init__(self, name, user_ids=None, domain=None, skills=None):
        self.name = name
        self.user_ids = user_ids or []
        self.domain = domain or []
        self.skills = skills or []

    def add_user(self, user_id):
        self.user_ids.append(user_id)

    def add_domain(self, domain):
        self.domain.append(domain)

    def add_skill(self, skill):
        self.skills.append(skill)

    def save(self):
        # Save the profession to the database
        profession_data = {
            'name': self.name,
            'user_ids': self.user_ids,
            'domain': self.domain,
            'skills': self.skills
        }
        mongo.db.professions.insert_one(profession_data)

    @staticmethod
    def find_by_id(id):
        profession_data = mongo.db.professions.find_one({'_id': ObjectId(id)})
        if profession_data:
            return Profession(
                profession_data['name'],
                profession_data.get('user_ids', []),
                profession_data.get('domain', []),
                profession_data.get('skills', []),
            )
        return None
