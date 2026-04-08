import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:make_my_ride/core/theme/app_colors.dart';
import 'package:make_my_ride/core/theme/app_text_styles.dart';
import 'package:make_my_ride/features/ride/presentation/providers/home_provider.dart';
import 'package:make_my_ride/shared/models/location_model.dart';

class AddressSearchScreen extends ConsumerStatefulWidget {
  const AddressSearchScreen({super.key});

  @override
  ConsumerState<AddressSearchScreen> createState() => _AddressSearchScreenState();
}

class _AddressSearchScreenState extends ConsumerState<AddressSearchScreen> {
  final _searchController = TextEditingController();
  List<LocationPoint> _suggestions = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onSearch(String query) async {
    if (query.isEmpty) {
      setState(() => _suggestions = []);
      return;
    }

    setState(() => _isSearching = true);
    
    // In a real app, this would use the SearchAddressUseCase
    // For now, it's mocked in the repository
    final results = await ref.read(rideRepositoryProvider).searchAddresses(query);
    
    if (mounted) {
      setState(() {
        _suggestions = results;
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Set Destination'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // ─── Search Input ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Enter destination...',
                prefixIcon: const Icon(Icons.location_on, color: AppColors.primary),
                suffixIcon: _searchController.text.isNotEmpty 
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _onSearch('');
                      },
                    )
                  : null,
              ),
              onChanged: _onSearch,
            ),
          ),

          // ─── Suggestions List ────────────────────────────────────────────────
          Expanded(
            child: _isSearching
              ? const Center(child: CircularProgressIndicator())
              : _suggestions.isEmpty && _searchController.text.isNotEmpty
                ? const Center(child: Text('No results found'))
                : ListView.separated(
                    itemCount: _suggestions.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final suggestion = _suggestions[index];
                      return ListTile(
                        leading: const Icon(Icons.place_rounded, color: AppColors.textSecondary),
                        title: Text(suggestion.name ?? 'Unknown Location', style: AppTextStyles.bodyMedium),
                        subtitle: Text(suggestion.address ?? '', style: AppTextStyles.caption),
                        onTap: () {
                          // Return the selected location to the previous screen
                          context.pop(suggestion);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
