// Main entry point for the APMA application.
// Relates to: injection_container.dart, splash_screen.dart, auth_bloc.dart
import 'package:apma_app/core/constants/app_string.dart';
import 'package:apma_app/core/themes/app_theme.dart';
import 'package:apma_app/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// DI
import 'core/di/injection_container.dart' as di;
import 'features/auth/presentation/bloc/auth_bloc.dart';

/// Initializes the app with required configurations and dependency injection.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize GetIt
  await di.init();

  runApp(const ApmacoApp());
}

//Root widget of the APMA application with BLoC provider setup.
// Relates to: app_theme.dart, auth_bloc.dart, splash_screen.dart
class ApmacoApp extends StatelessWidget {
  const ApmacoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => di.sl<AuthBloc>(),
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
