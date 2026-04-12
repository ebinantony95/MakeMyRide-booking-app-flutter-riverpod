import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:make_my_ride/features/auth/data/models/user_model.dart';

class AuthFirebaseDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthFirebaseDataSource({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  // ─── Send OTP ──────────────────────────────────────────────────────────────

  Future<String> sendOtp(String phoneNumber) async {
    final completer = Completer<String>();
//send otp to the phone number
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval on Android — sign in silently
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (!completer.isCompleted) {
          completer.completeError(_mapAuthException(e));
        }
      },
      //otp sent to the phone number
      codeSent: (String verificationId, int? resendToken) {
        if (!completer.isCompleted) {
          completer.complete(verificationId);
        }
      },
      //otp auto retrieval timeout
      codeAutoRetrievalTimeout: (String verificationId) {
        if (!completer.isCompleted) {
          completer.complete(verificationId);
        }
      },
    );

    return completer.future;
  }

  // ─── Verify OTP ────────────────────────────────────────────────────────────

  Future<UserModel> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    final result = await _auth.signInWithCredential(credential);
    final firebaseUser = result.user!;

    // Upsert user document in Firestore
    final docRef = _firestore.collection('users').doc(firebaseUser.uid);
    final snapshot = await docRef.get();

    //if user is not exists in firestore create new user

    if (!snapshot.exists) {
      final userModel = UserModel.fromFirebaseUser(
        uid: firebaseUser.uid,
        phoneNumber: firebaseUser.phoneNumber ?? '',
      );
      await docRef.set(userModel.toFirestore());
      return userModel;
    }

    return UserModel.fromFirestore(snapshot);
  }

  // ─── Get current user ──────────────────────────────────────────────────────

  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    final snapshot =
        await _firestore.collection('users').doc(firebaseUser.uid).get();
    if (!snapshot.exists) return null;

    return UserModel.fromFirestore(snapshot);
  }

  // ─── Sign out ──────────────────────────────────────────────────────────────

  Future<void> signOut() => _auth.signOut();

  // ─── Update Profile ────────────────────────────────────────────────────────

  Future<UserModel> updateUserProfile({
    required String name,
    required String email,
  }) async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) throw Exception('No user signed in');

    final docRef = _firestore.collection('users').doc(firebaseUser.uid);
    final snapshot = await docRef.get();

    if (!snapshot.exists) throw Exception('User not found in database');

    UserModel currentUser = UserModel.fromFirestore(snapshot);
    UserModel updatedUser = currentUser.copyWith(
      name: name,
      email: email,
      isProfileComplete: true,
    );

    await docRef.update(updatedUser.toFirestore());
    return updatedUser;
  }

  Future<UserModel> updateUserRole(String role) async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) throw Exception('No user signed in');

    final docRef = _firestore.collection('users').doc(firebaseUser.uid);
    final snapshot = await docRef.get();

    if (!snapshot.exists) throw Exception('User not found in database');

    final currentUser = UserModel.fromFirestore(snapshot);
    final updatedUser = currentUser.copyWith(role: role.trim().toLowerCase());

    await docRef.update(updatedUser.toFirestore());
    return updatedUser;
  }

  Future<UserModel> updateDriverDetails({
    required String vehicleType,
    required String vehicleNumber,
  }) async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) throw Exception('No user signed in');

    final docRef = _firestore.collection('users').doc(firebaseUser.uid);
    final snapshot = await docRef.get();

    if (!snapshot.exists) throw Exception('User not found in database');

    final currentUser = UserModel.fromFirestore(snapshot);
    final updatedUser = currentUser.copyWith(
      driverVehicleType: vehicleType,
      driverVehicleNumber: vehicleNumber,
    );

    await docRef.update(updatedUser.toFirestore());
    return updatedUser;
  }

  // ─── Error mapping ─────────────────────────────────────────────────────────

  Exception _mapAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return Exception('Invalid phone number. Please check and try again.');
      case 'too-many-requests':
        return Exception('Too many requests. Please wait before trying again.');
      case 'quota-exceeded':
      case 'billing-not-enabled':
      case 'admin-restricted-operation':
        return Exception(
            'Firebase Billing is not enabled. Please use a "Test Phone Number" configured in the Firebase Console to test login.');
      default:
        return Exception(e.message ?? 'Authentication failed. Try again.');
    }
  }
}
