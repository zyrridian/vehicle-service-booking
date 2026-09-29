import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'presentation/onboarding/pages/onboarding_page.dart';
import 'presentation/auth/pages/login_page.dart';
import 'presentation/main_layout/pages/main_layout_page.dart';
import 'presentation/account/pages/simple_data_diri_page.dart';

import 'dart:convert';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_network_debugger/flutter_network_debugger.dart';
import 'data/models/user_model.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final prefs = await SharedPreferences.getInstance();
  final bool hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;
  
  final String? sessionString = prefs.getString('auth_session');
  UserModel? cachedUser;
  if (sessionString != null) {
    try {
      cachedUser = UserModel.fromJson(jsonDecode(sessionString));
    } catch (_) {}
  }

  runApp(MyApp(
    hasSeenOnboarding: hasSeenOnboarding,
    cachedUser: cachedUser,
  ));
}

class MyApp extends StatefulWidget {
  final bool hasSeenOnboarding;
  final UserModel? cachedUser;

  const MyApp({super.key, required this.hasSeenOnboarding, this.cachedUser});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      FlutterNativeSplash.remove();
    });
  }

  Widget _getInitialPage() {
    if (widget.cachedUser != null) {
      if (widget.cachedUser!.isNewUser) {
        return SimpleDataDiriPage(user: widget.cachedUser!);
      } else {
        return const MainLayoutPage();
      }
    } else {
      return widget.hasSeenOnboarding ? const LoginPage() : const OnboardingPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Servisin Aja',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      navigatorKey: navigatorKey,
      builder: (context, child) {
        return FlutterNetworkDebugger(
          navigatorKey: navigatorKey,
          isDebug: kDebugMode,
          child: child!,
        );
      },
      home: _getInitialPage(),
    );
  }
}
