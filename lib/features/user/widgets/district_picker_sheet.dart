import 'package:flutter/material.dart';
import 'package:amal_tracker/core/constants/location_data.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';

class LocationSelectionResult {
  final String locationName;
  final double latitude;
  final double longitude;
  final bool isForeign;

  const LocationSelectionResult({
    required this.locationName,
    required this.latitude,
    required this.longitude,
    this.isForeign = false,
  });
}

class DistrictPickerSheet extends StatefulWidget {
  final String? initialSelection;

  const DistrictPickerSheet({super.key, this.initialSelection});

  static Future<LocationSelectionResult?> show(
    BuildContext context, {
    String? initialSelection,
  }) {
    return showModalBottomSheet<LocationSelectionResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DistrictPickerSheet(initialSelection: initialSelection),
    );
  }

  @override
  State<DistrictPickerSheet> createState() => _DistrictPickerSheetState();
}

class _DistrictPickerSheetState extends State<DistrictPickerSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchCtrl = TextEditingController();
  final _customCtrl = TextEditingController();

  String _searchQuery = '';
  int _selectedTab = 0;
  bool _showCustomInput = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedTab = _tabController.index;
          _showCustomInput = false;
        });
      }
    });

    _searchCtrl.addListener(() {
      setState(() {
        _searchQuery = _searchCtrl.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    _customCtrl.dispose();
    super.dispose();
  }

  void _selectLocation(LocationInfo loc) {
    Navigator.of(context).pop(LocationSelectionResult(
      locationName: loc.nameBn,
      latitude: loc.latitude,
      longitude: loc.longitude,
      isForeign: loc.isForeign,
    ));
  }

  void _submitCustomForeign() {
    final text = _customCtrl.text.trim();
    if (text.isEmpty) return;

    final coords = LocationData.getCoordinates(text);
    Navigator.of(context).pop(LocationSelectionResult(
      locationName: text,
      latitude: coords['latitude']!,
      longitude: coords['longitude']!,
      isForeign: true,
    ));
  }

  List<LocationInfo> get _filteredBdDistricts {
    if (_searchQuery.isEmpty) return LocationData.bdDistricts;
    return LocationData.bdDistricts.where((loc) {
      return loc.nameBn.toLowerCase().contains(_searchQuery) ||
          loc.nameEn.toLowerCase().contains(_searchQuery) ||
          (loc.divisionBn != null && loc.divisionBn!.toLowerCase().contains(_searchQuery));
    }).toList();
  }

  List<LocationInfo> get _filteredForeignLocations {
    if (_searchQuery.isEmpty) return LocationData.foreignLocations;
    return LocationData.foreignLocations.where((loc) {
      return loc.nameBn.toLowerCase().contains(_searchQuery) ||
          loc.nameEn.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height * 0.82;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: context.colors.cardBg,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Drag handle
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(Icons.location_city_rounded,
                    color: context.colors.darkGreen, size: 24),
                const SizedBox(width: 10),
                Text(
                  'লোকেশন নির্ধারণ করুন',
                  style: TextStyle(
                    color: context.colors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close_rounded,
                      color: context.colors.textSecondary),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Search Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'জেলা বা দেশের নাম দিয়ে খুঁজুন...',
                hintStyle: TextStyle(
                    color: context.colors.textHint, fontSize: 14),
                prefixIcon: Icon(Icons.search_rounded,
                    color: context.colors.textSecondary, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () => _searchCtrl.clear(),
                      )
                    : null,
                filled: true,
                fillColor: context.colors.surfaceAlt,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Tab Bar (BD Districts / Expat)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 44,
            decoration: BoxDecoration(
              color: context.colors.surfaceAlt,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: context.colors.darkGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: context.colors.textSecondary,
              labelStyle: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w700),
              unselectedLabelStyle: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600),
              tabs: const [
                Tab(text: 'বাংলাদেশ (৬৪ জেলা)'),
                Tab(text: 'প্রবাস (অন্যান্য দেশ)'),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // List content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // ── Tab 1: BD Districts ──────────────────────────────────
                _buildDistrictList(_filteredBdDistricts),

                // ── Tab 2: Foreign Locations ────────────────────────────
                _buildForeignSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistrictList(List<LocationInfo> list) {
    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off_rounded,
                  size: 44, color: context.colors.textHint),
              const SizedBox(height: 10),
              Text(
                'কোনো জেলা পাওয়া যায়নি',
                style: TextStyle(
                    color: context.colors.textSecondary, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: list.length,
      separatorBuilder: (_, __) => Divider(
          height: 1, thickness: 0.5, color: context.colors.border),
      itemBuilder: (ctx, idx) {
        final loc = list[idx];
        final isSelected = widget.initialSelection != null &&
            (widget.initialSelection == loc.nameBn ||
                widget.initialSelection == loc.nameEn);

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          title: Row(
            children: [
              Text(
                loc.nameBn,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected
                      ? context.colors.darkGreen
                      : context.colors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(${loc.nameEn})',
                style: TextStyle(
                  fontSize: 13,
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
          subtitle: loc.divisionBn != null
              ? Text(
                  'বিভাগ: ${loc.divisionBn}',
                  style: TextStyle(
                      fontSize: 11, color: context.colors.textHint),
                )
              : null,
          trailing: isSelected
              ? Icon(Icons.check_circle_rounded,
                  color: context.colors.darkGreen, size: 20)
              : Icon(Icons.chevron_right_rounded,
                  color: context.colors.textHint, size: 20),
          onTap: () => _selectLocation(loc),
        );
      },
    );
  }

  Widget _buildForeignSection() {
    final list = _filteredForeignLocations;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Option to enter custom foreign location
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: context.colors.surfaceAlt,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.colors.border),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: context.colors.darkGreen.withOpacity(0.12),
                    child: Icon(Icons.public_rounded,
                        color: context.colors.darkGreen, size: 20),
                  ),
                  title: const Text(
                    'অন্যান্য প্রবাস / শহর নাম লিখুন',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text(
                    'আপনার কাঙ্ক্ষিত শহর তালিকায় না থাকলে নিজে লিখুন',
                    style: TextStyle(fontSize: 11),
                  ),
                  trailing: Icon(
                    _showCustomInput
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.edit_note_rounded,
                    color: context.colors.darkGreen,
                  ),
                  onTap: () {
                    setState(() {
                      _showCustomInput = !_showCustomInput;
                    });
                  },
                ),
                if (_showCustomInput)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _customCtrl,
                            decoration: InputDecoration(
                              hintText: 'যেমন: টোকিও, জাপান বা মদিনা',
                              hintStyle: TextStyle(
                                  color: context.colors.textHint,
                                  fontSize: 13),
                              filled: true,
                              fillColor: context.colors.cardBg,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: context.colors.border),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _submitCustomForeign,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colors.darkGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('নিশ্চিত'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: Text(
              'জনপ্রিয় প্রবাসী শহরসমূহ',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: context.colors.textHint,
                letterSpacing: 0.5,
              ),
            ),
          ),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            separatorBuilder: (_, __) => Divider(
                height: 1, thickness: 0.5, color: context.colors.border),
            itemBuilder: (ctx, idx) {
              final loc = list[idx];
              final isSelected = widget.initialSelection != null &&
                  (widget.initialSelection == loc.nameBn ||
                      widget.initialSelection == loc.nameEn);

              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                title: Text(
                  loc.nameBn,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected
                        ? context.colors.darkGreen
                        : context.colors.textPrimary,
                  ),
                ),
                subtitle: Text(
                  loc.nameEn,
                  style: TextStyle(
                      fontSize: 12, color: context.colors.textSecondary),
                ),
                trailing: isSelected
                    ? Icon(Icons.check_circle_rounded,
                        color: context.colors.darkGreen, size: 20)
                    : Icon(Icons.chevron_right_rounded,
                        color: context.colors.textHint, size: 20),
                onTap: () => _selectLocation(loc),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LOCATION SELECTOR FIELD (Reusable Widget replacing old GPS field)
// ─────────────────────────────────────────────────────────────────────────────

class LocationSelectorField extends StatelessWidget {
  final String? district;
  final String? error;
  final ValueChanged<LocationSelectionResult> onLocationSelected;
  final VoidCallback? onClear;
  final String label;

  const LocationSelectorField({
    super.key,
    required this.district,
    this.error,
    required this.onLocationSelected,
    this.onClear,
    this.label = 'জেলা / লোকেশন',
  });

  @override
  Widget build(BuildContext context) {
    final hasDist = district != null && district!.isNotEmpty;
    final hasErr = error != null && error!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(children: [
          Text(label,
              style: TextStyle(
                color: hasErr ? context.colors.red : context.colors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              )),
          const SizedBox(width: 3),
          Text('*',
              style: TextStyle(
                  color: context.colors.red,
                  fontSize: 13,
                  fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 8),

        // Clickable Selector Tile
        GestureDetector(
          onTap: () async {
            final result = await DistrictPickerSheet.show(
              context,
              initialSelection: district,
            );
            if (result != null) {
              onLocationSelected(result);
            }
          },
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
            child: Row(
              children: [
                const SizedBox(width: 16),
                Icon(
                  hasDist
                      ? Icons.location_on_rounded
                      : Icons.location_city_rounded,
                  size: 20,
                  color: hasErr
                      ? context.colors.red
                      : hasDist
                          ? context.colors.darkGreen
                          : context.colors.textSecondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    hasDist ? district! : 'জেলা বা প্রবাস লোকেশন নির্বাচন করুন',
                    style: TextStyle(
                      color: hasDist
                          ? context.colors.textPrimary
                          : context.colors.textHint,
                      fontSize: 14,
                      fontWeight: hasDist ? FontWeight.w600 : FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: context.colors.darkGreen.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        hasDist ? 'পরিবর্তন' : 'বাছাই',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: context.colors.darkGreen,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(Icons.keyboard_arrow_down_rounded,
                          size: 16, color: context.colors.darkGreen),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        if (hasErr)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 6),
            child: Text(
              error!,
              style: TextStyle(fontSize: 11, color: context.colors.red),
            ),
          ),
      ],
    );
  }
}
