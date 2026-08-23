import 'package:amal_tracker/features/auth/providers/provider_reset.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../../../core/router/app_router.dart';
import 'package:amal_tracker/core/theme/app_colors.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';
import 'package:amal_tracker/core/constants/location_data.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DESIGN TOKENS
// ─────────────────────────────────────────────────────────────────────────────
// ─────────────────────────────────────────────────────────────────────────────
// DISTRICT MAPPING
// ─────────────────────────────────────────────────────────────────────────────

const Map<String, String> _englishToBangla = {
  'dhaka': 'ঢাকা',
  'chittagong': 'চট্টগ্রাম',
  'chattogram': 'চট্টগ্রাম',
  'rajshahi': 'রাজশাহী',
  'khulna': 'খুলনা',
  'barisal': 'বরিশাল',
  'barishal': 'বরিশাল',
  'sylhet': 'সিলেট',
  'rangpur': 'রংপুর',
  'mymensingh': 'ময়মনসিংহ',
  'faridpur': 'ফরিদপুর',
  'gazipur': 'গাজীপুর',
  'narayanganj': 'নারায়ণগঞ্জ',
  'comilla': 'কুমিল্লা',
  'cumilla': 'কুমিল্লা',
  'brahmanbaria': 'ব্রাহ্মণবাড়িয়া',
  'chandpur': 'চাঁদপুর',
  'lakshmipur': 'লক্ষ্মীপুর',
  'noakhali': 'নোয়াখালী',
  'feni': 'ফেনী',
  "cox's bazar": 'কক্সবাজার',
  'coxs bazar': 'কক্সবাজার',
  'cox bazar': 'কক্সবাজার',
  'bandarban': 'বান্দরবান',
  'rangamati': 'রাঙ্গামাটি',
  'khagrachhari': 'খাগড়াছড়ি',
  'moulvibazar': 'মৌলভীবাজার',
  'habiganj': 'হবিগঞ্জ',
  'sunamganj': 'সুনামগঞ্জ',
  'netrokona': 'নেত্রকোণা',
  'kishoreganj': 'কিশোরগঞ্জ',
  'manikganj': 'মানিকগঞ্জ',
  'munshiganj': 'মুন্সীগঞ্জ',
  'tangail': 'টাঙ্গাইল',
  'narsingdi': 'নরসিংদী',
  'shariatpur': 'শরীয়তপুর',
  'madaripur': 'মাদারীপুর',
  'gopalganj': 'গোপালগঞ্জ',
  'jhalokati': 'ঝালকাঠি',
  'pirojpur': 'পিরোজপুর',
  'barguna': 'বরগুনা',
  'patuakhali': 'পটুয়াখালী',
  'bhola': 'ভোলা',
  'natore': 'নাটোর',
  'pabna': 'পাবনা',
  'sirajganj': 'সিরাজগঞ্জ',
  'bogura': 'বগুড়া',
  'bogra': 'বগুড়া',
  'joypurhat': 'জয়পুরহাট',
  'chapainawabganj': 'চাঁপাইনবাবগঞ্জ',
  'naogaon': 'নওগাঁ',
  'dinajpur': 'দিনাজপুর',
  'lalmonirhat': 'লালমনিরহাট',
  'nilphamari': 'নীলফামারী',
  'panchagarh': 'পঞ্চগড়',
  'thakurgaon': 'ঠাকুরগাঁও',
  'kurigram': 'কুড়িগ্রাম',
  'gaibandha': 'গাইবান্ধা',
  'jashore': 'যশোর',
  'jessore': 'যশোর',
  'jhenaidah': 'ঝিনাইদহ',
  'magura': 'মাগুরা',
  'narail': 'নড়াইল',
  'bagerhat': 'বাগেরহাট',
  'satkhira': 'সাতক্ষীরা',
  'kushtia': 'কুষ্টিয়া',
  'meherpur': 'মেহেরপুর',
  'chuadanga': 'চুয়াডাঙ্গা',
};

String? _matchBangla(String candidate) {
  final n = candidate.toLowerCase().trim();
  if (n.isEmpty) return null;
  if (_englishToBangla.containsKey(n)) return _englishToBangla[n];
  for (final e in _englishToBangla.entries) {
    if (n.contains(e.key)) return e.value;
  }
  return null;
}

// ─────────────────────────────────────────────────────────────────────────────
// GENDER
// ─────────────────────────────────────────────────────────────────────────────

class _G {
  final String value, label;
  final IconData icon;
  const _G(this.value, this.label, this.icon);
}

const _genders = [
  _G('male', 'পুরুষ', Icons.man_rounded),
  _G('female', 'মহিলা', Icons.woman_rounded),
  _G('other', 'অন্যান্য', Icons.people_alt_rounded),
];

// ─────────────────────────────────────────────────────────────────────────────
// REGISTER SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});
  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _cfPassCtrl = TextEditingController();
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();
  final _cfPassFocus = FocusNode();
  final _scrollCtrl = ScrollController();

  bool _submitted = false;
  bool _isRegistering = false;
  bool _isLocating = false;

  // GPS
  String? _district; // value sent to backend (Bangla or raw foreign)
  String? _fullAddress; // stored internally, NOT shown to user
  double? _latitude;
  double? _longitude;

  String? _selectedGender;
  String? _nameErr, _emailErr, _passErr, _cfPassErr, _districtErr, _genderErr;

  // ── init ───────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    for (final n in [_nameFocus, _emailFocus, _passFocus, _cfPassFocus]) {
      n.addListener(() {
        if (n.hasFocus) _ensureVisible(n);
      });
    }
  }

  void _ensureVisible(FocusNode node) {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      final ctx = node.context;
      if (ctx == null) return;
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          alignment: 0.25);
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _cfPassCtrl.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    _cfPassFocus.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ── GPS LOCATION (Production Fail-Safe) ───────────────────────────────────

  Future<void> _pickLocation() async {
    if (_isLocating) return;
    setState(() => _isLocating = true);

    try {
      // 1. Check if Location Services (GPS toggle) are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        final shouldOpenSettings = await _showPermissionDialog(
          title: 'লোকেশন সার্ভিস বন্ধ আছে',
          message:
              'ফোনের GPS/Location ফিচারটি বন্ধ রয়েছে। অনুগ্রহ করে ডিভাইস সেটিংস থেকে লোকেশন চালু করুন।',
          buttonText: 'GPS সেটিংস খুলুন',
        );
        if (shouldOpenSettings == true) {
          await Geolocator.openLocationSettings();
        }
        return;
      }

      // 2. Check & Request Permissions
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }

      if (perm == LocationPermission.deniedForever) {
        if (!mounted) return;
        final shouldOpenAppSettings = await _showPermissionDialog(
          title: 'লোকেশন অনুমতি প্রয়োজন',
          message:
              'আপনার অবস্থানের সঠিক জেলা ও নামাজের সময় নির্ধারণের জন্য অ্যাপ সেটিংসে গিয়ে লোকেশন অনুমতি প্রদান করুন।',
          buttonText: 'অ্যাপ সেটিংস খুলুন',
        );
        if (shouldOpenAppSettings == true) {
          await Geolocator.openAppSettings();
        }
        return;
      }

      if (perm == LocationPermission.denied) {
        _toast('লোকেশন অনুমতি ছাড়া এলাকা নির্ধারণ সম্ভব নয়', err: true);
        return;
      }

      // 3. Multi-tier Position Retrieval (Fastest to Fallback)
      // Tier 1: Last Known Position (Instant < 100ms)
      Position? pos = await Geolocator.getLastKnownPosition();

      // Tier 2: Medium Accuracy (Fast fix via Cell/WiFi/GPS within 6 seconds)
      if (pos == null) {
        try {
          pos = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium,
            timeLimit: const Duration(seconds: 6),
          );
        } catch (_) {
          // Tier 3: Low Accuracy Fallback (Instant Cell Tower fix within 5 seconds)
          try {
            pos = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.low,
              timeLimit: const Duration(seconds: 5),
            );
          } catch (_) {
            pos = null;
          }
        }
      }

      if (pos == null) {
        _toast('ডিভাইসের লোকেশন পাওয়া যায়নি। কিছুক্ষণ পর আবার চেষ্টা করুন', err: true);
        return;
      }

      // 4. Reverse Geocoding
      List<Placemark> marks = [];
      try {
        marks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      } catch (_) {}

      if (marks.isEmpty) {
        _toast('স্থানাঙ্ক পাওয়া গেলেও ঠিকানা চেনা যায়নি', err: true);
        return;
      }

      final p = marks.first;
      final isBD = (p.country ?? '').toLowerCase().contains('bangladesh') ||
          (p.isoCountryCode ?? '').toUpperCase() == 'BD';

      final full = [
        p.street,
        p.subLocality,
        p.locality,
        p.subAdministrativeArea,
        p.administrativeArea,
        p.country
      ]
          .where((s) => s != null && s.trim().isNotEmpty)
          .map((s) => s!.trim())
          .join(', ');

      String? district;

      if (isBD) {
        for (final c in [
          p.subAdministrativeArea ?? '',
          p.locality ?? '',
          p.administrativeArea ?? '',
          p.subLocality ?? '',
          p.name ?? '',
        ]) {
          district = _matchBangla(c);
          if (district != null) break;
        }
        if (district == null) {
          _toast('জেলা চেনা যায়নি, আবার চেষ্টা করুন', err: true);
        }
      } else {
        district = p.subAdministrativeArea?.trim().isNotEmpty == true
            ? p.subAdministrativeArea!.trim()
            : p.locality?.trim().isNotEmpty == true
                ? p.locality!.trim()
                : p.administrativeArea?.trim();
        if (district != null) _toast('বিদেশি লোকেশন সেট হয়েছে');
      }

      setState(() {
        _fullAddress = full;
        _latitude = pos!.latitude;
        _longitude = pos.longitude;
        if (district != null) {
          _district = district;
          if (_submitted) _districtErr = null;
        }
      });

      if (district != null) {
        _toast('GPS দিয়ে $district নির্ধারিত হয়েছে');
      }
    } catch (_) {
      _toast('লোকেশন নির্ধারণে সমস্যা হয়েছে', err: true);
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  Future<bool?> _showPermissionDialog({
    required String title,
    required String message,
    required String buttonText,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.location_on_rounded, color: context.colors.darkGreen),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(fontSize: 13.5, color: context.colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'বাতিল',
              style: TextStyle(color: context.colors.textHint),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.darkGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              buttonText,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _toast(String msg, {bool err = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: err ? context.colors.red : context.colors.amber,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 3),
    ));
  }

  // ── validators ─────────────────────────────────────────────────────────────

  void _onNameChange(String v) {
    if (!_submitted) return;
    setState(() =>
        _nameErr = v.trim().length < 2 ? 'নাম কমপক্ষে ২ অক্ষর হতে হবে' : null);
  }

  void _onEmailChange(String v) {
    if (!_submitted) return;
    setState(() {
      _emailErr = v.trim().isEmpty
          ? 'ইমেইল দিন'
          : !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim())
              ? 'সঠিক ইমেইল ঠিকানা দিন'
              : null;
    });
  }

  void _onPassChange(String v) {
    if (!_submitted) return;
    setState(() {
      _passErr = v.isEmpty
          ? 'পাসওয়ার্ড দিন'
          : v.length < 6
              ? 'কমপক্ষে ৬ অক্ষর হতে হবে'
              : null;
      if (_cfPassCtrl.text.isNotEmpty) {
        _cfPassErr = _cfPassCtrl.text != v ? 'পাসওয়ার্ড মিলছে না' : null;
      }
    });
  }

  void _onCfPassChange(String v) {
    if (!_submitted) return;
    setState(
        () => _cfPassErr = v != _passCtrl.text ? 'পাসওয়ার্ড মিলছে না' : null);
  }

  void _onGenderSelected(String? g) {
    setState(() {
      _selectedGender = g;
      if (_submitted)
        _genderErr = (g == null || g.isEmpty) ? 'লিঙ্গ নির্বাচন করুন' : null;
    });
  }

  bool _validate() {
    setState(() {
      _submitted = true;
      final name = _nameCtrl.text.trim();
      final email = _emailCtrl.text.trim();
      final pass = _passCtrl.text;
      final cf = _cfPassCtrl.text;
      _nameErr = name.length < 2 ? 'নাম কমপক্ষে ২ অক্ষর হতে হবে' : null;
      _emailErr = email.isEmpty
          ? 'ইমেইল দিন'
          : !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)
              ? 'সঠিক ইমেইল ঠিকানা দিন'
              : null;
      _passErr = pass.isEmpty
          ? 'পাসওয়ার্ড দিন'
          : pass.length < 6
              ? 'কমপক্ষে ৬ অক্ষর হতে হবে'
              : null;
      _cfPassErr = cf != pass ? 'পাসওয়ার্ড মিলছে না' : null;
      _districtErr = (_district == null || _district!.isEmpty)
          ? 'জেলা বা লোকেশন নির্ধারণ করুন'
          : null;
      _genderErr = (_selectedGender == null || _selectedGender!.isEmpty)
          ? 'লিঙ্গ নির্বাচন করুন'
          : null;
    });
    return _nameErr == null &&
        _emailErr == null &&
        _passErr == null &&
        _cfPassErr == null &&
        _districtErr == null &&
        _genderErr == null;
  }

  // ── register ───────────────────────────────────────────────────────────────

  Future<void> _register() async {
    if (_isRegistering) return;
    if (!_validate()) return;

    setState(() => _isRegistering = true);
    ref.read(authProvider.notifier).clearError();

    final ok = await ref.read(authProvider.notifier).register(
          name: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
          district: _district!,
          fullLocation: _fullAddress,
          latitude: _latitude,
          longitude: _longitude,
          phone: null,
          photoUrl: null,
          gender: _selectedGender,
        );

    if (ok) invalidateUserProviders(ref);
    setState(() => _isRegistering = false);

    if (!mounted) return;

    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('নিবন্ধন সফল হয়েছে! ওটিপি কোড যাচাই করুন।'),
        backgroundColor: context.colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
      context.go(AppRoutes.verifyOtp);
    } else {
      setState(() => _isRegistering = false);
    }
  }

  // ── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final isLoading = _isRegistering;
    final size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: context.colors.pageBg,
        body: Stack(
          children: [
            // Header gradient
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: size.height * 0.35,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [context.colors.darkGreen, context.colors.midGreen],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Stack(children: [
                  Positioned(
                      top: -40,
                      right: -40,
                      child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.05)))),
                  Positioned(
                      bottom: -30,
                      left: -30,
                      child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context.colors.gold.withOpacity(0.08)))),
                ]),
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                controller: _scrollCtrl,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // Hero
                    Column(children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.25)),
                        ),
                        child: const Icon(Icons.person_add_rounded,
                            color: Colors.white, size: 35),
                      ).animate().scale(
                          duration: 500.ms,
                          curve: Curves.elasticOut,
                          begin: const Offset(0.5, 0.5)),
                      const SizedBox(height: 20),
                      const Text('নতুন অ্যাকাউন্ট',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5))
                          .animate(delay: 100.ms)
                          .fadeIn()
                          .slideY(begin: -0.1),
                      const SizedBox(height: 6),
                      Text('নিবন্ধন করে শুরু করুন',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.75),
                                  fontSize: 14))
                          .animate(delay: 150.ms)
                          .fadeIn(),
                    ]),

                    const SizedBox(height: 32),

                    // Form card
                    IgnorePointer(
                      ignoring: isLoading,
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.colors.cardBg,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 8))
                          ],
                        ),
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(children: [
                              if (auth.error != null) ...[
                                _ErrorBanner(auth.error!),
                                const SizedBox(height: 20),
                              ],

                              // Name
                              _Field(
                                label: 'পূর্ণ নাম',
                                icon: Icons.person_outline_rounded,
                                controller: _nameCtrl,
                                focusNode: _nameFocus,
                                hint: 'আপনার পূর্ণ নাম লিখুন',
                                error: _nameErr,
                                onChanged: _onNameChange,
                                onSubmit: () => _emailFocus.requestFocus(),
                              )
                                  .animate(delay: 200.ms)
                                  .fadeIn()
                                  .slideY(begin: 0.05),

                              const SizedBox(height: 18),

                              // Email
                              _Field(
                                label: 'ইমেইল ঠিকানা',
                                icon: Icons.alternate_email_rounded,
                                controller: _emailCtrl,
                                focusNode: _emailFocus,
                                hint: 'example@email.com',
                                keyboardType: TextInputType.emailAddress,
                                error: _emailErr,
                                onChanged: _onEmailChange,
                                onSubmit: () =>
                                    FocusScope.of(context).unfocus(),
                              )
                                  .animate(delay: 250.ms)
                                  .fadeIn()
                                  .slideY(begin: 0.05),

                              const SizedBox(height: 18),

                              // Location field with GPS auto-detection
                              _GpsDistrictField(
                                district: _district,
                                error: _districtErr,
                                isLocating: _isLocating,
                                onTap: _pickLocation,
                                onClear: () => setState(() {
                                  _district = null;
                                  _fullAddress = null;
                                  _latitude = null;
                                  _longitude = null;
                                  if (_submitted) {
                                    _districtErr =
                                        'GPS বাটন চেপে জেলা নির্ধারণ করুন';
                                  }
                                }),
                              )
                                  .animate(delay: 280.ms)
                                  .fadeIn()
                                  .slideY(begin: 0.05),

                              const SizedBox(height: 18),

                              // Gender
                              _GenderSelector(
                                selected: _selectedGender,
                                error: _genderErr,
                                onSelected: _onGenderSelected,
                              )
                                  .animate(delay: 300.ms)
                                  .fadeIn()
                                  .slideY(begin: 0.05),

                              const SizedBox(height: 18),

                              // Password
                              _PasswordField(
                                label: 'পাসওয়ার্ড',
                                controller: _passCtrl,
                                focusNode: _passFocus,
                                hint: 'কমপক্ষে ৬ অক্ষর',
                                error: _passErr,
                                onChanged: _onPassChange,
                                onSubmit: () => _cfPassFocus.requestFocus(),
                                showStrengthBar: true,
                              )
                                  .animate(delay: 310.ms)
                                  .fadeIn()
                                  .slideY(begin: 0.05),

                              const SizedBox(height: 18),

                              // Confirm password
                              _PasswordField(
                                label: 'পাসওয়ার্ড নিশ্চিত করুন',
                                controller: _cfPassCtrl,
                                focusNode: _cfPassFocus,
                                hint: 'পাসওয়ার্ড আবার লিখুন',
                                error: _cfPassErr,
                                onChanged: _onCfPassChange,
                                onSubmit: _register,
                                textInputAction: TextInputAction.done,
                              )
                                  .animate(delay: 350.ms)
                                  .fadeIn()
                                  .slideY(begin: 0.05),
                            ]),
                          ),

                          // Register button
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                            child: _PrimaryButton(
                              label: isLoading
                                  ? 'নিবন্ধন হচ্ছে...'
                                  : 'নিবন্ধন করুন',
                              icon:
                                  isLoading ? null : Icons.check_circle_rounded,
                              onTap: isLoading ? null : _register,
                              isLoading: isLoading,
                            )
                                .animate(delay: 400.ms)
                                .fadeIn()
                                .slideY(begin: 0.05),
                          ),
                        ]),
                      ),
                    ).animate(delay: 180.ms).fadeIn().slideY(begin: 0.1),

                    const SizedBox(height: 24),

                    // Login link
                    GestureDetector(
                      onTap:
                          isLoading ? null : () => context.go(AppRoutes.login),
                      child: Opacity(
                        opacity: isLoading ? 0.4 : 1.0,
                        child: RichText(
                            text: TextSpan(
                          text: 'ইতিমধ্যে অ্যাকাউন্ট আছে?  ',
                          style:
                              TextStyle(color: context.colors.textSecondary, fontSize: 14),
                          children: [
                            TextSpan(
                                text: 'লগইন করুন',
                                style: TextStyle(
                                    color: context.colors.darkGreen,
                                    fontWeight: FontWeight.w700))
                          ],
                        )),
                      ),
                    ).animate(delay: 450.ms).fadeIn(),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GPS DISTRICT FIELD
// ─────────────────────────────────────────────────────────────────────────────

class _GpsDistrictField extends StatelessWidget {
  final String? district;
  final String? error;
  final bool isLocating;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _GpsDistrictField({
    required this.district,
    required this.error,
    required this.isLocating,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasErr = error != null && error!.isNotEmpty;
    final hasDist = district != null && district!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(children: [
          Text('লোকেশন',
              style: TextStyle(
                color: hasErr ? context.colors.red : context.colors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              )),
          const SizedBox(width: 3),
          Text('*',
              style: TextStyle(
                  color: context.colors.red, fontSize: 13, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 8),

        // Tap tile
        GestureDetector(
          onTap: isLocating ? null : onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            height: 54,
            decoration: BoxDecoration(
              color: hasErr
                  ? context.colors.red.withOpacity(0.04)
                  : hasDist
                      ? context.colors.greenLight
                      : context.colors.surfaceAlt,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: hasErr
                    ? context.colors.red.withOpacity(0.6)
                    : hasDist
                        ? context.colors.darkGreen
                        : context.colors.border,
                width: hasDist ? 1.5 : 1.0,
              ),
              boxShadow: hasDist && !hasErr
                  ? [
                      BoxShadow(
                          color: context.colors.darkGreen.withOpacity(0.10),
                          blurRadius: 10,
                          offset: const Offset(0, 3))
                    ]
                  : [],
            ),
            child: Row(children: [
              const SizedBox(width: 16),

              // Left icon / spinner
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: isLocating
                    ? SizedBox(
                        key: const ValueKey('spin'),
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.2, color: context.colors.darkGreen))
                    : Icon(
                        key: ValueKey(hasDist),
                        hasDist
                            ? Icons.gps_fixed_rounded
                            : Icons.my_location_rounded,
                        size: 20,
                        color: hasErr
                            ? context.colors.red
                            : hasDist
                                ? context.colors.darkGreen
                                : context.colors.textSecondary),
              ),

              const SizedBox(width: 12),

              // Text
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: isLocating
                      ? SizedBox(
                          key: const ValueKey('locating'),
                          width: double.infinity,
                          child: Text('লোকেশন খোঁজা হচ্ছে...',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: context.colors.darkGreen.withOpacity(0.7),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)))
                      : hasDist
                          ? SizedBox(
                              key: const ValueKey('dist'),
                              width: double.infinity,
                              child: Text(district!,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: context.colors.darkGreen,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)))
                          : SizedBox(
                              key: const ValueKey('hint'),
                              width: double.infinity,
                              child: Text('GPS দিয়ে জেলা নির্ধারণ করুন',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: hasErr
                                          ? context.colors.red.withOpacity(0.8)
                                          : context.colors.textHint,
                                      fontSize: 14))),
                ),
              ),

              // Right action
              if (!isLocating)
                hasDist
                    ? GestureDetector(
                        onTap: onClear,
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: context.colors.darkGreen.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              Icon(Icons.refresh_rounded,
                                  size: 12,
                                  color: context.colors.darkGreen.withOpacity(0.75)),
                              const SizedBox(width: 4),
                              Text('পরিবর্তন',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: context.colors.darkGreen.withOpacity(0.85))),
                            ]),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(right: 14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: hasErr ? context.colors.red : context.colors.darkGreen,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('GPS',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5)),
                        ),
                      )
              else
                const SizedBox(width: 14),
            ]),
          ),
        ),

        // Sub-hint / error
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: hasErr
              ? Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Row(children: [
                    Icon(Icons.error_rounded, size: 13, color: context.colors.red),
                    const SizedBox(width: 6),
                    Expanded(
                        child: Text(error!,
                            style: TextStyle(
                                color: context.colors.red,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500))),
                  ]),
                )
              : hasDist
                  ? Padding(
                      padding: const EdgeInsets.only(top: 6, left: 4),
                      child: Row(children: [
                        Icon(Icons.gps_fixed_rounded,
                            size: 11, color: context.colors.green),
                        const SizedBox(width: 5),
                        Text('GPS থেকে নির্ধারিত — পরিবর্তন করতে ↺ চাপুন',
                            style: TextStyle(
                                color: context.colors.green,
                                fontSize: 11,
                                fontWeight: FontWeight.w500)),
                      ]),
                    )
                  : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GENDER SELECTOR
// ─────────────────────────────────────────────────────────────────────────────

class _GenderSelector extends StatelessWidget {
  final String? selected;
  final String? error;
  final void Function(String?) onSelected;
  const _GenderSelector(
      {required this.selected, required this.error, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final hasErr = error != null && error!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('লিঙ্গ',
            style: TextStyle(
                color: hasErr ? context.colors.red : context.colors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13)),
        const SizedBox(height: 8),
        Row(
            children: List.generate(_genders.length, (i) {
          final opt = _genders[i];
          final sel = selected == opt.value;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i < _genders.length - 1 ? 8 : 0),
              child: GestureDetector(
                onTap: () => onSelected(sel ? null : opt.value),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 54,
                  decoration: BoxDecoration(
                    color: sel
                        ? context.colors.greenLight
                        : hasErr
                            ? context.colors.red.withOpacity(0.04)
                            : context.colors.surfaceAlt,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: sel
                          ? context.colors.darkGreen
                          : hasErr
                              ? context.colors.red.withOpacity(0.5)
                              : context.colors.border,
                      width: sel ? 1.5 : 1.0,
                    ),
                    boxShadow: sel
                        ? [
                            BoxShadow(
                                color: context.colors.darkGreen.withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 3))
                          ]
                        : [],
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(opt.icon,
                            size: 20,
                            color: sel
                                ? context.colors.darkGreen
                                : hasErr
                                    ? context.colors.red
                                    : context.colors.textSecondary),
                        const SizedBox(height: 3),
                        Text(opt.label,
                            style: TextStyle(
                                fontSize: 11.5,
                                fontWeight:
                                    sel ? FontWeight.w700 : FontWeight.w500,
                                color: sel
                                    ? context.colors.darkGreen
                                    : hasErr
                                        ? context.colors.red
                                        : context.colors.textSecondary)),
                      ]),
                ),
              ),
            ),
          );
        })),
        AnimatedSize(
          duration: const Duration(milliseconds: 180),
          child: hasErr
              ? Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Row(children: [
                    Icon(Icons.error_rounded, size: 13, color: context.colors.red),
                    const SizedBox(width: 6),
                    Text(error!,
                        style: TextStyle(
                            color: context.colors.red,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500)),
                  ]))
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}



// ─────────────────────────────────────────────────────────────────────────────
// TEXT FIELD
// ─────────────────────────────────────────────────────────────────────────────

class _Field extends StatefulWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final String? error;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final void Function(String)? onChanged;
  final VoidCallback onSubmit;

  const _Field({
    required this.label,
    required this.icon,
    required this.controller,
    required this.focusNode,
    required this.hint,
    this.error,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    required this.onSubmit,
  });
  @override
  State<_Field> createState() => _FieldState();
}

class _FieldState extends State<_Field> {
  bool _focused = false;
  late final VoidCallback _fl;
  @override
  void initState() {
    super.initState();
    _fl = () {
      if (mounted) setState(() => _focused = widget.focusNode.hasFocus);
    };
    widget.focusNode.addListener(_fl);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_fl);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasErr = widget.error != null && widget.error!.isNotEmpty;
    final ic = hasErr
        ? context.colors.red
        : _focused
            ? context.colors.darkGreen
            : context.colors.textSecondary;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(widget.label,
          style: TextStyle(
              color: hasErr
                  ? context.colors.red
                  : _focused
                      ? context.colors.darkGreen
                      : context.colors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13)),
      const SizedBox(height: 8),
      AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: _focused && !hasErr
              ? [
                  BoxShadow(
                      color: context.colors.darkGreen.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ]
              : [],
        ),
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          onEditingComplete: widget.onSubmit,
          onSubmitted: (_) => widget.onSubmit(),
          style: TextStyle(
              color: context.colors.textPrimary, fontWeight: FontWeight.w500, fontSize: 15),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(color: context.colors.textHint, fontSize: 14),
            prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(widget.icon, size: 20, color: ic)),
            prefixIconConstraints: const BoxConstraints(minWidth: 54),
            filled: true,
            fillColor: hasErr
                ? context.colors.red.withOpacity(0.04)
                : _focused
                    ? context.colors.cardBg
                    : context.colors.surfaceAlt,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: context.colors.border)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                    color: hasErr ? context.colors.red.withOpacity(0.5) : context.colors.border)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                    color: hasErr ? context.colors.red : context.colors.darkGreen, width: 1.5)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ),
      AnimatedSize(
        duration: const Duration(milliseconds: 180),
        child: hasErr
            ? Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Row(children: [
                  Icon(Icons.error_rounded, size: 13, color: context.colors.red),
                  const SizedBox(width: 6),
                  Text(widget.error!,
                      style: TextStyle(
                          color: context.colors.red,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500)),
                ]))
            : const SizedBox.shrink(),
      ),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PASSWORD FIELD
// ─────────────────────────────────────────────────────────────────────────────

class _PasswordField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final String? error;
  final TextInputAction textInputAction;
  final void Function(String) onChanged;
  final VoidCallback onSubmit;
  final bool showStrengthBar;

  const _PasswordField({
    required this.label,
    required this.controller,
    required this.focusNode,
    required this.hint,
    this.error,
    this.textInputAction = TextInputAction.next,
    required this.onChanged,
    required this.onSubmit,
    this.showStrengthBar = false,
  });
  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _focused = false, _obscure = true;
  late final VoidCallback _fl;
  @override
  void initState() {
    super.initState();
    _fl = () {
      if (mounted) setState(() => _focused = widget.focusNode.hasFocus);
    };
    widget.focusNode.addListener(_fl);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_fl);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasErr = widget.error != null && widget.error!.isNotEmpty;
    final ic = hasErr
        ? context.colors.red
        : _focused
            ? context.colors.darkGreen
            : context.colors.textSecondary;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(widget.label,
          style: TextStyle(
              color: hasErr
                  ? context.colors.red
                  : _focused
                      ? context.colors.darkGreen
                      : context.colors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13)),
      const SizedBox(height: 8),
      AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: _focused && !hasErr
              ? [
                  BoxShadow(
                      color: context.colors.darkGreen.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ]
              : [],
        ),
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          obscureText: _obscure,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          onEditingComplete: widget.onSubmit,
          onSubmitted: (_) => widget.onSubmit(),
          style: TextStyle(
              color: context.colors.textPrimary, fontWeight: FontWeight.w500, fontSize: 15),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(color: context.colors.textHint, fontSize: 14),
            prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.lock_outline_rounded, size: 20, color: ic)),
            prefixIconConstraints: const BoxConstraints(minWidth: 54),
            suffixIcon: GestureDetector(
              onTap: () => setState(() => _obscure = !_obscure),
              child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(
                      _obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                      color: _focused ? context.colors.darkGreen : context.colors.textSecondary)),
            ),
            suffixIconConstraints: const BoxConstraints(minWidth: 50),
            filled: true,
            fillColor: hasErr
                ? context.colors.red.withOpacity(0.04)
                : _focused
                    ? context.colors.cardBg
                    : context.colors.surfaceAlt,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: context.colors.border)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                    color: hasErr ? context.colors.red.withOpacity(0.5) : context.colors.border)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                    color: hasErr ? context.colors.red : context.colors.darkGreen, width: 1.5)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ),
      AnimatedSize(
        duration: const Duration(milliseconds: 180),
        child: hasErr
            ? Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Row(children: [
                  Icon(Icons.error_rounded, size: 13, color: context.colors.red),
                  const SizedBox(width: 6),
                  Text(widget.error!,
                      style: TextStyle(
                          color: context.colors.red,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500)),
                ]))
            : const SizedBox.shrink(),
      ),
      if (widget.showStrengthBar && widget.controller.text.isNotEmpty) ...[
        const SizedBox(height: 10),
        _StrengthBar(password: widget.controller.text),
      ],
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STRENGTH BAR
// ─────────────────────────────────────────────────────────────────────────────

class _StrengthBar extends StatelessWidget {
  final String password;
  const _StrengthBar({required this.password});
  int get _score {
    int s = 0;
    if (password.length >= 6) s++;
    if (password.length >= 10) s++;
    if (password.contains(RegExp(r'[A-Z]'))) s++;
    if (password.contains(RegExp(r'[0-9]'))) s++;
    if (password.contains(RegExp(r'[^A-Za-z0-9]'))) s++;
    return s;
  }

  @override
  Widget build(BuildContext context) {
    final s = _score;
    final color = s <= 1
        ? context.colors.red
        : s <= 3
            ? context.colors.amber
            : context.colors.green;
    final label = s <= 1
        ? 'দুর্বল'
        : s <= 3
            ? 'মাঝারি'
            : 'শক্তিশালী';
    return Row(children: [
      Expanded(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                  value: s / 5,
                  minHeight: 4,
                  backgroundColor: context.colors.border,
                  valueColor: AlwaysStoppedAnimation(color)))),
      const SizedBox(width: 12),
      Text(label,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w700, color: color)),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ERROR BANNER
// ─────────────────────────────────────────────────────────────────────────────

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner(this.message);
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
            color: context.colors.redLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.colors.red.withOpacity(0.25))),
        child: Row(children: [
          Icon(Icons.error_outline_rounded, color: context.colors.red, size: 18),
          const SizedBox(width: 10),
          Expanded(
              child: Text(message,
                  style: TextStyle(
                      color: context.colors.red,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500))),
        ]),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// PRIMARY BUTTON
// ─────────────────────────────────────────────────────────────────────────────

class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isLoading;
  const _PrimaryButton(
      {required this.label, this.icon, this.onTap, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null && !isLoading;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      height: 54,
      width: double.infinity,
      decoration: BoxDecoration(
        color: enabled ? context.colors.darkGreen : context.colors.borderMid,
        borderRadius: BorderRadius.circular(16),
        boxShadow: enabled
            ? [
                BoxShadow(
                    color: context.colors.darkGreen.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6))
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.5, color: Colors.white))
                  : Row(mainAxisSize: MainAxisSize.min, children: [
                      if (icon != null) ...[
                        Icon(icon, color: Colors.white, size: 20),
                        const SizedBox(width: 10)
                      ],
                      Text(label,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              letterSpacing: -0.2)),
                    ])),
        ),
      ),
    );
  }
}
