import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:productly/core/constants/app_constants.dart';
import 'package:productly/core/splash/app_logo.dart';
import 'package:productly/core/theme/app_theme.dart';

class SplashScreen extends StatelessWidget {
  final VoidCallback onComplete;

  const SplashScreen({
    super.key,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    // Trigger the completion callback after animations
    Future.delayed(const Duration(milliseconds: 2500), onComplete);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              
              // Logo
              Animate(
                effects: [
                  FadeEffect(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOut,
                  ),
                  MoveEffect(
                    begin: const Offset(0, 30),
                    end: const Offset(0, 0),
                    curve: Curves.easeOutQuad,
                    duration: const Duration(milliseconds: 800),
                  ),
                ],
                child: const AppLogo(size: 120),
              ),
                
              const SizedBox(height: 40),
              
              // App name
              Animate(
                effects: [
                  FadeEffect(
                    begin: 0,
                    end: 1,
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 400),
                  ),
                  MoveEffect(
                    begin: const Offset(0, 20),
                    end: const Offset(0, 0),
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 400),
                    curve: Curves.easeOutQuad,
                  ),
                ],
                child: Text(
                  AppConstants.appName.toUpperCase(),
                  style: AppTextStyles.displaySmall.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
              ),
              
              // Tagline
              Animate(
                effects: [
                  FadeEffect(
                    begin: 0,
                    end: 1,
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 600),
                  ),
                ],
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    AppConstants.appTagline,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.onPrimary.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              
              const Spacer(flex: 3),
              
              // Loading indicator
              Animate(
                effects: [
                  FadeEffect(
                    begin: 0,
                    end: 1,
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 800),
                  ),
                ],
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.onPrimary),
                    strokeWidth: 3,
                  ),
                ),
              ),
              
              const Spacer(),
              
              // Version info
              Animate(
                effects: [
                  FadeEffect(
                    begin: 0,
                    end: 1,
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 1000),
                  ),
                ],
                child: Text(
                  'Version ${AppConstants.appVersion}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.onPrimary.withOpacity(0.6),
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
} 