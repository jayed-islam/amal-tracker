import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';

// ─── Feedback Category ─────────────────────────────────────────────────────
// Backend enum ("bug" | "suggestion" | "complaint" | "praise" | "other")
// এর সাথে হুবহু মিলিয়ে — UI তে দেখানোর label/icon/color সহ।

enum FeedbackCategory { bug, suggestion, complaint, praise, other }

extension FeedbackCategoryX on FeedbackCategory {
  String get apiValue => switch (this) {
        FeedbackCategory.bug => 'bug',
        FeedbackCategory.suggestion => 'suggestion',
        FeedbackCategory.complaint => 'complaint',
        FeedbackCategory.praise => 'praise',
        FeedbackCategory.other => 'other',
      };

  String get labelBn => switch (this) {
        FeedbackCategory.bug => 'সমস্যা',
        FeedbackCategory.suggestion => 'পরামর্শ',
        FeedbackCategory.complaint => 'অভিযোগ',
        FeedbackCategory.praise => 'প্রশংসা',
        FeedbackCategory.other => 'অন্যান্য',
      };

  IconData get icon => switch (this) {
        FeedbackCategory.bug => Icons.bug_report_rounded,
        FeedbackCategory.suggestion => Icons.lightbulb_rounded,
        FeedbackCategory.complaint => Icons.report_problem_rounded,
        FeedbackCategory.praise => Icons.favorite_rounded,
        FeedbackCategory.other => Icons.chat_bubble_rounded,
      };
}

// ─── Feedback State ─────────────────────────────────────────────────────────

class FeedbackState {
  final bool isSubmitting;
  final bool submitted;
  final String? error;

  const FeedbackState({
    this.isSubmitting = false,
    this.submitted = false,
    this.error,
  });

  FeedbackState copyWith({
    bool? isSubmitting,
    bool? submitted,
    String? error,
  }) =>
      FeedbackState(
        isSubmitting: isSubmitting ?? this.isSubmitting,
        submitted: submitted ?? this.submitted,
        error: error,
      );
}

// ─── Feedback Notifier ──────────────────────────────────────────────────────
// tracker_provider.dart এর DailyEntryNotifier এর মতোই দুই স্তরে error ধরা
// হয়: ApiException (expected — network/validation/cooldown message সরাসরি
// user-facing) আর একটা generic fallback (অপ্রত্যাশিত crash এড়াতে)।

class FeedbackNotifier extends StateNotifier<FeedbackState> {
  final ApiService _api;
  FeedbackNotifier(this._api) : super(const FeedbackState());

  Future<bool> submit({
    required String message,
    FeedbackCategory category = FeedbackCategory.other,
    int? rating,
  }) async {
    state = state.copyWith(isSubmitting: true, error: null);
    try {
      await _api.post<Map<String, dynamic>>('/feedback', data: {
        'message': message.trim(),
        'category': category.apiValue,
        if (rating != null) 'rating': rating,
      });
      state = state.copyWith(isSubmitting: false, submitted: true);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: 'পাঠাতে সমস্যা হয়েছে। আবার চেষ্টা করুন।',
      );
      return false;
    }
  }

  void clearError() => state = state.copyWith(error: null);

  // sheet প্রতিবার নতুন করে খোলার সময় fresh state দরকার (submitted flag
  // যেন আগের সাফল্যের রেশ ধরে না রাখে)
  void reset() => state = const FeedbackState();
}

final feedbackProvider =
    StateNotifierProvider.autoDispose<FeedbackNotifier, FeedbackState>(
  (ref) => FeedbackNotifier(ref.read(apiServiceProvider)),
);
