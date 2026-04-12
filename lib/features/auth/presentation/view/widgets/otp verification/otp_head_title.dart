import 'package:flutter/material.dart';
import 'package:make_my_ride/core/theme/app_colors.dart';
import 'package:make_my_ride/core/theme/app_text_styles.dart';

class OtpHeadTitle extends StatelessWidget {
  const OtpHeadTitle({super.key});

  String? get _maskedPhone => null;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Verify your\nnumber 🔐', style: AppTextStyles.displayMedium),
        SizedBox(height: 10),
        RichText(
          text: TextSpan(
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            children: [
              const TextSpan(text: 'OTP sent to '),
              TextSpan(
                text: _maskedPhone,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
        )
      ],
    );
  }
}
