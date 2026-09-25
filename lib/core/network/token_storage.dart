import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage extends ChangeNotifier {
  TokenStorage._();
  static final TokenStorage instance = TokenStorage._();

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _fullNameKey = 'full_name';
  static const _emailKey = 'email';
  static const _isEmailVerifiedKey = 'is_email_verified';

  final _storage = const FlutterSecureStorage();

  String? _accessToken;
  String? _refreshToken;
  String? _fullName;
  String? _email;
  bool _isEmailVerified = false;

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  String? get fullName => _fullName;
  String? get email => _email;
  bool get isEmailVerified => _isEmailVerified;
  bool get isSignedIn => _accessToken != null;

  Future<void> init() async {
    _accessToken = await _storage.read(key: _accessTokenKey);
    _refreshToken = await _storage.read(key: _refreshTokenKey);
    _fullName = await _storage.read(key: _fullNameKey);
    _email = await _storage.read(key: _emailKey);
    _isEmailVerified = (await _storage.read(key: _isEmailVerifiedKey)) == 'true';
  }

  /// Stores the access/refresh tokens returned by login. Login no longer
  /// returns user details, so call [setUserInfo] separately once the
  /// profile has been fetched.
  Future<void> setTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    notifyListeners();
  }

  Future<void> setUserInfo({
    required String fullName,
    required String email,
    required bool isEmailVerified,
  }) async {
    _fullName = fullName;
    _email = email;
    _isEmailVerified = isEmailVerified;
    await _storage.write(key: _fullNameKey, value: fullName);
    await _storage.write(key: _emailKey, value: email);
    await _storage.write(key: _isEmailVerifiedKey, value: isEmailVerified.toString());
    notifyListeners();
  }

  Future<void> clear() async {
    _accessToken = null;
    _refreshToken = null;
    _fullName = null;
    _email = null;
    _isEmailVerified = false;
    await _storage.deleteAll();
    notifyListeners();
  }
}