import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:make_my_ride/core/router/app_routes.dart';
import 'package:make_my_ride/core/theme/app_colors.dart';
import 'package:make_my_ride/core/theme/app_text_styles.dart';
import 'package:make_my_ride/core/constants/app_spacing.dart';
import 'package:make_my_ride/features/auth/presentation/view/screens/phone_input_field.dart';
import 'package:make_my_ride/features/auth/presentation/view/widgets/login/hero_session.dart';
import 'package:make_my_ride/shared/widgets/app_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  String _countryCode = '+91';

  late AnimationController _animController;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _animController, curve: Curves.easeOutCubic));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    // TODO: wire AuthViewModel → SendOtpUseCase
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _isLoading = false);
        context.push(AppRoutes.otpVerification);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                // ─── Top hero
                const LoginHeroSession(),
                // ─── Form card
                Expanded(
                  child: Padding(
                    padding: AppSpacing.screenPadding.copyWith(top: 0),
                    child: SlideTransition(
                      position: _slideAnim,
                      child: FadeTransition(
                        opacity: _fadeAnim,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 32),
                            Text('Welcome 👋', style: AppTextStyles.heading),
                            const SizedBox(height: 4),
                            Text(
                              'Enter your phone number to continue',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Form(
                              key: _formKey,
                              child: PhoneInputField(
                                controller: _phoneController,
                                countryCode: _countryCode,
                                onCountryChanged: (v) =>
                                    setState(() => _countryCode = v),
                              ),
                            ),
                            const SizedBox(height: 24),
                            AppButton.primary(
                              label: 'Send OTP',
                              isLoading: _isLoading,
                              onPressed: _onContinue,
                              suffixIcon:
                                  const Icon(Icons.arrow_forward_rounded),
                            ),
                            const Spacer(),
                            // ─── Terms

                            Center(
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
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
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
