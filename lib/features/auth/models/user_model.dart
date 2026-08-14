class UserModel {
  final String id;
  final String name;
  final String email;
  final String? department;
  final String? designation;
  final String district;
  final String? phone;
  final String? photoUrl;
  final String? gender;
  final String? avatar;
  final String role;
  final bool isActive;
  final bool isVerified;
  final bool isEmailVerified;
  final LeaderboardPrivacy? leaderboardPrivacy;
  final LeaderboardOptOut? leaderboardOptOut;
  final ShareProfile? shareProfile;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.department,
    this.designation,
    required this.district,
    this.phone,
    this.photoUrl,
    this.gender,
    this.avatar,
    this.leaderboardPrivacy,
    this.leaderboardOptOut,
    this.shareProfile,
    required this.role,
    required this.isActive,
    required this.isVerified,
    this.isEmailVerified = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    print('fromJson - id from json: ${json['id']}');
    print('fromJson - _id from json: ${json['_id']}');

    final emailVerified =
        json['isEmailVerified'] ?? json['isVerified'] ?? false;

    return UserModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
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
      isVerified: emailVerified,
      isEmailVerified: emailVerified,
      leaderboardPrivacy: json['leaderboardPrivacy'] != null
          ? LeaderboardPrivacy.fromJson(json['leaderboardPrivacy'])
          : null,
      leaderboardOptOut: json['leaderboardOptOut'] != null
          ? LeaderboardOptOut.fromJson(json['leaderboardOptOut'])
          : null,
      shareProfile: json['shareProfile'] != null
          ? ShareProfile.fromJson(json['shareProfile'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // ← শুধু id ফিল্ড সেভ করুন
      'name': name,
      'email': email,
      'department': department,
      'designation': designation,
      'district': district,
      'phone': phone,
      'photo_url': photoUrl,
      if (leaderboardPrivacy != null)
        'leaderboardPrivacy': leaderboardPrivacy!.toJson(),
      if (leaderboardOptOut != null)
        'leaderboardOptOut': leaderboardOptOut!.toJson(),
      if (shareProfile != null) 'shareProfile': shareProfile!.toJson(),
      'gender': gender,
      'avatar': avatar,
      'role': role,
      'isActive': isActive,
      'isVerified': isVerified,
      'isEmailVerified': isEmailVerified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? department,
    String? designation,
    String? district,
    String? phone,
    String? photoUrl,
    String? gender,
    String? avatar,
    String? role,
    bool? isActive,
    bool? isVerified,
    bool? isEmailVerified,
    LeaderboardPrivacy? leaderboardPrivacy,
    LeaderboardOptOut? leaderboardOptOut,
    ShareProfile? shareProfile,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      department: department ?? this.department,
      designation: designation ?? this.designation,
      district: district ?? this.district,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      gender: gender ?? this.gender,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? (isEmailVerified ?? this.isEmailVerified),
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      leaderboardPrivacy: leaderboardPrivacy ?? this.leaderboardPrivacy,
      leaderboardOptOut: leaderboardOptOut ?? this.leaderboardOptOut,
      shareProfile: shareProfile ?? this.shareProfile,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
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

class LeaderboardPrivacy {
  final bool isHidden;
  final bool showAnonymous;

  const LeaderboardPrivacy({
    this.isHidden = false,
    this.showAnonymous = false,
  });

  factory LeaderboardPrivacy.fromJson(Map<String, dynamic> json) =>
      LeaderboardPrivacy(
        isHidden: json['isHidden'] ?? false,
        showAnonymous: json['showAnonymous'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'isHidden': isHidden,
        'showAnonymous': showAnonymous,
      };
}

class LeaderboardOptOut {
  final bool isPermanent;
  const LeaderboardOptOut({this.isPermanent = false});

  factory LeaderboardOptOut.fromJson(Map<String, dynamic> json) =>
      LeaderboardOptOut(isPermanent: json['isPermanent'] ?? false);

  Map<String, dynamic> toJson() => {'isPermanent': isPermanent};
}

class ShareProfile {
  final bool isPublic;
  const ShareProfile({this.isPublic = false});

  factory ShareProfile.fromJson(Map<String, dynamic> json) =>
      ShareProfile(isPublic: json['isPublic'] ?? false);

  Map<String, dynamic> toJson() => {'isPublic': isPublic};
}
