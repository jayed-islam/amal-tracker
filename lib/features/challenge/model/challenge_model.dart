// ─────────────────────────────────────────────────────────────────────────
// CHALLENGE MODELS — backend এর Challenge / ChallengeParticipant response
// shape এর সাথে হুবহু মিলিয়ে বানানো। null-safety সহ, সব parsing defensive
// (backend কোনো optional field না পাঠালেও crash না করে)।
// ─────────────────────────────────────────────────────────────────────────

int _asInt(dynamic v, [int fallback = 0]) {
  if (v == null) return fallback;
  if (v is int) return v;
  if (v is double) return v.round();
  return int.tryParse(v.toString()) ?? fallback;
}

int? _asIntOrNull(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is double) return v.round();
  return int.tryParse(v.toString());
}

DateTime? _asDateOrNull(dynamic v) {
  if (v == null) return null;
  return DateTime.tryParse(v.toString());
}

String _idOf(dynamic v) {
  if (v == null) return '';
  if (v is Map) return (v['_id'] ?? v['id'] ?? '').toString();
  return v.toString();
}

// ─── ChallengeProgress — nested myProgress অংশ ───────────────────────────

class ChallengeProgress {
  final int currentValue;
  final int? currentSurahNumber;
  final int? currentAyahInSurah;
  final bool isCompleted;
  final DateTime? completedAt;
  final int progressPercent;

  const ChallengeProgress({
    required this.currentValue,
    this.currentSurahNumber,
    this.currentAyahInSurah,
    required this.isCompleted,
    this.completedAt,
    required this.progressPercent,
  });

  factory ChallengeProgress.fromJson(Map<String, dynamic> json) =>
      ChallengeProgress(
        currentValue: _asInt(json['currentValue']),
        currentSurahNumber: _asIntOrNull(json['currentSurahNumber']),
        currentAyahInSurah: _asIntOrNull(json['currentAyahInSurah']),
        isCompleted: json['isCompleted'] == true,
        completedAt: _asDateOrNull(json['completedAt']),
        progressPercent: _asInt(json['progressPercent']),
      );
}

// ─── Challenge ────────────────────────────────────────────────────────────

class Challenge {
  final String id;
  final String title;
  final String? description;
  final String categoryKey;
  final String categoryId;
  final String targetType; // "count" | "days"
  final int targetValue;
  final String unit;
  final bool isQuranChallenge;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final int participantCount;
  final bool isJoined;
  final ChallengeProgress? myProgress;

  const Challenge({
    required this.id,
    required this.title,
    this.description,
    required this.categoryKey,
    required this.categoryId,
    required this.targetType,
    required this.targetValue,
    required this.unit,
    required this.isQuranChallenge,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.participantCount,
    this.isJoined = false,
    this.myProgress,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) => Challenge(
        id: _idOf(json['_id'] ?? json['id']),
        title: (json['title'] ?? '').toString(),
        description: json['description']?.toString(),
        categoryKey: (json['categoryKey'] ?? '').toString(),
        categoryId: _idOf(json['categoryId']),
        targetType: (json['targetType'] ?? 'count').toString(),
        targetValue: _asInt(json['targetValue'], 1),
        unit: (json['unit'] ?? '').toString(),
        isQuranChallenge: json['isQuranChallenge'] == true,
        startDate: _asDateOrNull(json['startDate']) ?? DateTime.now(),
        endDate: _asDateOrNull(json['endDate']) ??
            DateTime.now().add(const Duration(days: 30)),
        isActive: json['isActive'] != false,
        participantCount: _asInt(json['participantCount']),
        isJoined: json['isJoined'] == true,
        myProgress: json['myProgress'] is Map
            ? ChallengeProgress.fromJson(
                Map<String, dynamic>.from(json['myProgress']))
            : null,
      );

  int get daysLeft {
    final d = endDate.difference(DateTime.now()).inHours / 24;
    return d.ceil().clamp(0, 1 << 30);
  }

  int get totalDays =>
      (endDate.difference(startDate).inHours / 24).ceil().clamp(1, 1 << 30);

  bool get hasEnded => DateTime.now().isAfter(endDate);
  bool get hasStarted => !DateTime.now().isBefore(startDate);
  bool get isJoinable => isActive && hasStarted && !hasEnded && !isJoined;
  bool get isCompleted => myProgress?.isCompleted ?? false;

  String get unitBn {
    switch (unit.toLowerCase()) {
      case 'rakaat':
        return 'রাকাত';
      case 'ayah':
        return 'আয়াত';
      case 'day':
        return 'দিন';
      case 'minute':
        return 'মিনিট';
      case 'time':
        return 'বার';
      default:
        return unit;
    }
  }
}

// ─── MyProgressDetail — GET /challenges/:id/my-progress ──────────────────

class MyProgressDetail {
  final Challenge challenge;
  final int currentValue;
  final int targetValue;
  final int progressPercent;
  final bool isCompleted;
  final DateTime? completedAt;
  final int? currentSurahNumber;
  final int? currentAyahInSurah;
  final int rank;
  final int daysLeft;
  final int totalDays;
  final int dailyNeeded;
  final int currentDailyAvg;
  final int remaining;

  const MyProgressDetail({
    required this.challenge,
    required this.currentValue,
    required this.targetValue,
    required this.progressPercent,
    required this.isCompleted,
    this.completedAt,
    this.currentSurahNumber,
    this.currentAyahInSurah,
    required this.rank,
    required this.daysLeft,
    required this.totalDays,
    required this.dailyNeeded,
    required this.currentDailyAvg,
    required this.remaining,
  });

  factory MyProgressDetail.fromJson(Map<String, dynamic> json) =>
      MyProgressDetail(
        challenge: Challenge.fromJson(
            Map<String, dynamic>.from(json['challenge'] ?? {})),
        currentValue: _asInt(json['currentValue']),
        targetValue: _asInt(json['targetValue'], 1),
        progressPercent: _asInt(json['progressPercent']),
        isCompleted: json['isCompleted'] == true,
        completedAt: _asDateOrNull(json['completedAt']),
        currentSurahNumber: _asIntOrNull(json['currentSurahNumber']),
        currentAyahInSurah: _asIntOrNull(json['currentAyahInSurah']),
        rank: _asInt(json['rank'], 1),
        daysLeft: _asInt(json['daysLeft']),
        totalDays: _asInt(json['totalDays'], 1),
        dailyNeeded: _asInt(json['dailyNeeded']),
        currentDailyAvg: _asInt(json['currentDailyAvg']),
        remaining: _asInt(json['remaining']),
      );
}

// ─── LeaderboardEntry — GET /challenges/:id/leaderboard rows ──────────────

class LeaderboardEntry {
  final String userId;
  final String name;
  final String? avatar;
  final String? district;
  final String? gender;
  final int currentValue;
  final int? currentSurahNumber;
  final int? currentAyahInSurah;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime? lastUpdatedAt;
  final int progressPercent;
  final int rank;

  const LeaderboardEntry({
    required this.userId,
    required this.name,
    this.avatar,
    this.district,
    this.gender,
    required this.currentValue,
    this.currentSurahNumber,
    this.currentAyahInSurah,
    required this.isCompleted,
    this.completedAt,
    this.lastUpdatedAt,
    required this.progressPercent,
    required this.rank,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    final user = json['user'] is Map
        ? Map<String, dynamic>.from(json['user'])
        : <String, dynamic>{};
    return LeaderboardEntry(
      userId: _idOf(json['userId']),
      name: (user['name'] ?? 'ব্যবহারকারী').toString(),
      avatar: user['avatar']?.toString(),
      district: user['district']?.toString(),
      gender: user['gender']?.toString(),
      currentValue: _asInt(json['currentValue']),
      currentSurahNumber: _asIntOrNull(json['currentSurahNumber']),
      currentAyahInSurah: _asIntOrNull(json['currentAyahInSurah']),
      isCompleted: json['isCompleted'] == true,
      completedAt: _asDateOrNull(json['completedAt']),
      lastUpdatedAt: _asDateOrNull(json['lastUpdatedAt']),
      progressPercent: _asInt(json['progressPercent']),
      rank: _asInt(json['rank'], 1),
    );
  }
}

class LeaderboardPage {
  final List<LeaderboardEntry> data;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const LeaderboardPage({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });
}
