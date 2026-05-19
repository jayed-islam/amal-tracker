// class UserModel {
//   final String id;
//   final String name;
//   final String email;
//   final String role;
//   final String? department;
//   final String? designation;
//   final String? avatar;
//   final bool isActive;
//   final bool isVerified;
//   final DateTime? lastLogin;
//   final DateTime createdAt;

//   const UserModel({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.role,
//     this.department,
//     this.designation,
//     this.avatar,
//     required this.isActive,
//     required this.isVerified,
//     this.lastLogin,
//     required this.createdAt,
//   });

//   bool get isAdmin => role == 'admin';
//   bool get isAdminOrMod => role == 'admin' || role == 'moderator';

//   factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
//         id: json['_id'] ?? json['id'] ?? '',
//         name: json['name'] ?? '',
//         email: json['email'] ?? '',
//         role: json['role'] ?? 'user',
//         department: json['department'],
//         designation: json['designation'],
//         avatar: json['avatar'],
//         isActive: json['isActive'] ?? true,
//         isVerified: json['isVerified'] ?? false,
//         lastLogin: json['lastLogin'] != null ? DateTime.tryParse(json['lastLogin']) : null,
//         createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
//       );

//   Map<String, dynamic> toJson() => {
//         '_id': id,
//         'name': name,
//         'email': email,
//         'role': role,
//         'department': department,
//         'designation': designation,
//         'avatar': avatar,
//         'isActive': isActive,
//         'isVerified': isVerified,
//         'lastLogin': lastLogin?.toIso8601String(),
//         'createdAt': createdAt.toIso8601String(),
//       };

//   UserModel copyWith({
//     String? name,
//     String? department,
//     String? designation,
//     String? avatar,
//   }) =>
//       UserModel(
//         id: id,
//         name: name ?? this.name,
//         email: email,
//         role: role,
//         department: department ?? this.department,
//         designation: designation ?? this.designation,
//         avatar: avatar ?? this.avatar,
//         isActive: isActive,
//         isVerified: isVerified,
//         lastLogin: lastLogin,
//         createdAt: createdAt,
//       );
// }

// class AuthResponse {
//   final String accessToken;
//   final String refreshToken;
//   final UserModel user;

//   AuthResponse({
//     required this.accessToken,
//     required this.refreshToken,
//     required this.user,
//   });

//   factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
//         accessToken: json['accessToken'] ?? '',
//         refreshToken: json['refreshToken'] ?? '',
//         user: UserModel.fromJson(json['user'] ?? {}),
//       );
// }
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
      id: json['_id'] ?? json['id'] ?? '',
      serialId: json['id'] ?? 0,
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
