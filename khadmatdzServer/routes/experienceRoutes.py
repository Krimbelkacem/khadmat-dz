from bson import ObjectId
from flask import request, jsonify, Blueprint, send_from_directory
from config.db import mongo

exp_routes = Blueprint('exp_routes', __name__)


@exp_routes.route('/user/addexperience', methods=['POST'])
def add_experience():
    user_id = request.args.get('user_id')
    if not user_id:
        return jsonify({'error': 'User ID is required in query parameters'}), 400

    data = request.json
    start_date = data.get('start_date')
    profession = data.get('profession')
    end_date = data.get('end_date', False)
    still_working = data.get('still_working', False)
    institution = data.get('institution')

    # Find the user
    user = mongo.db.users.find_one({'_id': ObjectId(user_id)})
    if not user:
        return jsonify({'error': 'User not found'}), 404

    # Initialize experiences field if not present
    if 'experiences' not in user:
        user['experiences'] = []

    # Add the experience
    experience = {
        'start_date': start_date,
        'profession': profession,
        'end_date': end_date,
        'still_working': still_working,
        'institution': institution
    }
    user['experiences'].append(experience)
    mongo.db.users.update_one({'_id': ObjectId(user_id)}, {
                              '$set': {'experiences': user['experiences']}})

    return jsonify({'message': 'Experience added successfully'}), 201


@exp_routes.route('/user/updateexperience/<experience_id>', methods=['PUT'])
def update_experience(experience_id):
    user_id = request.args.get('user_id')
    if not user_id:
        return jsonify({'error': 'User ID is required in query parameters'}), 400

    data = request.json
    start_date = data.get('start_date')
    profession = data.get('profession')
    end_date = data.get('end_date')
    still_working = data.get('still_working')
    institution = data.get('institution')

    # Find the user
    user = mongo.db.users.find_one({'_id': ObjectId(user_id)})
    if not user:
        return jsonify({'error': 'User not found'}), 404

    # Find the experience index
    experience_index = next((index for index, exp in enumerate(
        user['experiences']) if str(exp['_id']) == experience_id), None)
    if experience_index is None:
        return jsonify({'error': 'Experience not found'}), 404

    # Update the experience
    if start_date:
        user['experiences'][experience_index]['start_date'] = start_date
    if profession:
        user['experiences'][experience_index]['profession'] = profession
    if end_date is not None:
        user['experiences'][experience_index]['end_date'] = end_date
    if still_working is not None:
        user['experiences'][experience_index]['still_working'] = still_working

    if institution is not None:
        user['experiences'][experience_index]['still_working'] = institution

    mongo.db.users.update_one({'_id': ObjectId(user_id)}, {
                              '$set': {'experiences': user['experiences']}})

    return jsonify({'message': 'Experience updated successfully'})


@exp_routes.route('/user/deleteexperience/<start_date>', methods=['DELETE'])
def delete_experience(start_date):
    user_id = request.args.get('user_id')
    if not user_id:
        return jsonify({'error': 'User ID is required in query parameters'}), 400

    # Find the user
    user = mongo.db.users.find_one({'_id': ObjectId(user_id)})
    if not user:
        return jsonify({'error': 'User not found'}), 404

    # Find and remove the experience with the matching start date
    user_experiences = user.get('experiences', [])
    updated_experiences = [
        exp for exp in user_experiences if exp.get('start_date') != start_date]

    # Update the user document with the modified experiences
    mongo.db.users.update_one({'_id': ObjectId(user_id)}, {
                              '$set': {'experiences': updated_experiences}})

    return jsonify({'message': 'Experience deleted successfully'})
