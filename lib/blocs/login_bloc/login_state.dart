class LoginState {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final bool isVerified;

  LoginState({
    this.isEmailValid,
    this.isPasswordValid,
    this.isSubmitting,
    this.isSuccess,
    this.isFailure,
    this.isVerified,
  });

  bool get isFormValid => isEmailValid && isPasswordValid;

  factory LoginState.initial() {
    return LoginState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false,
        isVerified: false);
  }

  factory LoginState.loading() {
    return LoginState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: true,
        isSuccess: false,
        isFailure: false,
        isVerified: false);
  }

  factory LoginState.failure() {
    return LoginState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: true,
        isVerified: true);
  }

  factory LoginState.success() {
    return LoginState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: false,
        isSuccess: true,
        isFailure: false,
        isVerified: true);
  }

  LoginState update({bool isEmailValid, bool isPasswordValid}) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      isVerified: false,
    );
  }

  LoginState copyWith(
      {bool isEmailValid,
      bool isPasswordValid,
      bool isSubmitting,
      bool isSuccess,
      bool isFailure, bool isVerified}) {
    return LoginState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
