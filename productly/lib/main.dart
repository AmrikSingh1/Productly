import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:productly/core/di/injection_container.dart' as di;
import 'package:productly/core/routes/app_router.dart';
import 'package:productly/core/splash/splash_provider.dart';
import 'package:productly/core/splash/splash_screen.dart';
import 'package:productly/core/theme/app_theme.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style for status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.primary,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  // Initialize dependencies
  await di.init();
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => SplashProvider(),
      child: const ProductlyApp(),
    ),
  );
}

class ProductlyApp extends StatelessWidget {
  const ProductlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final showSplash = context.watch<SplashProvider>().showSplash;
    
    return MaterialApp(
      title: 'Productly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: showSplash 
        ? SplashScreen(
            onComplete: () => context.read<SplashProvider>().hideSplash(),
          )
        : const MainApp(),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Productly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
