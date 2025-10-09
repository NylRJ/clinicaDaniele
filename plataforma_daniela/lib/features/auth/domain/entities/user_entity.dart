import 'package:equatable/equatable.dart';

/// Representa o objeto de negócio 'Usuário' na camada de domínio.
/// Esta é uma classe pura, sem dependências de fontes de dados externas.
class UserEntity extends Equatable {
  final String uid; // ID único vindo do Firebase Auth
  final String name; // Nome completo do usuário
  final String email; // Email do usuário
  final String role; // Papel do usuário (ex: 'paciente', 'terapeuta')

  const UserEntity({required this.uid, required this.name, required this.email, required this.role});

  /// A lista de propriedades que o `equatable` usará para comparar
  /// duas instâncias de UserEntity.
  @override
  List<Object?> get props => [uid, name, email, role];
}
