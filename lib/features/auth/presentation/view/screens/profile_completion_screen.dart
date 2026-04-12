import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:make_my_ride/core/router/app_routes.dart';
import 'package:make_my_ride/core/theme/app_colors.dart';
import 'package:make_my_ride/core/theme/app_text_styles.dart';
import 'package:make_my_ride/core/constants/app_spacing.dart';
import 'package:make_my_ride/features/auth/presentation/providers/auth_provider.dart';
import 'package:make_my_ride/features/auth/presentation/view/widgets/login/hero_session.dart';
import 'package:make_my_ride/shared/widgets/app_button.dart';

class ProfileCompletionScreen extends ConsumerStatefulWidget {
  const ProfileCompletionScreen({super.key});

  @override
  ConsumerState<ProfileCompletionScreen> createState() =>
      _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState
    extends ConsumerState<ProfileCompletionScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

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
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final success =
        await ref.read(authViewModelProvider.notifier).updateProfile(
              name: _nameController.text.trim(),
              email: _emailController.text.trim(),
            );

    if (!mounted) return;

    if (success) {
      context.go(AppRoutes.chooseRole);
      return;
    }

    if (!success) {
      // The view_model sets the error state, listener handles showing the snackbar.
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for errors
    ref.listen(authViewModelProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.error,
          ),
        );
        ref.read(authViewModelProvider.notifier).clearError();
      }
    });

    final isLoading = ref.watch(authViewModelProvider).isLoading;

    return Scaffold(
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Reusing the nice hero graphic from Login
              const LoginHeroSession(),

              Padding(
                padding: AppSpacing.screenPadding,
                child: SlideTransition(
                  position: _slideAnim,
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Text('Complete Profile ✨',
                              style: AppTextStyles.heading),
                          const SizedBox(height: 8),
                          Text(
                            'Just a few details to get you started on your journey.',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Name Field
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Full Name',
                              prefixIcon: Icon(Icons.person_outline_rounded),
                            ),
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Email Field
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email Address',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(
                                      r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) => _onSubmit(),
                          ),

                          const SizedBox(height: 40),

                          AppButton.primary(
                            label: 'Continue',
                            isLoading: isLoading,
                            onPressed: isLoading ? null : _onSubmit,
                            suffixIcon:
                                const Icon(Icons.check_circle_outline_rounded),
                          ),
                          const SizedBox(height: 40),
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
    );
  }
}
