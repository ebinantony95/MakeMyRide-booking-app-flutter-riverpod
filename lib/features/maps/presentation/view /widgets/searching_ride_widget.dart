import 'package:flutter/material.dart';
import 'package:make_my_ride/core/theme/theme.dart';

class SearchingRideWidget extends StatefulWidget {
  const SearchingRideWidget({super.key});

  @override
  State<SearchingRideWidget> createState() => _SearchingRideWidgetState();
}

class _SearchingRideWidgetState extends State<SearchingRideWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      // Use a constraint instead of a fixed height for better flexibility
      constraints: const BoxConstraints(minHeight: 340),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 160,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Pulsing circles
                    ...List.generate(3, (index) {
                      return AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          final progress = (_controller.value + index / 3) % 1;
                          return Container(
                            width: 150 * progress,
                            height: 150 * progress,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary
                                  .withValues(alpha: 1 - progress),
                            ),
                          );
                        },
                      );
                    }),
                    // Center Icon
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.electric_rickshaw,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Searching for nearest ride...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Connecting you with top-rated drivers",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "A new ride can only be created after this ride is completed.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
