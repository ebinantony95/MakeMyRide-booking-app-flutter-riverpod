import 'package:flutter/material.dart';
import 'package:make_my_ride/core/theme/app_colors.dart';
import 'package:make_my_ride/core/theme/app_text_styles.dart';

class OtpLogoTitle extends StatelessWidget {
  const OtpLogoTitle({super.key, required this.maskedPhone});
  final String maskedPhone;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Icon badge
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.lock_outline_rounded,
            color: Colors.white,
            size: 30,
          ),
        ),

        const SizedBox(height: 28),

        // ─── Title
        Text('Verify your\nnumber 🔐', style: AppTextStyles.displayMedium),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            children: [
              const TextSpan(text: 'OTP sent to '),
              TextSpan(
                text: maskedPhone,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
