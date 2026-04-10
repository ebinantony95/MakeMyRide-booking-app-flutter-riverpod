import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:make_my_ride/core/theme/app_colors.dart';
import 'package:make_my_ride/core/theme/app_text_styles.dart';

class OtpPinField extends StatelessWidget {
  const OtpPinField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onCompleted,
    this.errorText,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onCompleted;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 6,
      controller: controller,
      animationType: AnimationType.scale,
      keyboardType: TextInputType.number,
      autoFocus: true,
      enableActiveFill: true,
      cursorColor: AppColors.primary,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(14),
        fieldWidth: 50,
        fieldHeight: 56,
        activeFillColor: AppColors.primaryLight,
        inactiveFillColor: AppColors.surfaceVariant,
        selectedFillColor: AppColors.primaryLight,
        activeColor: AppColors.primary,
        inactiveColor: AppColors.border,
        selectedColor: AppColors.primary,
        borderWidth: 1.5,
      ),
      textStyle:
          AppTextStyles.headingSmall.copyWith(color: AppColors.textPrimary),
      animationDuration: const Duration(milliseconds: 200),
      onChanged: onChanged,
      onCompleted: onCompleted,
    );
  }
}
