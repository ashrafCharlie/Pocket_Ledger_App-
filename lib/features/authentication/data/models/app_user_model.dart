import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pocket_ledger_app/features/authentication/domain/entities/app_user_entity.dart';

class AppUserModel extends AppUser {
  const AppUserModel({
    required super.uid,
    required super.email,
    required super.name,
    required super.createdAt,
  });

  //from Map  to appUser
  factory AppUserModel.fromMap(Map<String, dynamic> data) {
    return AppUserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  //Appuser to Map
  Map<String, dynamic> toMap() {
    return {
      'uid' : uid,
      'name' : name,
      'email' : email,
      'createdAt' : createdAt,
    };
  }
}