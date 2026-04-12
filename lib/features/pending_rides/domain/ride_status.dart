abstract final class RideStatusValues {
  static const String pending = 'pending';
  static const String accepted = 'accepted';
  static const String completed = 'completed';
  static const String cancelled = 'cancelled';

  static const List<String> active = [
    pending,
    accepted,
  ];

  static bool isActive(String? status) {
    return active.contains(status);
  }
}
