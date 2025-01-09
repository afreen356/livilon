class UserModel {
  String? userId;
  String? username;
  String? email;
  String? password;

  UserModel({ this.userId,
    required this.username,
   required this.email,
     required this.password});
    
    factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      username: data['username'] ?? 'Not available',
      email: data['email'] ?? 'Not available',
      password: data['password'] ?? 'Not available',
    );
  }
}
  
