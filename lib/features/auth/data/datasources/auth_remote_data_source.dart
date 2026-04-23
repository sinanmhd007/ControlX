import 'package:controlx/core/error/exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> loginWithEmailAndPassword(String email, String password);
  Future<UserModel> signUpWithEmailAndPassword(String email, String password);
  Future<void> logout();
  Stream<UserModel?> get userStream;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl({required this.firebaseAuth});

  @override
  Future<UserModel> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        return UserModel.fromFirebaseUser(userCredential.user!);
      } else {
        throw AuthException('User not found after login');
      }
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseException(e);
    } catch (_) {
      throw AuthException('Login failed Please try again.');
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        return UserModel.fromFirebaseUser(userCredential.user!);
      }
      throw AuthException('User not created');
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseException(e);
    } catch (_) {
      throw AuthException('Sign up failed Please try again.');
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Stream<UserModel?> get userStream {
    return firebaseAuth.authStateChanges().map((user) {
      if (user != null) {
        return UserModel.fromFirebaseUser(user);
      }
      return null;
    });
  }

  AuthException _handleFirebaseException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return AuthException('No user found for that email.');
      case 'wrong-password':
        return AuthException('Wrong password provided.');
      case 'email-already-in-use':
        return AuthException('The account already exists for that email.');
      case 'weak-password':
        return AuthException('The password provided is too weak.');
      default:
        return AuthException(e.message ?? 'An unknown error occurred.');
    }
  }
}
