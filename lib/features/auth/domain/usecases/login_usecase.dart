// Login use case implementing authentication business logic.
// Relates to: auth_repository.dart, auth_bloc.dart, user.dart, usecase.dart

import 'package:apma_app/core/errors/failures.dart';
import 'package:apma_app/core/usecases/usecase.dart';
import 'package:apma_app/features/auth/domain/entities/user.dart';
import 'package:apma_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

// Use case for handling user login operations.
class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(
      username: params.username,
      password: params.password,
    );
  }
}

// Parameters required for login operation.
class LoginParams extends Equatable {
  final String username;
  final String password;

  const LoginParams({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}
