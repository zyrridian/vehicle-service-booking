import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/user.dart';

/// Contract bridging the domain layer and the data layer for authentication.
abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
}
