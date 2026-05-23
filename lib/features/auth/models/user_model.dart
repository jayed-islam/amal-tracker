class UserModel {
  final String id;
  final String serialId; // New field
  final String name;
  final String email;
  final String? department;
  final String? designation;
  final String district; // New required field
  final String? phone; // New optional field
  final String? photoUrl; // New optional field
  final String? gender; // New optional field
  final String? avatar;
  final String role;
  final bool isActive;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.serialId,
    required this.name,
    required this.email,
    this.department,
    this.designation,
    required this.district,
    this.phone,
    this.photoUrl,
    this.gender,
    this.avatar,
    required this.role,
    required this.isActive,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['_id'] ?? '',
      serialId: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      department: json['department'],
      designation: json['designation'],
      district: json['district'] ?? '',
      phone: json['phone'],
      photoUrl: json['photo_url'],
      gender: json['gender'],
      avatar: json['avatar'],
      role: json['role'] ?? 'user',
      isActive: json['isActive'] ?? true,
      isVerified: json['isVerified'] ?? false,
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'serialId': serialId,
      'name': name,
      'email': email,
      'department': department,
      'designation': designation,
      'district': district,
      'phone': phone,
      'photo_url': photoUrl,
      'gender': gender,
      'avatar': avatar,
      'role': role,
      'isActive': isActive,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }
}
