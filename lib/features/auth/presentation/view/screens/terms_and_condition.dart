import 'package:flutter/material.dart';
import 'package:make_my_ride/core/theme/app_colors.dart';
import 'package:make_my_ride/core/theme/app_text_styles.dart';

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
      ),
      body: Center(
        child: Text.rich(
          TextSpan(
            text: 'By continuing, you agree to our ',
            style: AppTextStyles.caption,
            children: [
              TextSpan(
                text: 'Terms & Privacy Policy',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
