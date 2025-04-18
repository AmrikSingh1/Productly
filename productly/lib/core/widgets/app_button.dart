import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:productly/core/constants/app_constants.dart';

enum AppButtonType { filled, outlined, text }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final AppButtonType type;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final bool isFullWidth;
  final bool animate;
  final Color? backgroundColor;
  final Color? textColor;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = AppButtonType.filled,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height,
    this.padding,
    this.isFullWidth = false,
    this.animate = true,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget buttonWidget = SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height,
      child: _buildButtonByType(theme),
    );

    if (animate) {
      return buttonWidget
          .animate()
          .fadeIn(duration: AppConstants.defaultAnimationDuration)
          .scale(
            duration: const Duration(milliseconds: 150),
            begin: const Offset(0.97, 0.97),
            end: const Offset(1, 1),
            curve: Curves.easeOut,
          );
    }

    return buttonWidget;
  }

  Widget _buildButtonByType(ThemeData theme) {
    switch (type) {
      case AppButtonType.filled:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            padding: padding,
          ),
          child: _buildButtonContent(theme),
        );
      case AppButtonType.outlined:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor,
            padding: padding,
          ),
          child: _buildButtonContent(theme),
        );
      case AppButtonType.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: textColor,
            padding: padding,
          ),
          child: _buildButtonContent(theme),
        );
    }
  }

  Widget _buildButtonContent(ThemeData theme) {
    if (isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: type == AppButtonType.filled 
              ? theme.colorScheme.onPrimary 
              : theme.colorScheme.primary,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }

    return Text(text);
  }
} 