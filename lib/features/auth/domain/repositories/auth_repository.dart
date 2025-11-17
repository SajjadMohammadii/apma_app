// Authentication repository contract defining domain-level authentication operations.
// Relates to: auth_repository_impl.dart, login_usecase.dart, user.dart

import 'package:apma_app/core/errors/failures.dart';
import 'package:apma_app/features/auth/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

/// Repository interface for authentication operations.
abstract class AuthRepository {
  /// Authenticates user with username and password.
  Future<Either<Failure, User>> login({
    required String username,
    required String password,
  });

  /// Registers a new user account.
  Future<Either<Failure, User>> register({
    required String username,
    required String password,
    required String email,
  });

  /// Logs out the current user.
  Future<Either<Failure, void>> logout();

  /// Retrieves the currently authenticated user.
  Future<Either<Failure, User>> getCurrentUser();

  /// Checks if a user is currently logged in.
  Future<Either<Failure, bool>> isLoggedIn();
}
