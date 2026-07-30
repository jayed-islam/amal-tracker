import 'package:amal_tracker/core/providers/connectivity_provider.dart';
import 'package:amal_tracker/shared/widgets/offline_banner.dart';
import 'package:amal_tracker/shared/widgets/offline_tasbih_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/cache_provider.dart';
import 'package:amal_tracker/core/theme/app_color_tokens.dart';

class MainShell extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;
  const MainShell({super.key, required this.navigationShell});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell>
    with WidgetsBindingObserver {
  StatefulNavigationShell get _shell => widget.navigationShell;
  DateTime? _lastBackPress;

  // GoRouter delegate listen করবো — route বদলালে rebuild হবে
  GoRouterDelegate? _delegate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_delegate == null) {
      _delegate = GoRouter.of(context).routerDelegate;
      _delegate!.addListener(_onRouteChanged);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _delegate?.removeListener(_onRouteChanged);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(cacheStatusProvider.notifier).checkTtlAndMarkDirty();
    }
  }

  void _onRouteChanged() {
    if (mounted) setState(() {});
  }

  void _onTabTap(int index) {
    ref.read(activeTabIndexProvider.notifier).state = index;
    _shell.goBranch(
      index,
      initialLocation: index == _shell.currentIndex,
    );
  }

  Future<void> _onPopInvoked(bool didPop) async {
    if (didPop) return;

    final router = GoRouter.of(context);

    // Case 1: stack এ page আছে → pop
    if (router.canPop()) {
      router.pop();
      return;
    }

    // Case 2: Home tab এ নেই → Home এ যাও
    if (_shell.currentIndex != 0) {
      _shell.goBranch(0, initialLocation: true);
      return;
    }

    // Case 3: Home root → double back to exit
    final now = DateTime.now();
    final isDoubleBack = _lastBackPress != null &&
        now.difference(_lastBackPress!) < const Duration(seconds: 2);

    if (isDoubleBack) {
      SystemNavigator.pop();
      return;
    }

    _lastBackPress = now;
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: const Text(
            'আবার back চাপলে অ্যাপ বন্ধ হবে',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
          backgroundColor: context.colors.avatar1,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    // Sync active index provider with the current shell tab index
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final currentActive = ref.read(activeTabIndexProvider);
        if (currentActive != _shell.currentIndex) {
          ref.read(activeTabIndexProvider.notifier).state = _shell.currentIndex;
        }
      }
    });

    ref.listen<bool>(isOnlineProvider, (previous, next) {
      if (previous == true && next == false) {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (_) => const OfflineTasbihSheet(),
        );
      }
      if (previous == false && next == true) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.wifi_rounded, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'সংযোগ পুনরুদ্ধার হয়েছে',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              backgroundColor: context.colors.green,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            ),
          );
      }
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) => _onPopInvoked(didPop),
      child: Scaffold(
        body: _shell,
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const OfflineBanner(),
            _BottomNav(
              activeIndex: _shell.currentIndex,
              onTap: _onTabTap,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bottom Navigation Bar ──────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int activeIndex;
  final void Function(int) onTap;

  const _BottomNav({required this.activeIndex, required this.onTap});

  static const _items = [
    _NavItem(icon: Icons.home_rounded, label: 'হোম'),
    _NavItem(icon: Icons.list_alt_rounded, label: 'ট্র্যাকার'),
    _NavItem(icon: Icons.flag_rounded, label: 'চ্যালেঞ্জ'),
    _NavItem(icon: Icons.bar_chart_rounded, label: 'রিপোর্ট'),
    _NavItem(icon: Icons.emoji_events_rounded, label: 'র‍্যাংকিং'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.card,
        border:
            Border(top: BorderSide(color: context.colors.border, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final active = index == activeIndex;
              return GestureDetector(
                onTap: () => onTap(index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color:
                        active ? context.colors.greenLight : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          item.icon,
                          key: ValueKey(active),
                          size: 22,
                          color: active
                              ? context.colors.avatar1
                              : context.colors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.label,
                        style: TextStyle(
                          color: active
                              ? context.colors.avatar1
                              : context.colors.textMuted,
                          fontSize: 9,
                          fontWeight:
                              active ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
