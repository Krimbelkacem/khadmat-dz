import datetime
from bson.objectid import ObjectId
from config.db import mongo


class Experience:
    def __init__(self, start_date, position, profession=None, end_date=None, still_working=False, institution=False):
        self._id = ObjectId()
        self.start_date = start_date
        self.end_date = end_date
        self.still_working = still_working
        self.profession = profession
        self.position = position
        self.institution = institution


class Proposal:
    def __init__(self, title, description=None, budget=None, timeline=None, image=None, date_created=None):
        self._id = ObjectId()
        self.title = title
        self.description = description
        self.budget = budget
        self.timeline = timeline
        self.image = image
        self.date_created = datetime.datetime.now()


class User:
    def __init__(self, username, email, password, is_client=False, picture=None, actualprofession=None, skills=None, experiences=None, languages=None, cv_file=None):
        self.username = username
        self.email = email
        self.password = password
        self.is_client = is_client
        self.picture = picture
        self.actualprofession = actualprofession
        self.skills = skills or []
        self.experiences = experiences or []
        self.languages = languages or []
        self.cv_file = cv_file
        self.proposals = []

    def add_skill(self, skill_id):
        self.skills.append(skill_id)

    def add_experience(self, start_date, position, profession=None, end_date=None, still_working=False):
        experience = Experience(start_date, position,
                                profession, end_date, still_working)
        self.experiences.append(experience)
        self.save()

    def add_language(self, language):
        self.languages.append(language)

    def add_proposal(self, title, description=None, budget=None, timeline=None, image=None, date_created=None):
        proposal = Proposal(title, description, budget,
                            timeline, image, date_created)
        self.proposals.append(proposal)
        self.save()

    def update_is_client(self):
        self.is_client = True
        self.save()

    def save(self):
        existing_user = mongo.db.users.find_one({'email': self.email})
        if existing_user:
            update_data = {
                'username': self.username,
                'password': self.password,
                'is_client': self.is_client,
                'picture': self.picture,
                'actualprofession': self.actualprofession,
                'skills': self.skills,
                'experiences': [
                    {
                        '_id': exp._id,
                        'start_date': exp.start_date,
                        'end_date': exp.end_date,
                        'still_working': exp.still_working,
                        'profession': exp.profession
                    }
                    for exp in self.experiences
                ],
                'languages': self.languages,
                'cv_file': self.cv_file,
                'proposals': [
                    {
                        '_id': proposal._id,
                        'title': proposal.title,
                        'description': proposal.description,
                        'budget': proposal.budget,
                        'timeline': proposal.timeline,
                        'image': proposal.image,
                        'date_created': proposal.date_created
                    }
                    for proposal in self.proposals
                ]
            }
            mongo.db.users.update_one(
                {'email': self.email}, {'$set': update_data})
        else:
            user_data = {
                'username': self.username,
                'email': self.email,
                'password': self.password,
                'is_client': self.is_client,
                'picture': self.picture,
                'actualprofession': self.actualprofession,
                'skills': self.skills,
                'experiences': [
                    {
                        '_id': exp._id,
                        'start_date': exp.start_date,
                        'end_date': exp.end_date,
                        'still_working': exp.still_working,
                        'profession': exp.profession
                    }
                    for exp in self.experiences
                ],
                'languages': self.languages,
                'cv_file': self.cv_file,
                'proposals': [
                    {
                        '_id': proposal._id,
                        'title': proposal.title,
                        'description': proposal.description,
                        'budget': proposal.budget,
                        'timeline': proposal.timeline,
                        'image': proposal.image,
                        'date_created': proposal.date_created
                    }
                    for proposal in self.proposals
                ]
            }
            mongo.db.users.insert_one(user_data)

    @staticmethod
    def find_by_id(id):
        user_data = mongo.db.users.find_one({'_id': ObjectId(id)})
        if user_data:
            user = User(
                user_data['username'],
                user_data['email'],
                user_data['password'],
                user_data.get('is_client', False),
                user_data.get('picture'),
                user_data.get('actualprofession'),
                user_data.get('skills', []),
                [
                    Experience(
                        exp['start_date'],
                        # Use .get() method with a default value
                        exp.get('position', ''),
                        exp.get('profession'),
                        exp.get('end_date'),
                        exp['still_working']
                    )
                    for exp in user_data.get('experiences', [])
                ],
                user_data.get('languages', []),
                user_data.get('cv_file')
            )
            # Load existing proposals
            user.proposals = [
                Proposal(
                    proposal['title'],
                    proposal['description'],
                    proposal['budget'],
                    proposal['timeline'],
                    proposal['image'],
                    proposal['date_created']
                )
                for proposal in user_data.get('proposals', [])
            ]
            return user
        return None
