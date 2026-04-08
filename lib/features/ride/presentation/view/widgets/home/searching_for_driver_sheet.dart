import 'package:flutter/material.dart';
import 'package:make_my_ride/core/theme/app_colors.dart';
import 'package:make_my_ride/core/theme/app_text_styles.dart';

class SearchingForDriverSheet extends StatefulWidget {
  final VoidCallback onCancel;

  const SearchingForDriverSheet({super.key, required this.onCancel});

  @override
  State<SearchingForDriverSheet> createState() =>
      _SearchingForDriverSheetState();
}

class _SearchingForDriverSheetState extends State<SearchingForDriverSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ─── Radar Animation Placeholder
          Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    width: 100 + (_pulseController.value * 40),
                    height: 100 + (_pulseController.value * 40),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary
                          .withValues(alpha: 0.3 * (1 - _pulseController.value)),
                    ),
                  );
                },
              ),
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.search_rounded,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // ─── Text
          Text(
            'Finding your driver...',
            style: AppTextStyles.heading,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'This usually takes about a minute.',
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // ─── Cancel Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error, width: 1.5),
              ),
              onPressed: widget.onCancel,
              child: const Text('Cancel Request'),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
