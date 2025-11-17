// Base use case interface following Clean Architecture principles.
// Relates to: login_usecase.dart, auth_repository.dart

import 'package:apma_app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

/// Generic use case interface for business logic operations.
abstract class UseCase<Type, Params> {
  // Executes the use case with given parameters.
  Future<Either<Failure, Type>> call(Params params);
}

// Placeholder for use cases that don't require parameters.
class NoParams {}
