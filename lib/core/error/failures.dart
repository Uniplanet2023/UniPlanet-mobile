// // lib/core/error/failures.dart

// import 'package:equatable/equatable.dart';

// abstract class Failure extends Equatable {
//   @override
//   List<Object?> get props => [];
// }

// // General failures
// class ServerFailure extends Failure {}

// class CacheFailure extends Failure {}


class Failure {
  final String message;
  Failure([this.message = 'An unexpected error occurred,']);
}