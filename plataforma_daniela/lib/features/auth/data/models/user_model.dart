import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({required super.uid, required super.name, required super.email, required super.role});

  factory UserModel.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>? ?? {};
    return UserModel(uid: snap.id, name: data['name'] ?? '', email: data['email'] ?? '', role: data['role'] ?? 'paciente');
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'role': role};
  }
}
