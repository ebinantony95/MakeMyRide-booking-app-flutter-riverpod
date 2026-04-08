import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:make_my_ride/core/router/app_routes.dart';
import 'package:make_my_ride/core/theme/app_colors.dart';
import 'package:make_my_ride/core/theme/app_text_styles.dart';
import 'package:make_my_ride/core/constants/app_spacing.dart';
import 'package:make_my_ride/features/auth/presentation/providers/auth_provider.dart';
import 'package:make_my_ride/shared/widgets/app_button.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen>
    with SingleTickerProviderStateMixin {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _otpCode = '';

  // ─── Resend timer
  late Timer _timer;
  int _resendSeconds = 60;
  bool _canResend = false;

  // ─── Entry animations
  late AnimationController _animController;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _animController, curve: Curves.easeOutCubic));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();
  }

  @override
  void dispose() {
    _timer.cancel();
    _animController.dispose();
    final otpController = _otpController;
    Future.microtask(() => otpController.dispose());
    super.dispose();
  }

  void _startResendTimer() {
    _resendSeconds = 60;
    _canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        if (_resendSeconds > 0) {
          _resendSeconds--;
        } else {
          _canResend = true;
          t.cancel();
        }
      });
    });
  }

  Future<void> _onVerify() async {
    if (_otpCode.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        _errorSnackBar('Please enter the complete 6-digit OTP.'),
      );
      return;
    }

    final success =
        await ref.read(authViewModelProvider.notifier).verifyOtp(_otpCode);
    if (success && mounted) {
      final user = ref.read(authViewModelProvider).user;
      if (user != null && user.isProfileComplete) {
        context.go(AppRoutes.home);
      } else {
        context.go(AppRoutes.completeProfile);
      }
    }
  }

  Future<void> _onResend() async {
    if (!_canResend) return;
    _timer.cancel();
    _otpController.clear();
    setState(() => _otpCode = '');
    await ref
        .read(authViewModelProvider.notifier)
        .resendOtp(widget.phoneNumber);
    _startResendTimer();
  }

  SnackBar _errorSnackBar(String msg) => SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      );

  String get _maskedPhone {
    final p = widget.phoneNumber;
    if (p.length < 4) return p;
    return '${p.substring(0, p.length - 4)}****';
  }

  @override
  Widget build(BuildContext context) {
    // Listen for errors & success
    ref.listen(authViewModelProvider, (prev, next) {
      if (next.errorMessage != null &&
          next.errorMessage != prev?.errorMessage) {
        ScaffoldMessenger.of(context)
            .showSnackBar(_errorSnackBar(next.errorMessage!));
        ref.read(authViewModelProvider.notifier).clearError();
      }
    });

    final isLoading = ref.watch(authViewModelProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: SlideTransition(
              position: _slideAnim,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

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
                    Text('Verify your\nnumber 🔐',
                        style: AppTextStyles.displayMedium),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        style: AppTextStyles.body
                            .copyWith(color: AppColors.textSecondary),
                        children: [
                          const TextSpan(text: 'OTP sent to '),
                          TextSpan(
                            text: _maskedPhone,
                            style: AppTextStyles.bodyMedium
                                .copyWith(color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 44),

                    // ─── OTP Pin Field
                    Form(
                      key: _formKey,
                      child: PinCodeTextField(
                        appContext: context,
                        length: 6,
                        controller: _otpController,
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
                        textStyle: AppTextStyles.headingSmall
                            .copyWith(color: AppColors.textPrimary),
                        animationDuration:
                            const Duration(milliseconds: 200),
                        onChanged: (value) =>
                            setState(() => _otpCode = value),
                        onCompleted: (value) {
                          setState(() => _otpCode = value);
                          _onVerify();
                        },
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ─── Verify button
                    AppButton.primary(
                      label: 'Verify OTP',
                      isLoading: isLoading,
                      onPressed: isLoading ? null : _onVerify,
                      suffixIcon: const Icon(Icons.verified_outlined),
                    ),

                    const SizedBox(height: 28),

                    // ─── Resend row
                    Center(
                      child: _canResend
                          ? GestureDetector(
                              onTap: _onResend,
                              child: Text.rich(
                                TextSpan(
                                  text: "Didn't receive OTP? ",
                                  style: AppTextStyles.body.copyWith(
                                      color: AppColors.textSecondary),
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
                                style: AppTextStyles.body.copyWith(
                                    color: AppColors.textSecondary),
                                children: [
                                  TextSpan(
                                    text: '0:${_resendSeconds.toString().padLeft(2, '0')}',
                                    style: AppTextStyles.bodyMedium
                                        .copyWith(color: AppColors.primary),
                                  ),
                                ],
                              ),
                            ),
                    ),

                    const SizedBox(height: 40),

                    // ─── Bottom hint card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'The OTP is valid for 10 minutes. Do not share it with anyone.',
                              style: AppTextStyles.caption
                                  .copyWith(color: AppColors.primaryDark),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
