from flask import Flask
from flask_cors import CORS
from flask_jwt_extended import JWTManager
from flask_session import Session
from config.config import FILE_UPLOAD_FOLDER
from config.db import mongo
from bson.objectid import ObjectId
from routes.userRoutes import user_routes
from models.domain import Domain
from models.profession import Profession
from routes.educationRoutes import education_routes
from routes.experienceRoutes import exp_routes
from routes.skillsRoutes import skills_routes
app = Flask(__name__)

# Configuration
app.config['SECRET_KEY'] = 'your_secret_key'
app.config['UPLOAD_FOLDER'] = 'uploads'
app.config['FILE_UPLOAD_FOLDER'] = FILE_UPLOAD_FOLDER
app.config['SESSION_TYPE'] = 'filesystem'

# Initialize Flask extensions
CORS(app)
Session(app)
jwt = JWTManager(app)

# Register blueprints
app.register_blueprint(user_routes)
app.register_blueprint(education_routes)
app.register_blueprint(exp_routes)
app.register_blueprint(skills_routes)

if __name__ == "__main__":
    app.run(debug=True)
