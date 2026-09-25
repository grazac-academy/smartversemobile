class UserResponseModel {
  final String id;
  final String email;
  final String fullName;
  final String? userType;
  final String? state;
  final String? phoneNumber;
  final bool isEmailVerified;
  final DateTime? createdAt;

  const UserResponseModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.userType,
    this.state,
    this.phoneNumber,
    required this.isEmailVerified,
    this.createdAt,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      userType: json['userType'] as String?,
      state: json['state'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      // Field name isn't confirmed in the Swagger spec yet — tries the
      // common variants and stays null (chip just won't render) if none match.
      createdAt: _parseDate(json['createdAt'] ?? json['created_at'] ?? json['joinedAt']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}