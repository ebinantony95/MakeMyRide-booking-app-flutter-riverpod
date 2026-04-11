import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  String? getUserIdOrNull() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  String getUserId() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    return user.uid;
  }
}
