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
      codeSent: (String verificationId, int? resendToken) {
        if (!completer.isCompleted) {
          completer.complete(verificationId);
        }
      },
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

  // ─── Error mapping ─────────────────────────────────────────────────────────

  Exception _mapAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return Exception('Invalid phone number. Please check and try again.');
      case 'too-many-requests':
        return Exception('Too many requests. Please wait before trying again.');
      case 'quota-exceeded':
        return Exception('SMS quota exceeded. Try again later.');
      default:
        return Exception(e.message ?? 'Authentication failed. Try again.');
    }
  }
}
