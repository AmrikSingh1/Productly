import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:productly/core/constants/app_constants.dart';
import 'package:productly/core/widgets/app_button.dart';

class AppErrorWidget extends StatelessWidget {
  final String? message;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final bool animate;

  const AppErrorWidget({
    super.key,
    this.message,
    this.actionText,
    this.onActionPressed,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget content = Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 64,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            message ?? 'Something went wrong',
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          if (actionText != null && onActionPressed != null) ...[
            const SizedBox(height: 24),
            AppButton(
              text: actionText!,
              onPressed: onActionPressed!,
              animate: false,
            ),
          ],
        ],
      ),
    );

    if (animate) {
      content = content
          .animate()
          .fadeIn(duration: AppConstants.defaultAnimationDuration)
          .slideY(
            begin: 0.1,
            end: 0,
            curve: Curves.easeOut,
            duration: AppConstants.defaultAnimationDuration,
          );
    }

    return Center(child: content);
  }
} 