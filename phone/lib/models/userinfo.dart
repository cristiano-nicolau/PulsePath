class UserInfo{
  final int? id;
  final int? userId;
  final String gender;
  final String age;
  final String weight;
  final String height;

  UserInfo({ this.id, required this.userId, required this.age, required this.gender, required this.height, required this.weight});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'gender': gender,
      'age': age,
      'weight': weight,
      'height': height,
    };
  }
}