// app_sliver_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppSliverBar extends StatefulWidget {
  final ScrollController scrollController;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final double expandedHeight;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  const AppSliverBar({
    super.key,
    required this.scrollController,
    required this.title,
    required this.subtitle,
    this.icon = Icons.lock_reset_rounded,
    required this.color,
    this.expandedHeight = 120,
    this.onBack,
    this.actions,
  });

  @override
  State<AppSliverBar> createState() => _AppSliverBarState();
}

class _AppSliverBarState extends State<AppSliverBar> {
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final collapsed = widget.scrollController.offset >
        (widget.expandedHeight - kToolbarHeight);
    if (collapsed != _isCollapsed) {
      setState(() => _isCollapsed = collapsed);
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasActions = widget.actions != null && widget.actions!.isNotEmpty;

    return SliverAppBar(
      pinned: true,
      //  সবসময় color থাকে — transparent করলে bg দেখা যায়
      backgroundColor: widget.color,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      expandedHeight: widget.expandedHeight,

      //  Collapse হলে title fade in হয়
      title: AnimatedOpacity(
        opacity: _isCollapsed ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
      ),

      leading: GestureDetector(
        onTap: widget.onBack ?? () => Navigator.of(context).pop(),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),

      //  Right side actions — যেকোনো widget পাঠানো যাবে
      actions: widget.actions != null
          ? [
              ...widget.actions!.map(
                (action) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: action,
                ),
              ),
            ]
          : null,

      //  flexibleSpace সবসময় থাকে — null করলে title আসে না
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Container(
          color: widget.color,
          child: Stack(
            children: [
              Positioned(
                top: -24,
                right: -24,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.04),
                  ),
                ),
              ),
              Positioned(
                bottom: 30,
                right: 36,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.04),
                  ),
                ),
              ),
              if (!hasActions)
                Positioned(
                  top: 44,
                  right: 20,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(widget.icon, color: Colors.white60, size: 20),
                  ),
                ),
              Positioned(
                bottom: 16,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.4,
                      ),
                    ),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
