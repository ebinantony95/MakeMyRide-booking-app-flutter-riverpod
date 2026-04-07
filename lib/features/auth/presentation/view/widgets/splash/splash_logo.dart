import 'package:flutter/material.dart';
import 'package:make_my_ride/core/constants/app_constants.dart';
import 'package:make_my_ride/core/theme/app_text_styles.dart';

class SplashLogo extends StatelessWidget {
  final Animation<double> fadeAnim;
  final Animation<double> scaleAnim;
  const SplashLogo(
      {super.key, required this.fadeAnim, required this.scaleAnim});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 6,
      child: Center(
        child: FadeTransition(
          opacity: fadeAnim,
          child: ScaleTransition(
            scale: scaleAnim,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo box
                Container(
                  width: 108,
                  height: 108,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.35),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 32,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.directions_car_rounded,
                    color: Colors.white,
                    size: 56,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  AppConstants.appName,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.displayMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your ride, on demand.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subheading.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
