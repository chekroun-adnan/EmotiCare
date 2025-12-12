class UserModel {
  const UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.age,
    this.role,
  });

  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final int? age;
  final String? role;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      age: json['age'] as int?,
      role: json['role'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'age': age,
      'role': role,
    };
  }
}
