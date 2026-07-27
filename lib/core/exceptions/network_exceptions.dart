import 'package:amal_tracker/core/services/api_service.dart'; // adjust path

class NetworkException extends ApiException {
  const NetworkException({
    super.message = 'ইন্টারনেট সংযোগ নেই। পরে আবার চেষ্টা করুন।',
    super.statusCode = 0,
  });

  // Convenience: check if any ApiException is network-related.
  static bool isNetPwork(Object e) => e is NetworkException;
}
