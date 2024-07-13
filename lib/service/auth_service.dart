import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  FirebaseAuthException? errorMessage;
  Uri? image;

  Future<User?> signUp(String email, String password, String username) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.updateDisplayName(username);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      errorMessage = e;
      print('Error during registration: ${e.message}');
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return user;
    } on FirebaseAuthException catch (e) {
      errorMessage = e;
      print('Error during login: ${e.message}');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String?> uploadProfileImage(String uid, File imageFile) async {
    User? user = _auth.currentUser;
    try {
      String imagePath = 'profile_images/${user?.uid}.jpg';
      final Reference storageReference = _storage.ref().child(imagePath);
      await storageReference.putFile(imageFile);
      return await storageReference.getDownloadURL();
    } on FirebaseAuthException catch (e) {
      errorMessage = e;
      print('Error uploading profile image: $e');
      return null;
    }
  }

  Future<String?> getProfileImage(String uid) async {
    User? user = _auth.currentUser;
    try {
      String imagePath = 'profile_images/${user?.uid}.jpg';
      final Reference storageReference = _storage.ref().child(imagePath);
      return await storageReference.getDownloadURL();
    } on FirebaseAuthException catch (e) {
      if (e.code == "404") {
        return null;
      } else {
        errorMessage = e;
        print('Error getting profile image: $e');
      }
      rethrow;
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }
}
