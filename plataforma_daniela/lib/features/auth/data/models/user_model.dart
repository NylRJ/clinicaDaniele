// ARQUIVO: lib/features/auth/data/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({required super.uid, required super.name, required super.email, required super.role});

  // FÁBRICA SIMPLIFICADA
  factory UserModel.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>? ?? {};
    return UserModel(uid: snap.id, name: (data['name'] ?? 'Usuário sem nome').toString(), email: (data['email'] ?? '').toString(), role: (data['role'] ?? 'paciente').toString());
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'role': role};
  }
}
