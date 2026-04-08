import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String phoneNumber;
  final String? name;
  final String? email;
  final String? photoUrl;
  final bool isProfileComplete;
  final DateTime createdAt;

  const UserEntity({
    required this.uid,
    required this.phoneNumber,
    this.name,
    this.email,
    this.photoUrl,
    required this.isProfileComplete,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        uid,
        phoneNumber,
        name,
        email,
        photoUrl,
        isProfileComplete,
        createdAt,
      ];
}
