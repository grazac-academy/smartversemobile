import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/auth_response_model.dart';
import '../models/user_response_model.dart';

class AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSource(this._apiClient);

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    String? userType,
    String? state,
    String? phoneNumber,
  }) async {
    try {
      await _apiClient.dio.post(ApiEndpoints.register, data: {
        'fullName': fullName,
        'email': email,
        'password': password,
        if (userType != null) 'userType': userType,
        if (state != null) 'state': state,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
      });
    } catch (e) {
      _apiClient.handleError(e);
    }
  }

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.dio.post(ApiEndpoints.login, data: {
        'email': email,
        'password': password,
      });
      final data = response.data['data'] as Map<String, dynamic>;
      return AuthResponseModel.fromJson(data);
    } catch (e) {
      _apiClient.handleError(e);
    }
  }

  Future<UserResponseModel> getProfile() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.userProfile);
      final data = response.data['data'] as Map<String, dynamic>;
      return UserResponseModel.fromJson(data);
    } catch (e) {
      _apiClient.handleError(e);
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      await _apiClient.dio.post(ApiEndpoints.forgotPassword, data: {'email': email});
    } catch (e) {
      _apiClient.handleError(e);
    }
  }

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      await _apiClient.dio.post(ApiEndpoints.resetPassword, data: {
        'email': email,
        'otp': otp,
        'newPassword': newPassword,
      });
    } catch (e) {
      _apiClient.handleError(e);
    }
  }

  Future<void> resendVerification({required String email}) async {
    try {
      await _apiClient.dio.post(ApiEndpoints.resendVerification, data: {'email': email});
    } catch (e) {
      _apiClient.handleError(e);
    }
  }


  Future<void> verifyEmail({required String email, required String otp}) async {
    try {
      await _apiClient.dio.post(ApiEndpoints.verifyEmail, data: {'email': email, 'otp': otp});
    } catch (e) {
      _apiClient.handleError(e);
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _apiClient.dio.delete(ApiEndpoints.deleteAccount);
    } catch (e) {
      _apiClient.handleError(e);
    }
  }

  /// PATCH /api/v1/user/profile — only fullName/phoneNumber are editable;
  /// omit a field to leave it unchanged server-side.
  Future<UserResponseModel> updateProfile({
    String? fullName,
    String? phoneNumber,
  }) async {
    try {
      final response = await _apiClient.dio.patch(ApiEndpoints.userProfile, data: {
        if (fullName != null) 'fullName': fullName,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
      });
      final data = response.data['data'] as Map<String, dynamic>;
      return UserResponseModel.fromJson(data);
    } catch (e) {
      _apiClient.handleError(e);
    }
  }
}