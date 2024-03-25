class UserData{
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String password;


  UserData({ this.id, required this.name, required this.email, required this.phone, required this.password});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,

    };
  }
}