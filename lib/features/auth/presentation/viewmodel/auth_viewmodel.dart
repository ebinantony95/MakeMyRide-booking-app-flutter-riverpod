import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:make_my_ride/features/auth/domain/entities/user_entity.dart';
import 'package:make_my_ride/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:make_my_ride/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:make_my_ride/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:make_my_ride/features/auth/domain/usecases/verify_otp_usecase.dart';

// ─── State ────────────────────────────────────────────────────────────────────

class AuthState {
  final bool isLoading;
  final String? verificationId;
  final UserEntity? user;
  final String? errorMessage;
  final bool otpSent;
  final bool isAuthenticated;

  const AuthState({
    this.isLoading = false,
    this.verificationId,
    this.user,
    this.errorMessage,
    this.otpSent = false,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    bool? isLoading,
    String? verificationId,
    UserEntity? user,
    String? errorMessage,
    bool? otpSent,
    bool? isAuthenticated,
    bool clearError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      verificationId: verificationId ?? this.verificationId,
      user: user ?? this.user,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      otpSent: otpSent ?? this.otpSent,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

// ─── ViewModel ────────────────────────────────────────────────────────────────

class AuthViewModel extends StateNotifier<AuthState> {
  final SendOtpUseCase _sendOtpUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final SignOutUseCase _signOutUseCase;

  AuthViewModel({
    required SendOtpUseCase sendOtpUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required SignOutUseCase signOutUseCase,
  })  : _sendOtpUseCase = sendOtpUseCase,
        _verifyOtpUseCase = verifyOtpUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _signOutUseCase = signOutUseCase,
        super(const AuthState());

  // ─── Check session (called from splash) ────────────────────────────────────

  Future<bool> checkCurrentUser() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _getCurrentUserUseCase();
      state = state.copyWith(
        isLoading: false,
        user: user,
        isAuthenticated: user != null,
      );
      return user != null;
    } catch (_) {
      state = state.copyWith(isLoading: false, isAuthenticated: false);
      return false;
    }
  }

  // ─── Send OTP ──────────────────────────────────────────────────────────────

  Future<void> sendOtp(String phoneNumber) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final verificationId = await _sendOtpUseCase(phoneNumber);
      state = state.copyWith(
        isLoading: false,
        verificationId: verificationId,
        otpSent: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  // ─── Verify OTP ────────────────────────────────────────────────────────────

  Future<bool> verifyOtp(String smsCode) async {
    final verificationId = state.verificationId;
    if (verificationId == null) {
      state = state.copyWith(
          errorMessage: 'Session expired. Please resend OTP.');
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _verifyOtpUseCase(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      state = state.copyWith(
        isLoading: false,
        user: user,
        isAuthenticated: true,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }

  // ─── Resend OTP ────────────────────────────────────────────────────────────

  Future<void> resendOtp(String phoneNumber) async {
    state = state.copyWith(otpSent: false, clearError: true);
    await sendOtp(phoneNumber);
  }

  // ─── Sign Out ──────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    await _signOutUseCase();
    state = const AuthState(); // reset to initial
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  void clearError() => state = state.copyWith(clearError: true);
}
