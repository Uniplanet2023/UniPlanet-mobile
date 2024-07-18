// lib/core/usecases/usecase.dart

import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';

/// A contract for a UseCase in the application.
///
/// The [UseCase] class takes in two types: [Type] and [Params].
/// [Type] is the return type of the UseCase, while [Params] is the
/// parameters type needed to execute the UseCase.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// A helper class for UseCases that do not require any parameters.
///
/// It can be used when calling a UseCase with no params like:
/// `useCase(NoParams())`.
class NoParams {}
