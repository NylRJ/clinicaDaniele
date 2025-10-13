// ARQUIVO: lib/features/auth/data/datasources/auth_firebase_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthFirebaseDataSource {
  Future<UserModel> signIn({required String email, required String password});
  Future<UserModel> signUp({required String name, required String email, required String password});
  Future<void> signOut();
  Stream<UserModel?> get user;
}

class AuthFirebaseDataSourceImpl implements AuthFirebaseDataSource {
  final firebase.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthFirebaseDataSourceImpl({required this.firebaseAuth, required this.firestore});

  @override
  Stream<UserModel?> get user {
    return firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        return null;
      }
      try {
        final userDoc = await firestore.collection('users').doc(firebaseUser.uid).get();
        if (userDoc.exists) {
          return UserModel.fromSnapshot(userDoc);
        }
        // Se o documento não existir, retorna um modelo de usuário com dados básicos
        return UserModel(
          uid: firebaseUser.uid,
          name: firebaseUser.displayName ?? 'Usuário',
          email: firebaseUser.email ?? '',
          role: 'paciente', // Papel padrão
        );
      } catch (e) {
        // Log the error if needed
        return null;
      }
    });
  }

  @override
  Future<UserModel> signIn({required String email, required String password}) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw ServerException();
      }
      final userDoc = await firestore.collection('users').doc(firebaseUser.uid).get();

      // **** CORREÇÃO APLICADA AQUI ****
      if (!userDoc.exists) {
        // Se o documento não existe, criamos um UserModel com os dados do Firebase Auth.
        // Isso torna o login resiliente, mesmo que o registro no Firestore tenha falhado.
        return UserModel(
          uid: firebaseUser.uid,
          name: firebaseUser.displayName ?? 'Usuário sem nome',
          email: firebaseUser.email!,
          role: 'paciente', // Assume o papel padrão
        );
      }
      return UserModel.fromSnapshot(userDoc);
    } on firebase.FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? 'Authentication failed');
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> signUp({required String name, required String email, required String password}) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw ServerException();
      }

      // Atualiza o displayName no Firebase Auth
      await firebaseUser.updateDisplayName(name);

      final userModel = UserModel(uid: firebaseUser.uid, name: name, email: email, role: 'paciente');
      await firestore.collection('users').doc(firebaseUser.uid).set(userModel.toJson());
      return userModel;
    } on firebase.FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? 'Sign up failed');
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
