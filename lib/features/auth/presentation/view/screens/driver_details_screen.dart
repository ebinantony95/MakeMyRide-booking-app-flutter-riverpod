import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:make_my_ride/core/constants/app_spacing.dart';
import 'package:make_my_ride/core/router/app_routes.dart';
import 'package:make_my_ride/core/theme/app_colors.dart';
import 'package:make_my_ride/core/theme/app_text_styles.dart';
import 'package:make_my_ride/features/auth/presentation/providers/auth_provider.dart';
import 'package:make_my_ride/shared/widgets/app_button.dart';

class DriverDetailsScreen extends ConsumerStatefulWidget {
  const DriverDetailsScreen({super.key});

  @override
  ConsumerState<DriverDetailsScreen> createState() =>
      _DriverDetailsScreenState();
}

class _DriverDetailsScreenState extends ConsumerState<DriverDetailsScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _vehicleNumberController = TextEditingController();
  String? _vehicleType;

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
    _vehicleNumberController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _onContinue() async {
    if (!_formKey.currentState!.validate()) return;
    if (_vehicleType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your vehicle type.')),
      );
      return;
    }

    final success =
        await ref.read(authViewModelProvider.notifier).updateDriverDetails(
              vehicleType: _vehicleType!,
              vehicleNumber: _vehicleNumberController.text.trim().toUpperCase(),
            );

    if (!mounted || !success) return;
    context.go(AppRoutes.driverHome);
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
        child: GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: SlideTransition(
            position: _slideAnim,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SingleChildScrollView(
                padding: AppSpacing.screenPadding,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        width: 62,
                        height: 62,
                        decoration: BoxDecoration(
                          color: AppColors.infoLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.local_taxi_outlined,
                          color: AppColors.info,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'Driver Setup',
                        style: AppTextStyles.displayMedium,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Tell us about your vehicle so we can prepare your driver portal.',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'Vehicle Type',
                        style: AppTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _VehicleTypeChip(
                            label: 'Bike',
                            icon: Icons.pedal_bike,
                            isSelected: _vehicleType == 'bike',
                            onTap: () => setState(() => _vehicleType = 'bike'),
                          ),
                          _VehicleTypeChip(
                            label: 'Auto',
                            icon: Icons.electric_rickshaw_outlined,
                            isSelected: _vehicleType == 'auto',
                            onTap: () => setState(() => _vehicleType = 'auto'),
                          ),
                          _VehicleTypeChip(
                            label: 'Car',
                            icon: Icons.directions_car_outlined,
                            isSelected: _vehicleType == 'car',
                            onTap: () => setState(() => _vehicleType = 'car'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      TextFormField(
                        controller: _vehicleNumberController,
                        textCapitalization: TextCapitalization.characters,
                        decoration: const InputDecoration(
                          labelText: 'Vehicle Number',
                          hintText: 'KL 07 AB 1234',
                          prefixIcon: Icon(Icons.confirmation_number_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your vehicle number';
                          }
                          if (value.trim().length < 6) {
                            return 'Please enter a valid vehicle number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.infoLight,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: AppColors.info.withValues(alpha: 0.16),
                          ),
                        ),
                        child: Text(
                          'This will be saved to your profile. Later we can use it to show pending rides only to matching driver types.',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                      AppButton.primary(
                        label: 'Continue to Driver Home',
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
        ),
      ),
    );
  }
}

class _VehicleTypeChip extends StatelessWidget {
  const _VehicleTypeChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 102,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.infoLight : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.info : AppColors.border,
            width: isSelected ? 1.8 : 1.2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.info : AppColors.textPrimary,
              size: 26,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? AppColors.info : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
