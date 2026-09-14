import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pocket_ledger_app/features/authentication/data/datasource/auth_remote_datasource.dart';
import 'package:pocket_ledger_app/features/authentication/data/models/app_user_model.dart';

class AuthRemoteDataSourceimpl implements AuthRemoteDataSource {
  static bool _isGoogleInitialized = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<AppUserModel?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user!;
      final model = AppUserModel(
        uid: user.uid,
        email: email,
        name: name,
        createdAt: DateTime.now(),
      );

      //save user information to firebase
      await _firestore.collection('users').doc(user.uid).set(model.toMap());

      return model;
    } catch (e) {
      throw Exception("Account Creation Failed: $e");
    }
  }

  @override
  Future<AppUserModel?> login({required String email, required String password}) async{
    try{
      final UserCredential userCredential =  await _auth.signInWithEmailAndPassword(email: email, password: password);
      final user = userCredential.user;
      if(user == null){
        return null;
      }

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if(!doc.exists) return null;
      return AppUserModel.fromMap(doc.data()!);
    }catch(e){
      throw Exception("Login Failed.. Error is: $e");
    }
  }
  //get Current user
  @override
  Future<AppUserModel?> getCurrentser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return null;
      }
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return null;
      return AppUserModel.fromMap(doc.data()!);
    } catch (e) {
      throw Exception("Some error Occured: $e");
    }
  }

  //logout
  @override
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception("Some error occured: $e");
    }
  }

  //send reset link
  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception("Failed to send Reset Email: $e");
    }
  }

  //initialize the google signin
  Future<void> _initGoogleSignIn() async {
    if (!_isGoogleInitialized) {
      await GoogleSignIn.instance.initialize();
      _isGoogleInitialized = true;
    }
  }

  @override
  Future<AppUserModel?> signInwithGoogle() async {
    UserCredential userCredential;
    try {
      if (kIsWeb) {
        final googleProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        await _initGoogleSignIn();
        final GoogleSignInAccount? user = await GoogleSignIn.instance
            .authenticate();

        if (user == null) {
          throw Exception("Google Sign-In cancelled by user.");
        }

        final googleAuth = user.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );
        userCredential = await _auth.signInWithCredential(credential);
      }
      final user = userCredential.user;
      if (user == null) {
        return null;
      }
      final model = AppUserModel(
        uid: user.uid,
        email: user.email?? '',
        name: user.displayName ?? '',
        createdAt: DateTime.now(),
      );

      //save user information to firebase
      await _firestore.collection('users').doc(user.uid).set(model.toMap());
      return model;
    } catch (e) {
      throw Exception("Google sign-in failed: $e");
    }
  }

  //delete account
  @override
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception("Some error occured");
      }
      await user.delete();
      await logout();
    } catch (e) {
      throw Exception("Some error Occured: $e");
    }
  }
}