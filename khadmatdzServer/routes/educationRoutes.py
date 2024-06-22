from flask import request, jsonify, Blueprint
import jwt
from config.db import mongo
from flask_jwt_extended import jwt_required
from bson import ObjectId

education_routes = Blueprint('education_routes', __name__)

# Function to decode JWT token and extract user ID


def decode_token(token):
    try:
        # Decode the JWT token to extract user ID
        decoded_token = jwt.decode(
            token, 'your_secret_key', algorithms=['HS256'])
        user_id = decoded_token['sub']  # Extract user ID from 'sub' key
        return user_id
    except jwt.ExpiredSignatureError:
        return None  # Token has expired
    except jwt.InvalidTokenError:
        return None  # Invalid token


# Route to create education
@education_routes.route('/user/education', methods=['POST'])
def create_education():
    # Retrieve the JWT token from the query parameters
    token = request.args.get('token')
    print('Received token:', token)

    if not token:
        return jsonify({'error': 'Token is missing'}), 400

    # Decode the token and extract user ID
    user_id = decode_token(token)
    if not user_id:
        return jsonify({'error': 'Invalid or expired token'}), 401

    data = request.get_json()
    institution = data.get('institution')
    degree = data.get('degree')
    field_of_study = data.get('field_of_study')
    start_date = data.get('start_date')
    end_date = data.get('end_date')
    still_learning = data.get('still_learning', False)

    # Insert the education record into the database
    new_education = {
        'user_id': user_id,
        'institution': institution,
        'degree': degree,
        'field_of_study': field_of_study,
        'start_date': start_date,
        'end_date': end_date,
        'still_learning': still_learning
    }

    result = mongo.db.educations.insert_one(new_education)

    return jsonify({'message': 'Education created successfully', 'education_id': str(result.inserted_id)}), 201


# Route to update education


@education_routes.route('/user/education/<education_id>', methods=['PUT'])
def update_education(education_id):
    # Retrieve the JWT token from the query parameters
    token = request.args.get('token')
    print('Received token:', token)

    if not token:
        return jsonify({'error': 'Token is missing'}), 400

    # Decode the token and extract user ID
    user_id = decode_token(token)
    if not user_id:
        return jsonify({'error': 'Invalid or expired token'}), 401

    data = request.get_json()
    institution = data.get('institution')
    degree = data.get('degree')
    field_of_study = data.get('field_of_study')
    start_date = data.get('start_date')
    end_date = data.get('end_date')
    still_learning = data.get('still_learning', False)

    # Find the education record to update
    education = mongo.db.educations.find_one(
        {'_id': ObjectId(education_id), 'user_id': user_id})
    if not education:
        return jsonify({'error': 'Education not found or unauthorized'}), 404

    # Prepare update data
    update_data = {
        'institution': institution,
        'degree': degree,
        'field_of_study': field_of_study,
        'start_date': start_date,
        'still_learning': still_learning
    }

    # Add end_date to update data if provided
    if end_date is not None:
        update_data['end_date'] = end_date

    # Update the education record
    mongo.db.educations.update_one(
        {'_id': ObjectId(education_id)}, {'$set': update_data})

    return jsonify({'message': 'Education updated successfully'}), 200


# Route to remove education
@education_routes.route('/user/education/<education_id>', methods=['DELETE'])
def remove_education(education_id):
    # Retrieve the JWT token from the query parameters
    userId = request.args.get('userId')
    print('Received token:', userId)

    if not userId:
        return jsonify({'error': 'userId is missing'}), 400

    # Decode the token and extract user ID
    user_id = userId

    # Find the education record to remove
    education = mongo.db.educations.find_one(
        {'_id': ObjectId(education_id), 'user_id': user_id})
    if not education:
        return jsonify({'error': 'Education not found or unauthorized'}), 404

    # Remove the education record from the database
    mongo.db.educations.delete_one({'_id': ObjectId(education_id)})

    return jsonify({'message': 'Education removed successfully'}), 200


# Route to get all education records for a user
@education_routes.route('/user/educations', methods=['GET'])
def get_educations():
    try:
        # Decode the JWT token to extract user ID
        token = request.args.get('token')
        user_id = decode_token(token)

        if not user_id:
            return jsonify({'error': 'Invalid or expired token'}), 401

        # Find all education records for the user
        educations = list(mongo.db.educations.find({'user_id': user_id}))

        # Convert ObjectId to string for JSON serialization
        for education in educations:
            education['_id'] = str(education['_id'])

        return jsonify({'educations': educations}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
