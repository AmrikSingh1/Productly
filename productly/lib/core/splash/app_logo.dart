import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:productly/core/constants/app_constants.dart';
import 'package:productly/core/theme/app_theme.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final Color? iconColor;
  final Color? backgroundColor;
  final bool animate;

  const AppLogo({
    super.key,
    this.size = 120,
    this.iconColor,
    this.backgroundColor,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.onPrimary;
    final fgColor = iconColor ?? theme.colorScheme.primary;
    
    final logoContainer = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(size / 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Shopping bag base
          Animate(
            effects: animate ? [
              ScaleEffect(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1.0, 1.0),
                duration: const Duration(milliseconds: 700),
                curve: Curves.elasticOut,
                delay: const Duration(milliseconds: 200),
              ),
            ] : [],
            child: Icon(
              Icons.shopping_bag_rounded,
              size: size * 0.5,
              color: fgColor,
            ),
          ),
          
          // Product sparkle
          Positioned(
            top: size * 0.22,
            right: size * 0.22,
            child: Animate(
              effects: animate ? [
                FadeEffect(
                  begin: 0,
                  end: 1,
                  delay: const Duration(milliseconds: 500),
                  duration: const Duration(milliseconds: 300),
                ),
                ScaleEffect(
                  begin: const Offset(0.3, 0.3),
                  end: const Offset(1.0, 1.0),
                  delay: const Duration(milliseconds: 500),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.elasticOut,
                ),
              ] : [],
              child: IgnorePointer(
                child: Material(
                  color: Colors.transparent,
                  child: ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        AppColors.secondary,
                        AppColors.tertiary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Icon(
                      Icons.star,
                      color: bgColor,
                      size: size * 0.2,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Shine effect
          if (animate)
          Positioned.fill(
            child: Animate(
              onComplete: (controller) => controller.repeat(),
              effects: [
                ShimmerEffect(
                  delay: const Duration(milliseconds: 800),
                  duration: const Duration(milliseconds: 1800),
                  color: Colors.white.withOpacity(0.2),
                  angle: 45,
                  size: 0.3,
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size / 4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    
    if (!animate) return logoContainer;
    
    return logoContainer.animate()
      .scaleXY(
        begin: 0.85,
        end: 1.0,
        duration: AppConstants.defaultAnimationDuration,
        curve: Curves.easeOut,
      );
  }
} 