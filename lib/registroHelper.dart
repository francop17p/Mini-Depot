import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      rethrow; // Propagar la excepción
    }
  }

  // Create user with email and password
  Future<User?> createUserWithEmailAndPassword(
    String email,
    String password,
    String name, // nuevo parámetro para el nombre del usuario
  ) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      String userId = userCredential.user!.uid;
      await FirebaseFirestore.instance.collection('Usuarios').doc(userId).set({
        'name': name,
        'email': email,
      });
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      rethrow; // Propagar la excepción
    } catch (e) {
      print(e);
    }
    return null;
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
