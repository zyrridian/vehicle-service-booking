<#
.SYNOPSIS
    Scaffolds a clean architecture Flutter project structure.
.DESCRIPTION
    Creates the necessary directory structure and initial boilerplate files
    for a Flutter project following Clean Architecture principles. Supports
    different state management solutions (BLoC, Riverpod, GetX).
.EXAMPLE
    .\flutter-structure.ps1 -StateManagement bloc
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$false, HelpMessage="Select the state management solution")]
    [ValidateSet('bloc', 'riverpod', 'getx')]
    [string]$StateManagement
)

$ErrorActionPreference = 'Stop'

# Initialization & Validation

function Out-Log {
    param([string]$Message, [ConsoleColor]$Color = 'White')
    Write-Host "[*] $Message" -ForegroundColor $Color
}

function Out-Success {
    param([string]$Message)
    Write-Host "[+] $Message" -ForegroundColor Green
}

function Out-Error {
    param([string]$Message)
    Write-Host "[-] $Message" -ForegroundColor Red
}

if (-not (Test-Path "pubspec.yaml")) {
    Out-Error "pubspec.yaml not found. Please run this script from the root of a Flutter project."
    exit 1
}

if ([string]::IsNullOrWhiteSpace($StateManagement)) {
    Out-Log "Please select your preferred state management:" 'Cyan'
    Out-Log "1) BLoC"
    Out-Log "2) Riverpod"
    Out-Log "3) GetX"
    
    $choice = Read-Host "Enter choice (1-3)"
    switch ($choice) {
        '1' { $StateManagement = 'bloc' }
        '2' { $StateManagement = 'riverpod' }
        '3' { $StateManagement = 'getx' }
        default {
            Out-Error "Invalid choice. Aborting."
            exit 1
        }
    }
}

Out-Log "Initializing project scaffolding with $StateManagement..." 'Cyan'

# Directory Structure Definition

$directories = @(
    'lib/app',
    'lib/core/config',
    'lib/core/constants',
    'lib/core/di',
    'lib/core/errors',
    'lib/core/extensions',
    'lib/core/localization/l10n',
    'lib/core/network',
    'lib/core/routing',
    'lib/core/services',
    'lib/core/theme',
    'lib/core/utils',
    'lib/data/datasources/local',
    'lib/data/datasources/remote',
    'lib/data/models',
    'lib/data/repositories',
    'lib/domain/entities',
    'lib/domain/repositories',
    'lib/domain/usecases',
    'lib/presentation/shared/components',
    'lib/presentation/shared/dialogs',
    'lib/presentation/shared/widgets',
    'lib/presentation/auth/pages',
    'lib/presentation/auth/widgets',
    'assets/fonts',
    'assets/icons',
    'assets/images',
    'assets/animations'
)

switch ($StateManagement) {
    'bloc' {
        $directories += 'lib/presentation/auth/bloc'
    }
    'riverpod' {
        $directories += 'lib/presentation/auth/providers'
    }
    'getx' {
        $directories += 'lib/presentation/auth/bindings'
        $directories += 'lib/presentation/auth/controllers'
    }
}

# Directory Creation

foreach ($dir in $directories) {
    $normalizedPath = $dir -replace '/', [System.IO.Path]::DirectorySeparatorChar
    if (-not (Test-Path $normalizedPath)) {
        New-Item -ItemType Directory -Path $normalizedPath -Force | Out-Null
    }
}

Out-Success "Directories established."

# Boilerplate Generation

$templates = @{}

$templates['lib/main.dart'] = @'
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/app.dart';
import 'core/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize dependency injection
  await di.init();

  runApp(const MainApp());
}
'@

$templates['lib/app/app.dart'] = @'
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_constants.dart';
import '../presentation/auth/pages/login_page.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const LoginPage(),
    );
  }
}
'@

$templates['lib/core/config/app_config.dart'] = @'
/// Environment configuration wrapper.
/// Use this class to manage varying environmental configurations (e.g., dev, staging, prod).
abstract class AppConfig {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://api.default-env.com',
  );

  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
}
'@

$templates['lib/core/constants/app_constants.dart'] = @'
/// Global constants utilized throughout the application.
abstract class AppConstants {
  static const String appName = 'My Application';
  static const String defaultFontFamily = 'Roboto';
  
  // Storage Keys
  static const String keyToken = 'auth_token';
  static const String keyThemeMode = 'theme_mode';
}
'@

$templates['lib/core/di/injection_container.dart'] = @'
/// Service Locator setup utilizing `get_it` or a similar DI framework.
/// 
/// Ensure to register dependencies starting from external layers down to the presentation layer.
Future<void> init() async {
  // Core
  
  // External / Services
  
  // Data Sources
  
  // Repositories
  
  // Use Cases
  
  // Blocs / Controllers / Providers
}
'@

$templates['lib/core/errors/failures.dart'] = @'
import 'package:equatable/equatable.dart';

/// Base class for handling domain-level failures across the application.
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection available.'});
}
'@

$templates['lib/core/errors/exceptions.dart'] = @'
/// Exception thrown when a server-related issue occurs.
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({required this.message, this.statusCode});
  
  @override
  String toString() => 'ServerException: $message (StatusCode: $statusCode)';
}

/// Exception thrown when local data caching fails.
class CacheException implements Exception {
  final String message;
  const CacheException(this.message);
}

/// Exception thrown when network connectivity is absent.
class NetworkException implements Exception {}
'@

$templates['lib/core/extensions/context_extension.dart'] = @'
import 'package:flutter/material.dart';

/// Convenient extensions on [BuildContext] to simplify boilerplate retrieval.
extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  
  Size get mediaQuerySize => MediaQuery.sizeOf(this);
  EdgeInsets get mediaQueryPadding => MediaQuery.paddingOf(this);
  
  void showSnackBar(String message) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
'@

$templates['lib/core/localization/l10n/app_en.arb'] = @'
{
  "@@locale": "en",
  "appTitle": "My Application",
  "@appTitle": {
    "description": "The title of the application"
  },
  "loginButton": "Sign In",
  "@loginButton": {
    "description": "Text displayed on the login button"
  }
}
'@

$templates['lib/core/network/api_endpoints.dart'] = @'
/// Defines all remote endpoints to prevent hardcoded strings throughout the data layer.
abstract class ApiEndpoints {
  static const String authLogin = '/v1/auth/login';
  static const String authRegister = '/v1/auth/register';
  static const String userProfile = '/v1/user/profile';
}
'@

$templates['lib/core/network/network_client.dart'] = @'
/// Contract for network operations, allowing for abstracting away the underlying HTTP client (e.g. Dio, http).
abstract class NetworkClient {
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters});
  Future<dynamic> post(String path, {dynamic data, Map<String, dynamic>? queryParameters});
  Future<dynamic> put(String path, {dynamic data, Map<String, dynamic>? queryParameters});
  Future<dynamic> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters});
}
'@

$templates['lib/core/routing/app_router.dart'] = @'
import 'package:flutter/material.dart';
import '../../presentation/auth/pages/login_page.dart';

/// Centralized application routing. 
/// Consider using `go_router` or `auto_route` for more complex navigation graphs.
class AppRouter {
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
'@

$templates['lib/core/services/storage_service.dart'] = @'
/// Contract for local storage operations.
abstract class StorageService {
  Future<void> init();
  Future<void> write(String key, dynamic value);
  Future<dynamic> read(String key);
  Future<void> delete(String key);
  Future<void> clearAll();
}
'@

$templates['lib/core/theme/app_theme.dart'] = @'
import 'package:flutter/material.dart';

/// Centralized theme definition.
abstract class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.blueAccent,
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.blueAccent,
      brightness: Brightness.dark,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
    );
  }
}
'@

$templates['lib/core/utils/logger.dart'] = @'
import 'package:flutter/foundation.dart';

/// Custom wrapper for unified logging. 
/// Consolidates debug printing to avoid polluting production builds.
abstract class AppLogger {
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('[DEBUG] $message');
      if (error != null) debugPrint('Error: $error');
      if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
    }
  }

  static void info(String message) {
    if (kDebugMode) {
      debugPrint('[INFO] $message');
    }
  }
  
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    debugPrint('[ERROR] $message');
    if (error != null) debugPrint('Error Details: $error');
    if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
  }
}
'@

$templates['lib/data/datasources/remote/auth_remote_datasource.dart'] = @'
import '../../models/user_model.dart';

/// Defines the remote operations necessary for authentication.
abstract class AuthRemoteDataSource {
  /// Authenticates a user and returns their profile representation.
  /// Throws a [ServerException] for all error codes.
  Future<UserModel> login({required String email, required String password});
}
'@

$templates['lib/data/models/user_model.dart'] = @'
import '../../domain/entities/user.dart';

/// Data transfer object for the [User] entity.
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.fullName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
    };
  }
}
'@

$templates['lib/data/repositories/auth_repository_impl.dart'] = @'
import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';

/// Concrete implementation of [AuthRepository] orchestrating data flow.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final userModel = await remoteDataSource.login(email: email, password: password);
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode?.toString()));
    } on NetworkException {
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
'@

$templates['lib/domain/entities/user.dart'] = @'
import 'package:equatable/equatable.dart';

/// Domain entity representing an authenticated user.
class User extends Equatable {
  final String id;
  final String email;
  final String fullName;

  const User({
    required this.id,
    required this.email,
    required this.fullName,
  });

  @override
  List<Object?> get props => [id, email, fullName];
}
'@

$templates['lib/domain/repositories/auth_repository.dart'] = @'
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/user.dart';

/// Contract bridging the domain layer and the data layer for authentication.
abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
}
'@

$templates['lib/domain/usecases/login_usecase.dart'] = @'
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Encapsulates the core business logic for user authentication.
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, User>> call(LoginParams params) {
    return repository.login(params.email, params.password);
  }
}

class LoginParams {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});
}
'@

$templates['lib/presentation/shared/components/primary_button.dart'] = @'
import 'package:flutter/material.dart';

/// A standardized primary action button for the application.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
'@

$templates['lib/presentation/auth/pages/login_page.dart'] = @'
import 'package:flutter/material.dart';
import '../../shared/components/primary_button.dart';

/// The entry point for user authentication.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    // TODO: Dispatch login event to state management
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome Back',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'Sign In',
                onPressed: _handleLogin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
'@

if ($StateManagement -eq 'bloc') {
    $templates['lib/presentation/auth/bloc/auth_bloc.dart'] = @'
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/usecases/login_usecase.dart';
import '../../../domain/entities/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// Manages authentication state transitions using the BLoC pattern.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc({required this.loginUseCase}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  void _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthInitial());
  }
}
'@

    $templates['lib/presentation/auth/bloc/auth_event.dart'] = @'
part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class LogoutRequested extends AuthEvent {}
'@

    $templates['lib/presentation/auth/bloc/auth_state.dart'] = @'
part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;

  const AuthSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object> get props => [message];
}
'@

} elseif ($StateManagement -eq 'riverpod') {
    $templates['lib/presentation/auth/providers/auth_provider.dart'] = @'
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/user.dart';

/// Riverpod state manager for authentication flows.
final authStateProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  AuthNotifier() : super(const AsyncData(null));

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    // Simulate API delay or utilize UseCase from DI
    await Future.delayed(const Duration(seconds: 1));
    
    // Example success:
    final mockUser = User(id: '1', email: email, fullName: 'Test User');
    state = AsyncData(mockUser);
  }
  
  void logout() {
    state = const AsyncData(null);
  }
}
'@
} elseif ($StateManagement -eq 'getx') {
    $templates['lib/presentation/auth/controllers/auth_controller.dart'] = @'
import 'package:get/get.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/login_usecase.dart';

/// GetX Controller bridging the UI and authentication business logic.
class AuthController extends GetxController {
  final LoginUseCase loginUseCase;
  
  AuthController({required this.loginUseCase});

  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';
    
    final result = await loginUseCase(
      LoginParams(email: email, password: password),
    );

    result.fold(
      (failure) => errorMessage.value = failure.message,
      (user) => currentUser.value = user,
    );
    
    isLoading.value = false;
  }
  
  void logout() {
    currentUser.value = null;
  }
}
'@
    $templates['lib/presentation/auth/bindings/auth_binding.dart'] = @'
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

/// Binds the AuthController to the dependency lifecycle.
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Ideally retrieve the UseCase from your service locator, e.g., get_it
    // final loginUseCase = sl<LoginUseCase>();
    // Get.lazyPut(() => AuthController(loginUseCase: loginUseCase));
  }
}
'@
}

foreach ($key in $templates.Keys) {
    $normalizedPath = $key -replace '/', [System.IO.Path]::DirectorySeparatorChar
    if (-not (Test-Path $normalizedPath)) {
        $templates[$key] | Set-Content -Path $normalizedPath -Encoding UTF8
        Out-Log "Created $normalizedPath" 'DarkGray'
    } else {
        Out-Log "Skipped $normalizedPath (already exists)" 'DarkYellow'
    }
}

Out-Success "Boilerplate scaffolding completed successfully."