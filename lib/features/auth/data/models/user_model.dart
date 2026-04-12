import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:make_my_ride/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.phoneNumber,
    super.name,
    super.email,
    super.role,
    super.driverVehicleType,
    super.driverVehicleNumber,
    super.photoUrl,
    required super.isProfileComplete,
    required super.createdAt,
  });

  //from firestore to user model
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      phoneNumber: data['phoneNumber'] as String? ?? '',
      name: data['name'] as String?,
      email: data['email'] as String?,
      role: data['role'] as String?,
      driverVehicleType: data['driverVehicleType'] as String?,
      driverVehicleNumber: data['driverVehicleNumber'] as String?,
      photoUrl: data['photoUrl'] as String?,
      isProfileComplete: data['isProfileComplete'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  //from firebase user to user model
  factory UserModel.fromFirebaseUser({
    required String uid,
    required String phoneNumber,
  }) {
    return UserModel(
      uid: uid,
      phoneNumber: phoneNumber,
      isProfileComplete: false,
      createdAt: DateTime.now(),
    );
  }

  //from user model to firestore
  Map<String, dynamic> toFirestore() => {
        'phoneNumber': phoneNumber,
        'name': name,
        'email': email,
        'role': role,
        'driverVehicleType': driverVehicleType,
        'driverVehicleNumber': driverVehicleNumber,
        'photoUrl': photoUrl,
        'isProfileComplete': isProfileComplete,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  UserModel copyWith({
    String? uid,
    String? phoneNumber,
    String? name,
    String? email,
    String? role,
    String? driverVehicleType,
    String? driverVehicleNumber,
    String? photoUrl,
    bool? isProfileComplete,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      driverVehicleType: driverVehicleType ?? this.driverVehicleType,
      driverVehicleNumber: driverVehicleNumber ?? this.driverVehicleNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
