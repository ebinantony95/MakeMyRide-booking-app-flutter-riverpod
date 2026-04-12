import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:make_my_ride/core/constants/app_spacing.dart';
import 'package:make_my_ride/core/router/app_routes.dart';
import 'package:make_my_ride/core/theme/app_colors.dart';
import 'package:make_my_ride/core/theme/app_text_styles.dart';
import 'package:make_my_ride/features/auth/presentation/providers/auth_provider.dart';
import 'package:make_my_ride/shared/widgets/app_button.dart';

class RoleSelectionScreen extends ConsumerStatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  ConsumerState<RoleSelectionScreen> createState() =>
      _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends ConsumerState<RoleSelectionScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedRole;

  late final AnimationController _animController;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _onContinue() async {
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose how you want to join.')),
      );
      return;
    }

    final success = await ref
        .read(authViewModelProvider.notifier)
        .updateUserRole(_selectedRole!);

    if (!mounted || !success) return;

    if (_selectedRole == 'driver') {
      context.go(AppRoutes.driverDetails);
    } else {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authViewModelProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        ref.read(authViewModelProvider.notifier).clearError();
      }
    });

    final isLoading = ref.watch(authViewModelProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SlideTransition(
          position: _slideAnim,
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Padding(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.badge_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'How do you want\nto join?',
                    style: AppTextStyles.displayMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Choose your role now. We will use this later to open the right portal and features for you.',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 28),
                  _RoleOptionCard(
                    title: 'Join as User',
                    subtitle:
                        'Book rides, manage trips, and explore the rider experience.',
                    icon: Icons.person_outline_rounded,
                    accentColor: AppColors.primary,
                    isSelected: _selectedRole == 'user',
                    onTap: () => setState(() => _selectedRole = 'user'),
                  ),
                  const SizedBox(height: 16),
                  _RoleOptionCard(
                    title: 'Join as Driver',
                    subtitle:
                        'Accept pending rides and manage trips from the driver side later.',
                    icon: Icons.local_taxi_outlined,
                    accentColor: AppColors.info,
                    isSelected: _selectedRole == 'driver',
                    onTap: () => setState(() => _selectedRole = 'driver'),
                  ),
                  const Spacer(),
                  AppButton.primary(
                    label: 'Continue',
                    isLoading: isLoading,
                    onPressed: isLoading ? null : _onContinue,
                    suffixIcon: const Icon(Icons.arrow_forward_rounded),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleOptionCard extends StatelessWidget {
  const _RoleOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color:
                isSelected ? accentColor.withValues(alpha: 0.08) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected ? accentColor : AppColors.border,
              width: isSelected ? 1.8 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: accentColor, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.headingSmall),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? accentColor : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? accentColor : AppColors.border,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
