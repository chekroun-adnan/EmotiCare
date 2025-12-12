import '../../data/models/user_model.dart';

class UserEntity {
  const UserEntity({
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

  factory UserEntity.fromModel(UserModel model) => UserEntity(
        id: model.id,
        firstName: model.firstName,
        lastName: model.lastName,
        email: model.email,
        age: model.age,
        role: model.role,
      );
}
