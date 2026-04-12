import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:make_my_ride/features/auth/data/datasource/auth_firebase_datasource.dart';
import 'package:make_my_ride/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:make_my_ride/features/auth/domain/entities/user_entity.dart';
import 'package:make_my_ride/features/auth/domain/repositories/auth_repository.dart';
import 'package:make_my_ride/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:make_my_ride/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:make_my_ride/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:make_my_ride/features/auth/domain/usecases/update_driver_details_usecase.dart';
import 'package:make_my_ride/features/auth/domain/usecases/update_user_role_usecase.dart';
import 'package:make_my_ride/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:make_my_ride/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:make_my_ride/features/auth/presentation/viewmodel/auth_viewmodel.dart';

// ─── Data Layer Providers ─────────────────────────────────────────────────────

final authDataSourceProvider = Provider<AuthFirebaseDataSource>(
  (ref) => AuthFirebaseDataSource(),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.watch(authDataSourceProvider)),
);

// ─── Use Case Providers ───────────────────────────────────────────────────────

final sendOtpUseCaseProvider = Provider<SendOtpUseCase>(
  (ref) => SendOtpUseCase(ref.watch(authRepositoryProvider)),
);

final verifyOtpUseCaseProvider = Provider<VerifyOtpUseCase>(
  (ref) => VerifyOtpUseCase(ref.watch(authRepositoryProvider)),
);

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>(
  (ref) => GetCurrentUserUseCase(ref.watch(authRepositoryProvider)),
);

final signOutUseCaseProvider = Provider<SignOutUseCase>(
  (ref) => SignOutUseCase(ref.watch(authRepositoryProvider)),
);

final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>(
  (ref) => UpdateProfileUseCase(ref.watch(authRepositoryProvider)),
);

final updateUserRoleUseCaseProvider = Provider<UpdateUserRoleUseCase>(
  (ref) => UpdateUserRoleUseCase(ref.watch(authRepositoryProvider)),
);

final updateDriverDetailsUseCaseProvider = Provider<UpdateDriverDetailsUseCase>(
  (ref) => UpdateDriverDetailsUseCase(ref.watch(authRepositoryProvider)),
);

// ─── ViewModel Provider ───────────────────────────────────────────────────────

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>(
  (ref) => AuthViewModel(
    sendOtpUseCase: ref.watch(sendOtpUseCaseProvider),
    verifyOtpUseCase: ref.watch(verifyOtpUseCaseProvider),
    getCurrentUserUseCase: ref.watch(getCurrentUserUseCaseProvider),
    signOutUseCase: ref.watch(signOutUseCaseProvider),
    updateProfileUseCase: ref.watch(updateProfileUseCaseProvider),
    updateUserRoleUseCase: ref.watch(updateUserRoleUseCaseProvider),
    updateDriverDetailsUseCase: ref.watch(updateDriverDetailsUseCaseProvider),
  ),
);

// ─── Auth Check Provider (FutureProvider for splash) ─────────────────────────

/// Returns the currently logged-in [UserEntity] or null.
/// Used by SplashScreen to decide where to redirect.
final authCheckProvider = FutureProvider<UserEntity?>((ref) async {
  final useCase = ref.watch(getCurrentUserUseCaseProvider);
  return useCase();
});
