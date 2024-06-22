from bson.objectid import ObjectId
from config.db import mongo


class Education:
    def __init__(self, user_id, institution, degree, start_date, end_date=None, still_learning=False, domain=None):
        self.user_id = user_id
        self.institution = institution
        self.degree = degree
        self.start_date = start_date
        self.end_date = end_date
        self.still_learning = still_learning
        self.domain = domain

    def save(self):
        # Save the education to the database
        education_data = {
            'user_id': self.user_id,
            'institution': self.institution,
            'degree': self.degree,
            'start_date': self.start_date,
            'end_date': self.end_date,
            'still_learning': self.still_learning,
            'domain': self.domain
        }
        mongo.db.educations.insert_one(education_data)

    @staticmethod
    def find_by_id(id):
        education_data = mongo.db.educations.find_one({'_id': ObjectId(id)})
        if education_data:
            return Education(
                education_data['user_id'],
                education_data['institution'],
                education_data['degree'],
                education_data['start_date'],
                education_data.get('end_date'),
                education_data.get('still_learning', False),
                education_data.get('domain'),
            )
        return None
