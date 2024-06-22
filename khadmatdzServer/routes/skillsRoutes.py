from flask import request, jsonify, Blueprint
import jwt
from config.db import mongo
from flask_jwt_extended import jwt_required
from bson import ObjectId

from models.skill import Skill
from models.user import User

skills_routes = Blueprint('skills_routes', __name__)

# Function to decode JWT token and extract user ID


@skills_routes.route('/skills/getall', methods=['GET'])
def get_all_skills():
    skills = []
    for skill_data in mongo.db.skills.find():
        skill = Skill(skill_data['name'])
        skills.append({'id': str(skill_data['_id']), 'name': skill.name})

    return jsonify({'skills': skills})


@skills_routes.route('/skills/add_skills', methods=['POST'])
def add_skills():
    # Get the user ID from the query parameters
    user_id = request.args.get('user_id')

    # Validate that the user ID is provided
    if not user_id:
        return jsonify({'error': 'User ID is required in query parameters'}), 400

    # Get the skill names from the request body
    skill_names = request.json.get('skills', [])

    # Validate that at least one skill name is provided
    if not skill_names:
        return jsonify({'error': 'At least one skill name is required'}), 400

    # Find the user by ID
    user = User.find_by_id(user_id)

    # Check if the user exists
    if not user:
        return jsonify({'error': 'User not found'}), 404

    # Add each skill name to the user
    for skill_name in skill_names:
        user.add_skill(skill_name)

    user.save()  # Update the existing user with new skills

    return jsonify({'message': 'Skills added successfully'}), 200


# Define the route to delete a skill
@skills_routes.route('/skills/delete_skill', methods=['POST'])
def delete_skill():
    # Get the user ID from the query parameters
    user_id = request.args.get('user_id')

    # Validate that the user ID is provided
    if not user_id:
        return jsonify({'error': 'User ID is required in query parameters'}), 400

    # Get the skill data from the request
    skill_data = request.json

    # Validate that the required fields are present
    if 'skill_name' not in skill_data:
        return jsonify({'error': 'Skill name is required'}), 400

    # Find the user by ID
    user = User.find_by_id(user_id)

    # Check if the user exists
    if not user:
        return jsonify({'error': 'User not found'}), 404

    # Remove the skill from the user's skills list
    if skill_data['skill_name'] in user.skills:
        user.skills.remove(skill_data['skill_name'])
        user.save()  # Save the updated user to the database
        return jsonify({'message': 'Skill deleted successfully'}), 200
    else:
        return jsonify({'error': 'Skill not found in user skills'}), 404
