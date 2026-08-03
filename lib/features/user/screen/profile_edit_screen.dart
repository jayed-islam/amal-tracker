import 'package:amal_tracker/features/user/widgets/app_silver_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import '../../auth/providers/auth_provider.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';

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
// SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;

  final _scrollController = ScrollController();

  bool _saving = false;
  bool _hasChanges = false;

  // GPS
  bool _isLocating = false;
  String? _district;
  String? _fullAddress;
  String? _originalDistrict;
  String? _districtErr;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);

    _nameCtrl = TextEditingController(text: user?.name ?? '');
    _phoneCtrl = TextEditingController(text: user?.phone ?? '');

    _district = user?.district;
    _originalDistrict = user?.district;

    _nameCtrl.addListener(_checkForChanges);
    _phoneCtrl.addListener(_checkForChanges);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    final user = ref.read(currentUserProvider);
    final hasNameChange = _nameCtrl.text != (user?.name ?? '');
    final hasPhoneChange = _phoneCtrl.text != (user?.phone ?? '');
    final hasDistrictChange = (_district ?? '') != (_originalDistrict ?? '');

    setState(() {
      _hasChanges = hasNameChange || hasPhoneChange || hasDistrictChange;
    });
  }

  // ── GPS ───────────────────────────────────────────────────────────────────

  Future<void> _pickLocation() async {
    if (_isLocating) return;
    setState(() => _isLocating = true);
    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        _toast('লোকেশন অনুমতি দিন', err: true);
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 12),
      );

      final marks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (marks.isEmpty) {
        _toast('লোকেশন পাওয়া যায়নি', err: true);
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
        p.country,
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
        if (district != null) {
          _district = district;
          _districtErr = null;
        }
      });
      _checkForChanges();
    } catch (_) {
      _toast('লোকেশন নিতে সমস্যা হয়েছে', err: true);
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
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

  // ── Save ──────────────────────────────────────────────────────────────────

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_district == null || _district!.isEmpty) {
      _showErrorSnackBar('GPS বাটন চেপে লোকেশন নির্ধারণ করুন');
      return;
    }
    if (!_hasChanges) {
      if (mounted) context.pop();
      return;
    }

    setState(() => _saving = true);
    HapticFeedback.mediumImpact();

    try {
      final Map<String, dynamic> updateData = {
        'name': _nameCtrl.text.trim(),
        if (_district != null && _district!.isNotEmpty) 'district': _district,
        if (_fullAddress != null) 'fullLocation': _fullAddress,
      };

      final phoneValue = _phoneCtrl.text.trim();
      if (phoneValue.isNotEmpty) {
        updateData['phone'] = phoneValue;
      }

      final success =
          await ref.read(authProvider.notifier).updateProfile(updateData);

      if (!mounted) return;

      if (success) {
        HapticFeedback.selectionClick();
        await ref.read(authProvider.notifier).refreshProfile();
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'প্রোফাইল সফলভাবে আপডেট হয়েছে',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: context.colors.darkGreen,
            margin: const EdgeInsets.all(16),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 2),
          ),
        );

        await Future.delayed(const Duration(milliseconds: 300));
      } else {
        if (mounted) _showErrorSnackBar('প্রোফাইল আপডেট করতে ব্যর্থ হয়েছে');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('একটি সমস্যা হয়েছে। আবার চেষ্টা করুন');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded,
                color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
        backgroundColor: context.colors.red,
        margin: const EdgeInsets.all(16),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final isFemale = user?.gender?.toLowerCase() == 'female';

    return Scaffold(
      backgroundColor: context.colors.bg,
      bottomNavigationBar: _SubmitBar(
        saving: _saving,
        onTap: _save,
        hasChanges: _hasChanges,
      ),
      body: CustomScrollView(
        controller: _scrollController,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const BouncingScrollPhysics(),
        slivers: [
          AppSliverBar(
            scrollController: _scrollController,
            title: 'প্রোফাইল সম্পাদনা',
            subtitle: 'নিরাপদ থাকতে নিয়মিত পরিবর্তন করুন',
            icon: Icons.lock_reset_rounded,
            color: context.colors.darkGreen,
            actions: [
              GestureDetector(
                onTap: (_saving || !_hasChanges) ? null : _save,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 14, 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: (_saving || !_hasChanges)
                        ? context.colors.gold.withOpacity(0.4)
                        : context.colors.gold,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : !_hasChanges
                          ? const Icon(Icons.check_rounded,
                              color: Colors.white70, size: 16)
                          : const Text(
                              'সেভ',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                ),
              ).animate().fadeIn(duration: 200.ms).slideX(begin: 0.2),
            ],
          ),
          SliverToBoxAdapter(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 14),
                  // ── Form fields ──────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _FormSection(
                          label: 'ব্যক্তিগত তথ্য',
                          children: [
                            _FieldItem(
                              label: 'পুরো নাম',
                              hint: 'আপনার নাম লিখুন',
                              controller: _nameCtrl,
                              icon: Icons.person_outline_rounded,
                              required: true,
                            ),
                            _GpsDistrictField(
                              district: _district,
                              error: _districtErr,
                              isLocating: _isLocating,
                              onTap: _pickLocation,
                              onClear: () {
                                setState(() {
                                  _district = null;
                                  _fullAddress = null;
                                  _districtErr =
                                      'GPS বাটন চেপে লোকেশন নির্ধারণ করুন';
                                });
                                _checkForChanges();
                              },
                            ),
                            _FieldItem(
                              label: 'ফোন নম্বর',
                              hint: '০১XXXXXXXXX',
                              controller: _phoneCtrl,
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              isPhoneField: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _FormSection(
                          label: 'স্থায়ী তথ্য (পরিবর্তনযোগ্য নয়)',
                          children: [
                            _ReadonlyField(
                              label: 'ইমেইল',
                              value: user?.email ?? '-',
                              icon: Icons.email_outlined,
                            ),
                            _ReadonlyField(
                              label: 'লিঙ্গ',
                              value: isFemale
                                  ? 'মহিলা 🌸'
                                  : user?.gender == 'male'
                                      ? 'পুরুষ'
                                      : user?.gender ?? '-',
                              icon: Icons.person_pin_outlined,
                            ),
                            if (user?.id != null)
                              _ReadonlyField(
                                label: 'সিরিয়াল আইডি',
                                value: '#${user!.id}',
                                icon: Icons.tag_rounded,
                              ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).padding.bottom + 32,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
    this.error,
    required this.isLocating,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasDist = district != null && district!.isNotEmpty;
    final hasErr = error != null && error!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: hasErr
                  ? context.colors.red.withOpacity(0.08)
                  : (isLocating || hasDist)
                      ? context.colors.greenLight
                      : context.colors.bg,
              borderRadius: BorderRadius.circular(9),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isLocating
                  ? Center(
                      child: SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          color: context.colors.darkGreen,
                        ),
                      ),
                    )
                  : Icon(
                      hasErr
                          ? Icons.error_rounded
                          : hasDist
                              ? Icons.gps_fixed_rounded
                              : Icons.my_location_rounded,
                      size: 17,
                      color: hasErr
                          ? context.colors.red
                          : (isLocating || hasDist)
                              ? context.colors.darkGreen
                              : context.colors.textHint,
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'জেলা',
                      style: TextStyle(
                        color: context.colors.textSecondary,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      ' *',
                      style: TextStyle(color: context.colors.red, fontSize: 10),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: isLocating ? null : onTap,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.colors.darkGreen.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    padding: const EdgeInsets.only(
                        top: 13, bottom: 13, left: 15, right: 9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            layoutBuilder: (currentChild, previousChildren) {
                              return Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  ...previousChildren,
                                  if (currentChild != null) currentChild,
                                ],
                              );
                            },
                            child: isLocating
                                ? Text(
                                    'লোকেশন খোঁজা হচ্ছে...',
                                    style: TextStyle(
                                      color: context.colors.darkGreen
                                          .withOpacity(0.7),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.left,
                                  )
                                : hasDist
                                    ? Text(
                                        district!,
                                        style: TextStyle(
                                          color: context.colors.textPrimary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    : Text(
                                        'GPS দিয়ে জেলা আপডেট করুন',
                                        style: TextStyle(
                                          color: context.colors.textHint,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                          ),
                        ),
                        if (!isLocating)
                          hasDist
                              ? GestureDetector(
                                  onTap: onClear,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: context.colors.darkGreen
                                          .withOpacity(0.10),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.refresh_rounded,
                                            size: 11,
                                            color: context.colors.darkGreen
                                                .withOpacity(0.75)),
                                        const SizedBox(width: 3),
                                        Text(
                                          'পরিবর্তন',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: context.colors.darkGreen
                                                .withOpacity(0.85),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: hasErr
                                        ? context.colors.red
                                        : context.colors.darkGreen,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'GPS',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                      ],
                    ),
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  child: hasErr
                      ? Padding(
                          padding: const EdgeInsets.only(left: 9),
                          child: Text(
                            error!,
                            style: TextStyle(
                              fontSize: 10,
                              color: context.colors.red,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FORM SECTION
// ─────────────────────────────────────────────────────────────────────────────

class _FormSection extends StatelessWidget {
  final String label;
  final List<Widget> children;

  const _FormSection({required this.label, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 8),
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              color: context.colors.textHint,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.7,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: context.colors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.colors.border, width: 0.5),
          ),
          child: Column(
            children: List.generate(children.length, (i) {
              return Column(
                children: [
                  children[i],
                  if (i < children.length - 1)
                    Divider(
                        height: 0.5,
                        thickness: 0.5,
                        color: context.colors.border,
                        indent: 52),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FIELD ITEM
// ─────────────────────────────────────────────────────────────────────────────

class _FieldItem extends StatefulWidget {
  final String label, hint;
  final TextEditingController controller;
  final IconData icon;
  final bool required;
  final TextInputType keyboardType;
  final bool isPhoneField;

  const _FieldItem({
    required this.label,
    required this.hint,
    required this.controller,
    required this.icon,
    this.required = false,
    this.keyboardType = TextInputType.text,
    this.isPhoneField = false,
  });

  @override
  State<_FieldItem> createState() => _FieldItemState();
}

class _FieldItemState extends State<_FieldItem> {
  bool _focused = false;
  String? _errorText;

  String? _validateBangladeshPhone(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    String cleaned = value.trim().replaceAll(RegExp(r'[\s\-+]'), '');
    if (!RegExp(r'^01[3-9]\d{8}$').hasMatch(cleaned)) {
      return 'বাংলাদেশের বৈধ ফোন নম্বর দিন (01XXXXXXXXX)';
    }
    return null;
  }

  String? _validateRequired(String? value) {
    if (widget.required && (value?.trim().isEmpty ?? true)) {
      return '${widget.label} আবশ্যক';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: _focused ? context.colors.greenLight : context.colors.bg,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(widget.icon,
                size: 17,
                color: _focused
                    ? context.colors.darkGreen
                    : context.colors.textHint),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.label,
                      style: TextStyle(
                        color: context.colors.textSecondary,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (widget.required)
                      Text(' *',
                          style: TextStyle(
                              color: context.colors.red, fontSize: 10)),
                    if (widget.isPhoneField)
                      Text(' (ঐচ্ছিক)',
                          style: TextStyle(
                              color: context.colors.textHint, fontSize: 9)),
                  ],
                ),
                Focus(
                  onFocusChange: (f) => setState(() => _focused = f),
                  child: TextFormField(
                    controller: widget.controller,
                    keyboardType: widget.keyboardType,
                    validator: widget.isPhoneField
                        ? (v) {
                            final err = _validateBangladeshPhone(v);
                            setState(() => _errorText = err);
                            return err;
                          }
                        : (v) {
                            final err = _validateRequired(v);
                            setState(() => _errorText = err);
                            return err;
                          },
                    onChanged: widget.isPhoneField
                        ? (v) => setState(
                            () => _errorText = _validateBangladeshPhone(v))
                        : null,
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding:
                          const EdgeInsets.only(top: 15, bottom: 15, left: 9),
                      border: InputBorder.none,
                      hintText: widget.hint,
                      hintStyle: TextStyle(
                        color: context.colors.textHint,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                      errorText: _errorText,
                      errorStyle:
                          TextStyle(fontSize: 10, color: context.colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// READONLY FIELD
// ─────────────────────────────────────────────────────────────────────────────

class _ReadonlyField extends StatelessWidget {
  final String label, value;
  final IconData icon;

  const _ReadonlyField({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: context.colors.bg,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 17, color: context.colors.textHint),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: context.colors.textHint,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: TextStyle(
                    color: context.colors.textSecondary,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: context.colors.bg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'লক',
              style: TextStyle(
                color: context.colors.textHint,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SAVE BUTTON
// ─────────────────────────────────────────────────────────────────────────────

class _SaveButton extends StatelessWidget {
  final bool saving;
  final VoidCallback onTap;
  final bool hasChanges;

  const _SaveButton({
    required this.saving,
    required this.onTap,
    required this.hasChanges,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = hasChanges && !saving;

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: 200.ms,
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: _getBackgroundColor(isEnabled, context),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isEnabled && !saving
              ? [
                  BoxShadow(
                    color: context.colors.darkGreen.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: AnimatedSwitcher(
          duration: 200.ms,
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: _buildButtonContent(isEnabled),
        ),
      ),
    );
  }

  Color _getBackgroundColor(bool isEnabled, BuildContext context) {
    if (saving) return context.colors.darkGreen.withOpacity(0.7);
    if (!isEnabled) return context.colors.darkGreen.withOpacity(0.4);
    return context.colors.darkGreen;
  }

  Widget _buildButtonContent(bool isEnabled) {
    if (saving) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
                color: Colors.white, strokeWidth: 2.5),
          ),
          SizedBox(width: 12),
          Text('সেভ হচ্ছে...',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15)),
        ],
      );
    }

    if (!isEnabled) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline_rounded,
              color: Colors.white.withOpacity(0.7), size: 18),
          const SizedBox(width: 8),
          Text('কোনো পরিবর্তন নেই',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w600,
                  fontSize: 14)),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.8, end: 1.0),
          duration: 300.ms,
          curve: Curves.elasticOut,
          builder: (context, scale, child) =>
              Transform.scale(scale: scale, child: child),
          child: const Icon(Icons.save_rounded, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 8),
        const Text('পরিবর্তন সেভ করুন',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
                letterSpacing: 0.3)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SUBMIT BAR
// ─────────────────────────────────────────────────────────────────────────────

class _SubmitBar extends StatelessWidget {
  final bool saving;
  final VoidCallback onTap;
  final bool hasChanges;
  const _SubmitBar(
      {required this.saving, required this.onTap, required this.hasChanges});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.card,
        border:
            Border(top: BorderSide(color: context.colors.border, width: 0.5)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      child: _SaveButton(saving: saving, onTap: onTap, hasChanges: hasChanges),
    );
  }
}
