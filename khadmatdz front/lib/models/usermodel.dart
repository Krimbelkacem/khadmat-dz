class UserModel {
  final String? username;
  final String? email;
  final String picture; // Make picture non-nullable with a default value

  UserModel({
    required this.username,
    required this.email,
    required this.picture, // Ensure picture is non-nullable in the constructor
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      email: json['email'],
      picture: json['picture'] ?? '../../images/defaultpicture.png', // Provide default value for picture
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'picture': picture,
    };
  }
}
