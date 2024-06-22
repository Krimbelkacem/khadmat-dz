import os
from bson import ObjectId
from flask import app, request, jsonify, Blueprint, send_from_directory
from config.config import ALLOWED_EXTENSIONS, FILE_UPLOAD_FOLDER, IMAGE_DESCRIPTION_FOLDER
from config.db import mongo
from flask_bcrypt import generate_password_hash, check_password_hash
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_identity
import jwt  # Import the JWT library
from models.user import User
from utils import upload_file, upload_cv_file
from werkzeug.utils import secure_filename

user_routes = Blueprint('user_routes', __name__)
UPLOAD_FOLDER = 'uploads'


@user_routes.route('/user/upload_cv', methods=['POST'])
def upload_cv():
    # Get the user ID from the query parameters
    user_id = request.args.get('user_id')
    if not user_id:
        return jsonify({'error': 'User ID is required'})

    if 'file' not in request.files:
        return jsonify({'error': 'No file part'})

    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'})

    filename = secure_filename(file.filename)  # Ensure a secure filename

    # Save the file to the upload folder
    file_path = os.path.join(FILE_UPLOAD_FOLDER, filename)
    file.save(file_path)

    # Retrieve the user object from the database using the provided user_id
    user = mongo.db.users.find_one({'_id': ObjectId(user_id)})
    if user:
        # Update the user object with the filename
        user['cv_file'] = filename
        mongo.db.users.update_one({'_id': ObjectId(user_id)}, {'$set': user})
        return jsonify({'message': 'CV uploaded successfully', 'filename': filename})
    else:
        return jsonify({'error': 'User not found'})


# User sign-in route with JWT token generation

# Route to serve user profile pictures

# Change the endpoint URL for serving CV files


@user_routes.route('/user/cv/<filename>', methods=['GET'])
def serve_cv(filename):
    return send_from_directory(FILE_UPLOAD_FOLDER, filename)


@user_routes.route('/user/delete_cv', methods=['POST'])
def delete_cv():
    # Get the user ID from the query parameters
    user_id = request.args.get('user_id')
    if not user_id:
        return jsonify({'error': 'User ID is required'})

    # Retrieve the user object from the database using the provided user_id
    user = mongo.db.users.find_one({'_id': ObjectId(user_id)})
    if not user:
        return jsonify({'error': 'User not found'})

    # Check if the user has a CV file path
    if 'cv_file_path' not in user:
        return jsonify({'error': 'CV not found for this user'})

    try:
        # Delete the CV file from the file system
        cv_file_path = user['cv_file_path']
        if os.path.exists(cv_file_path):
            os.remove(cv_file_path)

        # Remove the CV file path from the user object and update the database
        del user['cv_file_path']
        mongo.db.users.update_one({'_id': ObjectId(user_id)}, {
                                  '$unset': {'cv_file_path': 1}})

        return jsonify({'message': 'CV deleted successfully'})
    except Exception as e:
        return jsonify({'error': f'Failed to delete CV: {str(e)}'}), 500


@user_routes.route('/user/signin', methods=['POST'])
def sign_in():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    # Retrieve the user from the database based on the email
    user = mongo.db.users.find_one({'email': email})

    if not user:
        return jsonify({'error': 'User not found'}), 404

    # Check if the provided password matches the hashed password stored in the database
    if check_password_hash(user['password'], password):
        # Passwords match, user is authenticated
        # Generate a JWT token
        token = create_access_token(identity=str(user['_id']))
        return jsonify({'token': token}), 200  # Return the JWT token
    else:
        # Passwords don't match
        return jsonify({'error': 'Incorrect password'}), 401

# User profile route with token-based authentication


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

# Route to get user profile


@user_routes.route('/user/profile', methods=['GET'])
def get_user_profile():
    try:
        # Retrieve the JWT token from the query parameters
        token = request.args.get('token')
        if not token:
            return jsonify({'error': 'Token is missing'}), 400

        # Decode the token and extract user ID
        user_id = decode_token(token)
        if not user_id:
            return jsonify({'error': 'Invalid or expired token'}), 401

        # Retrieve user information from the database based on the user ID
        user = mongo.db.users.find_one({'_id': ObjectId(user_id)})
        if user:
            # Convert ObjectId to string for _id field
            user_id_str = str(user['_id'])
            # Convert ObjectId to string for _id fields within experiences and proposals
            user['experiences'] = [
                {**exp, '_id': str(exp.get('_id'))} for exp in user.get('experiences', [])
            ]
            user['proposals'] = [
                {**proposal, '_id': str(proposal.get('_id'))} for proposal in user.get('proposals', [])
            ]

            output = {
                'id': user_id_str,
                'email': user.get('email', ''),
                'username': user.get('username', ''),
                'picture': user.get('picture', ''),
                'biography': user.get('biography', ''),
                'languages': user.get('languages', []),
                'cv_file': user.get('cv_file', ''),
                'experiences': user.get('experiences', []),
                'skills': user.get('skills', [])
            }

            return jsonify({'result': output}), 200
        else:
            return jsonify({'error': 'No such user'}), 404
    except Exception as e:
        # Log the error for debugging purposes
        app.logger.error(f"Error in get_user_profile: {str(e)}")
        return jsonify({'error': str(e)}), 500


@user_routes.route('/users', methods=['GET'])
def get_users():
    users = mongo.db.users.find()
    output = [{'username': user['username'], 'email': user['email']}
              for user in users]
    return jsonify({'result': output})


@user_routes.route('/user', methods=['POST'])
def add_user():
    data = request.get_json()
    username = data['username']
    email = data['email']
    password = data['password']

    # Hashing the password
    hashed_password = generate_password_hash(password).decode('utf-8')

    # Logging the incoming data
    print(f'Username: {username}, Email: {email}')

    new_user = {'username': username,
                'email': email, 'password': hashed_password}
    mongo.db.users.insert_one(new_user)
    return jsonify({'message': 'User added successfully'})


@user_routes.route('/user/<user_id>/addpicture', methods=['POST'])
def add_user_picture(user_id):
    user = mongo.db.users.find_one({'_id': ObjectId(user_id)})
    if not user:
        return jsonify({'error': 'User not found'})

    if 'file' not in request.files:
        return jsonify({'error': 'No file part'})

    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'})

    filename = upload_file(file)
    if filename:
        mongo.db.users.update_one({'_id': ObjectId(user_id)}, {
                                  '$set': {'picture': filename}})
        return jsonify({'message': 'Picture added successfully', 'filename': filename})

    return jsonify({'error': 'Error uploading file'})


# Route to serve user profile pictures
@user_routes.route('/user/profile_picture/<filename>', methods=['GET'])
def serve_profile_picture(filename):
    return send_from_directory(UPLOAD_FOLDER, filename)
#
###
#############################
##############


@user_routes.route('/user/add_biography', methods=['POST'])
def add_biography():
    data = request.get_json()
    user_id = data.get('user_id')
    biography = data.get('biography')

    if not user_id:
        return jsonify({'error': 'User ID is required'})

    if not biography:
        return jsonify({'error': 'Biography is required'})

    try:
        # Retrieve the user object from the database using the provided user_id
        user = mongo.db.users.find_one({'_id': ObjectId(user_id)})
        if user:
            # Update the user object with the biography
            user['biography'] = biography
            mongo.db.users.update_one(
                {'_id': ObjectId(user_id)}, {'$set': user})
            return jsonify({'message': 'Biography added successfully'})
        else:
            return jsonify({'error': 'User not found'})
    except Exception as e:
        return jsonify({'error': f'Failed to add biography: {str(e)}'}), 500


##################
@user_routes.route('/user/update_biography', methods=['POST'])
def update_biography():
    data = request.get_json()
    user_id = data.get('user_id')
    new_biography = data.get('biography')

    if not user_id:
        return jsonify({'error': 'User ID is required'})

    if not new_biography:
        return jsonify({'error': 'New biography is required'})

    try:
        # Retrieve the user object from the database using the provided user_id
        user = mongo.db.users.find_one({'_id': ObjectId(user_id)})
        if user:
            # Update the user object with the new biography
            user['biography'] = new_biography
            mongo.db.users.update_one(
                {'_id': ObjectId(user_id)}, {'$set': user})
            return jsonify({'message': 'Biography updated successfully'})
        else:
            return jsonify({'error': 'User not found'})
    except Exception as e:
        return jsonify({'error': f'Failed to update biography: {str(e)}'}), 500

    ####################
    #########################
    #########################


@user_routes.route('/user/delete_biography', methods=['POST'])
def delete_biography():
    data = request.get_json()
    user_id = data.get('user_id')

    if not user_id:
        return jsonify({'error': 'User ID is required'})

    try:
        # Retrieve the user object from the database using the provided user_id
        user = mongo.db.users.find_one({'_id': ObjectId(user_id)})
        if user:
            # Check if the user has a biography
            if 'biography' in user:
                # Remove the biography field from the user object and update the database
                del user['biography']
                mongo.db.users.update_one({'_id': ObjectId(user_id)}, {
                                          '$unset': {'biography': 1}})
                return jsonify({'message': 'Biography deleted successfully'})
            else:
                return jsonify({'error': 'Biography not found for this user'})
        else:
            return jsonify({'error': 'User not found'})
    except Exception as e:
        return jsonify({'error': f'Failed to delete biography: {str(e)}'}), 500

##############
#######################################
# Route to add a language to a user


# Route to add a language to a user
@user_routes.route('/user/addlanguage', methods=['POST'])
def add_language():
    user_id = request.args.get('user_id')
    if user_id:
        user = mongo.db.users.find_one({'_id': ObjectId(user_id)})
        if user:
            language = request.json.get('language')
            if language:
                mongo.db.users.update_one(
                    {'_id': ObjectId(user_id)},
                    {'$push': {'languages': language}}
                )
                return jsonify({'message': 'Language added successfully'}), 201
            else:
                return jsonify({'error': 'Language field is required'}), 400
        else:
            return jsonify({'error': 'User not found'}), 404
    else:
        return jsonify({'error': 'User ID query parameter is required'}), 400

# Route to delete a language from a user


@user_routes.route('/user/language', methods=['DELETE'])
def delete_language():
    user_id = request.args.get('user_id')
    language = request.args.get('language')
    if user_id and language:
        user = mongo.db.users.find_one({'_id': ObjectId(user_id)})
        if user:
            if language in user.get('languages', []):
                mongo.db.users.update_one(
                    {'_id': ObjectId(user_id)},
                    {'$pull': {'languages': language}}
                )
                return jsonify({'message': f'Language "{language}" deleted successfully'}), 200
            else:
                return jsonify({'error': f'Language "{language}" not found for the user'}), 404
        else:
            return jsonify({'error': 'User not found'}), 404
    else:
        return jsonify({'error': 'User ID and language query parameters are required'}), 400


#############################

@user_routes.route('/user/add_proposal', methods=['POST'])
def add_proposal_route():
    user_id = request.args.get('user_id')
    print(user_id)
    print(request.form.get('title'))
    if not user_id:
        return jsonify({'error': 'User ID is required'}), 400

    # Get the data from the request
    title = request.form.get('title')
    description_text = request.form.get('description_text')
    budget = request.form.get('budget')
    timeline = request.form.get('timeline')  # Add timeline field

    # Check if a file is included in the request
    if 'description_image' in request.files:
        file = request.files['description_image']
        if file.filename == '':
            return jsonify({'error': 'No selected file'}), 400

        if '.' not in file.filename or file.filename.rsplit('.', 1)[1].lower() not in ALLOWED_EXTENSIONS:
            return jsonify({'error': 'Invalid file extension'}), 400

        # Create the folder for storing image descriptions if it doesn't exist
        IMAGE_DESCRIPTION_FOLDER = 'path_to_your_image_folder'
        if not os.path.exists(IMAGE_DESCRIPTION_FOLDER):
            os.makedirs(IMAGE_DESCRIPTION_FOLDER)

        filename = secure_filename(file.filename)
        file_path = os.path.join(IMAGE_DESCRIPTION_FOLDER, filename)
        file.save(file_path)

        # Save only the file name instead of the full file path
        file_name_only = filename
    else:
        file_name_only = None

    user = User.find_by_id(user_id)

    if not user:
        return jsonify({'error': 'User not found'}), 404

    user.add_proposal(title, description_text, budget, timeline,
                      file_name_only)  # Add title and timeline
    return jsonify({'message': 'Proposal added successfully'}), 200
