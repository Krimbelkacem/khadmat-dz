import os
from werkzeug.utils import secure_filename
from flask import current_app
from config.config import FILE_UPLOAD_FOLDER, FILE_ALLOWED_EXTENSIONS, IMAGE_DESCRIPTION_FOLDER


def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in FILE_ALLOWED_EXTENSIONS


def upload_file(file):
    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        file_path = os.path.join(current_app.config['UPLOAD_FOLDER'], filename)
        file.save(file_path)
        return filename
    return None


def upload_cv_file(file):
    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        file_path = os.path.join(
            current_app.config['FILE_UPLOAD_FOLDER'], filename)
        file.save(file_path)
        return filename
    return None


def upload_image_description(file):
    return upload_file(file, 'IMAGE_DESCRIPTION_FOLDER')
