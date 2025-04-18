import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:productly/core/constants/app_constants.dart';

class AppLoadingWidget extends StatelessWidget {
  final String? message;
  final bool animate;
  final bool useSpinKit;

  const AppLoadingWidget({
    super.key,
    this.message,
    this.animate = true,
    this.useSpinKit = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget content = Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (useSpinKit)
            SpinKitDoubleBounce(
              color: theme.colorScheme.primary,
              size: 50.0,
            )
          else
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: theme.colorScheme.primary,
              ),
            ),
          if (message != null) ...[
            const SizedBox(height: 24),
            Text(
              message!,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );

    if (animate) {
      content = content
          .animate()
          .fadeIn(duration: AppConstants.defaultAnimationDuration);
    }

    return Center(child: content);
  }
} 