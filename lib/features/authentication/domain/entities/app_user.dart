class AppUser {
  final String uid;
  final String email;
  final String name;

  AppUser({
    required this.uid, 
    required this.email, 
    required this.name
  });

  // Convert user data to Json
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name
    };
  }

  // Convert Json to user data
  factory AppUser.fromJson(Map<String, dynamic> jsonUser) {
    return AppUser(
      uid: jsonUser['uid'],
      email: jsonUser['email'],
      name: jsonUser['name'],
    );
  }
}
