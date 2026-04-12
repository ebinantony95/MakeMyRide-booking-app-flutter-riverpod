import 'package:flutter/material.dart';
import 'package:make_my_ride/core/theme/app_colors.dart';
import 'package:make_my_ride/core/theme/app_text_styles.dart';

class OtpResendWidget extends StatelessWidget {
  final bool canResend;
  final int resendSeconds;
  final VoidCallback onResend;

  const OtpResendWidget({
    super.key,
    required this.canResend,
    required this.resendSeconds,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: canResend
          ? GestureDetector(
              onTap: onResend,
              child: Text.rich(
                TextSpan(
                  text: "Didn't receive OTP? ",
                  style: AppTextStyles.body
                      .copyWith(color: AppColors.textSecondary),
                  children: [
                    TextSpan(
                      text: 'Resend',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            )
          : Text.rich(
              TextSpan(
                text: 'Resend OTP in ',
                style:
                    AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                children: [
                  TextSpan(
                    text: '0:${resendSeconds.toString().padLeft(2, '0')}',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ),
    );
  }
}
