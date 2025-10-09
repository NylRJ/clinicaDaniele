import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({required super.uid, required super.name, required super.email, required super.role});

  factory UserModel.fromSnapshot(DocumentSnapshot snap) {
    final raw = snap.data() as Map<String, dynamic>? ?? {};
    // Some documents are nested under a 'dados' map (console/manual creation).
    final data = (raw['dados'] is Map<String, dynamic>) ? (raw['dados'] as Map<String, dynamic>) : raw;
    return UserModel(
      uid: snap.id,
      name: (data['name'] ?? '').toString(),
      email: (data['email'] ?? '').toString(),
      role: (data['role'] ?? 'paciente').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'role': role};
  }
}
