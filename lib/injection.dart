import 'data/datasources/local/auth_local_datasource.dart';
import 'data/datasources/remote/auth_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/verify_otp_usecase.dart';
import 'presentation/auth/bloc/auth_bloc.dart';

class Injection {
  static AuthBloc provideAuthBloc() {
    final remoteDataSource = AuthRemoteDataSourceImpl();
    final localDataSource = AuthLocalDataSourceImpl();
    final repository = AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
    return AuthBloc(
      loginUseCase: LoginUseCase(repository),
      verifyOtpUseCase: VerifyOtpUseCase(repository),
    );
  }
}
