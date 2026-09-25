class ApiEndpoints {
  ApiEndpoints._();

  static const register = '/auth/register';
  static const login = '/auth/login';
  static const forgotPassword = '/auth/forgot-password';
  static const resetPassword = '/auth/reset-password';
  static const resendVerification = '/auth/resend-verification';
  static const verifyEmail = '/auth/verify-email';
  static const userProfile = '/user/profile';
  static const deleteAccount = '/user/delete';
}